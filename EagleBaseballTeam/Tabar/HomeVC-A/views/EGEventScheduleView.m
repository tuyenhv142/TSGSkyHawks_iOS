//
//  EGEventScheduleView.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/1/23.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGEventScheduleView.h"

#import "EGScheduleModel.h"

@interface EGEventScheduleView ()

@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIImageView *leftImageView;
@property (nonatomic,strong) UIImageView *rightImageView;

@property (nonatomic,strong) UILabel *dateLb;
@property (nonatomic,strong) UILabel *nameNumLb;
@property (nonatomic,strong) UILabel *leftScoreLb;
@property (nonatomic,strong) UILabel *rightScoreLb;

@property (nonatomic,strong) UIButton *reviewBtn;
@property (nonatomic,strong) UIButton *fansBtn;
@property (nonatomic,strong) UIView *line_v;

@property (nonatomic,strong) UILabel *vsLb;

@end

@implementation EGEventScheduleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, ScaleW(190))];
        [self addSubview:topView];
        // 使用 CAGradientLayer 设置背景色
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        gradientLayer.frame = topView.bounds;
        gradientLayer.colors = @[(id)rgba(0, 78, 162, 1).CGColor,(id)rgba(0, 121, 192, 1).CGColor];
        [topView.layer insertSublayer:gradientLayer atIndex:0];
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleW(20));
            make.left.mas_equalTo(ScaleW(20));
            make.right.mas_equalTo(-ScaleW(20));
            make.bottom.mas_equalTo(-ScaleW(20));
        }];
        
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
           // make.top.mas_equalTo(-ScaleW(20));
            make.width.mas_equalTo(ScaleW(144));
            make.height.mas_equalTo(ScaleW(192));
            make.centerY.mas_equalTo(0);
            make.centerX.mas_equalTo(ScaleW(45));
            //make.bottom.mas_equalTo(ScaleW(20));
        }];
        
        UILabel *vsLb = [UILabel new];
        vsLb.text = @"VS";
        vsLb.textAlignment = NSTextAlignmentCenter;
        vsLb.textColor = UIColor.whiteColor;
        vsLb.font = [UIFont systemFontOfSize:FontSize(16) weight:(UIFontWeightSemibold)];
        [self addSubview:vsLb];
        [vsLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.centerX.mas_equalTo(0);
//            make.width.mas_equalTo(ScaleW(30));
//            make.height.mas_equalTo(ScaleW(30));
        }];
        self.vsLb = vsLb;
        
        UIView *lindeView = [UIView new];
        lindeView.backgroundColor = rgba(255, 255, 255, 0.2);
        [self addSubview:lindeView];
        [lindeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-ScaleW(58));
            make.left.mas_equalTo(ScaleW(36));
            make.right.mas_equalTo(-ScaleW(36));
            make.height.mas_equalTo(0.6);
        }];
                
        [self.dateLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView.mas_top).offset(ScaleW(19));
            make.left.mas_equalTo(ScaleW(36));
        }];
        
        [self.nameNumLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView.mas_top).offset(ScaleW(19));
            make.right.mas_equalTo(-ScaleW(36));
        }];
        
        [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(ScaleW(45));
            make.width.mas_equalTo(ScaleW(55));
            make.height.mas_equalTo(ScaleW(55));
        }];
        [self.leftScoreLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.equalTo(self.leftImageView.mas_right).offset(ScaleW(10));
            make.right.equalTo(vsLb.mas_left).offset(-ScaleW(10));
        }];
        
        [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-ScaleW(45));
            make.width.mas_equalTo(ScaleW(55));
            make.height.mas_equalTo(ScaleW(55));
        }];
        [self.rightScoreLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.equalTo(self.rightImageView.mas_left).offset(-ScaleW(10));
            make.left.equalTo(vsLb.mas_right).offset(ScaleW(10));
        }];
        
        
        UIView *line_v = [UIView new];
        line_v.backgroundColor = rgba(255, 255, 255, 0.2);
        [self addSubview:line_v];
        [line_v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bgView.mas_bottom).offset(-ScaleW(5));
            make.top.equalTo(lindeView.mas_bottom).offset(ScaleW(5));
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(0.6);
        }];
        self.line_v = line_v;
        [self.reviewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-ScaleW(25));
            make.right.mas_equalTo(-ScaleW(70));
            make.left.mas_equalTo(ScaleW(70));//have fansBtn delete
        }];
        
//        [self.fansBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(-ScaleW(25));
//            make.left.mas_equalTo(ScaleW(70));
//        }];
    }
    return self;
}

- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [UIImageView new];
//        _bgImageView.layer.cornerRadius = 5;
//        _bgImageView.layer.masksToBounds = true;
//        _bgImageView.backgroundColor = rgba(0, 71, 56, 1);
        _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
        _bgImageView.image = [UIImage imageNamed:@"TSG-green"];
        [self.bgView addSubview:_bgImageView];
    }
    return _bgImageView;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.layer.cornerRadius = 5;
        _bgView.layer.masksToBounds = true;
        _bgView.backgroundColor = rgba(239, 245, 255, 0.5);
        [self addSubview:_bgView];
    }
    return _bgView;
}
- (UILabel *)dateLb
{
    if (!_dateLb) {
        _dateLb = [UILabel new];
        _dateLb.textAlignment = NSTextAlignmentLeft;
//        _dateLb.text = @"2025/01/04 (六) 18:30";
        _dateLb.textColor = UIColor.whiteColor;
        _dateLb.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
        [self addSubview:_dateLb];
    }
    return _dateLb;
}
- (UILabel *)nameNumLb
{
    if (!_nameNumLb) {
        _nameNumLb = [UILabel new];
        _nameNumLb.textAlignment = NSTextAlignmentLeft;
//        _nameNumLb.text = @"澄清湖 342";
        _nameNumLb.textColor = UIColor.whiteColor;
        _nameNumLb.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
        [self addSubview:_nameNumLb];
    }
    return _nameNumLb;
}

- (UIImageView *)leftImageView
{
    if (!_leftImageView) {
        _leftImageView = [UIImageView new];
//        _leftImageView.image = [UIImage imageNamed:@"台鋼雄鷹"];
        [self addSubview:_leftImageView];
    }
    return _leftImageView;
}
- (UILabel *)leftScoreLb
{
    if (!_leftScoreLb) {
        _leftScoreLb = [UILabel new];
        _leftScoreLb.textAlignment = NSTextAlignmentCenter;
        _leftScoreLb.text = @"-";
        _leftScoreLb.textColor = UIColor.whiteColor;
        _leftScoreLb.font = [UIFont systemFontOfSize:FontSize(36) weight:UIFontWeightSemibold];
        [self addSubview:_leftScoreLb];
    }
    return _leftScoreLb;
}

- (UIImageView *)rightImageView
{
    if (!_rightImageView) {
        _rightImageView = [UIImageView new];
//        _rightImageView.image = [UIImage imageNamed:@"樂天桃猿"];
        [self addSubview:_rightImageView];
    }
    return _rightImageView;
}
- (UILabel *)rightScoreLb
{
    if (!_rightScoreLb) {
        _rightScoreLb = [UILabel new];
        _rightScoreLb.textAlignment = NSTextAlignmentCenter;
        _rightScoreLb.text = @"-";
        _rightScoreLb.textColor = UIColor.whiteColor;
        _rightScoreLb.font = [UIFont systemFontOfSize:FontSize(36) weight:UIFontWeightSemibold];
        [self addSubview:_rightScoreLb];
    }
    return _rightScoreLb;
}

- (UIButton *)reviewBtn
{
    if (!_reviewBtn) {
        _reviewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _reviewBtn.tag = 1;
        [_reviewBtn setTitle:@"賽事回顧" forState:UIControlStateNormal];
        [_reviewBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _reviewBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
        [_reviewBtn addTarget:self action:@selector(reviewBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_reviewBtn];
    }
    return _reviewBtn;
}
- (UIButton *)fansBtn
{
    if (!_fansBtn) {
        _fansBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _fansBtn.tag = 0;
        [_fansBtn setTitle:@"鷹迷回顧" forState:UIControlStateNormal];
        [_fansBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _fansBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
        [_fansBtn addTarget:self action:@selector(reviewBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_fansBtn];
    }
    return _fansBtn;
}

-(void)reviewBtnEvent:(UIButton *)sender
{
    if (_reviewBlock) {
        _reviewBlock(self.model,sender.tag);
    }
}

-(void)setDataForModel:(EGScheduleModel *)model
{
    _model = model;
    
    NSString *timeStr = model.GameDateTimeS;
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *dataDate = [formatter1 dateFromString:timeStr];
    
    NSInteger result = [self compareDate:dataDate withDate:[NSDate date]];
    if (result < 1)
    {
        
        NSString *gameTimeStatr = model.GameDateTimeS;
        NSString *time = [gameTimeStatr substringWithRange:NSMakeRange(0, 16)];
        time = [time stringByReplacingOccurrencesOfString:@"T" withString:[self getWeek:model.GameDateTimeS]];
        time = [time stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
        self.dateLb.text = time;
        
        self.nameNumLb.text = [NSString stringWithFormat:@"%@ %ld",model.FieldAbbe,model.Seq];
        
        self.rightImageView.image = [UIImage imageNamed:retureHeaderTeamIconImgName(model.HomeTeamName)];
        self.leftImageView.image = [UIImage imageNamed:retureHeaderTeamIconImgName(model.VisitingTeamName)];
        
        if (model.PresentStatus == 0) {
            
            self.vsLb.textColor = UIColor.whiteColor;
            self.vsLb.text = @"VS";
            self.vsLb.font = [UIFont systemFontOfSize:FontSize(16) weight:(UIFontWeightSemibold)];
            self.rightScoreLb.text = [NSString stringWithFormat:@"%ld",model.HomeSetsWon];
            self.leftScoreLb.text = [NSString stringWithFormat:@"%ld",model.VisitingSetsWon];
            
        }else if (model.PresentStatus == 1) {
            
            self.vsLb.textColor = rgba(220, 38, 38, 1);
            self.vsLb.text = @"延賽";
            self.vsLb.font = [UIFont systemFontOfSize:FontSize(20) weight:(UIFontWeightSemibold)];
            self.leftScoreLb.text = @"";
            self.rightScoreLb.text = @"";
            
        }else if (model.PresentStatus == 2) {
            
            self.vsLb.textColor = rgba(220, 38, 38, 1);
            self.vsLb.text = @"保留";
            self.vsLb.font = [UIFont systemFontOfSize:FontSize(20) weight:(UIFontWeightSemibold)];
            self.leftScoreLb.text = @"";
            self.rightScoreLb.text = @"";
            
        } else{
            
            self.vsLb.textColor = UIColor.whiteColor;
            self.vsLb.text = @"VS";
            self.vsLb.font = [UIFont systemFontOfSize:FontSize(16) weight:(UIFontWeightSemibold)];
            self.leftScoreLb.text = @"-";
            self.rightScoreLb.text = @"-";
            
        }
        
    }else{
        NSString *gameTimeStatr = model.GameDateTimeS;
        NSString *time = [gameTimeStatr substringWithRange:NSMakeRange(0, 16)];
        time = [time stringByReplacingOccurrencesOfString:@"T" withString:[self getWeek:model.GameDateTimeS]];
        time = [time stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
        self.dateLb.text = time;
        self.nameNumLb.text = [NSString stringWithFormat:@"%@ %ld", model.FieldAbbe, model.Seq];
        self.rightImageView.image = [UIImage imageNamed:retureHeaderTeamIconImgName(model.HomeTeamName)];
        self.leftImageView.image = [UIImage imageNamed:retureHeaderTeamIconImgName(model.VisitingTeamName)];
        
        self.vsLb.textColor = UIColor.whiteColor;
        self.vsLb.text = @"VS";
        self.vsLb.font = [UIFont systemFontOfSize:FontSize(16) weight:(UIFontWeightSemibold)];
        self.leftScoreLb.text = @"-";
        self.rightScoreLb.text = @"-";
    }
    
//    if ([model.GameResult isEqualToString:@"0"]) {
//        self.line_v.hidden = false;
//        self.fansBtn.hidden = false;
//        [self.reviewBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(Device_Width / 2 + ScaleW(30));
//        }];
//    }else{
//        self.line_v.hidden = true;
//        self.fansBtn.hidden = true;
//        [self.reviewBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(ScaleW(70));
//        }];
//    }
    
    self.line_v.hidden = true;
    self.fansBtn.hidden = true;
    [self.reviewBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(70));
    }];
    
}


- (NSInteger )compareDate:(NSDate *)date1 withDate:(NSDate *)date2 {
    
    NSInteger resultNum = 0;
    NSComparisonResult result = [date1 compare:date2];
    switch (result) {
        case NSOrderedAscending:
//            NSLog(@"%@ 早于 %@", [self stringFromDate:date1], [self stringFromDate:date2]);
            resultNum = -1;
            break;
        case NSOrderedSame:
//            NSLog(@"%@ 等于 %@", [self stringFromDate:date1], [self stringFromDate:date2]);
            resultNum = 0;
            break;
        case NSOrderedDescending:
//            NSLog(@"%@ 晚于 %@", [self stringFromDate:date1], [self stringFromDate:date2]);
            resultNum = 1;
            break;
    }
    return resultNum;
}

NSString *retureHeaderTeamIconImgName(NSString *homeTeamCode)
{
    if ([homeTeamCode containsString:@"桃園雲豹"]) {
        return @"桃園雲豹";
    }else if ([homeTeamCode containsString:@"臺北伊斯特"]){
        return @"臺北伊斯特";
    }else if ([homeTeamCode containsString:@"臺中連莊"]){
        return @"臺中連莊";
    }else if ([homeTeamCode containsString:@"台鋼天鷹"]){
        return @"台鋼雄鷹3x_L";
    }else{
        return @"add";
    }
}
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
