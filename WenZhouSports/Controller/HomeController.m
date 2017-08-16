//
//  HomeController.m
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/3.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "HomeController.h"
#import "PersonalCenterView.h"
#import "OldRankingController.h"
#import "UINavigationItem+Addition.h"
#import "SportsDetailsController.h"
#import "SportsDetailViewModel.h"
#import "SportsAreaOutdoorListController.h"
#import "SportsHistoryManagerController.h"
#import "HomeItemCell.h"
#import "HomeTotalCell.h"
#import "HomeRankCell.h"
#import "HomeSportsTypeCell.h"
#import "PersonInfoController.h"
#import "SportsPerformanceController.h"
#import "ApproveController.h"
#import "SettingController.h"
#import "HomeViewModel.h"
#import "RunningSportsModel.h"
#import "RunningSportModel.h"
#import "RankingManagerController.h"
#import "NetErrorView.h"
#import "SportsHistoryManagerController.h"
#import "RankingController.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "LoginController.h"

@interface HomeController () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NetErrorView *netErrorView;
@property (nonatomic, strong) PersonalCenterView *personalCenterView;
@property (nonatomic, strong) UIView *midView;// 个人中心被色背景层
@property (nonatomic, strong) HomeViewModel *vm;
@property (nonatomic, strong) NSArray *dataList;

@end

CGFloat proportion = 0.84;

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"课外体育锻炼";
//    self.edgesForExtendedLayout=UIRectEdgeNone;
//    self.extendedLayoutIncludesOpaqueBars=NO;
//    self.automaticallyAdjustsScrollViewInsets=NO;
//    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor = cFFFFFF;
    self.vm = [[HomeViewModel alloc] init];
    
    [self initSubviews];
    [self setupRefresh];
    [self.tableView.mj_header beginRefreshing];
//    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // 隐藏返回按钮文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault]; 

    [self.navigationItem setLeftBarButtonItemWithImage:[UIImage imageNamed:@"btn_menu"]
                                                target:self
                                                action:@selector(showPersonalCenter)];
    // 导航栏背景蓝色
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar lt_setBackgroundColor:c66A7FE];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    // 标题白色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:cFFFFFF,NSFontAttributeName:S(19)}];
    [self.navigationController.navigationBar setTintColor:cFFFFFF];
    
    // 状态栏颜色白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)setupRefresh {
    @weakify(self);
    
    // 网络故障
    self.netErrorView = [[NetErrorView alloc] initWithFrame:self.view.bounds];
    self.netErrorView.hidden = YES;
    [self.netErrorView reloadView:^{
        @strongify(self);
        [self initData];
    }];
    [self.view addSubview:self.netErrorView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.vm.universityId = [UserDefaultsManager sharedUserDefaults].universityId;
        self.vm.studentId = [UserDefaultsManager sharedUserDefaults].studentId;
        self.vm.pageNumber = 1;
        [[self.vm.cmdRunningSports execute:nil] subscribeNext:^(RunningSportsModel *x) {
            @strongify(self);
            [LNDProgressHUD hidenForView:self.view];
            [self.tableView.mj_header endRefreshing];
            self.netErrorView.hidden = YES;
            [self.tableView reloadData];
        } error:^(NSError * _Nullable error) {
            [LNDProgressHUD hidenForView:self.view];
            [self.tableView.mj_header endRefreshing];
            self.netErrorView.hidden = NO;
            
            NSLog(@"error:%@", [error localizedDescription]);
        }];
    }];

}

- (void)initData {
    @weakify(self);
    [LNDProgressHUD showLoadingInView:self.view];
    self.vm.universityId = [UserDefaultsManager sharedUserDefaults].universityId;
    self.vm.studentId = [UserDefaultsManager sharedUserDefaults].studentId;
    self.vm.pageNumber = 1;
    [[self.vm.cmdRunningSports execute:nil] subscribeNext:^(RunningSportsModel *x) {
        @strongify(self);
        [LNDProgressHUD hidenForView:self.view];
        self.netErrorView.hidden = YES;
        [self.tableView reloadData];
    } error:^(NSError * _Nullable error) {
        [LNDProgressHUD hidenForView:self.view];
        
        self.netErrorView.hidden = NO;
        
        NSLog(@"error:%@", [error localizedDescription]);
    }];
}

-(int)getRandomNumber:(int)from to:(int)to {
    return (int)(from + (arc4random() % (to - from + 1)));
}

- (void)initSubviews {
    _tableView = ({
        UITableView *tv = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, WIDTH, HEIGHT) style:UITableViewStyleGrouped];
        tv.delegate = self;
        tv.dataSource = self;
        tv.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [tv registerClass:[HomeItemCell class]
           forCellReuseIdentifier:NSStringFromClass([HomeItemCell class])];
        [tv registerClass:[HomeTotalCell class]
           forCellReuseIdentifier:NSStringFromClass([HomeTotalCell class])];
        [tv registerClass:[HomeRankCell class]
           forCellReuseIdentifier:NSStringFromClass([HomeRankCell class])];
        [tv registerClass:[HomeSportsTypeCell class]
           forCellReuseIdentifier:NSStringFromClass([HomeSportsTypeCell class])];
        
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
    
    // 退出登录
    @weakify(self);
    [_personalCenterView.signalLogout subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        LoginController *vc = [[LoginController alloc] init];
        
        [UserDefaultsManager sharedUserDefaults].universityId = 0;
        [UserDefaultsManager sharedUserDefaults].studentId = 0;
        [UserDefaultsManager sharedUserDefaults].studentName = @"";
        
        [self restoreRootViewController:vc];
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_personalCenterView];
    
    //监听个人中心
    [[RACObserve(_personalCenterView, selectedIndex) skip:1] subscribeNext:^(id x) {
        @strongify(self);
        switch (self.personalCenterView.selectedIndex) {
            case 0:// 运动历史
            {
                SportsHistoryManagerController *vc = [[SportsHistoryManagerController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 1:// 设置(原本应该是体侧数据)
            {
                SettingController *vc = [[SettingController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                break;
                
//                PersonInfoController *vc = [[PersonInfoController alloc] init];
//                [self.navigationController pushViewController:vc animated:YES];
//                break;
            }
            case 2:// 体育成绩
            {
                SportsPerformanceController *vc = [[SportsPerformanceController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 3:// 审批
            {
                ApproveController *vc = [[ApproveController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 5:// 设置
            {
                SettingController *vc = [[SettingController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }

            default:
                break;
        }
        [self showHomePage];
        
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
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            SportsHistoryManagerController *vc = [[SportsHistoryManagerController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
//            RankingController *vc = [[RankingController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];

        } else if (indexPath.row ==1) {
            RankingManagerController *vc = [[RankingManagerController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
//        [[self.vm.cmdRuningActivitys execute:nil] subscribeNext:^(id  _Nullable x) {
//            NSLog(@"cmdRuningActivitys:%@", x);
//        }];
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return;
        }
        
        if (indexPath.row == SportsTypeOutdoor) {
            SportsAreaOutdoorListController *vc = [[SportsAreaOutdoorListController alloc] init];
            vc.areaSport = self.vm.homePage.areaSports.firstObject;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        SportsDetailsController *vc = [[SportsDetailsController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.runningSport = self.vm.homePage.runningSports[indexPath.row - 1];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            HomeTotalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeTotalCell class]) forIndexPath:indexPath];
            [cell setupWithData:self.vm.homePage];
            return cell;
        } else {
            HomeRankCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeRankCell class]) forIndexPath:indexPath];
            return cell;
        }
    } else {
        if (indexPath.row == 0) {
            HomeSportsTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeSportsTypeCell class]) forIndexPath:indexPath];
            return cell;
        } else {
            HomeItemCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeItemCell class]) forIndexPath:indexPath];
            
//            int personCount = [self getRandomNumber:0 to:100];
            
            switch (indexPath.row) {
                case SportsTypeJogging:
                {
                    RunningSportModel *runSport = (RunningSportModel *)self.vm.homePage.runningSports[indexPath.row - 1];
                    [cell initWithSportsType:SportsTypeJogging data:runSport];                    break;
                }
                case SportsTypeRun:
                {
                    RunningSportModel *runSport = (RunningSportModel *)self.vm.homePage.runningSports[indexPath.row - 1];
                    [cell initWithSportsType:SportsTypeRun data:runSport];
                    break;
                }
                case SportsTypeWalk:
                {
                    RunningSportModel *runSport = (RunningSportModel *)self.vm.homePage.runningSports[indexPath.row - 1];
                    [cell initWithSportsType:SportsTypeWalk data:runSport];                    break;
                }
//                case SportsTypeStep:
//                {
//                    RunningSportModel *runSport = (RunningSportModel *)self.vm.homePage.runningSports[indexPath.row - 1];
//                    [cell initWithSportsType:SportsTypeStep data:runSport];                    break;
//                }
                case SportsTypeOutdoor:
                {
                    [cell initWithSportsType:SportsTypeOutdoor data:nil];                    break;
                }
            }
            return cell;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 5;
//    return self.vm.homePage.runningSports.count + self.vm.homePage.areaSports.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 224;
        } else {
            return 44;
        }
    } else {
        if (indexPath.row == 0) {
            return 40;
        } else {
            return FIX(162);
        }
    }
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

// 渐变切换rootController
- (void)restoreRootViewController:(UIViewController *)rootViewController {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    typedef void (^Animation)(void);
    UIWindow *window = delegate.window;
    
    rootViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    Animation animation = ^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        window.rootViewController = rootViewController;
        [UIView setAnimationsEnabled:oldState];
    };
    
    [UIView transitionWithView:window
                      duration:0.3f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:animation
                    completion:nil];
}

@end
