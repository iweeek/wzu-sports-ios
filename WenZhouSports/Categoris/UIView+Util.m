//
//  UIView+Util.m
//  WenZhouSports
//
//  Created by 何聪 on 2017/4/28.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "UIView+Util.h"

@implementation UIView (Util)

- (void)addSubviews:(NSArray *)subViews
{
    for (UIView *v in subViews) {
        NSParameterAssert([v isKindOfClass:[UIView class]]);
        [self addSubview:v];
    }
}

@end
