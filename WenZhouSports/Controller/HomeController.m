//
//  HomeController.m
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/3.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "HomeController.h"
#import "HomeHeaderView.h"

@interface HomeController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HomeHeaderView *headerView;

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
    self.title = @"首页";
}

- (void)initSubviews {
    _tableView = ({
        UITableView *tv = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, WIDTH, HEIGHT - 64.0)];
        tv.delegate = self;
        tv.dataSource = self;
        _headerView = [[HomeHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, WIDTH, FIT_LENGTH(238.0))];
        tv.tableHeaderView = _headerView;
        
        tv;
    });
    [self.view addSubview: _tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
