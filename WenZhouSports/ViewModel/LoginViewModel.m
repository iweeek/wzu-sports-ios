//
//  LoginViewModel.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/8/7.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "LoginViewModel.h"
#import "Dao+Login.h"

@implementation LoginViewModel

- (instancetype)init {
    if (self = [super init]) {
        @weakify(self);
        RACSignal *signal = [RACSignal defer:^RACSignal *{
            @strongify(self);
            return [[[Dao share] getStudentInfoWithUserId:self.user.userId]
                    doNext:^(id x) {
                        @strongify(self);
                        self.student = x;
                    }];
        }];
        
        self.cmdLogin = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary *input) {
            @strongify(self);
            return [[[[[Dao share] LoginWithUniversityId:self.universityId
                                               username:self.username
                                               password:self.password]
                    doNext:^(id  _Nullable x) {
                        @strongify(self);
                        self.user = x;
                    }]
                    flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
                        return signal;
                    }]
                    catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
                        return [RACSignal error:error];
                    }];
        }];
        
        self.cmdGetUniversities = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary *input) {
            return [[[[Dao share] getUniversities]
                     doNext:^(id  _Nullable x) {
                         self.universities = x;
                     }]
                    catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
                        return [RACSignal error:error];
                    }];
        }];
    }
    
    
    return self;
}


@end
