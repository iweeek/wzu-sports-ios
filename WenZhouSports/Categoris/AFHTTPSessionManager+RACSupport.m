//
//  AFHTTPSessionManager+RACSupport.m
//  WenZhouSports
//
//  Created by 何聪 on 2017/4/28.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "AFHTTPSessionManager+RACSupport.h"

@implementation AFHTTPSessionManager (RACSupport)

- (RACSignal *)RAC_GET:(NSString *)path parameters:(id)parameters {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            NSURLSessionTask *task = [self GET:path parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                DDLogVerbose(@"%@", error);
                [subscriber sendError:error];
            }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

- (RACSignal *)RAC_POST:(NSString *)path parameters:(id)parameters {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionTask *task = [self POST:path parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            DDLogVerbose(@"%@", error);
            [subscriber sendError:error];
        }];
        [task resume];
       return [RACDisposable disposableWithBlock:^{
           [task cancel];
       }];
    }];
}

- (RACSignal *)RAC_POST:(NSString *)path parameters:(id)parameters postParameters:(id)postParameters{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]
                                        multipartFormRequestWithMethod:@"POST"
                                        URLString:path
                                        parameters:parameters
                                        constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                                            NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
                                            long long tmp = interval;
                                            
                                                                                   } error:nil];
        NSLog(@"%@", request);
        [request setValue:@"application/x-www-form-urlencoded"forHTTPHeaderField:@"Content-Type"];
        NSURLSessionUploadTask *task = [self uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
            //上传进度
            NSLog(@"%@", uploadProgress);
        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@",error);
                [subscriber sendError:error];
            } else {
                NSLog(@"%@",responseObject);
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            }
        }];
        [task resume];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

@end
