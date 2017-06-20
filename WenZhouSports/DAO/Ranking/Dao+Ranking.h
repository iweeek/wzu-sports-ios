//
//  Dao+Ranking.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/19.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "Dao.h"

@interface Dao (Ranking)

- (RACSignal *)getRanking:(NSDictionary *)dic;

@end
