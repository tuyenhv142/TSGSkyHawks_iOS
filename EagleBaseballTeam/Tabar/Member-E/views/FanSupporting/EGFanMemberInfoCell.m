//
//  EGMemberCardCell.m
//  EagleBaseballTeam
//
//  Created by dragon on 1/24/25.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGFanMemberInfoCell.h"
@interface EGFanMemberInfoCell()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *videolink_bt;
@property (nonatomic, strong) UIButton *musiclink_bt;
@property (nonatomic, strong) UIButton *musictext_bt;

@property (nonatomic, strong) UIView *baseView;

@end

@implementation EGFanMemberInfoCell
+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"EGFanMemberInfoCell";
    EGFanMemberInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
          cell = [[EGFanMemberInfoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class

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
    self.nameLabel.text = @"歌曲";
    self.nameLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightMedium];
    [self.baseView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(0));
        make.width.mas_equalTo(ScaleW(180));
        make.height.mas_equalTo(ScaleW(30));
        make.top.mas_equalTo(ScaleW(5));
        make.bottom.mas_equalTo(-ScaleW(5));
    }];
    
    
    UIButton *Button = [UIButton buttonWithType:UIButtonTypeCustom];
    Button.tag = 60001;
    [Button setImage:[UIImage imageNamed:@"vediolink"] forState:UIControlStateNormal];
    [Button addTarget:self action:@selector(showVMTInfo:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.baseView addSubview:Button];
    [Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(ScaleW(140-48-88));
        make.width.mas_equalTo(ScaleW(24));
        make.height.mas_equalTo(ScaleW(24));
        make.centerY.equalTo(self.nameLabel);
    }];
    self.videolink_bt = Button;
    
    Button = [UIButton buttonWithType:UIButtonTypeCustom];
    Button.tag = 60002;
    [Button setImage:[UIImage imageNamed:@"musiclink"] forState:UIControlStateNormal];
    [Button addTarget:self action:@selector((showVMTInfo:)) forControlEvents:(UIControlEventTouchUpInside)];
    [self.baseView addSubview:Button];
    [Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(ScaleW(140-88));
        make.width.mas_equalTo(ScaleW(24));
        make.height.mas_equalTo(ScaleW(24));
        make.centerY.equalTo(self.nameLabel);
    }];
    self.musiclink_bt = Button;
    
    Button = [UIButton buttonWithType:UIButtonTypeCustom];
    Button.tag = 60003;
    [Button setImage:[UIImage imageNamed:@"musictext"] forState:UIControlStateNormal];
    [Button addTarget:self action:@selector((showVMTInfo:)) forControlEvents:(UIControlEventTouchUpInside)];
    [self.baseView addSubview:Button];
    [Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(ScaleW(100));
        make.width.mas_equalTo(ScaleW(24));
        make.height.mas_equalTo(ScaleW(24));
        make.centerY.equalTo(self.nameLabel);
    }];
    self.musictext_bt = Button;
   
}

- (void)setupWithInfo:(NSDictionary *)info {
    
    NSString *vediolinkstr = NULL;
    NSString *musiclinkstr = NULL;
    NSString *textstring = NULL;
    
//    [self removeConstraint:self.videolink_bt];
    
    self.videolink_bt.hidden = YES;
    self.musiclink_bt.hidden = YES;;
    self.musictext_bt.hidden = YES;;
    
    
    self.nameLabel.text = info[@"memberName"];
//    if([self.nameLabel.text isEqualToString:@"新版嗆司曲"])
//    {
//        NSLog(@"新版嗆司曲");
//    }
    
    vediolinkstr = info[@"memberVideolink"];
    musiclinkstr = info[@"memberMusiclink"];
    textstring = info[@"memberMusictext"];
    
    self.sendDic = [[NSMutableDictionary alloc] initWithDictionary:info];
    
   //重新布局
    if([textstring isEqualToString:@""])
    {
        self.musictext_bt.hidden = YES;
        if([musiclinkstr isEqualToString:@""])
        {
            self.musiclink_bt.hidden=YES;
            if([vediolinkstr isEqualToString:@""])
            {
                self.videolink_bt.hidden = YES;
            }
            else
            {
                self.videolink_bt.hidden = NO; //目前不进
                [self.videolink_bt mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(self.nameLabel.mas_right).offset(ScaleW(140-88));
                    make.width.mas_equalTo(ScaleW(24));
                    make.height.mas_equalTo(ScaleW(24));
                        make.centerY.equalTo(self.nameLabel);
                    }];
            }
        }
        else
        {
            self.musiclink_bt.hidden=NO;
            [self.musiclink_bt mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.nameLabel.mas_right).offset(ScaleW(100));
                make.width.mas_equalTo(ScaleW(24));
                make.height.mas_equalTo(ScaleW(24));
                    make.centerY.equalTo(self.nameLabel);
                }];
            
            if([vediolinkstr isEqualToString:@""])
            {
                self.videolink_bt.hidden=YES;
            }
            else
            {
                self.videolink_bt.hidden=NO;
                [self.videolink_bt mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(self.nameLabel.mas_right).offset(ScaleW(140-88));
                    make.width.mas_equalTo(ScaleW(24));
                    make.height.mas_equalTo(ScaleW(24));
                        make.centerY.equalTo(self.nameLabel);
                    }];
            }
            
            
        }
    }
    else
    {
        self.musictext_bt.hidden = NO;
        if([musiclinkstr isEqualToString:@""])
        {
            self.musiclink_bt.hidden = YES;
            if([vediolinkstr isEqualToString:@""])
            {
                self.videolink_bt.hidden=YES;
            }
            else
            {
                self.videolink_bt.hidden=NO;
                [self.videolink_bt mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(self.nameLabel.mas_right).offset(ScaleW(140-88));
                    make.width.mas_equalTo(ScaleW(24));
                    make.height.mas_equalTo(ScaleW(24));
                        make.centerY.equalTo(self.nameLabel);
                    }];
            }
        }
        else
        {
            self.musiclink_bt.hidden = NO;
            [self.musiclink_bt mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.nameLabel.mas_right).offset(ScaleW(140-88));
                make.width.mas_equalTo(ScaleW(24));
                make.height.mas_equalTo(ScaleW(24));
                    make.centerY.equalTo(self.nameLabel);
                }];
            
            
            if([vediolinkstr isEqualToString:@""])
            {
                self.videolink_bt.hidden=YES;
            }
            else
            {
                self.videolink_bt.hidden=NO;
                [self.videolink_bt mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(self.nameLabel.mas_right).offset(ScaleW(140-48-88));
                    make.width.mas_equalTo(ScaleW(24));
                    make.height.mas_equalTo(ScaleW(24));
                        make.centerY.equalTo(self.nameLabel);
                    }];
            }
        }
    }
}

-(void)showVMTInfo:(UIButton*)bt
{
    if(self.fansInfoBlock)
    {
        self.fansInfoBlock(self.sendDic,bt.tag);
    }
}


@end
