//
//  RunningActivityModel.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/18.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RunningActivityModel : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger projectId;//该活动关联的项目id
@property (nonatomic, assign) NSInteger studentId;
@property (nonatomic, assign) NSInteger distance;
@property (nonatomic, assign) NSInteger costTime; //活动耗时
@property (nonatomic, assign) NSInteger targetTime;
@property (nonatomic, assign) NSInteger starTime;
@property (nonatomic, assign) NSInteger caloriesConsumed;//本次活动的卡路里消耗量
@property (nonatomic, assign) BOOL qualified;//本次活动是否达标

@end
