//
//  SportsDetailView.m
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/8.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "SportsDetailView.h"
#import "MAMutablePolyline.h"
#import "MAMutablePolylineRenderer.h"

@interface SportsDetailView ()

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *standardLabel;
@property (nonatomic, strong) UILabel *sportsAmountLabel;
@property (nonatomic, strong) UILabel *numberOfPeopleLable;
@property (nonatomic, strong) UIView *topCuttingLine;
@property (nonatomic, strong) UIView *middleView;
@property (nonatomic, strong) UIView *middleCuttingLine;
@property (nonatomic, strong) UILabel *speedLabel;
@property (nonatomic, strong) UILabel *speedNumberLabel;
@property (nonatomic, strong) UILabel *stageLabel;
@property (nonatomic, strong) UILabel *stageNumberLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *distanceNumberLabel;
@property (nonatomic, strong) UIView *resultView;
@property (nonatomic, strong) UIView *resultCuttingLine;
@property (nonatomic, strong) UILabel *calorieResultLabel;
@property (nonatomic, strong) UILabel *timeResultLabel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *bottomBackgroundView;
@property (nonatomic, strong) UILabel *bottomSpeedLabel;
@property (nonatomic, strong) UILabel *bottomSpeedNumberLabel;
@property (nonatomic, strong) UILabel *bottomStageLabel;
@property (nonatomic, strong) UILabel *bottomStageNumberLabel;
@property (nonatomic, strong) UILabel *bottomDistanceLabel;
@property (nonatomic, strong) UILabel *bottomDistanceNumberLabel;
@property (nonatomic, strong) UIView *pauseView;
@property (nonatomic, strong) UIView *pauseBackground;
@property (nonatomic, strong) UIImageView *pauseImageView;
@property (nonatomic, strong) UILabel *pauseLabel;
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

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) MAMutablePolyline *line;
@property (nonatomic, strong) MAMutablePolylineRenderer *render;

@property (nonatomic, strong) RACSignal *startSignal;
@property (nonatomic, strong) RACSubject *pauseSignal;
@property (nonatomic, strong) RACSignal *pauseGestureSignal;
@property (nonatomic, strong) RACSignal *continueSignal;
@property (nonatomic, strong) RACSignal *endSignal;
@property (nonatomic, strong) RACSignal *shareSignal;

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

- (void)initSubviews {
    _mapView = ({
        MAMapView *map = [[MAMapView alloc] initWithFrame:self.frame];
        map.zoomLevel = 18;
        map.showsUserLocation = YES;
        map.userTrackingMode = MAUserTrackingModeFollow;
        _line = [[MAMutablePolyline alloc] initWithPoints:@[]];
        [map addOverlay:_line];
        map.delegate = self;

        map;
    });
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
        lab.text = @"达标！";
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
        lab.text = @"?人正在参加";
        lab.font = S10;
        lab.textColor = C_GRAY_TEXT;
        
        lab;
    });
    [_titleView addSubviews:@[_titleLabel, _standardLabel, _topCuttingLine, _sportsAmountLabel, _numberOfPeopleLable]];
    _middleView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        
        view;
    });
    _speedLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"本次速度";
        lab.textColor = C_GRAY_TEXT;
        lab.font = S12;
        
        lab;
    });
    _stageLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"完成段数";
        lab.textColor = C_GRAY_TEXT;
        lab.font = S12;
        
        lab;
    });
    _distanceLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"本次运动距离";
        lab.font = S12;
        lab.textColor = C_GRAY_TEXT;
        
        lab;
    });
    _speedNumberLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        
        lab;
    });
    _stageNumberLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        
        lab;
    });
    _distanceNumberLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        
        lab;
    });
    _middleCuttingLine = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = C_CUTTING_LINE;
        
        view;
    });

    [_middleView addSubviews:@[_speedLabel, _stageLabel, _distanceLabel, _middleCuttingLine, _speedNumberLabel, _stageNumberLabel, _distanceNumberLabel]];
    _resultView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.hidden = YES;
        
        view;
    });
    _calorieResultLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"本次消耗热量：？千卡";
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
    _bottomSpeedLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.textColor = [UIColor whiteColor];
        lab.text = @"达标速度";
        lab.font = S12;
        
        lab;
    });
    _bottomStageLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"分段段数";
        lab.textColor = [UIColor whiteColor];
        lab.font = S12;
        
        lab;
    });
    _bottomDistanceLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"每段最短距离";
        lab.textColor = [UIColor whiteColor];
        lab.font = S12;
        
        lab;
    });
    _bottomSpeedNumberLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        
        lab;
    });
    _bottomDistanceNumberLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        
        lab;
    });
    _bottomStageNumberLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        
        lab;
    });
    [_bottomView addSubviews:@[_bottomBackgroundView, _bottomSpeedLabel, _bottomStageLabel, _bottomDistanceLabel, _bottomSpeedNumberLabel, _bottomStageNumberLabel, _bottomDistanceNumberLabel]];
    
    _pauseView = ({
        UIView *view = [[UIView alloc] init];
        view.hidden = YES;
        
        view;
    });
    _pauseBackground = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.5;
        view.layer.cornerRadius = FIT_LENGTH(21.0);
        
        view;
    });
    _pauseImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
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
        view.backgroundColor = [UIColor whiteColor];
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
    
    
    [self addSubviews:@[_mapView ,_shadowView, _middleView, _titleView, _resultView, _bottomView,
                        _pauseView, _startButton, _continueButton, _endButton, _shareButton]] ;
}

- (void)makeConstraints {
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(MARGIN_SCREEN);
        make.right.equalTo(self).offset(-MARGIN_SCREEN);
        make.top.equalTo(self).offset(FIT_LENGTH(11.0));
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
        make.left.equalTo(self).offset(MARGIN_SCREEN);
        make.right.equalTo(self).offset(-MARGIN_SCREEN);
        make.height.mas_equalTo(FIT_LENGTH(77.0));
    }];
    [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleView);
        make.left.right.equalTo(_middleView);
        make.bottom.equalTo(_middleView);
    }];
    [_speedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_middleView).offset(FIT_LENGTH(17.0));
        make.left.equalTo(_middleView).offset(FIT_LENGTH(20.0));
    }];
    [_stageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_speedLabel);
        make.centerX.equalTo(_middleView);
    }];
    [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_middleView).offset(-FIT_LENGTH(20.0));
        make.top.equalTo(_speedLabel);
    }];
    [_speedNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_middleView).offset(FIT_LENGTH(20.0));
        make.top.equalTo(_speedLabel.mas_bottom);
    }];
    [_stageNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_speedNumberLabel);
        make.centerX.equalTo(_stageLabel);
    }];
    [_distanceNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_speedNumberLabel);
        make.right.equalTo(_distanceLabel);
    }];
    [_middleCuttingLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_middleView);
        make.height.mas_equalTo(1.0);
    }];
    [_resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_middleView.mas_bottom);
        make.left.equalTo(self).offset(MARGIN_SCREEN);
        make.right.equalTo(self).offset(-MARGIN_SCREEN);
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
    [_bottomSpeedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomView).offset(MARGIN_SCREEN);
        make.top.equalTo(_bottomView).offset(FIT_LENGTH(10.0));
    }];
    [_bottomStageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bottomView);
        make.top.equalTo(_bottomSpeedLabel);
    }];
    [_bottomDistanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bottomView).offset(-MARGIN_SCREEN);
        make.top.equalTo(_bottomSpeedLabel);
    }];
    [_bottomSpeedNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomSpeedLabel.mas_bottom).offset(FIT_LENGTH(8.0));
        make.left.equalTo(_bottomSpeedLabel);
    }];
    [_bottomStageNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bottomStageLabel);
        make.top.equalTo(_bottomSpeedNumberLabel);
    }];
    [_bottomDistanceNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bottomDistanceLabel);
        make.top.equalTo(_bottomSpeedNumberLabel);
    }];
    [_pauseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-FIT_LENGTH(70.0));
        make.size.mas_equalTo(CGSizeMake(FIT_LENGTH(246.0), FIT_LENGTH(52.0)));
    }];
    [_pauseBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-FIT_LENGTH(70.0));
        make.size.mas_equalTo(CGSizeMake(FIT_LENGTH(194.0), FIT_LENGTH(42.0)));
    }];
    [_pauseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_pauseBackground.mas_left);
        make.centerY.equalTo(_pauseBackground);
    }];
    [_pauseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_pauseBackground);
    }];
    [_startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(FIT_LENGTH(53.0));
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

- (void)changeSportsStation:(SportsStation)station {
    switch (station) {
        case SportsWillStart:
            break;
        case SportsDidStart:
            _startButton.hidden = YES;
            _continueButton.hidden = YES;
            _endButton.hidden = YES;
            _shareButton.hidden = YES;
            _pauseView.hidden = NO;
            _bottomView.hidden = NO;

            break;
        case SportsDidPause:
            _startButton.hidden = YES;
            _continueButton.hidden = NO;
            _endButton.hidden = NO;
            _shareButton.hidden = YES;
            _pauseView.hidden = YES;

            break;
        case SportsDidEnd: {
            _sportsAmountLabel.hidden = YES;
            _numberOfPeopleLable.hidden = YES;
            _titleLabel.hidden = NO;
            _standardLabel.hidden = NO;
            _startButton.hidden = YES;
            _continueButton.hidden = YES;
            _endButton.hidden = YES;
            _shareButton.hidden = NO;
            _resultView.hidden = NO;
            [_bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_middleView);
                make.height.mas_equalTo(FIT_LENGTH(53.0));
                make.top.equalTo(_resultView.mas_bottom);
            }];
            [_shadowView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_titleView);
                make.left.right.equalTo(_middleView);
                make.bottom.equalTo(_resultView);
            }];
            if (_pauseSignal) {
                [_pauseSignal sendCompleted];
            }
            break;
        }
        case SportsShare:
            break;
        default:
            break;
    }
}

- (void)setDataWithSpeed:(NSString *)speed distance:(NSInteger)distance stage:(NSInteger)stage {
    NSString *speedString = [NSString stringWithFormat:@"%@米/秒", speed];
    NSString *stageString = [NSString stringWithFormat:@"%ld段", distance / stage];
    NSString *distanceString = [NSString stringWithFormat:@"%ld米", distance];
    NSDictionary *attribute1 = @{NSFontAttributeName : SS26,
                                 NSForegroundColorAttributeName : C_66A7FE};
    NSDictionary *attribute2 = @{NSFontAttributeName : S10,
                                 NSForegroundColorAttributeName : C_GRAY_TEXT};
    NSMutableAttributedString *speedAttributedString = [[NSMutableAttributedString alloc] initWithString:speedString];
    NSMutableAttributedString *stageAttributedString = [[NSMutableAttributedString alloc] initWithString:stageString];
    NSMutableAttributedString *distanceAttributedString = [[NSMutableAttributedString alloc] initWithString:distanceString];
    [speedAttributedString addAttributes:attribute1 range:NSMakeRange(0, speedString.length - 3)];
    [speedAttributedString addAttributes:attribute2 range:NSMakeRange(speedString.length - 3, 3)];
    [stageAttributedString addAttributes:attribute1 range:NSMakeRange(0, stageString.length - 1)];
    [stageAttributedString addAttributes:attribute2 range:NSMakeRange(stageString.length - 1, 1)];
    [distanceAttributedString addAttributes:attribute1 range:NSMakeRange(0, distanceString.length - 1)];
    [distanceAttributedString addAttributes:attribute2 range:NSMakeRange(distanceString.length - 1, 1)];
    _speedNumberLabel.attributedText = speedAttributedString;
    _stageNumberLabel.attributedText = stageAttributedString;
    _distanceNumberLabel.attributedText = distanceAttributedString;
}

- (void)setDataWithCalorie:(int)calorie time:(int)time {
    _calorieResultLabel.text = [NSString stringWithFormat:@"本次消耗热量:%d千卡", calorie];
    _timeResultLabel.text = [NSString stringWithFormat:@"本次运动时长:%d分钟", time];
}

- (void)addPauseGestureEvent {
    CGFloat centerX = _pauseImageView.center.x;
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
                        [_pauseSignal sendNext:nil];
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

- (void)addPolygonLine:(CLLocation *)location {
    [_line appendPoint:MAMapPointForCoordinate(location.coordinate)];
    [_mapView setCenterCoordinate:location.coordinate animated:YES];
    
    [self.render invalidatePath];
}

/**
 高德地图折现配置

 @param mapView mapView description
 @param overlay overlay description
 @return return value description
 */
- (MAOverlayPathRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAMutablePolyline class]])
    {
        MAMutablePolylineRenderer *renderer = [[MAMutablePolylineRenderer alloc] initWithOverlay:overlay];
        renderer.lineWidth = 4.0f;
        
        renderer.strokeColor = C_66A7FE;
        
        _render = renderer;
        
        return renderer;
    }
    
    return nil;

}
@end
