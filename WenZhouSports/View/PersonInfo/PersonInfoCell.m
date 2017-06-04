//
//  PersonInfoCell.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/3.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "PersonInfoCell.h"

@interface PersonInfoCell ()

@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UIView *spliteLine;
@property (nonatomic, strong) UILabel *labHint;

@end

@implementation PersonInfoCell

- (void)setupWithData:(id)data {
    self.labTitle.text = @"身高";
    self.labHint.text = @"175cm";
}

- (void)createUI {
    [self.contentView addSubview:self.labTitle];
    [self.contentView addSubview:self.labHint];
    [self.contentView addSubview:self.spliteLine];
}

- (void)layout {
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(20);
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
