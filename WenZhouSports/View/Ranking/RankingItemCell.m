//
//  RankingItemCell.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/18.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "RankingItemCell.h"
#import "StudentTimeCostedModel.h"

@interface RankingItemCell ()

@property (nonatomic, strong) UILabel *labNum;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *labName;
@property (nonatomic, strong) UILabel *labTime;

@end

@implementation RankingItemCell

- (void)setupWithData:(id)data index:(NSInteger)index {
    StudentTimeCostedModel *model = (StudentTimeCostedModel *)data;
    
    self.labNum.text = [NSString stringWithFormat:@"%ld", index + 1];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.avatarUrl]
                    placeholderImage:[UIImage imageNamed:@"icon_item_avatar"]];
    self.labName.text = model.studentName;
    NSInteger time = model.timeCosted / 60 ;
    self.labTime.text = [NSString stringWithFormat:@"%ld 分钟", (long)time];
}

- (void)createUI {
    [self.contentView addSubview:self.labNum];
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.labName];
    [self.contentView addSubview:self.labTime];
}

- (void)layout {
    [self.labNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(20);
    }];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.labNum.mas_right).offset(7);
        make.size.mas_equalTo(CGSizeMake(46, 46));
    }];
    [self.labName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.imgView.mas_right).offset(7);
    }];
    [self.labTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(0);
    }];
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.layer.cornerRadius = 23;
        _imgView.layer.masksToBounds = YES;
    }
    return _imgView;
}

- (UILabel *)labNum {
    if (!_labNum) {
        _labNum = [[UILabel alloc] init];
        _labNum.font = S(15);
        _labNum.numberOfLines = 0;
        _labNum.textAlignment = NSTextAlignmentLeft;
        _labNum.textColor = c474A4F;
        _labNum.text = @"";
    }
    return _labNum;
}

- (UILabel *)labName {
    if (!_labName) {
        _labName = [[UILabel alloc] init];
        _labName.font = S(15);
        _labName.numberOfLines = 0;
        _labName.textAlignment = NSTextAlignmentLeft;
        _labName.textColor = c474A4F;
        _labName.text = @"";
    }
    return _labName;
}
- (UILabel *)labTime {
    if (!_labTime) {
        _labTime = [[UILabel alloc] init];
        _labTime.font = S(17);
        _labTime.numberOfLines = 0;
        _labTime.textAlignment = NSTextAlignmentLeft;
        _labTime.textColor = c7E848C;
        _labTime.text = @"";
    }
    return _labTime;
}


@end
