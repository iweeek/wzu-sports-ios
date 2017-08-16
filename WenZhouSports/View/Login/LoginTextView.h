//
//  LoginTextView.h
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/2.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginTextView : UIView

@property (nonatomic, strong) RACSignal *signalDidBeginEditing;
@property (nonatomic, strong) RACSignal *signalTextChanged;

- (void)initWithTitle:(NSString *)title
          placeholder:(NSString *)placeholder
                 hint:(NSString *)hint
         showClearBtn:(BOOL)showClearBtn;

- (void)setSecureTextEntry:(BOOL)secureTextEntry
                showEyeBtn:(BOOL)showEyeBtn;

- (void)setHint:(NSString *)Hint
       showHint:(BOOL)showHint;

- (void)changeTextEnabled:(BOOL)enabled;

- (void)setText:(NSString *)text;

@end
