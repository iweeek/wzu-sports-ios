//
//  ForgetPasswordView.h
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/4.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPasswordView : UIView

/**
 下一步按钮点击事件
 */
@property (nonatomic, strong, readonly) RACSignal *nextSignal;


/**
 设置各个空间的文本

 @param text label的text
 @param placeholder textView的placeholder
 @param title button的名称
 */
- (void)setLabel: (NSString *)text
        textView: (NSString *)placeholder
          button: (NSString *)title;


/**
 获取textField的文本

 @return String
 */
- (NSString *)getStringOfTextField;

/**
 显示显示密码按钮

 @param isShowPassword 是否显示
 */
- (void)setShowPassword: (BOOL)isShowPassword;

@end
