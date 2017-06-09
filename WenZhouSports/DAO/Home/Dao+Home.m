//
//  Dao+Home.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/9.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "Dao+Home.h"
#import "StudentModel.h"

@implementation Dao (Home)

- (RACSignal *)HomePage:(NSDictionary *)dic {
    return [[self RAC_POST:@"graphql" parameters:dic]
        map:^id _Nullable(id  _Nullable value) {
            return [self jsonToMode:[StudentModel class] dictionary:value];
        }];
}

@end
