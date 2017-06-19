//
//  Dao.m
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/2.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "Dao.h"
#import "AFHTTPSessionManager+RACSupport.h"
#import "APIInterface.h"
#import <Foundation/Foundation.h>
#import "NSString+JsonToDictionary.h"

@interface Dao ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation Dao

+ (instancetype)share {
    static Dao *this;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        this = [[Dao alloc] init];
        this.manager = [AFHTTPSessionManager manager];
//        this.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        this.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        this.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/json", @"text/javascript", @"text/html",  nil];
        
//        this.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        this.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [this.manager.requestSerializer setTimeoutInterval:30.0];
//        [this.manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [this.manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    });
    
    return this;
}

- (RACSignal *)catchError:(NSError *)error {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSInteger code = error.code;
        NSString *message = error.domain;
        if (![self isReachable]) {
            code = 1006;
            message = @"没有网络";
        }
        [subscriber sendError:[NSError errorWithDomain:message code:code userInfo:nil]];
        return nil;
    }];
}

- (RACSignal *)checkData:(id)json {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSArray *errorsArray = [json objectForKey:@"errors"];
        if (errorsArray.count == 0) {
            [subscriber sendNext:json];
            [subscriber sendCompleted];
        } else {
            NSString *message = [json objectForKey:@"message"];
            NSInteger code = 1004;
            if (![self isReachable]) {
                code = 1006;
                message = @"没有网络";
            }
            [subscriber sendError:[NSError errorWithDomain:@""
                                                      code:code
                                                  userInfo:@{@"msg":@""}]];
        }
        return nil;
    }];
}

- (RACSignal *)RAC_GET:(NSString *)path parameters:(id)parameters {
    NSDictionary *dic = parameters;
    __block NSString *tmp = @"";
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key,
                                             id  _Nonnull obj,
                                             BOOL * _Nonnull stop) {
        tmp = [NSString stringWithFormat:@"%@%@=%@&", tmp, key, obj];
    }];
    NSString *requestPath = [NSString stringWithFormat:Server, path];
    NSLog(@"===============");
    NSLog(@"%@?%@", requestPath, tmp);
    NSLog(@"===============");
    @weakify(self);
    return [[[[self.manager RAC_GET:requestPath parameters:parameters] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        @strongify(self);
        return [self checkData:value];
    }] catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
        @strongify(self);
        return [self catchError:error];
    }] deliverOnMainThread];
}

- (RACSignal *)RAC_POST:(NSString *)path parameters:(id)parameters {
    NSDictionary *dic = parameters;
    __block NSString *tmp = @"";
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key,
                                             id  _Nonnull obj,
                                             BOOL * _Nonnull stop) {
        tmp = [NSString stringWithFormat:@"%@%@=%@", tmp, key, obj];
    }];
    NSString *requestPath = [NSString stringWithFormat:Server, path];
    NSLog(@"===============");
    NSLog(@"%@", requestPath);
    NSLog(@"===============");
    @weakify(self);
    return [[[[self.manager RAC_POST:requestPath parameters:parameters] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        @strongify(self);
        return [self checkData:value];
    }] catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
        @strongify(self);
        return [self catchError:error];
    }] deliverOnMainThread];
}

- (RACSignal *)RAC_POST:(NSString *)path parameters:(id)parameters postParameters:(id)postParameters {
    NSDictionary *dic = parameters;
    __block NSString *tmp = @"";
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        tmp = [NSString stringWithFormat:@"%@%@=%@&", tmp, key, obj];
    }];
    NSString *requestPath = [NSString stringWithFormat:Server, path];
    NSLog(@"===============");
    NSLog(@"%@?%@", requestPath, tmp);
    NSLog(@"===============");
    if ([self isReachable]){
        DDLogVerbose(@"网络状态良好");
    }
    @weakify(self);
    return [[[[self.manager RAC_POST:requestPath parameters:parameters postParameters:postParameters] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        @strongify(self);
        return [self checkData:value];
    }] catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
        @strongify(self);
        return [self catchError:error];
    }] deliverOnMainThread];
}

- (BOOL)isReachable {
    BOOL __block reachabilty = true;
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case 0:
                reachabilty = false;
                break;
                
            default:
                break;
        }
    }];
    return reachabilty;
}

- (id)jsonToMode:(Class)className dictionary:(id)value key:(NSString *)key {
//    NSString *jsonStr = [[NSString alloc] initWithData:value encoding:NSUTF8StringEncoding];
//    NSDictionary *jsonDic = [jsonStr toDictionary];
    id responseData = value[@"data"];
    NSLog(@"========data:%@", responseData);
    if (!responseData) {
        return nil;
    }
    
    id obj = [className yy_modelWithDictionary:responseData];
    return obj;
}
@end
