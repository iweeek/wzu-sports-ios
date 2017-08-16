//
//  Dao+Sports.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/14.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "Dao+Sports.h"
#import "RunningSportsModel.h"
#import "RunningActivityModel.h"
#import "AreaSportsOutdoorPointsModel.h"
#import "AreaActivityModel.h"

@implementation Dao (Sports)

- (RACSignal *)runActivity:(NSDictionary *)dic {
    return [[self RAC_POST:@"runningActivitys" parameters:dic]
            map:^id _Nullable(id  _Nullable value) {
                return [self jsonToMode:[RunningSportsModel class] dictionary:value key:nil];
            }];
}

- (RACSignal *)runningActivitysStartWithRunningSportId:(NSInteger)runningSportId
                                             studentId:(NSInteger)studentId
                                             startTime:(NSTimeInterval)startTime {
    NSDictionary *dicParameters = @{@"runningSportId":@(runningSportId),
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
                return [self jsonToMode:[RunningActivityModel class] dictionary:value key:nil];
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
                return [self jsonToMode:[RunningSportsModel class] dictionary:value key:nil];
            }];
}

- (RACSignal *)getAreaSportsList:(NSInteger)universityId {
    NSString *str = [NSString stringWithFormat:@"universities/%ld/FixLocationOutdoorSportPoints", universityId];
    return [[self RAC_GET:str parameters:nil]
            map:^id _Nullable(id  _Nullable value) {
                return [self jsonToModeForREST:[AreaSportsOutdoorPointsModel class] dictionary:value key:nil];
            }];
}

- (RACSignal *)areaActivitysStartWithAreaSportId:(NSInteger)areaSportId
                                        studentId:(NSInteger)studentId {
    NSDictionary *dicParameters = @{@"areaSportId":@(areaSportId),
                                    @"studentId":@(studentId)};
    return [[self RAC_POST:@"areaActivities" parameters:dicParameters]
            map:^id _Nullable(id  _Nullable value) {
                return [self jsonToModeForREST:[AreaActivityModel class] dictionary:value key:@"obj"];
            }];
}

- (RACSignal *)areaActivitysDataWithActivityId:(NSInteger)activityId
                                     longitude:(float)longitude
                                      latitude:(float)latitude
                                  locationType:(NSInteger)locationType {
    NSDictionary *dicParameters = @{@"activityId":@(activityId),
                                    @"longitude":@(longitude),
                                    @"latitude":@(latitude),
                                    @"locationType":@(locationType)};
    return [self RAC_POST:@"areaActivityData" parameters:dicParameters];
}

- (RACSignal *)areaActivitysEndWithActivityId:(NSInteger)activityId {
//    NSDictionary *dicParameters = @{@"id":@(activityId)};
    NSString *API = [NSString stringWithFormat:@"areaActivities/%ld", activityId];
    return [[self RAC_POST:API parameters:nil]
            map:^id _Nullable(id  _Nullable value) {
                return [self jsonToModeForREST:[AreaActivityModel class] dictionary:value key:@"obj"];
            }];
}

@end
