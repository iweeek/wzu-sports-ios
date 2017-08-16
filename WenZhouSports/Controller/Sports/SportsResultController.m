//
//  SportsResultController.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/7/12.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "SportsResultController.h"
#import "AMapRouteRecord.h"
#import "SportsDetailView.h"
#import "MAMutablePolylineRenderer3D.h"
#import "SportsHistoryViewModel.h"

@interface SportsResultController () <MAMapViewDelegate>

@property (nonatomic, strong) SportsHistoryViewModel *vm;

@property (nonatomic, strong) AMapRouteRecord *record;
@property (nonatomic, strong) MAAnimatedAnnotation *myLocation;
@property (nonatomic, strong) NSMutableArray<MATracePoint *> *tracedLocationsArray;

@property (nonatomic, strong) MAMutablePolyline *line;
@property (nonatomic, strong) MAMutablePolylineRenderer3D *render;
@property (nonatomic, strong) SportsDetailView *detailView;

// 经纬度数组，用于排序，取出西北角和东南角坐标
@property (nonatomic, strong) NSMutableArray *longitudeArray;
@property (nonatomic, strong) NSMutableArray *latitudeArray;

@end

@implementation SportsResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"锻炼成果";
    
    self.vm = [[SportsHistoryViewModel alloc] init];
    if (self.runningActivity) {
        self.vm.runningActivity = self.runningActivity;
        [[self.vm.cmdGetRunningActivity execute:nil] subscribeNext:^(id  _Nullable x) {
            [self.detailView changeSportsStation:SportsDidEnd];
            [self.detailView setDataWithActivity:self.runningActivity];
            [self initPolyline];
        } error:^(NSError * _Nullable error) {
            [LNDProgressHUD showErrorMessage:@"获取运动信息失败，请重试" inView:self.view];
        }];
    } else {
        self.vm.areaActivity = self.areaActivity;
        [[self.vm.cmdGetAreaActivity execute:nil] subscribeNext:^(id  _Nullable x) {
            [self.detailView changeSportsStation:SportsAreaOutdoorDidEnd];
            [self.detailView setAreaSportQualifiedData];
            [self.detailView setDataWithActivity:self.vm.areaActivity];
            [self initPolyline];
        } error:^(NSError * _Nullable error) {
            [LNDProgressHUD showErrorMessage:@"获取运动信息失败，请重试" inView:self.view];
        }];
    }
    
    [self createUI];
    
    
}

- (void)createUI {
    
    self.detailView = [[SportsDetailView alloc] initWithFrame:CGRectMake(0.0, 0.0, WIDTH, HEIGHT)];
    [self.detailView setDelegate:self];
    [self.detailView changeSportsStation:SportsWillStart];
    // 不追踪用户的location更新
    [self.detailView changeUserTrackingMode:MAUserTrackingModeNone];
    
    // 不显示用户当前位置，否则会把当前位置和运动轨迹同时显示在地图上
    self.detailView.mapView.showsUserLocation = NO;
    
    self.line = [[MAMutablePolyline alloc] initWithPoints:@[]];
    [self.detailView.mapView addOverlay:self.line];
    
    [self.view addSubview:self.detailView];
    
}

- (void)initPolyline {
    // 加载坐标点
    [self modelMapToLocations];
    
    // 画轨迹
    [self showRoute];
}

- (void)showRoute {
    if (self.record == nil || [self.record numOfLocations] == 0) {
        NSLog(@"invaled route");
    }
    
    [self initDisplayRoutePolyline];
}

- (void)initDisplayRoutePolyline {
    NSArray<MATracePoint *> *tracePoints = self.tracedLocationsArray;
    
    if (tracePoints.count < 2) {
        if (tracePoints.count == 1) {
            // 初始定位，以运动的开头为中心
            MATracePoint *point = [tracePoints firstObject];
            struct CLLocationCoordinate2D location = {point.latitude, point.longitude};
            self.detailView.mapView.centerCoordinate = location;
        }
        return;
    }
    
    MAPointAnnotation *startPoint = [[MAPointAnnotation alloc] init];
    startPoint.coordinate = CLLocationCoordinate2DMake(tracePoints.firstObject.latitude, tracePoints.firstObject.longitude);
    startPoint.title = @"起点";
    [self.detailView.mapView addAnnotation:startPoint];
    
    MAPointAnnotation *endPoint = [[MAPointAnnotation alloc] init];
    endPoint.coordinate = CLLocationCoordinate2DMake(tracePoints.lastObject.latitude, tracePoints.lastObject.longitude);
    endPoint.title = @"终点";
    [self.detailView.mapView addAnnotation:endPoint];

    for (MATracePoint *p in self.tracedLocationsArray) {
        struct CLLocationCoordinate2D location = {p.latitude, p.longitude};
        
        [self.line appendPoint: MAMapPointForCoordinate(location)];
        [self.render referenceDidChange];
    }
    // 完全显示出来所有线
    [self.detailView.mapView showOverlays:self.detailView.mapView.overlays
                              edgePadding:UIEdgeInsetsMake(200,20,40,20)
                                 animated:YES];
}


- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAMutablePolyline class]]) {
        MAMutablePolylineRenderer3D *renderer = [[MAMutablePolylineRenderer3D alloc] initWithOverlay:overlay];
        renderer.lineWidth = 4.0f;
        
        renderer.strokeColor = [UIColor yellowColor];
        
        _render = renderer;
        
        return renderer;
    }
    return nil;
}

- (void)modelMapToLocations {
    self.tracedLocationsArray = [[NSMutableArray alloc] init];
    NSArray *coordsArr = nil;
    if (self.runningActivity) {
        coordsArr = self.vm.runningActivity.data;
    } else {
        coordsArr = self.vm.areaActivity.data;
    }
    
    for (NSDictionary *dic in coordsArr) {
        MATracePoint *point = [[MATracePoint alloc] init];
        point.longitude = [dic[@"longitude"] doubleValue];
        point.latitude = [dic[@"latitude"] doubleValue];
        [self.tracedLocationsArray addObject:point];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
