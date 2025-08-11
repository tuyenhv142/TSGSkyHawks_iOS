//
//  EGLogInViewController.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/7.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGLogInViewController.h"

#import "EGLogInTools.h"
#import "EGRegisterViewController.h"
#import "EGForgetPassWordViewController.h"
#import "LXYHyperlinksButton.h"
#import "EGPolicyViewController.h"

@interface EGLogInViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *pswdTextField;
@property (nonatomic,strong) UITextField *accountTextField;

@property (nonatomic,strong) UIButton *rememberBtn;
@property (nonatomic,strong) UIButton *logInBtn;

@end

@implementation EGLogInViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = true;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = false;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = rgba(0, 71, 56, 1);
    
    [self createUI];
    
//    [self checkAppVersion];
}


-(void)checkAppVersion
{
    [[EGetTokenViewModel sharedManager] getAppStoreVersionWithAppID:STOREAPPID completion:^(NSString *appStoreVersion, NSError *error) {
        if (error) {
//            ELog(@"获取App Store版本失败: %@", error.localizedDescription);
        } else {
//            ELog(@"App Store上的版本号: %@", appStoreVersion);
            // 获取当前安装的版本号
            NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
            if ([appStoreVersion compare:currentVersion options:NSNumericSearch] == NSOrderedDescending) {

                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *message = [NSString stringWithFormat:@"台鋼天鷹已推出新版%@\n前往更新，以獲得最佳使用體驗",appStoreVersion];
                    [ELAlertController alertControllerWithTitleName:@"發現新版本" andMessage:message cancelButtonTitle:nil confirmButtonTitle:@"立即更新" showViewController:self addCancelClickBlock:^(UIAlertAction * _Nonnull cancelAction) {
                    } addConfirmClickBlock:^(UIAlertAction * _Nonnull SureAction) {

                        NSString *appStoreStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", STOREAPPID];
                        NSURL *appStoreURL = [NSURL URLWithString:appStoreStr];
                        [[UIApplication sharedApplication] openURL:appStoreURL options:@{} completionHandler:^(BOOL success) {
                            if (!success) {
                                [[UIApplication sharedApplication] openURL:appStoreURL options:@{} completionHandler:nil];
                            }
                        }];

                    }];
                });

            }
        }
    }];
}


    
-(void)closeLoginViewButton
{
    [self dismissViewControllerAnimated:true completion:^{
    }];
}

-(void)createUI
{
//    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:scrollview];
    
    UIView *scrollview = self.view;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, ScaleH(280))];
    [scrollview addSubview:topView];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    gradientLayer.frame = topView.bounds;
    gradientLayer.colors = @[(id)rgba(16, 38, 73, 1).CGColor,(id)rgba(0, 121, 192, 1).CGColor];
    [topView.layer insertSublayer:gradientLayer atIndex:0];
    
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"台鋼雄鷹Logo"];
    [topView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(ScaleW(139));
        make.height.mas_equalTo(ScaleW(147));
    }];
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [closeBtn setImage:[UIImage imageNamed:@"x-mark"] forState:UIControlStateNormal];
    [closeBtn setTitle:@"關閉" forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeLoginViewButton) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([UIDevice de_safeDistanceTop]);
        make.right.mas_equalTo(-ScaleW(20));
//        make.width.height.mas_equalTo(ScaleW(20));
    }];
    closeBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -50, -50, -10);
    
    UILabel *titleLb = [UILabel new];
//    titleLb.text = @"TSG HAWKS ";
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.textColor = UIColor.whiteColor;
    titleLb.font = [UIFont boldSystemFontOfSize:FontSize(16)];
    [topView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(10));
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
#pragma mark --- bottomView
    UIView *bottomView = [UIView new];
    bottomView.frame = CGRectMake(0, ScaleH(240), Device_Width, Device_Height - ScaleH(240));
    bottomView.layer.cornerRadius = ScaleW(28);
    bottomView.layer.masksToBounds = YES;
    bottomView.backgroundColor = [UIColor whiteColor];
    [scrollview addSubview:bottomView];
//    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(0);
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.top.equalTo(topView.mas_bottom).offset(-ScaleH(40));
//    }];
    UILabel *weComeLB = [UILabel new];
    weComeLB.text = @"歡迎登入";
    weComeLB.textAlignment = NSTextAlignmentCenter;
    weComeLB.textColor = rgba(0, 78, 162, 1);
    weComeLB.font = [UIFont boldSystemFontOfSize:FontSize(18)];
    [bottomView addSubview:weComeLB];
    [weComeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleH(30));
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    NSDictionary *dict = [kUserDefaults objectForKey:@"remberLogIn"];
    CGFloat leftManger = ScaleW(24);
    
    UILabel *accountLB = [[UILabel alloc] init];
    accountLB.textColor = rgba(64, 64, 64, 1);
    accountLB.textAlignment = NSTextAlignmentLeft;
    accountLB.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
    accountLB.text = @"帳號";
    [bottomView addSubview:accountLB];
    [accountLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftManger);
        make.top.mas_equalTo(weComeLB.mas_bottom).offset(ScaleW(30));
        make.right.mas_equalTo(-leftManger);
    }];
    UITextField *accountTextField = [UITextField new];
    accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    accountTextField.tag = 1;
    accountTextField.borderStyle = UITextBorderStyleRoundedRect;
    if ([[dict allKeys] containsObject:@"account"])
    {
        accountTextField.text = [dict objectForKey:@"account"];
    }
    accountTextField.font = [UIFont systemFontOfSize:FontSize(14)];
    accountTextField.returnKeyType = UIReturnKeyNext;
    accountTextField.keyboardType = UIKeyboardTypePhonePad;
    accountTextField.delegate = self;
    accountTextField.placeholder = @"請輸入手機";
    [bottomView addSubview:accountTextField];
    [accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftManger);
        make.top.mas_equalTo(accountLB.mas_bottom).offset(ScaleW(8));
        make.height.mas_equalTo(ScaleH(40));
        make.right.mas_equalTo(-leftManger);
    }];
    self.accountTextField = accountTextField;
    
    
    UILabel *pswdLB = [[UILabel alloc] init];
    pswdLB.textColor = rgba(64, 64, 64, 1);
    pswdLB.textAlignment = NSTextAlignmentLeft;
    pswdLB.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
    pswdLB.text = @"密碼";
    [bottomView addSubview:pswdLB];
    [pswdLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftManger);
        make.top.mas_equalTo(accountTextField.mas_bottom).offset(ScaleW(20));
        make.right.mas_equalTo(-leftManger);
    }];
    UITextField *pswdLBTextField = [UITextField new];
    pswdLBTextField.tag = 2;
    pswdLBTextField.borderStyle = UITextBorderStyleRoundedRect;
    if ([[dict allKeys] containsObject:@"pswd"])
    {
        pswdLBTextField.text = [dict objectForKey:@"pswd"];
    }
    pswdLBTextField.font = [UIFont systemFontOfSize:FontSize(14)];
    pswdLBTextField.returnKeyType = UIReturnKeyNext;
//    pswdLBTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    pswdLBTextField.textContentType = UITextContentTypeOneTimeCode;
    pswdLBTextField.delegate = self;
    pswdLBTextField.placeholder = @"請輸入密碼";
    pswdLBTextField.secureTextEntry = YES;
    [bottomView addSubview:pswdLBTextField];
    [pswdLBTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftManger);
        make.top.mas_equalTo(pswdLB.mas_bottom).offset(ScaleW(8));
        make.height.mas_equalTo(ScaleH(40));
        make.right.mas_equalTo(-leftManger);
    }];
    self.pswdTextField = pswdLBTextField;
    
    UIButton *eyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [eyeBtn setImage:[UIImage imageNamed:@"eye-slash"] forState:UIControlStateNormal];
    [eyeBtn setImage:[UIImage imageNamed:@"showPswd"] forState:UIControlStateSelected];
    [eyeBtn addTarget:self action:@selector(eyeBtnSelecteState:) forControlEvents:UIControlEventTouchUpInside];
    eyeBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-20, -40, -20, -20);
    [bottomView addSubview:eyeBtn];
    [eyeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(pswdLBTextField);
        make.right.mas_equalTo(-ScaleW(leftManger+10));
        make.width.height.mas_equalTo(ScaleW(20));
    }];
    
#pragma mark ---- 记住账号密码
    UIButton *rememberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rememberBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-5, -5, -5, -50);
    [rememberBtn setImage:[UIImage imageNamed:@"check-square-no"] forState:UIControlStateNormal];
    [rememberBtn setImage:[UIImage imageNamed:@"Checkboxes"] forState:UIControlStateSelected];//gouXuanC
    [rememberBtn addTarget:self action:@selector(rememberAcountPassword:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:rememberBtn];
    [rememberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pswdLBTextField.mas_bottom).offset(ScaleW(20));
        make.left.mas_equalTo(ScaleW(leftManger));
        make.height.width.mas_equalTo(ScaleW(14));
    }];
    if ([[dict allKeys] containsObject:@"pswd"]) {
        rememberBtn.selected = YES;
    }
    self.rememberBtn = rememberBtn;
    UILabel *textLb = [UILabel new];
    textLb.text = @"記住帳號";
    textLb.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
    textLb.textColor = rgba(23, 23, 23, 1);
    [bottomView addSubview:textLb];
    [textLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(rememberBtn);
        make.left.equalTo(rememberBtn.mas_right).offset(5);
        make.height.mas_equalTo(ScaleW(19));
    }];
    
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
    label.textColor = rgba(115, 115, 115, 1);
    [bottomView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(rememberBtn.mas_bottom).offset(ScaleW(20));
        make.left.mas_equalTo(leftManger);
    }];
    LXYHyperlinksButton *detailBtn = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(0, 0, 50, 36)];
    detailBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
    [detailBtn setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
    [detailBtn addTarget:self action:@selector(memberBindingEvent) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:detailBtn];
    [detailBtn setColor:[UIColor colorWithRed:0 green:78.0/255.0 blue:162.0/255 alpha:1.0]];
    [detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(label);
        make.left.equalTo(label.mas_right);
    }];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"如果您曾是天鷹商城會員，請點選會員綁定"];
    NSRange strRange = {15, 4};
    [str addAttribute:NSForegroundColorAttributeName value:rgba(0, 78, 162, 1) range:strRange]; // 字体
    [str addAttribute:NSUnderlineColorAttributeName value:rgba(0, 78, 162, 1) range:strRange]; // 下划线
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger : NSUnderlineStyleSingle] range:strRange];
    [detailBtn setAttributedTitle:str forState:UIControlStateNormal];
    detailBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [detailBtn setHidden:YES];
    
#pragma mark ---- login
    UIButton *logInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logInBtn.layer.masksToBounds = YES;
    logInBtn.layer.cornerRadius = 5;
    logInBtn.backgroundColor = rgba(229, 229, 229, 1);
    [logInBtn setTitle:@"登入" forState:UIControlStateNormal];
    logInBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightBold];
    [logInBtn addTarget:self action:@selector(logInMethod:) forControlEvents:UIControlEventTouchUpInside];
    [logInBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [logInBtn setTitleColor:rgba(163, 163, 163, 1) forState:UIControlStateDisabled];
    [logInBtn setBackgroundImage:[UIImage imageWithColor:rgba(243, 243, 243, 1)] forState:UIControlStateDisabled];
    [logInBtn setBackgroundImage:[UIImage imageWithColor:rgba(16, 38, 73, 1)] forState:UIControlStateNormal];
    [bottomView addSubview:logInBtn];
    
    if ([[dict allKeys] containsObject:@"pswd"] && [[dict allKeys] containsObject:@"account"])
    {
        logInBtn.enabled = true;
    }else{
        logInBtn.enabled = false;
    }
    
    [logInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_bottom).offset(ScaleW(20));
        make.left.mas_equalTo(leftManger);
        make.right.mas_equalTo(-leftManger);
        make.height.mas_equalTo(ScaleH(40));
    }];
    self.logInBtn = logInBtn;
    
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = rgba(115, 115, 115, 1);
    [bottomView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logInBtn.mas_bottom).offset(ScaleW(41));
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(ScaleW(2));
        make.height.mas_equalTo(ScaleW(15));
    }];
    UIButton *forgotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgotBtn.tag = 67;
    [forgotBtn setTitle:@"忘記密碼" forState:UIControlStateNormal];
    forgotBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
    [forgotBtn setTitleColor:rgba(64, 64, 64, 1) forState:UIControlStateNormal];
    [forgotBtn addTarget:self action:@selector(registerPasswordForget:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:forgotBtn];
    [forgotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(line);
        make.left.mas_equalTo(leftManger);
        make.right.equalTo(line.mas_left).offset(-leftManger);
        make.height.mas_equalTo(ScaleH(40));
    }];
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.tag = 68;
    [registerBtn setTitle:@"註冊會員" forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
    [registerBtn setTitleColor:rgba(64, 64, 64, 1) forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerPasswordForget:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(line);
        make.left.equalTo(line.mas_left).offset(leftManger);
        make.right.mas_equalTo(-leftManger);
        make.height.mas_equalTo(ScaleH(40));
    }];
}

-(void)registerPasswordForget:(UIButton *)sender
{
    if (sender.tag == 67) {
    
        EGForgetPassWordViewController *pswdVC = [EGForgetPassWordViewController new];
        pswdVC.navigationItem.title = @"忘記密碼";
        [self.navigationController pushViewController:pswdVC animated:true];
        
    }else{
        EGRegisterViewController *registerVC = [EGRegisterViewController new];
        [self.navigationController pushViewController:registerVC animated:true];
    }

}
#pragma mark --- 会员绑定
-(void)memberBindingEvent
{
    //會員帳號移轉作業
    EGPolicyViewController *policyVC = [[EGPolicyViewController alloc] init];
    policyVC.type = 0;
    policyVC.agreeBlock = ^{
        EGForgetPassWordViewController *pswdVC = [EGForgetPassWordViewController new];
        pswdVC.navigationItem.title = @"會員綁定";
        [self.navigationController pushViewController:pswdVC animated:true];
    };
    [self.navigationController presentViewController:policyVC animated:YES completion:^{
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark --- 隐藏输入密码
-(void)eyeBtnSelecteState:(UIButton *)sender
{
    if (sender.selected == YES) {
        _pswdTextField.secureTextEntry = YES;
        sender.selected = !sender.selected;
        
    }else{
        _pswdTextField.secureTextEntry = NO;
        sender.selected = !sender.selected;
    }
}
#pragma mark --- 记住密码
-(void)rememberAcountPassword:(UIButton *)btn
{
    if (btn.selected) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
}
#pragma mark --- UITextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (_accountTextField.text.length+string.length > 1 && _pswdTextField.text.length+string.length > 1) {
        
        self.logInBtn.enabled = true;
        
        
    }else{
        
        self.logInBtn.enabled = false;
        
    }
    
    if ([self.accountTextField isEqual:textField] && textField.text.length >= 10 && string.length > 0) {
        textField.text = [textField.text substringToIndex:10];
        [textField resignFirstResponder];
    }
    
    if ([self.pswdTextField isEqual:textField] && textField.text.length >= 20 && string.length > 0) {
        textField.text = [textField.text substringToIndex:20];
        [textField resignFirstResponder];
    }
    
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    if (textField.text.length == 0) {
        return YES;
    }
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
        [self logInMethod:nil];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

#pragma mark --- 登录
-(void)logInMethod:(UIButton *)button
{
    [self.view endEditing:YES];
    
    BOOL isValid = [EGLogInTools isValidTaiwanMobileNumber:self.accountTextField.text];
    if (!isValid) {
        [[EGAlertViewHelper sharedManager] alertViewColor:1 message:@"請輸入正確手機號碼格式"];
        return;
    }
    BOOL isValid_pswd = [EGLogInTools isValidPswdString:self.pswdTextField.text];
    if (!isValid_pswd) {
        [[EGAlertViewHelper sharedManager] alertViewColor:1 message:@"請輸入正確密碼格式"];
        return;
    }
    
    NSDictionary *dictUser = [kUserDefaults objectForKey:@"TokenRefreshLogIn"];
    if (![dictUser[@"account"] isEqualToString:self.accountTextField.text] && dictUser) {
        [[EGAlertViewHelper sharedManager] alertViewColor:1 message:@"基於安全考量，本裝置已綁定一組會員帳號"];
        return;
    }
    
    if (!self.rememberBtn.selected) {
        [kUserDefaults removeObjectForKey:@"remberLogIn"];
        
    }else{
        [kUserDefaults setObject:@{@"account":self.accountTextField.text,@"pswd":self.pswdTextField.text} forKey:@"remberLogIn"];
    }
//    [kUserDefaults setObject:@{@"account":self.accountTextField.text,@"password":self.pswdTextField.text} forKey:@"TokenRefreshLogIn"];
    [kUserDefaults synchronize];
    
    EGUserOauthModel *model = [EGLoginUserManager getOauthDataModel];
    if (!model) {
        [[EGetTokenViewModel sharedManager] getAuthForOnlyOneCRM:^(BOOL success) {
            if (success) {
                [self checkPhoneRegister];
            }
        }];
    }else{
        [self checkPhoneRegister];
    }
}
-(void)checkPhoneRegister
{
    WS(weakSelf);
    EGUserOauthModel *model = [EGLoginUserManager getOauthDataModel];
    NSDictionary *dict_header;
    if (model) {
        NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
        dict_header = @{@"Authorization":tokenString};
    }
    [MBProgressHUD showMessage:@""];
    [[WAFNWHTTPSTool sharedManager] getWithURL:[EGServerAPI checkPhoneRegister_api:self.accountTextField.text] parameters:@{} headers:dict_header success:^(NSDictionary * _Nonnull response) {
            
            [weakSelf loginAction];
        } failure:^(NSError * _Nonnull error) {
            [MBProgressHUD hideHUD];
            if (error) {
                NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                if (errorData) {
                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:&error];
                    NSString *message = dictionary[@"message"];
                    [[EGAlertViewHelper sharedManager] alertViewColor:1 message:message];
                }else{
                    [[EGAlertViewHelper sharedManager] alertViewColor:1 message:error.localizedDescription];
                }
            }
        }];
}

-(void)loginAction
{
    EGUserOauthModel *model = [EGLoginUserManager getOauthDataModel];
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
    NSDictionary *dict_header = @{@"Authorization":tokenString};
    
    WS(weakSelf);
    NSDictionary *dict = @{
        @"account": self.accountTextField.text,
        @"password": self.pswdTextField.text};
    __strong __typeof(weakSelf)strongSelf = weakSelf;
    [[WAFNWHTTPSTool sharedManager] postWithURL:[EGServerAPI signIn_api] parameters:dict headers:dict_header success:^(NSDictionary * _Nonnull response) {
        [MBProgressHUD hideHUD];
        
        NSDictionary *dataDict = [response objectForKey:@"data"];
        UserInfomationModel *userModel = [UserInfomationModel mj_objectWithKeyValues:dataDict];
        [EGLoginUserManager saveUserInfomation:userModel];
        
        [strongSelf getDataForUser];
        
        if (weakSelf.logInBlock) {
            weakSelf.logInBlock();
        }
        
        [kUserDefaults setObject:@{@"account":self.accountTextField.text,@"password":self.pswdTextField.text} forKey:@"TokenRefreshLogIn"];
        [kUserDefaults synchronize];
        
        [weakSelf dismissViewControllerAnimated:true completion:^{
            
        }];
        
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
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


-(void)getDataForUser
{
    WS(weakSelf);
    __strong __typeof(weakSelf)strongSelf = weakSelf;
    UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
    NSDictionary *dict_header = @{@"Authorization":tokenString};
    [[WAFNWHTTPSTool sharedManager] getWithURL:[EGServerAPI basicMemberContact_api:model.ID] parameters:@{} headers:dict_header success:^(NSDictionary * _Nonnull response) {
        [MBProgressHUD hideHUD];
        NSDictionary *dataDict = response[@"data"];
        
        MemberInfomationModel *model = [MemberInfomationModel mj_objectWithKeyValues:dataDict];
        [EGLoginUserManager saveMemberInfomation:model];
        
        [[NSNotificationCenter defaultCenter]
                postNotificationName:@"checkbeaconNotification"
                object:self];
        
        [strongSelf mobile_crm_API:[dataDict objectOrNilForKey:@"Name"]];
        
        } failure:^(NSError * _Nonnull error) {
            
        }];
}

-(void)mobile_crm_API:(NSString *)userName
{
    NSString *fcmToken = [kUserDefaults objectForKey:FCMTokenInfo];
    if (!fcmToken) {
        [EGLoginUserManager getFCMTokenSuccess:^(BOOL success, NSString * _Nonnull token) {
            if (success) {
                [self setFcmTokenToServer:userName fcmToken:token];
            }
        }];
    }else{
        [self setFcmTokenToServer:userName fcmToken:fcmToken];
    }
}
-(void)setFcmTokenToServer:(NSString *)userName fcmToken:(NSString *)token
{
    UserInfomationModel *userModel = [EGLoginUserManager getUserInfomation];
    if (!userModel) {
        return;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSString *loginTime = [formatter stringFromDate:[NSDate date]];
    loginTime = [loginTime stringByReplacingOccurrencesOfString:@" " withString:@"T"];
    NSString *uuidStr = [UIDevice currentDevice].identifierForVendor.UUIDString;
    NSDictionary *dict = @{
        @"deviceId": uuidStr ? uuidStr:@"",
        @"fcmToken": token ? token:@"",
        @"deviceIsPush": @(0),
        @"deviceType": @(0),
        @"memberType": @(1),
        @"loginTime": [loginTime stringByAppendingString:@"+08:00"],
        @"crmMemberToken":userModel.accessToken ? userModel.accessToken:@"",
        @"userName":userName ? userName:@"" ,
        @"crmMemberId":userModel.ID ? userModel.ID:@""
    };
    EGRelayTokenModel *tokenModel = [EGLoginUserManager getRelayToken];
    NSDictionary *headerDict;
    if (tokenModel) {
        headerDict = @{@"Authorization":tokenModel.token ? tokenModel.token:@""};
    }
    [[WAFNWHTTPSTool sharedManager] postWithURL:[EGServerAPI mobile_crm_API] parameters:dict headers:headerDict success:^(NSDictionary * _Nonnull response) {
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}

@end
