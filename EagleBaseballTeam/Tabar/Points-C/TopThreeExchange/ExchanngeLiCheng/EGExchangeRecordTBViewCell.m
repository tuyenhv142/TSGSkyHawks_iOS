//
//  EGExchangeRecordTBViewCell.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/4/27.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGExchangeRecordTBViewCell.h"

@interface EGExchangeRecordTBViewCell ()

@property (nonatomic,strong) UIImageView *picture;
@property (nonatomic,strong) UILabel *yellowtitle;
@property (nonatomic,strong) UIImageView *yellowimage_view;
@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UILabel *goodsName;
@property (nonatomic,strong) UILabel *dateTime;
@property (nonatomic,strong) UIButton *openCode;
@property (nonatomic,strong) UIImageView *backimage_view;
@end

@implementation EGExchangeRecordTBViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"EGExchangeRecordTBViewCell";
    EGExchangeRecordTBViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
          cell = [[EGExchangeRecordTBViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//cell选中无色
    //  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//箭头
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *bgImageView = [UIImageView new];
        bgImageView.image = [UIImage imageNamed:@"exchangeBgIMG"];
        bgImageView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:bgImageView];
        [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleW(20));
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        self.backimage_view = bgImageView;
        
        
        UIView *baseView = [UIView new];
        baseView.layer.masksToBounds = true;
        baseView.layer.cornerRadius = ScaleW(8);
        baseView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:baseView];
        [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleW(20));
            make.left.mas_equalTo(ScaleW(20));
            make.right.mas_equalTo(-ScaleW(20));
            make.bottom.mas_equalTo(0);
        }];
        self.picture = [UIImageView new];
        self.picture.image = [UIImage imageNamed:@"FamilyCard2"];
        self.picture.layer.borderColor = ColorRGB(0xE5E5E5).CGColor;
        self.picture.layer.borderWidth = 1.0;
        self.picture.layer.masksToBounds = true;
        self.picture.layer.cornerRadius = ScaleW(8);
        self.picture.backgroundColor = [UIColor whiteColor];
        [baseView addSubview:self.picture];
        [self.picture mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleW(20));
            make.left.mas_equalTo(ScaleW(20));
            make.width.mas_equalTo(ScaleW(96));
            make.height.mas_equalTo(ScaleW(96));
        }];
        
        self.yellowimage_view = [[UIImageView alloc]init];
        self.yellowimage_view.contentMode = UIViewContentModeScaleToFill;
        self.yellowimage_view.image = [UIImage imageNamed:@"Vector 1"];
        [baseView addSubview:self.yellowimage_view];
        [self.yellowimage_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleW(10));
            make.right.mas_equalTo(-ScaleW(5));
            make.height.mas_equalTo(ScaleW(17));
            make.width.mas_equalTo(ScaleW(80));
        }];
        
        
        
        self.yellowtitle = [UILabel new];
        self.yellowtitle.text = @"限鷹國皇家";
        self.yellowtitle.numberOfLines = 0;
        self.yellowtitle.textAlignment = NSTextAlignmentCenter;
        self.yellowtitle.textColor = UIColor.whiteColor;
        self.yellowtitle.font = [UIFont systemFontOfSize:FontSize(12) weight:UIFontWeightMedium];
        [baseView addSubview:self.yellowtitle];
        [self.yellowtitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.yellowimage_view.mas_top);
            make.centerX.mas_equalTo(self.yellowimage_view.mas_centerX);
            make.width.mas_equalTo(ScaleW(100));
            make.height.mas_equalTo(ScaleW(20));
        }];
        
        
        self.title = [UILabel new];
        self.title.text = @"特別優惠";
        self.title.numberOfLines = 0;
        self.title.textAlignment = NSTextAlignmentLeft;
        self.title.textColor = UIColor.blackColor;
        self.title.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightMedium];
        [baseView addSubview:self.title];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleW(24));
            make.left.equalTo(self.picture.mas_right).offset(ScaleW(15));
            make.right.mas_equalTo(-ScaleW(35));
            make.height.mas_equalTo(ScaleW(40));
        }];

        self.goodsName = [UILabel new];
        self.goodsName.text = @"";
        self.goodsName.numberOfLines = 2;
        self.goodsName.textColor = rgba(23, 23, 23, 1);
        self.goodsName.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightMedium];
        [baseView addSubview:self.goodsName];
        [self.goodsName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.title.mas_bottom).offset(ScaleW(10));
            make.left.equalTo(self.picture.mas_right).offset(ScaleW(20));
            make.right.mas_equalTo(-ScaleW(20));
        }];
        
        self.dateTime = [UILabel new];
        self.dateTime.text = @"";
        self.dateTime.numberOfLines = 1;
        self.dateTime.textColor = rgba(115, 115, 115, 1);
        self.dateTime.font = [UIFont systemFontOfSize:FontSize(12) weight:UIFontWeightRegular];
        [baseView addSubview:self.dateTime];
        [self.dateTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.goodsName.mas_bottom).offset(ScaleW(10));
            make.left.equalTo(self.picture.mas_right).offset(ScaleW(20));
            make.right.mas_equalTo(-ScaleW(20));
        }];
    
        self.openCode = [UIButton buttonWithType:UIButtonTypeCustom];
//        detailBtn.layer.borderColor = rgba(51, 51, 51, 1).CGColor;
//        detailBtn.layer.borderWidth = 1;
        self.openCode.titleLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightSemibold];
        [self.openCode setTitle:@" 開啟條碼" forState:UIControlStateNormal];
        [self.openCode setImage:[UIImage imageNamed:@"ScanCodeG"] forState:UIControlStateNormal];
        [self.openCode setTitleColor:rgba(0, 122, 96, 1) forState:UIControlStateNormal];
        [self.openCode addTarget:self action:@selector(openQRCodeAction) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:self.openCode];
        [self.openCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dateTime.mas_bottom).offset(ScaleW(35));
            make.left.mas_equalTo(ScaleW(25));
            make.right.mas_equalTo(-ScaleW(25));
            make.height.mas_equalTo(ScaleW(30));
            make.bottom.mas_equalTo(-ScaleW(20));
        }];
        
    }
    return self;
}
-(void)openQRCodeAction
{
    if (self.openCodeBlock) {
        self.openCodeBlock(self.qrcode_id,[self.info objectForKey:@"id"]);
    }
}

-(void)updateUI
{
    [self.picture sd_setImageWithURL:[self.info objectForKey:@"coverImage"]];
    self.title.text = [self.info objectForKey:@"couponName"];
    
    NSString *sdate_string = [self.info objectForKey:@"claimStartAt"];
    NSString *edate_string = [self.info objectForKey:@"claimEndAt"];
    if([sdate_string isKindOfClass:[NSString class]]&&
       [edate_string isKindOfClass:[NSString class]])
    {
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
        self.dateTime.text = range_time;
        
        BOOL en_bt = NO;//[self getconditionsEvent:sdate_string end:edate_string current:[NSDate date]];
        if(en_bt){
            self.openCode.backgroundColor = [UIColor clearColor];
            [self.openCode setImage:[UIImage imageNamed:@"ScanCodeG"] forState:UIControlStateNormal];
            self.openCode.enabled = YES;
            [self.openCode setTitleColor:rgba(0, 122, 96, 1) forState:UIControlStateNormal];
        }
        else{
            //[self.openCode setImage:[UIImage imageNamed:@"QR_Code"] forState:UIControlStateNormal];
            self.openCode.enabled = NO;
            //[self.openCode setTitle:@" 尚未開放" forState:UIControlStateNormal];
            //[self.openCode setTitleColor:ColorRGB(0x737373) forState:UIControlStateNormal];
        }
    }
    else
        self.dateTime.text = @"";
    
    //设置会员黄色标签
    NSMutableString *strng = [NSMutableString new];
    NSString* criter = [self.info objectForKey:@"eligibilityCriteria"];
    if([criter isKindOfClass:[NSString class]])
    {
        if([criter isEqualToString:@"memberCard"])
        {
            NSArray* criter_mem = [self.info objectForKey:@"eligibleMembers"];
            if([criter_mem isKindOfClass:[NSArray class]]){
                if(criter_mem.count==1){
                    strng = [NSMutableString stringWithString:[criter_mem objectAtIndex:0]];
                    if([strng isEqualToString:@"A001"])
                        strng = [NSMutableString stringWithString:@"鷹國皇家"];
                    if([strng isEqualToString:@"A002"])
                        strng = [NSMutableString stringWithString:@"鷹國尊爵"];
                    if([strng isEqualToString:@"A003"])
                        strng = [NSMutableString stringWithString:@"Takao 親子卡"];
                    if([strng isEqualToString:@"A004"])
                        strng = [NSMutableString stringWithString:@"鷹國人"];
                    
                    self.yellowtitle.hidden = NO;
                    self.yellowimage_view.hidden = NO;
                    self.yellowtitle.text = strng;
                }
                else if(criter_mem.count>1)
                {
                    strng = [NSMutableString stringWithString:@"鷹國會員"];
                    self.yellowtitle.hidden = NO;
                    self.yellowimage_view.hidden = NO;
                    self.yellowtitle.text = strng;
                }
                else
                {
                    strng = [NSMutableString stringWithFormat:@"%@",@"所有會員皆適用"];
                    self.yellowtitle.hidden = YES;
                    self.yellowimage_view.hidden = YES;
                    //[self.backimage_view setImage:[UIImage imageNamed:@"exchangeBgIMG"]];
                }
                
                //[self.backimage_view setImage:[UIImage imageNamed:@"backimage_view"]];
            }
            else
            {
                strng = [NSMutableString stringWithFormat:@"%@",@"所有會員皆適用"];
                self.yellowtitle.hidden = YES;
                self.yellowimage_view.hidden = YES;
                //[self.backimage_view setImage:[UIImage imageNamed:@"exchangeBgIMG"]];
            }
        }
        else
        {
            strng = [NSMutableString stringWithFormat:@"%@",@"所有會員皆適用"];
            self.yellowtitle.hidden = YES;
            self.yellowimage_view.hidden = YES;
            //[self.backimage_view setImage:[UIImage imageNamed:@"exchangeBgIMG"]];
        }
        
    }
    else
    {
        strng = [NSMutableString stringWithFormat:@"%@",@"所有會員皆適用"];
        self.yellowtitle.hidden = YES;
        [self.backimage_view setImage:[UIImage imageNamed:@"exchangeBgIMG"]];
    }
    
}

/*按照当前时间，过滤符合时间段的任务，并记录任务 id*/
-(BOOL)getconditionsEvent:(NSString*)startTime  end:(NSString*)endTime current:(NSDate*)curTime
{
    BOOL is_OKEvent = NO;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]]; // 设置为公历
        [formatter setTimeZone:[NSTimeZone localTimeZone]]; // 设置本地时区
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    NSDate *date1 = [formatter dateFromString:startTime];
    NSDate *date2 = [formatter dateFromString:endTime];
    
    NSDate *dateToCheck = curTime; // 需要检查的日期
    NSDate *startDate = date1; // 起始日期
    NSDate *endDate = date2; // 结束日期
     
    NSTimeInterval intervalToStart = [dateToCheck timeIntervalSinceDate:startDate];
    NSTimeInterval intervalToEnd = [endDate timeIntervalSinceDate:dateToCheck];
     
    if (intervalToStart >= 0 && intervalToEnd >= 0) {
        NSLog(@"日期在两个时间段内");
        is_OKEvent = YES;
    } else {
        NSLog(@"日期不在两个时间段内");
    }
    
    return is_OKEvent;
}

@end






@interface UsedAlreadyTBViewCell ()

@property (nonatomic,strong) UIImageView *picture_ed;
@property (nonatomic,strong) UILabel *title_ed;
@property (nonatomic,strong) UILabel *goodsName_ed;
@property (nonatomic,strong) UILabel *dateTime_ed;
@end

@implementation UsedAlreadyTBViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"UsedAlreadyTBViewCell";
    UsedAlreadyTBViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
          cell = [[UsedAlreadyTBViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//cell选中无色
    //  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//箭头
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.backgroundColor = [UIColor clearColor];
        
        UIView *baseView = [UIView new];
        baseView.layer.masksToBounds = true;
        baseView.layer.cornerRadius = ScaleW(8);
        baseView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:baseView];
        [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleW(20));
            make.left.mas_equalTo(ScaleW(20));
            make.right.mas_equalTo(-ScaleW(20));
            make.bottom.mas_equalTo(0);
        }];
        
        self.picture_ed = [UIImageView new];
        self.picture_ed.image = [UIImage imageNamed:@"FamilyCard2"];
        self.picture_ed.layer.masksToBounds = true;
        self.picture_ed.layer.cornerRadius = ScaleW(8);
        self.picture_ed.backgroundColor = [UIColor whiteColor];
        [baseView addSubview:self.picture_ed];
        [self.picture_ed mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(ScaleW(20));
            make.width.mas_equalTo(ScaleW(96));
            make.height.mas_equalTo(ScaleW(96));
        }];
        UILabel *titleLb = [UILabel new];
        titleLb.layer.masksToBounds = true;
        titleLb.layer.cornerRadius = ScaleW(8);
        titleLb.text = @"已使用";
        titleLb.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        titleLb.textAlignment = NSTextAlignmentCenter;
        titleLb.textColor = UIColor.whiteColor;
        titleLb.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightSemibold];
        [baseView addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(ScaleW(20));
            make.width.mas_equalTo(ScaleW(96));
            make.height.mas_equalTo(ScaleW(96));
        }];
        
        
        self.title_ed = [UILabel new];
        self.title_ed.text = @"特別優惠";
        self.title_ed.numberOfLines = 0;
        self.title_ed.textAlignment = NSTextAlignmentLeft;
        self.title_ed.textColor = UIColor.blackColor;
        self.title_ed.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightMedium];
        [baseView addSubview:self.title_ed];
        [self.title_ed mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleW(24));
            make.left.equalTo(self.picture_ed.mas_right).offset(ScaleW(20));
            make.right.mas_equalTo(-ScaleW(20));
            make.height.mas_equalTo(ScaleW(60));
        }];

        self.goodsName_ed = [UILabel new];
        self.goodsName_ed.text = @"";
        self.goodsName_ed.numberOfLines = 2;
        self.goodsName_ed.textColor = rgba(23, 23, 23, 1);
        self.goodsName_ed.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightMedium];
        [baseView addSubview:self.goodsName_ed];
        [self.goodsName_ed mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.title_ed.mas_bottom).offset(ScaleW(10));
            make.left.equalTo(self.picture_ed.mas_right).offset(ScaleW(20));
            make.right.mas_equalTo(-ScaleW(20));
        }];
        
        self.dateTime_ed = [UILabel new];
        self.dateTime_ed.text = @"";
        self.dateTime_ed.numberOfLines = 1;
        self.dateTime_ed.textColor = rgba(115, 115, 115, 1);
        self.dateTime_ed.font = [UIFont systemFontOfSize:FontSize(12) weight:UIFontWeightRegular];
        [baseView addSubview:self.dateTime_ed];
        [self.dateTime_ed mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.goodsName_ed.mas_bottom).offset(ScaleW(10));
            make.left.equalTo(self.picture_ed.mas_right).offset(ScaleW(20));
            make.right.mas_equalTo(-ScaleW(20));
            make.bottom.mas_equalTo(-ScaleW(10));
        }];
        
    }
    return self;
}

-(void)updateUI
{
    [self.picture_ed sd_setImageWithURL:[self.info objectForKey:@"coverImage"]];
    self.title_ed.text = [self.info objectForKey:@"couponName"];;
    
    NSString *sdate_string = [self.info objectForKey:@"claimStartAt"];
    NSString *edate_string = [self.info objectForKey:@"claimEndAt"];
    if([sdate_string isKindOfClass:[NSString class]]&&
           [edate_string isKindOfClass:[NSString class]])
    {
        
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
        self.dateTime_ed.text = range_time;
    }
    else
        self.dateTime_ed.text = @"";
}
@end

