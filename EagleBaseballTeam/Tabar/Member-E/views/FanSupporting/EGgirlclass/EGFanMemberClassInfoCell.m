//
//  EGMemberCardCell.m
//  EagleBaseballTeam
//
//  Created by dragon on 1/24/25.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGFanMemberClassInfoCell.h"
@interface EGFanMemberClassInfoCell()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIImageView *statusview;
@property (nonatomic, strong)UIImageView *Hline;//竖线
@end

@implementation EGFanMemberClassInfoCell
+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"EGFanMemberClassInfoCell";
    EGFanMemberClassInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
          cell = [[EGFanMemberClassInfoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class

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

- (void)setupUI {
    self.baseView = [[UIView alloc] init];
    self.baseView.backgroundColor = [UIColor clearColor];
    self.baseView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.baseView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(0));
        make.left.mas_equalTo(ScaleW(20));
        make.width.mas_equalTo(ScaleW(Device_Width-20));
        make.height.mas_equalTo(ScaleW(45));
        make.bottom.mas_equalTo(0);
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.text = @"4/4(五)";
    self.nameLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
    [self.baseView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(0));
        make.width.mas_equalTo(ScaleW(80));
        make.height.mas_equalTo(ScaleW(20));
        make.top.mas_equalTo(ScaleW(5));
        make.bottom.mas_equalTo(-ScaleW(5));
    }];
    
    //竖线 view
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 1)];
    line.backgroundColor = rgba(232, 232, 232, 1);
    [self.baseView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(ScaleW(10));
        make.height.mas_equalTo(self.contentView.frame.size.height +ScaleW(20));
        make.width.mas_equalTo(ScaleW(1));
    }];
    self.Hline = line;
    
    
    //status image
    line = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 1)];
    line.image = [UIImage imageNamed:@"Ellipse11"];
    [self.baseView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
        make.left.mas_equalTo(self.Hline.mas_right).offset(ScaleW(120));
        make.height.mas_equalTo(ScaleW(20));
        make.width.mas_equalTo(ScaleW(20));
    }];
    self.statusview = line;
    
    
}

- (void)setupWithInfo:(NSDictionary *)info {
    
    self.statusview.hidden = YES;
    BOOL isshow = [[info objectForKey:@"girlclassdatestatus"] boolValue];
    if(isshow)
    {
        self.statusview.hidden = NO;
    }
    
    self.nameLabel.text = info[@"girIclassdate"];
   
}



@end
