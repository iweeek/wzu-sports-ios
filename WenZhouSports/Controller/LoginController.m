
//
//  LoginController.m
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/2.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "LoginController.h"
#import "LoginView.h"

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
}


@end
