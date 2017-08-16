//
//  LoginNewController.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/2.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "LoginController.h"
#import "LoginView.h"
#import "ForgetPasswordController.h"
#import "HomeController.h"
#import "AppDelegate.h"
#import "LoginViewModel.h"
#import "NSString+MD5.h"
#import "UniversityModel.h"
#import "StudentModel.h"

@interface LoginController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) LoginView *loginView;
@property (nonatomic, strong) LoginViewModel *vm;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger universityId;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.vm = [[LoginViewModel alloc] init];
    [self initSubview];
    [self reactiveEvent];
    
    //点击文本框改变 view 位置
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //当 Keyboard 弹出时会系统会发送 UIKeyboardWillChangeFrameNotification 通知
    [center addObserver:self selector:@selector(changeTextfieldFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
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

- (void)initSubview {
    self.loginView = [[LoginView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.loginView];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(200);
    }];

    [self getUniversities];
}

- (void)reactiveEvent {
    @weakify(self);
    [self.loginView.signalSubmit subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        // 检查输入有效性
        if (![self checkInputData]) {
            return ;
        }
        
        self.vm.universityId = [UserDefaultsManager sharedUserDefaults].universityId;
        self.vm.username = self.loginView.username;//self.loginView.username
        self.vm.password = [NSString stringToMD5:self.loginView.password];//self.loginView.password
        NSLog(@"%@",[NSString stringToMD5:@"123456"]) ;
        [[self.vm.cmdLogin execute:nil] subscribeNext:^(id  _Nullable x) {
            StudentModel *student = x;
            [UserDefaultsManager sharedUserDefaults].studentId = student.id;
            [UserDefaultsManager sharedUserDefaults].studentName = student.name;
            [UserDefaultsManager sharedUserDefaults].universityId = student.universityId;
            
            HomeController *vc = [[HomeController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self restoreRootViewController:nav];
        } error:^(NSError * _Nullable error) {
            [LNDProgressHUD showErrorMessage:[error localizedDescription] inView:self.view];
        }];
    }];
    
    [self.loginView.signalForgetPassword subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        ForgetPasswordController *vc = [[ForgetPasswordController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.loginView.signalDidBeginEditing subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (self.vm.universities.universities.count > 0) {
            [self.view endEditing:YES];
            self.tableView.hidden = NO;
        } else {
            @weakify(self);
            [[self.vm.cmdGetUniversities execute:nil] subscribeNext:^(id  _Nullable x) {
                @strongify(self);
                [self.tableView reloadData];
                if (self.vm.universities.universities.count > 0) {
                    [self.view endEditing:YES];
                    self.tableView.hidden = NO;
                }
            } error:^(NSError * _Nullable error) {
                [LNDProgressHUD showErrorMessage:@"学校列表获取失败" inView:self.view];
            }];
        }
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [self.loginView addGestureRecognizer:tap];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self);
        [self.view endEditing:YES];
    }];
}

//点击文本框改变 view 位置
- (void)changeTextfieldFrame:(NSNotification *)info{
    
    //获取通知中传来的信息，Keyboard 的 frame 信息保存在 UIKeyboardFrameEndUserInfoKey 这个 key 里
    CGRect endFrame = [info.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //动画展示平移效果
    [UIView animateWithDuration:0.25 animations:^{
        //用键盘的Y值减去屏幕高度获得偏移量
        //当键盘弹出时 键盘Y值小于屏幕高度 所以translationY为负值 view得以向上偏移
        //当键盘隐藏时 键盘Y值等于屏幕高度 所以translationY值为零 view得以平移回去
        if (endFrame.origin.y < self.view.frame.size.height) {
            self.view.transform = CGAffineTransformMakeTranslation(0, -30);
        } else {
            self.view.transform = CGAffineTransformMakeTranslation(0, 0);
        }
    }];
}

- (BOOL)checkInputData {
    [self.loginView.txtUniversityName setHint:@"" showHint:NO];
    [self.loginView.txtUserName setHint:@"" showHint:NO];
    [self.loginView.txtPassword setHint:@"" showHint:NO];
    if (!self.universityId) {
        [self.loginView.txtUniversityName setHint:@"请选择学校" showHint:YES];
        return NO;
    }
    if (!self.loginView.username) {
        [self.loginView.txtUserName setHint:@"请输入您的学号" showHint:YES];
        return NO;
    }
    if (!self.loginView.password) {
        [self.loginView.txtPassword setHint:@"请输入密码" showHint:YES];
        return NO;
    }
    return YES;
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

- (void)getUniversities {
    // 获取大学列表
    @weakify(self);
    [[self.vm.cmdGetUniversities execute:nil] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView reloadData];
    } error:^(NSError * _Nullable error) {
        [LNDProgressHUD showErrorMessage:@"学校列表获取失败" inView:self.view];
    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defaultCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultCell"];
    }
    // 分割线从头开始
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    UniversityModel *university = self.vm.universities.universities[indexPath.row];
    cell.textLabel.text = university.name;
    cell.textLabel.textColor = c474A4F;
    cell.textLabel.font = S14;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.vm.universities.universities.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.tableView.hidden = YES;
    UniversityModel *university = self.vm.universities.universities[indexPath.row];
    self.universityId = university.id;
    [self.loginView.txtUniversityName setText:university.name];
}

#pragma mark - getter && setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 50 - 64) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.userInteractionEnabled = YES;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.userInteractionEnabled = YES;
        _tableView.hidden = YES;
        _tableView.tableFooterView = [UITableView new];
        
    }
    return _tableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//移除通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
