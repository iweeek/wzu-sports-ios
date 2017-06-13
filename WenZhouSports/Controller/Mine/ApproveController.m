//
//  ApproveController.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/3.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "ApproveController.h"
#import "ApproveItemCell.h"
#import "ApproveAddController.h"
#import "ApproveDetailController.h"

@interface ApproveController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *btnAddApprove;
@property (nonatomic, strong) RACSignal *signalAddApprove;

@end

@implementation ApproveController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"审批";
    self.view.backgroundColor = cFFFFFF;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.btnAddApprove];
    
    [self initEvent];
    
    [self.btnAddApprove mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-30);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)initEvent {
    @weakify(self);
    [self.signalAddApprove subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        ApproveAddController *vc = [[ApproveAddController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ApproveItemCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ApproveItemCell class]) forIndexPath:indexPath];
//    [cell setupWithData:nil];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 126;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ApproveDetailController *vc = [[ApproveDetailController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - getter && setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,WIDTH, HEIGHT) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.userInteractionEnabled = YES;
        
        [_tableView registerClass:[ApproveItemCell class]
           forCellReuseIdentifier:NSStringFromClass([ApproveItemCell class])];
    }
    return _tableView;
}

- (UIButton *)btnAddApprove {
    if (!_btnAddApprove) {
        _btnAddApprove = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnAddApprove.userInteractionEnabled = YES;
        [_btnAddApprove setImage:[UIImage imageNamed:@"icon_addApprove"] forState:UIControlStateNormal];
        _btnAddApprove.layer.cornerRadius = 30;
        _btnAddApprove.layer.masksToBounds = YES;
        
        self.signalAddApprove = [_btnAddApprove rac_signalForControlEvents:UIControlEventTouchUpInside];
    }
    return _btnAddApprove;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
