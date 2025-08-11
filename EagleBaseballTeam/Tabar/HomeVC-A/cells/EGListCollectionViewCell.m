//
//  EGListCollectionViewCell.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/1/23.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGListCollectionViewCell.h"

#import "EGScheduleModel.h"

@interface EGListCollectionViewCell ()

@property (nonatomic,strong) UILabel *vsLb;
@property (nonatomic,strong) UIImageView *rightImageView;

@property (nonatomic,strong) UILabel *dateLb;
@property (nonatomic,strong) UILabel *siteLb;
@property (nonatomic,strong) UIButton *calendarBtn;


@property (nonatomic,strong) UILabel *dateLb1;
@property (nonatomic,strong) UILabel *siteLb1;
@property (nonatomic,strong) UIButton *calendarBtn1;


@property (nonatomic,strong) UILabel *dateLb2;
@property (nonatomic,strong) UILabel *siteLb2;
@property (nonatomic,strong) UIButton *calendarBtn2;

@end


@implementation EGListCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.layer.cornerRadius = 10;
        self.contentView.layer.masksToBounds = true;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(292), ScaleW(56))];
        bgView.backgroundColor = UIColor.whiteColor;
        [self.contentView addSubview:bgView];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.startPoint = CGPointMake(0, 0.5);
        gradientLayer.endPoint = CGPointMake(1, 0.5);
        gradientLayer.frame = bgView.bounds;
//        gradientLayer.colors = @[(id)rgba(229, 229, 229, 0.8).CGColor,(id)rgba(163, 163, 163, 0.7).CGColor];
        gradientLayer.colors = @[(id)rgba(240, 240, 240, 1).CGColor,(id)rgba(204, 204, 204, 1).CGColor];
//        gradientLayer.colors = @[(id)rgba(10, 63, 145, 1).CGColor,(id)rgba(2, 25, 245, 0.5).CGColor];
        [bgView.layer insertSublayer:gradientLayer atIndex:0];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, ScaleW(292), ScaleH(56)) byRoundingCorners:UIRectCornerBottomRight | UIRectCornerBottomLeft cornerRadii:CGSizeMake(ScaleH(10),ScaleH(10))];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = CGRectMake(0, 0,  ScaleW(292), ScaleH(56));
        maskLayer.path = maskPath.CGPath;
        bgView.layer.mask = maskLayer;
        
        UIView *lindeCententView = [UIView new];
        lindeCententView.backgroundColor = rgba(229, 229, 229, 1);
        [self.contentView addSubview:lindeCententView];
        [lindeCententView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(1);
            make.left.mas_equalTo(ScaleW(16));
            make.right.mas_equalTo(-ScaleW(16));
            make.height.mas_equalTo(1);
        }];
        UIView *lindesecSecodeView = [UIView new];
        lindesecSecodeView.backgroundColor = rgba(229, 229, 229, 1);
        [self.contentView addSubview:lindesecSecodeView];
        [lindesecSecodeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lindeCententView.mas_bottom).offset(ScaleW(56));
            make.left.mas_equalTo(ScaleW(16));
            make.right.mas_equalTo(-ScaleW(16));
            make.height.mas_equalTo(1);
        }];
        
        [self.vsLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleW(16));
            make.left.mas_equalTo(ScaleW(15));
        }];
        
        [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleW(6));
            make.right.mas_equalTo(-ScaleW(16));
            make.width.mas_equalTo(ScaleW(44));
            make.height.mas_equalTo(ScaleW(44));
        }];
        
        //MARK: 000
        [self.dateLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lindeCententView.mas_top).offset(-ScaleW(20));
            make.left.mas_equalTo(ScaleW(16));
        }];
        [self.calendarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.dateLb);
            make.right.mas_equalTo(-ScaleW(16));
            make.width.mas_equalTo(ScaleW(27));
            make.height.mas_equalTo(ScaleW(25));
        }];
        [self.siteLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.dateLb);
            make.right.equalTo(self.calendarBtn.mas_left).offset(-ScaleW(8));
            make.left.equalTo(self.dateLb.mas_right).offset(ScaleW(5));
        }];
        
        //MARK: 001
        [self.dateLb1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lindeCententView.mas_bottom).offset(ScaleW(20));
            make.left.mas_equalTo(ScaleW(16));
        }];
        [self.calendarBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.dateLb1);
            make.right.mas_equalTo(-ScaleW(16));
            make.width.mas_equalTo(ScaleW(27));
            make.height.mas_equalTo(ScaleW(25));
        }];
        [self.siteLb1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.dateLb1);
            make.right.equalTo(self.calendarBtn1.mas_left).offset(-ScaleW(8));
            make.left.equalTo(self.dateLb1.mas_right).offset(ScaleW(5));
        }];
        
        //MARK: 002
        [self.dateLb2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lindesecSecodeView.mas_bottom).offset(ScaleW(20));
            make.left.mas_equalTo(ScaleW(16));
        }];
        [self.calendarBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.dateLb2);
            make.right.mas_equalTo(-ScaleW(16));
            make.width.mas_equalTo(ScaleW(27));
            make.height.mas_equalTo(ScaleW(25));
        }];
        [self.siteLb2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.dateLb2);
            make.right.equalTo(self.calendarBtn2.mas_left).offset(-ScaleW(8));
            make.left.equalTo(self.dateLb2.mas_right).offset(ScaleW(5));
        }];
    }
    return self;
}

- (UILabel *)vsLb
{
    if (!_vsLb) {
        _vsLb = [UILabel new];
        _vsLb.text = @"VS 樂天桃猿";
        _vsLb.textAlignment = NSTextAlignmentCenter;
        _vsLb.textColor = rgba(1, 1, 1, 1);
        _vsLb.font = [UIFont systemFontOfSize:FontSize(16) weight:(UIFontWeightSemibold)];
        [self.contentView addSubview:_vsLb];
    }
    return _vsLb;
}

- (UIImageView *)rightImageView
{
    if (!_rightImageView) {
        _rightImageView = [UIImageView new];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
        _rightImageView.image = [UIImage imageNamed:@"樂天桃猿"];
        [self.contentView addSubview:_rightImageView];
    }
    return _rightImageView;
}

#pragma mark - 000
- (UILabel *)dateLb
{
    if (!_dateLb) {
        _dateLb = [UILabel new];
        _dateLb.textAlignment = NSTextAlignmentLeft;
        _dateLb.text = @"01/04 (六) 18:30";
        _dateLb.textColor = rgba(64, 64, 64, 1);
        _dateLb.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightMedium];
        [self.contentView addSubview:_dateLb];
    }
    return _dateLb;
}
- (UILabel *)siteLb
{
    if (!_siteLb) {
        _siteLb = [UILabel new];
        _siteLb.textAlignment = NSTextAlignmentRight;
        _siteLb.text = @"澄清湖";
        _siteLb.textColor = rgba(115, 115, 115, 1);
        _siteLb.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
        [self.contentView addSubview:_siteLb];
    }
    return _siteLb;
}
- (UIButton *)calendarBtn
{
    if (!_calendarBtn) {
        _calendarBtn = [[UIButton alloc] init];
        _calendarBtn.tag = 24;
        [_calendarBtn setImage:[UIImage imageNamed:@"Group 796"] forState:UIControlStateNormal];
        [_calendarBtn addTarget:self action:@selector(calendarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_calendarBtn];
        _calendarBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -20);
    }
    return _calendarBtn;
}


#pragma mark - 001
- (UILabel *)dateLb1
{
    if (!_dateLb1) {
        _dateLb1 = [UILabel new];
        _dateLb1.textAlignment = NSTextAlignmentLeft;
        _dateLb1.text = @"01/04 (六) 18:30";
        _dateLb1.textColor = rgba(64, 64, 64, 1);
        _dateLb1.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightMedium];
        [self.contentView addSubview:_dateLb1];
    }
    return _dateLb1;
}
- (UILabel *)siteLb1
{
    if (!_siteLb1) {
        _siteLb1 = [UILabel new];
        _siteLb1.textAlignment = NSTextAlignmentRight;
        _siteLb1.text = @"澄清湖";
        _siteLb1.textColor = rgba(115, 115, 115, 1);
        _siteLb1.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
        [self.contentView addSubview:_siteLb1];
    }
    return _siteLb1;
}
- (UIButton *)calendarBtn1
{
    if (!_calendarBtn1) {
        _calendarBtn1 = [[UIButton alloc] init];
        _calendarBtn1.tag = 25;
        [_calendarBtn1 setImage:[UIImage imageNamed:@"Group 796"] forState:UIControlStateNormal];
        [_calendarBtn1 addTarget:self action:@selector(calendarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_calendarBtn1];
        _calendarBtn1.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -20);
    }
    return _calendarBtn1;
}

#pragma mark - 002
- (UILabel *)dateLb2
{
    if (!_dateLb2) {
        _dateLb2 = [UILabel new];
        _dateLb2.textAlignment = NSTextAlignmentLeft;
        _dateLb2.text = @"01/04 (六) 18:30";
        _dateLb2.textColor = rgba(64, 64, 64, 1);
        _dateLb2.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightMedium];
        [self.contentView addSubview:_dateLb2];
    }
    return _dateLb2;
}
- (UILabel *)siteLb2
{
    if (!_siteLb2) {
        _siteLb2 = [UILabel new];
        _siteLb2.textAlignment = NSTextAlignmentRight;
        _siteLb2.text = @"澄清湖";
        _siteLb2.textColor = rgba(115, 115, 115, 1);
        _siteLb2.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
        [self.contentView addSubview:_siteLb2];
    }
    return _siteLb2;
}
- (UIButton *)calendarBtn2
{
    if (!_calendarBtn2) {
        _calendarBtn2 = [[UIButton alloc] init];
        _calendarBtn2.tag = 26;
        [_calendarBtn2 setImage:[UIImage imageNamed:@"Group 796"] forState:UIControlStateNormal];
        [_calendarBtn2 addTarget:self action:@selector(calendarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_calendarBtn2];
        _calendarBtn2.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -20);
    }
    return _calendarBtn2;
}
#pragma mark - calendarBtnClick
-(void)calendarBtnClick:(UIButton *)sender
{
//    WS(weakSelf);
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"賽程訂閱" message:@"是否同意存取您的行事曆，以便輕鬆掌握比賽通知及賽程安排" preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction* defaultBtn = [UIAlertAction actionWithTitle:@"允許" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//        [weakSelf addCalendarBtnClick:sender.tag];
//    }];
//    [alert addAction:defaultBtn];
//    UIAlertAction* cancelBtn = [UIAlertAction actionWithTitle:@"不允許" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
//    }];
//    [alert addAction:cancelBtn];
//    UIViewController *rController= [UIApplication sharedApplication].windows.firstObject.rootViewController;
//    [rController presentViewController:alert animated:YES completion:nil];
    
//    NSString *message = @"是否同意存取您的行事曆，以便輕鬆掌握比賽通知及賽程安排";
//    [ELAlertController alertControllerWithTitleName:@"賽程訂閱" andMessage:message cancelButtonTitle:@"取消" confirmButtonTitle:@"確定" showViewController:rController addCancelClickBlock:^(UIAlertAction * _Nonnull cancelAction) {
//            
//        } addConfirmClickBlock:^(UIAlertAction * _Nonnull SureAction) {
//            [weakSelf addCalendarBtnClick:sender.tag];
//        }];
    
    [self addCalendarBtnClick:sender.tag];
}
-(void)addCalendarBtnClick:(NSInteger )index
{
    if (index== 24) {
        
        EGScheduleModel *model = [_dataArray firstObject];
        if (model) {
            [[EGEventStoreTool shareEvent] addEventToCalender:model];
        }
        
    }else if (index == 25){
        
        EGScheduleModel *model = [_dataArray objectAtIndex:1];
        if (model) {
            [[EGEventStoreTool shareEvent] addEventToCalender:model];
        }
        
    }else{
        
        EGScheduleModel *model = [_dataArray objectAtIndex:2];
        if (model) {
            [[EGEventStoreTool shareEvent] addEventToCalender:model];
        }
        
    }
}

- (void)setTeamCode:(NSString *)teamCode
{
    if ([teamCode containsString:@"臺北伊斯特"]) {
        self.vsLb.text = @"VS 臺北伊斯特";
        self.rightImageView.image = [UIImage imageNamed:@"臺北伊斯特"];
        
    }else if ([teamCode containsString:@"臺中連莊"]){
        self.vsLb.text = @"VS 臺中連莊";
        self.rightImageView.image = [UIImage imageNamed:@"臺中連莊"];
        
    }else if ([teamCode containsString:@"桃園雲豹"]){
        self.vsLb.text = @"VS 桃園雲豹";
        self.rightImageView.image = [UIImage imageNamed:@"桃園雲豹"];
        
//    }else if ([teamCode containsString:@"ACN011"]){
//        
//        self.vsLb.text = @"VS 中信兄弟";
//        self.rightImageView.image = [UIImage imageNamed:@"中信兄弟3x_L"];
//        
//    }else if ([teamCode containsString:@"AJL011"]){
//        self.vsLb.text = @"VS 樂天桃猿";
//        self.rightImageView.image = [UIImage imageNamed:@"樂天桃猿3x_L"];
//    
    }else{
        self.vsLb.text = @"";
        self.rightImageView.image = [UIImage imageNamed:@"add"];
    }
}
- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
//    if (dataArray.count == 0)
    {
        self.dateLb.text = @"無賽事";
        self.siteLb.text = @"";
        self.calendarBtn.hidden = true;
        self.dateLb1.text = @"";
        self.siteLb1.text = @"";
        self.calendarBtn1.hidden = true;
        self.dateLb2.text = @"";
        self.siteLb2.text = @"";
        self.calendarBtn2.hidden = true;
    }
    
    for (int i = 0; i < dataArray.count; i++) {
        
        EGScheduleModel *model = [dataArray objectAtIndex:i];
        NSString *gameTimeStatr = model.GameDateTimeS;
        NSString *time = [gameTimeStatr substringWithRange:NSMakeRange(0, 16)];
        time = [time stringByReplacingOccurrencesOfString:@"T" withString:[self getWeek:model.GameDateTimeS]];
        time = [time stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
        if (i == 0) {
        
            self.dateLb.text = time;
            self.siteLb.text = model.FieldAbbe;
            self.calendarBtn.hidden = false;
            
        }else if (i == 1){
            
            self.dateLb1.text = time;
            self.siteLb1.text = model.FieldAbbe;
            self.calendarBtn1.hidden = false;
            
        }else if (i == 2){
            
            self.dateLb2.text = time;
            self.siteLb2.text = model.FieldAbbe;
            self.calendarBtn2.hidden = false;
            
        }
    }
    
}
//-(NSString *)getWeek:(NSString *)dayString
//{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    NSDate *dates = [formatter dateFromString:[dayString substringToIndex:10]];
//    
//    NSCalendar *calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSTimeZone *timeZone=[[NSTimeZone alloc]initWithName:@"Asia/Beijing"];
//    [calendar setTimeZone:timeZone];
//    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
//    NSDateComponents *components=[calendar components:calendarUnit fromDate:dates];
//    NSString *weekString;
//    switch (components.weekday) {
//        case 1:
//            weekString = @"(日)";
//            break;
//        case 2:
//            weekString = @"(一)";
//            break;
//        case 3:
//            weekString = @"(二)";
//            break;
//        case 4:
//            weekString = @"(三)";
//            break;
//        case 5:
//            weekString = @"(四)";
//            break;
//        case 6:
//            weekString = @"(五)";
//            break;
//        case 7:
//            weekString = @"(六)";
//            break;
//        default:
//            break;
//    }
//    return weekString;
//}

#pragma mark - 获取日期的周几
- (NSString *)getWeek:(NSString *)dayString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:[dayString substringToIndex:10]];
    
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
            weekString = @"(日)";
            break;
        case 2:
            weekString = @"(一)";
            break;
        case 3:
            weekString = @"(二)";
            break;
        case 4:
            weekString = @"(三)";
            break;
        case 5:
            weekString = @"(四)";
            break;
        case 6:
            weekString = @"(五)";
            break;
        case 7:
            weekString = @"(六)";
            break;
        default:
            weekString = @"未知";
            break;
    }
    
    return weekString;
}

@end
