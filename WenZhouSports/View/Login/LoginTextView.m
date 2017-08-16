//
//  LoginTextView.m
//  WenZhouSports
//
//  Created by 郭佳 on 2017/6/2.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "LoginTextView.h"
#import "LineTextField.h"

@interface LoginTextView () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UITextField *txt;
@property (nonatomic, strong) UIView *spliteLine;
@property (nonatomic, strong) UILabel *labHint;
@property (nonatomic, strong) UIButton *btnClear;
@property (nonatomic, strong) UIButton *btnShowPassword;

@end

@implementation LoginTextView

- (void)initWithTitle:(NSString *)title
          placeholder:(NSString *)placeholder
                 hint:(NSString *)hint
         showClearBtn:(BOOL)showClearBtn {
    self.labTitle.text = title;
    self.labHint.text = hint;
    
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:placeholder];
    [attribute addAttribute:NSFontAttributeName value:S12 range:NSMakeRange(0, placeholder.length)];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, placeholder.length)];
    self.txt.attributedPlaceholder = attribute;
    self.btnClear.hidden = !showClearBtn;
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry
                showEyeBtn:(BOOL)showEyeBtn {
    self.txt.secureTextEntry = secureTextEntry;
    self.btnShowPassword.hidden = !showEyeBtn;
}

- (void)setHint:(NSString *)Hint
       showHint:(BOOL)showHint {
    self.labHint.text = Hint;
    self.labHint.hidden = !showHint;
}

- (void)changeTextEnabled:(BOOL)enabled {
    self.txt.enabled = enabled;
}

- (void)setText:(NSString *)text {
    self.txt.text = text;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self createUI];
        [self layout];
    }
    return self;
}

- (void)createUI {
    [self addSubview:self.labTitle];
    [self addSubview:self.txt];
    [self addSubview:self.labHint];
    [self addSubview:self.spliteLine];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [self addGestureRecognizer:tap];
    self.signalDidBeginEditing = [tap rac_gestureSignal];
}

- (void)layout {
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    [self.txt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labTitle.mas_bottom).offset(7);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    [self.spliteLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.txt.mas_bottom).offset(10);
        make.left.mas_equalTo(self.txt);
        make.right.mas_equalTo(self.txt);
        make.height.mas_equalTo(1);
    }];
    [self.labHint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.spliteLine.mas_bottom).offset(2);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.font = S15;
        _labTitle.numberOfLines = 0;
        _labTitle.textColor = cFFFFFF;
        _labTitle.text = @"用户名";
    }
    return _labTitle;
}

- (UITextField *)txt {
    if (!_txt) {
        _txt = [[UITextField alloc] init];
        _txt.textColor = cFFFFFF;
        _txt.font = S13;
        _txt.tintColor = cFFFFFF;// 改变光标颜色
//        _txt.delegate = self;
        self.signalTextChanged = [_txt rac_signalForControlEvents:UIControlEventEditingChanged];
        
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 46, 35)];

        self.btnClear = [[UIButton alloc] init];
        [self.btnClear setImage:[UIImage imageNamed:@"btn_clear"] forState:UIControlStateNormal];
        @weakify(self);
        [[self.btnClear rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            self.txt.text = @"";
        }];
        
        self.btnShowPassword = [[UIButton alloc] init];
        self.btnShowPassword.hidden = YES;
        [self.btnShowPassword setBackgroundImage:[UIImage imageNamed:@"btn_eye_select"] forState:UIControlStateNormal];
        [self.btnShowPassword setBackgroundImage:[UIImage imageNamed:@"btn_eye_normal"] forState:UIControlStateSelected];
        [[self.btnShowPassword rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
            @strongify(self);
            x.selected = !x.isSelected;
            if (x.isSelected) { // 显示明文
                self.txt.secureTextEntry = NO;
                [x mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(0);
                    make.centerY.mas_equalTo(0);
                    make.size.mas_equalTo(CGSizeMake(19, 9));
                }];
            } else {
                self.txt.secureTextEntry = YES;
                [x mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(0);
                    make.centerY.mas_equalTo(0);
                    make.size.mas_equalTo(CGSizeMake(19, 14));
                }];
            }

        }];
        
        [rightView addSubview:self.btnClear];
        [rightView addSubview:self.btnShowPassword];
        
        [self.btnShowPassword mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(19, 14));
        }];
        [self.btnClear mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.btnShowPassword.mas_left).offset(-7);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];

        _txt.rightView = rightView;
        _txt.rightViewMode = UITextFieldViewModeAlways;
    }
    return _txt;
}

- (UILabel *)labHint {
    if (!_labHint) {
        _labHint = [[UILabel alloc] init];
        _labHint.font = S12;
        _labHint.numberOfLines = 0;
        _labHint.textColor = c57FFDA;
        _labHint.hidden = YES;
        _labHint.text = @"请输入密码";
    }
    return _labHint;
}

- (UIView *)spliteLine {
    if (!_spliteLine) {
        _spliteLine = [[UIView alloc] init];
        _spliteLine.backgroundColor = cFFFFFF;
    }
    return _spliteLine;
}


@end
