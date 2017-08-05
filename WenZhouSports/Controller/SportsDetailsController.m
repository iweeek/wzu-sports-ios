//
//  SportsDetailsController.m
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/10.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "SportsDetailsController.h"
#import "NSNumber+SetScale.h"
#import "SportsDetailView.h"
#import "SportsDetailViewModel.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>
#import "MAMutablePolyline.h"
#import "MAMutablePolylineRenderer3D.h"
#import "UIViewController+BackButtonHandler.h"
#import "AMapRouteRecord.h"
#import "RunningActivityModel.h"

@interface SportsDetailsController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, AMapLocationManagerDelegate, MAMapViewDelegate ,AMapLocationManagerDelegate>

@property (nonatomic, strong) SportsDetailView *detailView;

@property (nonatomic, strong) CMPedometer *pedometer;
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) CMMotionActivityManager *motionActivityManager;
@property (nonatomic, strong) CMAltimeter *altimeter;
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) dispatch_source_t timerForLab;
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
@property (nonatomic, assign) NSInteger steps;

@property (nonatomic, strong) NSMutableArray *tracedPolylines;
@property (nonatomic, strong) NSMutableArray *tempTraceLocations;
@property (nonatomic, strong) MATraceManager *traceManager;
@property (nonatomic, strong) AMapRouteRecord *currentRecord;

@property (nonatomic, strong) UILabel *labLatitude;
@property (nonatomic, strong) UILabel *lablongitude;

//采集点所需数据
@property (nonatomic, assign) double dataLatitude;
@property (nonatomic, assign) double dataLongitude;
@property (nonatomic, assign) float  dataDistance;
@property (nonatomic, assign) NSTimeInterval acquisitionTime;

@property (nonatomic, strong) RunningActivityModel *runningActivity;

@end 

@implementation SportsDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    // 电量
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    double deviceLevel = [UIDevice currentDevice].batteryLevel;
    [LNDProgressHUD showErrorMessage:[NSString stringWithFormat:@"您的电量剩余%.0f%%",deviceLevel * 100] inView:self.view];
}

- (void)initSubviews {
    self.detailView = [[SportsDetailView alloc] initWithFrame:CGRectMake(0.0, 0.0, WIDTH, HEIGHT)];
    [self.detailView setDelegate:self];
    
    if (self.sportsType == SportsRunning) {
        self.detailView.runningSport = self.runningSport;
        [self.detailView changeSportsStation:SportsWillStart];
    } else if (self.sportsType == SportsOutdoor) {
        [self.detailView changeSportsStation:SportsAreaOutdoorWillStart];
        [self.detailView setDataWithAreaSportsOutdoorPoint:self.areaAportsOutdoorPoint];
    }
    
    self.line = [[MAMutablePolyline alloc] initWithPoints:@[]];
    [self.detailView.mapView addOverlay:self.line];
    [self.view addSubview:self.detailView];
    
    [self.navigationItem setRightBarButtonItemWithImage:[UIImage imageNamed:@"icon_sets_selected"]
                                                 target:self
                                                 action:@selector(triggerSportsInfo)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    [self free];
    self.detailView = nil;
}

// 拦截系统返回按钮，返回前释放timer，避免循环引用
-(BOOL)navigationShouldPopOnBackButton {
    if (self.isRecording) {
        [LNDProgressHUD showErrorMessage:@"请先结束运动" inView:self.view];
        return NO;
    }
    return YES; // 返回按钮有效
}

- (void)triggerSportsInfo {
    [self.detailView triggerSportsInfo];
}

- (void)reactiveEvent {
    _sportsDataSignal = [[RACSubject alloc] init];
    @weakify(self);
    // 运动开始点击事件
    [self.detailView.startSignal subscribeNext:^(id x) {
        @strongify(self);
        self.startTime = (long)[[NSDate date] timeIntervalSince1970];
        self.isRecording = YES;
        // 滑动结束手势
        [self.detailView addPauseGestureEvent];
        
        // 设置后台持续定位
        if ([[UIDevice currentDevice] systemVersion].floatValue >= 9) {
            self.locationManager.allowsBackgroundLocationUpdates = YES;
        } else{
            [self.locationManager setPausesLocationUpdatesAutomatically:NO];
        }
        [self.locationManager startUpdatingLocation];
        
        // 定点运动开始
        if (self.sportsType == SportsOutdoor) {
            [self.detailView changeSportsStation:SportsAreaOutdoorDidStart];
            // 开始
            [self sportsAreaOutdoorPointStart];
            return ;
        }
        
        [self.detailView setQualifiedData];
        self.currentRecord = [[AMapRouteRecord alloc] init];

        // 调用运动开始接口
        self.viewModel.runningSportId = self.runningSport.id;
        self.viewModel.studentId = 3;
        self.viewModel.starTime = self.startTime;
        [[self.viewModel.cmdRunningActivitiesStart execute:nil] subscribeNext:^(id  _Nullable x) {
            self.runningActivity = x;
            
            dispatch_resume(self.timerForLab);
            dispatch_resume(self.timer);
        } error:^(NSError * _Nullable error) {
            @strongify(self);
            [LNDProgressHUD showErrorMessage:[error localizedDescription] inView:self.view];
        }];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            @strongify(self);
            [[self.viewModel.compareFaceCommand execute:nil] subscribeNext:^(id  _Nullable x) {
                
            }];
        });
        
        
        [self.detailView changeSportsStation:SportsDidStart];
        
        // 为界面读秒计时
        self.timerForLab = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        // 定时器，每秒触发
        dispatch_source_set_timer(self.timerForLab, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(self.timerForLab, ^{
            // 运动时长计数
            self.sportsTime++;
            NSLog(@"时间：%ld", (long)self.sportsTime);
            [self.detailView setDataWithDistance:self.distance
                                            time:self.sportsTime
                                           speed:self.speed];
        });
        
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        // 定时器，按照后台返回时间间隔触发
        dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, self.runningSport.acquisitionInterval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(self.timer, ^{
            @strongify(self);
            // 开始运动
            self.isSporting = YES;
            [self.sportsDataSignal subscribeNext:^(CMPedometerData *x) {
                self.steps = x.numberOfSteps.integerValue;
            }];
            
            // 这里也更新界面
            [self.detailView setDataWithDistance:self.distance
                                            time:self.sportsTime
                                           speed:self.speed];
            
            // 开始的信息返回后开始记录运动数据
            self.viewModel.runningActivityid = self.runningActivity.id;
            self.viewModel.acquisitionTime = (long)[[NSDate date] timeIntervalSince1970];
            self.viewModel.stepCount = self.steps;
            self.viewModel.distance = self.dataDistance;
            self.viewModel.longitude = self.dataLongitude;
            self.viewModel.latitude = self.dataLatitude;
            self.viewModel.locationType = YES;
            // 每秒超过10米就是不正常的数据
            self.viewModel.isNormal = YES;
            
            [[self.viewModel.cmdRunningActivityData execute:nil] subscribeNext:^(id  _Nullable x) {
                NSLog(@"data提交成功：%ld", (long)self.sportsTime);
                [LNDProgressHUD showMessage:[NSString stringWithFormat:@"Longitude:%f, Latitude:%f", self.dataLongitude, self.dataLatitude] inView:self.view];
            } error:^(NSError * _Nullable error) {
                @strongify(self);                  [LNDProgressHUD showErrorMessage:[error localizedDescription] inView:self.view];
            }];
        });
        
        
       
        // 计步器
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
        // 设备硬件状态
        self.motionManager.deviceMotionUpdateInterval = 1;
        @weakify(self);
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue  currentQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            @autoreleasepool {
            }
        }];
        // 设备当前的活动状态
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
        // 高度
        [self.altimeter startRelativeAltitudeUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAltitudeData * _Nullable altitudeData, NSError * _Nullable error) {
            
        }];
    }];
    
    // 停止（原来是暂停，注释掉暂停逻辑）
    [self.detailView.pauseSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        // 释放计时器
        dispatch_source_cancel(self.timerForLab);
        dispatch_source_cancel(self.timer);
        // 停止画轨迹
        self.isRecording = NO;
        // 停止运动
        self.isSporting = NO;
        // 停止定位
        [self.locationManager stopUpdatingLocation];
        
//        int timeStamp = [[NSDate date] timeIntervalSince1970];
//        [self.db executeUpdate:@"insert into sportsInfo(steps, stepDistance, mapDistance, totalTime, time) values(?,?,?,?,?);", @(steps), @((int)distance), @((int)self.mapDistance), @(time), @(timeStamp)];
        
        [self free];
        
        // 如果是定点运动
        if (self.sportsType == SportsOutdoor) {
            [self.detailView changeSportsStation:SportsAreaOutdoorDidEnd];
            
            // 调用接口
            self.viewModel.areaActivityId = self.viewModel.areaActivity.id;
            [[self.viewModel.cmdAreaActivityEnd execute:nil] subscribeNext:^(id  _Nullable x) {
                DDLogInfo(@"定点运动结束成功");
            } error:^(NSError * _Nullable error) {
                [LNDProgressHUD showErrorMessage:[error localizedDescription] inView:self.view];
            }];
            return ;
        }
        
        [self.detailView changeSportsStation:SportsDidEnd];

        self.viewModel.runningActivityid = self.runningActivity.id;
        self.viewModel.distance = self.distance;
        // 这里是总步数
        self.viewModel.stepCount = self.steps;
        self.viewModel.costTime = self.sportsTime;
        self.viewModel.targetFinishedTime = self.runningSport.qualifiedCostTime;
        [[self.viewModel.cmdRunningActivitiesEnd execute:nil] subscribeNext:^(id  _Nullable x) {
            NSLog(@"成功结束%@", x);
            RunningActivityModel *runningActivity = x;
            [self.detailView setDataWithCalorie:runningActivity.kcalConsumed
                                           time:self.sportsTime / 60
                                      qualified:runningActivity.qualified];
        } error:^(NSError * _Nullable error) {
            [LNDProgressHUD showErrorMessage:[error localizedDescription] inView:self.view];
        }];
    }];
    
    [self.detailView.endSignal subscribeNext:^(id  _Nullable x) {
//        @strongify(self)
    }];
    [self.detailView.shareSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.detailView changeSportsStation:SportsShare];
    }];
    [self.detailView.signalChangeArea subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (self.isRecording) {
            [LNDProgressHUD showErrorMessage:@"请先结束运动" inView:self.view];
            return;
        }

        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - About sportsArea
- (void)sportsAreaOutdoorPointStart {
    @weakify(self);
    
    // 创建一个areaActivity
    self.viewModel.areaSport = self.areaSport;
    self.viewModel.studentId = 3;
    [[self.viewModel.cmdAreaActivityStart execute:nil] subscribeNext:^(id  _Nullable x) {
        DDLogInfo(@"定点运动创建成功");
        
        dispatch_resume(self.timerForLab);
        dispatch_resume(self.timer);
    }];
    
    // 为界面读秒计时
    self.timerForLab = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    // 定时器，每秒触发
    dispatch_source_set_timer(self.timerForLab, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.timerForLab, ^{
        // 运动时长计数
        self.sportsTime++;
        NSLog(@"时间：%ld", (long)self.sportsTime);
        [self.detailView setSportsOutdoorTime:self.sportsTime];
    });
    
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    // 定时器，按照后台返回时间间隔触发
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, self.areaSport.acquisitionInterval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.timer, ^{
        @strongify(self);
        // 开始运动
        self.isSporting = YES;
        
        self.viewModel.areaActivityId = self.viewModel.areaActivity.id;
        self.viewModel.longitude = self.dataLongitude;
        self.viewModel.latitude = self.dataLatitude;
        self.viewModel.locationType = 0;
        [[self.viewModel.cmdAreaActivityData execute:nil] subscribeNext:^(id  _Nullable x) {
            DDLogInfo(@"定点运动添加成功");
        }];
    });
}

#pragma mark - Location
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode {
    
    self.dataLatitude = location.coordinate.latitude;
    self.dataLongitude = location.coordinate.longitude;

    if (self.isRecording) { // 是否正在绘制
        CLLocationDistance tempDistance = 0;
        // 移动距离小于10米属于无效的，不画
        if (self.lastLocatioin) {
            if (location.speed > 0) {
//                self.speed = location.speed;
                // 速度大于10米每秒，属于无效数据
                if (location.speed > 10) {
                    return;
                }
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
        }
    }
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

// 定位失败
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

#pragma mark - FaceCompare
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
        dispatch_source_cancel(self.timerForLab);
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
        dispatch_source_cancel(self.timerForLab);
        dispatch_source_cancel(self.timer);
    }
    
    NSLog(@">>>>>>>>>>>>>>>>");
}
@end
