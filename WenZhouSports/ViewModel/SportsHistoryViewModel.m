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
                                    startDate:self.startDate
                                      endDate:self.endDate
                            sportsHistoryType:self.sportsHistoryType]
                    doNext:^(HomePageModel *x) {
                        @strongify(self);
                        if (self.currentPage == 1) {
                            self.homePage = x;
                            [self mergeArray];
                        } else {
                            [self.homePage.student.currentTermActivities.data addObjectsFromArray:x.student.currentTermActivities.data];
                        }
                    }];
//            return [[[Dao share] getSportsHistoryWithStudentId:self.studentId
//                                                   currentPage:self.currentPage]
//                    doNext:^(HomePageModel *x) {
//                        @strongify(self);
//                        if (self.currentPage == 1) {
//                            self.homePage = x;
//                        } else {
//                            [self.homePage.student.currentTermActivities.data addObjectsFromArray:x.student.currentTermActivities.data];
//                        }
//                    }];
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
        
        self.cmdLoadMoreSportsHistory = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id input) {
            @strongify(self);
            return [[[Dao share] getRunningActivityWithId:self.runningActivity.id]
            doNext:^(id  _Nullable x) {
                self.runningActivity = x;
            }];
        }];
        
        self.cmdGetRunningActivity = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id input) {
            @strongify(self);
            return [[[Dao share] getRunningActivityWithId:self.runningActivity.id]
                    doNext:^(id  _Nullable x) {
                        self.runningActivity = x;
                    }];
        }];
        
        self.cmdGetAreaActivity = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id input) {
            @strongify(self);
            return [[[Dao share] getAreaActivityWithId:self.areaActivity.id]
                    doNext:^(id  _Nullable x) {
                        self.areaActivity = x;
                    }];
        }];
    }
    return self;
}

- (void)mergeArray  {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    for (RunningActivityModel *runningActivity in self.homePage.student.runningActivities.data) {
        [arr addObject:runningActivity];
    }
    for (AreaActivityModel *areaActivity in self.homePage.student.areaActivities.data) {
        [arr addObject:areaActivity];
    }
    
    // 获取array中所有index值
    NSArray *indexArray = [arr valueForKey:@"sportDate"];
    
    // 将array装换成NSSet类型为了去重
    NSSet *indexSet = [NSSet setWithArray:indexArray];
    
    // 重新赋值给一个数组为了排序
    NSArray *tempArr = [indexSet allObjects];
    
    // 倒序
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSArray *sortedArray = [tempArr sortedArrayUsingComparator:^(NSString *string1, NSString *string2) {
        NSDate *date1 = [dateFormatter dateFromString:string1];
        NSDate *date2 = [dateFormatter dateFromString:string2];
        
        return [date2 compare:date1];
    }];
    
    // 新建array，用来存放分组后的array
    NSMutableArray *resultArray = [NSMutableArray array];
    for (id obj in sortedArray) {
        // 根据NSPredicate获取array
        NSLog(@"%@",obj);
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sportDate == %@",obj];
        NSArray *tempArr = [arr filteredArrayUsingPredicate:predicate];
        
        // 将查询结果加入到resultArray中
        [resultArray addObject:tempArr];
    }
    self.allActivityArray = resultArray;
}


@end
