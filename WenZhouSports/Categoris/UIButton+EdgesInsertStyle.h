//
//  UIButton+EdgesInsertStyle.h
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/10.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ButtonEdgesInsetsStyle) {
    EdgesStyleTop,
    EdgesStyleRight,
    EdgesStyleBottom
};

@interface UIButton (EdgesInsertStyle)

- (void)changeButtonStyle:(ButtonEdgesInsetsStyle)style
                    space:(CGFloat)space;

@end
