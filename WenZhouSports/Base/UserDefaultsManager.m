//
//  LNDUserDefaultsManager.m
//  lnd
//
//  Created by 郭佳 on 7/1/16.
//  Copyright © 2016 zhubaijia. All rights reserved.
//

#import "UserDefaultsManager.h"

static NSString *const kUserId = @"UserId";
static NSString *const kStudentId = @"StudentId";
static NSString *const kStudentName = @"StudentName";
static NSString *const kUniversityId = @"UniversityId";
static NSString *const kAppVersion = @"AppVersion";


@interface UserDefaultsManager ()

@property (nonatomic, strong) NSUserDefaults *defaults;

@end

@implementation UserDefaultsManager

+ (instancetype)sharedUserDefaults {
    static UserDefaultsManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UserDefaultsManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

#pragma mark - userId
- (NSInteger)userId {
    return [[self.defaults objectForKey:kUserId] integerValue];
}

- (void)setUserId:(NSInteger)userId {
    [self.defaults setObject:@(userId) forKey:kUserId];
}

#pragma mark - studentId
- (NSInteger)studentId {
    return [[self.defaults objectForKey:kStudentId] integerValue];
}

- (void)setStudentId:(NSInteger)studentId {
    [self.defaults setObject:@(studentId) forKey:kStudentId];
}

#pragma mark - studentName
- (void)setStudentName:(NSString *)studentName {
    [self.defaults setObject:studentName forKey:kStudentName];
}

- (NSString *)studentName {
    return [self.defaults objectForKey:kStudentName];
}

#pragma mark - universityId
- (NSInteger)universityId {
    return [[self.defaults objectForKey:kUniversityId] integerValue];
}

- (void)setUniversityId:(NSInteger)universityId {
    [self.defaults setObject:@(universityId) forKey:kUniversityId];
}

#pragma mark - appVersion
- (void)setAppVersion:(NSString *)appVersion {
    [self.defaults setObject:appVersion forKey:kAppVersion];
}

- (NSString *)appVersion {
    return [self.defaults objectForKey:kAppVersion];
}


@end
