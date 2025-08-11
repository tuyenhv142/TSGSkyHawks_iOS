//
//  EGActivityDetailTBViewCell.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/4/28.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGActivityDetailTBViewCell.h"

@interface EGActivityDetailTBViewCell ()

@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UILabel *descrip;
@property (nonatomic,strong) UILabel *point;
@end


@implementation EGActivityDetailTBViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)updateUI
{
    self.title.text = [self.info objectForKey:@"couponName"];
    self.point.text = [NSString stringWithFormat:@"%d 點",[[self.info objectForKey:@"pointCost"] intValue]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"EGActivityDetailTBViewCell";
    EGActivityDetailTBViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
          cell = [[EGActivityDetailTBViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//cell选中无色
    //  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//箭头
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.backgroundColor = [UIColor whiteColor];
        
        
        UIView *baseView = self.contentView;
        
        self.title = [UILabel new];
        self.title.text = @"THANK YOU FANS！北部鷹台鋼天鷹來了 (臺北大巨蛋簽名會)";
        self.title.numberOfLines = 0;
        self.title.textColor = rgba(64, 64, 64, 1);
        self.title.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightSemibold];
        [baseView addSubview:self.title];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleW(20));
            make.left.mas_equalTo(ScaleW(20));
            make.right.mas_equalTo(-ScaleW(20));
        }];
        
        self.descrip = [UILabel new];
        self.descrip.text = @"THANK YOU FANS！北部鷹台鋼天鷹來了 (臺北大巨蛋簽名會)";
        self.descrip.numberOfLines = 0;
        self.descrip.textColor = rgba(82, 82, 82, 1);
        self.descrip.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
        [baseView addSubview:self.descrip];
        [self.descrip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.title.mas_bottom).offset(ScaleW(10));
            make.left.mas_equalTo(ScaleW(20));
            make.right.mas_equalTo(-ScaleW(20));
        }];
        self.descrip.hidden = YES;
        
        
        UIView *pointView = [UIView new];
        pointView.layer.masksToBounds = true;
        pointView.layer.cornerRadius = ScaleW(8);
        pointView.backgroundColor = rgba(237, 245, 243, 1);
        [self.contentView addSubview:pointView];
        [pointView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.title.mas_bottom).offset(ScaleW(20));
            make.left.mas_equalTo(ScaleW(20));
            make.right.mas_equalTo(-ScaleW(20));
            make.height.mas_equalTo(ScaleW(52));
            make.bottom.mas_equalTo(-ScaleW(20));
        }];
        
        UILabel *titleLb = [UILabel new];
        titleLb.text = @"兌換點數";
        titleLb.textColor = rgba(64, 64, 64, 1);
        titleLb.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightMedium];
        [pointView addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(ScaleW(20));
        }];
        
        self.point = [UILabel new];
        self.point.text = @"50 點";
        self.point.textColor = rgba(64, 64, 64, 1);
        self.point.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightMedium];
        [pointView addSubview:self.point];
        [self.point mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-ScaleW(20));
        }];
        
    }
    return self;
}
@end



@interface ActivityDescriptionTBViewCell ()

@property (nonatomic,strong) UILabel *titleDes;
@property (nonatomic,strong) UILabel *descripDes;
@property (nonatomic,strong)CAShapeLayer *line_shapeLayer;

@end

@implementation ActivityDescriptionTBViewCell
+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"ActivityDescriptionTBViewCell";
    ActivityDescriptionTBViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
          cell = [[ActivityDescriptionTBViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//cell选中无色
    //  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//箭头
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.backgroundColor = [UIColor whiteColor];
        
        UIView *baseView = self.contentView;
        
        self.titleDes = [UILabel new];
        self.titleDes.text = @"兌換地點";
        self.titleDes.textColor = rgba(0, 122, 96, 1);
        self.titleDes.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
        [baseView addSubview:self.titleDes];
        [self.titleDes mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleW(20));
            make.left.mas_equalTo(ScaleW(20));
            make.right.mas_equalTo(-ScaleW(20));
        }];
        
        self.descripDes = [UILabel new];
        self.descripDes.text = @"";
        self.descripDes.numberOfLines = 0;
        self.descripDes.textColor = rgba(64, 64, 64, 1);
        self.descripDes.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
        [baseView addSubview:self.descripDes];
        [self.descripDes mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleDes.mas_bottom).offset(ScaleW(10));
            make.left.mas_equalTo(ScaleW(20));
            make.right.mas_equalTo(-ScaleW(20));
            make.bottom.mas_equalTo(-ScaleW(20));
        }];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(ScaleW(20), self.contentView.bounds.origin.y)];
        [path addLineToPoint:CGPointMake(Device_Width - ScaleW(20), self.contentView.bounds.origin.y)];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        shapeLayer.lineWidth = 1.0;
        shapeLayer.lineDashPattern = @[@2, @3]; // 虚线模式
        [self.contentView.layer addSublayer:shapeLayer];
        self.line_shapeLayer = shapeLayer;
        
    }
    return self;
}

-(void)updateUI
{
    if(self.ui_type==0){
        if(self.cell_typ==0)
        {
            self.titleDes.text = @"活動期間";
            NSString *sdate_string = [self.info objectForKey:@"redeemStartAt"];
            NSString *edate_string = [self.info objectForKey:@"redeemEndAt"];
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
                [outputFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                [outputFormatter setDateFormat:@"yyyy/MM/dd"];
                NSString *sformattedDate = [outputFormatter stringFromDate:sdate];
                NSString *start_time = sformattedDate;
                
                NSString *eformattedDate = [outputFormatter stringFromDate:newEndDate];
                NSString *end_time = eformattedDate;
                
                NSString *range_time = [NSString stringWithFormat:@"%@~%@",start_time,end_time];
                self.descripDes.text = range_time;
            }
            else
                self.descripDes.text = @"";
        }
        else if(self.cell_typ==1)
        {
            self.titleDes.text = @"兌換對象";
            NSMutableString *strng = [NSMutableString new];
            NSString* criter = [self.info objectForKey:@"eligibilityCriteria"];
            if([criter isKindOfClass:[NSString class]])
            {
                if([criter isEqualToString:@"memberCard"])
                {
                    NSArray* criter_mem = [self.info objectForKey:@"eligibleMembers"];
                    if([criter_mem isKindOfClass:[NSArray class]]){
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
                            self.descripDes.text = strng;
                        }
                    }
                    else
                        self.descripDes.text = @"所有會員皆適用";
                    
                }
                else
                    self.descripDes.text = @"所有會員皆適用";
               
            }
            else
              self.descripDes.text = @"所有會員皆適用";
        }
        else if(self.cell_typ==2)
        {
            self.titleDes.text = @"全站數量";;
            
            int total = [[self.info objectForKey:@"totalQuantity"] intValue];
            NSString *per = @"";
            if(total!=-1)
                per = [NSString stringWithFormat:@"%d",total];
            else
                per = @"無上限";
            
            self.descripDes.text = per;//self.address;
            
        }
        else if(self.cell_typ==3){
            //self.titleDes.text = @"使用規則";
            self.descripDes.text = [self.info objectForKey:@"usageRules"];
        }
        
        if(self.cell_typ==0)
            self.line_shapeLayer.hidden = YES;
        else
            self.line_shapeLayer.hidden = NO;
    }
    else
    {
        if(self.cell_typ==1)
        {
            self.titleDes.text = @"活動期間";
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
                self.descripDes.text = range_time;
            }
            else
                self.descripDes.text = @"";
        }
        else if(self.cell_typ==0)
        {
            self.titleDes.text = @"使用狀態";
            NSString *point_status = @"未使用";
            switch (self.stauts) {
                    case 0:
                        point_status = @"未使用";
                        break;
                    case 1:
                    point_status = @"已鎖定";
                    break;
                    case 2:
                        point_status = @"已使用";
                        break;
                }
            self.descripDes.text = point_status;
        }
        else if(self.cell_typ==2)
        {
            self.titleDes.text = @"兌換地點";;
            self.descripDes.text = self.address;
            
        }
        else if(self.cell_typ==3){
            //self.titleDes.text = @"使用規則";
            self.descripDes.text = [self.info objectForKey:@"usageRules"];
        }
        
        if(self.cell_typ==0)
            self.line_shapeLayer.hidden = YES;
        else
            self.line_shapeLayer.hidden = NO;
    }
}
@end
