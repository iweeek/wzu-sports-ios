//
//  ZBJProgressHUD.m
//  zbj-iPhone
//
//  Created by 王刚 on 15/6/17.
//  Copyright (c) 2015年 ZhuBaiJia. All rights reserved.
//

#import "LNDProgressHUD.h"
#import "MBProgressHUD.h"

@interface LNDProgressHUD() <MBProgressHUDDelegate>

@end

@implementation LNDProgressHUD

+ (LNDProgressHUD*)sharedView {
    static dispatch_once_t once;
    static LNDProgressHUD *sharedView;
    dispatch_once(&once, ^ { sharedView = [[self alloc] init]; });
    return sharedView;
}



#pragma mark - loading

+ (void)showLoadingInView:(UIView *)view {
    [MBProgressHUD showHUDAddedTo:view animated:YES];
}

+ (void)showLoadingWithMesssage:(NSString *)msg inView:(UIView *)view {
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    
    HUD.labelText = msg;
    
    [HUD show:YES];
}

+ (void)showLoadingWithMessage:(NSString *)msg detial:(NSString *)detail inView:(UIView *)view {
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    
    HUD.labelText = msg;
    HUD.detailsLabelText = detail;
    HUD.square = YES;
    
    [HUD show:YES];
}

+ (void)hidenForView:(UIView *)view {
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}

#pragma mark - message

+ (void)showMessage:(NSString *)msg inView:(UIView *)view {
    [LNDProgressHUD showMessage:msg durationTime:1.8 completionBlock:nil inView:view];
}

+ (void)showSuccessMessage:(NSString *)msg inView:(UIView *)view {
    [LNDProgressHUD showMessage:msg durationTime:1.8 completionBlock:nil inView:view];
}

+ (void)showErrorMessage:(NSString *)msg inView:(UIView *)view {
    [LNDProgressHUD showMessage:msg durationTime:1.8 completionBlock:nil inView:view];
}

+ (void)showMessage:(NSString *)msg durationTime:(NSTimeInterval)durationTime completionBlock:(void (^)())completion inView:(UIView *)view {
    [LNDProgressHUD showMessage:msg detail:nil durationTime:durationTime completionBlock:completion inView:view];
}

+ (void)showMessage:(NSString *)msg detail:(NSString *)detail durationTime:(NSTimeInterval)durationTime completionBlock:(void (^)())completion inView:(UIView *)view {
    
    [self showMessage:msg detail:detail userInteractionEnabled:YES durationTime:durationTime completionBlock:completion inView:view];
}




+ (void)showMessageOnKeyboard:(NSString *)msg detail:(NSString *)detail durationTime:(NSTimeInterval)durationTime completionBlock:(void (^)())completion inView:(UIView *)view {
    MBProgressHUD *h = [MBProgressHUD HUDForView:view];
    
    NSArray * windows = [[UIApplication sharedApplication] windows];
    UIWindow * keyboardWindow = nil;
    
    for (UIWindow *window in windows) {
        if ([window isKindOfClass:NSClassFromString(@"UITextEffectsWindow")]) {
            keyboardWindow = window;
        }
    }
    
    if ([h.labelText isEqualToString:msg] || [h.detailsLabelText isEqualToString:detail]) {
        return;
    } else {
        if (keyboardWindow) {
            [MBProgressHUD hideHUDForView:keyboardWindow animated:YES];
        }else{
            
            [MBProgressHUD hideHUDForView:view animated:YES];
        }
    }
    
    MBProgressHUD *hud = nil;
    if (keyboardWindow) {
        hud = [MBProgressHUD showHUDAddedTo:keyboardWindow animated:YES];
    }else{
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    
    //    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.mode = MBProgressHUDModeText;
    hud.labelText = detail;
    hud.detailsLabelText = msg;
    hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16.0];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, durationTime * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //        [MBProgressHUD hideHUDForView:view animated:YES];
        if (keyboardWindow) {
            
            [MBProgressHUD hideHUDForView:keyboardWindow animated:YES];
            
        }else{
            
            [MBProgressHUD hideHUDForView:view animated:YES];
        }
        
        if (completion) {
            completion();
        }
    });
    
}


+ (void)showMessageCanMove:(NSString *)msg detail:(NSString *)detail durationTime:(NSTimeInterval)durationTime completionBlock:(void (^)())completion inView:(UIView *)view {
     [self showMessage:msg detail:detail userInteractionEnabled:NO durationTime:durationTime completionBlock:completion inView:view];
}

+ (void)showMessage:(NSString *)msg detail:(NSString *)detail userInteractionEnabled:(BOOL)userInteractionEnabled  durationTime:(NSTimeInterval)durationTime completionBlock:(void (^)())completion inView:(UIView *)view {
    
    MBProgressHUD *h = [MBProgressHUD HUDForView:view];
    
    if ([h.labelText isEqualToString:msg]) {
        return;
    } else {
        [MBProgressHUD hideHUDForView:view animated:YES];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = detail;
    hud.detailsLabelText = msg;
    hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
    hud.userInteractionEnabled = userInteractionEnabled;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, durationTime * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [MBProgressHUD hideHUDForView:view animated:YES];
        if (completion) {
            completion();
        }
    });
}




@end
