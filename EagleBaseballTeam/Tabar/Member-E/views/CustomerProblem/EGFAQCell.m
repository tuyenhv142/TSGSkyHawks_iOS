//
//  EGMemberCardCell.m
//  EagleBaseballTeam
//
//  Created by rick on 1/24/25.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGFAQCell.h"
@interface EGFAQCell()
@property (nonatomic,strong) UIImageView *teamicon;

@property (nonatomic, strong) UIView *baseView;

@property (nonatomic, strong) UILabel *problemNo;//显示问题序号
@property (nonatomic, strong) UILabel *winLabel;//显示问题标题
@property (nonatomic, strong) UILabel *failLabel;//显示问题更多内容
@property (nonatomic, strong) UIButton *expendbt;

@end

@implementation EGFAQCell
+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"EGFAQCell";
    EGFAQCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
          cell = [[EGFAQCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class

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
    self.baseView = self.contentView;
    self.baseView.backgroundColor = UIColor.whiteColor;
    self.baseView.layer.masksToBounds = YES;
    
    UIImageView *gView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 20)];
    gView.contentMode = UIViewContentModeScaleAspectFit;
    gView.image = [UIImage imageNamed:@"blackbt"];
    [self.baseView addSubview:gView];
    self.teamicon = gView;
    [self.teamicon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(30));
        make.top.mas_equalTo(ScaleW(15));
        make.width.mas_equalTo(ScaleW(5));
        make.height.mas_equalTo(ScaleW(5));
    }];
    
    
        self.failLabel =  [[UILabel alloc] init];
        self.failLabel.text = @"";
        self.failLabel.textAlignment = NSTextAlignmentLeft;
        self.failLabel.numberOfLines = 0;
        self.failLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
        [self.baseView addSubview:self.failLabel];
        [self.failLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.teamicon).offset(ScaleW(10));
            make.top.mas_equalTo(ScaleW(10));
            make.right.mas_equalTo(-ScaleW(40));
            make.bottom.mas_equalTo(-ScaleW(10));
        }];
}

- (void)setupWithInfo:(NSString *)info showdot:(BOOL)isshow{
    self.failLabel.text =info;
    
    if(isshow)
        self.teamicon.hidden = NO;
    else
        self.teamicon.hidden = YES;
}
@end
