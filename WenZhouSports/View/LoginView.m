//
//  LoginView.m
//  WenZhouSports
//
//  Created by 何聪 on 2017/5/2.
//  Copyright © 2017年 何聪. All rights reserved.
//

#import "LoginView.h"
#import "LineTextField.h"

@interface LoginView () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *accountLabel;
@property (nonatomic, strong) LineTextField *accountTextField;
@property (nonatomic, strong) UILabel *passwordLabel;
@property (nonatomic, strong) LineTextField *passwordTextField;
@property (nonatomic, strong) UIButton *showPasswordButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *forgetPasswordButton;

@property (nonatomic, strong) RACSignal *loginSignal;
@property (nonatomic, strong) RACSignal *forgetPasswordSignal;
@property (nonatomic, strong) RACSignal *beginEditSignal;
@property (nonatomic, strong) RACSignal *endEditSignal;
@property (nonatomic, strong) RACSignal *showPasswordSignal;

@end

@implementation LoginView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = C_66A7FE;
        [self initSubviews];
        [self makeConstraints];
        [self reactiveEvent];
    }
    return self;
}

- (void)initSubviews {
    _accountLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"学号";
        lab.textColor = [UIColor whiteColor];
        lab.font = S15;
        
        lab;
    });
    _accountTextField = ({
        LineTextField *text = [[LineTextField alloc] init];
        text.layer.borderColor = [UIColor whiteColor].CGColor;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"请输入您的学号"];
        NSDictionary *dic = @{NSFontAttributeName:S12,
                              NSForegroundColorAttributeName:[UIColor whiteColor]};
        text.keyboardType = UIKeyboardTypeNumberPad;
        [attributedString addAttributes:dic range:NSMakeRange(0, 7)];
        text.attributedPlaceholder = attributedString;
        text.delegate = self;
        
        text;
    });
    _passwordLabel = ({
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"密码";
        lab.textColor = [UIColor whiteColor];
        lab.font = S15;
        
        lab;
    });
    _passwordTextField = ({
        LineTextField *text = [[LineTextField alloc] init];
        text.layer.borderColor = [UIColor whiteColor].CGColor;
        text.secureTextEntry = YES;
        text.clearsOnBeginEditing = YES;
        text.delegate = self;
        NSString *string = @"请输入6-16位密码";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        NSDictionary *dic = @{NSFontAttributeName:S12,
                              NSForegroundColorAttributeName:[UIColor whiteColor]};
        [attributedString addAttributes:dic range:NSMakeRange(0, string.length)];
        text.attributedPlaceholder = attributedString;
        
        text;
    });
    _showPasswordButton = ({
        UIButton *btn = [[UIButton alloc] init];
        _showPasswordSignal = [btn rac_signalForControlEvents:UIControlEventTouchDown];
        [btn setImage:[UIImage imageNamed:@"btn_eye_normal"] forState:UIControlStateNormal];
        
        btn;
    });
    _loginButton = ({
        UIButton *btn = [[UIButton alloc] init];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_Login_White"] forState:UIControlStateNormal];
        [btn setTitle:@"登录" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:S16];
        _loginSignal = [btn rac_signalForControlEvents:UIControlEventTouchDown];
        
        btn;
    });
    _forgetPasswordButton = ({
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [btn.titleLabel setTextColor: [UIColor whiteColor]];
        [btn.titleLabel setFont:S12];
        _forgetPasswordSignal = [btn rac_signalForControlEvents:UIControlEventTouchDown];
        
        btn;
    });
    
    [self addSubviews:@[_accountLabel, _accountTextField, _passwordTextField,
                        _passwordLabel, _loginButton, _forgetPasswordButton, _showPasswordButton]];
}

- (void)makeConstraints {
    [_accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(FIT_LENGTH(285.0));
        make.left.equalTo(self).offset(MARGIN_SCREEN);
    }];
    [_accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(WIDTH - FIT_LENGTH(36.0), FIT_LENGTH(34.0)));
        make.centerX.equalTo(self);
        make.top.equalTo(_accountLabel.mas_bottom);
    }];
    [_passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_accountTextField.mas_bottom).offset(26.0);
        make.left.equalTo(self).offset(MARGIN_SCREEN);
    }];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_accountTextField);
        make.centerX.equalTo(self);
        make.top.equalTo(_passwordLabel.mas_bottom);
    }];
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-FIT_LENGTH(72.0));
    }];
    [_forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginButton.mas_bottom).offset(FIT_LENGTH(13.0));
        make.centerX.equalTo(self);
    }];
    [_showPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-MARGIN_SCREEN);
        make.centerY.equalTo(_passwordTextField);
    }];
}

- (void)reactiveEvent {
    _beginEditSignal = [[_accountTextField rac_signalForControlEvents:UIControlEventEditingDidBegin] merge:[_passwordTextField rac_signalForControlEvents:UIControlEventEditingDidBegin]];
    @weakify(self);
    [_beginEditSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [_accountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(FIT_LENGTH(89.0));
        }];
        [_loginButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-FIT_LENGTH(338.0));
        }];
    }];
    _endEditSignal = [[_accountTextField rac_signalForControlEvents:UIControlEventEditingDidEnd] merge:[_passwordTextField rac_signalForControlEvents:UIControlEventEditingDidEnd]];
    [_endEditSignal subscribeNext:^(id x) {
        @strongify(self)
        [_accountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(FIT_LENGTH(221.0));
        }];
        [_loginButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-FIT_LENGTH(77.0));
        }];
    }];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [[tapGesture rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        [self endEditing:YES];
    }];
    [self addGestureRecognizer:tapGesture];
    [self.showPasswordSignal subscribeNext:^(id  _Nullable x) {
       @strongify(self)
        if (self.passwordTextField.secureTextEntry) {
            [self.showPasswordButton setImage:[UIImage imageNamed:@"btn_eye_select"] forState:UIControlStateNormal];
            self.passwordTextField.secureTextEntry = NO;
        } else {
            [self.showPasswordButton setImage:[UIImage imageNamed:@"btn_eye_normal"] forState:UIControlStateNormal];
            self.passwordTextField.secureTextEntry = YES;
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

@end
