//
//  UIBarButtonItem+LNDAddition.h
//  lnd
//
//  Created by 郭佳 on 7/20/16.
//  Copyright © 2016 zhubaijia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (Addition)

- (void)setLeftBarButtonItemWithTitle:(nullable NSString *)title target:(nullable id)target action:(nullable SEL)action;
- (void)setRightBarButtonItemWithTitle:(nullable NSString *)title target:(nullable id)target action:(nullable SEL)action;
- (void)setLeftBarButtonItemWithImage:(nullable UIImage *)image target:(nullable id)target action:(nullable SEL)action;
- (void)setRightBarButtonItemWithImage:(nullable UIImage *)image target:(nullable id)target action:(nullable SEL)action;

@end
