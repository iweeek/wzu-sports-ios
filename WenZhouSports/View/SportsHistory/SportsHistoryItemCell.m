//
//  SportsHistoryItemCell.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/1.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "SportsHistoryItemCell.h"

@interface SportsHistoryItemCell ()

@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labDate;
@property (nonatomic, strong) UILabel *labTitleSpeed;
@property (nonatomic, strong) UILabel *labTitleStage;
@property (nonatomic, strong) UILabel *labTitleMinDistance;
@property (nonatomic, strong) UILabel *labSpeed;
@property (nonatomic, strong) UILabel *labStage;// 段
@property (nonatomic, strong) UILabel *labMinDistance;
@property (nonatomic, strong) UILabel *labCalorie;
@property (nonatomic, strong) UILabel *labTime;// 累计时长
@property (nonatomic, strong) UIView  *spliteLine1;
@property (nonatomic, strong) UIView  *spliteLine2;

@end

@implementation SportsHistoryItemCell

- (void)setupWithData:(id)data {
    NSDictionary *attribute1 = @{NSFontAttributeName : S10,
                                 NSForegroundColorAttributeName : c7E848C};
    
    NSString *speedStr = @"1.0 米/秒";
    NSString *stageStr = @"4 段";
    NSString *minDistanceDisStr = @"1000 米";
    
    NSMutableAttributedString *speedAttributedString = [[NSMutableAttributedString alloc] initWithString:speedStr];
    NSMutableAttributedString *stageAttributedString = [[NSMutableAttributedString alloc] initWithString:stageStr];
    NSMutableAttributedString *minDistanceDisString = [[NSMutableAttributedString alloc] initWithString:minDistanceDisStr];
    
    [speedAttributedString addAttributes:attribute1 range:NSMakeRange(speedAttributedString.length - 3, 3)];
    [stageAttributedString addAttributes:attribute1 range:NSMakeRange(stageAttributedString.length - 1, 1)];
    [minDistanceDisString addAttributes:attribute1 range:NSMakeRange(minDistanceDisString.length - 1, 1)];
    
    self.labSpeed.attributedText = speedAttributedString;
    self.labStage.attributedText = stageAttributedString;
    self.labMinDistance.attributedText = minDistanceDisString;

}

- (void)createUI {
    [self.contentView addSubview:self.labTitle];
    [self.contentView addSubview:self.labDate];
    [self.contentView addSubview:self.labTitleSpeed];
    [self.contentView addSubview:self.labTitleStage];
    [self.contentView addSubview:self.labTitleMinDistance];
    [self.contentView addSubview:self.labSpeed];
    [self.contentView addSubview:self.labStage];
    [self.contentView addSubview:self.labMinDistance];
    [self.contentView addSubview:self.labCalorie];
    [self.contentView addSubview:self.labTime];
    [self.contentView addSubview:self.spliteLine1];
    [self.contentView addSubview:self.spliteLine2];
}

- (void)layout {
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.mas_equalTo(20);
    }];
    [self.labDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.right.mas_equalTo(-20);
    }];
    [self.spliteLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labTitle.mas_bottom).offset(10);
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
        make.height.mas_equalTo(1);
    }];
    [self.labTitleSpeed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.spliteLine1.mas_bottom).offset(12);
        make.left.mas_equalTo(20);
    }];
    [self.labTitleStage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.spliteLine1.mas_bottom).offset(12);
        make.centerX.mas_equalTo(0);
    }];
    [self.labTitleMinDistance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.spliteLine1.mas_bottom).offset(12);
        make.right.mas_equalTo(-20);
    }];
    [self.labSpeed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labTitleMinDistance.mas_bottom).offset(10);
        make.left.mas_equalTo(self.labTitleSpeed);
    }];
    [self.labStage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labTitleMinDistance.mas_bottom).offset(10);
        make.centerX.mas_equalTo(0);
    }];
    [self.labMinDistance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labTitleMinDistance.mas_bottom).offset(10);
        make.right.mas_equalTo(-20);
    }];
    [self.spliteLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labSpeed.mas_bottom).offset(12);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(1);
    }];
    [self.labCalorie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.spliteLine2.mas_bottom).offset(12);
        make.left.mas_equalTo(20);
    }];
    [self.labTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.spliteLine2.mas_bottom).offset(12);
        make.right.mas_equalTo(-20);
    }];
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.font = S12;
        _labTitle.numberOfLines = 0;
        _labTitle.textAlignment = NSTextAlignmentLeft;
        _labTitle.textColor = c66A7FE;
        _labTitle.text = @"本学期剩余次数：3次";
    }
    return _labTitle;
}

- (UILabel *)labDate {
    if (!_labDate) {
        _labDate = [[UILabel alloc] init];
        _labDate.font = S12;
        _labDate.numberOfLines = 0;
        _labDate.textAlignment = NSTextAlignmentLeft;
        _labDate.textColor = c7E848C;
        _labDate.text = @"2017-05-08 09:00";
    }
    return _labDate;
}

- (UILabel *)labTitleSpeed {
    if (!_labTitleSpeed) {
        _labTitleSpeed = [[UILabel alloc] init];
        _labTitleSpeed.font = S12;
        _labTitleSpeed.numberOfLines = 0;
        _labTitleSpeed.textAlignment = NSTextAlignmentLeft;
        _labTitleSpeed.textColor = c7E848C;
        _labTitleSpeed.text = @"本次速度";
    }
    return _labTitleSpeed;
}

- (UILabel *)labTitleStage {
    if (!_labTitleStage) {
        _labTitleStage = [[UILabel alloc] init];
        _labTitleStage.font = S12;
        _labTitleStage.numberOfLines = 0;
        _labTitleStage.textAlignment = NSTextAlignmentCenter;
        _labTitleStage.textColor = c7E848C;
        _labTitleStage.text = @"完成段数";
    }
    return _labTitleStage;
}

- (UILabel *)labTitleMinDistance {
    if (!_labTitleMinDistance) {
        _labTitleMinDistance = [[UILabel alloc] init];
        _labTitleMinDistance.font = S12;
        _labTitleMinDistance.numberOfLines = 0;
        _labTitleMinDistance.textAlignment = NSTextAlignmentRight;
        _labTitleMinDistance.textColor = c7E848C;
        _labTitleMinDistance.text = @"本次最短距离";
    }
    return _labTitleMinDistance;
}

- (UILabel *)labSpeed {
    if (!_labSpeed) {
        _labSpeed = [[UILabel alloc] init];
        _labSpeed.font = S17;
        _labSpeed.numberOfLines = 0;
        _labSpeed.textAlignment = NSTextAlignmentLeft;
        _labSpeed.textColor = c474A4F;
        _labSpeed.text = @"1.0 米/秒";
    }
    return _labSpeed;
}

- (UILabel *)labStage {
    if (!_labStage) {
        _labStage = [[UILabel alloc] init];
        _labStage.font = S17;
        _labStage.numberOfLines = 0;
        _labStage.textAlignment = NSTextAlignmentCenter;
        _labStage.textColor = c474A4F;
        _labStage.text = @"3 段";
    }
    return _labStage;
}

- (UILabel *)labMinDistance {
    if (!_labMinDistance) {
        _labMinDistance = [[UILabel alloc] init];
        _labMinDistance.font = S17;
        _labMinDistance.numberOfLines = 0;
        _labMinDistance.textAlignment = NSTextAlignmentRight;
        _labMinDistance.textColor = c474A4F;
        _labMinDistance.text = @"1000 米";
    }
    return _labMinDistance;
}

- (UILabel *)labCalorie {
    if (!_labCalorie) {
        _labCalorie = [[UILabel alloc] init];
        _labCalorie.font = S12;
        _labCalorie.numberOfLines = 0;
        _labCalorie.textAlignment = NSTextAlignmentLeft;
        _labCalorie.textColor = c7E848C;
        _labCalorie.text = @"本次消耗热量:1000千卡";
    }
    return _labCalorie;
}

- (UILabel *)labTime {
    if (!_labTime) {
        _labTime = [[UILabel alloc] init];
        _labTime.font = S12;
        _labTime.numberOfLines = 0;
        _labTime.textAlignment = NSTextAlignmentRight;
        _labTime.textColor = c7E848C;
        _labTime.text = @"本次运动时长：300分钟";
    }
    return _labTime;
}

- (UIView *)spliteLine1 {
    if (!_spliteLine1) {
        _spliteLine1 = [[UIView alloc] init];
        _spliteLine1.backgroundColor = cSpliteLine;
    }
    return _spliteLine1;
}

- (UIView *)spliteLine2 {
    if (!_spliteLine2) {
        _spliteLine2 = [[UIView alloc] init];
        _spliteLine2.backgroundColor = cSpliteLine;
    }
    return _spliteLine2;
}

@end
