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
#import "RankingViewModel.h"

@interface RankingController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RankingViewModel *vm;

@end

@implementation RankingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = cFFFFFF;
    [self.view addSubview:self.tableView];
    
    self.vm = [[RankingViewModel alloc] init];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

- (void)initData {
    @weakify(self);
    NSString *str = @"{ \
                        university(id:%ld) { \
                            timeCostedRanking (pageSize:%ld pageNumber:%ld){ \
                                pagesCount \
                                data{ \
                                    studentId \
                                    studentName \
                                    timeCosted \
                                    avatarUrl \
                                } \
                            } \
                        }\
                    }";
    NSDictionary *dic = @{@"query":[NSString stringWithFormat:str, 1, 20, 1]};
    [LNDProgressHUD showLoadingInView:self.view];
    [[self.vm.cmdGetRanking execute:dic] subscribeNext:^(id x) {
        @strongify(self);
        [LNDProgressHUD hidenForView:self.view];
//        self.netErrorView.hidden = YES;
        [self.tableView reloadData];
    } error:^(NSError * _Nullable error) {
        [LNDProgressHUD hidenForView:self.view];
        if (error.code == -1009) {// 无网络
//            self.netErrorView.hidden = NO;
        }
        
        NSLog(@"error:%@", [error localizedDescription]);
    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        RankingHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RankingHeaderCell class]) forIndexPath:indexPath];
        [cell setupWithData:self.vm.homePage.university.timeCostedRanking.data];
        return cell;
    }
    
    RankingItemCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RankingItemCell class]) forIndexPath:indexPath];
    [cell setupWithData:self.vm.homePage.university.timeCostedRanking.data[indexPath.row + 3] index:indexPath.row + 3];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.vm.homePage.university.timeCostedRanking.data.count - 3;
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,WIDTH, HEIGHT - 64 + 20 - 64) style:UITableViewStyleGrouped];
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