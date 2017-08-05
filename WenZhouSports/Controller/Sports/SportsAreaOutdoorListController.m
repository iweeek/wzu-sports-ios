//
//  SportsAreaOutdoorController.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/7/27.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "SportsAreaOutdoorListController.h"
#import "SportsDetailView.h"
#import "SportsDetailViewModel.h"
#import "SportsAreaOutdoorCell.h"
#import "SportsDetailsController.h"

@interface SportsAreaOutdoorListController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SportsDetailViewModel *vm;

@end

@implementation SportsAreaOutdoorListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"锻炼区域列表";
    [self.view addSubview:self.tableView];
    self.vm = [[SportsDetailViewModel alloc] init];
    
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 导航栏背景蓝色
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar lt_setBackgroundColor:c66A7FE];
}

- (void)initData {
    @weakify(self);
    [LNDProgressHUD showLoadingInView:self.view];
    [[self.vm.cmdGetAreaSportsList execute:nil] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [LNDProgressHUD hidenForView:self.view];
        [self.tableView reloadData];
        NSLog(@"列表获取成功");
    } error:^(NSError * _Nullable error) {
        [LNDProgressHUD showErrorMessage:[error localizedDescription] inView:self.view];
        NSLog(@"列表获取失败");
    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SportsAreaOutdoorCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SportsAreaOutdoorCell class]) forIndexPath:indexPath];
    [cell setupWithData:self.vm.areaSportsOutdoorPoints.obj[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.vm.areaSportsOutdoorPoints.obj.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SportsDetailsController *vc = [[SportsDetailsController alloc] init];
    vc.sportsType = SportsOutdoor;
    vc.areaAportsOutdoorPoint = (AreaSportsOutdoorPointModel *)self.vm.areaSportsOutdoorPoints.obj[indexPath.row];
    vc.areaSport = self.areaSport;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - getter && setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.userInteractionEnabled = YES;
        
        [_tableView registerClass:[SportsAreaOutdoorCell class]
           forCellReuseIdentifier:NSStringFromClass([SportsAreaOutdoorCell class])];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
