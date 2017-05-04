//
//  PersonalCenterView.m
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/4.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "PersonalCenterView.h"

@interface PersonalCenterView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *signOutImageView;
@property (nonatomic, strong) UIButton *signOutButton;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) UITableViewCell *tableCell;

@end

@implementation PersonalCenterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleArray = @[@"历史运动记录", @"体测数据", @"体育成绩", @"审批", @"客服"];
        [self initSubviews];
        [self makeConstraints];
    }
    return self;
}

- (void)initSubviews {
    CGFloat proportion = 0.84;
    _headerView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, WIDTH * proportion, FIT_LENGTH(196.0))];
        _avatarImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.layer.cornerRadius = FIT_LENGTH(34.0);
            imageView.layer.borderWidth = 2.0;
            imageView.layer.borderColor = [UIColor whiteColor].CGColor;
            
            imageView;
        });
        _nameLabel = ({
            UILabel *lab = [[UILabel alloc] init];
            lab.text = @"text";
            lab.textColor = [UIColor whiteColor];
            lab.font = S14;
            
            lab;
        });
        view.backgroundColor = [UIColor blueColor];
        [view addSubviews:@[_avatarImageView, _nameLabel]];
        [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(FIT_LENGTH(68), FIT_LENGTH(68)));
            make.top.equalTo(view).offset(FIT_LENGTH(52.0));
            make.left.equalTo(view).offset(FIT_LENGTH(15.0));
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatarImageView);
            make.top.equalTo(_avatarImageView.mas_bottom).offset(FIT_LENGTH(20.0));
        }];
        
        view;
    });
    _tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, WIDTH * proportion, HEIGHT)];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView setScrollEnabled:NO];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableHeaderView = _headerView;
        
        tableView;
    });
    [self addSubview:_tableView];
    
    _signOutImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        
        imageView;
    });
    _signOutButton = ({
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:@"退出账号" forState:UIControlStateNormal];
        btn.titleLabel.font = S14;
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor clearColor];
        [btn sizeToFit];
        
        btn;
    });
    [self addSubviews:@[_signOutButton, _signOutImageView]];
}

- (void)makeConstraints {
    [_signOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-FIT_LENGTH(17.0));
        make.bottom.equalTo(self).offset(-FIT_LENGTH(18.0));
    }];
    [_signOutImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_signOutButton.mas_left).offset(-FIT_LENGTH(14.0));
        make.centerY.equalTo(_signOutButton);
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defaultCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultCell"];
    }
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.font = S14;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FIT_LENGTH(48.0);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = C_66A7FE;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor lightTextColor];
}
@end


