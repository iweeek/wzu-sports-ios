//
//  NSString+toDictionary.m
//  Lvka
//
//  Created by iOSDev1 on 17/3/16.
//  Copyright © 2017年 iOSDev1. All rights reserved.
//

#import "NSString+JsonToDictionary.h"

@implementation NSString (JsonToDictionary)

- (NSDictionary *)toDictionary
{
    if (self == nil) {
        return nil;
    }
    
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
