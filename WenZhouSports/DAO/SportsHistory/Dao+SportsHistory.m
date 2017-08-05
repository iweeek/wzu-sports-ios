//
//  Dao+SportsHistory.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/20.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "Dao+SportsHistory.h"
#import "HomePageModel.h"

@implementation Dao (SportsHistory)

- (RACSignal *)getSportsHistory:(NSDictionary *)dic {
    return [[self RAC_POST:@"graphql/query" parameters:dic]
            map:^id _Nullable(id _Nullable value) {
                return [self jsonToMode:[HomePageModel class] dictionary:value key:nil];
            }];
}

- (RACSignal *)getSportsHistoryWithStudentId:(NSInteger)studentId
                                 currentPage:(NSInteger)currentPage {
    NSString *str = @"{ \
                        student(id:%ld) { \
                            currentTermActivityCount \
                            qualifiedActivityCount(timeRange:CURRENT_TERM) \
                            caloriesConsumption(timeRange:CURRENT_TERM) \
                            timeCosted(timeRange:CURRENT_TERM) \
                            currentTermActivities(pageSize:%ld, pageNumber:%ld){ \
                                pagesCount \
                                data { \
                                    runningSportId \
                                    costTime \
                                    kcalConsumed \
                                    startTime \
                                    endedAt \
                                    distance \
                                    qualified \
                                    data { \
                                        longitude \
                                        latitude \
                                    } \
                                    runningSport{ \
                                        name \
                                    } \
                                } \
                            } \
                        } \
                    }";
    NSDictionary *dicParameters = @{@"query":[NSString stringWithFormat:str, studentId, pageSize, currentPage]};
    return [[self RAC_POST:@"graphql/query" parameters:dicParameters]
            map:^id _Nullable(id _Nullable value) {
                return [self jsonToMode:[HomePageModel class] dictionary:value key:nil];
            }];
}

- (RACSignal *)getSportsHistoryWithStudentId:(NSInteger)studentId
                                   startDate:(NSString *)startDate
                                     endDate:(NSString *)endDate
                           sportsHistoryType:(NSString *)sportsHistoryType {
    NSString *str = @"{ \
                        student(id:%ld){ \
                            qualifiedAreaActivityCount(timeRange:%@) \
                            qualifiedRunningActivityCount(timeRange:%@) \
                            areaActivityTimeCosted(timeRange:%@) \
                            runningActivityTimeCosted(timeRange:%@) \
                            areaActivityKcalConsumption(timeRange:%@) \
                            runningActivityKcalConsumption(timeRange:%@) \
                            accuRunningActivityCount(timeRange:%@) \
                            accuAreaActivityCount(timeRange:%@) \
                            areaActivities(startDate:\"%@\",endDate:\"%@\") { \
                                data{ \
                                    sportDate \
                                    areaSportId \
                                    costTime \
                                    kcalConsumed \
                                    startTime \
                                    endedAt \
                                    qualified \
                                    areaSport{ \
                                        name \
                                    } \
                                } \
                            } \
                            runningActivities(startDate:\"%@\",endDate:\"%@\"){ \
                                data{ \
                                    sportDate \
                                    runningSportId \
                                    costTime \
                                    kcalConsumed \
                                    startTime \
                                    endedAt \
                                    distance \
                                    qualified \
                                    qualifiedDistance \
                                    qualifiedCostTime \
                                    runningSport{ \
                                        name  \
                                    } \
                                    data { \
                                        longitude \
                                        latitude \
                                    } \
                                } \
                            }  \
                        } \
                    }";
    NSDictionary *dicParameters = @{@"query":[NSString stringWithFormat:str, studentId,
                                              sportsHistoryType,
                                              sportsHistoryType,
                                              sportsHistoryType,
                                              sportsHistoryType,
                                              sportsHistoryType,
                                              sportsHistoryType,
                                              sportsHistoryType,
                                              sportsHistoryType,
                                              startDate, endDate, startDate, endDate]};
    return [[self RAC_POST:@"graphql/query" parameters:dicParameters]
            map:^id _Nullable(id _Nullable value) {
                return [self jsonToMode:[HomePageModel class] dictionary:value key:nil];
            }];
}

- (RACSignal *)getRunningActivityWithId:(NSInteger)activityId {
    NSString *str = @"{ \
                        runningActivity(id:%ld){ \
                            id \
                            runningSportId \
                            costTime \
                            kcalConsumed \
                            startTime \
                            endedAt \
                            distance \
                            qualified \
                            qualifiedDistance \
                            qualifiedCostTime \
                            data { \
                                longitude \
                                latitude \
                            } \
                            runningSport{ \
                                name \
                            } \
                        } \
                    }";
    NSDictionary *dicParameters = @{@"query":[NSString stringWithFormat:str, activityId]};
    return [[self RAC_POST:@"graphql/query" parameters:dicParameters]
            map:^id _Nullable(id _Nullable value) {
                return [self jsonToMode:[HomePageModel class] dictionary:value key:nil];
            }];
}

- (RACSignal *)getAreaActivityWithId:(NSInteger)activityId {
    NSString *str = @"{ \
                        runningActivity(id:%ld){ \
                            id \
                            runningSportId \
                            costTime \
                            kcalConsumed \
                            startTime \
                            endedAt \
                            distance \
                            qualified \
                            qualifiedDistance \
                            qualifiedCostTime \
                            data { \
                                longitude \
                                latitude \
                            } \
                            runningSport{ \
                                name \
                            } \
                        } \
                    }";
    NSDictionary *dicParameters = @{@"query":[NSString stringWithFormat:str, activityId]};
    return [[self RAC_POST:@"graphql/query" parameters:dicParameters]
            map:^id _Nullable(id _Nullable value) {
                return [self jsonToMode:[HomePageModel class] dictionary:value key:nil];
            }];
}

@end
