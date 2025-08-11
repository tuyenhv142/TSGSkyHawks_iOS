//
//  EGActivityExchangeTBViewCell.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/4/27.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGActivityExchangeTBViewCell.h"

@interface EGActivityExchangeTBViewCell ()

@property (nonatomic,strong) UIImageView *picture;
@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UILabel *dateTime;
@property (nonatomic,strong) UIImageView *yellowcornerimageView;//右上角半黄色图片
@property (nonatomic,strong) UILabel *yellowclabel;
@end

@implementation EGActivityExchangeTBViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"EGActivityExchangeTBViewCell";
    EGActivityExchangeTBViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
          cell = [[EGActivityExchangeTBViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class
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
        self.picture = [UIImageView new];
        self.picture.image = [UIImage imageNamed:@"FamilyCard2"];
        self.picture.contentMode = UIViewContentModeScaleAspectFit;
        self.picture.layer.masksToBounds = true;
        self.picture.layer.cornerRadius = ScaleW(0);
        self.picture.backgroundColor = [UIColor whiteColor];
        [baseView addSubview:self.picture];
        [self.picture mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(ScaleW(188));
        }];
        
        self.dateTime = [UILabel new];
        self.dateTime.text = @"";
        self.dateTime.textColor = rgba(0, 78, 162, 1);
        self.dateTime.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightMedium];
        [baseView addSubview:self.dateTime];
        [self.dateTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.picture.mas_bottom).offset(ScaleW(10));
            make.left.mas_equalTo(ScaleW(20));
            make.right.mas_equalTo(-ScaleW(20));
        }];
        
        self.yellowcornerimageView = [[UIImageView alloc]init];
        self.yellowcornerimageView.contentMode = UIViewContentModeScaleToFill;
        self.yellowcornerimageView.image = [UIImage imageNamed:@"Vector 1"];
        [baseView addSubview:self.yellowcornerimageView];
        [self.yellowcornerimageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleW(5));
            make.right.mas_equalTo(-ScaleW(5));
            make.width.mas_equalTo(ScaleW(80));
            make.height.mas_equalTo(ScaleW(17));
        }];
        
        self.yellowclabel = [UILabel new];
        self.yellowclabel.text = @"鷹國會員限定";
        self.yellowclabel.textAlignment = NSTextAlignmentCenter;
        self.yellowclabel.numberOfLines = 0;
        self.yellowclabel.textColor = UIColor.whiteColor;
        self.yellowclabel.font = [UIFont systemFontOfSize:FontSize(12) weight:UIFontWeightRegular];
        [baseView addSubview:self.yellowclabel];
        [self.yellowclabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.yellowcornerimageView.mas_top);
            make.centerX.mas_equalTo(self.yellowcornerimageView.mas_centerX);
            make.width.mas_equalTo(ScaleW(100));
            make.height.mas_equalTo(ScaleW(17));
        }];
        
        
        self.title = [UILabel new];
        self.title.text = @"";
        self.title.numberOfLines = 0;
        self.title.textColor = rgba(64, 64, 64, 1);
        self.title.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightSemibold];
        [baseView addSubview:self.title];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dateTime.mas_bottom).offset(ScaleW(10));
            make.left.mas_equalTo(ScaleW(20));
            make.right.mas_equalTo(-ScaleW(20));
            make.bottom.mas_equalTo(-ScaleW(10));
        }];
    
        
    }
    return self;
}

-(void)updateUI
{
    if(self.info)
    {
        [self.picture sd_setImageWithURL:[self.info objectForKey:@"coverImage"]];
        
        NSString *sdate_string = [self.info objectForKey:@"redeemStartAt"];
        if([sdate_string isKindOfClass:[NSString class]])
        {
            NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
            [inputFormatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]]; // 设置为公历
                [inputFormatter setTimeZone:[NSTimeZone localTimeZone]]; // 设置本地时区
            [inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
            NSDate *sdate = [inputFormatter dateFromString:sdate_string];
            
            NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
            [outputFormatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]]; // 设置为公历
                [outputFormatter setTimeZone:[NSTimeZone localTimeZone]]; // 设置本地时区
            [outputFormatter setDateFormat:@"yyyy/MM/dd"];
            NSString *sformattedDate = [self getWeek:[outputFormatter stringFromDate:sdate]];
            self.dateTime.text = sformattedDate;
        }
        else
            self.dateTime.text = @"";
        
        self.title.text = [self.info objectForKey:@"couponName"];
        
        self.yellowclabel.hidden = NO;
        self.yellowcornerimageView.hidden = NO;
        NSString* criter = [self.info objectForKey:@"eligibilityCriteria"];
        if([criter isKindOfClass:[NSString class]])
        {
            if([criter isEqualToString:@"memberCard"])
            {
                self.yellowcornerimageView.image = [UIImage imageNamed:@"Vector 1"];
                NSArray* criter_mem = [self.info objectForKey:@"eligibleMembers"];
                if([criter_mem isKindOfClass:[NSArray class]]){
                    if(criter_mem.count>1)
                        self.yellowclabel.text = @"鷹國會員";
                    
                    if(criter_mem.count==1){
                        NSString* string = [criter_mem objectAtIndex:0];
                        if([string isEqualToString:@"A001"])
                            self.yellowclabel.text = @"鷹國皇家";
                        if([string isEqualToString:@"A002"])
                            self.yellowclabel.text = @"鷹國尊爵";
                        if([string isEqualToString:@"A003"])
                            self.yellowclabel.text = @"Takao 親子卡";
                        if([string isEqualToString:@"A004"])
                            self.yellowclabel.text = @"鷹國人";
                    }
                    
                    if(criter_mem.count==0)
                    {
                        self.yellowclabel.hidden = YES;
                        self.yellowcornerimageView.hidden = YES;
                    }
                }
                else
                {
                    self.yellowclabel.hidden = YES;
                    self.yellowcornerimageView.hidden = YES;
                }
            }
            else
            {
                self.yellowclabel.hidden = YES;
                self.yellowcornerimageView.hidden = YES;
            }
        }
        else
        {
            self.yellowclabel.hidden = YES;
            self.yellowcornerimageView.hidden = YES;
        }
    }
    
}

-(NSString*)getWeek:(NSString *)date
{
    NSDateFormatter * weekDateFormatter =[[NSDateFormatter alloc]init];
    [weekDateFormatter setDateFormat:@"yyyy-MM-dd"];
    [weekDateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate * weekData =[weekDateFormatter dateFromString:date];
    NSCalendar * calendar =[[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents * comps =[[NSDateComponents alloc]init];
    
    NSInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth| NSCalendarUnitDay| NSCalendarUnitWeekday |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    calendar.locale =[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    
    comps  =[calendar components:unitFlags fromDate:weekData];
    NSArray * arr =@[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    
    return [NSString stringWithFormat:@"%ld/%ld/%ld  (%@)",(long)comps.year,(long)comps.month,(long)comps.day ,arr[comps.weekday-1]];
}
@end
