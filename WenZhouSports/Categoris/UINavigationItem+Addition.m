//
//  UIBarButtonItem+LNDAddition.m
//  lnd
//
//  Created by 郭佳 on 7/20/16.
//  Copyright © 2016 zhubaijia. All rights reserved.
//

#import "UINavigationItem+Addition.h"

@implementation UINavigationItem (Addition)

- (void)setLeftBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    [leftItem setTitlePositionAdjustment:UIOffsetMake(3, 0) forBarMetrics:UIBarMetricsDefault];
    [leftItem setTitleTextAttributes:@{NSForegroundColorAttributeName:c474A4F,
                                       NSFontAttributeName: [UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
    [leftItem setTitleTextAttributes:@{NSForegroundColorAttributeName:c474A4F,
                                       NSFontAttributeName: [UIFont systemFontOfSize:17]} forState:UIControlStateDisabled];
    self.leftBarButtonItem = leftItem;
}

- (void)setRightBarButtonItemWithTitle:(nullable NSString *)title target:(nullable id)target action:(nullable SEL)action {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    [rightItem setTitlePositionAdjustment:UIOffsetMake(-3, 0) forBarMetrics:UIBarMetricsDefault];
    [rightItem setTitleTextAttributes:@{NSForegroundColorAttributeName:c474A4F,
                                       NSFontAttributeName: [UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
    [rightItem setTitleTextAttributes:@{NSForegroundColorAttributeName:c474A4F,
                                       NSFontAttributeName: [UIFont systemFontOfSize:17]} forState:UIControlStateDisabled];
    self.rightBarButtonItem = rightItem;
}

- (void)setLeftBarButtonItemWithImage:(nullable UIImage *)image target:(nullable id)target action:(nullable SEL)action {
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:target action:action];
    [leftItem setImageInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    self.leftBarButtonItem = leftItem;
}

- (void)setRightBarButtonItemWithImage:(nullable UIImage *)image target:(nullable id)target action:(nullable SEL)action {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:target action:action];
    [rightItem setImageInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    
    [rightItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                        NSFontAttributeName: [UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    [rightItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                        NSFontAttributeName: [UIFont systemFontOfSize:15]} forState:UIControlStateDisabled];
    self.rightBarButtonItem = rightItem;
}

@end
