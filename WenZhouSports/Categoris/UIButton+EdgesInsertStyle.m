//
//  UIButton+EdgesInsertStyle.m
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/10.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "UIButton+EdgesInsertStyle.h"

@implementation UIButton (EdgesInsertStyle)

- (void)changeButtonStyle:(ButtonEdgesInsetsStyle)style space:(CGFloat)space {
    CGFloat imageHeight = self.imageView.frame.size.height;
    CGFloat imageWidth = self.imageView.frame.size.width;
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
    }
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;
    UIEdgeInsets titleInset = UIEdgeInsetsZero;
    switch (style) {
        case EdgesStyleTop:
            imageInsets = UIEdgeInsetsMake(-labelHeight - space, 0.0, 0.0, 0.0);
            titleInset = UIEdgeInsetsMake(0.0, -imageWidth, 0.0, 0.0);
            break;
        case EdgesStyleBottom:
            imageInsets = UIEdgeInsetsMake(labelHeight + space, 0.0, 0.0, 0.0);
            titleInset = UIEdgeInsetsMake(0.0, -imageWidth, 0.0, 0.0);
            break;
        case EdgesStyleRight:
            imageInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, labelWidth);
            titleInset = UIEdgeInsetsMake(0.0, -imageWidth - space, 0.0, 0.0);
            break;
        default:
            break;
    }
    self.imageEdgeInsets = imageInsets;
    self.titleEdgeInsets = titleInset;
}

@end
