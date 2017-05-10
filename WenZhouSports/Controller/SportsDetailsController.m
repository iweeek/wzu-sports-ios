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
#import <CoreMotion/CoreMotion.h>

@interface SportsDetailsController ()

@property (nonatomic, strong) SportsDetailView *detailView;
@property (nonatomic, strong) CMPedometer *pedometer;
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation SportsDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
    [self reactiveEvent];
    _pedometer = [[CMPedometer alloc] init];
}

- (void)initSubviews {
    _detailView = [[SportsDetailView alloc] initWithFrame:CGRectMake(0.0, 64.0, WIDTH, HEIGHT - 64.0)];
    [self.view addSubview:_detailView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)reactiveEvent {
    RACSubject *sportsDataSignal = [[RACSubject alloc] init];
    __block CMPedometerData *pedometerData = [[CMPedometerData alloc] init];
    @weakify(self);
    [self.detailView.startSignal subscribeNext:^(id x) {
        [self.detailView setDataWithSpeed:@"0.0" distance:0 stage:10];
        NSDate *nowDate = [NSDate date];
        @strongify(self)
        [self.detailView changeSportsStation:SportsDidStart];
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(_timer, ^{
            int time = [nowDate timeIntervalSinceNow];
            NSLog(@"时间：%d", time);
            [sportsDataSignal subscribeNext:^(CMPedometerData *x) {
                pedometerData = x;
            }];
            NSNumber *speed = @(pedometerData.distance.floatValue / - (time - 1));
            [self.detailView setDataWithSpeed:[speed getNumberWithScale:2] distance:pedometerData.distance.integerValue stage:10];
        });
        dispatch_resume(_timer);
        if ([CMPedometer isStepCountingAvailable]) {
            [_pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
                if (error) {
                    log(@"%@", error);
                }
                [sportsDataSignal sendNext:pedometerData];
                log(@"速度：%f；距离：%ld", pedometerData.currentPace.floatValue,pedometerData.distance.integerValue);
            }];
        }
    }];
    [self.detailView.continueSignal subscribeNext:^(id  _Nullable x) {
       @strongify(self)
        [self.detailView changeSportsStation:SportsDidStart];
    }];
    [self.detailView.endSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.detailView changeSportsStation:SportsDidEnd];
    }];
    [self.detailView.shareSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.detailView changeSportsStation:SportsShare];
    }];
}

@end
