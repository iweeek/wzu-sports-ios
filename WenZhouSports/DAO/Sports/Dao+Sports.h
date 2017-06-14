//
//  Dao+Sports.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/14.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "Dao.h"

@interface Dao (Sports)

- (RACSignal *)runActivity:(NSDictionary *)dic;

@end
