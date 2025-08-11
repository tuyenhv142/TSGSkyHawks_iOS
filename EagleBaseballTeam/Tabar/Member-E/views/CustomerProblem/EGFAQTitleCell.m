//
//  EGMemberCardCell.m
//  EagleBaseballTeam
//
//  Created by rick on 1/24/25.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGFAQTitleCell.h"
@interface EGFAQTitleCell()
@property (nonatomic,strong) UIImageView *teamicon;

@property (nonatomic, strong) UIView *baseView;

@property (nonatomic, strong) UILabel *problemNo;//显示问题序号
@property (nonatomic, strong) UILabel *winLabel;//显示问题标题
@property (nonatomic, strong) UIButton *expendbt;

@property (nonatomic, strong) NSDictionary* section_info;


@end

@implementation EGFAQTitleCell
+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"EGFAQTitleCell";
    EGFAQTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
          cell = [[EGFAQTitleCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class

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
    self.baseView.layer.masksToBounds = YES;
    self.baseView.backgroundColor = UIColor.whiteColor;

    self.problemNo = [[UILabel alloc] init];
    self.problemNo.text = @"";
    self.problemNo.textColor = rgba(0, 122, 96, 1);
    self.problemNo.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightSemibold];
    self.problemNo.textAlignment = NSTextAlignmentCenter;
    [self.baseView addSubview:self.problemNo];
    [self.problemNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(5));
        make.top.mas_equalTo(ScaleW(2));
        make.width.mas_equalTo(ScaleW(50));
        make.height.mas_equalTo(ScaleW(50));
    }];
    
    self.winLabel = [[UILabel alloc] init];
    self.winLabel.text = @"";
    self.winLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightSemibold];
    self.winLabel.textAlignment = NSTextAlignmentLeft;
    self.winLabel.numberOfLines = 0;
    [self.baseView addSubview:self.winLabel];
    [self.winLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.problemNo.mas_right);
        make.centerY.mas_equalTo(self.problemNo.mas_centerY);
        make.right.mas_equalTo(-ScaleW(40));
        make.bottom.mas_equalTo(-ScaleW(10));
    }];
    
    self.expendbt = [[UIButton alloc] init];
    self.expendbt.selected = NO;
    [self.expendbt setTitleColor:rgba(0, 114, 198, 1) forState:UIControlStateNormal];
    [self.expendbt setImage:[UIImage imageNamed:@"chevron-down"] forState:UIControlStateNormal];
    [self.expendbt setImage:[UIImage imageNamed:@"chevron-up"] forState:UIControlStateSelected];
    self.expendbt.titleLabel.font = [UIFont systemFontOfSize:FontSize(18) weight:(UIFontWeightBold)];
    self.expendbt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.expendbt addTarget:self action:@selector(pickerViewBtnOK:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseView addSubview:self.expendbt];
    [self.expendbt mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(ScaleW(-10));
        make.centerY.mas_equalTo(self.problemNo);
        make.width.mas_equalTo(ScaleW(20));
        make.height.mas_equalTo(ScaleW(20));
    }];
    
}

- (void)setupWithInfo:(NSDictionary *)info sectioninfo:(NSDictionary*)sectioninfodic{
    self.winLabel.text = [[info objectForKey:@"title"] stringValue];
    self.problemNo.text = [[info objectForKey:@"titleNum"] stringValue];
    
    self.section_info = sectioninfodic;
}

-(void)setbtstate:(BOOL)state
{
    self.expendbt.selected = state;
}


-(void)pickerViewBtnOK:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    BOOL select = sender.selected;
        
    if(self.FAQInfoBlock)
        {
            self.FAQInfoBlock(select,self.section_info);
        }
}
@end
