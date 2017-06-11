//
//  SettingController.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/3.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "SettingController.h"
#import "AboutUsController.h"

@interface SettingController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"体育成绩";
    self.view.backgroundColor = cFFFFFF;
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    SportsPerformanceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SportsPerformanceCell class]) forIndexPath:indexPath];
//    [cell setupWithData:nil];
//    return cell;
    static NSString * settingCellIdentifier = @"settingCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:settingCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier:settingCellIdentifier];
    }
    
    cell.textLabel.textColor = c474A4F;
    cell.textLabel.font = S15;
    cell.detailTextLabel.textColor = c7E848C;
    cell.detailTextLabel.font = S15;
    
    if (indexPath.section == 0) {
        cell.textLabel.text=@"修改密码";
        cell.detailTextLabel.text = @"";
    } else {
        if (indexPath.row == 0) {
            cell.textLabel.text=@"关于我们";
            cell.detailTextLabel.text = @"";
        } else {
            cell.textLabel.text=@"检查更新";
            cell.detailTextLabel.text = @"当前版本 V1.0";
        }
    }
    

    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //修改密码
    } else {
        if (indexPath.row == 0) {
            AboutUsController *vc = [[AboutUsController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            //检查更新
        }
    }
}

#pragma mark - getter && setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,WIDTH, HEIGHT) style:UITableViewStyleGrouped];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.userInteractionEnabled = YES;
        
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
