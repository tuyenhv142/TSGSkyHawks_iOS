//
//  EGScheduleInfoView.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/7.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGScheduleInfoView.h"

#import "EGScheduleModel.h"

@interface EGScheduleInfoView ()

@property (nonatomic,strong) UILabel *dateLb;
@property (nonatomic,strong) UIButton *closeBtn;//

@property (nonatomic,strong) UIImageView *leftImageView;
@property (nonatomic,strong) UIImageView *rightImageView;
@property (nonatomic,strong) UILabel *leftScoreLb;
@property (nonatomic,strong) UILabel *rightScoreLb;

@property (nonatomic,strong) UILabel *vsOrCityLb;
@property (nonatomic,strong) UILabel *titleLb;

@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;

@property (nonatomic,strong) EGScheduleModel *modelD;
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIView *bottomView;
@end


@implementation EGScheduleInfoView

- (UIView *)topView
{
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = rgba(49, 49, 49, 1);
        [self addSubview:_topView];
    }
    return _topView;
}
- (UILabel *)dateLb
{
    if (!_dateLb) {
        _dateLb = [UILabel new];
        _dateLb.textAlignment = NSTextAlignmentLeft;
//        _dateLb.text = @"01/22 (三) 18:30";
        _dateLb.textColor = UIColor.whiteColor;
        _dateLb.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightMedium];
        [self.topView addSubview:_dateLb];
    }
    return _dateLb;
}

- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_closeBtn setImage:[UIImage imageNamed:@"x-mark"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeViewBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:_closeBtn];
        _closeBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -20, -20, -20);
    }
    return _closeBtn;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = rgba(243, 243, 243, 1);
        [self addSubview:_bottomView];
    }
    return _bottomView;
}
- (UILabel *)titleLb
{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.textAlignment = NSTextAlignmentCenter;
//        _titleLb.text = @"例行賽 307";
        _titleLb.textColor = rgba(38, 38, 38, 1);
        _titleLb.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
        [self.bottomView addSubview:_titleLb];
    }
    return _titleLb;
}
- (UILabel *)vsOrCityLb
{
    if (!_vsOrCityLb) {
        _vsOrCityLb = [UILabel new];
        _vsOrCityLb.textAlignment = NSTextAlignmentCenter;
//        _vsOrCityLb.text = @"嘉義市";
        _vsOrCityLb.textColor = rgba(115, 115, 115, 1);
        _vsOrCityLb.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
        [self.bottomView addSubview:_vsOrCityLb];
    }
    return _vsOrCityLb;
}


- (UIImageView *)leftImageView
{
    if (!_leftImageView) {
        _leftImageView = [UIImageView new];
//        _leftImageView.image = [UIImage imageNamed:@"台鋼雄鷹"];
        [self.bottomView addSubview:_leftImageView];
    }
    return _leftImageView;
}
- (UILabel *)leftScoreLb
{
    if (!_leftScoreLb) {
        _leftScoreLb = [UILabel new];
        _leftScoreLb.textAlignment = NSTextAlignmentCenter;
        _leftScoreLb.text = @"0";
        _leftScoreLb.textColor = UIColor.blackColor;
        _leftScoreLb.font = [UIFont systemFontOfSize:FontSize(36) weight:UIFontWeightSemibold];
        [self.bottomView addSubview:_leftScoreLb];
    }
    return _leftScoreLb;
}

- (UIImageView *)rightImageView
{
    if (!_rightImageView) {
        _rightImageView = [UIImageView new];
//        _rightImageView.image = [UIImage imageNamed:@"樂天桃猿"];
        [self.bottomView addSubview:_rightImageView];
    }
    return _rightImageView;
}
- (UILabel *)rightScoreLb
{
    if (!_rightScoreLb) {
        _rightScoreLb = [UILabel new];
        _rightScoreLb.textAlignment = NSTextAlignmentCenter;
//        _rightScoreLb.text = @"0";
        _rightScoreLb.textColor = UIColor.blackColor;
        _rightScoreLb.font = [UIFont systemFontOfSize:FontSize(36) weight:UIFontWeightSemibold];
        [self.bottomView addSubview:_rightScoreLb];
    }
    return _rightScoreLb;
}


- (UIButton *)leftBtn
{
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _leftBtn.tag = 11;
        _leftBtn.backgroundColor = UIColor.whiteColor;
        _leftBtn.layer.cornerRadius = ScaleW(8);
        _leftBtn.layer.masksToBounds = true;
        _leftBtn.layer.borderWidth = 1;
        _leftBtn.layer.borderColor = rgba(0, 78, 162, 1).CGColor;
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightMedium];
        [_leftBtn setTitle:@"加入行事曆" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:rgba(0, 78, 162, 1) forState:UIControlStateNormal];
        [_leftBtn setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateDisabled];
        [_leftBtn addTarget:self action:@selector(addCalendarOrGoShop:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:_leftBtn];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _rightBtn.tag = 12;
        _rightBtn.backgroundColor = rgba(0, 78, 162, 1);
        _rightBtn.layer.cornerRadius = ScaleW(8);
        _rightBtn.layer.masksToBounds = true;
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightMedium];
        [_rightBtn setTitle:@"前往購票" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(addCalendarOrGoShop:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:_rightBtn];
    }
    return _rightBtn;
}

-(void)addCalendarOrGoShop:(UIButton *)sender
{
    NSInteger btntag = sender.tag;
    if ([sender.titleLabel.text isEqualToString:@"賽事回顧"]) {
        btntag = 13;
    }
    if ([sender.titleLabel.text isEqualToString:@"鷹迷回顧"]) {
        btntag = 14;
    }
    if ([self.delegate respondsToSelector:@selector(botomButtonEvent:dataModel:)] && _modelD) {
        [self.delegate botomButtonEvent:btntag dataModel:_modelD];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)closeViewBtn
{
    [self removeFromSuperview];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColor.clearColor;
        
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(Device_Width);
            make.height.mas_equalTo(ScaleH(175));
        }];
        
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottomView.mas_top);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(Device_Width);
            make.height.mas_equalTo(ScaleH(40));
        }];
        [self.dateLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
        }];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-ScaleW(20));
            make.centerY.mas_equalTo(0);
            make.width.height.mas_equalTo(ScaleW(24));
        }];
        
//例行賽 307
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleH(20));
            make.centerX.mas_equalTo(0);
        }];
//        VS or 天目
        [self.vsOrCityLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLb.mas_bottom).offset(ScaleH(22));
            make.centerX.mas_equalTo(0);
        }];
        
//        icon image
        [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleH(20));
            make.left.mas_equalTo(ScaleW(30));

        }];
        [self.leftScoreLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.vsOrCityLb);
            make.left.equalTo(self.leftImageView.mas_right).offset(ScaleW(15));
            make.right.equalTo(self.vsOrCityLb.mas_left).offset(-ScaleW(10));
        }];
        
        [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleH(20));
            make.right.mas_equalTo(-ScaleW(30));
        }];
        [self.rightScoreLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.vsOrCityLb);
            make.right.equalTo(self.rightImageView.mas_left).offset(-ScaleW(15));
            make.left.equalTo(self.vsOrCityLb.mas_right).offset(ScaleW(10));
        }];
        
//        button
        [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-ScaleH(16));
            make.left.mas_equalTo(ScaleW(30));
            make.width.mas_equalTo(ScaleW(141));
            make.height.mas_equalTo(ScaleH(35));
        }];
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-ScaleH(16));
            make.right.mas_equalTo(-ScaleW(30));
            make.width.mas_equalTo(ScaleW(141));
            make.height.mas_equalTo(ScaleH(35));
        }];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

/**
 * type == 0 买票  type == 1 回顾
 */
-(void)setSchedulesInformation:(EGScheduleModel *)model
{
    _modelD = model;
    
    NSString *gameTimeStatr = model.GameDateTimeS;
    NSString *time = [gameTimeStatr substringWithRange:NSMakeRange(5, 11)];
    self.dateLb.text = [time stringByReplacingOccurrencesOfString:@"T" withString:[self getWeek:model.GameDateTimeS]];
    
    self.rightImageView.image = [UIImage imageNamed:retureTeamIconImgName(model.HomeTeamName)];
    self.leftImageView.image = [UIImage imageNamed:retureTeamIconImgName(model.VisitingTeamName)];
    
    if (model.PresentStatus == 9) {
        
        CGFloat height = ScaleH(188);
        CGFloat selfY = Device_Height - (height + [UIDevice de_tabBarFullHeight]);
        self.frame = CGRectMake(0, selfY, Device_Width, height);
        
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(ScaleH(144));
        }];
        [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottomView.mas_top);
        }];
        [self.leftImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleH(20));
            make.left.mas_equalTo(ScaleW(45));
            make.width.height.mas_equalTo(ScaleW(50));
        }];
        [self.rightImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleH(20));
            make.right.mas_equalTo(-ScaleW(45));
            make.width.height.mas_equalTo(ScaleW(50));
        }];
//例行賽 307
        [self.titleLb mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleH(25));
            make.centerX.mas_equalTo(0);
        }];
        [self.vsOrCityLb mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLb.mas_bottom).offset(ScaleH(8));
            make.centerX.mas_equalTo(0);
        }];
        
        
        self.leftBtn.enabled = true;
        self.leftBtn.layer.borderColor = rgba(0, 122, 96, 1).CGColor;
        self.leftBtn.backgroundColor = UIColor.whiteColor;
        [self.leftBtn setTitle:@"加入行事曆" forState:UIControlStateNormal];
        
        if ([model.HomeTeamName isEqualToString:@"台鋼天鷹"]) {//雄鹰主场才能买票
            
            [self.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-ScaleW(30));
                make.width.mas_equalTo(ScaleW(141));
            }];
            
            [self.leftBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(ScaleW(30));
                make.width.mas_equalTo(ScaleW(141));
            }];
            self.rightBtn.hidden = false;
            [self.rightBtn setTitle:@"前往購票" forState:UIControlStateNormal];
            
        }else{
            
            [self.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-ScaleW(30));
                make.width.mas_equalTo(0);
            }];
            
            [self.leftBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(ScaleW(30));
                make.width.mas_equalTo(ScaleW(312));
            }];
            self.rightBtn.hidden = true;
        }
        
        
        self.leftScoreLb.text = @"";
        self.rightScoreLb.text = @"";
        
        self.titleLb.text = [NSString stringWithFormat:@"例行賽  %ld",model.Seq];//@"例行賽 307";
        self.titleLb.textColor = rgba(38, 38, 38, 1);
        
        self.vsOrCityLb.text = model.FieldAbbe;//@"嘉義市";
        self.vsOrCityLb.textColor = rgba(115, 115, 115, 1);
        self.vsOrCityLb.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
        
    }else{
        
        CGFloat height = ScaleH(219);
        CGFloat selfY = Device_Height - (ScaleH(219) + [UIDevice de_tabBarFullHeight]);
        self.frame = CGRectMake(0, selfY, Device_Width, height);
        
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(ScaleH(175));
        }];
        [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottomView.mas_top);
        }];
        [self.leftImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleH(36));
            make.left.mas_equalTo(ScaleW(30));
            make.width.height.mas_equalTo(ScaleW(65));
        }];
        [self.rightImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleH(36));
            make.right.mas_equalTo(-ScaleW(30));
            make.width.height.mas_equalTo(ScaleW(65));
        }];
//例行賽 307
        [self.titleLb mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleH(20));
            make.centerX.mas_equalTo(0);
        }];
        [self.vsOrCityLb mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLb.mas_bottom).offset(ScaleH(22));
            make.centerX.mas_equalTo(0);
        }];
        
        if (model.PresentStatus == 0) {//有比分
            
            self.rightScoreLb.text = [NSString stringWithFormat:@"%ld",model.HomeSetsWon];
            self.leftScoreLb.text = [NSString stringWithFormat:@"%ld",model.VisitingSetsWon];
            
            [self.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-ScaleW(30));
                make.width.mas_equalTo(ScaleW(141));
            }];
            [self.leftBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(ScaleW(30));
                make.width.mas_equalTo(ScaleW(141));
            }];
            self.rightBtn.hidden = false;
            [self.rightBtn setTitle:@"賽事回顧" forState:UIControlStateNormal];
            
//            self.leftBtn.enabled = true;
//            self.leftBtn.layer.borderColor = rgba(0, 122, 96, 1).CGColor;
//            self.leftBtn.backgroundColor = UIColor.whiteColor;
//            [self.leftBtn setTitle:@"鷹迷回顧" forState:UIControlStateNormal];
            self.leftBtn.enabled = false;
            self.leftBtn.layer.borderColor = UIColor.clearColor.CGColor;
            self.leftBtn.backgroundColor = rgba(222, 222, 222, 1);
            [self.leftBtn setTitle:@"加入行事曆" forState:UIControlStateNormal];
            
        }else{
            
            self.leftScoreLb.text = @"";
            self.rightScoreLb.text = @"";
            
            [self.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-ScaleW(30));
                make.width.mas_equalTo(0);
            }];
            [self.leftBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(ScaleW(30));
                make.width.mas_equalTo(ScaleW(312));
            }];
            self.rightBtn.hidden = true;
            
            self.leftBtn.enabled = false;
            self.leftBtn.layer.borderColor = UIColor.clearColor.CGColor;
            self.leftBtn.backgroundColor = rgba(222, 222, 222, 1);
            [self.leftBtn setTitle:@"加入行事曆" forState:UIControlStateNormal];
        }
        self.titleLb.text = [NSString stringWithFormat:@"例行賽 %ld｜%@",model.Seq, model.FieldAbbe];
        self.titleLb.textColor = rgba(115, 115, 115, 1);
        
        
        if (model.PresentStatus != 0) { //0正常結束 1延赛 2保留
            
            if (model.PresentStatus == 1) {
                self.vsOrCityLb.text = @"延賽";
            }else{
                self.vsOrCityLb.text = @"保留";
            }
            self.vsOrCityLb.textColor = rgba(220, 38, 38, 1);
            self.vsOrCityLb.font = [UIFont systemFontOfSize:FontSize(20) weight:UIFontWeightSemibold];
        }else{
            self.vsOrCityLb.text = @"VS";
            self.vsOrCityLb.textColor = rgba(0, 0, 0, 1);
            self.vsOrCityLb.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightSemibold];
        }
        
    }
}

NSString *retureTeamIconImgName(NSString *homeTeamCode)
{
    if ([homeTeamCode containsString:@"桃園雲豹"]) {
        return @"桃園雲豹";
    }else if ([homeTeamCode containsString:@"臺北伊斯特"]){
        return @"臺北伊斯特";
    }else if ([homeTeamCode containsString:@"臺中連莊"]){
        return @"臺中連莊";
    }else if ([homeTeamCode containsString:@"台鋼天鷹"]){
        return @"台鋼雄鷹3x_L";
//    }else if ([homeTeamCode containsString:@"ACN011"]){
//        return @"中信兄弟3x_L";
//    }else if ([homeTeamCode containsString:@"AJL011"]){
//        return @"樂天桃猿3x_L";
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
