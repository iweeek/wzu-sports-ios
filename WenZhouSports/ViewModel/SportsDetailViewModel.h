//
//  SportsDetailViewModel.h
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/15.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RunningActivityModel.h"
#import "AreaSportsOutdoorPointsModel.h"
#import "AreaSportModel.h"
#import "AreaActivityModel.h"

@interface SportsDetailViewModel : NSObject

//人脸比较
@property (nonatomic, strong) RACCommand *compareFaceCommand;
@property (nonatomic, strong) RACCommand *cmdRunActivity;
@property (nonatomic, strong) RACCommand *cmdRunningActivitiesStart;
@property (nonatomic, strong) RACCommand *cmdRunningActivitiesEnd;
@property (nonatomic, strong) RACCommand *cmdRunningActivityData;
@property (nonatomic, strong) RACCommand *cmdGetAreaSportsList;
@property (nonatomic, strong) RACCommand *cmdAreaActivityStart;
@property (nonatomic, strong) RACCommand *cmdAreaActivityEnd;
@property (nonatomic, strong) RACCommand *cmdAreaActivityData;

//跑步运动相关
//开始
@property (nonatomic, assign) NSInteger runningSportId;
@property (nonatomic, assign) NSInteger studentId;
@property (nonatomic, assign) NSTimeInterval starTime;
@property (nonatomic, strong) RunningActivityModel *runningActivity;

//结束
@property (nonatomic, assign) NSInteger runningActivityid;
@property (nonatomic, assign) NSInteger distance;
@property (nonatomic, assign) NSInteger stepCount;
@property (nonatomic, assign) NSTimeInterval costTime; //花费时间
@property (nonatomic, assign) NSTimeInterval targetFinishedTime;//目标时间

//采集点数据
@property (nonatomic, assign) NSTimeInterval acquisitionTime;
@property (nonatomic, assign) float longitude;
@property (nonatomic, assign) float latitude;
@property (nonatomic, assign) NSInteger locationType;
@property (nonatomic, assign) BOOL isNormal;

//户外运动相关
@property (nonatomic, strong) AreaSportsOutdoorPointsModel *areaSportsOutdoorPoints;
@property (nonatomic, strong) AreaActivityModel *areaActivity;
@property (nonatomic, strong) AreaSportModel *areaSport;
@property (nonatomic, assign) NSInteger areaActivityId;

@end
