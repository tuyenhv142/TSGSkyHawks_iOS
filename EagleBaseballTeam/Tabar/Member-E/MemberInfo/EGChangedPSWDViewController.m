//
//  EGChangedPSWDViewController.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/17.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGChangedPSWDViewController.h"

#import "EGLogInTools.h"

@interface EGChangedPSWDViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UIButton *sureBtn;

@property (nonatomic,strong) UITextField *pswdOldTF;
@property (nonatomic,strong) UITextField *pswdNewTF;
@property (nonatomic,strong) UITextField *pswdNew_AgainTF;

@property (nonatomic,strong) UITextField *codeTextField;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong) UILabel *timeLb;
@property (nonatomic,strong) NSTimer *countDownTime;
@property (nonatomic,assign) NSInteger secondsCountDown;
@end

@implementation EGChangedPSWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self setUI];
    
    [self createPasswordUI];
}

-(void)setUI{

    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, ScaleH(42))];
    topView.backgroundColor = rgba(0, 71, 56, 1);
    [self.view addSubview:topView];
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"x-mark"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeLoginViewButton) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-ScaleW(20));
        make.width.height.mas_equalTo(ScaleW(20));
    }];
    UILabel *titleLb = [UILabel new];
    titleLb.text = @"修改密碼";
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.textColor = UIColor.whiteColor;
    titleLb.font = [UIFont boldSystemFontOfSize:FontSize(16)];
    [topView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    UIButton *sureBtn = [[UIButton alloc] init];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
    [sureBtn setTitle:@"確認變更" forState:UIControlStateNormal];
    [sureBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [sureBtn setTitleColor:rgba(163, 163, 163, 1) forState:UIControlStateDisabled];
    sureBtn.backgroundColor = rgba(0, 122, 96, 1);
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
    [sureBtn setBackgroundImage:[UIImage imageWithColor:rgba(222, 222, 222, 1)] forState:UIControlStateDisabled];
    [sureBtn setBackgroundImage:[UIImage imageWithColor:rgba(0, 122, 96, 1)] forState:UIControlStateNormal];
    self.sureBtn = sureBtn;
    self.sureBtn.enabled = false;
}
-(void)closeLoginViewButton
{
    [self dismissViewControllerAnimated:true completion:^{
        
    }];
}

-(void)bottomButtonAction:(UIButton *)button
{
    
    if (![self.pswdNewTF.text isEqualToString:self.pswdNew_AgainTF.text]) {
        [MBProgressHUD showDelayHidenMessage:@"兩次輸入的密碼不相符，請重新確認"];
        return;
    }
    BOOL pswdOk = [EGLogInTools isValidPswdString:self.pswdNewTF.text];
    if (!pswdOk) {
        [MBProgressHUD showDelayHidenMessage:@"密碼限 8~20 個字元，必須包含至少一個英文字母及數字"];
        return;
    }
    
    WS(weakSelf);
    UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
    NSDictionary *dict_header = @{@"Authorization":tokenString};
    NSDictionary *dict_body = @{@"otp":self.codeTextField.text,@"password":self.pswdNewTF.text,@"oldPassword":self.pswdOldTF.text};
    [[WAFNWHTTPSTool sharedManager] putWithURL:[EGServerAPI basicMemberResetpassword_api:model.ID] parameters:dict_body headers:dict_header success:^(NSDictionary * _Nonnull response) {
            
            [weakSelf closeLoginViewButton];
        [MBProgressHUD showDelayHidenMessage:@"修改成功"];
        
        } failure:^(NSError * _Nonnull error) {
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            if (errorData) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:&error];
                NSString *message = dictionary[@"message"];
                [[EGAlertViewHelper sharedManager] alertViewColor:1 message:message];
            }
        }];
    
}


-(void)createPasswordUI
{
    UILabel *titleLb = [UILabel new];
    titleLb.text = @"輸入密碼";
    titleLb.textColor = rgba(23, 23, 23, 1);
    titleLb.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
    [self.view addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(70));
        make.left.mas_equalTo(ScaleW(24));
        make.right.mas_equalTo(-ScaleW(24));
    }];
    UITextField *pswdOldTF = [UITextField new];
    pswdOldTF.borderStyle = UITextBorderStyleRoundedRect;
    pswdOldTF.font = [UIFont systemFontOfSize:FontSize(14)];
    pswdOldTF.returnKeyType = UIReturnKeyNext;
    pswdOldTF.delegate = self;
    pswdOldTF.placeholder = @"請輸入密碼";
    pswdOldTF.secureTextEntry = YES;
    [self.view addSubview:pswdOldTF];
    [pswdOldTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(24));
        make.top.mas_equalTo(titleLb.mas_bottom).offset(ScaleW(8));
        make.height.mas_equalTo(ScaleW(45));
        make.right.mas_equalTo(-ScaleW(24));
    }];
    self.pswdOldTF = pswdOldTF;
    UIButton *eyeBtn = [[UIButton alloc] init];
    eyeBtn.tag = 1;
    [eyeBtn setImage:[UIImage imageNamed:@"eye-slash"] forState:UIControlStateNormal];
    [eyeBtn setImage:[UIImage imageNamed:@"showPswd"] forState:UIControlStateSelected];
    [eyeBtn addTarget:self action:@selector(eyeAgainBtnSelecteState:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:eyeBtn];
    [eyeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(pswdOldTF);
        make.height.mas_equalTo(ScaleW(28));
        make.right.mas_equalTo(-ScaleW(40));
    }];
    eyeBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -20, -10, -20);
    
    
    
    UILabel *titleLb1 = [UILabel new];
    titleLb1.text = @"輸入新密碼";
    titleLb1.textColor = rgba(23, 23, 23, 1);
    titleLb1.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
    [self.view addSubview:titleLb1];
    [titleLb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pswdOldTF.mas_bottom).offset(ScaleW(20));
        make.left.mas_equalTo(ScaleW(24));
        make.right.mas_equalTo(-ScaleW(24));
    }];
    UITextField *pswdNewTF = [UITextField new];
    pswdNewTF.borderStyle = UITextBorderStyleRoundedRect;
    pswdNewTF.font = [UIFont systemFontOfSize:FontSize(14)];
    pswdNewTF.returnKeyType = UIReturnKeyNext;
    pswdNewTF.delegate = self;
    pswdNewTF.placeholder = @"請輸入新密碼";
    pswdNewTF.secureTextEntry = YES;
    [self.view addSubview:pswdNewTF];
    [pswdNewTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(24));
        make.top.mas_equalTo(titleLb1.mas_bottom).offset(ScaleW(8));
        make.height.mas_equalTo(ScaleW(45));
        make.right.mas_equalTo(-ScaleW(24));
    }];
    self.pswdNewTF = pswdNewTF;
    UIButton *againEyeBtn = [[UIButton alloc] init];
    againEyeBtn.tag = 2;
    [againEyeBtn setImage:[UIImage imageNamed:@"eye-slash"] forState:UIControlStateNormal];
    [againEyeBtn setImage:[UIImage imageNamed:@"showPswd"] forState:UIControlStateSelected];
    [againEyeBtn addTarget:self action:@selector(eyeAgainBtnSelecteState:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:againEyeBtn];
    [againEyeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(pswdNewTF);
        make.height.mas_equalTo(ScaleW(28));
        make.right.mas_equalTo(-ScaleW(40));
    }];
    againEyeBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -20, -10, -20);
    UILabel *bottomLb = [UILabel new];
    bottomLb.text = @"輸入您的新密碼，密碼限 8~20 個字元，必須包含至少一個英文字母及數字。";
    bottomLb.numberOfLines = 0;
    bottomLb.textColor = rgba(115, 115, 115, 1);
    bottomLb.font = [UIFont systemFontOfSize:FontSize(12) weight:UIFontWeightRegular];
    [self.view addSubview:bottomLb];
    [bottomLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pswdNewTF.mas_bottom).offset(ScaleW(5));
        make.left.mas_equalTo(ScaleW(24));
        make.right.mas_equalTo(-ScaleW(24));
    }];
    
    
    UILabel *titleLb2 = [UILabel new];
    titleLb2.text = @"再次輸入新密碼";
    titleLb2.textColor = rgba(23, 23, 23, 1);
    titleLb2.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
    [self.view addSubview:titleLb2];
    [titleLb2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottomLb.mas_bottom).offset(ScaleW(20));
        make.left.mas_equalTo(ScaleW(24));
        make.right.mas_equalTo(-ScaleW(24));
    }];
    UITextField *pswdNew_AgainTF = [UITextField new];
    pswdNew_AgainTF.borderStyle = UITextBorderStyleRoundedRect;
    pswdNew_AgainTF.font = [UIFont systemFontOfSize:FontSize(14)];
    pswdNew_AgainTF.returnKeyType = UIReturnKeyNext;
    pswdNew_AgainTF.delegate = self;
    pswdNew_AgainTF.placeholder = @"請輸入新密碼";
    pswdNew_AgainTF.secureTextEntry = YES;
    [self.view addSubview:pswdNew_AgainTF];
    [pswdNew_AgainTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(24));
        make.top.mas_equalTo(titleLb2.mas_bottom).offset(ScaleW(8));
        make.height.mas_equalTo(ScaleW(45));
        make.right.mas_equalTo(-ScaleW(24));
    }];
    self.pswdNew_AgainTF = pswdNew_AgainTF;
    UIButton *againEyeBtn2 = [[UIButton alloc] init];
    againEyeBtn2.tag = 3;
    [againEyeBtn2 setImage:[UIImage imageNamed:@"eye-slash"] forState:UIControlStateNormal];
    [againEyeBtn2 setImage:[UIImage imageNamed:@"showPswd"] forState:UIControlStateSelected];
    [againEyeBtn2 addTarget:self action:@selector(eyeAgainBtnSelecteState:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:againEyeBtn2];
    [againEyeBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(pswdNew_AgainTF);
        make.height.mas_equalTo(ScaleW(28));
        make.right.mas_equalTo(-ScaleW(40));
    }];
    againEyeBtn2.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -20, -10, -20);
    
    
    UILabel *titleLb3 = [UILabel new];
    titleLb3.text = @"輸入驗證碼";//[NSString stringWithFormat:@"驗證碼將發送至您當前登陸的手機(%@)",self.phoneNumber];
    titleLb3.textColor = rgba(23, 23, 23, 1);
    titleLb3.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
    [self.view  addSubview:titleLb3];
    [titleLb3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pswdNew_AgainTF.mas_bottom).offset(ScaleW(20));
        make.left.mas_equalTo(ScaleW(24));
        make.right.mas_equalTo(-ScaleW(24));
    }];
    UITextField *codeTextField = [UITextField new];
    codeTextField.layer.cornerRadius = ScaleW(8);
    codeTextField.layer.masksToBounds = true;
    codeTextField.layer.borderWidth = 1;
    codeTextField.layer.borderColor = rgba(163, 163, 163, 1).CGColor;
    codeTextField.borderStyle = UITextBorderStyleRoundedRect;
    codeTextField.font = [UIFont systemFontOfSize:FontSize(14)];
    codeTextField.returnKeyType = UIReturnKeyNext;
    codeTextField.keyboardType = UIKeyboardTypePhonePad;
    codeTextField.delegate = self;
    codeTextField.placeholder = @"請輸入驗證碼";
    [self.view addSubview:codeTextField];
    [codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(24));
        make.top.mas_equalTo(titleLb3.mas_bottom).offset(ScaleW(8));
        make.height.mas_equalTo(ScaleW(45));
        make.right.mas_equalTo(-ScaleW(24));
    }];
    self.codeTextField = codeTextField;
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.layer.cornerRadius = ScaleW(14);
    rightBtn.layer.masksToBounds = true;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
    [rightBtn setTitle:@"  發送驗證碼  " forState:UIControlStateNormal];
    [rightBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [rightBtn setTitleColor:rgba(163, 163, 163, 1) forState:UIControlStateDisabled];
    rightBtn.backgroundColor = rgba(243, 243, 243, 1);
    [rightBtn addTarget:self action:@selector(getCodeOtp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(codeTextField);
        make.height.mas_equalTo(ScaleW(28));
        make.right.mas_equalTo(-ScaleW(40));
    }];
    [rightBtn setBackgroundImage:[UIImage imageWithColor:rgba(243, 243, 243, 1)] forState:UIControlStateDisabled];
    [rightBtn setBackgroundImage:[UIImage imageWithColor:rgba(0, 122, 96, 1)] forState:UIControlStateNormal];
    self.rightBtn = rightBtn;
    UILabel *timeLb = [UILabel new];
    timeLb.textColor = rgba(220, 38, 38, 1);
    timeLb.font = [UIFont systemFontOfSize:FontSize(12) weight:UIFontWeightRegular];
    [self.view addSubview:timeLb];
    [timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeTextField.mas_bottom).offset(ScaleW(8));
        make.left.mas_equalTo(ScaleW(24));
        make.right.mas_equalTo(-ScaleW(24));
    }];
    self.timeLb = timeLb;
}


-(void)eyeAgainBtnSelecteState:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.tag == 1) {
        self.pswdOldTF.secureTextEntry = !button.selected;
    }else if (button.tag == 2){
        self.pswdNewTF.secureTextEntry = !button.selected;
    }else{
        self.pswdNew_AgainTF.secureTextEntry = !button.selected;
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.pswdNewTF.text.length >= 8 && self.pswdOldTF.text.length >= 8 && self.pswdNew_AgainTF.text.length >= 8  && self.codeTextField.text.length >= 3) {
        self.sureBtn.enabled = true;
    }else{
        self.sureBtn.enabled = false;
    }
    return true;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark ---
-(void)getCodeOtp:(UIButton *)sender
{
    WS(weakSelf);
    EGUserOauthModel *model = [EGLoginUserManager getOauthDataModel];
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
    NSDictionary *dict_header = @{@"Authorization":tokenString};
//    [[WAFNWHTTPSTool sharedManager] getWithURL:[EGServerAPI checkPhone_api:phoneNumber] parameters:@{} headers:dict_header success:^(NSDictionary * _Nonnull response) {
//
//        } failure:^(NSError * _Nonnull error) {
//
//        }];
    [[WAFNWHTTPSTool sharedManager] postWithURL:[EGServerAPI otpSms_api] parameters:@{@"phone":self.phoneNumber,@"type": @"resetPassword"} headers:dict_header success:^(NSDictionary * _Nonnull response) {
            
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

- (void)dealloc
{
    if (self.countDownTime) {
        [self.countDownTime invalidate];
        self.countDownTime = nil;
    }
}
@end
