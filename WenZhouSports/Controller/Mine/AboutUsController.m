//
//  AboutUsController.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/11.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "AboutUsController.h"

@interface AboutUsController ()

@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labDesc;

@end

@implementation AboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    self.view.backgroundColor = cFFFFFF;
    [self.view addSubview:self.labTitle];
    [self.view addSubview:self.labDesc];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64 + 20);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.labDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labTitle.mas_bottom).offset(15);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.font = SS(16);
        _labTitle.numberOfLines = 0;
        _labTitle.textAlignment = NSTextAlignmentCenter;
        _labTitle.textColor = c474A4F;
        _labTitle.text = @"关于我们";
    }
    return _labTitle;
}

- (UILabel *)labDesc {
    if (!_labDesc) {
        _labDesc = [[UILabel alloc] init];
        _labDesc.font = S14;
        _labDesc.numberOfLines = 0;
        _labDesc.textAlignment = NSTextAlignmentLeft;
        _labDesc.textColor = c474A4F;
        _labDesc.text = @"";
    }
    return _labDesc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
