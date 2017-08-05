//
//  HomeTotalCell.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/2.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "HomeTotalCell.h"
#import "HomePageModel.h"

@interface HomeTotalCell ()

@property (nonatomic, strong) UIImageView *imgArrows;
@property (nonatomic, strong) UILabel *labTitleTotalCount;//累计运动次数
@property (nonatomic, strong) UILabel *labTotalCount;
@property (nonatomic, strong) UILabel *labTitleCalorie;//卡路里
@property (nonatomic, strong) UILabel *labCalorie;
@property (nonatomic, strong) UILabel *labTitleTime;//耗时
@property (nonatomic, strong) UILabel *labTime;
@property (nonatomic, strong) UILabel *labTitleQualifiedCount;//达标次数
@property (nonatomic, strong) UILabel *labQualifiedCount;
@property (nonatomic, strong) UILabel *labTitleAdditional;//课外成绩
@property (nonatomic, strong) UILabel *labAdditional;
@property (nonatomic, strong) UIProgressView *proViewCount;
@property (nonatomic, strong) UIProgressView *proViewAdditional;
@property (nonatomic, strong) UIView  *spliteLine;

@end

@implementation HomeTotalCell

- (void)setupWithData:(id)data {
    HomePageModel *home = (HomePageModel *)data;
    
    // 总次数
    NSInteger totalCount = home.student.currentTermRunningActivityCount + home.student.currentTermAreaActivityCount;
    self.labTotalCount.text = [NSString stringWithFormat:@"%ld", (long)totalCount];
    
    // 卡路里
    NSInteger KcalConsumption = home.student.runningActivityKcalConsumption + home.student.areaActivityKcalConsumption;
    self.labCalorie.text = [NSString stringWithFormat:@"%ld", (long)KcalConsumption];
    
    // 耗时
    NSInteger costTime = home.student.runningActivityTimeCosted + home.student.areaActivityTimeCosted;
    self.labTime.text = [NSString stringWithFormat:@"%ld", (long)costTime / 60];;
    
    // 达标次数
    NSInteger qualifiedCount = home.student.currentTermQualifiedRunningActivityCount +
    home.student.currentTermQualifiedAreaActivityCount;
    NSInteger targetCount = home.university.currentTerm.termSportsTask.targetSportsTimes;
    self.labQualifiedCount.text = [NSString stringWithFormat:@"%ld/%ld", (long)qualifiedCount, targetCount];
    
    [self.proViewCount setProgress:qualifiedCount * 1.0 / targetCount animated:YES];
}

- (void)createUI {
    [self.contentView addSubview:self.imgArrows];
    [self.contentView addSubview:self.labTitleTotalCount];
    [self.contentView addSubview:self.labTotalCount];
    [self.contentView addSubview:self.labTitleCalorie];
    [self.contentView addSubview:self.labCalorie];
    [self.contentView addSubview:self.labTitleTime];
    [self.contentView addSubview:self.labTime];
    [self.contentView addSubview:self.labTitleQualifiedCount];
    [self.contentView addSubview:self.labQualifiedCount];
    [self.contentView addSubview:self.labTitleAdditional];
    [self.contentView addSubview:self.labAdditional];
    [self.contentView addSubview:self.proViewCount];
    [self.contentView addSubview:self.proViewAdditional];
    [self.contentView addSubview:self.spliteLine];
}

- (void)layout {
    [self.labTitleTotalCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(20);
    }];
    [self.labTotalCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labTitleTotalCount.mas_bottom).offset(10);
        make.left.mas_equalTo(self.labTitleTotalCount);
    }];
    [self.imgArrows mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.labTitleTotalCount);
        make.size.mas_equalTo(CGSizeMake(8, 13));
        make.right.mas_equalTo(-12);
    }];
    
    // 从进度条倒着向上布局
    [self.proViewCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.labTitleTotalCount);
        make.bottom.mas_equalTo(-10);
        make.right.mas_equalTo(self.proViewAdditional.mas_left).offset(-52);
        make.size.mas_equalTo(self.proViewAdditional);
        make.height.mas_equalTo(10);
    }];
    [self.proViewAdditional mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.left.mas_equalTo(self.proViewCount.mas_right).offset(52);
        make.size.mas_equalTo(self.proViewCount);
        make.centerY.mas_equalTo(self.proViewCount);
    }];
    [self.labQualifiedCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.labTitleTotalCount);
        make.bottom.mas_equalTo(self.proViewCount.mas_top).offset(-6);
    }];
    [self.labTitleQualifiedCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.labTitleTotalCount);
        make.bottom.mas_equalTo(self.labQualifiedCount.mas_top).offset(-10);
    }];
    [self.labAdditional mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.proViewAdditional);
        make.bottom.mas_equalTo(self.proViewAdditional.mas_top).offset(-6);
    }];
    [self.labTitleAdditional mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.labAdditional);
        make.bottom.mas_equalTo(self.labAdditional.mas_top).offset(-10);
    }];
    
    [self.labCalorie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.labTitleQualifiedCount.mas_top).offset(-18);
        make.left.mas_equalTo(self.labTitleTotalCount);
    }];
    [self.labTitleCalorie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.labCalorie.mas_top).offset(-9);
        make.left.mas_equalTo(self.labTitleTotalCount);
    }];
    [self.labTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.labCalorie);
        make.left.mas_equalTo(self.labAdditional);
    }];
    [self.labTitleTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.labTitleCalorie);
        make.left.mas_equalTo(self.labAdditional);
    }];
    
    [self.spliteLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(1);
    }];
}

- (UILabel *)labTitleTotalCount {
    if (!_labTitleTotalCount) {
        _labTitleTotalCount = [[UILabel alloc] init];
        _labTitleTotalCount.font = S10;
        _labTitleTotalCount.numberOfLines = 0;
        _labTitleTotalCount.textAlignment = NSTextAlignmentLeft;
        _labTitleTotalCount.textColor = c7E848C;
        _labTitleTotalCount.text = @"本学期累计运动(次)";
    }
    return _labTitleTotalCount;
}

- (UILabel *)labTotalCount {
    if (!_labTotalCount) {
        _labTotalCount = [[UILabel alloc] init];
        _labTotalCount.font = SS(35);
        _labTotalCount.numberOfLines = 0;
        _labTotalCount.textAlignment = NSTextAlignmentLeft  ;
        _labTotalCount.textColor = c474A4F;
        _labTotalCount.text = @"0";
    }
    return _labTotalCount;
}

- (UILabel *)labTitleCalorie {
    if (!_labTitleCalorie) {
        _labTitleCalorie = [[UILabel alloc] init];
        _labTitleCalorie.font = S10;
        _labTitleCalorie.numberOfLines = 0;
        _labTitleCalorie.textAlignment = NSTextAlignmentRight;
        _labTitleCalorie.textColor = c7E848C;
        _labTitleCalorie.text = @"消耗(大卡)";
    }
    return _labTitleCalorie;
}

- (UILabel *)labCalorie {
    if (!_labCalorie) {
        _labCalorie = [[UILabel alloc] init];
        _labCalorie.font = S17;
        _labCalorie.numberOfLines = 0;
        _labCalorie.textAlignment = NSTextAlignmentRight;
        _labCalorie.textColor = c474A4F;
        _labCalorie.text = @"0";
    }
    return _labCalorie;
}

- (UILabel *)labTitleTime {
    if (!_labTitleTime) {
        _labTitleTime = [[UILabel alloc] init];
        _labTitleTime.font = S10;
        _labTitleTime.numberOfLines = 0;
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

- (UILabel *)labTitleQualifiedCount {
    if (!_labTitleQualifiedCount) {
        _labTitleQualifiedCount = [[UILabel alloc] init];
        _labTitleQualifiedCount.font = S10;
        _labTitleQualifiedCount.numberOfLines = 0;
        _labTitleQualifiedCount.textColor = c7E848C;
        _labTitleQualifiedCount.text = @"达标(次)";
    }
    return _labTitleQualifiedCount;
}

- (UILabel *)labQualifiedCount {
    if (!_labQualifiedCount) {
        _labQualifiedCount = [[UILabel alloc] init];
        _labQualifiedCount.font = S17;
        _labQualifiedCount.numberOfLines = 0;
        _labQualifiedCount.textAlignment = NSTextAlignmentRight;
        _labQualifiedCount.textColor = c474A4F;
        _labQualifiedCount.text = @"0/0";
    }
    return _labQualifiedCount;
}

- (UILabel *)labTitleAdditional {
    if (!_labTitleAdditional) {
        _labTitleAdditional = [[UILabel alloc] init];
        _labTitleAdditional.font = S10;
        _labTitleAdditional.numberOfLines = 0;
        _labTitleAdditional.textColor = c7E848C;
        _labTitleAdditional.text = @"课外成绩（分）";
        _labTitleAdditional.hidden = YES;
    }
    return _labTitleAdditional;
}

- (UILabel *)labAdditional {
    if (!_labAdditional) {
        _labAdditional = [[UILabel alloc] init];
        _labAdditional.font = S17;
        _labAdditional.numberOfLines = 0;
        _labAdditional.textAlignment = NSTextAlignmentRight;
        _labAdditional.textColor = c474A4F;
        _labAdditional.text = @"0/0";
        _labAdditional.hidden = YES;
    }
    return _labAdditional;
}

- (UIProgressView *)proViewCount {
    if (!_proViewCount) {
        //实例化一个进度条，有两种样式，一种是UIProgressViewStyleBar一种是UIProgressViewStyleDefault，几乎无区别
        _proViewCount=[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _proViewCount.layer.cornerRadius = 5;
        _proViewCount.layer.masksToBounds = YES;
        //设置进度条颜色
        _proViewCount.trackTintColor= cEEEEEE;
        //设置进度默认值，这个相当于百分比，范围在0~1之间，不可以设置最大最小值
        _proViewCount.progress = 0.1;
        //设置进度条上进度的颜色
        _proViewCount.progressTintColor=c66A7FE;
//        //设置进度条的背景图片
//        _proViewCount.trackImage=[UIImage imageNamed:@"logo.png"];
//        //设置进度条上进度的背景图片
//        _proViewCount.progressImage=[UIImage imageNamed:@"1.png"];
        //设置进度值并动画显示
//        [_proViewCount setProgress:0.7 animated:YES];
    }
    return _proViewCount;
}

- (UIProgressView *)proViewAdditional {
    if (!_proViewAdditional) {
        //实例化一个进度条，有两种样式，一种是UIProgressViewStyleBar一种是UIProgressViewStyleDefault，几乎无区别
        _proViewAdditional=[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _proViewAdditional.layer.cornerRadius = 5;
        _proViewAdditional.layer.masksToBounds = YES;
        //设置进度条颜色
        _proViewAdditional.trackTintColor=cEEEEEE;
        //设置进度默认值，这个相当于百分比，范围在0~1之间，不可以设置最大最小值
        _proViewAdditional.progress=0.7;
        //设置进度条上进度的颜色
        _proViewAdditional.progressTintColor=c66A7FE;
        _proViewAdditional.hidden = YES;
        //        //设置进度条的背景图片
        //        _proViewCount.trackImage=[UIImage imageNamed:@"logo.png"];
        //        //设置进度条上进度的背景图片
        //        _proViewCount.progressImage=[UIImage imageNamed:@"1.png"];
        //设置进度值并动画显示
        [_proViewAdditional setProgress:0.7 animated:YES];
    }
    return _proViewAdditional;
}

- (UIImageView *)imgArrows {
    if (!_imgArrows) {
        _imgArrows = [[UIImageView alloc] init];
        [_imgArrows setImage:[UIImage imageNamed:@"icon_right_arrow"]];
    }
    return _imgArrows;
}

- (UIView *)spliteLine {
    if (!_spliteLine) {
        _spliteLine = [[UIView alloc] init];
        _spliteLine.backgroundColor = cSpliteLine;
    }
    return _spliteLine;
}

@end
