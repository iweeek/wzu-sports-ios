//
//  AreaActiviesPageModel.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/8/1.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AreaActivityModel.h"

@interface AreaActiviesPageModel : NSObject

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger pagesCount;
@property (nonatomic, assign) NSInteger dataCount;
@property (nonatomic, strong) NSMutableArray<AreaActivityModel *> *data;

@end
