//
//  AreaSportModel.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/7/28.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaSportModel : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *name;//区域运动项目名称
@property (nonatomic, assign) BOOL isEnabled;//该项目是否启用
@property (nonatomic, assign) NSInteger qualifiedCostTime;//该项目的合格耗时(单位:秒)
@property (nonatomic, assign) NSInteger acquisitionInterval;//采集运动数据的时间间隔(单位:秒)
@property (nonatomic, assign) NSInteger participantNum;//参加人数
@property (nonatomic, assign) NSInteger universityId;//所属大学的ID

@end
