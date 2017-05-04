
//
//  LoginController.m
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/2.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "LoginController.h"
#import "LoginView.h"
#import "ForgetPasswordController.h"
#import "HomeController.h"

@interface LoginController ()

@property (nonatomic, strong) LoginView *loginView;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
}

- (void)initSubviews {
    _loginView = [[LoginView alloc] init];
    [self.view addSubviews:@[_loginView]];
    [_loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    @weakify(self);
    [self.loginView.forgetPasswordSignal subscribeNext:^(id x) {
        @strongify(self)
        ForgetPasswordController *controller = [[ForgetPasswordController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }];
    [self.loginView.loginSignal subscribeNext:^(id  _Nullable x) {
       @strongify(self)
#warning 登录逻辑
        HomeController *controller = [[HomeController alloc] init];
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:controller];
        [self.navigationController presentViewController:navigation animated:YES completion:nil];
    }];
}


@end
