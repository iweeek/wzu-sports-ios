//
//  Dao.h
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/2.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dao : NSObject

+ (instancetype)share;

- (RACSignal *)RAC_GET:(NSString *)path parameters:(id)patameters;

- (RACSignal *)RAC_POST:(NSString *)path parameters:(id)parameters;

- (RACSignal *)RAC_POST:(NSString *)path parameters:(id)parameters postParameters:(id)postParameters;

- (id)jsonToMode:(Class)className dictionary:(NSDictionary *)value;

@end
