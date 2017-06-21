//
//  SportsHistoryHeaderCell.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/1.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "SportsHistoryHeaderCell.h"

@interface SportsHistoryHeaderCell ()

@property (nonatomic, strong) UILabel *labWeek; // 周、月、学期
@property (nonatomic, strong) UILabel *labRemainingCount;// 剩余次数
@property (nonatomic, strong) UILabel *labTargetCount;// 目标次数
@property (nonatomic, strong) UILabel *labCount;// 次数
@property (nonatomic, strong) UILabel *labTitleCalorie;// 卡路里标题
@property (nonatomic, strong) UILabel *labCalorie;// 卡路里标题
@property (nonatomic, strong) UILabel *labTitleTime;// 累计时长
@property (nonatomic, strong) UILabel *labTime;// 累计时长
@property (nonatomic, strong) UIView  *spliteLine;



@end

@implementation SportsHistoryHeaderCell

- (void)setupWithData:(id)data {
    NSDictionary *attribute1 = @{NSFontAttributeName : S10,
                                 NSForegroundColorAttributeName : c7E848C};
    NSDictionary *attribute2 = @{NSFontAttributeName : S10,
                                 NSForegroundColorAttributeName : c474A4F};
    
    NSString *countStr = @"1次";
    NSString *calorieStr = @"1200 千卡";
    NSString *timeStr = @"120 分钟";

    NSMutableAttributedString *countAttributedString = [[NSMutableAttributedString alloc] initWithString:countStr];
    NSMutableAttributedString *calorieAttributedString = [[NSMutableAttributedString alloc] initWithString:calorieStr];
    NSMutableAttributedString *timeAttributedString = [[NSMutableAttributedString alloc] initWithString:timeStr];
    
    [countAttributedString addAttributes:attribute1 range:NSMakeRange(countAttributedString.length - 1, 1)];
    [calorieAttributedString addAttributes:attribute2 range:NSMakeRange(calorieAttributedString.length - 2, 2)];
    [timeAttributedString addAttributes:attribute2 range:NSMakeRange(timeAttributedString.length - 2, 2)];
    
    self.labCount.attributedText = countAttributedString;
    self.labCalorie.attributedText = calorieAttributedString;
    self.labTime.attributedText = timeAttributedString;
}

- (void)createUI {
    [self.contentView addSubview:self.labWeek];
    [self.contentView addSubview:self.labRemainingCount];
    [self.contentView addSubview:self.labTargetCount];
    [self.contentView addSubview:self.labCount];
    [self.contentView addSubview:self.labTitleCalorie];
    [self.contentView addSubview:self.labCalorie];
    [self.contentView addSubview:self.labTitleTime];
    [self.contentView addSubview:self.labTime];
    [self.contentView addSubview:self.spliteLine];
}

- (void)layout {
    [self.labWeek mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.mas_equalTo(20);
    }];
    [self.labRemainingCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.right.mas_equalTo(-20);
    }];
    [self.labTargetCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labRemainingCount.mas_bottom).offset(7);
        make.right.mas_equalTo(self.labRemainingCount.mas_right);
    }];
    [self.labCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(75);
        make.centerX.mas_equalTo(0);
    }];
    [self.spliteLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labCount.mas_bottom).offset(35);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(1);
    }];
    [self.labTitleCalorie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.spliteLine.mas_bottom).offset(10);
        make.left.mas_equalTo(20);
    }];
    [self.labCalorie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labTitleCalorie.mas_bottom).offset(10);
        make.left.mas_equalTo(20);
    }];
    [self.labTitleTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.spliteLine.mas_bottom).offset(10);
        make.right.mas_equalTo(-20);
    }];
    [self.labTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labTitleTime.mas_bottom).offset(10);
        make.right.mas_equalTo(-20);
    }];
}

- (UILabel *)labWeek {
    if (!_labWeek) {
        _labWeek = [[UILabel alloc] init];
        _labWeek.font = S12;
        _labWeek.numberOfLines = 0;
        _labWeek.textColor = c474A4F;
        _labWeek.text = @"本周训练";
    }
    return _labWeek;
}

- (UILabel *)labRemainingCount {
    if (!_labRemainingCount) {
        _labRemainingCount = [[UILabel alloc] init];
        _labRemainingCount.font = S12;
        _labRemainingCount.numberOfLines = 0;
        _labRemainingCount.textAlignment = NSTextAlignmentRight;
        _labRemainingCount.textColor = c7E848C;
        _labRemainingCount.text = @"本学期剩余次数：3次";
    }
    return _labRemainingCount;
}

- (UILabel *)labTargetCount {
    if (!_labTargetCount) {
        _labTargetCount = [[UILabel alloc] init];
        _labTargetCount.font = S10;
        _labTargetCount.numberOfLines = 0;
        _labTargetCount.textAlignment = NSTextAlignmentRight;
        _labTargetCount.textColor = cCCCCCC;
        _labTargetCount.text = @"总目标次数：5次";
    }
    return _labTargetCount;
}

- (UILabel *)labCount {
    if (!_labCount) {
        _labCount = [[UILabel alloc] init];
        _labCount.font = SS(34);
        _labCount.numberOfLines = 0;
        _labCount.textColor = c474A4F;
        _labCount.text = @"1次";
    }
    return _labCount;
}

- (UILabel *)labTitleCalorie {
    if (!_labTitleCalorie) {
        _labTitleCalorie = [[UILabel alloc] init];
        _labTitleCalorie.font = S10;
        _labTitleCalorie.numberOfLines = 0;
        _labTitleCalorie.textColor = c7E848C;
        _labTitleCalorie.text = @"累计消耗热量";
    }
    return _labTitleCalorie;
}

- (UILabel *)labCalorie {
    if (!_labCalorie) {
        _labCalorie = [[UILabel alloc] init];
        _labCalorie.font = S17;
        _labCalorie.numberOfLines = 0;
        _labCalorie.textColor = c474A4F;
        _labCalorie.text = @"1200 千卡";
    }
    return _labCalorie;
}

- (UILabel *) labTitleTime{
    if (!_labTitleTime) {
        _labTitleTime = [[UILabel alloc] init];
        _labTitleTime.font = S10;
        _labTitleTime.numberOfLines = 0;
        _labTitleTime.textAlignment = NSTextAlignmentRight;
        _labTitleTime.textColor = c7E848C;
        _labTitleTime.text = @"累计运动时长";
    }
    return _labTitleTime;
}

- (UILabel *)labTime {
    if (!_labTime) {
        _labTime = [[UILabel alloc] init];
        _labTime.font = S17;
        _labTime.numberOfLines = 0;
        _labTime.textAlignment = NSTextAlignmentRight;
        _labTime.textColor = c474A4F;
        _labTime.text = @"120 分钟";
    }
    return _labTime;
}

- (UIView *)spliteLine {
    if (!_spliteLine) {
        _spliteLine = [[UIView alloc] init];
        _spliteLine.backgroundColor = cSpliteLine;
    }
    return _spliteLine;
}

@end
