//
//  LunchView.m
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/3.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "LaunchView.h"

@interface LaunchView ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *forgetPasswordButton;
@property (nonatomic, strong) RACSignal *loginSignal;
@property (nonatomic, strong) RACSignal *forgetPasswordSignal;

@end

@implementation LaunchView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initSubviews];
        [self makeConstraints];
    }
    return self;
}

- (void)initSubviews {
    _backgroundImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setImage:[UIImage imageNamed:@"launchBackground"]];
        
        imageView;
    });
    _loginButton = ({
        UIButton *btn = [[UIButton alloc] init];
        btn.layer.cornerRadius = 21.0;
        btn.backgroundColor = C_66A7FE;
        [btn setTitle:@"登录" forState:UIControlStateNormal];
        [btn.titleLabel setTextColor:[UIColor whiteColor]];
        [btn.titleLabel setFont:S16];
        _loginSignal = [btn rac_signalForControlEvents:UIControlEventTouchDown];
        
        btn;
    });
    _forgetPasswordButton = ({
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [btn.titleLabel setTextColor: [UIColor whiteColor]];
        [btn.titleLabel setFont:S12];
        _forgetPasswordSignal = [btn rac_signalForControlEvents:UIControlEventTouchDown];
        
        btn;
    });
    [self addSubviews:@[_backgroundImageView, _loginButton, _forgetPasswordButton]];
}

- (void)makeConstraints {
    [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(WIDTH - FIT_LENGTH(36.0), FIT_LENGTH(42.0)));
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-FIT_LENGTH(77.0));
    }];
    [_forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-FIT_LENGTH(48.0));
        make.centerX.equalTo(self);
    }];
}

@end
