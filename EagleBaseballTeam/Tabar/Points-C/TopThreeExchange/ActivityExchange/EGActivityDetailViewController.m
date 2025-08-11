//
//  EGActivityDetailViewController.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/4/28.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGActivityDetailViewController.h"
#import "EGBarQRCodeView.h"
#import "ELBannerView.h"
#import "EGActivityDetailTBViewCell.h"
#import "EGExchangeRecordViewController.h"
#import "GiftTBViewHeaderFooterView.h"
@interface EGActivityDetailViewController ()

@property (nonatomic,strong) ELBannerView *bannerView;
@property (nonatomic,strong) NSMutableString *store_address;
@property (nonatomic,strong) UIButton* send_bt;
@property (nonatomic,strong) NSMutableArray *btnStates;
@property (nonatomic,strong) UIView *bt_View;
@property (nonatomic,strong)UIButton *point_bt;
@end

@implementation EGActivityDetailViewController

- (NSString *)xy_noDataViewMessage {
    return @"尚無活動兌換";
}

- (UIImage *)xy_noDataViewImage {
    return [UIImage imageNamed:@"nodata"];
}

- (ELBannerView *)bannerView
{
    if (!_bannerView) {
        _bannerView = [[ELBannerView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, ScaleW(188))];
    }
    return _bannerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"活動兌換詳情";
    self.view.backgroundColor = rgba(243, 243, 243, 1);
    
    [self createUI];
    
    //[self.bannerView setImages:@[@"FamilyCard2",@"FamilyCard2"]];
    
}

-(void)createUI
{
    CGFloat topMargin = 0;
    if (self.from_type==0) {
        topMargin = ScaleW(47);
        UIView *topView = [UIView new];
        topView.backgroundColor = rgba(16, 38, 73, 1);
        [self.view addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(ScaleW(47));
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo([UIDevice de_navigationFullHeight]);
        }];
        UILabel *titleLb = [UILabel new];
        titleLb.text = @"我的點數";
        titleLb.textColor = rgba(255, 255, 255, 1);
        titleLb.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightMedium];
        [topView addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(ScaleW(20));
        }];
        UIButton *_pointsBtn = [[UIButton alloc] init];
        [_pointsBtn setTitle:[NSString stringWithFormat:@"%ld",self.points] forState:UIControlStateNormal];
        _pointsBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(20) weight:(UIFontWeightSemibold)];
        [_pointsBtn setImage:[UIImage imageNamed:@"TSG_LIGHT"] forState:UIControlStateNormal];
        [_pointsBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    //    [_pointsBtn addTarget:self action:@selector(pointsGoodsCollectExchangee:) forControlEvents:UIControlEventTouchUpInside];
        [_pointsBtn layoutButtonWithEdgeInsetsStyle:ZYButtonEdgeInsetsStyleLeft imageTitleSpace:5];
        [topView addSubview:_pointsBtn];
        _pointsBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-20, -30, -20, -20);
        [_pointsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-ScaleW(20));
        }];
        self.point_bt = _pointsBtn;
        
        
        [self createBottomButton];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo([UIDevice de_navigationFullHeight] + topMargin);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-ScaleW(104));
        }];
        
    }else{
        /*
        [self createBottomButton];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo([UIDevice de_navigationFullHeight] );
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];*/
        
        
        topMargin = ScaleW(0);
        UIView *topView = [UIView new];
        topView.backgroundColor = rgba(16, 38, 73, 1);
        [self.view addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(ScaleW(0));
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo([UIDevice de_navigationFullHeight]);
        }];
       
        [self createBottomButton];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo([UIDevice de_navigationFullHeight] + topMargin);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-ScaleW(104));
        }];
        
    }
    
    self.tableView.backgroundColor = UIColor.clearColor;
    
    [self.tableView setTableHeaderView:self.bannerView];
    
    
    if([self.activty_id isEqualToString:@""])
            [self updateUI];
    else
    {
        [self getactivty_DataInfo];
        
    }
}

-(void)getactivty_DataInfo
{
    NSString *goods = self.activty_id;//@"3d4b2c27-ef79-4942-a895-3ef3e782067e";//
    EGUserOauthModel *model = [EGLoginUserManager getOauthDataModel];
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
    NSDictionary *dict_header = @{@"Authorization":tokenString};
    [[WAFNWHTTPSTool sharedManager] getWithURL:[EGServerAPI couponsInfo_api:goods] parameters:@{} headers:dict_header success:^(NSDictionary * _Nonnull response) {
          self.info = response[@"data"];
          [self updateUI];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"失败");
        }];
}

-(void)createBottomButton
{
    UIView *baseView = [UIView new];
    baseView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:baseView];
    [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ScaleW(104));
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    self.bt_View = baseView;
    
    
    UIButton *exchangeBtn = [[UIButton alloc] init];
    exchangeBtn.backgroundColor = rgba(0, 78, 162, 1);
    exchangeBtn.layer.masksToBounds = true;
    exchangeBtn.layer.cornerRadius = ScaleW(8);
    [exchangeBtn setTitle:@"立即兌換" forState:UIControlStateNormal];
    [exchangeBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [exchangeBtn addTarget:self action:@selector(exchangeGoodsAction) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:exchangeBtn];
    [exchangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(10));
        make.left.mas_equalTo(ScaleW(20));
        make.height.mas_equalTo(ScaleW(50));
        make.right.mas_equalTo(-ScaleW(20));
    }];
    self.send_bt = exchangeBtn;
    
}
-(void)exchangeGoodsAction
{
    if(self.from_type==0){
        NSString *message = @"提醒您，一旦使用兌換即無法取消。確定要兌換贈品嗎？";
        [ELAlertController alertControllerWithTitleName:@"" andMessage:message cancelButtonTitle:@"取消" confirmButtonTitle:@"確定" showViewController:self addCancelClickBlock:^(UIAlertAction * _Nonnull cancelAction) {
            
        } addConfirmClickBlock:^(UIAlertAction * _Nonnull SureAction) {
            //get bar code string
            UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
            NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
            NSDictionary *dict_header = @{@"Authorization":tokenString};
            
            NSDictionary *body = @{@"couponId":[self.info objectForKey:@"id"]};
            
            [[WAFNWHTTPSTool sharedManager] postWithURL:[EGServerAPI redeem_coupon:model.ID] parameters:body headers:dict_header success:^(NSDictionary * _Nonnull response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //成功后刷新点数
                    [[EGetTokenViewModel sharedManager] fetchMemberInfo:^(BOOL isSuccess) {
                        if (isSuccess) {
                            NSInteger points = [EGLoginUserManager getMemberInfoPoints].Points;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.points = points;
                                [self.point_bt setTitle:[NSString stringWithFormat:@"%ld",self.points] forState:UIControlStateNormal];
                            });
                        }else{
                        }
                    }];
                    
                    //成功后 dialog
                    BKPopReminderView *popView = [[BKPopReminderView alloc] initWithTitle:@"兌換成功！您的兌換券已放入「兌換歷程」，隨時可查看使用。" buttons:@[@"取消",@"前往兌換歷程"]];
                        [popView showPopView];
                        popView.closeBlock = ^(NSInteger btnTag) {
                            if(btnTag==1)
                            {
                                EGExchangeRecordViewController *record = [EGExchangeRecordViewController new];
                                [self.navigationController pushViewController:record animated:true];
                            }
                        };
                });
            } failure:^(NSError * _Nonnull error) {
                if (error) {
                        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                        if (errorData) {
                            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:&error];
                            NSString *message = dictionary[@"message"];
                            [MBProgressHUD showDelayHidenMessage:message];
                        }else{
                            [MBProgressHUD showDelayHidenMessage:error.localizedDescription];
                            }
                    }
                }];
        }];
    }
    else
    {
        EGBarQRCodeView *codeView = [EGBarQRCodeView new];
        codeView.closeBlock = ^{
            BKPopReminderView *popView = [[BKPopReminderView alloc] initWithTitle:@"您的贈品已完成兌換，請留意兌換狀況。" buttons:@[@"確定"]];
                    [popView showPopView];
                    popView.closeBlock = ^(NSInteger btnTag) {
                        NSLog(@"点击確定");
                        [self.navigationController popViewControllerAnimated:YES];
                };
            
            
                //[self.navigationController pushViewController:pswdVC animated:true];
            };
        [codeView setgoodsID:[self.info objectForKey:@"id"]];
        [codeView showBarQRCodeView:self.qrcode_string];
    }
}

- (NSMutableArray *)btnStates
{
    if (_btnStates == nil) {
        _btnStates = [NSMutableArray arrayWithObjects:@0 , @0 , @0 , @0 , nil];
    }
    return _btnStates;
}

-(void)updateUI
{
    BOOL en_bt = NO;
    
    NSArray* imageArray = [self.info objectForKey:@"galleryImages"];//[NSArray arrayWithObject:[self.info objectForKey:@"galleryImages"]];
    [self.bannerView setImages:imageArray showTitle:YES width:Device_Width border:NO];
    
    self.store_address = [NSMutableString new];
    [self.store_address stringByAppendingString:@""];
    
    EGUserOauthModel *model = [EGLoginUserManager getOauthDataModel];
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
    NSDictionary *dict_header = @{@"Authorization":tokenString};
    [[WAFNWHTTPSTool sharedManager] getWithURL:[EGServerAPI searchstores:[self.info objectForKey:@"redeemStore"]] parameters:@{} headers:dict_header success:^(NSDictionary * _Nonnull response) {
        NSArray* array = response[@"data"];
        for(int i=0;i<array.count;i++)
        {
            [self.store_address appendString:[[array objectAtIndex:i] objectForKey:@"storeName"]];
            [self.store_address appendString:@"("];
            [self.store_address appendString:[[array objectAtIndex:i] objectForKey:@"storeAddress"]];
            [self.store_address appendFormat:@")"];
            if(i!=array.count-1)
              [self.store_address appendString:@"\n"];
        }
        
        [self.tableView reloadData];
        } failure:^(NSError * _Nonnull error) {

        }];
    
    
    if(self.from_type==0){
        NSInteger points = [EGLoginUserManager getMemberInfoPoints].Points;
        NSArray *cards = [EGLoginUserManager getMemberInfoPoints].MemberCards;
        self.send_bt.enabled = YES;
        
        //此用户是否是要求的会员才可以兑换
        NSString* criter = [self.info objectForKey:@"eligibilityCriteria"];
        BOOL isValid_User = NO;
        if([criter isKindOfClass:[NSString class]])//此栏位有值，说明有会员等级限制
        {
            if([criter isEqualToString:@"memberCard"])
            {
                NSArray* criter_mem = [self.info objectForKey:@"eligibleMembers"];
                if([criter_mem isKindOfClass:[NSArray class]]){
                    for(int i=0;i<criter_mem.count;i++)
                    {
                        NSString* mem = [criter_mem objectAtIndex:i];
                        for(int j=0;j<cards.count;j++)
                        {
                            NSString* cardtype = [[cards objectAtIndex:j] objectForKey:@"MemberTypeId"];
                            if([mem isEqualToString:cardtype])
                            {
                                isValid_User = YES;
                                break;
                            }
                        }
                    }
                }
                else
                    isValid_User = YES;
            }
            else
                isValid_User = YES;
            
            
            
            if(!isValid_User)//非法会员
            {
                self.send_bt.backgroundColor = ColorRGB(0xE5E5E5);
                [self.send_bt setTitleColor:ColorRGB(0x737373) forState:UIControlStateNormal];
                [self.send_bt setTitle:@"未符合兌換條件" forState:UIControlStateNormal];
                [self.send_bt setEnabled:NO];
            }
            else//合法会员能够兑换
            {
                //是否在兑换时间区间内
                BOOL date_ok = NO;
                NSInteger res = 0;
                NSString *sdate_string = [self.info objectForKey:@"redeemStartAt"];
                NSString *edate_string = [self.info objectForKey:@"redeemEndAt"];
                if([sdate_string isKindOfClass:[NSString class]]&&
                [edate_string isKindOfClass:[NSString class]])
                {
                    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
                    [inputFormatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]]; // 设置为公历
                        [inputFormatter setTimeZone:[NSTimeZone localTimeZone]]; // 设置本地时区
                    [inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
                    //NSDate *sdate = [inputFormatter dateFromString:sdate_string];
                    NSDate *edate = [inputFormatter dateFromString:edate_string];
                                        
                    NSTimeInterval secondsToSubtract = -1; // 减去一秒的时间间隔
                    NSDate *newEndDate = [edate dateByAddingTimeInterval:secondsToSubtract];
                                        
//                    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
//                    [outputFormatter setTimeZone:[NSTimeZone systemTimeZone]];
//                    [outputFormatter setDateFormat:@"yyyy/MM/dd"];
                    //                    NSString *sformattedDate = [outputFormatter stringFromDate:sdate];
                    //                    NSString *start_time = sformattedDate;
                                        
                    NSString *eformattedDate = [inputFormatter stringFromDate:newEndDate];
                    NSString *end_time = eformattedDate;
                    
                    date_ok = [self getconditionsEvent:sdate_string end:end_time current:[NSDate date] result:&res];
                }
                else
                date_ok = YES;
                                                                    
                if(!date_ok)
                    {
                        if(res==1){
                            self.send_bt.backgroundColor = ColorRGB(0xE5E5E5);
                            [self.send_bt setTitleColor:ColorRGB(0x737373) forState:UIControlStateNormal];
                            [self.send_bt setTitle:@"尚未開始" forState:UIControlStateNormal];
                            [self.send_bt setEnabled:NO];
                        }
                        else
                        {
                            self.send_bt.backgroundColor = ColorRGB(0xE5E5E5);
                            [self.send_bt setTitleColor:ColorRGB(0x737373) forState:UIControlStateNormal];
                            [self.send_bt setTitle:@"已結束" forState:UIControlStateNormal];
                            [self.send_bt setEnabled:NO];
                        }
                    }
                else
                {
                    //兑换点数大于已有点数，说明点数不足
                    if(points<(int)[[self.info objectForKey:@"pointCost"] intValue])
                        {
                            self.send_bt.backgroundColor = ColorRGB(0xE5E5E5);
                            [self.send_bt setTitleColor:ColorRGB(0x737373) forState:UIControlStateNormal];
                            [self.send_bt setTitle:@"點數不足" forState:UIControlStateNormal];
                            [self.send_bt setEnabled:NO];
                        }
                    
                    //是否还有次数兑换
                    NSInteger max_get = [[self.info objectForKey:@"maxPerMember"] intValue];
                    NSInteger has_get = [[self.info objectForKey:@"claimedCount"] intValue];
                    if(max_get != -1)//此栏位如果是 -1，表示无限次兑换
                    {
                        if(has_get>=max_get)//已兑换
                        {
                            self.send_bt.backgroundColor = ColorRGB(0xE5E5E5);
                            [self.send_bt setTitleColor:ColorRGB(0x737373) forState:UIControlStateNormal];
                            [self.send_bt setTitle:@"已兌換" forState:UIControlStateNormal];
                            self.send_bt.enabled = NO;
                        }
                    }
                    
                    //时间没到，但是已经兑换完成的情况
                    NSInteger total_get = [[self.info objectForKey:@"totalQuantity"] intValue];
                    NSInteger hasissued_get = [[self.info objectForKey:@"totalIssued"] intValue];
                    if(total_get != -1)//此栏位如果是 -1，表示无限次兑换
                    {
                        if(hasissued_get>=total_get)//已兑换
                        {
                            self.send_bt.backgroundColor = ColorRGB(0xE5E5E5);
                            [self.send_bt setTitleColor:ColorRGB(0x737373) forState:UIControlStateNormal];
                            [self.send_bt setTitle:@"已兑换完" forState:UIControlStateNormal];
                            self.send_bt.enabled = NO;
                        }
                    }
                    
                }
                
            }
            
        }
        else
        {
            //是否在兑换时间区间内
            BOOL date_ok = NO;
            NSInteger res = 0;
            NSString *sdate_string = [self.info objectForKey:@"redeemStartAt"];
            NSString *edate_string = [self.info objectForKey:@"redeemEndAt"];
            if([sdate_string isKindOfClass:[NSString class]]&&
            [edate_string isKindOfClass:[NSString class]])
            {
                NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
                [inputFormatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]]; // 设置为公历
                    [inputFormatter setTimeZone:[NSTimeZone localTimeZone]]; // 设置本地时区
                [inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
                //NSDate *sdate = [inputFormatter dateFromString:sdate_string];
                NSDate *edate = [inputFormatter dateFromString:edate_string];
                                    
                NSTimeInterval secondsToSubtract = -1; // 减去一秒的时间间隔
                NSDate *newEndDate = [edate dateByAddingTimeInterval:secondsToSubtract];
                                    
//                NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
//                [outputFormatter setTimeZone:[NSTimeZone systemTimeZone]];
//                [outputFormatter setDateFormat:@"yyyy/MM/dd"];
                //                    NSString *sformattedDate = [outputFormatter stringFromDate:sdate];
                //                    NSString *start_time = sformattedDate;
                                    
                NSString *eformattedDate = [inputFormatter stringFromDate:newEndDate];
                NSString *end_time = eformattedDate;
                date_ok = [self getconditionsEvent:sdate_string end:end_time current:[NSDate date] result:&res];
            }
            else
            date_ok = YES;
                                                                
            if(!date_ok)
                {
                    if(res==1){
                        self.send_bt.backgroundColor = ColorRGB(0xE5E5E5);
                        [self.send_bt setTitleColor:ColorRGB(0x737373) forState:UIControlStateNormal];
                        [self.send_bt setTitle:@"尚未開始" forState:UIControlStateNormal];
                        [self.send_bt setEnabled:NO];
                    }
                    else
                    {
                        self.send_bt.backgroundColor = ColorRGB(0xE5E5E5);
                        [self.send_bt setTitleColor:ColorRGB(0x737373) forState:UIControlStateNormal];
                        [self.send_bt setTitle:@"已結束" forState:UIControlStateNormal];
                        [self.send_bt setEnabled:NO];
                    }
                }
            else
            {
                //兑换点数大于已有点数，说明点数不足
                if(points<(int)[[self.info objectForKey:@"pointCost"] intValue])
                    {
                        self.send_bt.backgroundColor = ColorRGB(0xE5E5E5);
                        [self.send_bt setTitleColor:ColorRGB(0x737373) forState:UIControlStateNormal];
                        [self.send_bt setTitle:@"點數不足" forState:UIControlStateNormal];
                        [self.send_bt setEnabled:NO];
                    }
                else
                {
                    //是否还有次数兑换
                    NSInteger max_get = [[self.info objectForKey:@"maxPerMember"] intValue];
                    NSInteger has_get = [[self.info objectForKey:@"claimedCount"] intValue];
                    if(max_get != -1)//此栏位如果是 -1，表示无限次兑换
                    {
                        if(has_get>=max_get)//已兑换
                        {
                            self.send_bt.backgroundColor = ColorRGB(0xE5E5E5);
                            [self.send_bt setTitleColor:ColorRGB(0x737373) forState:UIControlStateNormal];
                            [self.send_bt setTitle:@"已兌換" forState:UIControlStateNormal];
                            self.send_bt.enabled = NO;
                        }
                        else
                        {
                            //时间没到，但是已经兑换完成的情况
                            NSInteger total_get = [[self.info objectForKey:@"totalQuantity"] intValue];
                            NSInteger hasissued_get = [[self.info objectForKey:@"totalIssued"] intValue];
                            if(total_get != -1)//此栏位如果是 -1，表示无限次兑换
                            {
                                if(hasissued_get>=total_get)//已兑换
                                    {
                                        self.send_bt.backgroundColor = ColorRGB(0xE5E5E5);
                                        [self.send_bt setTitleColor:ColorRGB(0x737373) forState:UIControlStateNormal];
                                        [self.send_bt setTitle:@"已兑换完" forState:UIControlStateNormal];
                                        self.send_bt.enabled = NO;
                                    }
                            }
                        }
                    }
                    else
                    {
                        //时间没到，但是已经兑换完成的情况
                        NSInteger total_get = [[self.info objectForKey:@"totalQuantity"] intValue];
                        NSInteger hasissued_get = [[self.info objectForKey:@"totalIssued"] intValue];
                        if(total_get != -1)//此栏位如果是 -1，表示无限次兑换
                        {
                            if(hasissued_get>=total_get)//已兑换
                            {
                                self.send_bt.backgroundColor = ColorRGB(0xE5E5E5);
                                [self.send_bt setTitleColor:ColorRGB(0x737373) forState:UIControlStateNormal];
                                [self.send_bt setTitle:@"已兑换完" forState:UIControlStateNormal];
                                self.send_bt.enabled = NO;
                            }
                        }
                    }
                    
                }
                
                
                
            }
            
        }
        
    }
    else
    {
        NSString *sdate_string = [self.info objectForKey:@"claimStartAt"];
        NSString *edate_string = [self.info objectForKey:@"claimEndAt"];
        NSInteger res = 0;
        if([sdate_string isKindOfClass:[NSString class]]&&
           [edate_string isKindOfClass:[NSString class]]){
            
            NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
            [inputFormatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]]; // 设置为公历
                [inputFormatter setTimeZone:[NSTimeZone localTimeZone]]; // 设置本地时区
            [inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
            //NSDate *sdate = [inputFormatter dateFromString:sdate_string];
            NSDate *edate = [inputFormatter dateFromString:edate_string];
                                
            NSTimeInterval secondsToSubtract = -1; // 减去一秒的时间间隔
            NSDate *newEndDate = [edate dateByAddingTimeInterval:secondsToSubtract];
                                
//            NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
//            [outputFormatter setTimeZone:[NSTimeZone systemTimeZone]];
//            [outputFormatter setDateFormat:@"yyyy/MM/dd"];
            //                    NSString *sformattedDate = [outputFormatter stringFromDate:sdate];
            //                    NSString *start_time = sformattedDate;
                                
            NSString *eformattedDate = [inputFormatter stringFromDate:newEndDate];
            NSString *end_time = eformattedDate;
            
            en_bt = [self getconditionsEvent:sdate_string end:end_time current:[NSDate date] result:&res];
        }
        else
            en_bt = YES;
        
        [self.send_bt setTitle:@"開啟條碼" forState:UIControlStateNormal];
        if(self.status==0){
            self.bt_View.hidden = NO;
            self.send_bt.hidden = NO;
            [self.send_bt setTitle:@"開啟條碼" forState:UIControlStateNormal];
                    if(en_bt){
                        self.send_bt.enabled = YES;
                        [self.send_bt setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
                        self.send_bt.backgroundColor = rgba(0, 78, 162, 1);
                    }
                    else{
                        self.send_bt.enabled = NO;
                        [self.send_bt setTitle:@" 尚未開放" forState:UIControlStateNormal];
                        self.send_bt.backgroundColor = ColorRGB(0xE5E5E5);
                        [self.send_bt setTitleColor:ColorRGB(0x737373) forState:UIControlStateNormal];
                    }
        }
        else
        {
            self.bt_View.hidden = YES;
            self.send_bt.hidden = YES;
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
            }];
        }
    }
}

/*按照当前时间，过滤符合时间段的任务，并记录任务 id*/
-(BOOL)getconditionsEvent:(NSString*)startTime  end:(NSString*)endTime current:(NSDate*)curTime result:(NSInteger*)r
{
    BOOL is_OKEvent = NO;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]]; // 设置为公历
        [formatter setTimeZone:[NSTimeZone localTimeZone]]; // 设置本地时区
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    //[formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    NSDate *date1 = [formatter dateFromString:startTime];
    NSDate *dateToCheck = curTime; // 需要检查的日期
    NSDate *startDate = date1; // 起始日期
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]]; // 设置为公历
        [formatter1 setTimeZone:[NSTimeZone localTimeZone]]; // 设置本地时区
    [formatter1 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    NSDate *date2 = [formatter1 dateFromString:endTime];
    NSDate *endDate = date2; // 结束日期
     
    NSTimeInterval intervalToStart = [dateToCheck timeIntervalSinceDate:startDate];
    NSTimeInterval intervalToEnd = [endDate timeIntervalSinceDate:dateToCheck];
     
    if (intervalToStart >= 0 && intervalToEnd >= 0) {
        //NSLog(@"日期在两个时间段内");
        is_OKEvent = YES;
    } else {
        //NSLog(@"日期不在两个时间段内");
        if(intervalToEnd<0)
        {
            NSLog(@"日期超出时间段");
            *r = 2;
        }
        
        if(intervalToStart<0)
        {
            NSLog(@"日期未到时间段");
            *r = 1;
        }
    }
    
    return is_OKEvent;
}

#pragma mark - UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return [UIView new];
    }else{
        WS(weakSelf);
        GiftTBViewHeaderFooterView *headerView = [GiftTBViewHeaderFooterView cellHeaderWithUITableView:tableView];
        headerView.titleLb.text =@[@"",@"",@"兌換地點",@"使用規則"][section];
        headerView.titleLb.textColor = ColorRGB(0x007A60);
        headerView.titleLb.font = [UIFont boldSystemFontOfSize:FontSize(14)];
        headerView.arrowBtn.selected = [self.btnStates[section] boolValue];
        headerView.showOrHiddenBlcok = ^(BOOL showHidden) {
            if (showHidden) {
                [weakSelf.btnStates replaceObjectAtIndex:section withObject:@1];
            }else{
                [weakSelf.btnStates replaceObjectAtIndex:section withObject:@0];
            }
            [weakSelf.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        };
        
        //if(section==3)
        {
            // 绘制虚线
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.bounds = headerView.bounds;
            shapeLayer.position = CGPointMake(CGRectGetMidX(headerView.bounds), CGRectGetMidY(headerView.bounds));
            shapeLayer.fillColor = [UIColor clearColor].CGColor;
            shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor; // 虚线颜色
            shapeLayer.lineWidth = 1.0;
            shapeLayer.lineJoin = kCALineJoinRound;
            shapeLayer.lineDashPattern = @[@2, @3]; // 虚线模式，这里是4像素实线，4像素空白
            
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(ScaleW(20), headerView.bounds.origin.y)];
            [path addLineToPoint:CGPointMake(Device_Width - ScaleW(20), headerView.bounds.origin.y)];
            shapeLayer.path = path.CGPath;
            
            [headerView.layer addSublayer:shapeLayer];
            
        }
        
        
        return headerView;
    }
//    else
//    {
//        WS(weakSelf);
//        GiftTBViewHeaderFooterView *headerView = [GiftTBViewHeaderFooterView cellHeaderWithUITableView:tableView];
//        headerView.titleLb.text =@[@"",@"",@"兌換地點",@"使用規則"][3];
//        headerView.titleLb.textColor = ColorRGB(0x007A60);
//        headerView.titleLb.font = [UIFont boldSystemFontOfSize:ScaleW(14)];
//        headerView.arrowBtn.selected = [self.btnStates[3] boolValue];
//        headerView.showOrHiddenBlcok = ^(BOOL showHidden) {
//            if (showHidden) {
//                [weakSelf.btnStates replaceObjectAtIndex:3 withObject:@1];
//            }else{
//                [weakSelf.btnStates replaceObjectAtIndex:3 withObject:@0];
//            }
//            [weakSelf.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
//        };
//        return headerView;
//    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 0.001;
    }else{
        return ScaleW(80);
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return /*2*/4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }else if(section==1){
        if(self.from_type==0)
          return /*4*/3;
        else
            return 2;
    }
    else //if(section==2)
    {
        BOOL expand = [self.btnStates[section] boolValue];
        if (expand) {
            return 1;
        }else{
            return 0;
        }
    }
//    else
//    {
//        BOOL expand = [self.btnStates[3] boolValue];
//        if (expand) {
//            return 1;
//        }else{
//            return 0;
//        }
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        EGActivityDetailTBViewCell *cell = [EGActivityDetailTBViewCell cellWithUITableView:tableView];
        if(self.info)
          cell.info = self.info;
        [cell updateUI];
        return cell;
    }else if(indexPath.section==1){
        if(indexPath.row==0)
        {
            ActivityDescriptionTBViewCell *cell = [ActivityDescriptionTBViewCell cellWithUITableView:tableView];
            cell.ui_type = self.from_type;
            cell.cell_typ = 0;
            cell.info = self.info;
            cell.stauts = self.status;
            [cell updateUI];
            return cell;
        }
        else if(indexPath.row==1)
        {
            ActivityDescriptionTBViewCell *cell = [ActivityDescriptionTBViewCell cellWithUITableView:tableView];
            cell.ui_type = self.from_type;
            cell.cell_typ = 1;
            cell.info = self.info;
            cell.stauts = self.status;
            [cell updateUI];
            return cell;
        }
       else /*if(indexPath.row==2)*/
        {
            ActivityDescriptionTBViewCell *cell = [ActivityDescriptionTBViewCell cellWithUITableView:tableView];
            cell.ui_type = self.from_type;
            cell.cell_typ = 2;
            cell.info = self.info;
            cell.stauts = self.status;
            [cell updateUI];
            return cell;
        }
//        else
//        {
//            ActivityDescriptionTBViewCell *cell = [ActivityDescriptionTBViewCell cellWithUITableView:tableView];
//            cell.ui_type = self.from_type;
//            cell.cell_typ = 3;
//            cell.info = self.info;
//            [cell updateUI];
//            return cell;
//        }
        
    }
    else if(indexPath.section==2)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerCellIDheaderaddressCellID1"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headerCellIDheaderaddressCellID1"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:FontSize(14)];
        cell.textLabel.numberOfLines = 0;
        if(self.store_address.length>0)
           cell.textLabel.text = self.store_address;
        else
            cell.textLabel.text = @"不限定兌換地點";
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerCellIDheaderCellID1"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headerCellIDheaderCellID1"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:FontSize(14)];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.text = [self.info objectForKey:@"usageRules"];//@".澄清湖棒球場(高雄市鳥松區大埤路113號)\n.鷹House(高雄市三民區九如一路67號)";
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
