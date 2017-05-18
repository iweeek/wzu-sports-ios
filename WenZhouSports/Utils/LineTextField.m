//
//  LineTextField.m
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/3.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "LineTextField.h"

@interface LineTextField ()

@end

@implementation LineTextField

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - 1.5, CGRectGetWidth(self.frame), 1.5));
}

@end
