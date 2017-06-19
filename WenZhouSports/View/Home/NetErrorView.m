//
//  ZBJNetErrorView.m
//  lnd
//
//  Created by jia guo on 16/6/29.
//  Copyright © 2016年 zhubaijia. All rights reserved.
//

#import "NetErrorView.h"

@interface NetErrorView()

@property (nonatomic,strong) UIImageView *reloadImageView;
@property (nonatomic,strong) UILabel     *titleLab;
@property (nonatomic,strong) UILabel     *descLab;
@property (nonatomic,copy  ) reloadBlock reloadBlock;

@end

@implementation NetErrorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = cFFFFFF;
        [self initSubviews];
        [self layout];
    }
    return self;
}

- (UIImageView *)reloadImageView
{
    if (!_reloadImageView) {
        _reloadImageView = [[UIImageView alloc] init];
        _reloadImageView.image = [UIImage imageNamed:@"icon_reloadView"];
    }
    
    return _reloadImageView;
}

- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = NSLocalizedString(@"网络故障", @"");
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont systemFontOfSize:20];
        _titleLab.textColor = c474A4F;
    }
    return  _titleLab;
}

- (UILabel *)descLab
{
    if (!_descLab) {
        _descLab = [[UILabel alloc] init];
        _descLab.text = NSLocalizedString(@"不好意思，网络出了点小问题，请稍后重试", @"");
        _descLab.textAlignment = NSTextAlignmentCenter;
        _descLab.font = [UIFont systemFontOfSize:14];
        _descLab.textColor = c474A4F;
        _descLab.numberOfLines = 0;
    }
    return _descLab;
}

- (void)layout
{
    [self.reloadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(43, 42));
        make.top.mas_equalTo(self).offset(96);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(180, 20));
        make.top.mas_equalTo(self.reloadImageView.mas_bottom).offset(16);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.descLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(40);
        make.right.mas_equalTo(self).offset(-39);
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(8);
    }];
}

- (void)initSubviews
{
    [self addSubview:self.reloadImageView];
    [self addSubview:self.titleLab];
    [self addSubview:self.descLab];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
    [self addGestureRecognizer:tap];
}

- (void)tapView
{
    if (self.reloadBlock) {
        self.reloadBlock();
    }
}

- (void)reloadView:(reloadBlock)reloadBlock
{
    self.reloadBlock = reloadBlock;
}


@end
