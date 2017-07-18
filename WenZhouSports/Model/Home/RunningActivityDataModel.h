//
//  RunningActivityDataModel.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/7/12.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RunningActivityDataModel : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger activityId;//该数据关联的运动的ID
@property (nonatomic, assign) NSTimeInterval acquisitionTime;//数据采集时间,时间戳格式(毫秒)
@property (nonatomic, assign) NSInteger stepCount;//该时段累计步数
@property (nonatomic, assign) NSInteger distance;//该时段活动距离(单位:米)
@property (nonatomic, assign) double longitude;//该时刻的经度
@property (nonatomic, assign) double latitude;//该时刻的纬度
@property (nonatomic, assign) NSInteger locationType;//定位方式
@property (nonatomic, assign) BOOL isNormal;//数据是否正常

@end
