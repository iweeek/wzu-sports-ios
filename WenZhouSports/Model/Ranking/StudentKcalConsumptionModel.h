//
//  StudentKcalConsumptionModel.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/8/3.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentKcalConsumptionModel : NSObject

@property (nonatomic, assign) NSInteger studentId;
@property (nonatomic, strong) NSString *studentName;
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, assign) NSInteger kcalConsumption;

@end
