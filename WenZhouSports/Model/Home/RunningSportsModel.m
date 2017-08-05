//
//  runningProjectModel.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/11.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "RunningSportsModel.h"
#import "RunningSportModel.h"

@implementation RunningSportsModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"runningSports":[RunningSportModel class]};
}

@end
