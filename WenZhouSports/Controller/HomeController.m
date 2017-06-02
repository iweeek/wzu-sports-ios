//
//  HomeController.m
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/3.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "HomeController.h"
#import "HomeHeaderView.h"
#import "PersonalCenterView.h"
#import "RankingController.h"
#import "SportsDetailsController.h"
#import "SportsDetailViewModel.h"
#import "SportsHistoryController.h"
#import "HomeItemCell.h"

@interface HomeController () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HomeHeaderView *headerView;
@property (nonatomic, strong) PersonalCenterView *personalCenterView;
@property (nonatomic, strong) UIView *midView;

@end

CGFloat proportion = 0.84;

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"课外体育锻炼";
    self.view.backgroundColor = cFFFFFF;
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)initSubviews {
    _tableView = ({
        UITableView *tv = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, WIDTH, HEIGHT) style:UITableViewStyleGrouped];
        tv.delegate = self;
        tv.dataSource = self;
        _headerView = [[HomeHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, WIDTH, FIT_LENGTH(302.0))];
        tv.tableHeaderView = _headerView;
        [_headerView.rankingSignal subscribeNext:^(id  _Nullable x) {
            RankingController *controller = [[RankingController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }];
        
        [tv registerClass:[HomeItemCell class]
           forCellReuseIdentifier:NSStringFromClass([HomeItemCell class])];
        
        tv;
    });
    [self.view addSubview: _tableView];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] init];
    panGesture.delegate = self;
    RACSignal *signal = [panGesture rac_gestureSignal];
    [self.tableView addGestureRecognizer:panGesture];
    
    _midView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(WIDTH * proportion, 0.0, WIDTH * (1 - proportion), HEIGHT)];
        view.hidden = YES;
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.5;
        
        view;
    });
    [self.view addSubview:_midView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    UIPanGestureRecognizer *midPanGesture = [[UIPanGestureRecognizer alloc] init];
    [_midView addGestureRecognizer:midPanGesture];
    [_midView addGestureRecognizer:tapGesture];
    [[tapGesture rac_gestureSignal] subscribeNext:^(UIGestureRecognizer * x) {
        [self showHomePage];
    }];
    
    _personalCenterView = ({
        PersonalCenterView *view = [[PersonalCenterView alloc] initWithFrame:CGRectMake(-WIDTH * proportion, 0.0, WIDTH * proportion, HEIGHT)];
        
        view;
    });
    [self.view addSubview:_personalCenterView];
    
    //监听选择的分类
    @weakify(self);
    [[RACObserve(_personalCenterView, selectedIndex) skip:1] subscribeNext:^(id x) {
        @strongify(self);
        switch (self.personalCenterView.selectedIndex) {
            case 0:
            {
                SportsHistoryController *vc = [[SportsHistoryController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            default:
                break;
        }
        
    }];
    
    [[signal merge:[midPanGesture rac_gestureSignal]] subscribeNext:^(UIPanGestureRecognizer *recognizer) {
        CGFloat x = [recognizer translationInView:self.tableView].x;
        if (recognizer.state == UIGestureRecognizerStateEnded) {
            if (x > WIDTH * 0.42) {
                [self showPersonalCenter];
            } else {
                [self showHomePage];
            }
        }
    }];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SportsDetailViewModel *viewModel = [[SportsDetailViewModel alloc] init];
    UIImage *image = [UIImage imageNamed:@"btn_back"];
    NSDictionary *dic = @{@"face1":image,
                          @"face2":image};
    [[viewModel.compareFaceCommand execute:dic] subscribeNext:^(id  _Nullable x) {
        [WToast showWithText:@"x"];
    }];
    SportsDetailsController *controller = [[SportsDetailsController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [UITableViewCell new];
    }
    
    HomeItemCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeItemCell class]) forIndexPath:indexPath];
    switch (indexPath.row) {
        case SportsTypeJogging:
        {
            [cell initWithSportsType:SportsTypeJogging data:nil];
            break;
        }
        case SportsTypeRun:
        {
            [cell initWithSportsType:SportsTypeRun data:nil];
            break;
        }
        case SportsTypeWalk:
        {
            [cell initWithSportsType:SportsTypeWalk data:nil];
            break;
        }
        case SportsTypeStep:
        {
            [cell initWithSportsType:SportsTypeStep data:nil];
            break;
        }
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 40;
    }
    return 162;
}

#pragma mark - Event
- (void)showPersonalCenter {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _tableView.center = CGPointMake(self.view.center.x+ WIDTH * proportion, self.view.center.y);
        _personalCenterView.center = CGPointMake(WIDTH / 2 * proportion, self.view.center.y);
    } completion:^(BOOL finished) {
        if (finished) {
            _midView.hidden = NO;
            
        }
    }];
    
}

- (void)showHomePage {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _tableView.center = CGPointMake(self.view.center.x, self.view.center.y);
        _personalCenterView.center = CGPointMake(-WIDTH / 2 * proportion, self.view.center.y);
    } completion:nil];
    _midView.hidden = YES;
}

@end
