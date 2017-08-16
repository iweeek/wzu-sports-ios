//
//  Dao+Login.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/8/7.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "Dao.h"

@interface Dao (Login)

- (RACSignal *)LoginWithUniversityId:(NSInteger)universityId
                            username:(NSString *)username
                            password:(NSString *)password;

- (RACSignal *)getStudentInfoWithUserId:(NSInteger)userId;

- (RACSignal *)getUniversities;

@end
