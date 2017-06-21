//
//  SportsHistoryViewModel.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/20.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "SportsHistoryViewModel.h"
#import "Dao+SportsHistory.h"

@implementation SportsHistoryViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.cmdGetSportsHistory = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary *input) {
            return [[[[Dao share] getSportsHistory:input]
                     doNext:^(id  _Nullable x) {
                         self.homePage = x;
                     }]
                    catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
                        return [RACSignal error:error];
                    }];
        }];
    }
    return self;
}


@end
