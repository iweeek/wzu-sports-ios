//
//  ApproveDetailController.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/12.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "ApproveDetailController.h"
#import "ApproveDetailItemCell.h"
#import "ApproveDetailImageCell.h"

@interface ApproveDetailController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ApproveDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"审批详情";
    self.view.backgroundColor = cFFFFFF;
    [self.view addSubview:self.tableView];
    
//    [self layout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        ApproveDetailImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ApproveDetailImageCell class]) forIndexPath:indexPath];
        return cell;
    }
    
    ApproveDetailItemCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ApproveDetailItemCell class]) forIndexPath:indexPath];
    //    [cell setupWithData:nil];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        return 123;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - getter && setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,WIDTH, HEIGHT) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.userInteractionEnabled = YES;
        
        [_tableView registerClass:[ApproveDetailItemCell class]
           forCellReuseIdentifier:NSStringFromClass([ApproveDetailItemCell class])];
        [_tableView registerClass:[ApproveDetailImageCell class]
           forCellReuseIdentifier:NSStringFromClass([ApproveDetailImageCell class])];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
