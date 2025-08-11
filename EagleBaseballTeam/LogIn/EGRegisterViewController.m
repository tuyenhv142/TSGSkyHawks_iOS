//
//  EGRegisterViewController.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/11.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGRegisterViewController.h"

#import "EGLogInTools.h"
#import "EGDateTimeView.h"
#import "EGRegisterData.h"
#import "EGRegisterTBViewCell.h"
#import "EGpolicyView.h"
#import "EGPolicyViewController.h"
#import "EGTermsViewController.h"

@interface EGRegisterViewController ()<DateTimeViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataMArray;
@property (nonatomic,strong) EGRegisterData *registerData;

@property (nonatomic,strong) NSMutableArray *btnMArray;

@property (nonatomic,strong) UIButton *sureBtn;

@property (nonatomic,strong) NSMutableDictionary *paramsDict;

@property (nonatomic, assign) NSInteger countdownValue;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic,assign) BOOL isAgree;
@property (nonatomic,assign) BOOL isBindAgree;

@end

@implementation EGRegisterViewController

- (NSMutableArray *)btnMArray
{
    if (_btnMArray == nil) {
        _btnMArray = [NSMutableArray array];
    }
    return _btnMArray;
}
- (NSMutableDictionary *)paramsDict
{
    if (!_paramsDict) {
        _paramsDict = [NSMutableDictionary dictionary];
    }
    return _paramsDict;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"註冊";
    
    self.registerData = [EGRegisterData new];
    self.dataMArray = self.registerData.dataMArray;
    
    [self setupUI];
    
}


- (void)setupUI
{
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [rightBtn setTitle:@"註冊條款" forState:UIControlStateNormal];
    [rightBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(registerPolicyLook) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = 0;
    self.tableView.backgroundColor = rgba(243, 243, 243, 1);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([UIDevice de_navigationFullHeight]);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-[UIDevice de_tabBarFullHeight]);
    }];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, ScaleW(220))];
    footView.backgroundColor = UIColor.whiteColor;
    [self.tableView setTableFooterView:footView];
    
    UIView *sexView = [UIView new];
    [footView addSubview:sexView];
    [sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(ScaleW(65));//65 0
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    UILabel *sexLB = [[UILabel alloc] init];
    sexLB.text = @"性别";
    sexLB.textColor = rgba(23, 23, 23, 1);
    sexLB.font = [UIFont systemFontOfSize:FontSize(14) weight:(UIFontWeightRegular)];
    [sexView addSubview:sexLB];
    [sexLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(24));
        make.top.mas_equalTo(ScaleW(15));
    }];
    UIButton *policyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [policyBtn setImage:[UIImage imageNamed:@"information-circle"] forState:UIControlStateNormal];
    [policyBtn addTarget:self action:@selector(registerPolicyLook) forControlEvents:UIControlEventTouchUpInside];
    [sexView addSubview:policyBtn];
    [policyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(sexLB);
        make.left.equalTo(sexLB.mas_right).offset(ScaleW(5));
        make.height.mas_equalTo(ScaleW(16));
        make.width.mas_equalTo(ScaleW(16));
    }];
    policyBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-15, -20, -15, -40);
    
    NSArray *btnArray = @[@" 男",@" 女",@" 保密"];
    for (int i = 0; i < btnArray.count; i++ ) {
        UIButton *detailBtn = [[UIButton alloc] init];
        [detailBtn setTitle:btnArray[i] forState:UIControlStateNormal];
        [detailBtn setTitleColor:rgba(64, 64, 64, 1) forState:UIControlStateNormal];
        detailBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
        [detailBtn setImage:[UIImage imageNamed:@"tuoYuanHui"] forState:UIControlStateNormal];
        [detailBtn setImage:[UIImage imageNamed:@"Checkboxes-1"] forState:UIControlStateSelected];
        detailBtn.tag = i;
        [detailBtn addTarget:self action:@selector(sexButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
        [sexView addSubview:detailBtn];
        [detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleW(40));
            make.height.mas_equalTo(ScaleW(25));
            make.left.mas_equalTo(ScaleW(24) + i * ScaleW(60) );
        }];
        detailBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -20);
        [self.btnMArray addObject:detailBtn];
    }
//    sexView.hidden = true;//去掉隐私 取审核  sexView。height=0
    
    UIButton *agreeBtn = [[UIButton alloc] init];
    agreeBtn.tag = 98;
    [agreeBtn setImage:[UIImage imageNamed:@"check-square-no"] forState:UIControlStateNormal];
    [agreeBtn setImage:[UIImage imageNamed:@"Checkboxes"] forState:UIControlStateSelected];
    [agreeBtn addTarget:self action:@selector(agreeButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:agreeBtn];
    [agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sexView.mas_bottom).offset(ScaleW(15));
        make.width.mas_equalTo(ScaleW(20));
        make.height.mas_equalTo(ScaleW(20));
        make.left.mas_equalTo(ScaleW(24));
    }];
    agreeBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -20);
    
    NSString *fullText = @"我已詳細閱讀且同意 隱私條款 及 使用者條款，並同意放棄契約審閱期，且授權貴公司於條款目的範圍內，進行本人之個人資料搜集、處裡及利用。";
    NSArray *highlightedTexts = @[@"隱私條款", @"使用者條款"];
    UILabel *agreementLabel = [[UILabel alloc] init];
    agreementLabel.numberOfLines = 0;
    agreementLabel.userInteractionEnabled = YES; // 必须启用用户交互
    // 创建属性字符串
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:fullText];
    // 设置整个文本的默认属性
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:FontSize(14)]
                             range:NSMakeRange(0, fullText.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:rgba(0, 78, 162, 1)
                             range:NSMakeRange(0, fullText.length)];
    // 设置高亮文本的属性（黄色）
    for (NSString *text in highlightedTexts) {
        NSRange range = [fullText rangeOfString:text];
        if (range.location != NSNotFound) {
            [attributedString addAttribute:NSForegroundColorAttributeName
                                     value:rgba(217, 174, 53, 1)
                                     range:range];
        }
    }
    agreementLabel.attributedText = attributedString;
    // 添加点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAgreementLabelTap:)];
    [agreementLabel addGestureRecognizer:tapGesture];
    [footView addSubview:agreementLabel];
    // 设置约束（根据你的布局需要调整）
    agreementLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
//        [agreementLabel.centerXAnchor constraintEqualToAnchor:footView.centerXAnchor],
//        [agreementLabel.centerYAnchor constraintEqualToAnchor:footView.centerYAnchor],
        [agreementLabel.topAnchor constraintGreaterThanOrEqualToAnchor:agreeBtn.topAnchor constant:0],
        [agreementLabel.leadingAnchor constraintGreaterThanOrEqualToAnchor:agreeBtn.leadingAnchor constant:20],
        [agreementLabel.trailingAnchor constraintLessThanOrEqualToAnchor:footView.trailingAnchor constant:-20]
    ]];
    
//    NSString *information = @"我已詳細閱讀且同意 會員服務條款，並同意放棄契約審閱期，且授權貴公司於條款目的範圍內，進行本人之個人資料搜集、處裡及利用。";
//    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:information];
//    [attributedString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FontSize(14)] range:NSMakeRange(10, 6)];
//    [attributedString2 addAttribute:NSForegroundColorAttributeName value:rgba(217, 174, 53, 1) range:NSMakeRange(10, 6)];
//    [attributedString2 addAttribute:NSUnderlineColorAttributeName value:rgba(217, 174, 53, 1) range:NSMakeRange(10, 6)];
//    [attributedString2 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger : NSUnderlineStyleSingle] range:NSMakeRange(10, 6)];
//    UIButton *agreeTitle = [[UIButton alloc] init];
//    agreeTitle.titleLabel.font = [UIFont systemFontOfSize:FontSize(14)];
//    [agreeTitle setTitleColor:rgba(0, 122, 96, 1) forState:UIControlStateNormal];
//    agreeTitle.titleLabel.numberOfLines = 0;
//    [agreeTitle addTarget:self action:@selector(agreeButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
//    [footView addSubview:agreeTitle];
//    [agreeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(ScaleW(52));
//        make.right.mas_equalTo(-ScaleW(24));
//        make.top.equalTo(sexView.mas_bottom).offset(ScaleW(15));
//        make.height.mas_equalTo(ScaleW(55));
//    }];
//    [agreeTitle setAttributedTitle:attributedString2 forState:(UIControlStateNormal)];
    
    UIButton *agreeBtn_B = [[UIButton alloc] init];
    agreeBtn_B.tag = 198;
    [agreeBtn_B setImage:[UIImage imageNamed:@"check-square-no"] forState:UIControlStateNormal];
    [agreeBtn_B setImage:[UIImage imageNamed:@"Checkboxes"] forState:UIControlStateSelected];
    [agreeBtn_B addTarget:self action:@selector(agreeButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:agreeBtn_B];
    [agreeBtn_B mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(agreementLabel.mas_bottom).offset(ScaleW(15));
        make.width.mas_equalTo(ScaleW(20));
        make.height.mas_equalTo(ScaleW(20));
        make.left.mas_equalTo(ScaleW(24));
    }];
    agreeBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -20);
    NSString *information_B = @"我已詳細閱讀且同意 會員帳號移轉作業。";
    NSMutableAttributedString *attributedString_B = [[NSMutableAttributedString alloc]initWithString:information_B];
    NSRange rangeB = NSMakeRange(10, 8);
    [attributedString_B addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FontSize(14)] range:rangeB];
    [attributedString_B addAttribute:NSForegroundColorAttributeName value:rgba(217, 174, 53, 1) range:rangeB];
    [attributedString_B addAttribute:NSUnderlineColorAttributeName value:rgba(217, 174, 53, 1) range:rangeB];
    [attributedString_B addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger : NSUnderlineStyleSingle] range:rangeB];
    UIButton *agreeTitle_B = [[UIButton alloc] init];
    agreeTitle_B.tag = 199;
    agreeTitle_B.titleLabel.font = [UIFont systemFontOfSize:FontSize(14)];
    [agreeTitle_B setTitleColor:rgba(0, 78, 162, 1) forState:UIControlStateNormal];
    agreeTitle_B.titleLabel.numberOfLines = 0;
    [agreeTitle_B addTarget:self action:@selector(agreeButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:agreeTitle_B];
    [agreeTitle_B mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(52));
        make.top.equalTo(agreementLabel.mas_bottom).offset(ScaleW(15));
        make.height.mas_equalTo(ScaleW(20));
    }];
    [agreeTitle_B setAttributedTitle:attributedString_B forState:(UIControlStateNormal)];
    
    UIButton *sureBtn = [[UIButton alloc] init];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
    [sureBtn setTitle:@"確定" forState:UIControlStateNormal];
    [sureBtn setTitle:@"前往登入" forState:UIControlStateSelected];
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
    [sureBtn setBackgroundImage:[UIImage imageWithColor:rgba(0, 78, 162, 1)] forState:UIControlStateNormal];
    self.sureBtn = sureBtn;
    self.sureBtn.enabled = false;
}

#pragma mark --- lable
// 处理点击事件
- (void)handleAgreementLabelTap:(UITapGestureRecognizer *)gesture {
    UILabel *label = (UILabel *)gesture.view;
    if (!label) return;
    // 获取点击位置
    CGPoint location = [gesture locationInView:label];
    // 创建文本容器
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:label.frame.size];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:label.attributedText];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    textContainer.lineFragmentPadding = 0.0;
    textContainer.lineBreakMode = label.lineBreakMode;
    textContainer.maximumNumberOfLines = label.numberOfLines;
    // 找到点击的字符索引
    NSUInteger characterIndex = [layoutManager characterIndexForPoint:location
                                                    inTextContainer:textContainer
                           fractionOfDistanceBetweenInsertionPoints:nil];
    if (characterIndex < textStorage.length) {
        // 检查点击的是否是高亮文本
        NSRange privacyRange = [label.text rangeOfString:@"隱私條款"];
        NSRange termsRange = [label.text rangeOfString:@"使用者條款"];
        if (NSLocationInRange(characterIndex, privacyRange)) {
            [self showPrivacyPolicy];
        } else if (NSLocationInRange(characterIndex, termsRange)) {
            [self showUserTerms];
        }
    }
}
// 示例方法 - 显示隐私政策
- (void)showPrivacyPolicy {
    EGTermsViewController *ServiceVC = [[EGTermsViewController alloc] init];
    ServiceVC.navigationItem.title = @"隱私條款";
    [self.navigationController pushViewController:ServiceVC animated:YES];
}

// 示例方法 - 使用者條款
- (void)showUserTerms {
    EGTermsViewController *ServiceVC = [[EGTermsViewController alloc] init];
    ServiceVC.navigationItem.title = @"使用者條款";
    [self.navigationController pushViewController:ServiceVC animated:YES];
}
// 注册条款
-(void)registerPolicyLook
{
    EGTermsViewController *ServiceVC = [[EGTermsViewController alloc] init];
    ServiceVC.navigationItem.title = @"註冊條款";
    [self.navigationController pushViewController:ServiceVC animated:YES];
}
#pragma mark - 复选框点击事件
-(void)sexButtonMethod:(UIButton *)sender
{
    for (UIButton *button in self.btnMArray) {
        if ([sender isEqual:button]) {
            button.selected = YES;
        }else{
            button.selected = NO;
        }
    }
    NSArray *sex = @[@"M",@"F",@"S"];
    [self.paramsDict setObject:sex[sender.tag] forKey:@"gender"];
    [self determineIfThereIsNil];
}
#pragma mark --- 會員服務
-(void)agreeButtonMethod:(UIButton *)sender
{
    if (sender.tag == 98) {
        
        sender.selected = !sender.selected;
        self.isAgree = sender.selected;
        
    }else if (sender.tag == 198){
        
        sender.selected = !sender.selected;
        self.isBindAgree = sender.selected;
        
    }else if (sender.tag == 199){
        
        //會員帳號移轉作業
        EGPolicyViewController *policyVC = [[EGPolicyViewController alloc] init];
        policyVC.type = 2;
        [self.navigationController presentViewController:policyVC animated:YES completion:^{
        }];
        
    } else{
        
        //會員服務條款
        EGpolicyView *picker = [[EGpolicyView alloc] init];
        [picker setInfo:2];
        picker.gBlock = ^(NSMutableDictionary* dic){
            
        };
        [picker popPickerView];
    }
    [self determineIfThereIsNil];
}

-(void)bottomButtonAction:(UIButton *)button
{
    if (button.selected) {
        [self.navigationController popViewControllerAnimated:true];
        
    }else{
        NSString *password = self.paramsDict[@"password"];
        NSString *password1 = self.paramsDict[@"password_again"];
        if (![password isEqualToString:password1]) {
            [MBProgressHUD showDelayHidenMessage:@"兩次輸入的密碼不相符，請重新確認"];
            return;
        }
        if (![EGLogInTools isValidPswdString:password]) {
            [MBProgressHUD showDelayHidenMessage:@"密碼限 8~20 個字元，必須包含至少一個英文字母及數字"];
            return;
        }
        NSString *email = self.paramsDict[@"email"];
        BOOL isEmail = [EGLogInTools isValidEmailString:email];
        if (!isEmail) {
            [MBProgressHUD showDelayHidenMessage:@"請輸入正確E-mail格式"];
            return;
        }
//        NSString *idNumber = self.paramsDict[@"extraData"][@"identity"];
//        BOOL idNum = [EGLogInTools isValidateTaiwanIDString:idNumber];
//        if (!idNum) {
//            [MBProgressHUD showDelayHidenMessage:@"身分格式不正確"];
//            return;
//        }
        WS(weakSelf);
        EGUserOauthModel *model = [EGLoginUserManager getOauthDataModel];
        NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
        NSDictionary *dict_header = @{@"Authorization":tokenString};
        [MBProgressHUD showMessage:@""];
        [[WAFNWHTTPSTool sharedManager] postWithURL:[EGServerAPI signUp_api] parameters:self.paramsDict headers:dict_header success:^(NSDictionary * _Nonnull response) {
            [MBProgressHUD hideHUD];
            button.selected = true;
            [weakSelf createRegisterFinishUI];
        } failure:^(NSError * _Nonnull error) {
            [MBProgressHUD hideHUD];
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            if (errorData) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:&error];
                NSString *message = dictionary[@"message"];
                [[EGAlertViewHelper sharedManager] alertViewColor:1 message:message];
            }
        }];
        
    }
}
-(void)createRegisterFinishUI
{
    UIView *baseView = [[UIView alloc] init];
    baseView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:baseView];
    [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([UIDevice de_navigationBarHeight]);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-[UIDevice de_tabBarFullHeight]);
    }];
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"對話框＿TAKAO"];
    [baseView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(-[UIDevice de_navigationBarHeight]);
        make.width.mas_equalTo(ScaleW(161));
        make.height.mas_equalTo(ScaleW(176));
    }];
    UILabel *titleLb = [UILabel new];
    titleLb.text = @"恭喜加入天鷹大家庭！";
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.textColor = rgba(23, 23, 23, 1);
    titleLb.font = [UIFont systemFontOfSize:FontSize(18) weight:UIFontWeightSemibold];
    [baseView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(ScaleW(14));
        make.left.mas_equalTo(ScaleW(24));
        make.right.mas_equalTo(-ScaleW(24));
    }];
    UILabel *notifLb = [UILabel new];
    notifLb.numberOfLines = 0;
    notifLb.text = @"您已成功加入天鷹排球APP。別忘了立即登入，查看即將到來的比賽日程，參與更多互動活動！";
    notifLb.textAlignment = NSTextAlignmentCenter;
    notifLb.textColor = rgba(23, 23, 23, 1);
    notifLb.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
    [baseView addSubview:notifLb];
    [notifLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLb.mas_bottom).offset(ScaleW(14));
        make.left.mas_equalTo(ScaleW(24));
        make.right.mas_equalTo(-ScaleW(24));
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    
    return self.dataMArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WS(weakSelf);
    EGRegisterTBViewCell *cell = [EGRegisterTBViewCell cellWithUITableView:tableView];

    [cell setDataDict:self.dataMArray[indexPath.row]];
    
    if (indexPath.row == 1) {
        NSString *timeStr = [EGLogInTools formatTimeFromSeconds:self.countdownValue];
        [cell setSubtitleLabelString:timeStr];
    }
    cell.textStringBlock = ^(NSString * _Nonnull textString, BOOL isBtn) {
        if (isBtn) {
            if ([textString isEqualToString:@"policy"]) {
                [weakSelf registerPolicyLook];
            }else{
                [weakSelf rightButtonEventForIndex:indexPath];
            }
        }else{
            [weakSelf textFieldChangeString:textString index:indexPath.row];
        }
    };
    return cell;
    
}
#pragma mark - textField
-(void)textFieldChangeString:(NSString *)string index:(NSInteger )row
{
    [self.registerData textFieldChangeString:string index:row];
    self.paramsDict = self.registerData.paramsDict;

    [self determineIfThereIsNil];
}
#pragma mark - textField
-(void)rightButtonEventForIndex:(NSIndexPath *)indexPath
{
    EGRegisterTBViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 1:
            [self startCountdown];
            break;
            
        case 3:
            cell.rightBtn.selected = !cell.rightBtn.selected;
            [cell setRightButtonStatue];
            break;
            
        case 4:
            cell.rightBtn.selected = !cell.rightBtn.selected;
            [cell setRightButtonStatue];
            break;
            
        case 7:
            [self selectorTimeView];
            break;
            
        default:
            break;
    }
    [self determineIfThereIsNil];
}

- (void)startCountdown
{
    [self.view endEditing:YES];
    
    NSIndexPath *firstRowIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    EGRegisterTBViewCell *cell = [self.tableView cellForRowAtIndexPath:firstRowIndexPath];
    if (cell && firstRowIndexPath.row == 1) {
        BOOL isValid = [EGLogInTools isValidTaiwanMobileNumber:cell.contentTextField.text];
        if (!isValid) {
            [[EGAlertViewHelper sharedManager] alertViewColor:1 message:@"請輸入正確手機號碼格式"];
            return;
        }
    }
    
    WS(weakSelf);
    EGUserOauthModel *model = [EGLoginUserManager getOauthDataModel];
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
    NSDictionary *dict_header = @{@"Authorization":tokenString};
    [[WAFNWHTTPSTool sharedManager] getWithURL:[EGServerAPI checkPhone_api:cell.contentTextField.text] parameters:@{} headers:dict_header success:^(NSDictionary * _Nonnull response) {
        
        } failure:^(NSError * _Nonnull error) {
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            if (errorData) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:&error];
                NSString *message = dictionary[@"message"];
                [[EGAlertViewHelper sharedManager] alertViewColor:1 message:message];
            }
        }];
    
    [[WAFNWHTTPSTool sharedManager] postWithURL:[EGServerAPI otpSms_api] parameters:@{@"phone": cell.contentTextField.text,@"type": @"signUp"} headers:dict_header success:^(NSDictionary * _Nonnull response) {
            
        cell.rightBtn.enabled = false;
        weakSelf.countdownValue = 300;
        weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCountdown) userInfo:nil repeats:YES];
        
        } failure:^(NSError * _Nonnull error) {
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            if (errorData) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:&error];
                NSString *message = dictionary[@"message"];
                [[EGAlertViewHelper sharedManager] alertViewColor:1 message:message];
            }
        }];
    
}

- (void)updateCountdown
{
    self.countdownValue -= 1;
    NSIndexPath *firstRowIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    EGRegisterTBViewCell *cell = [self.tableView cellForRowAtIndexPath:firstRowIndexPath];
    if (cell && firstRowIndexPath.row == 1) {
        NSString *timeStr = [EGLogInTools formatTimeFromSeconds:self.countdownValue];
        [cell setSubtitleLabelString:timeStr];
    }
    if (self.countdownValue <= 0) {
        [self.timer invalidate];
        self.timer = nil;
        cell.rightBtn.enabled = true;
    }
}
-(void)selectorTimeView
{
    EGDateTimeView *dateView = [[EGDateTimeView alloc] initWithDatePickerModeType:DatePickerViewDateMode];
    dateView.delegate = self;
    [dateView addViewToWindow];
}
- (void)selectTimeToReturnString:(NSString *)dateString
{
    [self.registerData textFieldChangeString:dateString index:7];
    self.paramsDict = self.registerData.paramsDict;
    [self.tableView reloadData];
}

/*
 * 判断 button state
 */
-(void)determineIfThereIsNil
{
    BOOL isOK = [self.registerData determineIfThereIsNil];
    if (!isOK) {
        self.sureBtn.enabled = NO;
        return;
    }
    if (!self.isAgree) {
        self.sureBtn.enabled = NO;
        return;
    }
    if (!self.isBindAgree) {
        self.sureBtn.enabled = NO;
        return;
    }
    self.sureBtn.enabled = YES;
}

- (void)dealloc
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
@end

