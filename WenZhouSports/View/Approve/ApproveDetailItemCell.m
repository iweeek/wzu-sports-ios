//
//  ApproveDetailItemCell.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/12.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "ApproveDetailItemCell.h"

@interface ApproveDetailItemCell ()

@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labDesc;
@property (nonatomic, strong) UIView *spliteLine;;

@end

@implementation ApproveDetailItemCell

- (void)createUI {
    [self.contentView addSubview:self.labTitle];
    [self.contentView addSubview:self.labDesc];
    [self.contentView addSubview:self.spliteLine];
}

- (void)layout {
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(20);
    }];
    [self.labDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-20);
    }];
    [self.spliteLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(1);
    }];
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.font = S12;
        _labTitle.numberOfLines = 0;
        _labTitle.textAlignment = NSTextAlignmentLeft;
        _labTitle.textColor = c7E848C;
        _labTitle.text = @"申请审批理由";
    }
    return _labTitle;
}

- (UILabel *)labDesc {
    if (!_labDesc) {
        _labDesc = [[UILabel alloc] init];
        _labDesc.font = S13;
        _labDesc.numberOfLines = 2;
        _labDesc.textAlignment = NSTextAlignmentLeft;
        _labDesc.textColor = c474A4F;
        _labDesc.text = @"产品BUG";
    }
    return _labDesc;
}

- (UIView *)spliteLine {
    if (!_spliteLine) {
        _spliteLine = [[UIView alloc] init];
        _spliteLine.backgroundColor = cSpliteLine;
    }
    return _spliteLine;
}

@end
