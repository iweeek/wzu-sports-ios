//
//  VerificationCodeController.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/2.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "VerificationCodeController.h"
#import "VerificationCodeView.h"

@interface VerificationCodeController ()

@property (nonatomic, strong) VerificationCodeView * verificationCodeView;

@end

@implementation VerificationCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    self.verificationCodeView = [[VerificationCodeView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.verificationCodeView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
