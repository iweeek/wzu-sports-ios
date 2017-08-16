//
//  VerificationCodeView.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/2.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "VerificationCodeView.h"
#import "LoginTextView.h"

@interface VerificationCodeView ()

@property (nonatomic, strong) LoginTextView *txtCode;
@property (nonatomic, strong) UIButton *btnSubmit;


@end

@implementation VerificationCodeView

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
    self.txtCode = [[LoginTextView alloc] init];
    [self.txtCode initWithTitle:@"验证码"
                     placeholder:@"请输入验证码"
                            hint:@""
                    showClearBtn:YES];
    [self.txtCode setSecureTextEntry:NO showEyeBtn:NO];
    [self.txtCode setHint:@"" showHint:NO];
    
    [self addSubview:self.txtCode];
    [self addSubview:self.btnSubmit];
    
    [self.txtCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(90);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(70);
        make.right.mas_equalTo(-20);
    }];
    [self.btnSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.txtCode.mas_bottom).offset(15);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(45);
    }];
    
}

- (UIButton *)btnSubmit {
    if (!_btnSubmit) {
        _btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnSubmit setTitle:@"下一步" forState:UIControlStateNormal];
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
