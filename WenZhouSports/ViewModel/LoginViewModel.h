//
//  LoginViewModel.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/8/7.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UniversitiesModel.h"
#import "UserModel.h"
#import "StudentModel.h"

@interface LoginViewModel : NSObject

@property (nonatomic, strong) RACCommand *cmdLogin;
@property (nonatomic, strong) RACCommand *cmdGetUniversities;

@property (nonatomic, strong) UniversitiesModel *universities;
@property (nonatomic, strong) UserModel *user;
@property (nonatomic, strong) StudentModel *student;

@property (nonatomic, assign) NSInteger universityId;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

@end
