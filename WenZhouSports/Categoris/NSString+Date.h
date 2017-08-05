//
//  NSString+Date.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/7/21.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Date)

#pragma mark - 将某个时间转化成 时间戳

+ (NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format;

#pragma mark - 将某个时间戳转化成 时间

+ (NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format;


@end
