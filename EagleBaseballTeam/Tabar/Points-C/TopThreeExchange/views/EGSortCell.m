//
//  EGSocialLinksCellTableViewCell.m
//  EagleBaseballTeam
//
//  Created by rick on 1/26/25.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGSortCell.h"

@interface EGSortCell()

@property (nonatomic,strong) UIView*baseView;
@property (nonatomic,strong)UIImageView *notificationSW;
@end

@implementation EGSortCell

+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"EGSortCell";
    EGSortCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[EGSortCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//cell选中无色
    cell.backgroundColor = UIColor.whiteColor;
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
    self.baseView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.baseView];
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        //make.width.mas_equalTo(self.contentView.frame.size.width);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(self.height);
    }];
    
    self.textLabel.font =  [UIFont systemFontOfSize:FontSize(16) weight:(UIFontWeightMedium)];
    self.textLabel.textColor = rgba(64, 64, 64, 1);
    self.textLabel.text = @"";
    
    UIImageView *Sw = [[UIImageView alloc] init];
    [Sw setImage:[UIImage imageNamed:@"radio_button_unchecked"]];
    
    [self.baseView addSubview:Sw];
    [Sw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(ScaleW(-10));
        make.centerY.mas_equalTo(self.baseView.mas_centerY);
        make.width.mas_equalTo(ScaleW(24));
        make.height.mas_equalTo(ScaleW(24));
    }];
    self.notificationSW = Sw;
}

-(void)setTitle:(NSString*)title
{
    self.textLabel.font =  [UIFont systemFontOfSize:FontSize(16) weight:(UIFontWeightMedium)];
    self.textLabel.textColor = ColorRGB(0x502314);
    self.textLabel.text = title;
}

-(void)setCheckstatus:(NSNumber*)sta
{
    
    if(sta.boolValue){
        self.notificationSW.hidden = NO;
        [self.notificationSW setImage:[UIImage imageNamed:@"radio_button_checked"]];
    }
    else{
        self.notificationSW.hidden = NO;
        [self.notificationSW setImage:[UIImage imageNamed:@"radio_button_unchecked"]];
    }
    
}

@end
