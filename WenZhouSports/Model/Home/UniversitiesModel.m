//
//  UniversitiesModel.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/8/8.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "UniversitiesModel.h"
#import "UniversityModel.h"

@implementation UniversitiesModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"universities":[UniversityModel class]};
}

@end
