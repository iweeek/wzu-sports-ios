//
//  Dao+Home.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/9.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "Dao.h"

@interface Dao (Home)

- (RACSignal *)runningProjects:(NSDictionary *)dic;
- (RACSignal *)sportTotal:(NSDictionary *)dic;

@end
