//
//  SportsAreaOutdoorsModel.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/7/28.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "AreaSportsOutdoorPointsModel.h"
#import "AreaSportsOutdoorPointModel.h"

@implementation AreaSportsOutdoorPointsModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"obj":[AreaSportsOutdoorPointModel class]};
}

@end
