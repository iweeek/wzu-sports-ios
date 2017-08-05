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

@interface SportsResultController ()<MAMapViewDelegate>
{
    CLLocationCoordinate2D *_traceCoordinate;
    NSUInteger _traceCount;
    CFTimeInterval _duration;
}

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
    
    // 加载坐标点
    [self modelMapToLocations];
    
    [self createUI];
    
    [self showRoute];
}

- (void)createUI {
    self.detailView = [[SportsDetailView alloc] initWithFrame:CGRectMake(0.0, 0.0, WIDTH, HEIGHT)];
    [self.detailView setDelegate:self];
    [self.detailView changeSportsStation:SportsWillStart];
    // 不追踪用户的location更新
    [self.detailView changeUserTrackingMode:MAUserTrackingModeNone];
    
    self.line = [[MAMutablePolyline alloc] initWithPoints:@[]];
    [self.detailView.mapView addOverlay:self.line];
    
    if (self.RunningActivity) {
        [self.detailView changeSportsStation:SportsDidEnd];
        [self.detailView setDataWithActivity:self.RunningActivity];
    } else {
        [self.detailView changeSportsStation:SportsAreaOutdoorDidEnd];
        [self.detailView setDataWithActivity:self.areaActivity];
    }
    
    [self.view addSubview:self.detailView];
    
    // 初始定位，以运动的开头为中心
    MATracePoint *point = [[MATracePoint alloc] init];
    if (self.tracedLocationsArray.count == 0) {
        return;
    }
    point = self.tracedLocationsArray[0];
    struct CLLocationCoordinate2D location = {point.latitude, point.longitude};
    self.detailView.mapView.centerCoordinate = location;
}

// 获取西北角坐标和东南角坐标以及中心点坐标，用于确定地图展示范围
- (void)setLocationRange {
    if (self.longitudeArray.count < 2) {
        return;
    }
    
    // 把经度数组和纬度数组排序生成顺序
    [self.longitudeArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 doubleValue] > [obj2 doubleValue];
    }];
    [self.latitudeArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 doubleValue] > [obj2 doubleValue];
    }];
    NSLog(@"longitudeArray:%@", self.longitudeArray);
    NSLog(@"latitudeArray:%@", self.latitudeArray);
    
    // 取中心点坐标
    double centerlongitude = ([self.longitudeArray.firstObject doubleValue] + [self.longitudeArray.lastObject doubleValue]) / 2;
    double centerlatitude = ([self.latitudeArray.firstObject doubleValue] + [self.latitudeArray.lastObject doubleValue]) / 2;
    // 取经纬度跨度
    double longitudeDelta = [self.longitudeArray.firstObject doubleValue] + [self.longitudeArray.lastObject doubleValue];
    double latitudeDelta = [self.latitudeArray.firstObject doubleValue] + [self.latitudeArray.lastObject doubleValue];
    // 当前区域的中心点经纬度
    CLLocationCoordinate2D centerPoint = CLLocationCoordinate2DMake(centerlatitude, centerlongitude);
    // 当前区域的经纬度跨度
    MACoordinateSpan span = MACoordinateSpanMake(latitudeDelta, longitudeDelta);
    // 确定区域
    MACoordinateRegion region = MACoordinateRegionMake(centerPoint, span);
    // 加入系统动画
    [self.detailView setRegion:region];

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
                              edgePadding:UIEdgeInsetsMake(200,0,0,0)
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
//    self.longitudeArray = [[NSMutableArray alloc] init];
//    self.latitudeArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in self.RunningActivity.data) {
//        [self.longitudeArray addObject:dic[@"longitude"]];
//        [self.latitudeArray addObject:dic[@"latitude"]];
        
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
