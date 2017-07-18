//
//  SportsHistoryViewModel.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/20.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "SportsHistoryViewModel.h"
#import "Dao+SportsHistory.h"

@interface SportsHistoryViewModel ()

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation SportsHistoryViewModel

- (instancetype)init {
    if (self = [super init]) {
        @weakify(self);
        RACSignal *signal = [RACSignal defer:^RACSignal *{
            @strongify(self);
            return [[[Dao share] getSportsHistoryWithStudentId:self.studentId
                                                   currentPage:self.currentPage]
                    doNext:^(HomePageModel *x) {
                        @strongify(self);
                        if (self.currentPage == 1) {
                            self.homePage = x;
                        } else {
                            [self.homePage.student.currentTermActivities.data addObjectsFromArray:x.student.currentTermActivities.data];
                        }
                    }];
        }];
        
        self.cmdRefreshSportsHistory = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id input) {
            @strongify(self);
            self.currentPage = 1;
            return signal;
        }];
        
        self.cmdLoadMoreSportsHistory = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id input) {
            @strongify(self);
            self.currentPage++;
            return signal;
        }];
    }
    return self;
}


@end
