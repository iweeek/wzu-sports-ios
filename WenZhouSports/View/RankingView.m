//
//  RankingView.m
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/6.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "RankingView.h"
#import "UIImageView+Hexagon.h"

@interface RankingView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) RankingHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RACSignal *selectCalorieSignal;
@property (nonatomic, strong) RACSignal *selectTimeSignal;

@end

@implementation RankingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
        [self makeConstraints];
    }
    return self;
}

- (void)initSubviews {
    _tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, WIDTH, HEIGHT) style:UITableViewStylePlain];
        _headerView = [[RankingHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, WIDTH, FIT_LENGTH(255.0))];
        tableView.tableHeaderView = _headerView;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _selectCalorieSignal = _headerView.selectCalorieSignal;
        _selectTimeSignal = _headerView.selectTimeSignal;
        [tableView registerClass:[RankingCell class] forCellReuseIdentifier:@"RankingCell"];
        tableView.delegate = self;
        tableView.dataSource = self;
        
        
        tableView;
    });
    [self addSubviews:@[_tableView]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RankingCell * cell =  [tableView dequeueReusableCellWithIdentifier:@"RankingCell" forIndexPath:indexPath];
    [cell setNeedsDisplay];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FIT_LENGTH(66.0);
}

- (void)makeConstraints {
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setDataWithCalorie:(id)data {
    [_headerView selectCalorieAnimate];
    [_tableView reloadData];
}

- (void)setDataWithTime:(id)data {
    [_headerView selectTimeAnimate];
    [_tableView reloadData];
}

@end

@interface RankingHeaderView ()

@property (nonatomic, strong) UIButton *selectCalorieButton;
@property (nonatomic, strong) UIButton *selectTimeButton;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *selectLine;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *cuttingView;
@property (nonatomic, strong) UIImageView *firstImageView;
@property (nonatomic, strong) UIImageView *secondImageView;
@property (nonatomic, strong) UIImageView *thirdImageView;
@property (nonatomic, strong) UILabel *firstNameLabel;
@property (nonatomic, strong) UILabel *secondNameLabel;
@property (nonatomic, strong) UILabel *thirdNameLabel;
@property (nonatomic, strong) UILabel *firstDataLabel;
@property (nonatomic, strong) UILabel *secondDataLabel;
@property (nonatomic, strong) UILabel *thirdDataLabel;

@property (nonatomic, strong) RACSignal *selectCalorieSignal;
@property (nonatomic, strong) RACSignal *selectTimeSignal;

@end

@implementation RankingHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
        [self makeConstraints];
    }
    return self;
}

- (void)initSubviews {
    _selectCalorieButton = ({
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:@"累计消耗热量" forState:UIControlStateNormal];
        [btn setTitleColor:C_66A7FE forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.titleLabel.font = S13;
        _selectCalorieSignal = [btn rac_signalForControlEvents:UIControlEventTouchDown];
        
        btn;
    });
    _selectTimeButton = ({
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:@"累计锻炼时长" forState:UIControlStateNormal];
        [btn setTitleColor:C_DARK_TEXT forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.titleLabel.font = S13;
        _selectTimeSignal = [btn rac_signalForControlEvents:UIControlEventTouchDown];

        btn;
    });
    _topView = ({
        UIView *view = [[UIView alloc] init];
        view.layer.shadowOffset = CGSizeMake(0.0, -2.5);
        view.layer.shadowOpacity = 0.6;
        view.layer.shadowColor = [UIColor grayColor].CGColor;
        view.backgroundColor = [UIColor whiteColor];
        
        view;
    });
    _selectLine = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, FIT_LENGTH(46.0), WIDTH / 2, FIT_LENGTH(2.0))];
        [view setBackgroundColor:C_66A7FE];
        
        view;
    });
    _firstImageView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, FIT_LENGTH(87.0), FIT_LENGTH(87.0))];
        [imageView cutHexagonWithImage:[UIImage imageNamed:@"第一名头像"]];
        
        imageView;
    });
    _secondImageView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, FIT_LENGTH(67.0), FIT_LENGTH(67.0))];
        [imageView cutHexagonWithImage:[UIImage imageNamed:@"第二名头像"]];
        
        imageView;
    });
    _thirdImageView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, FIT_LENGTH(67.0), FIT_LENGTH(67.0))];
        [imageView cutHexagonWithImage:[UIImage imageNamed:@"第二名头像"]];
        
        imageView;
    });
    _firstNameLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"name";
        lab.font = S14;
        lab.textColor = C_DARK_TEXT;
        
        lab;
    });
    _secondNameLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"name";
        lab.font = S14;
        lab.textColor = C_DARK_TEXT;
        
        lab;
    });
    _thirdNameLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"name";
        lab.font = S14;
        lab.textColor = C_DARK_TEXT;
        
        lab;
    });
    _firstDataLabel =  ({
        UILabel *lab = [[UILabel alloc] init];
        lab.textColor = C_GRAY_TEXT;
        lab.text = @"data";
        lab.font = S8;
        
        lab;
    });
    _secondDataLabel =  ({
        UILabel *lab = [[UILabel alloc] init];
        lab.textColor = C_GRAY_TEXT;
        lab.text = @"data";
        lab.font = S8;
        
        lab;
    });
    _thirdDataLabel =  ({
        UILabel *lab = [[UILabel alloc] init];
        lab.textColor = C_GRAY_TEXT;
        lab.text = @"data";
        lab.font = S8;
        
        lab;
    });
    _contentView = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.layer.shadowColor = [UIColor blackColor].CGColor;
        view.layer.shadowOffset = CGSizeMake(0.0, -1.0);
        view.layer.shadowOpacity = 0.6;
        
        view;
    });
    [_contentView addSubviews:@[_firstImageView, _secondImageView, _thirdImageView,
                                _firstNameLabel, _secondNameLabel, _thirdNameLabel,
                                _firstDataLabel, _secondDataLabel, _thirdDataLabel]];
    _cuttingView = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:C_EDF0F2];
        
        view;
    });
    [self addSubviews:@[_cuttingView, _contentView, _topView, _selectTimeButton,
                        _selectCalorieButton, _selectLine]];
}

- (void)makeConstraints {
    [_selectCalorieButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(WIDTH / 2, FIT_LENGTH(48.0)));
        make.top.equalTo(self);
    }];
    [_selectTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_selectCalorieButton.mas_right);
        make.top.equalTo(_selectCalorieButton);
        make.size.equalTo(_selectCalorieButton);
    }];
    [_firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_selectCalorieButton.mas_bottom).offset(FIT_LENGTH(34.0));
        make.size.mas_equalTo(CGSizeMake(FIT_LENGTH(87.0), FIT_LENGTH(87.0)));
    }];
    [_secondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView.mas_left).offset(FIT_LENGTH(33.0));
        make.top.equalTo(_contentView).offset(FIT_LENGTH(54.0));
        make.size.mas_equalTo(CGSizeMake(FIT_LENGTH(67.0), FIT_LENGTH(67.0)));
    }];
    [_thirdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_contentView.mas_right).offset(-FIT_LENGTH(33.0));
        make.top.equalTo(_secondImageView);
        make.size.equalTo(_secondImageView);
    }];
    [_firstNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_firstImageView.mas_bottom).offset(FIT_LENGTH(22.0));
        make.centerX.equalTo(_firstImageView);
    }];
    [_secondNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_firstNameLabel);
        make.centerX.equalTo(_secondImageView);
    }];
    [_thirdNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_firstNameLabel);
        make.centerX.equalTo(_thirdImageView);
    }];
    [_firstDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_firstNameLabel.mas_bottom).offset(FIT_LENGTH(6.0));
        make.centerX.equalTo(_firstImageView);
    }];
    [_secondDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_secondImageView);
        make.centerY.equalTo(_firstDataLabel);
    }];
    [_thirdDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_firstDataLabel);
        make.centerX.equalTo(_thirdImageView);
    }];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(_selectCalorieButton.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(WIDTH, FIT_LENGTH(191.0)));
    }];
    [_cuttingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(_contentView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(WIDTH, FIT_LENGTH(12.0)));
    }];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_selectCalorieButton);
        make.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(WIDTH,FIT_LENGTH(48.0)));
    }];
}

- (void)selectCalorieAnimate {
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _selectLine.center = CGPointMake(WIDTH / 4, _selectLine.center.y);
    } completion:nil];
    [_selectCalorieButton setTitleColor:C_66A7FE forState:UIControlStateNormal];
    [_selectTimeButton setTitleColor:C_GRAY_TEXT forState:UIControlStateNormal];

}

- (void)selectTimeAnimate {
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _selectLine.center = CGPointMake(WIDTH / 4 * 3, _selectLine.center.y);
    } completion:nil];
    [_selectCalorieButton setTitleColor:C_GRAY_TEXT forState:UIControlStateNormal];
    [_selectTimeButton setTitleColor:C_66A7FE forState:UIControlStateNormal];
}
@end

@interface RankingCell ()

@property (nonatomic, strong) UILabel *rankingNumberLabel;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *dataLabel;

@end

@implementation RankingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
        [self makeConstraints];
    }
    return self;
}

- (void)initSubviews {
    _rankingNumberLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.font = S14;
        lab.textColor = C_DARK_TEXT;
        
        lab;
    });
    _avatarImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setImage:[UIImage imageNamed:@"其他排名头像"]];
        imageView.layer.cornerRadius = FIT_LENGTH(21.5);
        [imageView.layer masksToBounds];
        
        imageView;
    });
    _nameLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.font = S14;
        lab.textColor = C_DARK_TEXT;
        lab.text = @"name";
        
        lab;
    });
    _dataLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        
        lab;
    });
    [self.contentView addSubviews:@[_rankingNumberLabel, _avatarImageView, _nameLabel, _dataLabel]];
}

- (void)makeConstraints {
    [_rankingNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(MARGIN_SCREEN);
        make.centerY.equalTo(self.contentView);
    }];
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_rankingNumberLabel.mas_right).offset(FIT_LENGTH(9.0));
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(FIT_LENGTH(43.0), FIT_LENGTH(43.0)));
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatarImageView.mas_right).offset(8.0);
        make.centerY.equalTo(self.contentView);
    }];
    [_dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-MARGIN_SCREEN);
        make.centerY.equalTo(self.contentView);
    }];
}

@end
