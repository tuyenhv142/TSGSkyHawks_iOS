//
//  EGMemberInfoViewController.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/15.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGMemberInfoViewController.h"

#import "EGChangedPSWDViewController.h"
#import "EGMemberInfoTbViewCell.h"
#import "EGMemberInfoData.h"
#import "EGMemberInfoTBHFooterView.h"
#import "EGPickerSelectView.h"
#import "EGLogInTools.h"
#import "EGDateTimeView.h"

@interface EGMemberInfoViewController ()<DateTimeViewDelegate>

@property (nonatomic,strong) EGMemberInfoData *infoData;
@property (nonatomic,strong) UIButton *sureBtn;
@property (nonatomic,strong) NSString *phoneNumber;
@property (nonatomic,strong)  NSArray *store_address;
@end

@implementation EGMemberInfoViewController

- (EGMemberInfoData *)infoData
{
    if (!_infoData) {
        _infoData = [[EGMemberInfoData alloc] init];
    }
    return _infoData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"會員資料";
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self createButtonUI];
    
    [self getDataForUser];
    
    UIView *footer = [UIView new];
    footer.frame = CGRectMake(0, 0, Device_Width, ScaleW(98));
    footer.backgroundColor = rgba(243, 243, 243, 1);
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.layer.cornerRadius = 8;
    closeBtn.layer.masksToBounds = true;
    closeBtn.layer.borderColor = rgba(0, 122, 96, 1).CGColor;
    closeBtn.layer.borderWidth = 0.5;
    closeBtn.backgroundColor = UIColor.whiteColor;
    [closeBtn setTitleColor:rgba(0, 122, 96, 1) forState:UIControlStateNormal];
    [closeBtn setTitle:NSLocalizedString(@"刪除帳號", nil) forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(cancelUserButton) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(-10);
        make.left.mas_equalTo(ScaleW(24));
        make.right.mas_equalTo(-ScaleW(24));
        make.height.mas_equalTo(ScaleW(40));
    }];
    [self.tableView setTableFooterView:footer];
}

-(void)cancelUserButton
{
    NSString *message = @"刪除帳號後您的相關資料和訊息將徹底刪除掉無法恢復,請您確認是否刪除該帳號。";
    [ELAlertController alertControllerWithTitleName:@"刪除帳號" andMessage:message cancelButtonTitle:@"取消" confirmButtonTitle:@"確定" showViewController:self addCancelClickBlock:^(UIAlertAction * _Nonnull cancelAction) {
            
        } addConfirmClickBlock:^(UIAlertAction * _Nonnull SureAction) {
            if (self.infomationBlock) {
                self.infomationBlock(@"cancelUser");
            }
            [self.navigationController popViewControllerAnimated:true];
        }];
}

-(void)closeLoginViewButton
{
    [self dismissViewControllerAnimated:true completion:^{
    }];
}

-(void)createButtonUI
{
    UIView *topViewNa = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, [UIDevice de_navigationFullHeight])];
    topViewNa.backgroundColor = rgba(0, 71, 56, 1);
    [self.view addSubview:topViewNa];
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"x-mark"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeLoginViewButton) forControlEvents:UIControlEventTouchUpInside];
    [topViewNa addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-ScaleW(15));
        make.right.mas_equalTo(-ScaleW(20));
        make.width.height.mas_equalTo(ScaleW(20));
    }];
    UILabel *titleLb = [UILabel new];
    titleLb.text = @"會員資料";
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.textColor = UIColor.whiteColor;
    titleLb.font = [UIFont boldSystemFontOfSize:FontSize(16)];
    [topViewNa addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-ScaleW(15));
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    
    UIView *topView = [UIView new];
    topView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([UIDevice de_navigationFullHeight]);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(ScaleW(70));
    }];
    UILabel *swithLb = [UILabel new];
    swithLb.text = @"個人設定";
    swithLb.textColor = rgba(64, 64, 64, 1);
    swithLb.font = [UIFont systemFontOfSize:FontSize(16) weight:(UIFontWeightMedium)];
    [topView addSubview:swithLb];
    [swithLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(ScaleW(24));
    }];
    UIButton *changedBtn = [[UIButton alloc] init];
    changedBtn.layer.borderColor = rgba(0, 122, 96, 1).CGColor;
    changedBtn.layer.borderWidth = 1;
    changedBtn.layer.cornerRadius = 8;
    changedBtn.layer.masksToBounds = true;
    [changedBtn setTitle:@"修改密碼" forState:UIControlStateNormal];
    [changedBtn setTitleColor:rgba(0, 122, 96, 1) forState:UIControlStateNormal];
    [changedBtn addTarget:self action:@selector(changedPassword) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:changedBtn];
    [changedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(ScaleW(126));
        make.height.mas_equalTo(ScaleW(38));
        make.right.mas_equalTo(-ScaleW(24));
    }];
    
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = 0;
    self.tableView.backgroundColor = rgba(243, 243, 243, 1);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([UIDevice de_navigationFullHeight] + ScaleW(70));
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-[UIDevice de_tabBarFullHeight]);
    }];
    
    UIButton *sureBtn = [[UIButton alloc] init];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
    [sureBtn setTitle:@"儲存" forState:UIControlStateNormal];
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
-(void)changedPassword
{
    if (!self.phoneNumber) {
        return;
    }
    EGChangedPSWDViewController *changedVC = [EGChangedPSWDViewController new];
    changedVC.phoneNumber = self.phoneNumber;
    [self presentViewController:changedVC animated:true completion:^{

    }];
}
-(void)bottomButtonAction:(UIButton *)button
{
    [self.view endEditing:true];
    
    [self.infoData.paramesDictionary removeObjectForKey:@"ExtraData"];
    [self.infoData.paramesDictionary setObject:self.infoData.extraDataDict forKey:@"extraData"];
    
    
    NSString *email = self.infoData.paramesDictionary[@"Email"];
    BOOL isEmail = [EGLogInTools isValidEmailString:email];
    if (!isEmail) {
        [MBProgressHUD showDelayHidenMessage:@"請輸入正確E-mail格式"];
        return;
    }
    
    NSString *idNumber = self.infoData.paramesDictionary[@"Identity"];
    if (idNumber.length>0) {
        BOOL idNum = [EGLogInTools isValidateTaiwanIDString:idNumber];
        if (!idNum) {
            [MBProgressHUD showDelayHidenMessage:@"請輸入正確身分證字號"];
            return;
        }
    }

    NSDictionary *dict = [self.infoData.paramesDictionary objectOrNilForKey:@"extraData"];
    NSString *invoice_number = [dict objectOrNilForKey:@"invoice_number"];
    if (invoice_number.length > 0) {
        BOOL isInvoice = [EGLogInTools isInvoiceNnumber:invoice_number];
        if (!isInvoice) {
            [MBProgressHUD showDelayHidenMessage:@"發票開立格式不正確"];
            return;
        }
    }
    

    UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
    NSDictionary *dict_header = @{@"Authorization":tokenString};
    [MBProgressHUD showMessage:@""];
    [[WAFNWHTTPSTool sharedManager] putWithURL:[EGServerAPI basicMemberContact_api:model.ID] parameters:self.infoData.paramesDictionary headers:dict_header success:^(NSDictionary * _Nonnull response) {
        [MBProgressHUD hideHUD];
        if (self.infomationBlock) {
            self.infomationBlock(invoice_number ? invoice_number:@"");
        }
        [MBProgressHUD showDelayHidenMessage:response[@"message"]];
        [self.navigationController popViewControllerAnimated:true];
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
    UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
    NSDictionary *dict_header = @{@"Authorization":tokenString};
    [[WAFNWHTTPSTool sharedManager] getWithURL:[EGServerAPI basicMemberContact_api:model.ID] parameters:@{} headers:dict_header success:^(NSDictionary * _Nonnull response) {
        
        NSDictionary *dataDict = response[@"data"];
        [weakSelf.infoData setDataDictionary:dataDict];
        weakSelf.phoneNumber = [dataDict objectOrNilForKey:@"Phone"];
        [weakSelf.tableView reloadData];
        
        } failure:^(NSError * _Nonnull error) {
            
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    EGMemberInfoTBHFooterView *headerView = [EGMemberInfoTBHFooterView headerViewWithTableView:tableView];
    
    headerView.titleLabel.text = self.infoData.headerArray[section];
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2 || section == 3 || section == 4) {
        return ScaleW(38);
    }else{
        return 0.00001;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if (section == 0) {
        return self.infoData.dataMArray.count;
    }else if (section == 1){
        return 1;
    }else if (section == 2){
        return self.infoData.addressMArray.count;;
    }else if (section == 3){
        return self.infoData.storeMArray.count;;
    }else if (section == 4){
        return self.infoData.playerMArray.count;;
    }else{
        return 2;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WS(weakSelf);
    if (indexPath.section == 0) {
        EGMemberInfoTbViewCell *cell = [EGMemberInfoTbViewCell cellWithUITableView:tableView];
        [cell setDataDict:self.infoData.dataMArray[indexPath.row]];
        cell.textStringBlock = ^(NSString * _Nonnull textString, BOOL isBtn) {
            if (isBtn) {
                [weakSelf selectorTimeView];
            }else{
                [weakSelf textFieldChangeString:textString indexPath:indexPath];
            }
        };
        return cell;
        
    }else if (indexPath.section == 1){
        
        MemberInfoTwoBtnTbViewCell *cell = [MemberInfoTwoBtnTbViewCell cellWithUITableView:tableView];
        [cell setTitleAndButtonText:[self.infoData.ticketArray lastObject]];
        cell.buttonSelectBlock = ^(NSString * _Nonnull textString, BOOL isBtn) {
            [weakSelf textFieldChangeString:textString indexPath:indexPath];
        };
        return cell;
        
    }else if (indexPath.section == 2){
        
        MemberInfoTextFieldTbViewCell *cell = [MemberInfoTextFieldTbViewCell cellWithUITableView:tableView];
        [cell setTextFieldTextAndPlaceholder:self.infoData.addressMArray[indexPath.row]];
        cell.textFSingleBlock = ^(NSString * _Nonnull textString, BOOL isBtn) {
            [weakSelf textFieldChangeString:textString indexPath:indexPath];
        };
        return cell;
        
    }else if (indexPath.section == 3){
        
        MemberInfoTextFieldTbViewCell *cell = [MemberInfoTextFieldTbViewCell cellWithUITableView:tableView];
        [cell setTextFieldTextAndPlaceholder:self.infoData.storeMArray[indexPath.row]];
        cell.textFSingleBlock = ^(NSString * _Nonnull textString, BOOL isBtn) {
            [weakSelf textFieldChangeString:textString indexPath:indexPath];
        };
        return cell;
        
    }else if (indexPath.section == 4){
        
        MemberInfoTextFieldTbViewCell *cell = [MemberInfoTextFieldTbViewCell cellWithUITableView:tableView];
        [cell setTextFieldTextAndPlaceholder:self.infoData.playerMArray[indexPath.row]];
        cell.textFSingleBlock = ^(NSString * _Nonnull textString, BOOL isBtn) {
            [weakSelf textFieldChangeString:textString indexPath:indexPath];
        };
        return cell;
        
    }else{
        
        if (indexPath.row == 0) {
            MemberInfoTwoBtnTbViewCell *cell = [MemberInfoTwoBtnTbViewCell cellWithUITableView:tableView];
            [cell setTitleAndButtonText:self.infoData.ticketArray[indexPath.row]];
            cell.buttonSelectBlock = ^(NSString * _Nonnull textString, BOOL isBtn) {
                [weakSelf textFieldChangeString:textString indexPath:indexPath];
            };
            return cell;
        }else{
            MemberInfoTextFieldTbViewCell *cell = [MemberInfoTextFieldTbViewCell cellWithUITableView:tableView];
            cell.textFSingleBlock = ^(NSString * _Nonnull textString, BOOL isBtn) {
                [weakSelf textFieldChangeString:textString indexPath:indexPath];
            };
            [cell setTextFieldTextAndPlaceholder:self.infoData.ticketArray[indexPath.row]];
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return ScaleW(80);
    }else if (indexPath.section == 5){
        if (indexPath.row == 0) {
            return ScaleW(80);
        }else{
            return UITableViewAutomaticDimension;
        }
    }else{
        return UITableViewAutomaticDimension;
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
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    [self.infoData cellTextFieldChange:dateString indexPath:indexPath];
    self.sureBtn.enabled = true;
    [self.tableView reloadData];
}

#pragma mark - textField
-(void)textFieldChangeString:(NSString *)string indexPath:(NSIndexPath *)indexPath
{
    [self.infoData cellTextFieldChange:string indexPath:indexPath];
    
    self.sureBtn.enabled = true;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:true];
    WS(weakSelf);
    if(indexPath.section==2)
    {
        if (indexPath.row == 0) {
            [self popUpViewForIndexPath:indexPath];
        }
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            
            [self popUpViewForIndexPath:indexPath];
            
        }else{
            
            if (!self.store_address) {
                NSString *path = [[NSBundle mainBundle] pathForResource:@"stores" ofType:@"json"];
                NSData *data = [NSData dataWithContentsOfFile:path];
                NSArray *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
                NSString *city;
                NSString *district;
                city = self.infoData.extraDataDict[@"store_city"];
                district = self.infoData.extraDataDict[@"store_county"];
                if (city) {
                    for (int i = 0; i < jsonData.count; i++) {
                        NSDictionary *dict = jsonData[i];
                        if ([dict[@"city"] isEqualToString:city]) {
                            NSArray *areaArr = dict[@"area"];
                            for (int j = 0; j < areaArr.count; j++) {
                                NSDictionary *dict2 = areaArr[j];
                                if ([dict2[@"name"] isEqualToString:district]) {
                                    self.store_address = dict2[@"store_address"];
                                    break;
                                }
                            }
                        }
                    }
                }else{
                    return;
                }
                
            }
            NSString *store_address = self.infoData.extraDataDict[@"store_address"];
            EGPickerSelectView *picker = [[EGPickerSelectView alloc] initWithChooseTitleNSArray:self.store_address];
            picker.componentNumber = PickerViewComponent_One;
            [picker popPickerView];
            [picker setPickerDefaultValue:store_address Value:nil];
            picker.selectBlock = ^(id result, NSInteger index,NSArray *store_address) {
                [weakSelf textFieldChangeString:result indexPath:indexPath];
                [weakSelf.tableView reloadData];
            };
            
        }
    }
}
-(void)popUpViewForIndexPath:(NSIndexPath *)indexPath
{
    NSString *city;
    NSString *district;
    if (indexPath.section == 2) {
        city = self.infoData.extraDataDict[@"delivery_city"];
        district = self.infoData.extraDataDict[@"delivery_district"];
    }else if (indexPath.section == 3){
        city = self.infoData.extraDataDict[@"store_city"];
        district = self.infoData.extraDataDict[@"store_county"];
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:@"stores" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
    WS(weakSelf);
    EGPickerSelectView *picker = [[EGPickerSelectView alloc] initWithChooseTitleNSArray:jsonData];
    picker.componentNumber = PickerViewComponent_Two;
    [picker popPickerView];
    [picker setPickerDefaultValue:city Value:district];
    picker.selectBlock = ^(id result, NSInteger index,NSArray *store_address) {
        [weakSelf textFieldChangeString:result indexPath:indexPath];
        if (indexPath.section == 3) {
            weakSelf.store_address = store_address;
        }
        [weakSelf.tableView reloadData];
    };
}


@end
