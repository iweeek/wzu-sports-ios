//
//  LoginNewController.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/2.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "LoginController.h"
#import "LoginView.h"
#import "ForgetPasswordController.h"

@interface LoginController ()

@property (nonatomic, strong) LoginView *loginView;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginView = [[LoginView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.loginView];
    [self reactiveEvent];
    // Do any additional setup after loading the view.
}

- (void)reactiveEvent {
    @weakify(self);
    [self.loginView.signalSubmit subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        ForgetPasswordController *vc = [[ForgetPasswordController alloc] init];
        vc.title = @"修改初始密码";
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.loginView.signalForgetPassword subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        ForgetPasswordController *vc = [[ForgetPasswordController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
