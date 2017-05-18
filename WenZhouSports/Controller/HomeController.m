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
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)initSubviews {
    _tableView = ({
        UITableView *tv = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, WIDTH, HEIGHT)];
        tv.delegate = self;
        tv.dataSource = self;
        _headerView = [[HomeHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, WIDTH, FIT_LENGTH(302.0))];
        tv.tableHeaderView = _headerView;
        [_headerView.rankingSignal subscribeNext:^(id  _Nullable x) {
            RankingController *controller = [[RankingController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }];
        
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

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
//    [self.navigationController pushViewController:controller animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}

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
