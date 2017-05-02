//
//  Dao.m
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/2.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "Dao.h"
#import "AFHTTPSessionManager+RACSupport.h"

@interface Dao ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation Dao

+ (instancetype)singletone {
    static Dao *this;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        this = [[Dao alloc] init];
        this.manager = [AFHTTPSessionManager manager];
        this.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        this.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [this.manager.requestSerializer setTimeoutInterval:30.0];
    });
    
    return this;
}

- (NSString *)createUrl:(NSString *)path {
    return nil;
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
        if ([[json objectForKey:@"status"] boolValue]) {
            [subscriber sendNext:json];
            [subscriber sendCompleted];
        } else {
            NSString *message = [json objectForKey:@"errMsg"];
            NSInteger code = 1004;
            if (![self isReachable]) {
                code = 1006;
                message = @"没有网络";
            }
            [subscriber sendError:[NSError errorWithDomain:message code:code userInfo:nil]];
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
    NSLog(@"===============");
    NSLog(@"%@?%@", path, tmp);
    NSLog(@"===============");
    @weakify(self);
    return [[[[self.manager RAC_GET:[self createUrl:path] parameters:parameters] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        @strongify(self)
        return [self checkData:value];
    }] catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
        @strongify(self)
        return [self catchError:error];
    }] deliverOnMainThread];
}

- (RACSignal *)RAC_POST:(NSString *)path parameters:(id)parameters {
    NSDictionary *dic = parameters;
    __block NSString *tmp = @"";
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key,
                                             id  _Nonnull obj,
                                             BOOL * _Nonnull stop) {
        tmp = [NSString stringWithFormat:@"%@%@=%@&", tmp, key, obj];
    }];
    NSLog(@"===============");
    NSLog(@"%@?%@", path, tmp);
    NSLog(@"===============");
    @weakify(self);
    return [[[[self.manager RAC_GET:[self createUrl:path] parameters:parameters] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        @strongify(self)
        return [self checkData:value];
    }] catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
        @strongify(self)
        return [self catchError:error];
    }] deliverOnMainThread];
}

- (BOOL)isReachable {
    BOOL __block reachabilty = true;
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                reachabilty = false;
                break;
                
            default:
                break;
        }
    }];
    return reachabilty;
}

@end
