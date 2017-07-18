//
//  RunningActivityModel.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/18.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RunningProjectItemModel.h"
#import "RunningActivityDataModel.h"

@interface RunningActivityModel : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger projectId;//该活动关联的项目的ID
@property (nonatomic, assign) NSInteger studentId;
@property (nonatomic, assign) NSInteger distance;//活动距离(单位:米)
@property (nonatomic, assign) NSInteger costTime;//活动耗时(单位:秒)
@property (nonatomic, assign) NSInteger targetTime;//达到目标距离的时间(单位:秒)
@property (nonatomic, assign) NSTimeInterval startTime;//活动开始时间,时间戳格式(毫秒)
@property (nonatomic, assign) NSInteger caloriesConsumed;//本次活动的卡路里消耗量
@property (nonatomic, assign) BOOL qualified;//本次活动是否达标
@property (nonatomic, strong) RunningProjectItemModel *runningProject;//该活动所属的运动项目
@property (nonatomic, strong) NSArray<RunningActivityDataModel *> *data;//该活动记录的采集数据

@end
