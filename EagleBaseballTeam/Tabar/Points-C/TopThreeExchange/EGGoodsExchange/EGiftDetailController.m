//
//  EGiftDetailController.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/4/28.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGiftDetailController.h"
#import "EGExchangeRecordViewController.h"
#import "GiftTBViewHeaderFooterView.h"
#import "EGiftDetailTableViewCell.h"
#import "EGBarQRCodeView.h"

@interface EGiftDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableViewG;
@property (nonatomic,strong) NSMutableArray *btnStates;

@property (nonatomic,strong) NSMutableArray* section1_array;
@property (nonatomic,strong) NSMutableString* store_address;
@property (nonatomic,strong) UIButton *send_bt;
@property (nonatomic,strong) UIView *bt_View;
@property (nonatomic,strong) UIButton *point_bt;
@end

@implementation EGiftDetailController

-(void)updateUI
{
    /*
     获取兑换门市
     */
    BOOL en_bt = NO;
    if(self.from_type==0){
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
                [self.store_address appendString:@")"];
                [self.store_address appendString:@"\n"];
            }
            [self.tableViewG reloadData];
            
        } failure:^(NSError * _Nonnull error) {
            
        }];
        
        NSDictionary *dic = self.info;
        NSString *point = [NSString stringWithFormat:@"%d 點",(int)[[dic objectForKey:@"pointCost"] intValue]];
        [self.section1_array addObject:point];
        
        //    NSString *point_status = @"未使用";
        //    switch ([[dic objectForKey:@"couponStatus"] intValue]) {
        //        case 0:
        //            point_status = @"未使用";
        //            break;
        //        case 2:
        //            point_status = @"已使用";
        //            break;
        //        default:
        //            break;
        //    }
        //    [self.section1_array addObject:point_status];
        
        int duihuan = [[dic objectForKey:@"maxPerMember"] intValue];
        NSString *usePer = @"";
        if(duihuan!=-1)
             usePer = [NSString stringWithFormat:@"%d 次",duihuan];
        else
            usePer = [NSString stringWithFormat:@"不限"];
        
        [self.section1_array addObject:usePer];
        
        //全站数量
        int totalQuan = [[dic objectForKey:@"totalQuantity"] intValue];
        NSString *Per = @"";
        if(totalQuan!=-1)
            Per = [NSString stringWithFormat:@"%d",totalQuan];
        else
            Per = [NSString stringWithFormat:@"無上限"];
        
        [self.section1_array addObject:Per];
        
        
        NSMutableString *strng = [NSMutableString new];
        NSString* criter = [self.info objectForKey:@"eligibilityCriteria"];
        if([criter isKindOfClass:[NSString class]])
        {
            if([criter isEqualToString:@"memberCard"])
            {
                NSArray* criter_mem = [self.info objectForKey:@"eligibleMembers"];
                if([criter_mem isKindOfClass:[NSArray class]])
                {
                    for(int i=0;i<criter_mem.count;i++)
                    {
                        NSString* type = [criter_mem objectAtIndex:i];
                        if([type isEqualToString:@"A001"]){
                            [strng appendString:@"鷹國皇家"];
                        }
                        
                        if([type isEqualToString:@"A002"]){
                            [strng appendString:@"鷹國尊爵"];
                        }
                        if([type isEqualToString:@"A003"]){
                            [strng appendString:@"Takao 親子卡"];
                        }
                        if([type isEqualToString:@"A004"]){
                            [strng appendString:@"鷹國人"];
                        }
                        
                        if(i!=criter_mem.count-1)
                            [strng appendString:@"、"];
                        
                        if(i==1)
                            [strng appendString:@"\n"];
                    }
                }
                else
                {
                    strng = [NSMutableString stringWithFormat:@"%@",@"所有會員皆適用"];
                }
                
            }
            else
            {
                strng = [NSMutableString stringWithFormat:@"%@",@"所有會員皆適用"];
            }
            
            [self.section1_array addObject:strng];
        }
        else
        {
            strng = [NSMutableString stringWithFormat:@"%@",@"所有會員皆適用"];
            [self.section1_array addObject:strng];
        }
        
        
        NSString *sdate_string = [dic objectForKey:@"redeemStartAt"];
        NSString *edate_string = [dic objectForKey:@"redeemEndAt"];
        if([sdate_string isKindOfClass:[NSString class]]&&
           [edate_string isKindOfClass:[NSString class]]){
            NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
            [inputFormatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]]; // 设置为公历
            [inputFormatter setTimeZone:[NSTimeZone localTimeZone]]; // 设置本地时区
            [inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
            NSDate *sdate = [inputFormatter dateFromString:sdate_string];
            NSDate *edate = [inputFormatter dateFromString:edate_string];
            
            NSTimeInterval secondsToSubtract = -1; // 减去一秒的时间间隔
            NSDate *newEndDate = [edate dateByAddingTimeInterval:secondsToSubtract];
            
            NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
            [outputFormatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]]; // 设置为公历
            [outputFormatter setTimeZone:[NSTimeZone localTimeZone]]; // 设置本地时区
            [outputFormatter setDateFormat:@"yyyy/MM/dd"];
            NSString *sformattedDate = [outputFormatter stringFromDate:sdate];
            NSString *start_time = sformattedDate;
            
            NSString *eformattedDate = [outputFormatter stringFromDate:newEndDate];
            NSString *end_time = eformattedDate;
            
            NSString *range_time = [NSString stringWithFormat:@"%@~%@",start_time,end_time];
            [self.section1_array addObject:range_time];
        }
        else
            [self.section1_array addObject:@""];
    }
    else
    {
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
                [self.store_address appendString:@")"];
                [self.store_address appendString:@"\n"];
            }
            [self.tableViewG reloadData];
            
        } failure:^(NSError * _Nonnull error) {
            
        }];
        
        NSDictionary *dic = self.info;
        NSString *point = [NSString stringWithFormat:@"%d 點",(int)[[dic objectForKey:@"pointCost"] intValue]];
        [self.section1_array addObject:point];
        
            NSString *point_status = @"未使用";
        switch (self.status) {
                case 0:
                    point_status = @"未使用";
                    break;
                case 2:
                    point_status = @"已使用";
                    break;
                default:
                    break;
            }
            [self.section1_array addObject:point_status];
        
        
        int duihuan = [[dic objectForKey:@"maxPerMember"] intValue];
        NSString *usePer = @"";
        if(duihuan!=-1)
             usePer = [NSString stringWithFormat:@"%d 次",duihuan];
        else
            usePer = [NSString stringWithFormat:@"不限"];
        
        [self.section1_array addObject:usePer];
        
//        NSString *strng = @"鷹國皇家";
//        [self.section1_array addObject:strng];
        
        NSString *sdate_string = [dic objectForKey:@"claimStartAt"];
        NSString *edate_string = [dic objectForKey:@"claimEndAt"];
        if([sdate_string isKindOfClass:[NSString class]]&&
           [edate_string isKindOfClass:[NSString class]]){
            NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
            [inputFormatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]]; // 设置为公历
                [inputFormatter setTimeZone:[NSTimeZone localTimeZone]]; // 设置本地时区
            [inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
            NSDate *sdate = [inputFormatter dateFromString:sdate_string];
            NSDate *edate = [inputFormatter dateFromString:edate_string];
            
            NSTimeInterval secondsToSubtract = -1; // 减去一秒的时间间隔
            NSDate *newEndDate = [edate dateByAddingTimeInterval:secondsToSubtract];
            NSString *end_time = [inputFormatter stringFromDate:newEndDate];
            
            
            NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
            [outputFormatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]]; // 设置为公历
            [outputFormatter setTimeZone:[NSTimeZone localTimeZone]]; // 设置本地时区
            [outputFormatter setDateFormat:@"yyyy/MM/dd"];
            NSString *sformattedDate = [outputFormatter stringFromDate:sdate];
            NSString *start_UItime = sformattedDate;
            
            NSString *eformattedDate = [outputFormatter stringFromDate:newEndDate];
            NSString *end_UItime = eformattedDate;
            
            NSString *range_time = [NSString stringWithFormat:@"%@~%@",start_UItime,end_UItime];
            
            NSInteger result;
            en_bt = [self getconditionsEvent:sdate_string end:end_time current:[NSDate date] result:&result];
            [self.section1_array addObject:range_time];
        }
        else{
            en_bt = YES;
            [self.section1_array addObject:@""];
        }
    }
    
    [_tableViewG reloadData];
    
    
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
                if([criter_mem isKindOfClass:[NSArray class]])
                {
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
            {
                isValid_User = YES;
            }
            
            
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
                NSInteger resu = 0;
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
                    
                    
                    date_ok = [self getconditionsEvent:sdate_string end:end_time current:[NSDate date] result:&resu];
                }
                else
                date_ok = YES;
                                                                    
                if(!date_ok)
                    {
                        if(resu==1){
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
        else//没有会员等级限制
        {
            //是否在兑换时间区间内
            BOOL date_ok = NO;
            NSInteger resu = 0;
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
                
                date_ok = [self getconditionsEvent:sdate_string end:end_time current:[NSDate date] result:&resu];
            }
            else
            date_ok = YES;
                                                                
            if(!date_ok)
                {
                    if(resu==1){
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
                else{
                    //点数满足
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
        [self.send_bt setTitle:@"開啟條碼" forState:UIControlStateNormal];
        if(self.status==0)
        {
            self.bt_View.hidden = NO;
            self.send_bt.hidden = NO;
            [self.send_bt setTitle:@"開啟條碼" forState:UIControlStateNormal];
            if(en_bt){
                self.send_bt.enabled = YES;
                [self.send_bt setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
                self.send_bt.backgroundColor = rgba(0, 122, 96, 1);
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
        }
        
    }
    
}

- (NSMutableArray *)btnStates
{
    if (_btnStates == nil) {
        _btnStates = [NSMutableArray arrayWithObjects:@0 , @0 , @0 , @0 , nil];
    }
    return _btnStates;
}
- (UITableView *)tableViewG
{
    if (_tableViewG == nil) {
        _tableViewG = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableViewG.delegate = self;
        _tableViewG.dataSource = self;
        _tableViewG.layer.cornerRadius = ScaleW(10);
        _tableViewG.layer.masksToBounds = true;
        _tableViewG.backgroundColor = [UIColor clearColor];
        _tableViewG.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableViewG.showsVerticalScrollIndicator = NO;
        _tableViewG.estimatedRowHeight = 100;
        [self.view addSubview:_tableViewG];
    }
    return _tableViewG;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"贈品兌換詳情";
    self.view.backgroundColor = rgba(243, 243, 243, 1);
    
    self.section1_array = [NSMutableArray new];
    
        if(self.from_type==0){
            [self createUI];
            [self createBottomButton];
            [self.tableViewG mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo([UIDevice de_navigationFullHeight] + ScaleW(67));
                make.left.mas_equalTo(ScaleW(20));
                make.right.mas_equalTo(-ScaleW(20));
                make.bottom.mas_equalTo(-ScaleW(114));
            }];
        }
        else
        {
            //[self createUI];
            [self createBottomButton];
            [self.tableViewG mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo([UIDevice de_navigationFullHeight] + ScaleW(27));
                make.left.mas_equalTo(ScaleW(20));
                make.right.mas_equalTo(-ScaleW(20));
                make.bottom.mas_equalTo(-ScaleW(80));
            }];
        }
        
    
    if([_goods_id isEqualToString:@""])
        [self updateUI];
    else
    {
        //来自通知界面
        [self getgoods_DataInfo];
        
    }
        
}

-(void)getgoods_DataInfo
{
    NSString *goods = self.goods_id;//@"3d4b2c27-ef79-4942-a895-3ef3e782067e";//
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


-(void)createUI
{
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
    exchangeBtn.backgroundColor = rgba(0, 121, 192, 1);
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
    if(self.from_type==0)
    {
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
                        
                        
                        //成功后 弹出dialog
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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

#pragma mark --TableViewDeleagte
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return [UIView new];
    }else{
        WS(weakSelf);
        GiftTBViewHeaderFooterView *headerView = [GiftTBViewHeaderFooterView cellHeaderWithUITableView:tableView];
        headerView.titleLb.text =@[@"",@"",@"兌換地點",@"使用規則"][section];
        headerView.arrowBtn.selected = [self.btnStates[section] boolValue];
        headerView.showOrHiddenBlcok = ^(BOOL showHidden) {
            if (showHidden) {
                [weakSelf.btnStates replaceObjectAtIndex:section withObject:@1];
            }else{
                [weakSelf.btnStates replaceObjectAtIndex:section withObject:@0];
            }
            [weakSelf.tableViewG reloadSections:[[NSIndexSet alloc]initWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        };
        return headerView;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 0.001;
    }else{
        return ScaleW(40);
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *view = [UIView new];
        view.backgroundColor = UIColor.whiteColor;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(ScaleW(20), 0)];
        [path addLineToPoint:CGPointMake(Device_Width - ScaleW(80), 0)];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        shapeLayer.lineWidth = 1.0;
        shapeLayer.lineDashPattern = @[@2, @3]; // 虚线模式
        [view.layer addSublayer:shapeLayer];
        
        return view;
    }
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 2;
    }else{
        return 0.001;
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return self.section1_array.count;
    } else{
        BOOL expand = [self.btnStates[section] boolValue];
        if (expand) {
            return 1;
        }else{
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        EGiftDetailTableViewCell *cell = [EGiftDetailTableViewCell cellWithUITableView:tableView];
        cell.from_type = self.from_type;
        if (self.info) {
            cell.info = self.info;
        }
        [cell updateUI];
        return cell;
    }else if (indexPath.section == 1){
        
        LeftRightLBTableViewCell *cell = [LeftRightLBTableViewCell cellWithUITableView:tableView];
        if(self.from_type==0)
        cell.leftLb.text = @[@"兌換點數",@"兌換上限",@"全站數量",@"兌換對象",@"兌換期間"][indexPath.row];
        else
        cell.leftLb.text = @[@"兌換點數",@"使用狀態",@"兌換上限",@"兌換期間"][indexPath.row];
        
        cell.rightLb.text = [self.section1_array objectAtIndex:indexPath.row];
        return cell;
        
    } else if(indexPath.section==2){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerCellIDheaderCellID"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headerCellIDheaderCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:FontSize(14)];
        if(self.store_address.length>0)
           cell.textLabel.text = self.store_address;
        else
            cell.textLabel.text = @"不限定兌換地點";
        return cell;
    }else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerCellIDheaderCellID1"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headerCellIDheaderCellID1"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:FontSize(14)];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.text = [self.info objectForKey:@"usageRules"];//@".澄清湖排球場(高雄市鳥松區大埤路113號)\n.鷹House(高雄市三民區九如一路67號)";
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
