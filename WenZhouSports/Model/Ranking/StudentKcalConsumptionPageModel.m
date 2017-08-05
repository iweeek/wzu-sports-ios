//
//  StudentKcalConsumptionPageModel.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/8/3.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "StudentKcalConsumptionPageModel.h"
#import "StudentKcalConsumptionModel.h"

@implementation StudentKcalConsumptionPageModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data":[StudentKcalConsumptionModel class]};
}

@end
