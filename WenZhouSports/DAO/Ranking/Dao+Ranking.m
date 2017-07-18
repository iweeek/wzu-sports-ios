//
//  Dao+Ranking.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/19.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "Dao+Ranking.h"
#import "HomePageModel.h"

@implementation Dao (Ranking)

- (RACSignal *)getRankingByUniversityId:(NSInteger)universityId
                            currentPage:(NSInteger)currentPage {
    NSString *str = @"{ \
                        university(id:%ld) { \
                            timeCostedRanking (pageSize:%ld pageNumber:%ld){ \
                                pagesCount \
                                data{ \
                                    studentId \
                                    studentName \
                                    timeCosted \
                                    avatarUrl \
                                } \
                            } \
                        }\
                    }";
    NSDictionary *dicParameters = @{@"query":[NSString stringWithFormat:str, universityId, pageSize, currentPage]};
    return [[self RAC_POST:@"graphql/query" parameters:dicParameters]
            map:^id _Nullable(id _Nullable value) {
                return [self jsonToMode:[HomePageModel class] dictionary:value key:nil];
            }];
}

@end
