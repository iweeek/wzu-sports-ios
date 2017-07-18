//
//  RankingManagerController.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/15.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "RankingManagerController.h"
#import "FlipTableView.h"
#import "SegmentTapView.h"
#import "RankingController.h"
#import "FSScrollContentView.h"
#import "UIViewController+BackButtonHandler.h"


@interface RankingManagerController () <SegmentTapViewDelegate, FlipTableViewDelegate>
// <FSPageContentViewDelegate,FSSegmentTitleViewDelegate>

//@property (nonatomic, strong) FSPageContentView *pageContentView;
//@property (nonatomic, strong) FSSegmentTitleView *titleView;

@property (nonatomic, strong)SegmentTapView *segment;
@property (nonatomic, strong) FlipTableView *flipView;
@property (nonatomic, strong) NSMutableArray *controllsArray;

@end

@implementation RankingManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"校园排行榜";
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(BOOL)navigationShouldPopOnBackButton {
//    self.pageContentView = nil;
    return YES; // 返回按钮有效
}

- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.segment = [[SegmentTapView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 50) withDataArray:[NSArray arrayWithObjects:@"累计消耗热量", @"累计锻炼时长", nil] withFont:15];
    self.segment.textNomalColor = c7E848C;
    self.segment.textSelectedColor = c66A7FE;
    self.segment.lineColor = c66A7FE;
    self.segment.delegate = self;
    self.segment.spliteLineColor = cEEEEEE;
    [self.view addSubview:self.segment];
    
    if (!self.controllsArray) {
        self.controllsArray = [[NSMutableArray alloc] init];
    }
    
    RankingController *calorieVC = [[RankingController alloc] init];
    calorieVC.nav = self.navigationController;
    calorieVC.view.backgroundColor = cFFFFFF;
    
    RankingController *TimeVC = [[RankingController alloc] init];
    TimeVC.nav = self.navigationController;
    TimeVC.view.backgroundColor = c7E848C;
    [self.controllsArray addObject:calorieVC];
    [self.controllsArray addObject:TimeVC];
    
    self.flipView = [[FlipTableView alloc] initWithFrame:CGRectMake(0, 64 + 50, WIDTH, HEIGHT - 50) withArray:_controllsArray];
    
    self.flipView.delegate = self;
    [self.view addSubview:self.flipView];
}

#pragma mark --
- (void)dealloc {
    NSLog(@"dealloc ranking");
}

#pragma mark - select Index
-(void)selectedIndex:(NSInteger)index {
    [self.flipView selectIndex:index];
    
}
-(void)scrollChangeToIndex:(NSInteger)index {
    [self.segment selectIndex:index];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
