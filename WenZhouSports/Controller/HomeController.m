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
#import "SportsDetailsController.h"
#import "SportsDetailViewModel.h"
#import "SportsHistoryController.h"
#import "HomeItemCell.h"
#import "HomeTotalCell.h"
#import "HomeRankCell.h"
#import "HomeSportsTypeCell.h"
#import "PersonInfoController.h"
#import "SportsPerformanceController.h"
#import "ApproveController.h"
#import "SettingController.h"
#import "HomeViewModel.h"
#import "RunningProjectsModel.h"
#import "RunningProjectItemModel.h"
#import "RankingManagerController.h"
#import "NetErrorView.h"
#import "SportsHistoryManagerController.h"
#import "RankingController.h"
#import "MJRefresh.h"

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
    self.automaticallyAdjustsScrollViewInsets=NO;
//    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor = cFFFFFF;
    self.vm = [[HomeViewModel alloc] init];
    
    [self initSubviews];
    [self setupRefresh];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // 隐藏返回按钮文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault]; 

    // 导航栏背景蓝色
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar lt_setBackgroundColor:c66A7FE];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
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
//    @weakify(self);
    [self.netErrorView reloadView:^{
        @strongify(self);
        [self initData];
//        [self.tableView.zbjRefreshHeaderView refresh];
    }];
    [self.view addSubview:self.netErrorView];
}

- (void)initData {
    @weakify(self);
    NSString *str = @"{ \
                        university(id:%ld) { \
                            currentTerm { \
                                termSportsTask { \
                                    targetSportsTimes \
                                } \
                            } \
                        } \
                        student(id:%ld) { \
                            currentTermQualifiedActivityCount \
                            caloriesConsumption \
                            currentTermActivities(pageNumber:1,pageSize:1) { \
                                pageNum \
                                pageSize \
                                pagesCount \
                                dataCount \
                            }\
                        } \
                        runningProjects(universityId:%ld){ \
                            id \
                            name \
                            qualifiedDistance \
                            qualifiedCostTime \
                            acquisitionInterval \
                        } \
                       }";
    NSDictionary *dic = @{@"query":[NSString stringWithFormat:str, 1, 1, 1]};
    [LNDProgressHUD showLoadingInView:self.view];
    [[self.vm.cmdRunningProjects execute:dic] subscribeNext:^(RunningProjectsModel *x) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        self.tableView.contentInset = UIEdgeInsetsZero;
        [LNDProgressHUD hidenForView:self.view];
        self.netErrorView.hidden = YES;
        [self.tableView reloadData];
    } error:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [LNDProgressHUD hidenForView:self.view];
        self.tableView.contentInset = UIEdgeInsetsZero;
        if (error.code == -1009) {// 无网络
            self.netErrorView.hidden = NO;
        }
        
        NSLog(@"error:%@", [error localizedDescription]);
    }];
}

-(int)getRandomNumber:(int)from to:(int)to {
    return (int)(from + (arc4random() % (to - from + 1)));
}

- (void)initSubviews {
    UIView *homeView = [[UIView alloc] initWithFrame:self.view.bounds];
//    homeView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:homeView];
    
    _tableView = ({
        UITableView *tv = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 64, WIDTH, HEIGHT) style:UITableViewStyleGrouped];
        tv.delegate = self;
        tv.dataSource = self;
        tv.separatorStyle = UITableViewCellSeparatorStyleNone;
//        tv.backgroundColor = [UIColor yellowColor];
        
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
//    [homeView addSubview:_tableView];
    
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(64);
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
//    }];
    
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
    [[UIApplication sharedApplication].keyWindow addSubview:_personalCenterView];
    
    //监听个人中心
    @weakify(self);
    [[RACObserve(_personalCenterView, selectedIndex) skip:1] subscribeNext:^(id x) {
        @strongify(self);
        switch (self.personalCenterView.selectedIndex) {
            case 0:// 运动历史
            {
                SportsHistoryController *vc = [[SportsHistoryController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 1:// 体侧数据
            {
                PersonInfoController *vc = [[PersonInfoController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                break;
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
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    SportsDetailViewModel *viewModel = [[SportsDetailViewModel alloc] init];
//    UIImage *image = [UIImage imageNamed:@"btn_back"];
//    NSDictionary *dic = @{@"face1":image,
//                          @"face2":image};
//    [[viewModel.compareFaceCommand execute:dic] subscribeNext:^(id  _Nullable x) {
//        [WToast showWithText:@"x"];
//    }];

    
//    ForgetPasswordController *vc = [[ForgetPasswordController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
//    LoginController *vc = [[LoginController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return;
        }
        SportsDetailsController *vc = [[SportsDetailsController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.runningProject = self.vm.homePage.runningProjects[indexPath.row - 1];
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
            
            int personCount = [self getRandomNumber:0 to:100];
            
            switch (indexPath.row) {
                case SportsTypeJogging:
                {
                    RunningProjectItemModel *runProject = (RunningProjectItemModel *)self.vm.homePage.runningProjects[indexPath.row - 1];
                    [cell initWithSportsType:SportsTypeJogging data:runProject];
                    [cell setupPersonCount:personCount];
                    break;
                }
                case SportsTypeRun:
                {
                    RunningProjectItemModel *runProject = (RunningProjectItemModel *)self.vm.homePage.runningProjects[indexPath.row - 1];
                    [cell initWithSportsType:SportsTypeRun data:runProject];
                    [cell setupPersonCount:personCount];
                    break;
                }
                case SportsTypeWalk:
                {
                    RunningProjectItemModel *runProject = (RunningProjectItemModel *)self.vm.homePage.runningProjects[indexPath.row - 1];
                    [cell initWithSportsType:SportsTypeWalk data:runProject];
                    [cell setupPersonCount:personCount];
                    break;
                }
                case SportsTypeStep:
                {
                    RunningProjectItemModel *runProject = (RunningProjectItemModel *)self.vm.homePage.runningProjects[indexPath.row - 1];
                    [cell initWithSportsType:SportsTypeStep data:runProject];
                    [cell setupPersonCount:personCount];
                    break;
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

@end
