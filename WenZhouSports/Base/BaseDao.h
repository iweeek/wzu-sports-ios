//
//  Dao.h
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/2.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseDao : NSObject

+ (instancetype)singletone;

- (RACSignal *)RAC_GET:(NSString *)path parameters:(id)patameters;

- (RACSignal *)RAC_POST:(NSString *)path parameters:(id)parameters;

- (RACSignal *)RAC_POST:(NSString *)path parameters:(id)parameters postParameters:(id)postParameters;

@end