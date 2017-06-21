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


@end
