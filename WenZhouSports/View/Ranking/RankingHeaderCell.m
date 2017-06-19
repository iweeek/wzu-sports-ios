//
//  RankingHeaderCell.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/18.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "RankingHeaderCell.h"
#import "StudentTimeCostedModel.h"

@interface RankingHeaderCell ()

@property (nonatomic, strong) UIImageView *imgAvatarLeft;
@property (nonatomic, strong) UIImageView *imgAvatarCenter;
@property (nonatomic, strong) UIImageView *imgAvatarRight;

@property (nonatomic, strong) UIImageView *imgNumLeft;
@property (nonatomic, strong) UIImageView *imgNumCenter;
@property (nonatomic, strong) UIImageView *imgNumRight;

@property (nonatomic, strong) UILabel *labNameLeft;
@property (nonatomic, strong) UILabel *labNameCenter;
@property (nonatomic, strong) UILabel *labNameRight;

@property (nonatomic, strong) UILabel *labDescLeft;
@property (nonatomic, strong) UILabel *labDescCenter;
@property (nonatomic, strong) UILabel *labDescRight;

@end

@implementation RankingHeaderCell

- (void)setupWithData:(id)data {
    NSArray<StudentTimeCostedModel *> *array = data;
    StudentTimeCostedModel *model1 = array[0];
    StudentTimeCostedModel *model2 = array[1];
    StudentTimeCostedModel *model3 = array[2];
    
    [self.imgAvatarLeft sd_setImageWithURL:[NSURL URLWithString:model2.avatarUrl] placeholderImage:[UIImage imageNamed:@"icon_item_avatar"]];
    [self.imgAvatarRight sd_setImageWithURL:[NSURL URLWithString:model3.avatarUrl] placeholderImage:[UIImage imageNamed:@"icon_item_avatar"]];
    [self.imgAvatarCenter sd_setImageWithURL:[NSURL URLWithString:model1.avatarUrl] placeholderImage:[UIImage imageNamed:@"icon_item_avatar"]];
    
    self.labNameLeft.text = model2.studentName;
    self.labNameCenter.text = model1.studentName;
    self.labNameRight.text = model3.studentName;
    
    self.labDescLeft.text = @"2313 千卡";
    self.labDescCenter.text = @"2313 千卡";
    self.labDescRight.text = @"2313 千卡";
}

- (void)createUI {
    [self.contentView addSubview:self.imgAvatarLeft];
    [self.contentView addSubview:self.imgAvatarCenter];
    [self.contentView addSubview:self.imgAvatarRight];
    
    [self.contentView addSubview:self.imgNumLeft];
    [self.contentView addSubview:self.imgNumCenter];
    [self.contentView addSubview:self.imgNumRight];
    
    [self.contentView addSubview:self.labNameLeft];
    [self.contentView addSubview:self.labNameCenter];
    [self.contentView addSubview:self.labNameRight];
    
    [self.contentView addSubview:self.labDescLeft];
    [self.contentView addSubview:self.labDescCenter];
    [self.contentView addSubview:self.labDescRight];
}

- (void)layout {
    [self.imgAvatarCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(36);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
    [self.imgAvatarLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.imgAvatarCenter.mas_bottom);
        make.left.mas_equalTo(38);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    [self.imgAvatarRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.imgAvatarCenter.mas_bottom);
        make.right.mas_equalTo(-38);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    [self.imgNumLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.mas_equalTo(self.imgAvatarLeft.mas_bottom).offset(-15);
        make.centerX.mas_equalTo(self.imgAvatarLeft);
    }];
    [self.imgNumCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.mas_equalTo(self.imgAvatarCenter.mas_bottom).offset(-20);
        make.centerX.mas_equalTo(self.imgAvatarCenter);
    }];
    [self.imgNumRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.mas_equalTo(self.imgAvatarRight.mas_bottom).offset(-15);
        make.centerX.mas_equalTo(self.imgAvatarRight);
    }];
    
    [self.labNameLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imgNumLeft.mas_bottom).offset(14);
        make.centerX.mas_equalTo(self.imgAvatarLeft);
    }];
    [self.labNameCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.labNameLeft);
        make.centerX.mas_equalTo(self.imgAvatarCenter);
    }];
    [self.labNameRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.labNameLeft);
        make.centerX.mas_equalTo(self.imgAvatarRight);
    }];
    
    [self.labDescLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labNameLeft.mas_bottom).offset(5);
        make.centerX.mas_equalTo(self.imgAvatarLeft);
    }];
    [self.labDescCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.labDescLeft);
        make.centerX.mas_equalTo(self.imgAvatarCenter);
    }];
    [self.labDescRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.labDescLeft);
        make.centerX.mas_equalTo(self.imgAvatarRight);
    }];
}

- (UIImageView *)imgAvatarLeft {
    if (!_imgAvatarLeft) {
        _imgAvatarLeft = [[UIImageView alloc] init];
        _imgAvatarLeft.layer.cornerRadius = 35;
        _imgAvatarLeft.layer.masksToBounds = YES;
    }
    return _imgAvatarLeft;
}

- (UIImageView *)imgAvatarCenter {
    if (!_imgAvatarCenter) {
        _imgAvatarCenter = [[UIImageView alloc] init];
        _imgAvatarCenter.layer.cornerRadius = 45;
        _imgAvatarCenter.layer.masksToBounds = YES;
    }
    return _imgAvatarCenter;
}

- (UIImageView *)imgAvatarRight {
    if (!_imgAvatarRight) {
        _imgAvatarRight = [[UIImageView alloc] init];
        _imgAvatarRight.layer.cornerRadius = 35;
        _imgAvatarRight.layer.masksToBounds = YES;
    }
    return _imgAvatarRight;
}

- (UIImageView *)imgNumLeft {
    if (!_imgNumLeft) {
        _imgNumLeft = [[UIImageView alloc] init];
        _imgNumLeft.layer.cornerRadius = 15;
        _imgNumLeft.layer.masksToBounds = YES;
        [_imgNumLeft setImage:[UIImage imageNamed:@"icon_two"]];
    }
    return _imgNumLeft;
}

- (UIImageView *)imgNumCenter {
    if (!_imgNumCenter) {
        _imgNumCenter = [[UIImageView alloc] init];
        _imgNumCenter.layer.cornerRadius = 20;
        _imgNumCenter.layer.masksToBounds = YES;
        [_imgNumCenter setImage:[UIImage imageNamed:@"icon_one"]];
    }
    return _imgNumCenter;
}

- (UIImageView *)imgNumRight {
    if (!_imgNumRight) {
        _imgNumRight = [[UIImageView alloc] init];
        _imgNumRight.layer.cornerRadius = 15;
        _imgNumRight.layer.masksToBounds = YES;
        [_imgNumRight setImage:[UIImage imageNamed:@"icon_three"]];
    }
    return _imgNumRight;
}

- (UILabel *)labNameLeft {
    if (!_labNameLeft) {
        _labNameLeft = [[UILabel alloc] init];
        _labNameLeft.font = S15;
        _labNameLeft.numberOfLines = 0;
        _labNameLeft.textAlignment = NSTextAlignmentCenter;
        _labNameLeft.textColor = c474A4F;
        _labNameLeft.text = @"";
    }
    return _labNameLeft;
}

- (UILabel *)labNameCenter {
    if (!_labNameCenter) {
        _labNameCenter = [[UILabel alloc] init];
        _labNameCenter.font = S15;
        _labNameCenter.numberOfLines = 0;
        _labNameCenter.textAlignment = NSTextAlignmentCenter;
        _labNameCenter.textColor = c474A4F;
        _labNameCenter.text = @"12";
    }
    return _labNameCenter;
}
- (UILabel *)labNameRight {
    if (!_labNameRight) {
        _labNameRight = [[UILabel alloc] init];
        _labNameRight.font = S15;
        _labNameRight.numberOfLines = 0;
        _labNameRight.textAlignment = NSTextAlignmentCenter;
        _labNameRight.textColor = c474A4F;
        _labNameRight.text = @"";
    }
    return _labNameRight;
}

- (UILabel *)labDescLeft {
    if (!_labDescLeft) {
        _labDescLeft = [[UILabel alloc] init];
        _labDescLeft.font = S10;
        _labDescLeft.numberOfLines = 0;
        _labDescLeft.textAlignment = NSTextAlignmentCenter;
        _labDescLeft.textColor = c474A4F;
        _labDescLeft.text = @"";
    }
    return _labDescLeft;
}

- (UILabel *)labDescCenter {
    if (!_labDescCenter) {
        _labDescCenter = [[UILabel alloc] init];
        _labDescCenter.font = S10;
        _labDescCenter.numberOfLines = 0;
        _labDescCenter.textAlignment = NSTextAlignmentCenter;
        _labDescCenter.textColor = c474A4F;
        _labDescCenter.text = @"";
    }
    return _labDescCenter;
}

- (UILabel *)labDescRight {
    if (!_labDescRight) {
        _labDescRight = [[UILabel alloc] init];
        _labDescRight.font = S10;
        _labDescRight.numberOfLines = 0;
        _labDescRight.textAlignment = NSTextAlignmentCenter;
        _labDescRight.textColor = c474A4F;
        _labDescRight.text = @"";
    }
    return _labDescRight;
}

@end
