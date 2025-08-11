//
//  EGMemberCardCell.m
//  EagleBaseballTeam
//
//  Created by rick on 1/24/25.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGCateringInfoCell.h"
@interface EGCateringInfoCell()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIImageView *statusview;
@property (nonatomic, strong)UIImageView *Hline;//竖线
@end

@implementation EGCateringInfoCell
+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"EGCateringInfoCell";
    EGCateringInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
          cell = [[EGCateringInfoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class

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
    
    //status image
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 1)];
    line.image = [UIImage imageNamed:@"bishengke"];
    [self.baseView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.baseView.mas_centerY);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(ScaleW(50));
        make.width.mas_equalTo(ScaleW(50));
    }];
    self.statusview = line;
    
    //竖线 view
    line = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 1)];
    line.backgroundColor = rgba(232, 232, 232, 1);
    [self.baseView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.statusview.mas_centerY);
        make.left.mas_equalTo(self.statusview.mas_right).offset(ScaleW(10));
        make.height.mas_equalTo(self.contentView.frame.size.height +ScaleW(20));
        make.width.mas_equalTo(ScaleW(1));
    }];
    self.Hline = line;
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.text = @"";
    self.nameLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
    [self.baseView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.statusview.mas_centerY);
        make.left.mas_equalTo(self.Hline.mas_right).offset(ScaleW(30));
        make.width.mas_equalTo(ScaleW(200));
        make.height.mas_equalTo(ScaleW(20));
    }];
}

- (void)setupWithInfo:(NSDictionary *)info {
    self.statusview.image = [UIImage imageNamed:info[@"catering_image"]];
    self.nameLabel.text = info[@"catering_name"];
}



@end
