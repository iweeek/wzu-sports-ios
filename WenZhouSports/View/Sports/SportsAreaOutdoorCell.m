//
//  SportsAreaOutdoorCell.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/7/27.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "SportsAreaOutdoorCell.h"
#import "AreaSportsOutdoorPointModel.h"

@interface SportsAreaOutdoorCell ()

@property (nonatomic, strong) UILabel *labName;
@property (nonatomic, strong) UILabel *labAddress;
@property (nonatomic, strong) UILabel *labTime;
@property (nonatomic, strong) UIImageView *selectImgView;
@property (nonatomic, strong) UIView *spliteLineView;

@end

@implementation SportsAreaOutdoorCell

- (void)setupWithData:(id)data {
    AreaSportsOutdoorPointModel *areaOutdoor = (AreaSportsOutdoorPointModel *)data;
    
    self.labName.text = areaOutdoor.name;
    self.labAddress.text = areaOutdoor.addr;
//    self.labTime.text = [NSString stringWithFormat:@""];
}

- (void)createUI {
    [self.contentView addSubview:self.labName];
    [self.contentView addSubview:self.labAddress];
    [self.contentView addSubview:self.labTime];
    [self.contentView addSubview:self.selectImgView];
    [self.contentView addSubview:self.spliteLineView];
}

- (void)layout {
    [self.labName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.mas_equalTo(18);
        make.width.mas_equalTo(160);
    }];
    [self.labAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labName.mas_bottom).offset(4);
        make.left.mas_equalTo(self.labName);
        make.right.mas_equalTo(-18);
    }];
    [self.labTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-65);
        make.centerY.mas_equalTo(self.labName);
    }];
    [self.selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.spliteLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
}

- (UILabel *)labName {
    if (!_labName) {
        _labName = [[UILabel alloc] init];
        _labName.font = S(15);
        _labName.numberOfLines = 1;
        _labName.textAlignment = NSTextAlignmentLeft;
        _labName.textColor = c474A4F;
        _labName.text = @"温州大学南校区体育馆";
    }
    return _labName;
}

- (UILabel *)labAddress {
    if (!_labAddress) {
        _labAddress = [[UILabel alloc] init];
        _labAddress.font = S(13);
        _labAddress.numberOfLines = 1;
        _labAddress.textAlignment = NSTextAlignmentLeft;
        _labAddress.textColor = c7E848C;
        _labAddress.text = @"浙江省温州市瓯海区夏鼐路与承焘路交叉口东100米";
    }
    return _labAddress;
}

- (UILabel *)labTime {
    if (!_labTime) {
        _labTime = [[UILabel alloc] init];
        _labTime.font = S(13);
        _labTime.numberOfLines = 0;
        _labTime.textAlignment = NSTextAlignmentLeft;
        _labTime.textColor = c474A4F;
        _labTime.hidden = YES;
        _labTime.text = @"达标时间：60分钟";
    }
    return _labTime;
}

- (UIImageView *)selectImgView {
    if (!_selectImgView) {
        _selectImgView = [[UIImageView alloc] init];
        _selectImgView.image = [UIImage imageNamed:@"icon_selected"];
        _selectImgView.hidden = YES;
    }
    return _selectImgView;
}

- (UIView *)spliteLineView {
    if (!_spliteLineView) {
        _spliteLineView = [[UIView alloc] init];
        _spliteLineView.backgroundColor = cSpliteLine;
    }
    return _spliteLineView;
}

@end
