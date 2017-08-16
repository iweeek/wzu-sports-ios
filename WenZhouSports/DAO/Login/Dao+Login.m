//
//  Dao+Login.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/8/7.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "Dao+Login.h"
#import "UniversitiesModel.h"
#import "UserModel.h"
#import "StudentModel.h"

@implementation Dao (Login)

- (RACSignal *)LoginWithUniversityId:(NSInteger)universityId
                          username:(NSString *)username
                            password:(NSString *)password {
    NSDictionary *dicParameters = @{@"universityId":@(universityId),
                                    @"username":username,
                                    @"password":password};
    return [[self RAC_POST:@"tokens" parameters:dicParameters]
            map:^id _Nullable(id  _Nullable value) {
                return [self jsonToMode:[UserModel class] dictionary:value key:nil];
            }];
}

- (RACSignal *)getStudentInfoWithUserId:(NSInteger)userId {
    NSString *str = @"{ \
                        student(userId:%ld){ \
                            id \
                            universityId \
                            name \
                        } \
                      }";
    NSDictionary *dicParameters = @{@"query":[NSString stringWithFormat:str, userId]};
    return [[self RAC_POST:@"graphql/query" parameters:dicParameters]
            map:^id _Nullable(id  _Nullable value) {
                return [self jsonToMode:[StudentModel class] dictionary:value key:@"student"];
            }];
}

- (RACSignal *)getUniversities {
    NSString *str = @"{ \
                        universities{ \
                            id \
                            name \
                        } \
                      }";
    NSDictionary *dicParameters = @{@"query":str};
    return [[self RAC_POST:@"graphql/query" parameters:dicParameters]
            map:^id _Nullable(id  _Nullable value) {
                return [self jsonToMode:[UniversitiesModel class] dictionary:value key:nil];
            }];
}


@end
