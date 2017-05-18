//
//  UIImageView+Hexagon.h
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/6.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Hexagon)

/**
 将UIImageView切割成带边框的六边形，注意要在imageView设置了Size以后调用

 @param image 要显示的图片
 */
- (void)cutHexagonWithImage: (UIImage *)image;

@end
