//
//  AreaActiviesPageModel.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/8/1.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "AreaActiviesPageModel.h"

@implementation AreaActiviesPageModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data":[AreaActivityModel class]};
}

@end
