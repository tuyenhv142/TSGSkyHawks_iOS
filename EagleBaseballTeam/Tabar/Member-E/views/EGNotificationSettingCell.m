//
//  EGSocialLinksCellTableViewCell.m
//  EagleBaseballTeam
//
//  Created by rick on 1/26/25.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGNotificationSettingCell.h"

@interface EGNotificationSettingCell()

@property (nonatomic,strong) UIView*baseView;
@property (nonatomic, strong) NSArray<UIView *> *containerViews;
@property (nonatomic,strong)UISwitch *notificationSW;
@end

@implementation EGNotificationSettingCell

+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"EGNotificationSettingCell";
    EGNotificationSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[EGNotificationSettingCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class
        
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
    
    NSNumber * akey = [[NSUserDefaults standardUserDefaults] objectForKey:@"usenotificationsetting"];
    BOOL useNotification = NO;
    if(!akey)
    {
        //此键值不存在
        useNotification = YES;//默认YES;
    }
    else
    {
        useNotification = [akey boolValue];
    }
    
    self.baseView = [[UIView alloc] init];
//    self.baseView.backgroundColor=UIColor.yellowColor;
    self.baseView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.baseView];
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(self.width);
        make.height.mas_equalTo(self.height);
    }];
    
    self.textLabel.font =  [UIFont systemFontOfSize:FontSize(16) weight:(UIFontWeightMedium)];
    self.textLabel.textColor = rgba(64, 64, 64, 1);
    self.textLabel.text = @"通知設定";
    
    UISwitch *Sw = [[UISwitch alloc] init];;
    Sw.onTintColor = ColorRGB(0x0066CC); 
    Sw.on = useNotification;
    [Sw addTarget:self action:@selector(clickSwith) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:Sw];
    [Sw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(ScaleW(-10));
        make.centerY.mas_equalTo(self.baseView.mas_centerY);
        make.width.mas_equalTo(ScaleW(45));
        make.height.mas_equalTo(ScaleW(30));
    }];
    self.notificationSW = Sw;
}

-(void)clickSwith
{
    BOOL isSelect = YES;
    
    isSelect = self.notificationSW.on;
    
    if(self.gSwitchBlock)
    {
        self.gSwitchBlock(isSelect);
    }
    
}

@end
