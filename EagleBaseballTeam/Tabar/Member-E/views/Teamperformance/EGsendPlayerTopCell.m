//
//  EGMemberCardCell.m
//  EagleBaseballTeam
//
//  Created by rick on 1/24/25.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGsendPlayerTopCell.h"
@interface EGsendPlayerTopCell()
@property (nonatomic,strong) UIImageView *teamicon;

@property (nonatomic, strong) UIView *baseView;

@property (nonatomic, strong) UILabel *winLabel;//胜利
@property (nonatomic, strong) UILabel *winrateLabel;//胜率
@property (nonatomic, strong) UILabel *gamebehindLabel;//胜差


@end

@implementation EGsendPlayerTopCell
+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"EGsendPlayerTopCell";
    EGsendPlayerTopCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
          cell = [[EGsendPlayerTopCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class

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
//    frame.origin.x = 5;//这里间距为10，可以根据自己的情况调整
//    frame.size.width -= 2 * frame.origin.x;
    frame.size.height -= 2 * 5;
    [super setFrame:frame];
}


- (void)setupUI {
    [self setFrame:self.contentView.frame];
    self.baseView = self.contentView;//[[UIView alloc] init];
    self.baseView.backgroundColor = UIColor.whiteColor;//rgba(229, 229, 229, 1);
    self.baseView.layer.masksToBounds = YES;
//    [self.contentView addSubview:self.baseView];
//    
//    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(ScaleW(5));
//        make.left.mas_equalTo(ScaleW(0));
//        make.width.mas_equalTo(Device_Width -  ScaleW(35));
//        make.height.mas_equalTo(ScaleW(65));
//    }];
    
    
    self.winLabel = [[UILabel alloc] init];
    self.winLabel.text = @"1";
    self.winLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    self.winLabel.textAlignment = NSTextAlignmentCenter;
    [self.baseView addSubview:self.winLabel];
    [self.winLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(10));
        make.centerY.mas_equalTo(self.baseView);
        make.width.mas_equalTo(ScaleW(20));
        make.height.mas_equalTo(ScaleW(30));
    }];
    
    
    UIImageView *gView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 20)];
    gView.contentMode = UIViewContentModeScaleAspectFit;
    gView.image = [UIImage imageNamed:@"中信兄弟3x_L"];
    [self.baseView addSubview:gView];
    self.teamicon = gView;
    [self.teamicon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.winLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(self.baseView);
        make.width.mas_equalTo(ScaleW(50));
        make.height.mas_equalTo(ScaleW(50));
    }];
    
    self.winrateLabel=  [[UILabel alloc] init];
    self.winrateLabel.text = @"名字";
    self.winrateLabel.textAlignment = NSTextAlignmentLeft;
    self.winrateLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    [self.baseView addSubview:self.winrateLabel];
    [self.winrateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.teamicon.mas_right).offset(25);
        make.centerY.mas_equalTo(self.teamicon);
        make.width.mas_equalTo(ScaleW(70));
        make.height.mas_equalTo(ScaleW(30));
    }];
    
    self.gamebehindLabel=  [[UILabel alloc] init];
    self.gamebehindLabel.text = @"2.82";
    self.gamebehindLabel.textAlignment = NSTextAlignmentCenter;
    self.gamebehindLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    [self.baseView addSubview:self.gamebehindLabel];
    [self.gamebehindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.winrateLabel.mas_right).offset(ScaleW(90));
        make.centerY.mas_equalTo(self.teamicon);
        make.width.mas_equalTo(ScaleW(50));
        make.height.mas_equalTo(ScaleW(30));
    }];
}

// 辅助方法：将 UIImageView 转换为 UIImage
- (UIImage *)imageFromImageView:(UIImageView *)imageView {
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, [UIScreen mainScreen].scale);
    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)setupWithInfo:(NSDictionary *)info {

    [self.teamicon sd_setImageWithURL:[info objectForKey:@"PlayerImage"] placeholderImage:[UIImage imageNamed:@"no_player2"]];//第一个参数是图片的URL第二个参数是占位图片加载失败时显示
    

    
    self.winLabel.text = [[info objectForKey:@"UniformNo"] stringValue];
    self.winrateLabel.text = [info objectForKey:@"PitcherName"];
    self.gamebehindLabel.text = [[info objectForKey:@"stats"] stringValue];
}




@end
