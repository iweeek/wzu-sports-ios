//
//  UniversityModel.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/17.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TermModel.h"
#import "StudentTimeCostedPageModel.h"
#import "StudentKcalConsumptionPageModel.h"

@interface UniversityModel : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger teachersCount;
@property (nonatomic, strong) TermModel *currentTerm;
@property (nonatomic, strong) StudentTimeCostedPageModel *timeCostedRanking;//该校的学生累计锻炼时长排行榜
@property (nonatomic, strong) StudentKcalConsumptionPageModel *kcalConsumptionRanking;



@end
