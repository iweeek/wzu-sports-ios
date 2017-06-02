//
//  ForgetPasswordController.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/2.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "ForgetPasswordController.h"
#import "ForgetPasswordView.h"
#import "VerificationCodeController.h"

@interface ForgetPasswordController ()

@property (nonatomic, strong) ForgetPasswordView *forgetPasswordView;

@end

@implementation ForgetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    self.forgetPasswordView = [[ForgetPasswordView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.forgetPasswordView];
    
    [self reactiveEvent];
}

- (void)reactiveEvent {
    @weakify(self);
    [self.forgetPasswordView.signalSubmit subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        VerificationCodeController *vc = [[VerificationCodeController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
