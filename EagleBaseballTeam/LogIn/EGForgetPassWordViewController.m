//
//  EGForgetPassWordViewController.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/12.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGForgetPassWordViewController.h"

#import "EGLogInTools.h"

@interface EGForgetPassWordViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UIView *phoneView;
@property (nonatomic,strong) UITextField *phoneTextField;
@property (nonatomic,strong) UITextField *codeTextField;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong) UILabel *errorLb;
@property (nonatomic,strong) UILabel *timeLb;


@property (nonatomic,strong) UIView *pswdView;
@property (nonatomic,strong) UITextField *pswdTextField;
@property (nonatomic,strong) UITextField *againTextField;


@property (nonatomic,strong) NSTimer *countDownTime;
@property (nonatomic,assign) NSInteger secondsCountDown;

@property (nonatomic,strong) UIButton *sureBtn;
@end

@implementation EGForgetPassWordViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
//    self.navigationItem.title = @"忘記密碼";
    
    [self createPhoneUI];
    
    UIButton *sureBtn = [[UIButton alloc] init];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
    [sureBtn setTitle:@"確定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [sureBtn setTitleColor:rgba(163, 163, 163, 1) forState:UIControlStateDisabled];
    sureBtn.backgroundColor = rgba(0, 78, 162, 1);
    [sureBtn addTarget:self action:@selector(bottomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.titleEdgeInsets = UIEdgeInsetsMake(-ScaleW(25), 0, 0, 0); // 文字往上偏移 10 點
    [sureBtn sizeToFit];
    [self.view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(ScaleW(48)+[UIDevice de_safeDistanceBottom]);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    [sureBtn setBackgroundImage:[UIImage imageWithColor:rgba(243, 243, 243, 1)] forState:UIControlStateDisabled];
    [sureBtn setBackgroundImage:[UIImage imageWithColor:rgba(0, 122, 96, 1)] forState:UIControlStateNormal];
    self.sureBtn = sureBtn;
    self.sureBtn.enabled = false;
}

-(void)bottomButtonAction:(UIButton *)button
{
    if (self.phoneView) {
        [self.phoneView removeFromSuperview];
        self.phoneView = nil;
        self.sureBtn.enabled = false;
        [self createPasswordUI];
    }else{
        
        if (![self.pswdTextField.text isEqualToString:self.againTextField.text]) {
            [MBProgressHUD showDelayHidenMessage:@"兩次輸入的密碼不相符，請重新確認"];
            return;
        }
        BOOL isOK = [EGLogInTools isValidPswdString:self.pswdTextField.text];
        if (isOK) {
            WS(weakSelf);
            EGUserOauthModel *model = [EGLoginUserManager getOauthDataModel];
            NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
            NSDictionary *dict_header = @{@"Authorization":tokenString};
            NSDictionary *dict_body = @{@"otp":self.codeTextField.text,@"password":self.pswdTextField.text,@"phone":self.phoneTextField.text};
            [[WAFNWHTTPSTool sharedManager] postWithURL:[EGServerAPI forgotPassword_api] parameters:dict_body headers:dict_header success:^(NSDictionary * _Nonnull response) {
                    
                [MBProgressHUD showDelayHidenMessage:@"修改成功，前往登入"];
                [weakSelf.navigationController popViewControllerAnimated:true];
                
                } failure:^(NSError * _Nonnull error) {
                    if (error) {
                        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                        if (errorData) {
                            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:&error];
                            NSString *message = dictionary[@"message"];
                            [[EGAlertViewHelper sharedManager] alertViewColor:1 message:message];
                        }
                    }
                }];
        }
    }
}
-(void)createPhoneUI
{
    UIView *phoneView = [[UIView alloc] init];
    [self.view addSubview:phoneView];
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([UIDevice de_navigationFullHeight]);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(Device_Width);
    }];
    self.phoneView = phoneView;
    UILabel *titleLb = [UILabel new];
    titleLb.text = @"輸入您的手機號碼，驗證碼將會傳送到您的手機。";
    titleLb.numberOfLines = 0;
    titleLb.textColor = rgba(23, 23, 23, 1);
    titleLb.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
    [phoneView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(30));
        make.left.mas_equalTo(ScaleW(24));
        make.right.mas_equalTo(-ScaleW(24));
    }];
    
    UITextField *phoneTextField = [UITextField new];
    phoneTextField.layer.cornerRadius = ScaleW(8);
    phoneTextField.layer.masksToBounds = true;
    phoneTextField.layer.borderWidth = 1;
    phoneTextField.layer.borderColor = rgba(163, 163, 163, 1).CGColor;
    phoneTextField.borderStyle = UITextBorderStyleRoundedRect;
    phoneTextField.font = [UIFont systemFontOfSize:FontSize(14)];
    phoneTextField.returnKeyType = UIReturnKeyNext;
    phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    phoneTextField.delegate = self;
    phoneTextField.placeholder = @"請輸入手機";
    [phoneView addSubview:phoneTextField];
    [phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(24));
        make.top.mas_equalTo(titleLb.mas_bottom).offset(ScaleW(20));
        make.height.mas_equalTo(ScaleW(45));
        make.right.mas_equalTo(-ScaleW(24));
    }];
    self.phoneTextField = phoneTextField;
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.layer.cornerRadius = ScaleW(14);
    rightBtn.layer.masksToBounds = true;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
    [rightBtn setTitle:@"  發送驗證碼  " forState:UIControlStateNormal];
    [rightBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [rightBtn setTitleColor:rgba(163, 163, 163, 1) forState:UIControlStateDisabled];
    rightBtn.backgroundColor = rgba(243, 243, 243, 1);
    [rightBtn addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [phoneView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(phoneTextField);
        make.height.mas_equalTo(ScaleW(28));
        make.right.mas_equalTo(-ScaleW(40));
    }];
    [rightBtn setBackgroundImage:[UIImage imageWithColor:rgba(243, 243, 243, 1)] forState:UIControlStateDisabled];
    [rightBtn setBackgroundImage:[UIImage imageWithColor:rgba(0, 78, 162, 1)] forState:UIControlStateNormal];
    self.rightBtn = rightBtn;
    
    UILabel *errorLb = [UILabel new];
    errorLb.text = @"請輸入正確格式";
    errorLb.textColor = rgba(220, 38, 38, 1);
    errorLb.font = [UIFont systemFontOfSize:FontSize(12) weight:UIFontWeightRegular];
    [phoneView addSubview:errorLb];
    [errorLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneTextField.mas_bottom).offset(ScaleW(8));
        make.left.mas_equalTo(ScaleW(24));
        make.right.mas_equalTo(-ScaleW(24));
    }];
    self.errorLb = errorLb;
    self.errorLb.hidden = true;
    
    
    UITextField *codeTextField = [UITextField new];
    codeTextField.borderStyle = UITextBorderStyleRoundedRect;
    codeTextField.font = [UIFont systemFontOfSize:FontSize(14)];
    codeTextField.returnKeyType = UIReturnKeyNext;
//    codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    codeTextField.delegate = self;
    codeTextField.placeholder = @"請輸入驗證碼";
    [phoneView addSubview:codeTextField];
    [codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(24));
        make.top.mas_equalTo(phoneTextField.mas_bottom).offset(ScaleW(40));
        make.height.mas_equalTo(ScaleW(45));
        make.right.mas_equalTo(-ScaleW(24));
    }];
    self.codeTextField = codeTextField;
    UILabel *timeLb = [UILabel new];
    timeLb.textColor = rgba(220, 38, 38, 1);
    timeLb.font = [UIFont systemFontOfSize:FontSize(12) weight:UIFontWeightRegular];
    [phoneView addSubview:timeLb];
    [timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeTextField.mas_bottom).offset(ScaleW(8));
        make.left.mas_equalTo(ScaleW(24));
        make.right.mas_equalTo(-ScaleW(24));
    }];
    self.timeLb = timeLb;

}

#pragma mark ---
-(void)rightButtonAction:(UIButton *)sender
{
    NSString *phoneNumber = self.phoneTextField.text;
    BOOL isValid = [EGLogInTools isValidTaiwanMobileNumber:phoneNumber];
    if (!isValid) {
        self.errorLb.hidden = false;
        self.phoneTextField.layer.borderColor = rgba(220, 38, 38, 1).CGColor;
        return;
    }
    
    WS(weakSelf);
    EGUserOauthModel *model = [EGLoginUserManager getOauthDataModel];
    
    if (!model) {
        //为空直接取
        [[EGetTokenViewModel sharedManager] getAuthForOnlyOneCRM:^(BOOL success) {
            if (success) {
                EGUserOauthModel *model2 = [EGLoginUserManager getOauthDataModel];
                [weakSelf sendMessage:model2];
            }
        }];
        
    
    }else{
        // 不为空判断一下
        if (!model.accessToken || [model.accessToken isEqualToString:@""]) {
            [[EGetTokenViewModel sharedManager] getAuthForOnlyOneCRM:^(BOOL success) {
                if (success) {
                    EGUserOauthModel *model2 = [EGLoginUserManager getOauthDataModel];
                    [weakSelf sendMessage:model2];
                }
            }];
        }else{
            [weakSelf sendMessage:model];
        }
    }

}

-(void) sendMessage:(EGUserOauthModel *)model{
    
    WS(weakSelf);
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
    NSDictionary *dict_header = @{@"Authorization":tokenString};
    NSString *phoneNumber = self.phoneTextField.text;
    
    [[WAFNWHTTPSTool sharedManager] postWithURL:[EGServerAPI otpSms_api] parameters:@{@"phone":phoneNumber,@"type": @"forgotPassword"} headers:dict_header success:^(NSDictionary * _Nonnull response) {
              
          weakSelf.rightBtn.enabled = false;
          weakSelf.secondsCountDown = 300;
          weakSelf.countDownTime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
          
          } failure:^(NSError * _Nonnull error) {
              NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
              if (errorData) {
                  NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:&error];
                  NSString *message = dictionary[@"message"];
                  [[EGAlertViewHelper sharedManager] alertViewColor:1 message:message];
              }
          }];
}

- (void)timeFireMethod
{
    if (self.secondsCountDown > 0) {
        self.secondsCountDown--;
        NSString *timeStr = [EGLogInTools formatTimeFromSeconds:self.secondsCountDown];
        self.timeLb.text = timeStr;
    }else{
        self.rightBtn.enabled = true;
        self.timeLb.text = @"";
        [self.countDownTime invalidate];
        self.countDownTime = nil;
    }
}

#pragma mark ---textFieldDelagate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.phoneView) {
        if ([textField isEqual:self.phoneTextField]) {
            self.errorLb.hidden = true;
            self.phoneTextField.layer.borderColor = rgba(163, 163, 163, 1).CGColor;
            
        }
        
        if ([self.phoneTextField isEqual:textField] && textField.text.length >= 10 && string.length > 0) {
            textField.text = [textField.text substringToIndex:10];
            [textField resignFirstResponder];
        }
        
        if ([self.codeTextField isEqual:textField] && textField.text.length > 8 && string.length > 0) {
            textField.text = [textField.text substringToIndex:8];
            [textField resignFirstResponder];
        }
        
        if (self.codeTextField.text.length >= 3 && self.phoneTextField.text.length >= 10) {
            
            self.sureBtn.enabled = true;
        }else{
            self.sureBtn.enabled = false;
        }
    }
    
    if (self.pswdView) {
        
        if ([self.pswdTextField isEqual:textField] && textField.text.length >= 20 && string.length > 0) {
            textField.text = [textField.text substringToIndex:20];
            [textField resignFirstResponder];
        }
        
        if ([self.againTextField isEqual:textField] && textField.text.length >= 20 && string.length > 0) {
            textField.text = [textField.text substringToIndex:20];
            [textField resignFirstResponder];
        }
    }
    
    
    return true;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.phoneView) {
        if (self.codeTextField.text.length >= 4 && self.phoneTextField.text.length >= 10) {
            self.sureBtn.enabled = true;
        }else{
            self.sureBtn.enabled = false;
        }
    }
    
    if (self.pswdView) {
        if (self.pswdTextField.text.length >= 8 && self.againTextField.text.length >= 8) {
            self.sureBtn.enabled = true;
        }else{
            self.sureBtn.enabled = false;
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)createPasswordUI
{
    UIView *phoneView = [[UIView alloc] init];
    [self.view addSubview:phoneView];
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([UIDevice de_navigationFullHeight]);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(Device_Width);
    }];
    self.pswdView = phoneView;
    UILabel *titleLb = [UILabel new];
    titleLb.text = @"輸入您的新密碼，密碼限 8~20 個字元，必須包含至少一個英文字母及數字。";
    titleLb.numberOfLines = 0;
    titleLb.textColor = rgba(23, 23, 23, 1);
    titleLb.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
    [phoneView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(30));
        make.left.mas_equalTo(ScaleW(24));
        make.right.mas_equalTo(-ScaleW(24));
    }];
    
    UITextField *pswdTextField = [UITextField new];
    pswdTextField.borderStyle = UITextBorderStyleRoundedRect;
    pswdTextField.font = [UIFont systemFontOfSize:FontSize(14)];
    pswdTextField.returnKeyType = UIReturnKeyNext;
//    phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    pswdTextField.delegate = self;
    pswdTextField.placeholder = @"請輸入新密碼";
    pswdTextField.secureTextEntry = YES;
    [phoneView addSubview:pswdTextField];
    [pswdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(24));
        make.top.mas_equalTo(titleLb.mas_bottom).offset(ScaleW(20));
        make.height.mas_equalTo(ScaleW(45));
        make.right.mas_equalTo(-ScaleW(24));
    }];
    self.pswdTextField = pswdTextField;
    UIButton *eyeBtn = [[UIButton alloc] init];
    [eyeBtn setImage:[UIImage imageNamed:@"eye-slash"] forState:UIControlStateNormal];
    [eyeBtn setImage:[UIImage imageNamed:@"showPswd"] forState:UIControlStateSelected];
    [eyeBtn addTarget:self action:@selector(eyeBtnSelecteState:) forControlEvents:UIControlEventTouchUpInside];
    [phoneView addSubview:eyeBtn];
    [eyeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(pswdTextField);
        make.height.mas_equalTo(ScaleW(28));
        make.right.mas_equalTo(-ScaleW(40));
    }];
    eyeBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -20, -10, -20);
    
    
    UITextField *againTextField = [UITextField new];
    againTextField.borderStyle = UITextBorderStyleRoundedRect;
    againTextField.font = [UIFont systemFontOfSize:FontSize(14)];
    againTextField.returnKeyType = UIReturnKeyNext;
//    codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    againTextField.delegate = self;
    againTextField.placeholder = @"請再次輸入相同密碼";
    againTextField.secureTextEntry = YES;
    [phoneView addSubview:againTextField];
    [againTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(24));
        make.top.mas_equalTo(pswdTextField.mas_bottom).offset(ScaleW(20));
        make.height.mas_equalTo(ScaleW(45));
        make.right.mas_equalTo(-ScaleW(24));
    }];
    self.againTextField = againTextField;
    UIButton *againEyeBtn = [[UIButton alloc] init];
    [againEyeBtn setImage:[UIImage imageNamed:@"eye-slash"] forState:UIControlStateNormal];
    [againEyeBtn setImage:[UIImage imageNamed:@"showPswd"] forState:UIControlStateSelected];
    [againEyeBtn addTarget:self action:@selector(eyeAgainBtnSelecteState:) forControlEvents:UIControlEventTouchUpInside];
    [phoneView addSubview:againEyeBtn];
    [againEyeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(againTextField);
        make.height.mas_equalTo(ScaleW(28));
        make.right.mas_equalTo(-ScaleW(40));
    }];
    againEyeBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -20, -10, -20);
}

#pragma mark ===== 密码show hidden
-(void)eyeBtnSelecteState:(UIButton *)button
{
    button.selected = !button.selected;
    
    if (button.selected) {
        self.pswdTextField.secureTextEntry = NO;
    }else{
        self.pswdTextField.secureTextEntry = YES;
    }
}
-(void)eyeAgainBtnSelecteState:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        self.againTextField.secureTextEntry = NO;
    }else{
        self.againTextField.secureTextEntry = YES;
    }
}

@end
