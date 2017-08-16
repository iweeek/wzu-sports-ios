//
//  Dao+Home.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/9.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "Dao+Home.h"
#import "RunningSportsModel.h"
#import "HomePageModel.h"

@implementation Dao (Home)

- (RACSignal *)runningSportsWith:(NSInteger)universityId
                         studentId:(NSInteger)studentId
                        pageNumber:(NSInteger)pageNumber {
    NSString *str = @"{ \
                        university(id:%ld) { \
                            currentTerm { \
                                termSportsTask { \
                                targetSportsTimes \
                                } \
                            } \
                        } \
                        student(id:%ld) { \
                            currentTermAreaActivityCount \
                            currentTermQualifiedRunningActivityCount \
                            areaActivityKcalConsumption \
                            runningActivityKcalConsumption \
                            areaActivityTimeCosted \
                            runningActivityTimeCosted \
                            qualifiedAreaActivityCount \
                            qualifiedRunningActivityCount \
                            currentTermQualifiedAreaActivityCount \
                            currentTermQualifiedRunningActivityCount \
                        } \
                        runningSports(universityId:%ld){ \
                            id \
                            name \
                            qualifiedDistance \
                            qualifiedCostTime \
                            acquisitionInterval \
                            participantNum \
                        } \
                        areaSports(universityId:%ld){ \
                            id \
                            name \
                            isEnabled \
                            qualifiedCostTime \
                            acquisitionInterval \
                            universityId \
                            participantNum \
                        } \
                    }";
    //participantNum
    NSDictionary *dicParameters = @{@"query":[NSString stringWithFormat:str, universityId, studentId, universityId, universityId]};
    return [[self RAC_POST:@"graphql/query" parameters:dicParameters]
        map:^id _Nullable(id  _Nullable value) {
            return [self jsonToMode:[HomePageModel class] dictionary:value key:nil];
        }];
}

- (RACSignal *)sportTotal:(NSDictionary *)dic {
    return [[self RAC_POST:@"graphql/query" parameters:dic]
            map:^id _Nullable(id  _Nullable value) {
                return [self jsonToMode:[RunningSportsModel class] dictionary:value key:@"runningSports"];
            }];
}



@end
