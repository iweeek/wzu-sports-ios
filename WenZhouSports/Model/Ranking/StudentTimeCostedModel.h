//
//  StudentTimeCostedModel.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/19.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentTimeCostedModel : NSObject

@property (nonatomic, assign) NSInteger studentId;
@property (nonatomic, strong) NSString *studentName;
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, assign) NSInteger timeCosted;

@end
