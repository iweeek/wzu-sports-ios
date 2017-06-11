//
//  Dao+Home.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/9.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "Dao+Home.h"
#import "runningProjectsModel.h"

@implementation Dao (Home)

- (RACSignal *)runningProjects:(NSDictionary *)dic {
    return [[self RAC_POST:@"graphql/query" parameters:dic]
        map:^id _Nullable(id  _Nullable value) {
            return [self jsonToMode:[runningProjectsModel class] dictionary:value key:@"runningProjects"];
        }];
}

- (RACSignal *)runActivity:(NSDictionary *)dic {
    NSDictionary *dic3 = @{@"projectId":@(1),
                          @"studentId":@(1),
                          @"distance":@(100),
                          @"costTime":@(14),
                          @"targetTime":@(15),
                          @"startTime":@(1497171815)};
    
    return [[self RAC_POST:@"runningActivitys" parameters:dic3]
            map:^id _Nullable(id  _Nullable value) {
                return [self jsonToMode:[runningProjectsModel class] dictionary:value key:nil];
            }];
}

@end
