//
//  UserModel.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/8/10.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, assign) NSTimeInterval expiredDate;//过期时间
@property (nonatomic, strong) NSArray *roles;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, assign) NSInteger userId;

@end
