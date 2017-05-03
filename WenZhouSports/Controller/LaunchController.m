//
//  LaunchController.m
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/3.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "LaunchController.h"
#import "LaunchView.h"
#import "LoginController.h"

@interface LaunchController ()

@property (nonatomic, strong) LaunchView *launchView;

@end

@implementation LaunchController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)initSubviews {
    _launchView = [[LaunchView alloc] init];
    [self.view addSubviews:@[_launchView]];
    [_launchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    @weakify(self);
    [_launchView.loginSignal subscribeNext:^(id x) {
        log(@"%@", x);
        @strongify(self)
        LoginController *loginController = [[LoginController alloc] init];
        [self.navigationController pushViewController:loginController animated:YES];
    }];
}

@end
