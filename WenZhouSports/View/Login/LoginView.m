//
//  LoginNewView.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/2.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "LoginView.h"

@interface LoginView ()

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
    
    // 大学
    self.txtUniversityName = [[LoginTextView alloc] init];
    [self.txtUniversityName initWithTitle:@"学校"
                              placeholder:@"请选择您当前就读学校"
                                     hint:@""
                             showClearBtn:NO];
    [self.txtUniversityName changeTextEnabled:NO];
    self.signalDidBeginEditing = self.txtUniversityName.signalDidBeginEditing;
    
    // 学号
    self.txtUserName = [[LoginTextView alloc] init];
    [self.txtUserName initWithTitle:@"学号"
                        placeholder:@"请输入您的学号"
                               hint:@""
                       showClearBtn:YES];
    [self.txtUserName setSecureTextEntry:NO showEyeBtn:NO];
    [self.txtUserName setHint:@"请输入用户名" showHint:NO];
    [self.txtUserName.signalTextChanged subscribeNext:^(id  _Nullable x) {
        UITextField *txt = x;
        self.username = txt.text;
        NSLog(@"username:%@",txt.text);
    }];
    
    //密码
    self.txtPassword = [[LoginTextView alloc] init];
    [self.txtPassword initWithTitle:@"密码"
                        placeholder:@"请输入6~16位密码"
                               hint:@""
                       showClearBtn:YES];
    [self.txtPassword setSecureTextEntry:YES showEyeBtn:YES];
    [self.txtPassword setHint:@"请输入密码" showHint:NO];
    [self.txtPassword.signalTextChanged subscribeNext:^(id  _Nullable x) {
        UITextField *txt = x;
        self.password = txt.text;
        NSLog(@"txtPassword:%@",txt.text);
    }];
    
    [self addSubview:self.txtUniversityName];
    [self addSubview:self.txtUserName];
    [self addSubview:self.txtPassword];
    [self addSubview:self.btnSubmit];
    [self addSubview:self.btnForgetPassword];
    
    [self.txtUniversityName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(70);
        make.right.mas_equalTo(-20);
    }];
    [self.txtUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.txtUniversityName.mas_bottom).offset(10);
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
        [_btnForgetPassword setTitle:@"新用户激活" forState:UIControlStateNormal];
        _btnForgetPassword.titleLabel.font = S12;
        [_btnForgetPassword setTitleColor:cFFFFFF forState:UIControlStateNormal];
        
        self.signalForgetPassword = [_btnForgetPassword rac_signalForControlEvents:UIControlEventTouchUpInside];
    }
    return _btnForgetPassword;
}

@end
