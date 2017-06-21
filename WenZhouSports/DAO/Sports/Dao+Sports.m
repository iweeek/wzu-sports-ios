//
//  Dao+Sports.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/14.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "Dao+Sports.h"
#import "RunningProjectsModel.h"

@implementation Dao (Sports)

- (RACSignal *)runActivity:(NSDictionary *)dic {
    return [[self RAC_POST:@"runningActivitys" parameters:dic]
            map:^id _Nullable(id  _Nullable value) {
                return [self jsonToMode:[RunningProjectsModel class] dictionary:value key:nil];
            }];
}

@end
