//
//  ApproveItemCell.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/3.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "ApproveItemCell.h"

@interface ApproveItemCell ()

@property (nonatomic, strong) UIView *viewWhite;
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labDesc;
@property (nonatomic, strong) UIView  *viewStatus;
@property (nonatomic, strong) UILabel *labStatus;
@property (nonatomic, strong) UILabel *labDate;
@property (nonatomic, strong) UIView  *spliteLine;

@end

@implementation ApproveItemCell

- (void)createUI {
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    self.contentView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [self.contentView addSubview:self.viewWhite];
    [self.viewWhite addSubview:self.img];
    [self.viewWhite addSubview:self.labTitle];
    [self.viewWhite addSubview:self.labDesc];
    [self.viewWhite addSubview:self.spliteLine];
    [self.viewWhite addSubview:self.viewStatus];
    [self.viewWhite addSubview:self.labStatus];
    [self.viewWhite addSubview:self.labDate];
}

- (void)layout {
    [self.viewWhite mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(7);
        make.right.mas_equalTo(-7);
        make.bottom.mas_equalTo(0);
    }];
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.viewWhite).offset(13);
        make.left.mas_equalTo(self.viewWhite).offset(12);
        make.size.mas_equalTo(CGSizeMake(56, 56));
    }];
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.img);
        make.left.mas_equalTo(self.img.mas_right).offset(10);
    }];
    [self.labDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.img.mas_bottom);
        make.left.mas_equalTo(self.labTitle);
        make.right.mas_equalTo(self.viewWhite.mas_right).offset(-10);
    }];
    [self.spliteLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.img.mas_bottom).offset(12);
        make.left.mas_equalTo(self.viewWhite);
        make.right.mas_equalTo(self.viewWhite);
        make.height.mas_equalTo(1);
    }];
    [self.viewStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.spliteLine).offset(18);
        make.left.mas_equalTo(self.img);
        make.size.mas_equalTo(CGSizeMake(8, 8));
    }];
    [self.labStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.viewStatus);
        make.left.mas_equalTo(self.viewStatus.mas_right).offset(4);
    }];
    [self.labDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.viewStatus);
        make.right.mas_equalTo(-10);
    }];
}

- (UIView *)viewWhite {
    if (!_viewWhite) {
        _viewWhite = [[UIImageView alloc] init];
        _viewWhite.backgroundColor = cFFFFFF;
    }
    return _viewWhite;
}

- (UIImageView *)img {
    if (!_img) {
        _img = [[UIImageView alloc] init];
        _img.layer.cornerRadius = 10;
        _img.layer.masksToBounds = YES;
        _img.backgroundColor = cSpliteLine;
    }
    return _img;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.font = S15;
        _labTitle.numberOfLines = 0;
        _labTitle.textAlignment = NSTextAlignmentLeft;
        _labTitle.textColor = c474A4F;
        _labTitle.text = @"忘打卡";
    }
    return _labTitle;
}

- (UILabel *)labDesc {
    if (!_labDesc) {
        _labDesc = [[UILabel alloc] init];
        _labDesc.font = S12;
        _labDesc.numberOfLines = 2;
        _labDesc.textAlignment = NSTextAlignmentLeft;
        _labDesc.textColor = c7E848C;
        _labDesc.text = @"说明：这是因为产品BUG导致的不能打卡而申请的审批记录。忘上级机关批准，如果审批理由超过一个星期";
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

- (UIView *)viewStatus {
    if (!_viewStatus) {
        _viewStatus = [[UIImageView alloc] init];
        _viewStatus.layer.cornerRadius = 4;
        _viewStatus.layer.masksToBounds = YES;
        _viewStatus.backgroundColor = c57FFDA;
    }
    return _viewStatus;
}

- (UILabel *)labStatus {
    if (!_labStatus) {
        _labStatus = [[UILabel alloc] init];
        _labStatus.font = S13;
        _labStatus.numberOfLines = 0;
        _labStatus.textAlignment = NSTextAlignmentLeft;
        _labStatus.textColor = c7E848C;
        _labStatus.text = @"通过";
    }
    return _labStatus;
}

- (UILabel *)labDate {
    if (!_labDate) {
        _labDate = [[UILabel alloc] init];
        _labDate.font = S12;
        _labDate.numberOfLines = 0;
        _labDate.textAlignment = NSTextAlignmentRight;
        _labDate.textColor = cBBBFC4;
        _labDate.text = @"2016-12-12 16:00";
    }
    return _labDate;
}


@end
