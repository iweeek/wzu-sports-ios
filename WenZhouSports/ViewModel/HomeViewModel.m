//
//  HomeViewModel.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/7.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "HomeViewModel.h"
#import "Dao.h"
#import "StudentModel.h"
#import "Dao+Home.h"

@implementation HomeViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.cmdGraphql = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary *input) {
            return [[Dao share] HomePage:input];
        }];
    }
    return self;
}


@end
