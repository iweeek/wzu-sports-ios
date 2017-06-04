//
//  LoginNewView.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/2.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginView : UIView

@property (nonatomic, strong) RACSignal *signalSubmit;
@property (nonatomic, strong) RACSignal *signalForgetPassword;

@end
