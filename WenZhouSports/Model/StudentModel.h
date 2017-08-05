//
//  StudentModel.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/8.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivitiesPageModel.h"
#import "AreaActiviesPageModel.h"

@interface StudentModel : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *studentNo;
@property (nonatomic, assign) BOOL isMan;
@property (nonatomic, assign) NSInteger universityId;
@property (nonatomic, assign) NSInteger classId;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) ActivitiesPageModel *currentWeekActivities;
@property (nonatomic, strong) ActivitiesPageModel *currentMonthActivities;
@property (nonatomic, strong) ActivitiesPageModel *currentTermActivities;
@property (nonatomic, assign) NSInteger caloriesConsumption;//该学生的累计卡路里消耗
@property (nonatomic, assign) NSInteger timeCosted;//该学生的累计运动时长(单位:秒)
@property (nonatomic, assign) NSInteger currentTermActivityCount;
@property (nonatomic, assign) NSInteger currentTermQualifiedActivityCount;//该学生的当前学期的合格活动次数
@property (nonatomic, assign) NSInteger qualifiedActivityCount;//该学生的合格活动次数
@property (nonatomic, strong) ActivitiesPageModel *runningActivities;
@property (nonatomic, strong) AreaActiviesPageModel *areaActivities;

@property (nonatomic, assign) NSInteger currentTermAreaActivityCount;
@property (nonatomic, assign) NSInteger currentTermRunningActivityCount;
@property (nonatomic, assign) NSInteger areaActivityKcalConsumption;
@property (nonatomic, assign) NSInteger runningActivityKcalConsumption;
@property (nonatomic, assign) NSInteger areaActivityTimeCosted;
@property (nonatomic, assign) NSInteger runningActivityTimeCosted;
@property (nonatomic, assign) NSInteger currentTermQualifiedAreaActivityCount;
@property (nonatomic, assign) NSInteger currentTermQualifiedRunningActivityCount;

@property (nonatomic, assign) NSInteger qualifiedAreaActivityCount;//达标次数
@property (nonatomic, assign) NSInteger qualifiedRunningActivityCount;//达标次数
@property (nonatomic, assign) NSInteger accuRunningActivityCount;//累计次数
@property (nonatomic, assign) NSInteger accuAreaActivityCount;//累计次数

@end
