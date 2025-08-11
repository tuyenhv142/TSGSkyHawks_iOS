//
//  EGActivityMegTableViewCell.m
//  EagleBaseballTeam
//
//  Created by Elvin on 2025/6/11.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGActivityMegTableViewCell.h"

#import "EGMessageModel.h"

@interface EGActivityMegTableViewCell ()

@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *newLabel;
@end

@implementation EGActivityMegTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"EGActivityMegTableViewCell";
    EGActivityMegTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
          cell = [[EGActivityMegTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//cell选中无色
    //  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//箭头
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    
    self.contentView.backgroundColor = rgba(243, 243, 243, 1);
    
    self.bgView = [UIView new];
    self.bgView.backgroundColor = UIColor.whiteColor;
    self.bgView.frame = CGRectMake(ScaleW(5), 0, Device_Width - ScaleW(10), ScaleW(120));
    [self.bgView addShadowCornerRadius:10 shadowColor:rgba(80, 35, 20, 0.1)];
    [self.contentView addSubview:self.bgView];
    
    
    [self.bgView addSubview:self.bgImageView];
    [self.bgView addSubview:self.dateLabel];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.newLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(ScaleW(10));
        make.width.mas_equalTo(ScaleW(108));
        make.height.mas_equalTo(ScaleW(108));
    }];
    
    [self.newLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView.mas_top);
        make.width.mas_equalTo(ScaleW(44));
        make.height.mas_equalTo(ScaleW(16));
        make.right.mas_equalTo(-ScaleW(10));
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView.mas_top);
        make.left.equalTo(self.bgImageView.mas_right).offset(ScaleW(10));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.newLabel.mas_bottom).offset(ScaleW(10));
        make.left.equalTo(self.bgImageView.mas_right).offset(ScaleW(10));
        make.right.mas_equalTo(-ScaleW(10));
    }];
    
}
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [UIView new];
//        _bgView.layer.cornerRadius = 5;
//        _bgView.layer.masksToBounds = true;
        _bgView.backgroundColor = UIColor.whiteColor;
        _bgView.layer.borderColor = UIColor.lightGrayColor.CGColor;
        _bgView.layer.borderWidth = 1;
    }
    return _bgView;
}

- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [UIImageView new];
        _bgImageView.layer.cornerRadius = 5;
        _bgImageView.layer.masksToBounds = true;
//        _bgImageView.backgroundColor = rgba(0, 71, 56, 1);
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
//        _bgImageView.image = [UIImage imageNamed:@"TSG-green"];
    }
    return _bgImageView;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [UILabel new];
        _dateLabel.textAlignment = NSTextAlignmentLeft;
//        _dateLabel.text = @"2025/09/09";
        _dateLabel.textColor = rgba(0, 0, 0, 0.4);
        _dateLabel.font = [UIFont systemFontOfSize:FontSize(12) weight:UIFontWeightMedium];
    }
    return _dateLabel;
}
    
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 0;
//        _titleLabel.text = @"雄鷹起飛倒數!今晚18：35主場迎戰味全龍！";
        _titleLabel.textColor = rgba(80, 35, 20, 1);
        _titleLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightSemibold];
        
    }
    return _titleLabel;
}

- (UILabel *)newLabel
{
    if (!_newLabel) {
        _newLabel = [UILabel new];
        _newLabel.textAlignment = NSTextAlignmentCenter;
        _newLabel.text = @"New";
        _newLabel.backgroundColor = rgba(217, 174, 53, 1);
        _newLabel.layer.cornerRadius = ScaleW(8);
        _newLabel.layer.masksToBounds = true;
        _newLabel.textColor = UIColor.whiteColor;
        _newLabel.font = [UIFont systemFontOfSize:FontSize(12) weight:UIFontWeightSemibold];
        
    }
    return _newLabel;
}

- (void)setActivityModel:(EGMessageModel *)activityModel
{
    _activityModel = activityModel;
    
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:activityModel.coverImage] placeholderImage:[UIImage imageNamed:@"notification"]];
    
    NSString *timeString = activityModel.CreatedAt;
    self.dateLabel.text = [timeString substringToIndex:10];
    
    self.titleLabel.text = activityModel.title;
    
    if (activityModel.status == 0) {
        self.newLabel.hidden = false;
    }else{
        self.newLabel.hidden = true;
    }
}
@end





@interface NotificationTBVCell ()

@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *timeLb;
@property (nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong) UIView *iconView;
@property (nonatomic,strong) UILabel *alterLabel;

@end

@implementation NotificationTBVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"NotificationTBVCell";
    NotificationTBVCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
          cell = [[NotificationTBVCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//cell选中无色
    //  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//箭头
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = rgba(243, 243, 243, 1);
        
        UIView *baseView = [UIView new];
        baseView.backgroundColor = UIColor.whiteColor;
        baseView.frame = CGRectMake(ScaleW(5), 0, Device_Width - ScaleW(10), ScaleW(120));
        [baseView addShadowCornerRadius:10 shadowColor:rgba(80, 35, 20, 0.1)];
        [self.contentView addSubview:baseView];
        
        UILabel *newLabel = [UILabel new];
        newLabel.textAlignment = NSTextAlignmentCenter;
        newLabel.text = @"New";
        newLabel.backgroundColor = rgba(217, 174, 53, 1);
        newLabel.layer.cornerRadius = ScaleW(8);
        newLabel.layer.masksToBounds = true;
        newLabel.textColor = UIColor.whiteColor;
        newLabel.font = [UIFont systemFontOfSize:FontSize(12) weight:UIFontWeightSemibold];
        [baseView addSubview:newLabel];
        [newLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleW(10));
            make.right.mas_equalTo(-ScaleW(10));
            make.width.mas_equalTo(ScaleW(44));
            make.height.mas_equalTo(ScaleW(16));
        }];
        self.alterLabel = newLabel;
        
        
        UILabel *timeLb = [UILabel new];
//        timeLb.text = @"2024/09/11";
        timeLb.textAlignment = NSTextAlignmentRight;
        timeLb.textColor = rgba(0, 0, 0, 0.4);
        timeLb.font = [UIFont systemFontOfSize:FontSize(12) weight:UIFontWeightRegular];
        [baseView addSubview:timeLb];
        [timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleW(10));
            make.left.mas_equalTo(ScaleW(10));
        }];
        self.timeLb = timeLb;
        
        
        UILabel *typeLabel = [UILabel new];
//        typeLabel.text = @"系統公告";
        typeLabel.textAlignment = NSTextAlignmentLeft;
        typeLabel.textColor = rgba(0, 0, 0, 0.75);
        typeLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightRegular];
        [baseView addSubview:typeLabel];
        [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(timeLb.mas_bottom).offset(ScaleW(10));
            make.right.mas_equalTo(-ScaleW(10));
            make.left.mas_equalTo(ScaleW(10));
        }];
        self.typeLabel = typeLabel;
        
        UILabel *titleLb = [UILabel new];
        titleLb.numberOfLines = 2;
//        titleLb.text = @"「4/25 凌晨 2:00～5:00 將進行維護，期間部分功能暫停使用，敬請見諒！";
        titleLb.textColor = rgba(0, 0, 0, 0.4);
        titleLb.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightMedium];
        [baseView addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(typeLabel.mas_bottom).offset(ScaleW(10));
            make.left.mas_equalTo(ScaleW(10));
            make.right.mas_equalTo(-ScaleW(40));
        }];
        self.titleLb = titleLb;
    }
    return self;
}

- (void)setSystemModel:(EGMessageModel *)systemModel
{
    _systemModel = systemModel;
    
    NSString *timeString = systemModel.CreatedAt;
    self.timeLb.text = [timeString substringToIndex:10];
    
    self.typeLabel.text = systemModel.title;
    
    self.titleLb.text = systemModel.content;
    
    if (systemModel.status == 0) {
        self.alterLabel.hidden = false;
    }else{
        self.alterLabel.hidden = true;
    }
}
    
@end

