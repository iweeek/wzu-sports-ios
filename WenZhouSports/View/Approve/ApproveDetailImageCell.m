//
//  ApproveDetailImageCell.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/12.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "ApproveDetailImageCell.h"

@interface ApproveDetailImageCell ()

@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation ApproveDetailImageCell

- (void)createUI {
    [self.contentView addSubview:self.labTitle];
    [self.contentView addSubview:self.imgView];
}

- (void)layout {
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(20);
    }];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labTitle.mas_bottom).offset(13);
        make.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(59, 59));
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
        _labTitle.text = @"已上传截图";
    }
    return _labTitle;
}


@end
