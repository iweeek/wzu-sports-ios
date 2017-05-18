//
//  NSNumber+SetScale.m
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/10.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "NSNumber+SetScale.h"

@implementation NSNumber (SetScale)

- (NSString *)getNumberWithScale:(NSInteger)scale {
    NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
    [format setNumberStyle:NSNumberFormatterDecimalStyle];
    [format setMaximumFractionDigits:scale];
    return [format stringFromNumber:self];
}

@end
