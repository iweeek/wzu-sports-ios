//
//  HomeItemCell.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/1.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "HomeItemCell.h"
#import "runningProjectItemModel.h"

@interface HomeItemCell ()

@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) UILabel *labSportsType;
@property (nonatomic, strong) UILabel *labPersonCount;
@property (nonatomic, strong) UILabel *labTitleDistance;
@property (nonatomic, strong) UILabel *labTitleSpeed;
@property (nonatomic, strong) UILabel *labTitleTime;
@property (nonatomic, strong) UILabel *labDistance;
@property (nonatomic, strong) UILabel *labSpeed;
@property (nonatomic, strong) UILabel *labTime;

@end

@implementation HomeItemCell

- (void)initWithSportsType:(SportsType)type
                      data:(id)data {
    switch (type) {
        case SportsTypeJogging:
            [self.img setImage:[UIImage imageNamed:@"bg_jogging"]];
            break;
        case SportsTypeRun:
            [self.img setImage:[UIImage imageNamed:@"bg_run"]];
            break;
        case SportsTypeWalk:
            [self.img setImage:[UIImage imageNamed:@"bg_walking"]];
            break;
        case SportsTypeStep:
            [self.img setImage:[UIImage imageNamed:@"bg_step"]];
            break;
        default:
            break;
    }
    
    runningProjectItemModel *item = (runningProjectItemModel *)data;
    
    NSDictionary *attribute = @{NSFontAttributeName : S10,
                                 NSForegroundColorAttributeName : cFFFFFF};
    
    NSString *qualifiedDistance = [NSString stringWithFormat:@"%ld 米", item.qualifiedDistance];
    NSString *qualifiedCostTime = [NSString stringWithFormat:@"%ld 分钟", item.qualifiedCostTime / 60];
    NSString *speed = @"0 米/秒";
    if (item.qualifiedCostTime > 0) {
        float sp = item.qualifiedDistance * 1.0 / item.qualifiedCostTime;
        speed = [NSString stringWithFormat:@"%.1f 米/秒", sp];
    }
    
    NSMutableAttributedString *qualifiedDistanceAttributedString = [[NSMutableAttributedString alloc] initWithString:qualifiedDistance];
    NSMutableAttributedString *qualifiedCostTimeAttributedString = [[NSMutableAttributedString alloc] initWithString:qualifiedCostTime];
    NSMutableAttributedString *speedAttributedString = [[NSMutableAttributedString alloc] initWithString:speed];
    
    [qualifiedDistanceAttributedString addAttributes:attribute range:NSMakeRange(qualifiedDistanceAttributedString.length - 1, 1)];
    [qualifiedCostTimeAttributedString addAttributes:attribute range:NSMakeRange(qualifiedCostTimeAttributedString.length - 2, 2)];
    [speedAttributedString addAttributes:attribute range:NSMakeRange(speedAttributedString.length - 3, 3)];
    
    self.labSportsType.text = item.name;
    self.labDistance.attributedText = qualifiedDistanceAttributedString;
    self.labTime.attributedText = qualifiedCostTimeAttributedString;
    self.labSpeed.attributedText = speedAttributedString;
}

- (void)setupPersonCount:(int)count {
    self.labPersonCount.text = [NSString stringWithFormat:@"%d人正在参加", count];
}

- (void)createUI {
    [self.contentView addSubview:self.img];
    [self.contentView addSubview:self.labSportsType];
    [self.contentView addSubview:self.labPersonCount];
    [self.contentView addSubview:self.labTitleDistance];
    [self.contentView addSubview:self.labTitleSpeed];
    [self.contentView addSubview:self.labTitleTime];
    [self.contentView addSubview:self.labDistance];
    [self.contentView addSubview:self.labSpeed];
    [self.contentView addSubview:self.labTime];
}

- (void)layout {
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-1);
        make.right.mas_equalTo(0);
    }];
    [self.labSportsType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(20);
    }];
    [self.labPersonCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labSportsType.mas_bottom).offset(10);
        make.left.mas_equalTo(self.labSportsType);
    }];
    [self.labTitleDistance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-35);
        make.left.mas_equalTo(self.labSportsType);
    }];
    [self.labDistance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labTitleDistance.mas_bottom).offset(8);
        make.left.mas_equalTo(self.labTitleDistance);
    }];
    [self.labTitleTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labTitleDistance);
        make.centerX.mas_equalTo(0);
    }];
    [self.labTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labDistance);
        make.centerX.mas_equalTo(0);
    }];
    [self.labTitleSpeed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labTitleDistance);
        make.right.mas_equalTo(-20);
    }];
    [self.labSpeed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labDistance);
        make.right.mas_equalTo(self.labTitleSpeed.mas_right);
    }];
}

- (UIImageView *)img {
    if (!_img) {
        _img = [[UIImageView alloc] init];
    }
    return _img;
}

- (UILabel *)labSportsType {
    if (!_labSportsType) {
        _labSportsType = [[UILabel alloc] init];
        _labSportsType.font = S(25);
        _labSportsType.numberOfLines = 0;
        _labSportsType.textAlignment = NSTextAlignmentLeft;
        _labSportsType.textColor = cFFFFFF;
        _labSportsType.text = @"随机慢跑";
    }
    return _labSportsType;
}

- (UILabel *)labPersonCount {
    if (!_labPersonCount) {
        _labPersonCount = [[UILabel alloc] init];
        _labPersonCount.font = S13;
        _labPersonCount.numberOfLines = 0;
        _labPersonCount.textAlignment = NSTextAlignmentLeft;
        _labPersonCount.textColor = cFFFFFF;
        _labPersonCount.text = @"50人正在参加";
    }
    return _labPersonCount;
}

- (UILabel *)labTitleDistance {
    if (!_labTitleDistance) {
        _labTitleDistance = [[UILabel alloc] init];
        _labTitleDistance.font = S10;
        _labTitleDistance.numberOfLines = 0;
        _labTitleDistance.textAlignment = NSTextAlignmentLeft;
        _labTitleDistance.textColor = cFFFFFF;
        _labTitleDistance.text = @"达标距离";
    }
    return _labTitleDistance;
}

- (UILabel *)labDistance {
    if (!_labDistance) {
        _labDistance = [[UILabel alloc] init];
        _labDistance.font = S17;
        _labDistance.numberOfLines = 0;
        _labDistance.textAlignment = NSTextAlignmentLeft;
        _labDistance.textColor = cFFFFFF;
        _labDistance.text = @"600 米";
    }
    return _labDistance;
}

- (UILabel *)labTitleTime {
    if (!_labTitleTime) {
        _labTitleTime = [[UILabel alloc] init];
        _labTitleTime.font = S10;
        _labTitleTime.numberOfLines = 0;
        _labTitleTime.textAlignment = NSTextAlignmentCenter;
        _labTitleTime.textColor = cFFFFFF;
        _labTitleTime.text = @"达标时间";
    }
    return _labTitleTime;
}

- (UILabel *)labTime {
    if (!_labTime) {
        _labTime = [[UILabel alloc] init];
        _labTime.font = S17;
        _labTime.numberOfLines = 0;
        _labTime.textAlignment = NSTextAlignmentCenter;
        _labTime.textColor = cFFFFFF;
        _labTime.text = @"60 分钟";
    }
    return _labTime;
}

- (UILabel *)labTitleSpeed {
    if (!_labTitleSpeed) {
        _labTitleSpeed = [[UILabel alloc] init];
        _labTitleSpeed.font = S10;
        _labTitleSpeed.numberOfLines = 0;
        _labTitleSpeed.textAlignment = NSTextAlignmentRight;
        _labTitleSpeed.textColor = cFFFFFF;
        _labTitleSpeed.text = @"达标速度";
    }
    return _labTitleSpeed;
}

- (UILabel *)labSpeed {
    if (!_labSpeed) {
        _labSpeed = [[UILabel alloc] init];
        _labSpeed.font = S17;
        _labSpeed.numberOfLines = 0;
        _labSpeed.textAlignment = NSTextAlignmentRight;
        _labSpeed.textColor = cFFFFFF;
        _labSpeed.text = @"1 米/秒";
    }
    return _labSpeed;
}

@end
