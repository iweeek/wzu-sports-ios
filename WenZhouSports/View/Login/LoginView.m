//
//  LoginNewView.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/2.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "LoginView.h"
#import "LoginTextView.h"

@interface LoginView ()

@property (nonatomic, strong) LoginTextView *txtUserName;
@property (nonatomic, strong) LoginTextView *txtPassword;
@property (nonatomic, strong) UIButton *btnSubmit;
@property (nonatomic, strong) UIButton *btnForgetPassword;

@end

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.backgroundColor = c66A7FE;
    
    // 学号
    self.txtUserName = [[LoginTextView alloc] init];
    [self.txtUserName initWithTitle:@"学号"
                        placeholder:@"请输入您的学号"
                               hint:@""
                       showClearBtn:YES];
    [self.txtUserName setSecureTextEntry:NO showEyeBtn:NO];
    [self.txtUserName setHint:@"请输入用户名" isShowHint:NO];
    
    //密码
    self.txtPassword = [[LoginTextView alloc] init];
    [self.txtPassword initWithTitle:@"密码"
                        placeholder:@"请输入6~16位密码"
                               hint:@""
                       showClearBtn:YES];
    [self.txtPassword setSecureTextEntry:YES showEyeBtn:YES];
    [self.txtPassword setHint:@"请输入密码" isShowHint:NO];
    
    [self addSubview:self.txtUserName];
    [self addSubview:self.txtPassword];
    [self addSubview:self.btnSubmit];
    [self addSubview:self.btnForgetPassword];
    
    [self.txtUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(90);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(70);
        make.right.mas_equalTo(-20);
    }];
    [self.txtPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.txtUserName.mas_bottom).offset(10);
        make.left.mas_equalTo(self.txtUserName);
        make.height.mas_equalTo(self.txtUserName);
        make.right.mas_equalTo(self.txtUserName.mas_right);
    }];
    [self.btnSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.txtPassword.mas_bottom).offset(30);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(45);
    }];
    [self.btnForgetPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.btnSubmit.mas_bottom).offset(20);
        make.centerX.mas_equalTo(0);
    }];
}

- (UIButton *)btnSubmit {
    if (!_btnSubmit) {
        _btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnSubmit setTitle:@"登录" forState:UIControlStateNormal];
        _btnSubmit.titleLabel.font = S18;
        _btnSubmit.layer.cornerRadius = 22;
        _btnSubmit.layer.masksToBounds = YES;
        _btnSubmit.backgroundColor = cFFFFFF;
        [_btnSubmit setTitleColor:c535353 forState:UIControlStateNormal];
        
        self.signalSubmit = [_btnSubmit rac_signalForControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSubmit;
}

- (UIButton *)btnForgetPassword {
    if (!_btnForgetPassword) {
        _btnForgetPassword = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnForgetPassword setTitle:@"忘记密码" forState:UIControlStateNormal];
        _btnForgetPassword.titleLabel.font = S12;
        [_btnForgetPassword setTitleColor:cFFFFFF forState:UIControlStateNormal];
        
        self.signalForgetPassword = [_btnForgetPassword rac_signalForControlEvents:UIControlEventTouchUpInside];
    }
    return _btnForgetPassword;
}

@end
