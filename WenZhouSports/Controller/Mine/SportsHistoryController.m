//
//  SportsHistoryController.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/1.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "SportsHistoryController.h"
#import "SportsHistoryHeaderCell.h"
#import "SportsHistoryItemCell.h"
#import "SportsHistoryViewModel.h"
#import "MJRefresh.h"
#import "SportsResultController.h"

@interface SportsHistoryController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SportsHistoryViewModel *vm;

@end

@implementation SportsHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史运动概况";
    self.view.backgroundColor = cFFFFFF;
    [self.view addSubview:self.tableView];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)initData {
    self.vm = [[SportsHistoryViewModel alloc] init];
    self.vm.studentId = 3;
//    self.vm.startDate = @"2017-7-1";
//    self.vm.endDate = @"2017-10-20";
    switch (self.type) {
        case SportsHistoryTypeWeek:
        {
            self.vm.sportsHistoryType = @"CURRENT_WEEK";
            self.vm.startDate = [[self getFirstAndLastDayOfThisWeek] firstObject];
            self.vm.endDate = [[self getFirstAndLastDayOfThisWeek] lastObject];
            break;
        }
        case SportsHistoryTypeMonth:
        {
            self.vm.sportsHistoryType = @"CURRENT_MONTH";
            self.vm.startDate = [[self getFirstAndLastDayOfThisMonth] firstObject];
            self.vm.endDate = [[self getFirstAndLastDayOfThisMonth] lastObject];
            break;
        }
        case SportsHistoryTypeTerm:
        {
            self.vm.sportsHistoryType = @"CURRENT_TERM";
            self.vm.startDate = @"2010-1-1";
            self.vm.endDate = [[self getFirstAndLastDayOfThisMonth] lastObject];
            break;
        }
        case SportsHistoryTypeAll:
        {
            self.vm.sportsHistoryType = @"CURRENT_TERM";
            self.vm.startDate = @"2010-1-1";
            self.vm.endDate = [[self getFirstAndLastDayOfThisMonth] lastObject];
            break;
        }
        default:
            break;
    }
    
    @weakify(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [[self.vm.cmdRefreshSportsHistory execute:nil] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        } error:^(NSError * _Nullable error) {
            [self.tableView.mj_header endRefreshing];
            NSLog(@"error:%@", [error localizedDescription]);
        }] ;
    }];
    
    //    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
    //        @strongify(self);
    //        [[self.vm.cmdLoadMoreSportsHistory execute:nil] subscribeNext:^(id  _Nullable x) {
    //            @strongify(self);
    //            [self.tableView.mj_footer endRefreshing];
    //            [self.tableView reloadData];
    //        } error:^(NSError * _Nullable error) {
    //            [self.tableView.mj_header endRefreshing];
    //            NSLog(@"error:%@", [error localizedDescription]);
    //        }] ;
    //    }];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SportsHistoryHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SportsHistoryHeaderCell class]) forIndexPath:indexPath];
        [cell setupWithData:self.vm.homePage.student];
        return cell;
    }
    SportsHistoryItemCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SportsHistoryItemCell class]) forIndexPath:indexPath];
    
    NSArray *arr = self.vm.allActivityArray[indexPath.section - 1];
    id item = arr[indexPath.row];
    [cell setupWithData:item];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    NSArray *arr = self.vm.allActivityArray[section - 1];
    return arr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.vm.allActivityArray.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 206;
    }
    return 97;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section > 0) {
        UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
        NSInteger kcalConsumed = 0;
        NSString *dateStr = nil;
        NSArray *arr = self.vm.allActivityArray[section - 1];
        RunningActivityModel *runningActivity = nil;
        AreaActivityModel *areaActivity = nil;
        for (id item in arr) {
            if ([item isMemberOfClass:[RunningActivityModel class]]) {
                runningActivity = item;
                dateStr = runningActivity.sportDate;
                kcalConsumed += runningActivity.kcalConsumed;
            } else {
                areaActivity = item;
                dateStr = areaActivity.sportDate;
                kcalConsumed += areaActivity.kcalConsumed;
            }
        }
        
        UILabel *labDate = [[UILabel alloc] init];
        labDate.font = SS(17);
        labDate.text = dateStr;
        labDate.textColor = c7E848C;
        
        UILabel *labCalorie = [[UILabel alloc] init];
        labCalorie.font = S13;
        labCalorie.text = [NSString stringWithFormat:@"消耗热量：%ld大卡", kcalConsumed];
        labCalorie.textColor = c7E848C;
        
        [sectionHeaderView addSubview:labDate];
        [sectionHeaderView addSubview:labCalorie];
        
        [labDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18);
            make.centerY.mas_equalTo(0);
        }];
        [labCalorie mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(labDate);
            make.right.mas_equalTo(-20);
        }];
        
        return sectionHeaderView;
    }
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > 0) {
        SportsResultController *vc = [[SportsResultController alloc] init];
        
        NSArray *arr = self.vm.allActivityArray[indexPath.section - 1];
        id activity = arr[indexPath.row];
        
        if ([activity isMemberOfClass:[RunningActivityModel class]]) {
            vc.RunningActivity = activity;
        } else {
            vc.areaActivity = activity;
        }
        [self.nav pushViewController:vc animated:YES];
    }
}

#pragma mark - 获取每周第一天和最后一天，每月第一天和最后一天
- (NSArray *)getFirstAndLastDayOfThisWeek {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger weekday = [dateComponents weekday];   //第几天(从sunday开始)
    NSInteger firstDiff,lastDiff;
    if (weekday == 1) {
        firstDiff = -6;
        lastDiff = 0;
    }else {
        firstDiff =  - weekday + 2;
        lastDiff = 8 - weekday;
    }
    NSInteger day = [dateComponents day];
    NSDateComponents *firstComponents = [calendar components:NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [firstComponents setDay:day+firstDiff];
    NSDate *firstDay = [calendar dateFromComponents:firstComponents];
    
    NSDateComponents *lastComponents = [calendar components:NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [lastComponents setDay:day+lastDiff];
    NSDate *lastDay = [calendar dateFromComponents:lastComponents];
    return [NSArray arrayWithObjects:firstDay,lastDay, nil];
}

- (NSArray *)getFirstAndLastDayOfThisMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *firstDay;
    [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&firstDay interval:nil forDate:[NSDate date]];
    NSDateComponents *lastDateComponents = [calendar components:NSCalendarUnitMonth | NSCalendarUnitYear |NSCalendarUnitDay fromDate:firstDay];
    NSUInteger dayNumberOfMonth = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]].length;
    NSInteger day = [lastDateComponents day];
    [lastDateComponents setDay:day+dayNumberOfMonth-1];
    NSDate *lastDay = [calendar dateFromComponents:lastDateComponents];
    return [NSArray arrayWithObjects:firstDay,lastDay, nil];
}

#pragma mark - getter && setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 50 - 64) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.userInteractionEnabled = YES;
        
        [_tableView registerClass:[SportsHistoryHeaderCell class]
           forCellReuseIdentifier:NSStringFromClass([SportsHistoryHeaderCell class])];
        [_tableView registerClass:[SportsHistoryItemCell class]
           forCellReuseIdentifier:NSStringFromClass([SportsHistoryItemCell class])];
        
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
