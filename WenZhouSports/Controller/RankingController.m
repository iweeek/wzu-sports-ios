//
//  RankingController.m
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/6.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "RankingView.h"
#import "RankingController.h"

@interface RankingController ()

@property (nonatomic, strong) RankingView *rankingView;

@end

@implementation RankingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)initSubviews {
    _rankingView = [[RankingView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_rankingView];
    @weakify(self);
    [self.rankingView.selectCalorieSignal subscribeNext:^(id x) {
        @strongify(self)
#warning setCalorieData
        [self.rankingView setDataWithCalorie:nil];
    }];
    [self.rankingView.selectTimeSignal subscribeNext:^(id  _Nullable x) {
       @strongify(self)
#warning setTimeData
        [self.rankingView setDataWithTime:nil];
    }];
}

@end
