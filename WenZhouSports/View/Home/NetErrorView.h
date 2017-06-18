//
//  ZBJNetErrorView.h
//  lnd
//
//  Created by jia guo on 16/6/29.
//  Copyright © 2016年 zhubaijia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^reloadBlock)();

@interface NetErrorView : UIView

- (void)reloadView:(reloadBlock)reloadBlock;

@end
