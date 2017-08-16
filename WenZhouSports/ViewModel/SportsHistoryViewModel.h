//
//  SportsHistoryViewModel.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/20.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomePageModel.h"
#import "StudentModel.h"
#import "RunningActivityModel.h"
#import "AreaActivityModel.h"

@interface SportsHistoryViewModel : NSObject

@property (nonatomic, strong) HomePageModel *homePage;
@property (nonatomic, strong) NSMutableArray *allActivityArray;
@property (nonatomic, strong) RunningActivityModel *runningActivity;
@property (nonatomic, strong) AreaActivityModel *areaActivity;
@property (nonatomic, assign) NSInteger studentId;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSString *sportsHistoryType;

@property (nonatomic, strong) RACCommand *cmdRefreshSportsHistory;
@property (nonatomic, strong) RACCommand *cmdLoadMoreSportsHistory;
@property (nonatomic, strong) RACCommand *cmdGetRunningActivity;
@property (nonatomic, strong) RACCommand *cmdGetAreaActivity;

@end
