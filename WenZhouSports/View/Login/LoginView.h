//
//  LoginNewView.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/2.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginTextView.h"

@interface LoginView : UIView

@property (nonatomic, strong) RACSignal *signalSubmit;
@property (nonatomic, strong) RACSignal *signalForgetPassword;
@property (nonatomic, strong) RACSignal *signalDidBeginEditing;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

@property (nonatomic, strong) LoginTextView *txtUniversityName;
@property (nonatomic, strong) LoginTextView *txtUserName;
@property (nonatomic, strong) LoginTextView *txtPassword;

@end
