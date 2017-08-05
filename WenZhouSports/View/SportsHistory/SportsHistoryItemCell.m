//
//  SportsHistoryItemCell.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/1.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "SportsHistoryItemCell.h"
#import "RunningActivityModel.h"
#import "AreaActivityModel.h"
#import "NSString+Date.h"

@interface SportsHistoryItemCell ()

@property (nonatomic, strong) UIImageView *imgIconView;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labQualified; // 是否达标
@property (nonatomic, strong) UILabel *labDate;
@property (nonatomic, strong) UILabel *labTitleDistance;
@property (nonatomic, strong) UILabel *labTitleTime;
@property (nonatomic, strong) UILabel *labTitleCalorie;
@property (nonatomic, strong) UILabel *labDistance;
@property (nonatomic, strong) UILabel *labTime;
@property (nonatomic, strong) UILabel *labCalorie;
@property (nonatomic, strong) UILabel *labCalorieOld;
@property (nonatomic, strong) UILabel *labTotalTime;// 累计时长
@property (nonatomic, strong) UIView  *spliteLine1;
@property (nonatomic, strong) UIView  *spliteLine2;

@end

@implementation SportsHistoryItemCell

- (void)setupWithData:(id)data {
    if ([data isMemberOfClass:[RunningActivityModel class]]) {
        RunningActivityModel *activity = (RunningActivityModel *)data;
        
        NSDictionary *attribute1 = @{NSFontAttributeName : S10,
                                     NSForegroundColorAttributeName : c7E848C};
        
        NSString *distanceStr = [NSString stringWithFormat:@"%ld 米", activity.distance];
        NSString *timeStr = [self getMMSSFromSS:activity.costTime];
        NSString *calorieStr = [NSString stringWithFormat:@"%ld大卡", activity.kcalConsumed];
        //    NSString *speedStr = nil;
        //    if (activity.costTime > 0) {
        //        speedStr = [NSString stringWithFormat:@"%.1f 米/秒",
        //                  activity.distance / activity.costTime * 0.1 * 10];
        //    } else {
        //        speedStr = @"0.0 米/秒";
        //    }
        
        NSMutableAttributedString *distanceAttributedString = [[NSMutableAttributedString alloc] initWithString:distanceStr];
        NSMutableAttributedString *calorieAttributedString = [[NSMutableAttributedString alloc] initWithString:calorieStr];
        
        [distanceAttributedString addAttributes:attribute1 range:NSMakeRange(distanceAttributedString.length - 1, 1)];
        [calorieAttributedString addAttributes:attribute1 range:NSMakeRange(calorieAttributedString.length - 2, 2)];
        
        self.labTitle.text = activity.runningSport.name;
        self.labDate.text = [NSString timestampSwitchTime:activity.startTime / 1000
                                             andFormatter:@"HH:mm"];
        
        self.labTitleDistance.hidden = NO;
        self.labDistance.hidden = NO;
        self.labDistance.attributedText = distanceAttributedString;
        self.labTime.text = timeStr;
        self.labCalorie.attributedText = calorieAttributedString;
        
        // 非正常结束
        if (activity.endedAt == 0) {
            self.labQualified.text = @"非正常结束";
            self.labQualified.backgroundColor = C_FF0000;
        } else {
            if (activity.qualified) {
                self.labQualified.text = @"达标！";
                self.labQualified.backgroundColor = C_42CC42;
            } else {
                self.labQualified.text = @"未达标！";
                self.labQualified.backgroundColor = C_FF0000;
            }
        }
    } else {
        AreaActivityModel *activity = (AreaActivityModel *)data;
        
        NSDictionary *attribute1 = @{NSFontAttributeName : S10,
                                     NSForegroundColorAttributeName : c7E848C};
        
        NSString *timeStr = [self getMMSSFromSS:activity.costTime];
        NSString *calorieStr = [NSString stringWithFormat:@"%ld大卡", activity.kcalConsumed];

        
        NSMutableAttributedString *calorieAttributedString = [[NSMutableAttributedString alloc] initWithString:calorieStr];
        
        [calorieAttributedString addAttributes:attribute1 range:NSMakeRange(calorieAttributedString.length - 2, 2)];
        
        self.labTitleDistance.hidden = YES;
        self.labDistance.hidden = YES;
        self.labTitle.text = activity.areaSport.name;
        self.labDate.text = [NSString timestampSwitchTime:activity.startTime / 1000
                                             andFormatter:@"HH:mm"];
        
        self.labTime.text = timeStr;
        self.labCalorie.attributedText = calorieAttributedString;
        
        // 非正常结束
        if (activity.endedAt == 0) {
            self.labQualified.text = @"非正常结束";
            self.labQualified.backgroundColor = C_FF0000;
        } else {
            if (activity.qualified) {
                self.labQualified.text = @"达标！";
                self.labQualified.backgroundColor = C_42CC42;
            } else {
                self.labQualified.text = @"未达标！";
                self.labQualified.backgroundColor = C_FF0000;
            }
        }
    }
    
}

//传入 秒  得到 xx:xx:xx
-(NSString *)getMMSSFromSS:(NSInteger)seconds {
    NSString *strHour = [NSString stringWithFormat:@"%02ld", seconds / 3600];
    
    NSString *strMinute = [NSString stringWithFormat:@"%02ld", (seconds % 3600) / 60];
    
    NSString *strSecond = [NSString stringWithFormat:@"%02ld", seconds % 60];
    
    NSString *strTime = [NSString stringWithFormat:@"%@:%@:%@", strHour, strMinute,strSecond];
    
    return strTime;
}


- (void)createUI {
    [self.contentView addSubview:self.imgIconView];
    [self.contentView addSubview:self.labTitle];
    [self.contentView addSubview:self.labQualified];
    [self.contentView addSubview:self.labDate];
    [self.contentView addSubview:self.labTitleDistance];
    [self.contentView addSubview:self.labTitleTime];
    [self.contentView addSubview:self.labTitleCalorie];
    [self.contentView addSubview:self.labDistance];
    [self.contentView addSubview:self.labTime];
    [self.contentView addSubview:self.labCalorie];
    [self.contentView addSubview:self.labCalorieOld];
    [self.contentView addSubview:self.labTotalTime];
    [self.contentView addSubview:self.spliteLine1];
    [self.contentView addSubview:self.spliteLine2];
}

- (void)layout {
    [self.imgIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.mas_equalTo(18);
        make.size.mas_equalTo(CGSizeMake(21, 21));
    }];
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(12);
        make.centerY.mas_equalTo(self.imgIconView);
        make.left.mas_equalTo(self.imgIconView.mas_right).offset(5);
    }];
    [self.labQualified mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.labTitle.mas_right).offset(2);
        make.centerY.mas_equalTo(self.labTitle);
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
    [self.labTitleDistance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.spliteLine1.mas_bottom).offset(8);
        make.left.mas_equalTo(20);
    }];
    [self.labTitleTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.spliteLine1.mas_bottom).offset(12);
        make.centerX.mas_equalTo(0);
    }];
    [self.labTitleCalorie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.spliteLine1.mas_bottom).offset(12);
        make.right.mas_equalTo(-20);
    }];
    [self.labDistance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labTitleCalorie.mas_bottom).offset(5);
        make.left.mas_equalTo(self.labTitleDistance);
    }];
    [self.labTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labTitleCalorie.mas_bottom).offset(5);
        make.centerX.mas_equalTo(0);
    }];
    [self.labCalorie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labTitleCalorie.mas_bottom).offset(5);
        make.right.mas_equalTo(-20);
    }];
    [self.spliteLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(1);
    }];
    [self.labCalorieOld mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.spliteLine2.mas_bottom).offset(12);
        make.left.mas_equalTo(20);
    }];
    [self.labTotalTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.spliteLine2.mas_bottom).offset(12);
        make.right.mas_equalTo(-20);
    }];
}

- (UIImageView *)imgIconView {
    if (!_imgIconView) {
        _imgIconView = [[UIImageView alloc] init];
        _imgIconView.image = [UIImage imageNamed:@"icon_runningSports"];
    }
    return _imgIconView;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.font = S15;
        _labTitle.numberOfLines = 0;
        _labTitle.textAlignment = NSTextAlignmentLeft;
        _labTitle.textColor = c66A7FE;
        _labTitle.text = @"本学期剩余次数：3次";
    }
    return _labTitle;
}

- (UILabel *)labQualified {
    if (!_labQualified) {
        _labQualified = [[UILabel alloc] init];
        _labQualified.font = S12;
        _labQualified.numberOfLines = 0;
        _labQualified.textColor = cFFFFFF;
        _labQualified.text = @"";
        _labQualified.layer.cornerRadius = 4;
        _labQualified.layer.masksToBounds = YES;
    }
    return _labQualified;
}


- (UILabel *)labDate {
    if (!_labDate) {
        _labDate = [[UILabel alloc] init];
        _labDate.font = S12;
        _labDate.numberOfLines = 0;
        _labDate.textAlignment = NSTextAlignmentLeft;
        _labDate.textColor = c7E848C;
        _labDate.text = @"";
    }
    return _labDate;
}

- (UILabel *)labTitleDistance {
    if (!_labTitleDistance) {
        _labTitleDistance = [[UILabel alloc] init];
        _labTitleDistance.font = S12;
        _labTitleDistance.numberOfLines = 0;
        _labTitleDistance.textAlignment = NSTextAlignmentLeft;
        _labTitleDistance.textColor = c7E848C;
        _labTitleDistance.text = @"距离";
    }
    return _labTitleDistance;
}

- (UILabel *)labTitleTime {
    if (!_labTitleTime) {
        _labTitleTime = [[UILabel alloc] init];
        _labTitleTime.font = S12;
        _labTitleTime.numberOfLines = 0;
        _labTitleTime.textAlignment = NSTextAlignmentCenter;
        _labTitleTime.textColor = c7E848C;
        _labTitleTime.text = @"耗时";
    }
    return _labTitleTime;
}

- (UILabel *)labTitleCalorie {
    if (!_labTitleCalorie) {
        _labTitleCalorie = [[UILabel alloc] init];
        _labTitleCalorie.font = S12;
        _labTitleCalorie.numberOfLines = 0;
        _labTitleCalorie.textAlignment = NSTextAlignmentRight;
        _labTitleCalorie.textColor = c7E848C;
        _labTitleCalorie.text = @"消耗热量";
    }
    return _labTitleCalorie;
}

- (UILabel *)labDistance {
    if (!_labDistance) {
        _labDistance = [[UILabel alloc] init];
        _labDistance.font = S17;
        _labDistance.numberOfLines = 0;
        _labDistance.textAlignment = NSTextAlignmentLeft;
        _labDistance.textColor = c474A4F;
        _labDistance.text = @"";
    }
    return _labDistance;
}

- (UILabel *)labTime {
    if (!_labTime) {
        _labTime = [[UILabel alloc] init];
        _labTime.font = S17;
        _labTime.numberOfLines = 0;
        _labTime.textAlignment = NSTextAlignmentCenter;
        _labTime.textColor = c474A4F;
        _labTime.text = @"";
    }
    return _labTime;
}

- (UILabel *)labCalorie {
    if (!_labCalorie) {
        _labCalorie = [[UILabel alloc] init];
        _labCalorie.font = S17;
        _labCalorie.numberOfLines = 0;
        _labCalorie.textAlignment = NSTextAlignmentRight;
        _labCalorie.textColor = c474A4F;
        _labCalorie.text = @"";
    }
    return _labCalorie;
}

- (UILabel *)labCalorieOld {
    if (!_labCalorieOld) {
        _labCalorieOld = [[UILabel alloc] init];
        _labCalorieOld.font = S12;
        _labCalorieOld.numberOfLines = 0;
        _labCalorieOld.textAlignment = NSTextAlignmentLeft;
        _labCalorieOld.textColor = c7E848C;
        _labCalorieOld.text = @"本次消耗热量:1000大卡";
        _labCalorieOld.hidden = YES;
    }
    return _labCalorieOld;
}

- (UILabel *)labTotalTime {
    if (!_labTotalTime) {
        _labTotalTime = [[UILabel alloc] init];
        _labTotalTime.font = S12;
        _labTotalTime.numberOfLines = 0;
        _labTotalTime.textAlignment = NSTextAlignmentRight;
        _labTotalTime.textColor = c7E848C;
        _labTotalTime.text = @"本次运动时长：300分钟";
        _labTotalTime.hidden = YES;
    }
    return _labTotalTime;
}

- (UIView *)spliteLine1 {
    if (!_spliteLine1) {
        _spliteLine1 = [[UIView alloc] init];
        _spliteLine1.backgroundColor = cSpliteLine;
        _spliteLine1.hidden = YES;
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
