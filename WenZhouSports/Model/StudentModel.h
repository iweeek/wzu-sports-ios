//
//  StudentModel.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/8.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivitiesPageModel.h"

@interface StudentModel : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *studentNo;
@property (nonatomic, assign) BOOL isMan;
@property (nonatomic, assign) NSInteger universityId;
@property (nonatomic, assign) NSInteger classId;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger caloriesConsumption;
@property (nonatomic, assign) NSInteger currentTermQualifiedActivityCount;
@property (nonatomic, strong) ActivitiesPageModel *currentTermActivities;

@end
