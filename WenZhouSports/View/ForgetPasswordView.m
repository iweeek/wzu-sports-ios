//
//  ForgetPasswordView.m
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/4.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "ForgetPasswordView.h"
#import "LineTextField.h"

@interface ForgetPasswordView ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) LineTextField *textView;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIButton *showPasswordButton;

@property (nonatomic, strong) RACSignal *nextSignal;
@property (nonatomic, strong) RACSignal *showPasswordSignal;

@end

@implementation ForgetPasswordView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = C_66A7FE;
        [self initSubviews];
        [self makeConstraints];
        [self setLabel:@"手机号" textView:@"请输入您的手机号" button:@"获取验证码"];
        [self reactiveEvent];
    }
    return self;
}

- (void)initSubviews {
    _label = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.font = S14;
        lab.textColor = [UIColor whiteColor];
        
        lab;
    });
    _textView = ({
        LineTextField *text = [[LineTextField alloc] init];
        
        text;
    });
    _nextButton = ({
        UIButton *btn = [[UIButton alloc] init];
        [btn.titleLabel setFont:S16];
        _nextSignal = [btn rac_signalForControlEvents:UIControlEventTouchDown];
        
        btn;
    });
    _showPasswordButton = ({
        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:[UIImage imageNamed:@"btn_eye_normal"] forState:UIControlStateNormal];
        _showPasswordSignal = [btn rac_signalForControlEvents:UIControlEventTouchDown];
        [btn setHidden:YES];
        
        btn;
    });
    [self addSubviews:@[_label, _textView, _nextButton, _showPasswordButton]];

}

- (void)makeConstraints {
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(FIT_LENGTH(92));
        make.left.equalTo(self).offset(MARGIN_SCREEN);
    }];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_label.mas_bottom).offset(FIT_LENGTH(2.0));
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(WIDTH - 2 * MARGIN_SCREEN, FIT_LENGTH(34.0)));
    }];
    [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textView.mas_bottom).offset(FIT_LENGTH(28.0));
        make.size.mas_equalTo(CGSizeMake(WIDTH - 2 * MARGIN_SCREEN, FIT_LENGTH(43.0)));
        make.centerX.equalTo(self);
    }];
    [_showPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-MARGIN_SCREEN);
        make.centerY.equalTo(_textView);
        make.size.mas_equalTo(CGSizeMake(FIT_LENGTH(42.0), FIT_LENGTH(20.0)));
    }];
}

- (void)setLabel: (NSString *)text
        textView: (NSString *)placeholder
          button: (NSString *)title {
    _label.text = text;
    _textView.text = @"";
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:placeholder];
    [attribute addAttribute:NSFontAttributeName value:S12 range:NSMakeRange(0, placeholder.length)];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, placeholder.length)];
    _textView.attributedPlaceholder = attribute;
    [_nextButton setTitle:title forState:UIControlStateNormal];
}

- (void)setShowPassword: (BOOL)isShowPassword {
    [_showPasswordButton setHidden: !isShowPassword];
    _textView.secureTextEntry = YES;
}

- (void)reactiveEvent {
    @weakify(self);
    [self.showPasswordSignal subscribeNext:^(id x) {
        @strongify(self)
        if (self.textView.secureTextEntry) {
            [self.showPasswordButton setImage:[UIImage imageNamed:@"btn_eye_select"] forState:UIControlStateNormal];
            self.textView.secureTextEntry = NO;
        } else {
            [self.showPasswordButton setImage:[UIImage imageNamed:@"btn_eye_normal"] forState:UIControlStateNormal];
            self.textView.secureTextEntry = YES;
        }
    }];
}

- (NSString *)getStringOfTextField {
    return _textView.text;
}

@end
