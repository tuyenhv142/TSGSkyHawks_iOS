//
//  OABtnImgCollectionViewCell.m
//  NewsoftOA24
//
//  Created by dragon_zheng on 2024/5/9.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import "EGClassDateCollectionViewCell.h"
@implementation EGClassDateCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self.contentView addSubview:self.baseView];
        [self.baseView addSubview:self.titleLA];
        [self.baseView addSubview:self.titleLB];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(0));
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.titleLA mas_makeConstraints:^(MASConstraintMaker *make) {
             make.height.mas_equalTo(ScaleW(24));
             make.centerX.mas_equalTo(self.baseView.mas_centerX);
             make.top.mas_equalTo(ScaleW(30));
             make.width.mas_equalTo(ScaleW(24));
         }];
    
    
   [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(ScaleW(34));
            make.centerX.mas_equalTo(self.baseView.mas_centerX);
            make.top.mas_equalTo(self.titleLA.mas_bottom).offset(ScaleW(5));
            make.width.mas_equalTo(ScaleW(34));
        }];
    
    
}

- (UIView *)baseView
{
    if (_baseView == nil) {
        _baseView = [[UIView alloc] init];
//        _baseView.backgroundColor = [UIColor yellowColor];
        _baseView.layer.cornerRadius = 10;
        _baseView.layer.masksToBounds = YES;
        _baseView.layer.borderColor = UIColor.whiteColor.CGColor;
        _baseView.layer.borderWidth = 1.0;
    }
    return _baseView;
}

- (DashedBorderLabel *)titleLB
{
    if (_titleLB == nil) {
        _titleLB = [[DashedBorderLabel alloc] init];
        _titleLB.text = @"";
        _titleLB.layer.cornerRadius = ScaleW(34)/2;
        _titleLB.layer.masksToBounds = YES;
        _titleLB.textColor = [UIColor blackColor];
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightBold];
    }
    return _titleLB;
}
    

- (UILabel *)titleLA
{
    if (_titleLA == nil) {
        _titleLA = [[UILabel alloc] init];
        _titleLA.text = @"";
        _titleLA.textColor = ColorRGB(0xA3A3A3);
        _titleLA.textAlignment = NSTextAlignmentCenter;
        _titleLA.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
    }
    return _titleLA;
}

-(void) setInfo:(NSString *)info iscurrentdate:(BOOL)is_current{
    
    NSString *day = [self getDay:info];
    NSString *week = [self getWeek:info];
    
    self.titleLA.text = week;
    self.titleLB.is_currentDate = is_current;
    self.titleLB.text  = day;
    
}

#pragma mark - 获取日期的周几
- (NSString *)getWeek:(NSString *)dayString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    //NSDate *date = [formatter dateFromString:[dayString substringToIndex:10]];
    NSDate * date =[formatter dateFromString:dayString];
    // 创建日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 获取日期的周几信息
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:date];
    
    // 获取周几的整数值（1: 周日, 2: 周一, ..., 7: 周六）
    NSInteger weekday = [components weekday];
    
    // 将周几的整数值转换为具体的周几名称
    NSString *weekString;
    switch (weekday) {
        case 1:
            weekString = @"日";
            break;
        case 2:
            weekString = @"一";
            break;
        case 3:
            weekString = @"二";
            break;
        case 4:
            weekString = @"三";
            break;
        case 5:
            weekString = @"四";
            break;
        case 6:
            weekString = @"五";
            break;
        case 7:
            weekString = @"六";
            break;
        
    }
    
    return weekString;
}


-(NSString*)getDay:(NSString *)date
{
    NSDateFormatter * weekDateFormatter =[[NSDateFormatter alloc]init];
    [weekDateFormatter setDateFormat:@"yyyy/MM/dd"];
    [weekDateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate * weekData =[weekDateFormatter dateFromString:date];
    NSCalendar * calendar =[[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents * comps =[[NSDateComponents alloc]init];
    
    NSInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth| NSCalendarUnitDay| NSCalendarUnitWeekday |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    calendar.locale =[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    
    comps  =[calendar components:unitFlags fromDate:weekData];
    //NSArray * arr =@[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    
    
    if(comps.day<10){
        return [NSString stringWithFormat:@"0%ld",(long)comps.day];
    }
    else
    return [NSString stringWithFormat:@"%ld",(long)comps.day];
}

@end
