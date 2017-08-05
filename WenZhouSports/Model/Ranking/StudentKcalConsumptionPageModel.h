//
//  StudentKcalConsumptionPageModel.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/8/3.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentKcalConsumptionPageModel : NSObject

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger pagesCount;
@property (nonatomic, assign) NSInteger dataCount;
@property (nonatomic, strong) NSMutableArray *data;

@end
