//
//  runningProjectItmeModel.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/11.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RunningSportModel : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger universityId;
@property (nonatomic, strong) NSString *name;//跑步项目名称
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) NSInteger qualifiedDistance;//该项目的合格距离(单位:米)
@property (nonatomic, assign) NSInteger qualifiedCostTime;//该项目的合格耗时(单位:秒)
@property (nonatomic, assign) NSInteger minCostTime;//该项目的最少耗时(单位:秒)
@property (nonatomic, assign) NSInteger acquisitionInterval;//采集运动数据的时间间隔(单位:秒)
@property (nonatomic, assign) NSInteger participantNum; //参加运动人数

@end
