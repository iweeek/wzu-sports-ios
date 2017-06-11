//
//  runningProjectModel.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/11.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "runningProjectsModel.h"
#import "runningProjectItemModel.h"

@implementation runningProjectsModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"runningProjects":[runningProjectItemModel class]};
}

@end
