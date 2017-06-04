//
//  HomeRankCell.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/2.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "HomeRankCell.h"

@interface HomeRankCell ()

@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) UIImageView *imgArrows;
@property (nonatomic, strong) UILabel *labTitle;

@end

@implementation HomeRankCell


- (void)createUI {
    [self.contentView addSubview:self.imgArrows];
    [self.contentView addSubview:self.img];
    [self.contentView addSubview:self.labTitle];
}

- (void)layout {
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(18, 18));
        make.centerY.mas_equalTo(0);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.img.mas_right).offset(7);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.imgArrows mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(8, 13));
        make.centerY.mas_equalTo(0);
    }];
}


- (UIImageView *)img {
    if (!_img) {
        _img = [[UIImageView alloc] init];
        [_img setImage:[UIImage imageNamed:@"icon_charts"]];
    }
    return _img;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.font = S10;
        _labTitle.numberOfLines = 0;
        _labTitle.textColor = c999999;
        _labTitle.text = @"校园排行榜";
    }
    return _labTitle;
}

- (UIImageView *)imgArrows {
    if (!_imgArrows) {
        _imgArrows = [[UIImageView alloc] init];
        [_imgArrows setImage:[UIImage imageNamed:@"icon_right_arrow"]];
    }
    return _imgArrows;
}

@end
