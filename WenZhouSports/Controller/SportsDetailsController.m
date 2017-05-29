//
//  SportsDetailsController.m
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/10.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "SportsDetailsController.h"
#import "SportsDetailView.h"
#import "NSNumber+SetScale.h"
#import "SportsDetailViewModel.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>
#import "MAMutablePolyline.h"
#import "MAMutablePolylineRenderer.h"

@interface SportsDetailsController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, AMapLocationManagerDelegate, MAMapViewDelegate>

@property (nonatomic, strong) SportsDetailView *detailView;

@property (nonatomic, strong) CMPedometer *pedometer;
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) CMMotionActivityManager *motionActivityManager;
@property (nonatomic, strong) CMAltimeter *altimeter;
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) FMDatabase *db;

@property (nonatomic, strong) SportsDetailViewModel *viewModel;

@property (nonatomic, strong) RACSubject *sportsDataSignal;

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic) MAMapPoint lastPoint;
@property (nonatomic) CLLocationDistance mapDistance;

//运动轨迹相关
@property (nonatomic, strong) NSMutableArray *locationsArray;
@property (nonatomic, strong) MAMutablePolyline *line;
@property (nonatomic, strong) MAMutablePolylineRenderer *render;
@property (nonatomic, assign) BOOL isRecording; //是否正在绘制
@property (nonatomic, strong) CLLocation *lastLocatioin;

@property (nonatomic, assign) BOOL isPause;

@end 

@implementation SportsDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
    [self reactiveEvent];
    _pedometer = [[CMPedometer alloc] init];
#warning TODO: 这个内存泄露，下面的@autoreleasepool可能就是要解决这个问题
    _motionManager = [[CMMotionManager alloc] init];
    _motionActivityManager = [[CMMotionActivityManager alloc] init];
    
    NSString *path = [NSString stringWithFormat:@"%@/Documents/user.sqlite", NSHomeDirectory()];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        
    }];
    _locationManager = [[AMapLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = 0;// 中心显示范围0
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;// 精确度
    _mapDistance = 0;
    _lastPoint = MAMapPointMake(0.0, 0.0);
    
    _viewModel = [[SportsDetailViewModel alloc] init];
}

- (void)initSubviews {
    _detailView = [[SportsDetailView alloc] initWithFrame:CGRectMake(0.0, 64.0, WIDTH, HEIGHT - 64.0)];
    [_detailView setDelete:self];
    _line = [[MAMutablePolyline alloc] initWithPoints:@[]];
    [_detailView.mapView addOverlay:_line];

    [self.view addSubview:_detailView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    [self free];
    self.detailView = nil;
}

- (void)reactiveEvent {
    _sportsDataSignal = [[RACSubject alloc] init];
    __block CGFloat distance = 0;
    __block NSInteger steps = 0;
    __block BOOL isPause = NO;
    __block int pauseTime = 0;
    __block int cyclingCount = 0;
    __block int time = 0;
    //暂停的时间
    __block NSDate *pauseDate = nil;
    //开始暂停时的距离
    __block CGFloat startPauseDistance = 0;
    //暂停时移动的距离
    __block CGFloat pauseDistance = 0;
    //暂停时总的移动距离
    __block CGFloat allPauseDistance = 0;
    @weakify(self);
    //运动开始点击事件
    [self.detailView.startSignal subscribeNext:^(id x) {
        @strongify(self)
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            @strongify(self)
            [[self.viewModel.compareFaceCommand execute:nil] subscribeNext:^(id  _Nullable x) {
                
            }];
        });
        [self.detailView setDataWithSpeed:@"0.0" distance:0 stage:10];
        [self.detailView addPauseGestureEvent];
        NSDate *nowDate = [NSDate date];
        [self.detailView changeSportsStation:SportsDidStart];
        @autoreleasepool {
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
            //定时器，每秒触发
            dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
            dispatch_source_set_event_handler(_timer, ^{
                //点击开始后开始计时
                time = -[nowDate timeIntervalSinceNow];
//              NSLog(@"时间：%d", time);
                [_sportsDataSignal subscribeNext:^(CMPedometerData *x) {
                    distance = x.distance.floatValue;
                    steps = x.numberOfSteps.integerValue;
                    DDLogInfo(@"步数%ld", (long)steps);
                }];
                if (isPause) {
                    pauseTime = -[pauseDate timeIntervalSinceNow];
                    pauseDistance = distance - startPauseDistance;
                }
                //避免时间从0开始
                NSNumber *speed = @((distance - pauseDistance - allPauseDistance) / (time + 1 - pauseTime));
                [self.detailView setDataWithSpeed:[speed getNumberWithScale:2] distance:(int)(distance - pauseDistance - allPauseDistance) stage:10];
//                [self.detailView setDataWithSpeed:[speed getNumberWithScale:2] distance:(int)(distance - pauseDistance - allPauseDistance) stage:steps];
                
        });
        dispatch_resume(_timer);
        }
        //计步器
        if ([CMPedometer isStepCountingAvailable]) {
            @weakify(self);
            [self.pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
                @autoreleasepool {
                    @strongify(self)
                    if (error) {
                        log(@"%@", error);
                    }
                    [self.sportsDataSignal sendNext:pedometerData];
                    log(@"距离：%ld", pedometerData.distance.integerValue);
                }
            }];
        }
        //设备硬件状态
        _motionManager.deviceMotionUpdateInterval = 1;
        @weakify(self);
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue  currentQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            @autoreleasepool {
            @strongify(self)
                NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
                DDLogInfo(@"\ngravity:x:%f\ty:%f\tz:%f", motion.gravity.x, motion.gravity.y, motion.gravity.z);
                DDLogInfo(@"\nattitude:pitch:%f\troll:%f\tyaw:%f", motion.attitude.pitch, motion.attitude.roll, motion.attitude.yaw);
                DDLogInfo(@"\nrotationMatrix:\n%f\t%f\t%f\n%f\t%f\t%f\n%f\t%f\t%f", motion.attitude.rotationMatrix.m11, motion.attitude.rotationMatrix.m12, motion.attitude.rotationMatrix.m13, motion.attitude.rotationMatrix.m21, motion.attitude.rotationMatrix.m22, motion.attitude.rotationMatrix.m23, motion.attitude.rotationMatrix.m31, motion.attitude.rotationMatrix.m32, motion.attitude.rotationMatrix.m33);
                DDLogInfo(@"\nquaternion:x:%f\ty:%f\tz:%f", motion.attitude.quaternion.x, motion.attitude.quaternion.y, motion.attitude.quaternion.z);
                DDLogInfo(@"\nrotationRate:x:%f\ty:%f\tz:%f", motion.rotationRate.x, motion.rotationRate.y, motion.rotationRate.z);
                DDLogInfo(@"\nAcceleration:x:%f\ty:%f\tz:%f", motion.userAcceleration.x, motion.userAcceleration.y, motion.userAcceleration.z);
                [self.db executeUpdate:@"insert into acceleration(x,y,z,time) values(?,?,?,?);", @(motion.userAcceleration.x), @(motion.userAcceleration.y), @(motion.userAcceleration.z), @(timeStamp)];
            }
        }];
        //设备当前的活动状态
         if ([CMMotionActivityManager isActivityAvailable]) {
//             @weakify(self);
            [self.motionActivityManager startActivityUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMMotionActivity * _Nullable activity) {
                @autoreleasepool {
                    @strongify(self)
                    NSString *userActivity = @"";
                    NSTimeInterval timeStamp = [activity.startDate timeIntervalSince1970];
                    if (activity.stationary) {
                        userActivity = @"stationary";
                        DDLogInfo(@"activity: user is stationary");
                    }
                    if (activity.unknown) {
                        userActivity = @"unknow";
                        DDLogInfo(@"activity: unknow state");
                    }
                    if (activity.walking) {
                        userActivity = @"walking";
                        DDLogInfo(@"activity: user is walking");
                    }
                    if (activity.running) {
                        userActivity = @"running";
                        DDLogInfo(@"activity: user is running");
                    }
                    if (activity.automotive) {
                        userActivity = @"automotive";
                        DDLogInfo(@"activity: user is in vehicle");
                    }
                    if (activity.cycling) {
                        userActivity = @"cycling";
                        DDLogInfo(@"activity: user is cycling");
                    }
                    if (![userActivity isEqualToString:@""]) {
                        [self.db executeUpdate:@"insert into activity(activity, confidence, time) values(?,?,?);", userActivity, @(activity.confidence), @(timeStamp)];
                    }
                }
            }];
        } else {
            DDLogWarn(@"error");
        }
        //高度
        [_altimeter startRelativeAltitudeUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAltitudeData * _Nullable altitudeData, NSError * _Nullable error) {
            
        }];
        //设置后台持续定位
        if ([[UIDevice currentDevice] systemVersion].floatValue >= 9) {
            self.locationManager.allowsBackgroundLocationUpdates = YES;
        } else{
            [self.locationManager setPausesLocationUpdatesAutomatically:NO];
        }
        [_locationManager startUpdatingLocation];
    }];
    // 暂停
    [self.detailView.pauseSignal subscribeNext:^(id  _Nullable x) {
       @strongify(self)
        [self.detailView changeSportsStation:SportsDidPause];
        isPause = YES;
        pauseDate = [NSDate date];
        startPauseDistance = distance;
        self.isPause = YES;
        
        self.line = [[MAMutablePolyline alloc] initWithPoints:@[]];
        [self.detailView.mapView addOverlay:self.line];
    }];
    // 继续
    [self.detailView.continueSignal subscribeNext:^(id  _Nullable x) {
       @strongify(self)
        isPause = NO;
        allPauseDistance += pauseDistance;
        pauseDistance = 0;
        [self.detailView changeSportsStation:SportsDidStart];
    }];
    [self.detailView.endSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        int timeStamp = [[NSDate date] timeIntervalSince1970];
        [_db executeUpdate:@"insert into sportsInfo(steps, stepDistance, mapDistance, totalTime, time) values(?,?,?,?,?);", @(steps), @((int)distance), @((int)_mapDistance), @(time), @(timeStamp)];
        dispatch_source_cancel(_timer);
        [self free];
        [self.detailView setDataWithCalorie:cyclingCount time:time / 60];
        [self.detailView changeSportsStation:SportsDidEnd];
        [self.locationManager stopUpdatingLocation];
    }];
    [self.detailView.shareSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.detailView changeSportsStation:SportsShare];
    }];
}

// 本方法已废弃
//- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
//    @autoreleasepool {
//        DDLogVerbose(@"latitude:%f\tlongitude:%f", location.coordinate.latitude, location.coordinate.longitude);
//        if (location) {
//            DDLogVerbose(@"%f,%f", _lastPoint.x, _lastPoint.y);
//            if (_lastPoint.x == 0.0 && _lastPoint.y == 0.0) {
//                _lastPoint = MAMapPointForCoordinate(location.coordinate);
//                DDLogVerbose(@"lastpoint");
//            }
//#warning TODO:do something when pause
//            MAMapPoint nowPoint = MAMapPointForCoordinate(location.coordinate);
//            _mapDistance += MAMetersBetweenMapPoints(_lastPoint, nowPoint);
//            _lastPoint = MAMapPointForCoordinate(location.coordinate);
//            DDLogVerbose(@"distance:%f", _mapDistance);
//            [_detailView addPolygonLine:location];
//        }
//    }
//}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode {
    
}

- (void)addPolygonLine:(CLLocation *)location {
    [_line appendPoint:MAMapPointForCoordinate(location.coordinate)];
    [_detailView.mapView setCenterCoordinate:location.coordinate animated:YES];
    
    [self.render invalidatePath];
}

#pragma mark - mapViewDelegate
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (!updatingLocation) {
        return;
    }
    // 改变箭头指向
    if (self.detailView.userLocationAnnotationView) {
        [UIView animateWithDuration:0.1 animations:^{
            double degree = userLocation.heading.trueHeading;// - self.mapView.rotationDegree;
            self.detailView.userLocationAnnotationView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f);
        }];
    }
    
    // 移动距离小于两米属于无效的，不画
    if (self.lastLocatioin) {
        CLLocationDistance distance = [userLocation.location distanceFromLocation:self.lastLocatioin];
        if (distance < 2) {
            return;
        }
    }
    self.lastLocatioin = userLocation.location;
    
#warning TODO:目前不判断是否在绘制
    self.isRecording = YES;
    if (self.isRecording) { //是否正在绘制
        /*当定位成功后，如果horizontalAccuracy大于0，说明定位有效
         horizontalAccuracy，该位置的纬度和经度确定的圆的中心，并且这个值表示圆的半径。负值表示该位置的纬度和经度是无效的。
         horizontalAccuracy值越大越不准确
         */
        if (userLocation.location.horizontalAccuracy < 80 && userLocation.location.horizontalAccuracy > 0) {
#warning TODO:暂时没用到，存储下坐标以备上传
            [self.locationsArray addObject:userLocation.location];
            
            NSLog(@"date: %@,now :%@",userLocation.location.timestamp,[NSDate date]);
            
            [self.line appendPoint: MAMapPointForCoordinate(userLocation.location.coordinate)];
            
            [self.detailView.mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
            
            self.lastLocatioin = userLocation.location;
            
            [self.render invalidatePath];
        }
    }
}

/**
 高德地图折线配置
 
 @param mapView mapView description
 @param overlay overlay description
 @return return value description
 */
- (MAOverlayPathRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAMutablePolyline class]]) {
        MAMutablePolylineRenderer *renderer = [[MAMutablePolylineRenderer alloc] initWithOverlay:overlay];
        renderer.lineWidth = 12.0f;
        
        if (self.isPause) {
            renderer.strokeColor = [UIColor grayColor];
        } else {
            renderer.strokeColor = C_66A7FE;
        }
        
        _render = renderer;
        
        return renderer;
    }
    
    return nil;
}

// 绘制方向箭头
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation                                                            reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        
        annotationView.image = [UIImage imageNamed:@"icon_userPosition"];
        self.detailView.userLocationAnnotationView = annotationView;

        return annotationView;
        
    }
    return nil;
}

//定位失败
- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    NSString *errorString = @"";
    switch([error code]) {
        case kCLErrorDenied:
            errorString = @"Access to Location Services denied by user";
            break;
        case kCLErrorLocationUnknown:
            errorString = @"Location data unavailable";
            break;
        default:
            errorString = @"An unknown error has occurred";
            break;
    }
}

#pragma mark - faceCompare
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSString *medieType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([medieType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        NSDictionary *dic = @{@"face1":image,
                              @"face2":image};
        [[_viewModel.compareFaceCommand execute:dic] subscribeNext:^(id  _Nullable x) {
            [WToast showWithText:@"x"];
            [_imagePicker dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

- (void)free {
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
    if (_pedometer) {
        [_pedometer stopPedometerUpdates];
        _pedometer = nil;
    }
    if (_motionManager) {
        [_motionManager stopDeviceMotionUpdates];
        _motionManager = nil;
    }
    if (_motionActivityManager) {
        [_motionActivityManager stopActivityUpdates];
        _motionActivityManager = nil;
    }
    [_db close];
    if (_locationManager) {
        [_locationManager stopUpdatingLocation];
        _locationManager = nil;
    }
    if (_altimeter) {
        [_altimeter stopRelativeAltitudeUpdates];
        _altimeter = nil;
    }
    [_sportsDataSignal sendCompleted];
}
@end
