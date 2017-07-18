//
//  RankingViewModel.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/19.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "RankingViewModel.h"
#import "Dao+Ranking.h"

@interface RankingViewModel ()

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation RankingViewModel

- (instancetype)init {
    if (self = [super init]) {
        @weakify(self);
        RACSignal *signal = [RACSignal defer:^RACSignal *{
            @strongify(self);
            return [[[Dao share] getRankingByUniversityId:self.universityId currentPage:self.currentPage]
                doNext:^(HomePageModel *x) {
                    @strongify(self);
                    if (self.currentPage == 1) {
                        self.homePage = x;
                    } else {
                        [self.homePage.university.timeCostedRanking.data addObjectsFromArray:x.university.timeCostedRanking.data];
                    }
                }];
        }];
        
        self.cmdGetRanking = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id input) {
            @strongify(self);
            self.currentPage = 1;
            return signal;
        }];
        
        self.cmdLoadMoreRanking = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id input) {
            @strongify(self);
            self.currentPage++;
            return signal;
        }];
    }
    return self;
}


@end
