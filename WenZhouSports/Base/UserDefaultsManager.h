//
//  LNDUserDefaultsManager.h
//  lnd
//
//  Created by 郭佳 on 7/1/16.
//  Copyright © 2016 zhubaijia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultsManager : NSObject

+ (instancetype)sharedUserDefaults;

/** User unique identifier */
@property (nonatomic, assign) NSInteger userId;

/** 学生id */
@property (nonatomic, assign) NSInteger studentId;
@property (nonatomic, strong) NSString *studentName;

/** 大学id */
@property (nonatomic, assign) NSInteger universityId;

/** app版本 */
@property (nonatomic, strong) NSString *appVersion;

@end
