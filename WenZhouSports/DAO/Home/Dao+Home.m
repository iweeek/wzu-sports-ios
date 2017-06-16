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



@end
