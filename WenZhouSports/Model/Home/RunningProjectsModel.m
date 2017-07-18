//
//  runningProjectModel.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/11.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "RunningProjectsModel.h"
#import "RunningProjectItemModel.h"

@implementation RunningProjectsModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"runningProjects":[RunningProjectItemModel class]};
}

@end
