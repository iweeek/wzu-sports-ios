//
//  LoginView.h
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/2.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginView : UIView

/**
 登录按钮点击事件
 */
@property (nonatomic, strong, readonly) RACSignal *loginSignal;

/**
 忘记密码点击事件
 */
@property (nonatomic, strong, readonly) RACSignal *forgetPasswordSignal;

@end
