//
//  HomeTotalCell.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/2.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "HomeTotalCell.h"

@interface HomeTotalCell ()

@property (nonatomic, strong) UIImageView *imgArrows;
@property (nonatomic, strong) UILabel *labTitleTarget;
@property (nonatomic, strong) UILabel *labTarget;
@property (nonatomic, strong) UILabel *labTitleCalorie;
@property (nonatomic, strong) UILabel *labCalorie;
@property (nonatomic, strong) UILabel *labCount;
@property (nonatomic, strong) UIView  *spliteLine;

@end

@implementation HomeTotalCell

- (void)setupWithData:(id)data {
    NSDictionary *attribute1 = @{NSFontAttributeName : S10,
                                 NSForegroundColorAttributeName : c7E848C};
    NSDictionary *attribute2 = @{NSFontAttributeName : S10,
                                 NSForegroundColorAttributeName : c474A4F};
    
    NSString *surplusCountStr = @"3 次";
    NSString *calorieStr = @"1200 千卡";
    NSString *countStr = @"剩余1次";
    
    NSMutableAttributedString *surplusCountAttributedString = [[NSMutableAttributedString alloc] initWithString:surplusCountStr];
    NSMutableAttributedString *calorieAttributedString = [[NSMutableAttributedString alloc] initWithString:calorieStr];
    NSMutableAttributedString *countAttributedString = [[NSMutableAttributedString alloc] initWithString:countStr];
    
    [countAttributedString addAttributes:attribute1 range:NSMakeRange(countAttributedString.length - 1, 1)];
    [countAttributedString addAttributes:attribute1 range:NSMakeRange(0, 2)];
    [calorieAttributedString addAttributes:attribute2 range:NSMakeRange(calorieAttributedString.length - 2, 2)];
    [surplusCountAttributedString addAttributes:attribute2 range:NSMakeRange(surplusCountAttributedString.length - 2, 2)];
    
    self.labCount.attributedText = countAttributedString;
    self.labCalorie.attributedText = calorieAttributedString;
    self.labTarget.attributedText = surplusCountAttributedString;
}

- (void)createUI {
    [self.contentView addSubview:self.imgArrows];
    [self.contentView addSubview:self.labTitleTarget];
    [self.contentView addSubview:self.labTarget];
    [self.contentView addSubview:self.labCount];
    [self.contentView addSubview:self.labTitleCalorie];
    [self.contentView addSubview:self.labCalorie];
    [self.contentView addSubview:self.spliteLine];
}

- (void)layout {
    [self.labTitleTarget mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(20);
    }];
    [self.labTarget mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labTitleTarget.mas_bottom).offset(7);
        make.left.mas_equalTo(self.labTitleTarget);
    }];
    [self.labTitleCalorie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labTitleTarget);
        make.right.mas_equalTo(-20);
    }];
    [self.labCalorie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labTitleCalorie.mas_bottom).offset(7);
        make.right.mas_equalTo(self.labTitleCalorie.mas_right);
    }];
    [self.labCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(84);
        make.centerX.mas_equalTo(0);
    }];
    [self.imgArrows mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.labCount.mas_bottom).offset(-3);
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(8, 13));
    }];
    [self.spliteLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(1);
    }];
}

- (UILabel *)labTitleTarget {
    if (!_labTitleTarget) {
        _labTitleTarget = [[UILabel alloc] init];
        _labTitleTarget.font = S13;
        _labTitleTarget.numberOfLines = 0;
        _labTitleTarget.textAlignment = NSTextAlignmentLeft;
        _labTitleTarget.textColor = c7E848C;
        _labTitleTarget.text = @"本学期总目标次数";
    }
    return _labTitleTarget;
}

- (UILabel *)labTarget {
    if (!_labTarget) {
        _labTarget = [[UILabel alloc] init];
        _labTarget.font = S17;
        _labTarget.numberOfLines = 0;
        _labTarget.textAlignment = NSTextAlignmentLeft  ;
        _labTarget.textColor = c474A4F;
        _labTarget.text = @"3 次";
    }
    return _labTarget;
}

- (UILabel *)labTitleCalorie {
    if (!_labTitleCalorie) {
        _labTitleCalorie = [[UILabel alloc] init];
        _labTitleCalorie.font = S10;
        _labTitleCalorie.numberOfLines = 0;
        _labTitleCalorie.textAlignment = NSTextAlignmentRight;
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
        _labCalorie.textAlignment = NSTextAlignmentRight;
        _labCalorie.textColor = c474A4F;
        _labCalorie.text = @"1200 千卡";
    }
    return _labCalorie;
}


- (UILabel *)labCount {
    if (!_labCount) {
        _labCount = [[UILabel alloc] init];
        _labCount.font = SS(34);
        _labCount.numberOfLines = 0;
        _labCount.textColor = c474A4F;
        _labCount.text = @"剩余1次";
    }
    return _labCount;
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
