//
//  StudentTimeCostedPageModel.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/19.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "StudentTimeCostedPageModel.h"
#import "StudentTimeCostedModel.h"

@implementation StudentTimeCostedPageModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data":[StudentTimeCostedModel class]};
}


@end
