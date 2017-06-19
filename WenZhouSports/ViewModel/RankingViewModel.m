//
//  RankingViewModel.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/19.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "RankingViewModel.h"
#import "Dao+Ranking.h"

@implementation RankingViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.cmdGetRanking = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary *input) {
            return [[[[Dao share] getRanking:input]
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
