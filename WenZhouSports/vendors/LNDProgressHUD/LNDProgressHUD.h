//
//  ZBJProgressHUD.h
//  zbj-iPhone
//
//  Created by 王刚 on 15/6/17.
//  Copyright (c) 2015年 ZhuBaiJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LNDProgressHUD : UIView

+ (void)showLoadingInView:(UIView *)view;
+ (void)showLoadingWithMesssage:(NSString *)msg inView:(UIView *)view;
+ (void)showLoadingWithMessage:(NSString *)msg detial:(NSString *)detail inView:(UIView *)view;
+ (void)hidenForView:(UIView *)view;

+ (void)showMessage:(NSString *)msg inView:(UIView *)view;
+ (void)showSuccessMessage:(NSString *)msg inView:(UIView *)view;
+ (void)showErrorMessage:(NSString *)msg inView:(UIView *)view;
+ (void)showMessage:(NSString *)msg durationTime:(NSTimeInterval)durationTime completionBlock:(void (^)())completion inView:(UIView *)view;
+ (void)showMessage:(NSString *)msg detail:(NSString *)detail durationTime:(NSTimeInterval)durationTime completionBlock:(void (^)())completion inView:(UIView *)view;

// keyboard use
+ (void)showMessageOnKeyboard:(NSString *)msg detail:(NSString *)detail durationTime:(NSTimeInterval)durationTime completionBlock:(void (^)())completion inView:(UIView *)view;

/// 收藏使用
+ (void)showMessageCanMove:(NSString *)msg detail:(NSString *)detail durationTime:(NSTimeInterval)durationTime completionBlock:(void (^)())completion inView:(UIView *)view;

@end
