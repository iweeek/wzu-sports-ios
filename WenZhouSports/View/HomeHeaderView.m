//
//  HomeHeaderView.m
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/2.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "HomeHeaderView.h"

@interface HomeHeaderView ()

@property (nonatomic, strong) UILabel *allTasksLabel;
@property (nonatomic, strong) UILabel *lastTasksLabel;
@property (nonatomic, strong) UILabel *totalCalorieLabel;
@property (nonatomic, strong) UILabel *numberOfCalorieLable;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UIView *cuttingLine;
@property (nonatomic, strong) UIImageView *rankingImageView;
@property (nonatomic, strong) UILabel *rankingLabel;
@property (nonatomic, strong) UIButton *rankingButton;
@property (nonatomic, strong) RACSignal *rankingSignal;
@property (nonatomic, strong) UIView *divideView;
@property (nonatomic, strong) UILabel *sportEventLabel;

@end

@implementation HomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initSubviews];
        [self makeConstraints];
    }
    return self;
}

- (void)initSubviews {
    _allTasksLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.font = S11;
        lab.text = @"本学期总目标次数：3次";
        
        lab;
    });
    _totalCalorieLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.font = S11;
        lab.text = @"累计消耗热量";
        
        lab;
    });
    _numberOfCalorieLable = ({
        UILabel *lab = [[UILabel alloc] init];
        NSString *string = @"1200千卡";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedString addAttribute:NSFontAttributeName value:SS14 range:NSMakeRange(0, string.length - 2)];
        [attributedString addAttribute:NSFontAttributeName value:S10 range:NSMakeRange(string.length - 2, 2)];
        lab.attributedText = attributedString;
        
        lab;
    });
    _lastTasksLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        NSString *string = @"剩余1次";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedString addAttribute:NSFontAttributeName value:S10 range:NSMakeRange(0, string.length)];
        [attributedString addAttribute:NSFontAttributeName value:SS26 range:NSMakeRange(2, 1)];
        lab.attributedText = attributedString;
        
        lab;
    });
    _scoreLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.font = S10;
        lab.text = @"课外锻炼分数";
        
        lab;
    });
    _cuttingLine = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor lightGrayColor];
        
        view;
    });
    _rankingImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        
        imageView;
    });
    _rankingLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.font = S10;
        lab.text = @"校园排行榜";
        
        lab;
    });
    _rankingButton = ({
        UIButton *btn = [[UIButton alloc] init];
        _rankingSignal = [btn rac_signalForControlEvents:UIControlEventTouchDown];
        btn.alpha = 1.0;
        
        btn;
    });
    _divideView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = C_EDF0F2;
        
        view;
    });
    _sportEventLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"运动项目";
        lab.font = S13;
        
        lab;
    });
    
    [self addSubviews:@[_allTasksLabel, _lastTasksLabel, _totalCalorieLabel, _numberOfCalorieLable,
                        _scoreLabel, _cuttingLine, _rankingLabel, _rankingImageView, _rankingButton,
                        _divideView, _sportEventLabel]];

}

- (void)makeConstraints {
    [_allTasksLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(FIT_LENGTH(11.0));
        make.left.equalTo(self).offset(MARGIN_SCREEN);
    }];
    [_totalCalorieLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_allTasksLabel);
        make.right.equalTo(self).offset(-MARGIN_SCREEN);
    }];
    [_numberOfCalorieLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_allTasksLabel.mas_bottom).offset(FIT_LENGTH(8.0));
        make.right.equalTo(_totalCalorieLabel);
    }];
    [_lastTasksLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(FIT_LENGTH(80.0));
        make.centerX.equalTo(self);
    }];
    [_scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lastTasksLabel.mas_bottom).offset(FIT_LENGTH(13.0));
        make.centerX.equalTo(self);
    }];
    [_cuttingLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(WIDTH - FIT_LENGTH(16.0));
        make.height.mas_equalTo(0.5);
        make.centerX.equalTo(self);
        make.top.equalTo(_scoreLabel.mas_bottom).offset(FIT_LENGTH(13.0));
    }];
    [_rankingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(FIT_LENGTH(20.0));
        make.top.equalTo(_cuttingLine.mas_bottom).offset(FIT_LENGTH(14.0));
    }];
    [_rankingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_rankingImageView.mas_right).offset(FIT_LENGTH(5.0));
        make.top.equalTo(_cuttingLine.mas_bottom).offset(FIT_LENGTH(18.0));
    }];
    [_rankingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(_cuttingLine.mas_bottom);
        make.height.mas_equalTo(FIT_LENGTH(48.0));
    }];
//    [_divideView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_rankingButton.mas_bottom);
//        make.left.right.equalTo(self);
//        make.height.mas_equalTo(FIT_LENGTH(11.0));
//    }];
//    [_sportEventLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_divideView.mas_bottom).offset(FIT_LENGTH(13.0));
//        make.centerX.equalTo(self);
//    }];
}

@end
