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
    
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)initData {
    @weakify(self);
    NSString *str = @"{ \
                        student(id:%ld) { \
                            currentTermActivities(pageSize:%ld, pageNumber:%ld){ \
                                pagesCount \
                                data { \
                                    projectId \
                                    costTime \
                                    caloriesConsumed \
                                    startTime \
                                    distance \
                                    qualified \
                                    runningProject{ \
                                        name \
                                    } \
                                } \
                            } \
                        } \
                      }";
    NSDictionary *dic = @{@"query":[NSString stringWithFormat:str, 1, 20, 1]};
    [LNDProgressHUD showLoadingInView:self.view];
    [[self.vm.cmdGetSportsHistory execute:dic] subscribeNext:^(id x) {
        @strongify(self);
        [LNDProgressHUD hidenForView:self.view];
        //        self.netErrorView.hidden = YES;
        [self.tableView reloadData];
    } error:^(NSError * _Nullable error) {
        [LNDProgressHUD hidenForView:self.view];
        if (error.code == -1009) {// 无网络
        }
        
        NSLog(@"error:%@", [error localizedDescription]);
    }];
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
    return 6;
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
