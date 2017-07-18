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
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) MAAnimatedAnnotation *myLocation;
@property (nonatomic, strong) NSMutableArray<MATracePoint *> *tracedLocationsArray;

@property (nonatomic, strong) MAMutablePolyline *line;
@property (nonatomic, strong) MAMutablePolylineRenderer3D *render;
@property (nonatomic, strong) SportsDetailView *detailView;

@end

@implementation SportsResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
//    CLLocationCoordinate2D *coords = (CLLocationCoordinate2D *)malloc(tracePoints.count * sizeof(CLLocationCoordinate2D));
//    
//    for (int i = 0; i < tracePoints.count; i++)
//    {
//        coords[i] = CLLocationCoordinate2DMake(tracePoints[i].latitude, tracePoints[i].longitude);
//    }
//    
//    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coords count:tracePoints.count];
//    [self.mapView addOverlay:polyline];
//    
//    [self.mapView showOverlays:self.mapView.overlays edgePadding:UIEdgeInsetsMake(200, 50, 200, 50) animated:NO];
//    
//    if (coords)
//    {
//        free(coords);
//    }
    
    MATracePoint *point = [[MATracePoint alloc] init];
    if (self.tracedLocationsArray.count == 0) {
        return;
    }
    
    for (MATracePoint *p in self.tracedLocationsArray) {
        struct CLLocationCoordinate2D location = {p.latitude, p.longitude};
        
        [self.line appendPoint: MAMapPointForCoordinate(location)];
        [self.render referenceDidChange];
    }
    
//    [self.detailView.mapView setCenterCoordinate:location animated:YES];
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
    for (NSDictionary *dic in self.RunningActivity.data) {
        MATracePoint *point = [[MATracePoint alloc] init];
        point.latitude = [dic[@"latitude"] floatValue];
        point.longitude = [dic[@"longitude"] floatValue];
        [self.tracedLocationsArray addObject:point];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
