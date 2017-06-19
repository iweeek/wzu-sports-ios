//
//  StudentTimeCostedPageModel.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/19.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentTimeCostedPageModel : NSObject

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger pagesCount;
@property (nonatomic, assign) NSInteger dataCount;
@property (nonatomic, strong) NSArray *data;

@end
