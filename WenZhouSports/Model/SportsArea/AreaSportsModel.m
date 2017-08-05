//
//  AreaSports.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/7/28.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "AreaSportsModel.h"
#import "AreaSportModel.h"

@implementation AreaSportsModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"areaSport":[AreaSportModel class]};
}

@end
