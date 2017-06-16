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
#import "MAMutablePolylineRenderer3D.h"
#import "UIViewController+BackButtonHandler.h"
#import "AMapRouteRecord.h"

@interface SportsDetailsController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, AMapLocationManagerDelegate, MAMapViewDelegate ,AMapLocationManagerDelegate>

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
@property (nonatomic, strong) MAMutablePolylineRenderer3D *render;
@property (nonatomic, assign) BOOL isRecording; //是否正在绘制
@property (nonatomic, strong) CLLocation *lastLocatioin;

@property (nonatomic, assign) BOOL isSporting;// 是否正在运动
@property (nonatomic, assign) NSInteger sportsTime;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) double distance;
@property (nonatomic, assign) float speed;

@property (nonatomic, strong) NSMutableArray *tracedPolylines;
@property (nonatomic, strong) NSMutableArray *tempTraceLocations;
@property (nonatomic, strong) MATraceManager *traceManager;
@property (nonatomic, strong) AMapRouteRecord *currentRecord;

@property (nonatomic, strong) UILabel *labLatitude;
@property (nonatomic, strong) UILabel *lablongitude;

@end 

@implementation SportsDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"运动详情";
    [self initSubviews];
    [self reactiveEvent];
    self.pedometer = [[CMPedometer alloc] init];
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionActivityManager = [[CMMotionActivityManager alloc] init];
    
    NSString *path = [NSString stringWithFormat:@"%@/Documents/user.sqlite", NSHomeDirectory()];
    self.db = [FMDatabase databaseWithPath:path];
    [self.db open];
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        
    }];
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager setLocatingWithReGeocode:YES];
    [self.locationManager startUpdatingLocation];
    self.locationManager.distanceFilter = 10;// 超出10米执行回调
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;// 精确度
    self.mapDistance = 0;
    self.lastPoint = MAMapPointMake(0.0, 0.0);
    
    self.viewModel = [[SportsDetailViewModel alloc] init];
    
    self.tracedPolylines = [NSMutableArray array];
    self.tempTraceLocations = [NSMutableArray array];
    self.traceManager = [[MATraceManager alloc] init];
    self.currentRecord = [[AMapRouteRecord alloc] init];
}

- (void)initSubviews {
    self.detailView = [[SportsDetailView alloc] initWithFrame:CGRectMake(0.0, 64, WIDTH, HEIGHT - 64)];
    [self.detailView setDelete:self];
    self.detailView.runningProject = self.runningProject;
    [self.detailView changeSportsStation:SportsWillStart];
    
    self.line = [[MAMutablePolyline alloc] initWithPoints:@[]];
    [self.detailView.mapView addOverlay:self.line];
    [self.view addSubview:self.detailView];
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

// 拦截系统返回按钮，返回前释放timer，避免循环引用
-(BOOL)navigationShouldPopOnBackButton {
    if (self.isRecording) {
        [WToast showWithText:@"请先结束运动"];
        return NO;
    }
    return YES; // 返回按钮有效
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
        self.startTime = (long)[[NSDate date] timeIntervalSince1970];
        self.isRecording = YES;
        [self.detailView setQualifiedData];
        self.currentRecord = [[AMapRouteRecord alloc] init];
        // 全程请求trace
        [self.detailView.mapView removeOverlays:self.tracedPolylines];
        [self queryTraceWithLocations:self.currentRecord.locations withSaving:YES];
        [self.navigationController.navigationItem setHidesBackButton:YES];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            @strongify(self)
            [[self.viewModel.compareFaceCommand execute:nil] subscribeNext:^(id  _Nullable x) {
                
            }];
        });
//        [self.detailView setDataWithSpeed:@"0.0" distance:0 stage:10];
        [self.detailView addPauseGestureEvent];
        NSDate *nowDate = [NSDate date];
        [self.detailView changeSportsStation:SportsDidStart];
        
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        //定时器，每秒触发
        dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(self.timer, ^{
            @strongify(self);
            // 开始运动
            self.isSporting = YES;
            // 运动时长计数
            self.sportsTime++;
            //点击开始后开始计时
            time = -[nowDate timeIntervalSinceNow];
            NSLog(@"时间：%ld", (long)self.sportsTime);
            [self.sportsDataSignal subscribeNext:^(CMPedometerData *x) {
                distance = x.distance.floatValue;
                steps = x.numberOfSteps.integerValue;
                DDLogInfo(@"步数%ld", (long)steps);
            }];
            if (isPause) {
                pauseTime = -[pauseDate timeIntervalSinceNow];
                pauseDistance = distance - startPauseDistance;
            }

            [self.detailView setDataWithDistance:self.distance
                                            time:self.sportsTime
                                           speed:self.speed];
        });
        
        dispatch_resume(self.timer);
       
        //计步器
        if ([CMPedometer isStepCountingAvailable]) {
            [self.pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
                @strongify(self)
                if (error) {
                    log(@"%@", error);
                }
                [self.sportsDataSignal sendNext:pedometerData];
                log(@"距离：%ld", (long)pedometerData.distance.integerValue);
            }];
        }
        //设备硬件状态
        self.motionManager.deviceMotionUpdateInterval = 1;
        @weakify(self);
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue  currentQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            @autoreleasepool {
            @strongify(self)
//                NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
//                DDLogInfo(@"\ngravity:x:%f\ty:%f\tz:%f", motion.gravity.x, motion.gravity.y, motion.gravity.z);
//                DDLogInfo(@"\nattitude:pitch:%f\troll:%f\tyaw:%f", motion.attitude.pitch, motion.attitude.roll, motion.attitude.yaw);
//                DDLogInfo(@"\nrotationMatrix:\n%f\t%f\t%f\n%f\t%f\t%f\n%f\t%f\t%f", motion.attitude.rotationMatrix.m11, motion.attitude.rotationMatrix.m12, motion.attitude.rotationMatrix.m13, motion.attitude.rotationMatrix.m21, motion.attitude.rotationMatrix.m22, motion.attitude.rotationMatrix.m23, motion.attitude.rotationMatrix.m31, motion.attitude.rotationMatrix.m32, motion.attitude.rotationMatrix.m33);
//                DDLogInfo(@"\nquaternion:x:%f\ty:%f\tz:%f", motion.attitude.quaternion.x, motion.attitude.quaternion.y, motion.attitude.quaternion.z);
//                DDLogInfo(@"\nrotationRate:x:%f\ty:%f\tz:%f", motion.rotationRate.x, motion.rotationRate.y, motion.rotationRate.z);
//                DDLogInfo(@"\nAcceleration:x:%f\ty:%f\tz:%f", motion.userAcceleration.x, motion.userAcceleration.y, motion.userAcceleration.z);
//                [self.db executeUpdate:@"insert into acceleration(x,y,z,time) values(?,?,?,?);", @(motion.userAcceleration.x), @(motion.userAcceleration.y), @(motion.userAcceleration.z), @(timeStamp)];
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
        [self.altimeter startRelativeAltitudeUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAltitudeData * _Nullable altitudeData, NSError * _Nullable error) {
            
        }];
        //设置后台持续定位
        if ([[UIDevice currentDevice] systemVersion].floatValue >= 9) {
            self.locationManager.allowsBackgroundLocationUpdates = YES;
        } else{
            [self.locationManager setPausesLocationUpdatesAutomatically:NO];
        }
        [self.locationManager startUpdatingLocation];
    }];
    
    // 停止（原来是暂停，注释掉暂停逻辑）
    [self.detailView.pauseSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        // 释放计时器
        dispatch_source_cancel(self.timer);
        // 停止画轨迹
        self.isRecording = NO;
        // 停止运动
        self.isSporting = NO;
        
        int timeStamp = [[NSDate date] timeIntervalSince1970];
        [self.db executeUpdate:@"insert into sportsInfo(steps, stepDistance, mapDistance, totalTime, time) values(?,?,?,?,?);", @(steps), @((int)distance), @((int)self.mapDistance), @(time), @(timeStamp)];
        
        [self free];
        [self.detailView setDataWithCalorie:cyclingCount time:self.sportsTime / 60];
        [self.detailView changeSportsStation:SportsDidEnd];
        [self.locationManager stopUpdatingLocation];
        
        NSDictionary *dic = @{@"projectId":@(self.runningProject.id),
                              @"studentId":@(1),
                              @"distance":@(self.distance),
                              @"costTime":@(self.sportsTime),
                              @"targetTime":@(self.sportsTime),
                              @"startTime":@(self.startTime)};

        [[self.viewModel.cmdRunActivity execute:dic] subscribeError:^(NSError * _Nullable error) {
            NSLog(@"error>>>>>>>>>:%@", [error localizedDescription]);
        }];;
        
//        // 停止运动
//        self.isSporting = NO;
//        dispatch_suspend(self.timer);
//        [self.detailView changeSportsStation:SportsDidPause];
//        isPause = YES;
//        pauseDate = [NSDate date];
//        startPauseDistance = distance;
//        
//        self.line = [[MAMutablePolyline alloc] initWithPoints:@[]];
//        [self.detailView.mapView addOverlay:self.line];
    }];
//    // 继续
//    [self.detailView.continueSignal subscribeNext:^(id  _Nullable x) {
//       @strongify(self)
//        // 开始运动
//        self.isSporting = YES;
//        dispatch_resume(self.timer);
//        isPause = NO;
//        allPauseDistance += pauseDistance;
//        pauseDistance = 0;
//        [self.detailView changeSportsStation:SportsDidStart];
//    }];
    [self.detailView.endSignal subscribeNext:^(id  _Nullable x) {
//        @strongify(self)
        
    }];
    [self.detailView.shareSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.detailView changeSportsStation:SportsShare];
    }];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode {
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    [locationManager startUpdatingLocation];
    
    self.labLatitude.text = [NSString stringWithFormat:@"CLlatitude:%f \nCLlongitude:%f \n%@", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude, reGeocode.formattedAddress];
    self.lablongitude.text = [NSString stringWithFormat:@"latitude:%f \nlongitude:%f", location.coordinate.latitude, location.coordinate.longitude];

    if (self.isRecording) { //是否正在绘制
        CLLocationDistance tempDistance = 0;
        // 移动距离小于10米属于无效的，不画
        if (self.lastLocatioin) {
            
            if (location.speed > 0) {
                self.speed = location.speed;
            } else {
                // location.speed为无效速度
                self.speed = 0;
            }
            
            tempDistance = [location distanceFromLocation:self.lastLocatioin];
            
            if (tempDistance < 10) {
                return;
            }
            
            if (self.isSporting) {
                // 总距离增加
                self.distance += tempDistance;
            }
        }
        
        self.lastLocatioin = location;
        
        /*当定位成功后，如果horizontalAccuracy大于0，说明定位有效
         horizontalAccuracy，该位置的纬度和经度确定的圆的中心，并且这个值表示圆的半径。负值表示该位置的纬度和经度是无效的。
         horizontalAccuracy值越大越不准确
         */
        if (location.horizontalAccuracy < 80 && location.horizontalAccuracy > 0) {
#warning TODO:暂时没用到，存储下坐标以备上传
            [self.locationsArray addObject:location];
            
            NSLog(@"date: %@,now :%@",location.timestamp,[NSDate date]);
            
            [self.currentRecord addLocation:location];
            
            [self.line appendPoint: MAMapPointForCoordinate(location.coordinate)];
            [self.render referenceDidChange];
            [self.detailView.mapView setCenterCoordinate:location.coordinate animated:YES];
            
            self.lastLocatioin = location;
            
            // trace
//            [self.tempTraceLocations addObject:location];
//            if (self.tempTraceLocations.count >= 2)
//            {
//                [self queryTraceWithLocations:self.tempTraceLocations withSaving:NO];
//                [self.tempTraceLocations removeAllObjects];
//                
//                // 把最后一个再add一遍，否则会有缝隙
//                [self.tempTraceLocations addObject:location];
//            }
        }
    }
}

- (void)mapView:(MAMapView *)mapView didChangeOpenGLESDisabled:(BOOL)openGLESDisabled {
    MAMutablePolyline *polyline = [self.render mutablePolyline];
    
    if (polyline.points == NULL || polyline.pointCount < 2)
    {
        return;
    }
    
    self.render.glPoints = [self.render glPointsForMapPoints:polyline.points count:polyline.pointCount];
    self.render.glPointCount = polyline.pointCount;
}

- (void)queryTraceWithLocations:(NSArray<CLLocation *> *)locations withSaving:(BOOL)saving
{
    NSMutableArray *mArr = [NSMutableArray array];
    for(CLLocation *loc in locations)
    {
        MATraceLocation *tLoc = [[MATraceLocation alloc] init];
        tLoc.loc = loc.coordinate;
        
        tLoc.speed = loc.speed * 3.6; //m/s  转 km/h
        tLoc.time = [loc.timestamp timeIntervalSince1970] * 1000;
        tLoc.angle = loc.course;
        [mArr addObject:tLoc];
    }
    
    __weak typeof(self) weakSelf = self;
    __unused NSOperation *op = [self.traceManager queryProcessedTraceWith:mArr type:-1 processingCallback:nil  finishCallback:^(NSArray<MATracePoint *> *points, double distance) {
        
        NSLog(@"trace query done!");
        
        [weakSelf addFullTrace:points];
        
    } failedCallback:^(int errorCode, NSString *errorDesc) {
        NSLog(@"query trace point failed :%@", errorDesc);
    }];
}

- (void)addFullTrace:(NSArray<MATracePoint*> *)tracePoints
{
    MAPolyline *polyline = [self makePolylineWith:tracePoints];
    if(!polyline)
    {
        return;
    }
    
    [self.tracedPolylines addObject:polyline];
    [self.detailView.mapView addOverlay:polyline];
}

- (MAPolyline *)makePolylineWith:(NSArray<MATracePoint*> *)tracePoints
{
    if(tracePoints.count < 2)
    {
        return nil;
    }
    
    CLLocationCoordinate2D *pCoords = malloc(sizeof(CLLocationCoordinate2D) * tracePoints.count);
    if(!pCoords) {
        return nil;
    }
    
    for(int i = 0; i < tracePoints.count; ++i) {
        MATracePoint *p = [tracePoints objectAtIndex:i];
        CLLocationCoordinate2D *pCur = pCoords + i;
        pCur->latitude = p.latitude;
        pCur->longitude = p.longitude;
    }
    
    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:pCoords count:tracePoints.count];
    
    if(pCoords)
    {
        free(pCoords);
    }
    
    return polyline;
}

#pragma mark - mapViewDelegate
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (!updatingLocation) {
        return;
    }
    // 改变箭头指向
    if (self.detailView.userLocationAnnotationView) {
        [UIView animateWithDuration:0.1 animations:^{
            double degree = userLocation.heading.trueHeading - self.detailView.mapView.rotationDegree;
            self.detailView.userLocationAnnotationView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f);
        }];
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
        MAMutablePolylineRenderer3D *renderer = [[MAMutablePolylineRenderer3D alloc] initWithOverlay:overlay];
        renderer.lineWidth = 10.0f;
        
        renderer.strokeColor = [UIColor yellowColor];
        
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

- (void)dealloc {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
    }
    
    NSLog(@">>>>>>>>>>>>>>>>");
}
@end
