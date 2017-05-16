//
//  BaseDao+Category.h
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/15.
//  Copyright © 2017年 何聪. All rights reserved.
//
#import "BaseDao.h"

@interface BaseDao (Category)


/**
 调用face++的人脸比较API

 @param face1 第一张脸
 @param face2 第二张脸
 @return signal
 */
- (RACSignal *)compareFaceWithFace1:(UIImage *)face1 face2:(UIImage *)face2;

@end
