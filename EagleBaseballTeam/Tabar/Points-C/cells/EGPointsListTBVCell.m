//
//  EGPointsListTBVCell.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/8.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGPointsListTBVCell.h"

@interface EGPointsListTBVCell ()
@property (nonatomic,weak) UILabel *titleLb;
@property (nonatomic,weak) UILabel *subTitleLb;
@property (nonatomic,weak) UILabel *timeLb;

@property (nonatomic,strong) UIButton *titleBtn;
@property (nonatomic,strong) UILabel *pointsLb;
@property (nonatomic,strong) UIButton *statesBtn;
@property (nonatomic,strong) UIButton *bluetoothBtn;
@end


@implementation EGPointsListTBVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIButton *)titleBtn
{
    if (!_titleBtn) {
        _titleBtn = [[UIButton alloc] init];
//        [_titleBtn setTitle:@"雄鷹點數" forState:UIControlStateNormal];
//        _titleBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:(UIFontWeightMedium)];
//        [_titleBtn setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
//        _titleBtn.backgroundColor = rgba(0, 122, 96, 1);
//        _titleBtn.layer.cornerRadius = ScaleW(12);
//        _titleBtn.layer.masksToBounds = true;
//        [_titleBtn setBackgroundImage:[UIImage imageNamed:@"Ellipse"] forState:UIControlStateNormal];
        [_titleBtn setImage:[UIImage imageNamed:@"TSG_Dark"] forState:UIControlStateNormal];
//        [self addSubview:_titleBtn];
    }
    return _titleBtn;
}
- (UILabel *)pointsLb
{
    if (!_pointsLb) {
        _pointsLb = [UILabel new];
        _pointsLb.textAlignment = NSTextAlignmentLeft;
        _pointsLb.text = @"5 點";
        _pointsLb.textColor = UIColor.blackColor;
        _pointsLb.font = [UIFont systemFontOfSize:FontSize(18) weight:UIFontWeightMedium];
//        [self addSubview:_titleLb];
    }
    return _pointsLb;
}

- (UIButton *)bluetoothBtn
{
    if (!_bluetoothBtn) {
        _bluetoothBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bluetoothBtn setImage:[UIImage imageNamed:@"icon_bluetooth"] forState:UIControlStateNormal];
        [_bluetoothBtn setImage:[UIImage imageNamed:@"bluetooth"] forState:UIControlStateDisabled];
        _bluetoothBtn.backgroundColor = rgba(245, 245, 245, 1);
        [_bluetoothBtn setEnabled:NO];
    }
    return _bluetoothBtn;
}
- (UIButton *)statesBtn
{
    if (!_statesBtn) {
        _statesBtn = [[UIButton alloc] init];
        _statesBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:(UIFontWeightMedium)];
        [_statesBtn setTitle:@"任務詳情" forState:UIControlStateNormal];
        [_statesBtn setBackgroundImage:[UIImage imageWithColor:rgba(208, 159, 41, 1)] forState:UIControlStateNormal];  // UIControlStateNormal状态背景色
        [_statesBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        
        [_statesBtn setTitleColor:rgba(163, 163, 163, 1) forState:UIControlStateDisabled];  // 禁用状态文字颜色
        [_statesBtn setTitle:@"已完成" forState: UIControlStateDisabled];
        [_statesBtn setTitle:@"即將開放" forState: UIControlStateDisabled];
        [_statesBtn setBackgroundImage:[UIImage imageWithColor:rgba(245, 245, 245, 1)] forState:UIControlStateDisabled];  // 禁用状态背景色
        _statesBtn.userInteractionEnabled = NO;
        [_statesBtn setEnabled:NO];
        [self.statesBtn addTarget:self action:@selector(statusButtonClicked) forControlEvents:UIControlEventTouchUpInside ];
        
        _statesBtn.backgroundColor = rgba(208, 159, 41, 1);
        _statesBtn.layer.cornerRadius = ScaleW(12);
        _statesBtn.layer.masksToBounds = true;
        _statesBtn.contentEdgeInsets = UIEdgeInsetsMake(0, ScaleW(8), 0, ScaleW(8));
//        [_titleBtn setBackgroundImage:[UIImage imageNamed:@"Ellipse"] forState:UIControlStateNormal];
//        [self addSubview:_titleBtn];
    }
    return _statesBtn;
}


+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"EGPointsListTBVCell";
    EGPointsListTBVCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
          cell = [[EGPointsListTBVCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class
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
            make.top.mas_equalTo(ScaleW(8));
            make.left.mas_equalTo(ScaleW(20));
            make.right.mas_equalTo(-ScaleW(20));
            make.bottom.mas_equalTo(-ScaleW(8));
        }];
        
        UILabel *titleLb = [UILabel new];
        titleLb.text = @"首次登入天鷹 APP，好禮立即送！";
        titleLb.textColor = rgba(60, 115, 210, 1);
        titleLb.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightSemibold];
        [baseView addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleW(16));
            make.left.mas_equalTo(ScaleW(20));
            make.right.mas_equalTo(-ScaleW(45));
        }];
        self.titleLb = titleLb;
        
        self.bluetoothBtn.layer.cornerRadius = ScaleW(12.5);
        self.bluetoothBtn.layer.masksToBounds = YES;
        [baseView addSubview:self.bluetoothBtn];
        [self.bluetoothBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLb);
            make.right.mas_equalTo(-ScaleW(20));
            make.height.width.mas_equalTo(ScaleW(25));
//            make.width.mas_equalTo(ScaleW(62));
//            make.bottom.mas_equalTo(-ScaleW(16));
        }];
        
        UILabel *subTitleLb = [UILabel new];
        subTitleLb.text = @"當日賽事台鋼天鷹安打總數達 15 支以上";
        subTitleLb.textColor = rgba(64, 64, 64, 1);
        subTitleLb.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightMedium];
        subTitleLb.numberOfLines = 0;
        [baseView addSubview:subTitleLb];
        [subTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLb.mas_bottom).offset(ScaleW(4));
            make.left.mas_equalTo(ScaleW(20));
            make.right.mas_equalTo(-ScaleW(20));
        }];
        self.subTitleLb = subTitleLb;
        
        UILabel *timeLb = [UILabel new];
        timeLb.text = @"2025/01/01 ~ 2025/04/30";
        timeLb.textAlignment = NSTextAlignmentLeft;
        timeLb.textColor = rgba(115, 115, 115, 1);
        timeLb.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
        timeLb.backgroundColor = [UIColor whiteColor];
        [baseView addSubview:timeLb];
        self.timeLb = timeLb;
        [timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(subTitleLb.mas_bottom).offset(ScaleW(4));
            make.left.mas_equalTo(ScaleW(20));
            make.right.mas_equalTo(-ScaleW(20));
        }];
//        self.timeLb = timeLb;
        
        [baseView addSubview:self.titleBtn];
        [self.titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(timeLb.mas_bottom).offset(ScaleW(8));
            make.left.mas_equalTo(ScaleW(20));
            make.width.height.mas_equalTo(ScaleW(24));
            make.bottom.mas_equalTo(-ScaleW(16));
        }];
        [baseView addSubview:self.pointsLb];
        [self.pointsLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleBtn);
            make.left.equalTo(self.titleBtn.mas_right).offset(ScaleW(5));
        }];
        
        [baseView addSubview:self.statesBtn];
        [self.statesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleBtn);
            make.right.mas_equalTo(-ScaleW(20));
            make.height.mas_equalTo(ScaleW(24));
//            make.width.mas_equalTo(ScaleW(62));
//            make.bottom.mas_equalTo(-ScaleW(16));
        }];
        
    }
    return self;
}

-(void)setModeInfo:(NSDictionary *)dict{
    self.titleLb.text = [dict objectIsNilReturnSteForKey:@"title"];
    self.subTitleLb.text = [dict objectIsNilReturnSteForKey:@"subtitle"];
    self.timeLb.text = [dict objectIsNilReturnSteForKey:@"dateRange"];
    self.pointsLb.text =  [NSString stringWithFormat:@"%@ 點", [dict objectIsNilReturnSteForKey:@"points"]];
    NSDictionary *taskDetail = [dict objectOrNilForKey:@"taskDetail"];
    
    BOOL  isBluetooth = [[taskDetail objectOrNilForKey:@"isBluetooth"] boolValue];
    
    [self.bluetoothBtn setHidden:!isBluetooth];
    
    
    NSString *status = dict[@"status"];
    [_statesBtn setTitle:status forState:UIControlStateDisabled];
//    if ([status isEqualToString:@"已完成"]) {
//        _statesBtn.enabled = NO;
//        [_statesBtn setBackgroundImage:[UIImage imageWithColor:rgba(208, 159, 41, 1)] forState:UIControlStateNormal];  //
//        
//    } else if ([status isEqualToString:@"敬請期待"]) {
//        [_statesBtn setTitleColor:rgba(82, 82, 82, 1) forState:UIControlStateNormal];
//        _statesBtn.backgroundColor = [UIColor clearColor];
//        [_statesBtn setBackgroundImage:nil forState:UIControlStateNormal];  //
//        
//    } else {
//        _statesBtn.enabled = YES;
//        [_statesBtn setBackgroundImage:[UIImage imageWithColor:rgba(208, 159, 41, 1)] forState:UIControlStateNormal];  //
////        _statesBtn.backgroundColor = rgba(208, 159, 41, 1);
////        [_statesBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    }
}

- (void)statusButtonClicked {
    NSLog(@"click");
    if ([self.delegate respondsToSelector:@selector(listTBCell:didClickStateButtonAtIndexPath:)]) {
        [self.delegate listTBCell:self didClickStateButtonAtIndexPath:self.indexPath];
    }
}
@end
