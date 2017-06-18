//
//  HomePageModel.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/18.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "HomePageModel.h"

@implementation HomePageModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"runningProjects":[runningProjectItemModel class]};
}

@end
