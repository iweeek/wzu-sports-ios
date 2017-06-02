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
@property (nonatomic, strong) UIImageView *headerBackgroundImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *signOutButton;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *selectImageArray;
@property (nonatomic, strong) UITableViewCell *tableCell;

@end

@implementation PersonalCenterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleArray = @[@"历史运动记录", @"体测数据", @"体育成绩", @"审批", @"客服", @"设置"];
        _imageArray = @[@"icon_survey", @"icon_fitness_test", @"icon_sports_achievement", @"icon_approval", @"icon_customer_service", @"icon_sets"];
        _selectImageArray = @[@"icon_survey_selected", @"icon_fitness_test_selected", @"icon_sports_achievement_selected", @"icon_approval_selected", @"icon_customer_service_selected", @"icon_sets_selected"];
        [self initSubviews];
        [self makeConstraints];
    }
    return self;
}

- (void)initSubviews {
    CGFloat proportion = 0.84;
    _headerView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, WIDTH * proportion, FIT_LENGTH(196.0))];
        _headerBackgroundImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = [UIImage imageNamed:@"bg_user"];
            
            imageView;
        });
        _avatarImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = [UIImage imageNamed:@"default_avatar"];
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
        [view addSubviews:@[_headerBackgroundImageView, _avatarImageView, _nameLabel]];
        [_headerBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
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
    _signOutButton = ({
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:@"退出账号" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon_logout"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon_logout_selected"] forState:UIControlStateHighlighted];
        btn.titleLabel.font = S14;
        [btn setTitleColor:C_GRAY_TEXT forState:UIControlStateNormal];
        [btn setTitleColor:C_66A7FE forState:UIControlStateHighlighted];
        btn.backgroundColor = [UIColor clearColor];
        [btn sizeToFit];
        
        btn;
    });
    [self addSubviews:@[_signOutButton]];
}

- (void)makeConstraints {
    [_signOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-FIT_LENGTH(17.0));
        make.bottom.equalTo(self).offset(-FIT_LENGTH(18.0));
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defaultCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultCell"];
    }
    cell.imageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.font = S14;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FIT_LENGTH(48.0);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = C_66A7FE;
    cell.imageView.image = [UIImage imageNamed:_selectImageArray[indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RACSubject *subject = [RACSubject subject];
    [[subject delay:0.3] subscribeCompleted:^{
        cell.textLabel.textColor = C_GRAY_TEXT;
        cell.imageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    }];
    [subject sendCompleted];
    self.selectedIndex = indexPath.row;
}

@end


