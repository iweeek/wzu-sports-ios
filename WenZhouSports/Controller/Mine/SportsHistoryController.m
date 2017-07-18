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
    self.vm = [[SportsHistoryViewModel alloc] init];
    self.vm.studentId = 1;
//    [self initData];
    
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
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [[self.vm.cmdLoadMoreSportsHistory execute:nil] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        } error:^(NSError * _Nullable error) {
            [self.tableView.mj_header endRefreshing];
            NSLog(@"error:%@", [error localizedDescription]);
        }] ;
    }];
    
    [self.tableView.mj_header beginRefreshing];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SportsHistoryHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SportsHistoryHeaderCell class]) forIndexPath:indexPath];
        [cell setupWithData:nil];
        return cell;
    }
    SportsHistoryItemCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SportsHistoryItemCell class]) forIndexPath:indexPath];
    [cell setupWithData:nil];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.vm.homePage.student.currentTermActivities.data.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 210;
    }
    return 140;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    }
    if (section == 1) {
        return 45;
    }
    return 11;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 45)];
        
        UILabel *lab = [[UILabel alloc] init];
        lab.font = S14;
        lab.text = @"锻炼明细";
        lab.textColor = c7E848C;
        
        [sectionHeaderView addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18);
            make.centerY.mas_equalTo(0);
        }];
        
        return sectionHeaderView;
    }
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > 0) {
        SportsResultController *vc = [[SportsResultController alloc] init];
        RunningActivityModel *runningActivity = self.vm.homePage.student.currentTermActivities.data[indexPath.section - 1];
        vc.RunningActivity = runningActivity;
        
        [self.nav pushViewController:vc animated:YES];
    }
}

#pragma mark - getter && setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,WIDTH, HEIGHT) style:UITableViewStyleGrouped];
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
