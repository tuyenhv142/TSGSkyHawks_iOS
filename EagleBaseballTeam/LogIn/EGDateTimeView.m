//
//  EGDateTimeView.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/13.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGDateTimeView.h"


#define screenWith  [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height


@interface EGDateTimeView ()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSInteger yearRange;
    NSInteger dayRange;
    NSInteger startYear;
    NSInteger selectedYear;
    NSInteger selectedMonth;
    NSInteger selectedDay;
    NSInteger selectedHour;
    NSInteger selectedMinute;
    NSInteger selectedSecond;
    NSCalendar *calendar;
    //右边的确定按钮
    UIButton *chooseButton;
}
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic,strong) NSString *string;

@end


@implementation EGDateTimeView

-(void)addViewToWindow
{
    [[[UIApplication sharedApplication].windows firstObject] addSubview:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark --- 002 时间选择器
- (instancetype)initWithDatePickerModeType:(DatePickerViewMode)type
{
    self = [super initWithFrame:CGRectMake(0, 0, screenWith, screenHeight)];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.pickerViewMode = type;
        [self createDateTimeView];
    }
    return self;
}

-(void)createDateTimeView
{
    UIView *bottomView = [UIView new];
    bottomView.layer.cornerRadius = 0;
    bottomView.layer.masksToBounds = YES;
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-[UIDevice de_safeDistanceBottom]);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(ScaleH(243));
    }];
    UIView *bView = [[UIView alloc] init];
    bView.backgroundColor = rgba(243, 243, 243, 1);
    [bottomView addSubview:bView];
    [bView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(ScaleW(44));
        make.right.mas_equalTo(0);
    }];
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"完成" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightBold];
    [sureBtn setTitleColor:rgba(16, 94, 254, 1) forState:UIControlStateNormal];
    sureBtn.backgroundColor = rgba(243, 243, 243, 1);
    [sureBtn addTarget:self action:@selector(dateSureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [bView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(ScaleW(44));
        make.right.mas_equalTo(-ScaleW(24));
    }];
    UIPickerView *pickerView = [[UIPickerView alloc]init];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [bottomView addSubview:pickerView];
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(44));
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    self.pickerView = pickerView;
    
    NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps ;//= [[NSDateComponents alloc] init]
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    comps = [calendar0 components:unitFlags fromDate:[NSDate date]];
    NSInteger year = [comps year];
    
    startYear = 1900;//起始 年 时间
    yearRange = year - 1899;//总 年 长
    
    [self setCurrentDate:[NSDate date]];
}
-(void)dateSureBtnAction
{
    NSString *str = _string;
    
    if ([self.delegate respondsToSelector:@selector(selectTimeToReturnString:)]) {
        [self.delegate selectTimeToReturnString:str];
    }
    [self removeFromSuperview];
}
#pragma mark -- UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.pickerViewMode == DatePickerViewDateTimeMode) {
        return 5;
    }else if (self.pickerViewMode == DatePickerViewDateNoDayMode){
        return 2;
    }else if (self.pickerViewMode == DatePickerViewDateMode){
        return 3;
    }else if (self.pickerViewMode == DatePickerViewTimeMode){
        return 2;
    }else if (self.pickerViewMode == DatePickerViewDateYearMode){
        return 1;
    }
    return 0;
}
//确定每一列返回的东西
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.pickerViewMode == DatePickerViewDateTimeMode) {
        switch (component) {
            case 0:
            {
                return yearRange;
            }
                break;
            case 1:
            {
                return 12;
            }
                break;
            case 2:
            {
                return dayRange;
            }
                break;
            case 3:
            {
                return 24;
            }
                break;
            case 4:
            {
                return 60;
            }
                break;
                
            default:
                break;
        }
    }else if (self.pickerViewMode == DatePickerViewDateNoDayMode){//年月
        switch (component) {
            case 0:
            {
                return yearRange;
            }
                break;
            case 1:
            {
                return 12;
            }
                break;
                
            default:
                break;
        }
    }else if (self.pickerViewMode == DatePickerViewDateMode){
        switch (component) {
            case 0:
            {
                return yearRange;
            }
                break;
            case 1:
            {
                return 12;
            }
                break;
            case 2:
            {
                return dayRange;
            }
                break;
    
            default:
                break;
        }
    }else if (self.pickerViewMode == DatePickerViewTimeMode){
        switch (component) {
            
            case 0:
            {
                return 24;
            }
                break;
            case 1:
            {
                return 60;
            }
                break;
                
            default:
                break;
        }
    }else if (self.pickerViewMode == DatePickerViewDateYearMode){//年
        switch (component) {
            case 0:
            {
                return yearRange;
            }
                break;
            default:
                break;
        }
    }
    return 0;
}
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    CGFloat ww = screenWith - ScaleW(78);
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(ww * component/2.0, 0, ww / 2.0, ScaleW(44))];
    label.font=[UIFont systemFontOfSize:FontSize(18) weight:(UIFontWeightBold)];
    label.tag=component*100+row;
    label.textAlignment=NSTextAlignmentCenter;
    
    if (self.pickerViewMode == DatePickerViewDateTimeMode) {
        label.frame = CGRectMake(ww * component/6.0, 0, ww / 6.0, ScaleW(44));
        switch (component) {
            case 0:
            {
                label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
            }
                break;
            case 1:
            {
                label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
            }
                break;
            case 2:
            {

                label.text=[NSString stringWithFormat:@"%ld日",(long)row+1];
            }
                break;
            case 3:
            {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld時",(long)row];
            }
                break;
            case 4:
            {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld分",(long)row];
            }
                break;
            case 5:
            {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld秒",(long)row];
            }
                break;
                
            default:
                break;
        }
    }else if (self.pickerViewMode == DatePickerViewDateNoDayMode){
        label.frame = CGRectMake(ww * component/2.0, 0, ww / 2.0, ScaleW(44));
        switch (component) {
            case 0:
            {
                label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
            }
                break;
            case 1:
            {
                label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
            }
                break;
            default:
                break;
        }

    }else if (self.pickerViewMode == DatePickerViewDateMode){
        switch (component) {
            case 0:
            {
                label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
            }
                break;
            case 1:
            {
                label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
            }
                break;
            case 2:
            {
                label.text=[NSString stringWithFormat:@"%ld日",(long)row+1];
            }
                break;
                
            default:
                break;
        }
    }else if (self.pickerViewMode == DatePickerViewTimeMode){
        switch (component) {
            case 0:
            {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld時",(long)row];
            }
                break;
            case 1:
            {
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld分",(long)row];
            }
                break;
                
            default:
                break;
        }
    }else if (self.pickerViewMode == DatePickerViewDateYearMode){
        switch (component) {
            case 0:
            {
                label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
            }
                break;
            default:
                break;
        }
    }
    return label;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    CGFloat ww = screenWith - ScaleW(78);
    
    if (self.pickerViewMode == DatePickerViewDateTimeMode) {
        return ([UIScreen mainScreen].bounds.size.width-40)/5;
    }else if (self.pickerViewMode == DatePickerViewDateNoDayMode){
        return ww / 2;
    }else if (self.pickerViewMode == DatePickerViewDateMode){
        return ([UIScreen mainScreen].bounds.size.width-40)/3;
    }else if (self.pickerViewMode == DatePickerViewTimeMode){
        return ([UIScreen mainScreen].bounds.size.width-40)/2;
    }else if (self.pickerViewMode == DatePickerViewDateYearMode){
        return ww;
    }
    return 0;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return ScaleH(44);
}
// 监听picker的滑动
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.pickerViewMode == DatePickerViewDateTimeMode) {
        switch (component) {
            case 0:
            {
                selectedYear = startYear + row;
                dayRange = [self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 1:
            {
                selectedMonth = row+1;
                dayRange = [self isAllDay:selectedYear andMonth:selectedMonth];
                if (dayRange < selectedDay) {
                    selectedDay = dayRange;
                }
                [self.pickerView reloadComponent:2];
            }
                break;
            case 2:
            {
                selectedDay = row + 1;
            }
                break;
            case 3:
            {
                selectedHour = row;
            }
                break;
            case 4:
            {
                selectedMinute = row;
            }
                break;
                
            default:
                break;
        }
        _string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld",selectedYear,selectedMonth,selectedDay,selectedHour,selectedMinute];
    }else if (self.pickerViewMode == DatePickerViewDateNoDayMode){
        switch (component) {
            case 0:
            {
                selectedYear=startYear + row;
            }
                break;
            case 1:
            {
                selectedMonth=row+1;
            }
                break;
            default:
                break;
        }
        _string =[NSString stringWithFormat:@"%ld-%.2ld",selectedYear,selectedMonth];
    }else if (self.pickerViewMode == DatePickerViewDateMode){
        switch (component) {
            case 0:
            {
                selectedYear=startYear + row;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 1:
            {
                selectedMonth=row+1;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                if (dayRange < selectedDay) {
                    selectedDay = dayRange;
                }
                [self.pickerView reloadComponent:2];
            }
                break;
            case 2:
            {
                selectedDay=row+1;
            }
                break;
                
            default:
                break;
        }
        
        _string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld",selectedYear,selectedMonth,selectedDay];
    }else if (self.pickerViewMode == DatePickerViewTimeMode){
        switch (component) {
            case 0:
            {
                selectedHour=row;
            }
                break;
            case 1:
            {
                selectedMinute=row;
            }
                break;
            default:
                break;
        }
        _string =[NSString stringWithFormat:@"%.2ld:%.2ld",selectedHour,selectedMinute];
        
    }else if (self.pickerViewMode == DatePickerViewDateYearMode){
        switch (component) {
            case 0:
            {
                selectedYear = startYear + row;
            }
                break;
            default:
                break;
        }
        _string = [NSString stringWithFormat:@"%ld",selectedYear];
    }
}
-(NSInteger)isAllDay:(NSInteger)year andMonth:(NSInteger)month
{
    int day=0;
    switch(month)
    {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            day=31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            day=30;
            break;
        case 2:
        {
            if(((year%4==0)&&(year%100!=0))||(year%400==0)){
                day=29;
                break;
            }else{
                day=28;
                break;
            }
        }
        default:
            break;
    }
    return day;
}


#pragma mark -- 默认时间的处理
-(void)setCurrentDate:(NSDate *)currentDate
{
    //获取当前时间
    NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps;// = [[NSDateComponents alloc] init]
    NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    comps = [calendar0 components:unitFlags fromDate:currentDate];
    NSInteger year=[comps year];
    NSInteger month=[comps month];
    NSInteger day=[comps day];
    NSInteger hour=[comps hour];
    NSInteger minute=[comps minute];
    
    selectedYear = year;
    selectedMonth = month;
    selectedDay = day;
    selectedHour = hour;
    selectedMinute = minute;
    
    dayRange = [self isAllDay:year andMonth:month];
    
    if (self.pickerViewMode == DatePickerViewDateTimeMode) {
        
        [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
        [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
        [self.pickerView selectRow:day-1 inComponent:2 animated:NO];
        [self.pickerView selectRow:hour inComponent:3 animated:NO];
        [self.pickerView selectRow:minute inComponent:4 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
        [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
        [self pickerView:self.pickerView didSelectRow:day-1 inComponent:2];
        [self pickerView:self.pickerView didSelectRow:hour inComponent:3];
        [self pickerView:self.pickerView didSelectRow:minute inComponent:4];
        
        
    }else if (self.pickerViewMode == DatePickerViewDateNoDayMode){
        
        [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
        [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
        [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
        [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
        
    }else if (self.pickerViewMode == DatePickerViewDateMode){
        
        [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
        [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
        [self.pickerView selectRow:day-1 inComponent:2 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
        [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
        [self pickerView:self.pickerView didSelectRow:day-1 inComponent:2];
        
    }else if (self.pickerViewMode == DatePickerViewTimeMode){
        
        [self.pickerView selectRow:hour inComponent:0 animated:NO];
        [self.pickerView selectRow:minute inComponent:1 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:hour inComponent:0];
        [self pickerView:self.pickerView didSelectRow:minute inComponent:1];
        
    }else if (self.pickerViewMode == DatePickerViewDateYearMode){
        
        [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
    }

    [self.pickerView reloadAllComponents];
}

@end
