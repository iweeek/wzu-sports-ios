//
//  SportsDetailView.m
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/8.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "SportsDetailView.h"
#import "RunningActivityModel.h"
#import "AreaActivityModel.h"

@interface SportsDetailView ()
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *standardLabel;
@property (nonatomic, strong) UILabel *sportsAmountLabel;
@property (nonatomic, strong) UILabel *numberOfPeopleLable;
@property (nonatomic, strong) UIView *topCuttingLine;

@property (nonatomic, strong) UIView *middleView;
@property (nonatomic, strong) UIView *middleCuttingLine;
@property (nonatomic, strong) UILabel *speedLabel;// 本次距离
@property (nonatomic, strong) UILabel *speedNumberLabel;
@property (nonatomic, strong) UILabel *timeLabel; // 本次时间
@property (nonatomic, strong) UILabel *timeNumberLabel;
@property (nonatomic, strong) UILabel *distanceLabel; // 本次速度
@property (nonatomic, strong) UILabel *distanceNumberLabel;

@property (nonatomic, strong) UIView *resultView;
@property (nonatomic, strong) UIView *resultCuttingLine;
@property (nonatomic, strong) UILabel *calorieResultLabel;
@property (nonatomic, strong) UILabel *timeResultLabel;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *bottomBackgroundView;
@property (nonatomic, strong) UILabel *bottomDistanceLabel;
@property (nonatomic, strong) UILabel *bottomDistanceNumberLabel;
@property (nonatomic, strong) UILabel *bottomTimeLabel;
@property (nonatomic, strong) UILabel *bottomTimeNumberLabel;
@property (nonatomic, strong) UILabel *bottomSpeedLabel;
@property (nonatomic, strong) UILabel *bottomSpeedNumberLabel;

@property (nonatomic, strong) UIView *pauseView;
@property (nonatomic, strong) UIView *pauseBackground;
@property (nonatomic, strong) UIImageView *pauseImageView;
@property (nonatomic, strong) UILabel *pauseLabel;

// 室外运动相关view
@property (nonatomic, strong) UIView *sportsOutdoorBGView;
@property (nonatomic, strong) UILabel *labSportsOutdoorTitle;
@property (nonatomic, strong) UILabel *labSportsOutdoorStandard;
@property (nonatomic, strong) UIButton *btnSportsOutdoorChangeArae;
@property (nonatomic, strong) UIView *spliteLineViewOutdoor1;
@property (nonatomic, strong) UILabel *labSportsOutdoorDesc;
@property (nonatomic, strong) UILabel *labSportsOutdoorTitleTime;
@property (nonatomic, strong) UILabel *labSportsOutdoorTime;
@property (nonatomic, strong) UIView *spliteLineViewOutdoor2;
@property (nonatomic, strong) UILabel *labSportsOutdoorStandardTime;
@property (nonatomic, strong) UILabel *labSportsOutdoorPeopleCount;

@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *continueButton;
@property (nonatomic, strong) UIButton *endButton;
@property (nonatomic, strong) UIButton *shareButton;

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *shareView;
@property (nonatomic, strong) UIButton *weiboButton;
@property (nonatomic, strong) UIButton *wechatButton;
@property (nonatomic, strong) UIButton *momentsButton;
@property (nonatomic, strong) UIButton *QQButton;
@property (nonatomic, strong) UIButton *QZoneButton;
@property (nonatomic, strong) UIButton *savePictureButton;
@property (nonatomic, strong) UIView *shareCuttingLine;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *shadowView;

//@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, strong) RACSignal *startSignal;
//@property (nonatomic, strong) RACSubject *pauseSignal;
@property (nonatomic, strong) RACSignal *pauseGestureSignal;
@property (nonatomic, strong) RACSignal *continueSignal;
@property (nonatomic, strong) RACSignal *endSignal;
@property (nonatomic, strong) RACSignal *shareSignal;

@property (nonatomic, assign) BOOL hiddenSportsInfo;

@end

@implementation SportsDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = C_EDF0F2;
        [self initSubviews];
        [self makeConstraints];
        _pauseSignal = [RACSubject subject];
    }
    return self;
}

- (void)changeSportsStation:(SportsStation)station {
    switch (station) {
        case SportsWillStart:
        {
            _sportsAmountLabel.text = self.runningSport.name;
            _distanceLabel.text = @"达标距离";
            _timeLabel.text = @"达标时间";
            _speedLabel.text = @"达标速度";
            
            [self setDataWithDistance:self.runningSport.qualifiedDistance
                                 time:self.runningSport.qualifiedCostTime
                                speed:self.runningSport.qualifiedDistance * 1.0 / self.runningSport.qualifiedCostTime];
            break;
        }
        case SportsDidStart:
        {
            _startButton.hidden = YES;
            _continueButton.hidden = YES;
            _endButton.hidden = YES;
            _shareButton.hidden = YES;
            _pauseView.hidden = NO;
            _bottomView.hidden = NO;
            
            _distanceLabel.text = @"当前距离";
            _timeLabel.text = @"耗时";
            _speedLabel.text = @"平均速度";
            
            break;
        }
        case SportsDidPause:
            _startButton.hidden = YES;
            _continueButton.hidden = NO;
            _endButton.hidden = NO;
            _shareButton.hidden = YES;
            _pauseView.hidden = YES;
            
            break;
        case SportsDidEnd: {
            _pauseView.hidden = YES;
            _sportsAmountLabel.hidden = YES;
            _numberOfPeopleLable.hidden = YES;
            _titleLabel.hidden = NO;
            _standardLabel.hidden = NO;
            _startButton.hidden = YES;
            _continueButton.hidden = YES;
            _endButton.hidden = YES;
            _shareButton.hidden = NO;
            _resultView.hidden = NO;
            
            _distanceLabel.text = @"本次距离";
            _timeLabel.text = @"本次耗时";
            _speedLabel.text = @"平均速度";
            
            [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_middleView);
                make.height.mas_equalTo(FIT_LENGTH(53.0));
                make.top.equalTo(_resultView.mas_bottom);
            }];
            [self.shadowView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.bottom.mas_equalTo(-450);
            }];
            if (self.pauseSignal) {
                [self.pauseSignal sendCompleted];
            }
            break;
        }
        case SportsShare:
            break;
        case SportsResult:{
            _pauseView.hidden = YES;
            _sportsAmountLabel.hidden = YES;
            _numberOfPeopleLable.hidden = YES;
            _titleLabel.hidden = NO;
            _standardLabel.hidden = NO;
            _startButton.hidden = YES;
            _continueButton.hidden = YES;
            _endButton.hidden = YES;
            _shareButton.hidden = NO;
            _resultView.hidden = NO;
            
            _distanceLabel.text = @"本次距离";
            _timeLabel.text = @"本次耗时";
            _speedLabel.text = @"平均速度";
            
            [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_middleView);
                make.height.mas_equalTo(FIT_LENGTH(53.0));
                make.top.equalTo(_resultView.mas_bottom);
            }];
            [self.shadowView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.bottom.mas_equalTo(-450);
            }];
            break;
        }
        case SportsAreaOutdoorWillStart:
        {
            self.shadowView.hidden = YES;
            self.sportsOutdoorBGView.hidden = NO;
            self.labSportsOutdoorStandard.hidden = YES;
            self.labSportsOutdoorTitleTime.hidden = YES;
            self.labSportsOutdoorTime.hidden = YES;
            self.labSportsOutdoorDesc.hidden = NO;
            
            _endButton.hidden = YES;
            _shareButton.hidden = YES;
            _pauseView.hidden = YES;
            _startButton.hidden = NO;
            break;
        }
        case SportsAreaOutdoorDidStart:
        {
            self.shadowView.hidden = YES;
            self.sportsOutdoorBGView.hidden = NO;
            self.labSportsOutdoorStandard.hidden = YES;
            self.labSportsOutdoorTitleTime.hidden = NO;
            self.labSportsOutdoorTime.hidden = NO;
            self.labSportsOutdoorDesc.hidden = YES;
            
            _endButton.hidden = YES;
            _shareButton.hidden = YES;
            _pauseView.hidden = NO;
            _startButton.hidden = YES;
            break;
        }
        case SportsAreaOutdoorDidEnd:
        {
            self.shadowView.hidden = YES;
            self.sportsOutdoorBGView.hidden = NO;
            self.btnSportsOutdoorChangeArae.hidden = YES;
            self.labSportsOutdoorStandard.hidden = NO;
            self.labSportsOutdoorTitleTime.hidden = NO;
            self.labSportsOutdoorTime.hidden = NO;
            self.labSportsOutdoorDesc.hidden = YES;
            
            _endButton.hidden = YES;
            _shareButton.hidden = NO;
            _pauseView.hidden = YES;
            _startButton.hidden = YES;

            if (self.pauseSignal) {
                [self.pauseSignal sendCompleted];
            }
            break;
        }
        default:
            break;
    }
}

- (void)initSubviews {
    _mapView = ({
        MAMapView *map = [[MAMapView alloc] initWithFrame:self.frame];
        map.zoomLevel = 19;
        map.zoomEnabled = YES;
        map.showsUserLocation = YES;
        map.showsCompass = YES;//指南针
        map.compassOrigin = CGPointMake(20, HEIGHT - 100);
        map.showsScale = NO;//比例尺
        map.scrollEnabled = YES;
        map.userTrackingMode = MAUserTrackingModeFollow;//追踪移动
        MAUserLocationRepresentation *representation = [[MAUserLocationRepresentation alloc] init];
        representation.showsAccuracyRing = NO;//精度圈是否显示，默认YES
        representation.showsHeadingIndicator = YES;//是否显示方向指示
        
        //执行
        [self.mapView updateUserLocationRepresentation:representation];
        
        map;
    });
    
    // 上方标题view
    _titleView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        
        view;
    });
    _titleLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"运动成果";
        lab.textColor = C_66A7FE;
        lab.font = S14;
        lab.hidden = YES;
        
        lab;
    });
    _standardLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.textColor = C_42CC42;
        lab.text = @"";
        lab.font = S10;
        lab.hidden = YES;
        
        lab;
    });
    _topCuttingLine = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = C_CUTTING_LINE;
        
        view;
    });
    _sportsAmountLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"小运动量";
        lab.font = S14;
        lab.textColor = C_66A7FE;
        
        lab;
    });
    _numberOfPeopleLable = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"0人正在参加";
        lab.font = S10;
        lab.textColor = C_GRAY_TEXT;
        
        lab;
    });
    [_titleView addSubviews:@[_titleLabel, _standardLabel, _topCuttingLine, _sportsAmountLabel, _numberOfPeopleLable]];
    
    // 当前信息View
    _middleView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        
        view;
    });
    _speedLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"平均速度";
        lab.textColor = C_GRAY_TEXT;
        lab.font = S12;
        
        lab;
    });
    _timeLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"耗时";
        lab.textColor = C_GRAY_TEXT;
        lab.font = S12;
        
        lab;
    });
    _distanceLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"即时距离";
        lab.font = S12;
        lab.textColor = C_GRAY_TEXT;
        
        lab;
    });
    _speedNumberLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.font = SS26;
        lab.textColor = c474A4F;
        
        lab;
    });
    _timeNumberLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.font = SS26;
        lab.textColor = c474A4F;
        
        lab;
    });
    _distanceNumberLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.font = SS26;
        lab.textColor = c474A4F;
        
        lab;
    });
    _middleCuttingLine = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = C_CUTTING_LINE;
        
        view;
    });

    [_middleView addSubviews:@[_speedLabel, _timeLabel, _distanceLabel, _middleCuttingLine, _speedNumberLabel, _timeNumberLabel, _distanceNumberLabel]];
    
    // 运动结果view
    _resultView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.hidden = YES;
        
        view;
    });
    _calorieResultLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"本次消耗热量：？大卡";
        lab.font = S12;
        lab.textColor = C_GRAY_TEXT;
        
        lab;
    });
    _timeResultLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.textColor = C_GRAY_TEXT;
        lab.text = @"本次运动时长：？分钟";
        lab.font = S12;
        
        lab;
    });
    [_resultView addSubviews:@[_calorieResultLabel, _timeResultLabel]];
    
    // 达标View
    _bottomView = ({
        UIView *view = [[UIView alloc] init];
        view.hidden = YES;
        
        view;
    });
    _bottomBackgroundView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.5;
        
        view;
    });
    _bottomDistanceLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.textColor = [UIColor whiteColor];
        lab.text = @"达标距离";
        lab.font = S12;
        
        lab;
    });
    _bottomTimeLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"达标耗时";
        lab.textColor = [UIColor whiteColor];
        lab.font = S12;
        
        lab;
    });
    _bottomSpeedLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"达标平均速度";
        lab.textColor = [UIColor whiteColor];
        lab.font = S12;
        
        lab;
    });
    _bottomDistanceNumberLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"6000 米";
        lab.textColor = cFFFFFF;
        lab.font = S12;
        
        lab;
    });
    _bottomSpeedNumberLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"1.0 米/秒";
        lab.textColor = cFFFFFF;
        lab.font = S12;
        
        lab;
    });
    _bottomTimeNumberLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"120 分钟";
        lab.textColor = cFFFFFF;
        lab.font = S12;
        
        lab;
    });
    [_bottomView addSubviews:@[_bottomBackgroundView, _bottomDistanceLabel, _bottomTimeLabel, _bottomSpeedLabel, _bottomDistanceNumberLabel, _bottomTimeNumberLabel, _bottomSpeedNumberLabel]];
    
    // 暂停View
    _pauseView = ({
        UIView *view = [[UIView alloc] init];
        view.hidden = YES;
        
        view;
    });
    _pauseBackground = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        view.alpha = 0.5;
        view.layer.cornerRadius = 23;
        view.layer.masksToBounds = YES;
        
        view;
    });
    _pauseImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = c66A7FE;
        imageView.layer.cornerRadius = 28;
        imageView.layer.masksToBounds = YES;
        imageView.alpha = 1;
        imageView.image = [UIImage imageNamed:@"btn_right_arrow"];
        UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] init];
        [imageView addGestureRecognizer:gesture];
        imageView.userInteractionEnabled = YES;
        _pauseGestureSignal = [gesture rac_gestureSignal];
        
        imageView;
    });
    _pauseLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"滑动停止跑步";
        lab.textColor  = [UIColor whiteColor];
        lab.font = S14;
        
        lab;
    });
    [_pauseView addSubviews:@[_pauseBackground, _pauseImageView, _pauseLabel]];
    
    
    _shadowView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view.layer.shadowOpacity = 0.2;
        view.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        view.layer.shadowColor = [UIColor blackColor].CGColor;
        
        view;
    });
    _startButton = ({
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = C_66A7FE;
        btn.alpha = 0.7;
        [btn setTitle:@"开始" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = S20;
        _startSignal = [btn rac_signalForControlEvents:UIControlEventTouchDown];
        
        btn;
    });
    _continueButton = ({
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = C_66A7FE;
        btn.alpha = 0.7;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:@"继续" forState:UIControlStateNormal];
        btn.hidden = YES;
        btn.titleLabel.font = S20;
        _continueSignal = [btn rac_signalForControlEvents:UIControlEventTouchDown];
        
        btn;
    });
    _endButton = ({
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = C_FF0000;
        btn.alpha = 0.7;
        btn.hidden = YES;
        [btn setTitle:@"结束" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _endSignal = [btn rac_signalForControlEvents:UIControlEventTouchDown];
        
        btn;
    });
    _shareButton = ({
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = C_66A7FE;
        btn.alpha = 0.7;
        btn.hidden = YES;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:@"分享" forState:UIControlStateNormal];
        _shareSignal = [btn rac_signalForControlEvents:UIControlEventTouchDown];
        
        btn;
    });
    _maskView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.5;
        
        view;
    });
    _shareView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        
        view;
    });
    
    [_shadowView addSubviews:@[ _middleView, _titleView, _resultView, _bottomView]];
    
    [self addSubviews:@[_mapView , _shadowView, _bottomView,_pauseView, _startButton, _continueButton, _endButton, _shareButton]];
    
    [self addSubview:self.sportsOutdoorBGView];
    [self.sportsOutdoorBGView addSubview:self.labSportsOutdoorTitle];
    [self.sportsOutdoorBGView addSubview:self.labSportsOutdoorStandard];
    [self.sportsOutdoorBGView addSubview:self.btnSportsOutdoorChangeArae];
    [self.sportsOutdoorBGView addSubview:self.spliteLineViewOutdoor1];
    [self.sportsOutdoorBGView addSubview:self.labSportsOutdoorDesc];
    [self.sportsOutdoorBGView addSubview:self.labSportsOutdoorTitleTime];
    [self.sportsOutdoorBGView addSubview:self.labSportsOutdoorTime];
    [self.sportsOutdoorBGView addSubview:self.spliteLineViewOutdoor2];
    [self.sportsOutdoorBGView addSubview:self.labSportsOutdoorStandardTime];
    [self.sportsOutdoorBGView addSubview:self.labSportsOutdoorPeopleCount];
}

- (UIView *)sportsOutdoorBGView {
    if (!_sportsOutdoorBGView) {
        _sportsOutdoorBGView = [[UIView alloc] init];
        _sportsOutdoorBGView.backgroundColor = cFFFFFF;
        _sportsOutdoorBGView.hidden = YES;
    }
    return _sportsOutdoorBGView;
}

- (UILabel *)labSportsOutdoorTitle {
    if (!_labSportsOutdoorTitle) {
        _labSportsOutdoorTitle = [[UILabel alloc] init];
        _labSportsOutdoorTitle.font = SS(17);
        _labSportsOutdoorTitle.numberOfLines = 0;
        _labSportsOutdoorTitle.textAlignment = NSTextAlignmentLeft;
        _labSportsOutdoorTitle.textColor = c474A4F;
        _labSportsOutdoorTitle.text = @"";
    }
    return _labSportsOutdoorTitle;
}

- (UILabel *)labSportsOutdoorStandard {
    if (!_labSportsOutdoorStandard) {
        _labSportsOutdoorStandard = [[UILabel alloc] init];
        _labSportsOutdoorStandard.font = S(14);
        _labSportsOutdoorStandard.numberOfLines = 0;
        _labSportsOutdoorStandard.textAlignment = NSTextAlignmentLeft;
        _labSportsOutdoorStandard.textColor = c474A4F;
        _labSportsOutdoorStandard.text = @"";
    }
    return _labSportsOutdoorStandard;
}

- (UIView *)spliteLineViewOutdoor1 {
    if (!_spliteLineViewOutdoor1) {
        _spliteLineViewOutdoor1 = [[UIView alloc] init];
        _spliteLineViewOutdoor1.backgroundColor = cSpliteLine;
    }
    return _spliteLineViewOutdoor1;
}

- (UILabel *)labSportsOutdoorDesc {
    if (!_labSportsOutdoorDesc) {
        _labSportsOutdoorDesc = [[UILabel alloc] init];
        _labSportsOutdoorDesc.font = S(14);
        _labSportsOutdoorDesc.numberOfLines = 2;
        _labSportsOutdoorDesc.textAlignment = NSTextAlignmentLeft;
        _labSportsOutdoorDesc.textColor = c474A4F;
        _labSportsOutdoorDesc.text = @"";
    }
    return _labSportsOutdoorDesc;
}

- (UILabel *)labSportsOutdoorTitleTime {
    if (!_labSportsOutdoorTitleTime) {
        _labSportsOutdoorTitleTime = [[UILabel alloc] init];
        _labSportsOutdoorTitleTime.font = S(14);
        _labSportsOutdoorTitleTime.numberOfLines = 2;
        _labSportsOutdoorTitleTime.textAlignment = NSTextAlignmentLeft;
        _labSportsOutdoorTitleTime.textColor = c474A4F;
        _labSportsOutdoorTitleTime.text = @"耗时";
    }
    return _labSportsOutdoorTitleTime;
}

- (UILabel *)labSportsOutdoorTime {
    if (!_labSportsOutdoorTime) {
        _labSportsOutdoorTime = [[UILabel alloc] init];
        _labSportsOutdoorTime.font = S(17);
        _labSportsOutdoorTime.numberOfLines = 2;
        _labSportsOutdoorTime.textAlignment = NSTextAlignmentLeft;
        _labSportsOutdoorTime.textColor = c474A4F;
        _labSportsOutdoorTime.text = @"0:00:00";
    }
    return _labSportsOutdoorTime;
}

- (UIView *)spliteLineViewOutdoor2 {
    if (!_spliteLineViewOutdoor2) {
        _spliteLineViewOutdoor2 = [[UIView alloc] init];
        _spliteLineViewOutdoor2.backgroundColor = cSpliteLine;
    }
    return _spliteLineViewOutdoor2;
}

- (UILabel *)labSportsOutdoorStandardTime {
    if (!_labSportsOutdoorStandardTime) {
        _labSportsOutdoorStandardTime = [[UILabel alloc] init];
        _labSportsOutdoorStandardTime.font = S(14);
        _labSportsOutdoorStandardTime.numberOfLines = 2;
        _labSportsOutdoorStandardTime.textAlignment = NSTextAlignmentLeft;
        _labSportsOutdoorStandardTime.textColor = c474A4F;
        _labSportsOutdoorStandardTime.text = @"达标时间：0分钟";
    }
    return _labSportsOutdoorStandardTime;
}

- (UILabel *)labSportsOutdoorPeopleCount {
    if (!_labSportsOutdoorPeopleCount) {
        _labSportsOutdoorPeopleCount = [[UILabel alloc] init];
        _labSportsOutdoorPeopleCount.font = S(14);
        _labSportsOutdoorPeopleCount.numberOfLines = 2;
        _labSportsOutdoorPeopleCount.textAlignment = NSTextAlignmentLeft;
        _labSportsOutdoorPeopleCount.textColor = c474A4F;
        _labSportsOutdoorPeopleCount.text = @"20人正在参加";
    }
    return _labSportsOutdoorPeopleCount;
}

- (UIButton *)btnSportsOutdoorChangeArae {
    if (!_btnSportsOutdoorChangeArae) {
        _btnSportsOutdoorChangeArae = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnSportsOutdoorChangeArae setTitle:@"地点调整>" forState:UIControlStateNormal];
        _btnSportsOutdoorChangeArae.titleLabel.font = S(14);
        _btnSportsOutdoorChangeArae.backgroundColor = [UIColor clearColor];
        [_btnSportsOutdoorChangeArae setTitleColor:c66A7FE forState:UIControlStateNormal];
        
        self.signalChangeArea = [_btnSportsOutdoorChangeArae rac_signalForControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSportsOutdoorChangeArae;
}

- (void)makeConstraints {
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shadowView).offset(MARGIN_SCREEN);
        make.right.equalTo(self.shadowView).offset(-MARGIN_SCREEN);
        make.top.equalTo(self.shadowView).offset(64 + 11);
        make.height.mas_equalTo(FIT_LENGTH(47.0));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_titleView);
    }];
    [_standardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleView);
        make.right.equalTo(_titleView).offset(-FIT_LENGTH(21.0));
    }];
    [_sportsAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleView).offset(FIT_LENGTH(21.0));
        make.centerY.equalTo(_titleView);
    }];
    [_numberOfPeopleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_standardLabel);
        make.centerY.equalTo(_titleView);
    }];
    [_topCuttingLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(_titleView);
        make.height.mas_equalTo(1.0);
    }];
    [_middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleView.mas_bottom);
        make.left.equalTo(self.shadowView).offset(MARGIN_SCREEN);
        make.right.equalTo(self.shadowView).offset(-MARGIN_SCREEN);
        make.height.mas_equalTo(FIT_LENGTH(77.0));
    }];
    [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-450);
    }];
    
    //户外运动相关
    [self.sportsOutdoorBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shadowView).offset(MARGIN_SCREEN);
        make.right.equalTo(self.shadowView).offset(-MARGIN_SCREEN);
        make.top.mas_equalTo(64);
        make.height.mas_equalTo(129);
    }];
    [self.labSportsOutdoorTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
    }];
    [self.labSportsOutdoorStandard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.labSportsOutdoorTitle);
        make.right.mas_equalTo(-MARGIN_SCREEN);
    }];
    [self.btnSportsOutdoorChangeArae mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.labSportsOutdoorTitle);
        make.right.mas_equalTo(-MARGIN_SCREEN);
    }];
    [self.spliteLineViewOutdoor1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labSportsOutdoorTitle.mas_bottom).offset(10);
        make.left.mas_equalTo(MARGIN_SCREEN);
        make.right.mas_equalTo(-MARGIN_SCREEN);
        make.height.mas_equalTo(1);
    }];
    [self.labSportsOutdoorDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.spliteLineViewOutdoor1).offset(10);
        make.left.mas_equalTo(self.spliteLineViewOutdoor1);
        make.right.mas_equalTo(self.spliteLineViewOutdoor1.mas_right);
    }];
    [self.labSportsOutdoorTitleTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.spliteLineViewOutdoor1).offset(5);
        make.centerX.mas_equalTo(0);
    }];
    [self.labSportsOutdoorTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labSportsOutdoorTitleTime.mas_bottom).offset(5);
        make.centerX.mas_equalTo(0);
    }];
    [self.spliteLineViewOutdoor2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.spliteLineViewOutdoor1).offset(50);
        make.left.mas_equalTo(self.spliteLineViewOutdoor1);
        make.right.mas_equalTo(self.spliteLineViewOutdoor1.mas_right);
        make.height.mas_equalTo(1);
    }];
    [self.labSportsOutdoorStandardTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.spliteLineViewOutdoor2).offset(10);
        make.left.mas_equalTo(self.spliteLineViewOutdoor2);
    }];
    [self.labSportsOutdoorPeopleCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.labSportsOutdoorStandardTime);
        make.right.mas_equalTo(self.spliteLineViewOutdoor2.mas_right);
    }];

    [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_middleView).offset(FIT_LENGTH(17.0));
        make.left.equalTo(_middleView).offset(FIT_LENGTH(20.0));
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_distanceLabel);
        make.centerX.equalTo(_middleView);
    }];
    [_speedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_middleView).offset(-FIT_LENGTH(20.0));
        make.top.equalTo(_distanceLabel);
    }];
    
    [_distanceNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_distanceLabel.mas_bottom);
        make.left.equalTo(_middleView).offset(FIT_LENGTH(20.0));
    }];
    [_timeNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_distanceNumberLabel);
        make.centerX.equalTo(_timeLabel);
    }];
    [_speedNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_distanceNumberLabel);
        make.right.equalTo(_speedLabel);
    }];
    
    [_middleCuttingLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_middleView);
        make.height.mas_equalTo(1.0);
    }];
    [_resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_middleView.mas_bottom);
        make.left.equalTo(self.shadowView).offset(MARGIN_SCREEN);
        make.right.equalTo(self.shadowView).offset(-MARGIN_SCREEN);
        make.height.mas_equalTo(FIT_LENGTH(47.0));
    }];
    [_calorieResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_resultView).offset(FIT_LENGTH(20.0));
        make.centerY.equalTo(_resultView);
    }];
    [_timeResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_resultView).offset(-FIT_LENGTH(20.0));
        make.centerY.equalTo(_resultView);
    }];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_middleView);
        make.top.equalTo(_middleView.mas_bottom);
        make.height.mas_equalTo(FIT_LENGTH(53.0));
    }];
    [_bottomBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_bottomView);
        make.edges.equalTo(_bottomView);
    }];
    [_bottomDistanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomView).offset(MARGIN_SCREEN);
        make.top.equalTo(_bottomView).offset(FIT_LENGTH(10.0));
    }];
    [_bottomTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bottomView);
        make.top.equalTo(_bottomDistanceLabel);
    }];
    [_bottomSpeedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bottomView).offset(-MARGIN_SCREEN);
        make.top.equalTo(_bottomDistanceLabel);
    }];
    [_bottomDistanceNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomDistanceLabel.mas_bottom).offset(FIT_LENGTH(8.0));
        make.left.equalTo(_bottomDistanceLabel);
    }];
    [_bottomTimeNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bottomTimeLabel);
        make.top.equalTo(_bottomDistanceNumberLabel);
    }];
    [_bottomSpeedNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bottomSpeedLabel);
        make.top.equalTo(_bottomDistanceNumberLabel);
    }];
    [_pauseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-72);
        make.height.mas_equalTo(56);
        make.left.mas_equalTo(73);
        make.right.mas_equalTo(-73);
    }];
    [_pauseBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-72);
        make.size.mas_equalTo(CGSizeMake(230, 45));
    }];
    [_pauseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_pauseBackground.mas_left);
        make.centerY.equalTo(_pauseBackground);
        make.size.mas_equalTo(CGSizeMake(56, 56));
    }];
    [_pauseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_pauseBackground);
    }];
    [_startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(56);
    }];
    [_continueButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(WIDTH / 2, FIT_LENGTH(53.0)));
    }];
    [_endButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.size.equalTo(_continueButton);
    }];
    [_shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_startButton);
    }];
}

- (void)setDataWithDistance:(double)distance
                       time:(NSInteger)time
                      speed:(float)speed {
    
    NSString *distanceStr = [NSString stringWithFormat:@"%d 米", (int)distance];
    NSString *timeStr = [NSString stringWithFormat:@"%ld 分钟", time / 60];
    // 取消了“即时速度”,取而代之的是“平均速度”,所有不再使用传过来的速度
    NSString *speedStr = nil;
    if (time == 0) {
        speedStr = @"0 米/秒";
    } else {
        speedStr = [NSString stringWithFormat:@"%.1f 米/秒", distance / time];
    }
    
    NSDictionary *attribute = @{NSFontAttributeName : S10,
                                 NSForegroundColorAttributeName : C_GRAY_TEXT};
    
    NSMutableAttributedString *distanceAttributedString = [[NSMutableAttributedString alloc] initWithString:distanceStr];
    NSMutableAttributedString *timeAttributedString = [[NSMutableAttributedString alloc] initWithString:timeStr];
    NSMutableAttributedString *speedAttributedString = [[NSMutableAttributedString alloc] initWithString:speedStr];
    
    [distanceAttributedString addAttributes:attribute range:NSMakeRange(distanceAttributedString.length - 1, 1)];
    [timeAttributedString addAttributes:attribute range:NSMakeRange(timeAttributedString.length - 2, 2)];
    [speedAttributedString addAttributes:attribute range:NSMakeRange(speedAttributedString.length - 3, 3)];
    
    self.distanceNumberLabel.attributedText = distanceAttributedString;
//    self.timeNumberLabel.attributedText = timeAttributedString;
    self.timeNumberLabel.text = [self getMMSSFromSS:time];
    self.speedNumberLabel.attributedText = speedAttributedString;
    self.numberOfPeopleLable.text = [NSString stringWithFormat:@"%ld人正在参加", (long)self.runningSport.participantNum];
}


- (void)setQualifiedData {
    self.bottomDistanceNumberLabel.text = [NSString stringWithFormat:@"%ld 米", self.runningSport.qualifiedDistance];
    self.bottomTimeNumberLabel.text = [NSString stringWithFormat:@"%ld 分钟", self.runningSport.qualifiedCostTime / 60];

    self.bottomSpeedNumberLabel.text = [NSString stringWithFormat:@"%.1f 米/秒", self.runningSport.qualifiedDistance * 1.0 / self.runningSport.qualifiedCostTime];\
    
}

- (void)setDataWithActivity:(id)activity {
    if ([activity isMemberOfClass:[RunningActivityModel class]]) {
        RunningActivityModel *runningActivity = (RunningActivityModel *)activity;
        // 隐藏“本次运动时长”
        self.timeResultLabel.hidden = YES;
        
        NSString *distanceStr = [NSString stringWithFormat:@"%d 米", (int)runningActivity.distance];
        // 取消了“即时速度”,取而代之的是“平均速度”,所有不再使用传过来的速度
        NSString *speedStr = nil;
        if (runningActivity.costTime == 0) {
            speedStr = @"0 米/秒";
        } else {
            speedStr = [NSString stringWithFormat:@"%.1f 米/秒", runningActivity.distance * 0.1 / runningActivity.costTime];
        }
        
        NSDictionary *attribute = @{NSFontAttributeName : S10,
                                    NSForegroundColorAttributeName : C_GRAY_TEXT};
        
        NSMutableAttributedString *distanceAttributedString = [[NSMutableAttributedString alloc] initWithString:distanceStr];
        NSMutableAttributedString *speedAttributedString = [[NSMutableAttributedString alloc] initWithString:speedStr];
        
        [distanceAttributedString addAttributes:attribute range:NSMakeRange(distanceAttributedString.length - 1, 1)];
        [speedAttributedString addAttributes:attribute range:NSMakeRange(speedAttributedString.length - 3, 3)];
        
        self.distanceNumberLabel.attributedText = distanceAttributedString;
        self.timeNumberLabel.text = [self getMMSSFromSS:runningActivity.costTime];
        self.speedNumberLabel.attributedText = speedAttributedString;
        self.numberOfPeopleLable.text = [NSString stringWithFormat:@"%ld人正在参加", (long)self.runningSport.participantNum];
        self.calorieResultLabel.text = [NSString stringWithFormat:@"本次消耗热量:%ld大卡", runningActivity.kcalConsumed];
    } else {
        AreaActivityModel *areaActivity = (AreaActivityModel *)activity;
        self.labSportsOutdoorTitle.text = areaActivity.areaSport.name;
        if (areaActivity.qualified) {
            self.labSportsOutdoorStandard.text = @"达标";
        } else {
            self.labSportsOutdoorStandard.text = @"未达标";
        }
        self.labSportsOutdoorTime.text = [self getMMSSFromSS:areaActivity.costTime];
        self.labSportsOutdoorStandardTime.text = [NSString stringWithFormat:@"达标时间：%ld分钟", areaActivity.qualifiedCostTime / 60];
        self.labSportsOutdoorPeopleCount.hidden = YES;
    }
    
}


- (void)setDataWithAreaSportsOutdoorPoint:(AreaSportsOutdoorPointModel *)outdoorPoint {
    self.labSportsOutdoorTitle.text = outdoorPoint.name;
    self.labSportsOutdoorDesc.text = outdoorPoint.desc;
}

- (void)setSportsOutdoorTime:(NSInteger)time {
    self.labSportsOutdoorTime.text = [self getMMSSFromSS:time];
}

- (void)setRegion:(MACoordinateRegion)region {
    [self.mapView setRegion:region animated:YES];
}

//传入 秒  得到 xx:xx:xx
-(NSString *)getMMSSFromSS:(NSInteger)seconds {
    NSString *strHour = [NSString stringWithFormat:@"%02ld", seconds / 3600];

    NSString *strMinute = [NSString stringWithFormat:@"%02ld", (seconds % 3600) / 60];

    NSString *strSecond = [NSString stringWithFormat:@"%02ld", seconds % 60];

    NSString *strTime = [NSString stringWithFormat:@"%@:%@:%@", strHour, strMinute,strSecond];
    
    return strTime;
}

- (void)setDataWithCalorie:(NSInteger)calorie time:(NSInteger)time qualified:(BOOL)qualified {
    self.calorieResultLabel.text = [NSString stringWithFormat:@"本次消耗热量:%ld大卡", calorie];
    self.timeResultLabel.text = [NSString stringWithFormat:@"本次运动时长:%ld分钟", time];
    if (qualified) {
        self.standardLabel.text = @"达标";
        self.standardLabel.textColor = C_42CC42;
    } else {
        self.standardLabel.text = @"未达标";
        self.standardLabel.textColor = [UIColor redColor];
    }
}

- (void)setDelegate:(id<MAMapViewDelegate>)delegate {
    self.mapView.delegate = delegate;
}

- (void)addPauseGestureEvent {
    CGFloat centerX = self.pauseImageView.center.x;
    @weakify(self);
    [self.pauseGestureSignal subscribeNext:^(UIPanGestureRecognizer *recognizer) {
        @strongify(self)
        CGFloat x = [recognizer translationInView:self.pauseImageView].x;
        if (x > 0 && x < FIT_LENGTH(194.0)) {
            [UIView animateWithDuration:0.2 animations:^{
                self.pauseImageView.center = CGPointMake(centerX + x, self.pauseImageView.center.y);
            }];
        }
        if (recognizer.state == UIGestureRecognizerStateEnded) {
            if (x > FIT_LENGTH(180.0)) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.pauseImageView.center = CGPointMake(centerX + FIT_LENGTH(194.0), self.pauseImageView.center.y);
                } completion:^(BOOL finished) {
                    if (finished) {
                        [self.pauseSignal sendNext:nil];
                        self.pauseImageView.center = CGPointMake(centerX, self.pauseImageView.center.y);
                    }
                }];
            } else {
                [UIView animateWithDuration:0.2 animations:^{
                    self.pauseImageView.center = CGPointMake(centerX, self.pauseImageView.center.y);
                }];
            }
        }
    }];
}

- (void)changeUserTrackingMode:(MAUserTrackingMode)userTrackingMode {
    self.mapView.userTrackingMode = userTrackingMode;
}

- (void)triggerSportsInfo {
    if (self.hiddenSportsInfo) {
        [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-450);
        }];
    } else {
        [self.shadowView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(self.mas_right);
            make.width.mas_equalTo(WIDTH);
            make.bottom.mas_equalTo(-450);
        }];
    }
    
    @weakify(self);
    [UIView animateWithDuration:0.4 animations:^{
        @strongify(self);
        [self layoutIfNeeded];
    }];
    
    self.hiddenSportsInfo = !self.hiddenSportsInfo;
}

@end
