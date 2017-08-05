//
//  AreaActivityModel.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/7/30.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AreaSportModel.h"
#import "AreaActivityDataModel.h"

@interface AreaActivityModel : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *sportDate;
@property (nonatomic, assign) NSInteger areaSportId;
@property (nonatomic, assign) NSInteger studentId;
@property (nonatomic, assign) NSInteger costTime;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSInteger kcalConsumed;
@property (nonatomic, assign) BOOL qualified; //本次活动是否达标
@property (nonatomic, assign) NSInteger qualifiedCostTime;//该次活动的合格耗时(单位:秒)
@property (nonatomic, assign) NSTimeInterval createdAtd;
@property (nonatomic, assign) NSTimeInterval updatedAt;
@property (nonatomic, assign) NSTimeInterval endedAt;
@property (nonatomic, assign) NSInteger endedBy;
@property (nonatomic, strong) AreaSportModel *areaSport;
@property (nonatomic, strong) NSArray<AreaActivityDataModel *> *data;//该活动记录的采集数据;
@end
