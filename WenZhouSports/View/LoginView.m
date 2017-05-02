//
//  LoginView.m
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/2.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "LoginView.h"

@interface LoginView ()

@property (nonatomic, strong) UIImageView *logo;
@property (nonatomic, strong) UIImageView *accountLogo;
@property (nonatomic, strong) UITextField *account;
@property (nonatomic, strong) UIImageView *passwordLogo;
@property (nonatomic, strong) UITextField *password;
@property (nonatomic, strong) UIButton *login;
@property (nonatomic, strong) UIButton *forgetPassword;

@end

@implementation LoginView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initSubviews];
        [self makeConstraints];
    }
    return self;
}

- (void)initSubviews {
    _logo = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        
        imageView;
    });
    _accountLogo = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        
        imageView;
    });
    _account = ({
        UITextField *text = [[UITextField alloc] init];
        
        text;
    });
    _passwordLogo = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        
        imageView;
    });
    _password = ({
        UITextField *text = [[UITextField alloc] init];
        
        text;
    });
    _login = ({
        UIButton *btn = [[UIButton alloc] init];
        
        btn;
    });
    _forgetPassword = ({
        UIButton *btn = [[UIButton alloc] init];
        
        btn;
    });
    
    [self addSubviews:@[_logo, _accountLogo, _account, _password,
                        _passwordLogo, _login, _forgetPassword]];
}

- (void)makeConstraints {
    
}

@end
