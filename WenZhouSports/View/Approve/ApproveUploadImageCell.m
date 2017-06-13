//
//  ApproveUploadImageCell.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/12.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "ApproveUploadImageCell.h"

@interface ApproveUploadImageCell ()

@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *labDesc;

@end

@implementation ApproveUploadImageCell

- (void)createUI {
    [self.contentView addSubview:self.labTitle];
    [self.contentView addSubview:self.labDesc];
    [self.contentView addSubview:self.imgView];
}

- (void)layout {
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.left.mas_equalTo(20);
    }];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labTitle.mas_bottom).offset(13);
        make.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(59, 59));
    }];
    [self.labDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imgView.mas_bottom).offset(11);
        make.left.mas_equalTo(self.labTitle);
    }];
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.layer.cornerRadius = 10;
        _imgView.layer.masksToBounds = YES;
        _imgView.backgroundColor = cSpliteLine;
    }
    return _imgView;
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
        _labDesc.font = S12;
        _labDesc.numberOfLines = 2;
        _labDesc.textAlignment = NSTextAlignmentLeft;
        _labDesc.textColor = cBBBFC4;
        _labDesc.text = @"产品BUG";
    }
    return _labDesc;
}

@end
