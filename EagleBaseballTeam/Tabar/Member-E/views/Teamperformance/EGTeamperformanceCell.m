//
//  EGMemberCardCell.m
//  EagleBaseballTeam
//
//  Created by rick on 1/24/25.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGTeamperformanceCell.h"
@interface EGTeamperformanceCell()
@property (nonatomic,strong) UIImageView *teamicon;

@property (nonatomic, strong) UIView *baseView;

@property (nonatomic, strong) UILabel *winLabel;//胜利
@property (nonatomic, strong) UILabel *failLabel;//失败
@property (nonatomic, strong) UILabel *sameLabel;//和
@property (nonatomic, strong) UILabel *winrateLabel;//胜率
@property (nonatomic, strong) UILabel *gamebehindLabel;//胜差


@end

@implementation EGTeamperformanceCell
+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"EGTeamperformanceCell";
    EGTeamperformanceCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
          cell = [[EGTeamperformanceCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//cell选中无色

    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
//    frame.origin.x = 5;//这里间距为0，可以根据自己的情况调整
//    frame.origin.y = 5;//这里间距为10，可以根据自己的情况调整
//    frame.size.width -= 2 * frame.origin.x;
    frame.size.height -= 2 * 5;
    [super setFrame:frame];
}


- (void)setupUI {
    
    [self setFrame:self.contentView.frame];
    self.baseView = self.contentView;//[[UIView alloc] init];
    self.baseView.layer.masksToBounds = YES;
    self.baseView.backgroundColor = rgba(229, 229, 229, 1);
    
//    [self.contentView addSubview:self.baseView];
//    
//    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(ScaleW(5));
//        make.left.mas_equalTo(ScaleW(0));
//        make.width.mas_equalTo(Device_Width -  ScaleW(35));
//        make.height.mas_equalTo(ScaleW(65));
//    }];
    
    UIImageView *gView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 20)];
    gView.image = [UIImage imageNamed:@"中信兄弟3x_L"];
    [self.baseView addSubview:gView];
    self.teamicon = gView;
    [self.teamicon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(10));
        make.top.mas_equalTo(ScaleW(5));
        make.width.mas_equalTo(ScaleW(50));
        make.height.mas_equalTo(ScaleW(50));
    }];
    
    self.winLabel = [[UILabel alloc] init];
    self.winLabel.text = @"胜利";
    self.winLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    self.winLabel.textAlignment = NSTextAlignmentCenter;
    [self.baseView addSubview:self.winLabel];
    [self.winLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.teamicon.mas_right).offset(ScaleW(15));
        make.centerY.mas_equalTo(self.teamicon);
        make.width.mas_equalTo(ScaleW(50));
        make.height.mas_equalTo(ScaleW(30));
    }];
    
    self.failLabel =  [[UILabel alloc] init];
    self.failLabel.text = @"负";
    self.failLabel.textAlignment = NSTextAlignmentCenter;
    self.failLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    [self.baseView addSubview:self.failLabel];
    [self.failLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.winLabel.mas_right).offset(ScaleW(10));
        make.centerY.mas_equalTo(self.teamicon);
        make.width.mas_equalTo(ScaleW(20));
        make.height.mas_equalTo(ScaleW(30));
    }];
    
    
    self.sameLabel =  [[UILabel alloc] init];
    self.sameLabel.text = @"和";
    self.sameLabel.textAlignment = NSTextAlignmentCenter;
    self.sameLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    [self.baseView addSubview:self.sameLabel];
    [self.sameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.failLabel.mas_right).offset(ScaleW(17));
        make.centerY.mas_equalTo(self.teamicon);
        make.width.mas_equalTo(ScaleW(20));
        make.height.mas_equalTo(ScaleW(30));
    }];
    
    self.winrateLabel=  [[UILabel alloc] init];
    self.winrateLabel.text = @"0.256";
    self.winrateLabel.textAlignment = NSTextAlignmentCenter;
    self.winrateLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    [self.baseView addSubview:self.winrateLabel];
    [self.winrateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sameLabel.mas_right).offset(ScaleW(23));
        make.centerY.mas_equalTo(self.teamicon);
        make.width.mas_equalTo(ScaleW(50));
        make.height.mas_equalTo(ScaleW(30));
    }];
    
    self.gamebehindLabel=  [[UILabel alloc] init];
    self.gamebehindLabel.text = @"20.5";
    self.gamebehindLabel.textAlignment = NSTextAlignmentCenter;
    self.gamebehindLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    [self.baseView addSubview:self.gamebehindLabel];
    [self.gamebehindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.winrateLabel.mas_right).offset(ScaleW(12));
        make.centerY.mas_equalTo(self.teamicon);
        make.width.mas_equalTo(ScaleW(50));
        make.height.mas_equalTo(ScaleW(30));
    }];
}

- (void)setupWithInfo:(NSDictionary *)info {
    
    [self.teamicon sd_setImageWithURL:[info objectForKey:@"BaseTeamImg"] placeholderImage:nil];//第一个参数是图片的URL第二个参数是占位图片加载失败时显示    
    self.winLabel.text = [[info objectForKey:@"GameResultWCnt"] stringValue];
    self.winrateLabel.text = [[info objectForKey:@"Pct"] stringValue];
    self.gamebehindLabel.text = [[info objectForKey:@"GB"] stringValue];
    self.failLabel.text = [[info objectForKey:@"GameResultLCnt"] stringValue];
    self.sameLabel.text = [[info objectForKey:@"GameResultTCnt"] stringValue];
    
    NSString *teamtype = [info objectForKey:@"BaseTeamCode"];
    if([teamtype isEqualToString:@"AKP011"])
        self.baseView.backgroundColor = UIColor.whiteColor;
    else
        self.baseView.backgroundColor = rgba(229, 229, 229, 1);
}

@end
