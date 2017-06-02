//
//  SportsPerformanceCell.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/3.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "SportsPerformanceCell.h"

@interface SportsPerformanceCell ()

@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labSubTitle;
@property (nonatomic, strong) UIView *spliteLine;
@property (nonatomic, strong) UILabel *labHint;

@end

@implementation SportsPerformanceCell

- (void)setupWithData:(id)data {
    self.labTitle.text = @"50米";
    self.labSubTitle.text = @"成绩:8秒";
    self.labHint.text = @"得分:80";
}

- (void)createUI {
    [self.contentView addSubview:self.labTitle];
    [self.contentView addSubview:self.labSubTitle];
    [self.contentView addSubview:self.labHint];
    [self.contentView addSubview:self.spliteLine];
}

- (void)layout {
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(20);
    }];
    [self.labSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.labTitle.mas_right).offset(30);
    }];
    [self.labHint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-20);
    }];
    [self.spliteLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(0);
    }];
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.font = S15;
        _labTitle.numberOfLines = 0;
        _labTitle.textColor = c474A4F;
        _labTitle.text = @"";
    }
    return _labTitle;
}

- (UILabel *)labSubTitle {
    if (!_labSubTitle) {
        _labSubTitle = [[UILabel alloc] init];
        _labSubTitle.font = S14;
        _labSubTitle.numberOfLines = 0;
        _labSubTitle.textColor = c474A4F;
        _labSubTitle.text = @"";
    }
    return _labSubTitle;
}

- (UILabel *)labHint {
    if (!_labHint) {
        _labHint = [[UILabel alloc] init];
        _labHint.font = S15;
        _labHint.numberOfLines = 0;
        _labHint.textColor = c474A4F;
        _labHint.text = @"";
    }
    return _labHint;
}

- (UIView *)spliteLine {
    if (!_spliteLine) {
        _spliteLine = [[UIView alloc] init];
        _spliteLine.backgroundColor = cSpliteLine;
    }
    return _spliteLine;
}


@end
