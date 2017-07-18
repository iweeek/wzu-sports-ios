//
//  Dao+SportsHistory.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/20.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "Dao.h"

@interface Dao (SportsHistory)

- (RACSignal *)getSportsHistory:(NSDictionary *)dic;
- (RACSignal *)getSportsHistoryWithStudentId:(NSInteger)studentId
                                 currentPage:(NSInteger)currentPage;

@end
