//
//  ForgetPasswordView.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/2.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "ForgetPasswordView.h"
#import "LoginTextView.h"

@interface ForgetPasswordView ()

@property (nonatomic, strong) LoginTextView *txtPhone;
@property (nonatomic, strong) UIButton *btnSubmit;

@end

@implementation ForgetPasswordView

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
    self.txtPhone = [[LoginTextView alloc] init];
    [self.txtPhone initWithTitle:@"手机号"
                        placeholder:@"请输入您的手机号"
                               hint:@""
                       showClearBtn:YES];
    [self.txtPhone setSecureTextEntry:NO showEyeBtn:NO];
    [self.txtPhone setHint:@"" isShowHint:NO];
    
    [self addSubview:self.txtPhone];
    [self addSubview:self.btnSubmit];
    
    [self.txtPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(90);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(70);
        make.right.mas_equalTo(-20);
    }];
    [self.btnSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.txtPhone.mas_bottom).offset(15);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(45);
    }];

}

- (UIButton *)btnSubmit {
    if (!_btnSubmit) {
        _btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnSubmit setTitle:@"获取验证码" forState:UIControlStateNormal];
        _btnSubmit.titleLabel.font = S18;
        _btnSubmit.layer.cornerRadius = 22;
        _btnSubmit.layer.masksToBounds = YES;
        _btnSubmit.backgroundColor = cFFFFFF;
        [_btnSubmit setTitleColor:c535353 forState:UIControlStateNormal];
        
        self.signalSubmit = [_btnSubmit rac_signalForControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSubmit;
}

@end
