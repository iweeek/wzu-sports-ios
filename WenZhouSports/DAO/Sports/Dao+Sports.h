//
//  Dao+Sports.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/14.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "Dao.h"

@interface Dao (Sports)

- (RACSignal *)runActivity:(NSDictionary *)dic;

- (RACSignal *)runningActivitysStartWithRunningSportId:(NSInteger)runningSportId
                                             studentId:(NSInteger)studentId
                                             startTime:(NSTimeInterval)startTime;

- (RACSignal *)runningActivitysEndWithId:(NSInteger)pid
                                distance:(NSInteger)distance
                               stepCount:(NSInteger)stepCount
                                costTime:(NSTimeInterval)costTime
                      targetFinishedTime:(NSTimeInterval)targetFinishedTime;

// 添加采集点信息
- (RACSignal *)runningActivitysDataWithActivityId:(NSInteger)activityId
                                  acquisitionTime:(NSTimeInterval)acquisitionTime
                                        stepCount:(NSInteger)stepCount
                                         distance:(NSInteger)distance
                                        longitude:(float)longitude
                                         latitude:(float)latitude
                                     locationType:(NSInteger)locationType
                                         isNormal:(BOOL)isNormal;

- (RACSignal *)getAreaSportsList:(NSInteger)universityId;

- (RACSignal *)areaActivitysStartWithAreaSportId:(NSInteger)areaSportId
                                       studentId:(NSInteger)studentId;

- (RACSignal *)areaActivitysDataWithActivityId:(NSInteger)activityId
                                     longitude:(float)longitude
                                      latitude:(float)latitude
                                  locationType:(NSInteger)locationType;

- (RACSignal *)areaActivitysEndWithActivityId:(NSInteger)activityId;

@end
