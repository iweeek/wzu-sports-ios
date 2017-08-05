//
//  SportsHistoryManagerController.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/20.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "SportsHistoryManagerController.h"
#import "FlipTableView.h"
#import "SegmentTapView.h"
#import "SportsHistoryController.h"

@interface SportsHistoryManagerController () <SegmentTapViewDelegate, FlipTableViewDelegate>

@property (nonatomic, strong)SegmentTapView *segment;
@property (nonatomic, strong) FlipTableView *flipView;
@property (nonatomic, strong) NSMutableArray *controllsArray;

@end

@implementation SportsHistoryManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"历史运动概况";
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *arrType = [NSArray arrayWithObjects:@"本周", @"本月", @"本学期", nil];
    self.segment = [[SegmentTapView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 50) withDataArray:arrType withFont:15];
    self.segment.textNomalColor = c7E848C;
    self.segment.textSelectedColor = c66A7FE;
    self.segment.lineColor = c66A7FE;
    self.segment.delegate = self;
    self.segment.spliteLineColor = cEEEEEE;
    [self.view addSubview:self.segment];
    
    if (!self.controllsArray) {
        self.controllsArray = [[NSMutableArray alloc] init];
    }
    
    for (int i = 0; i < arrType.count; i++) {
        SportsHistoryController *vc = [[SportsHistoryController alloc] init];
        vc.type = i;
        vc.nav = self.navigationController;
        [self.controllsArray addObject:vc];
    }
    
    self.flipView = [[FlipTableView alloc] initWithFrame:CGRectMake(0, 64 + 50, WIDTH, HEIGHT - 50) withArray:_controllsArray];
    
    self.flipView.delegate = self;
    [self.view addSubview:self.flipView];
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
