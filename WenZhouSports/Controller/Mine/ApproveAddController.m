//
//  ApproveAddController.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/12.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "ApproveAddController.h"
#import "ApproveAddItemCell.h"
#import "ApproveUploadImageCell.h"

@interface ApproveAddController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *btnSubmit;
@property (nonatomic, strong) RACSignal *signalSubmit;

@end

@implementation ApproveAddController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发起审批";
    self.view.backgroundColor = cFFFFFF;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.btnSubmit];
    
    [self layout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)layout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-56);
    }];
    [self.btnSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(56);
    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        ApproveUploadImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ApproveUploadImageCell class]) forIndexPath:indexPath];
        return cell;
    }
    
    ApproveAddItemCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ApproveAddItemCell class]) forIndexPath:indexPath];
    //    [cell setupWithData:nil];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        return 123;
    }
    return 62;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - getter && setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,WIDTH, HEIGHT) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.userInteractionEnabled = YES;
        
        [_tableView registerClass:[ApproveAddItemCell class]
           forCellReuseIdentifier:NSStringFromClass([ApproveAddItemCell class])];
        [_tableView registerClass:[ApproveUploadImageCell class]
           forCellReuseIdentifier:NSStringFromClass([ApproveUploadImageCell class])];
    }
    return _tableView;
}

- (UIButton *)btnSubmit {
    if (!_btnSubmit) {
        _btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnSubmit setTitle:@"提交审批" forState:UIControlStateNormal];
        _btnSubmit.titleLabel.font = S(21);
        _btnSubmit.backgroundColor = c66A7FE;
        [_btnSubmit setTitleColor:cFFFFFF forState:UIControlStateNormal];
        
        self.signalSubmit = [_btnSubmit rac_signalForControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSubmit;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
