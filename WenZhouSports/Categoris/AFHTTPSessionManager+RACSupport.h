//
//  AFHTTPSessionManager+RACSupport.h
//  WenZhouSports
//
//  Created by 何聪 on 2017/4/28.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface AFHTTPSessionManager (RACSupport)

- (RACSignal *)RAC_GET: (NSString *)path
            parameters: (id)parameters;

- (RACSignal *)RAC_POST:(NSString *)path
             parameters:(id)parameters;

- (RACSignal *)RAC_POST:(NSString *)path
             parameters:(id)parameters
         postParameters:(id)postParameters;

@end
