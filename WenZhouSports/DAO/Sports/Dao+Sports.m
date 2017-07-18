//
//  Dao+Sports.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/14.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "Dao+Sports.h"
#import "RunningProjectsModel.h"
#import "RunningActivityModel.h"

@implementation Dao (Sports)

- (RACSignal *)runActivity:(NSDictionary *)dic {
    return [[self RAC_POST:@"runningActivitys" parameters:dic]
            map:^id _Nullable(id  _Nullable value) {
                return [self jsonToMode:[RunningProjectsModel class] dictionary:value key:nil];
            }];
}

- (RACSignal *)runningActivitysStartWithProjectId:(NSInteger)projectId
                                        sutdentId:(NSInteger)studentId
                                         startTime:(NSTimeInterval)startTime {
    NSDictionary *dicParameters = @{@"projectId":@(projectId),
                                    @"studentId":@(studentId),
                                    @"startTime":@(startTime)};
    return [[self RAC_POST:@"runningActivities/start" parameters:dicParameters]
            map:^id _Nullable(id  _Nullable value) {
                return [self jsonToMode:[RunningActivityModel class] dictionary:value key:nil];
            }];
}

- (RACSignal *)runningActivitysEndWithId:(NSInteger)pid
                                distance:(NSInteger)distance
                               stepCount:(NSInteger)stepCount
                                costTime:(NSTimeInterval)costTime
                      targetFinishedTime:(NSTimeInterval)targetFinishedTime {
    NSDictionary *dicParameters = @{@"id":@(pid),
                                    @"distance":@(distance),
                                    @"stepCount":@(stepCount),
                                    @"costTime":@(costTime),
                                    @"targetFinishedTime":@(targetFinishedTime)};
    return [[self RAC_POST:@"runningActivities/end" parameters:dicParameters]
            map:^id _Nullable(id  _Nullable value) {
                return [self jsonToMode:[RunningProjectsModel class] dictionary:value key:nil];
            }];
            
}

- (RACSignal *)runningActivitysDataWithActivityId:(NSInteger)activityId
                                  acquisitionTime:(NSTimeInterval)acquisitionTime
                                        stepCount:(NSInteger)stepCount
                                         distance:(NSInteger)distance
                                        longitude:(float)longitude
                                         latitude:(float)latitude
                                     locationType:(NSInteger)locationType
                                         isNormal:(BOOL)isNormal {
    NSDictionary *dicParameters = @{@"activityId":@(activityId),
                                    @"acquisitionTime":@(acquisitionTime),
                                    @"stepCount":@(stepCount),
                                    @"distance":@(distance),
                                    @"longitude":@(longitude),
                                    @"latitude":@(latitude),
                                    @"locationType":@(locationType),
                                    @"isNormal":@(isNormal)};
    return [[self RAC_POST:@"runningActivityData" parameters:dicParameters]
            map:^id _Nullable(id  _Nullable value) {
                return [self jsonToMode:[RunningProjectsModel class] dictionary:value key:nil];
            }];
    
}



@end
