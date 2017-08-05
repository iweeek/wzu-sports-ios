//
//  SportsHistoryHeaderCell.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/1.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "SportsHistoryHeaderCell.h"
#import "StudentModel.h"

@interface SportsHistoryHeaderCell ()

@property (nonatomic, strong) UILabel *labTitleTotalCount;
@property (nonatomic, strong) UILabel *labCount;// 次数
@property (nonatomic, strong) UILabel *labTitleTargetCount;
@property (nonatomic, strong) UILabel *labTargetCount;// 达标次数
@property (nonatomic, strong) UILabel *labTitleCalorie;// 卡路里标题
@property (nonatomic, strong) UILabel *labCalorie;// 卡路里标题
@property (nonatomic, strong) UILabel *labTitleTime;// 累计时长
@property (nonatomic, strong) UILabel *labTime;// 累计时长
@property (nonatomic, strong) UIView  *spliteLine;

@end

@implementation SportsHistoryHeaderCell

- (void)setupWithData:(id)data {
    StudentModel *student = (StudentModel *)data;
    // 累计次数
    NSInteger accCount = student.accuAreaActivityCount + student.accuRunningActivityCount;
    self.labCount.text = [NSString stringWithFormat:@"%ld", accCount];
    
    // 达标次数
    NSInteger targetCount = student.qualifiedAreaActivityCount + student.qualifiedRunningActivityCount;
    self.labTargetCount.text = [NSString stringWithFormat:@"%ld", targetCount];
    
    // 卡路里
    NSInteger kcalConsumption = student.areaActivityKcalConsumption + student.runningActivityKcalConsumption;
    self.labCalorie.text = [NSString stringWithFormat:@"%ld", kcalConsumption];
    
    // 耗时
    NSInteger costTime = student.areaActivityTimeCosted + student.runningActivityTimeCosted;
    self.labTime.text = [NSString stringWithFormat:@"%ld", costTime / 60];
    
}

- (void)createUI {
    [self.contentView addSubview:self.labTitleTotalCount];
    [self.contentView addSubview:self.labTitleTargetCount];
    [self.contentView addSubview:self.labTargetCount];
    [self.contentView addSubview:self.labCount];
    [self.contentView addSubview:self.labTitleCalorie];
    [self.contentView addSubview:self.labCalorie];
    [self.contentView addSubview:self.labTitleTime];
    [self.contentView addSubview:self.labTime];
    [self.contentView addSubview:self.spliteLine];
}

- (void)layout {
    [self.labTitleTotalCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.mas_equalTo(20);
    }];
    [self.labCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labTitleTotalCount.mas_bottom).offset(7);
        make.left.mas_equalTo(self.labTitleTotalCount);
    }];
    [self.spliteLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(146);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(1);
    }];
    [self.labTitleTargetCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.spliteLine.mas_bottom).offset(10);
        make.left.mas_equalTo(20);

    }];
    [self.labTargetCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labTitleCalorie.mas_bottom).offset(10);
        make.left.mas_equalTo(20);
    }];
    [self.labTitleCalorie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.spliteLine.mas_bottom).offset(10);
        make.centerX.mas_equalTo(0);
    }];
    [self.labCalorie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labTitleCalorie.mas_bottom).offset(10);
        make.centerX.mas_equalTo(0);
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

- (UILabel *)labTitleTotalCount {
    if (!_labTitleTotalCount) {
        _labTitleTotalCount = [[UILabel alloc] init];
        _labTitleTotalCount.font = S12;
        _labTitleTotalCount.numberOfLines = 0;
        _labTitleTotalCount.textColor = c474A4F;
        _labTitleTotalCount.text = @"本周累计运动（次）";
    }
    return _labTitleTotalCount;
}

- (UILabel *)labCount {
    if (!_labCount) {
        _labCount = [[UILabel alloc] init];
        _labCount.font = SS(35);
        _labCount.numberOfLines = 0;
        _labCount.textColor = c474A4F;
        _labCount.text = @"1";
    }
    return _labCount;
}

- (UILabel *)labTitleTargetCount {
    if (!_labTitleTargetCount) {
        _labTitleTargetCount = [[UILabel alloc] init];
        _labTitleTargetCount.font = S10;
        _labTitleTargetCount.numberOfLines = 0;
        _labTitleTargetCount.textAlignment = NSTextAlignmentLeft;
        _labTitleTargetCount.textColor = c7E848C;
        _labTitleTargetCount.text = @"达标(次)";
    }
    return _labTitleTargetCount;
}

- (UILabel *)labTargetCount {
    if (!_labTargetCount) {
        _labTargetCount = [[UILabel alloc] init];
        _labTargetCount.font = S17;
        _labTargetCount.numberOfLines = 0;
        _labTargetCount.textAlignment = NSTextAlignmentLeft;
        _labTargetCount.textColor = c474A4F;
        _labTargetCount.text = @"0";
    }
    return _labTargetCount;
}

- (UILabel *)labTitleCalorie {
    if (!_labTitleCalorie) {
        _labTitleCalorie = [[UILabel alloc] init];
        _labTitleCalorie.font = S10;
        _labTitleCalorie.numberOfLines = 0;
        _labTitleCalorie.textColor = c7E848C;
        _labTitleCalorie.text = @"消耗(卡)";
    }
    return _labTitleCalorie;
}

- (UILabel *)labCalorie {
    if (!_labCalorie) {
        _labCalorie = [[UILabel alloc] init];
        _labCalorie.font = S17;
        _labCalorie.numberOfLines = 0;
        _labCalorie.textColor = c474A4F;
        _labCalorie.text = @"0";
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
        _labTitleTime.text = @"耗时（分钟）";
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
        _labTime.text = @"0";
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
