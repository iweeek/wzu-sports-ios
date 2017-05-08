//
//  ForgetPasswordController.m
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/4.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "ForgetPasswordController.h"
#import "ForgetPasswordView.h"
#import "HomeController.h"

@interface ForgetPasswordController ()

@property (nonatomic, strong) ForgetPasswordView *forgetPasswordView;

@end

@implementation ForgetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
}

- (void)initSubviews {
    //status 表示状态，0：输入手机号 1：输入验证码 2：输入新密码
    __block int status = 0;
    _forgetPasswordView = [[ForgetPasswordView alloc] init];
    [self.view addSubview:_forgetPasswordView];
    [_forgetPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    HomeController *homeController = [[HomeController alloc] init];
    @weakify(self);
    [self.forgetPasswordView.nextSignal subscribeNext:^(id x) {
        @strongify(self)
        switch (status) {
            case 0:
#warning verify phoneNumber
                if ([self.forgetPasswordView.getStringOfTextField isEqualToString:@""]) {
                    [WToast showWithText:@"请输入手机号"];
                }
                [self.forgetPasswordView setLabel:@"验证码" textView:@"请输入验证码" button:@"下一步"];
                break;
            case 1:
#warning verify code
                [self.forgetPasswordView setLabel:@"新密码" textView:@"请输入6-16位密码" button:@"提交"];
                [self.forgetPasswordView setShowPassword:YES];
                break;
            case 2:
#warning verrify new password
                [self.navigationController  pushViewController:homeController animated:YES];
                break;
            default:
                break;
        }
        status++;
    }];
}

@end
