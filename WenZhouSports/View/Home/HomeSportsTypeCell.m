//
//  HomeSportsTypeCell.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/2.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "HomeSportsTypeCell.h"

@interface HomeSportsTypeCell ()

@property (nonatomic, strong) UILabel *labTitle;

@end

@implementation HomeSportsTypeCell

- (void)createUI {
    [self.contentView addSubview:self.labTitle];
}

- (void)layout {
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.font = S15;
        _labTitle.numberOfLines = 0;
        _labTitle.textColor = c474A4F;
        _labTitle.text = @"运动方式选择";
    }
    return _labTitle;
}

@end
