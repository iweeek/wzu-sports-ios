//
//  TermModel.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/18.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TermSportsTaskModel.h"

@interface TermModel : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger universityId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSTimeInterval startDate;
@property (nonatomic, assign) NSTimeInterval endDate;
@property (nonatomic, strong) TermSportsTaskModel *termSportsTask;

@end
