//
//  SportsDetailsController.h
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/10.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "BaseViewController.h"
#import "RunningSportModel.h"
#import "AreaSportsOutdoorPointModel.h"
#import "AreaSportModel.h"

typedef NS_ENUM(NSInteger, SportsType) {
    SportsRunning = 0,            //跑步运动
    SportsOutdoor,                //户外运动
    SportsIndoor,                 //室内运动
};

@interface SportsDetailsController : BaseViewController

@property (nonatomic, strong) RunningSportModel *runningSport;
@property (nonatomic, strong) AreaSportModel *areaSport;
@property (nonatomic, assign) NSInteger acquisitionInterval;//采集间隔
@property (nonatomic, assign) SportsType sportsType;
@property (nonatomic, strong) AreaSportsOutdoorPointModel *areaAportsOutdoorPoint;

@end
