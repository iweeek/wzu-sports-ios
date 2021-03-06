//
//  HomePageModel.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/18.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UniversityModel.h"
#import "StudentModel.h"
#import "RunningSportsModel.h"
#import "AreaSportModel.h"

@interface HomePageModel : NSObject

@property (nonatomic, strong) UniversityModel *university;
@property (nonatomic, strong) StudentModel *student;
@property (nonatomic, strong) NSArray *runningSports;
@property (nonatomic, strong) NSArray *areaSports;

@end
