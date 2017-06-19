//
//  RankingController.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/15.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "RankingController.h"
#import "RankingHeaderCell.h"
#import "RankingItemCell.h"

@interface RankingController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation RankingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = cFFFFFF;
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        RankingHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RankingHeaderCell class]) forIndexPath:indexPath];
        [cell setupWithData:nil];
        return cell;
    }
    
    RankingItemCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RankingItemCell class]) forIndexPath:indexPath];
    [cell setupWithData:nil];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 6;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 199;
    }
    return 69;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}


#pragma mark - getter && setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,WIDTH, HEIGHT) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.userInteractionEnabled = YES;
        
        [_tableView registerClass:[RankingHeaderCell class]
           forCellReuseIdentifier:NSStringFromClass([RankingHeaderCell class])];
        [_tableView registerClass:[RankingItemCell class]
           forCellReuseIdentifier:NSStringFromClass([RankingItemCell class])];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
