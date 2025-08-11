//
//  OASearchFilterView.m
//  NewsoftOA24
//
//  Created by dragon on 7/31/24.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import "GoroundSettingView.h"
#import "LXYHyperlinksButton.h"
#import "EGPlayerCollectionViewCell.h"
@interface GoroundSettingView ()<UIGestureRecognizerDelegate,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{

}

@property (nonatomic,strong) UIView * baseView;
@property (nonatomic,weak) UIButton *cancelBtn; // X button

@property (nonatomic,weak) UILabel *SettingTitleLabel;
@property (nonatomic,weak) UILabel *SettingTextLabel;
@property (nonatomic,weak) UILabel *SettingFontSizeLabel;
@property (nonatomic,weak) UILabel *SettingColorLabel;
@property (nonatomic,weak) UILabel *FontTextLabel;
@property (nonatomic,weak) UITextField *SettingContentString;
@property (nonatomic,weak) UILabel *SpeedLabel;
@property (nonatomic,weak) UILabel *playerTextLabel;
@property (nonatomic,weak) UILabel *backColorLabel;
@property (nonatomic,weak) UILabel *fontColorLabel;
@property (nonatomic,weak) UIButton *blackbt; // X button
@property (nonatomic,weak) UIButton *greenbt; // X button

@property (nonatomic,weak) LXYHyperlinksButton *sanzhenbt;
@property (nonatomic,weak) LXYHyperlinksButton *quanleidabt;
@property (nonatomic,weak) LXYHyperlinksButton *taigangxiongyingbt;
@property (nonatomic,weak) LXYHyperlinksButton *jiayoubt;
@property (nonatomic,weak) LXYHyperlinksButton *chibangyinglebt;
@property (nonatomic,weak) LXYHyperlinksButton *One_X_bt;
@property (nonatomic,weak) LXYHyperlinksButton *Two_X_bt;
@property (nonatomic,weak) LXYHyperlinksButton *Thredd_X_bt;
@property (nonatomic,weak) LXYHyperlinksButton *smallbt;
@property (nonatomic,weak) LXYHyperlinksButton *middlebt;
@property (nonatomic,weak) LXYHyperlinksButton *lagerbt;

@property (nonatomic,strong)UICollectionView *playerView;

@end


@implementation GoroundSettingView

-(instancetype)initWithFrame:(CGRect)frame{
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    self = [super initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
//    self.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.2];
    if (self) {
        [self createUI];
        self.All_Array = [NSMutableArray new];
                
    }
    return self;
}

-(void)createUI{

    self.settingDic = [[NSMutableDictionary alloc] init];
    [self.settingDic setObject:@"I’m IN!I’m 鷹!我們是台鋼天鷹!" forKey:@"showText"];
    [self.settingDic setObject:@"0" forKey:@"showBackgroundcolor_r"];
    [self.settingDic setObject:@"78" forKey:@"showBackgroundcolor_g"];
    [self.settingDic setObject:@"162" forKey:@"showBackgroundcolor_b"];
    [self.settingDic setObject:@"1.0" forKey:@"showBackgroundcolor_alpha"];
    
    [self.settingDic setObject:@"0" forKey:@"showTextcolor_r"];
    [self.settingDic setObject:@"0" forKey:@"showTextcolor_g"];
    [self.settingDic setObject:@"0" forKey:@"showTextcolor_b"];
    [self.settingDic setObject:@"1.0" forKey:@"showTextcolor_alpha"];
    
    [self.settingDic setObject:@"1.0" forKey:@"textsize"];
    [self.settingDic setObject:@"" forKey:@"playername"];
    [self.settingDic setObject:@"" forKey:@"playerNO"];
    [self.settingDic setObject:@"1.0" forKey:@"textspeed"];
    [self.settingDic setObject:@"0" forKey:@"phraseIndex"];//常用短语的index
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    UIView *bView = [[UIView alloc] initWithFrame:self.bounds];
    [bView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:bView];
    
    // 添加点击手势识别器 点击背景退出
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    // 要识别手势的点击次数
    tapGestureRecognizer.numberOfTapsRequired = 1;
    // 添加到主视图
    [bView addGestureRecognizer:tapGestureRecognizer];
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight/3)];
    baseView.backgroundColor = [UIColor colorWithRed:16.0/255.0 green:38.0/255.0 blue:73.0/255 alpha:1.0];
    baseView.layer.cornerRadius = 15;
    baseView.layer.masksToBounds = YES;
    self.baseView = baseView;
    [self addSubview:self.baseView];
    
    
    
    UILabel *title = [[UILabel alloc] init];
    title.text = @"歡呼模式";
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightBold];
    title.textColor = [UIColor whiteColor];
    
    [self.baseView addSubview:title];
    self.SettingTitleLabel = title;
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(15));
        make.top.mas_equalTo(ScaleW(32));
        make.width.mas_equalTo((ScaleW(150)));
        make.height.mas_equalTo(ScaleW(30));
    }];
    
    UITextField *searchTextF = [UITextField new];
    searchTextF.backgroundColor = [UIColor whiteColor];
    searchTextF.layer.borderWidth = 1;
    searchTextF.layer.cornerRadius = 5.0;
    searchTextF.textAlignment = NSTextAlignmentCenter;
    searchTextF.clearButtonMode = UITextFieldViewModeAlways;
    searchTextF.text = @"I’m IN!I’m 鷹!我們是台鋼天鷹!";
    searchTextF.delegate = self;
    [self.baseView addSubview:searchTextF];
    self.SettingContentString = searchTextF;
    
    [searchTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.SettingTitleLabel.mas_bottom).offset(ScaleW(5));
        make.left.mas_equalTo(self.SettingTitleLabel.mas_left);
        make.height.mas_equalTo(ScaleW(33));
        make.width.mas_equalTo(ScaleW(335));
    }];
    
    
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"SettingClose"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeSettingView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.baseView addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(ScaleW(-15));
        make.top.mas_equalTo(ScaleW(32));
        make.width.mas_equalTo(ScaleW(32));
        make.height.mas_equalTo(ScaleW(32));
    }];
    
    
    //欢呼短语 行
    title = [[UILabel alloc] init];
    title.text = @"歡呼短語";
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightBold];
    title.textColor = [UIColor whiteColor];
    
    [self.baseView addSubview:title];
    self.SettingTextLabel = title;
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(15));
        make.top.mas_equalTo(self.SettingContentString.mas_bottom).offset(ScaleW(10));
        make.width.mas_equalTo(ScaleW(70));
        make.height.mas_equalTo(ScaleW(30));
    }];
    
    
    //add 短语button
    LXYHyperlinksButton *bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(20, 150, 72, 32)];
    bt.titleLabel.font = [UIFont boldSystemFontOfSize:FontSize(14)];
    [bt setTitle:@"三振" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(setText:) forControlEvents:(UIControlEventTouchUpInside)];
    bt.tag = 30001;
    [self.baseView addSubview:bt];
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.SettingTextLabel.mas_right).offset(ScaleW(0));
        make.centerY.mas_equalTo(self.SettingTextLabel.mas_centerY);
        make.width.mas_equalTo(ScaleW(30));
        make.height.mas_equalTo(ScaleW(50));
    }];
    [bt setColor:[UIColor whiteColor]];
    self.sanzhenbt = bt;
    
    bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(20, 150, 72, 32)];
    bt.titleLabel.font = [UIFont boldSystemFontOfSize:FontSize(14)];
    [bt setTitle:@"全壘打" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(setText:) forControlEvents:(UIControlEventTouchUpInside)];
    bt.tag = 30002;
    [self.baseView addSubview:bt];
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sanzhenbt.mas_right).offset(ScaleW(5));
        make.centerY.mas_equalTo(self.SettingTextLabel.mas_centerY);
        make.width.mas_equalTo(ScaleW(50));
        make.height.mas_equalTo(ScaleW(50));
    }];
    [bt setColor:[UIColor colorWithRed:16.0/255.0 green:38.0/255.0 blue:73.0/255 alpha:1.0]];
    self.quanleidabt = bt;
    
    bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(20, 150, 72, 32)];
    bt.titleLabel.font = [UIFont boldSystemFontOfSize:FontSize(14)];
    [bt setTitle:@"台鋼天鷹" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(setText:) forControlEvents:(UIControlEventTouchUpInside)];
    bt.tag = 30003;
    [self.baseView addSubview:bt];
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.quanleidabt.mas_right).offset(ScaleW(5));
        make.centerY.mas_equalTo(self.SettingTextLabel.mas_centerY);
        make.width.mas_equalTo(ScaleW(72));
        make.height.mas_equalTo(ScaleW(50));
    }];
    [bt setColor:[UIColor colorWithRed:16.0/255.0 green:38.0/255.0 blue:73.0/255 alpha:1.0]];
    self.taigangxiongyingbt = bt;
    
    
    bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(20, 150, 72, 32)];
    bt.titleLabel.font = [UIFont boldSystemFontOfSize:FontSize(14)];
    [bt setTitle:@"加油" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(setText:) forControlEvents:(UIControlEventTouchUpInside)];
    bt.tag = 30004;
    [self.baseView addSubview:bt];
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.taigangxiongyingbt.mas_right).offset(ScaleW(5));
        make.centerY.mas_equalTo(self.SettingTextLabel.mas_centerY);
        make.width.mas_equalTo(ScaleW(30));
        make.height.mas_equalTo(ScaleW(50));
    }];
    [bt setColor:[UIColor colorWithRed:16.0/255.0 green:38.0/255.0 blue:73.0/255 alpha:1.0]];
    self.jiayoubt = bt;
    
    
    
    bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(20, 150, 72, 32)];
    bt.titleLabel.font = [UIFont boldSystemFontOfSize:FontSize(14)];
    [bt setTitle:@"翅膀硬了" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(setText:) forControlEvents:(UIControlEventTouchUpInside)];
    bt.tag = 30005;
    [self.baseView addSubview:bt];
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.jiayoubt.mas_right).offset(ScaleW(5));
        make.centerY.mas_equalTo(self.SettingTextLabel.mas_centerY);
        make.width.mas_equalTo(ScaleW(60));
        make.height.mas_equalTo(ScaleW(50));
    }];
    [bt setColor:[UIColor colorWithRed:16.0/255.0 green:38.0/255.0 blue:73.0/255 alpha:1.0]];
    self.chibangyinglebt = bt;
    
    //end 欢呼短语 行
    
    /*球队成员collection view*/
    title = [[UILabel alloc] init];
    title.text = @"球隊成員";
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightBold];
    title.textColor = [UIColor whiteColor];
    
    [self.baseView addSubview:title];
    self.playerTextLabel = title;
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.SettingTextLabel.mas_left);
        make.top.mas_equalTo(self.chibangyinglebt.mas_bottom);
        make.width.mas_equalTo(ScaleW(72));
        make.height.mas_equalTo(ScaleW(50));
    }];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//竖直滚动
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor= [UIColor colorWithRed:16.0/255.0 green:38.0/255.0 blue:73.0/255 alpha:1.0];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    [self.baseView addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.playerTextLabel.mas_centerY);
        make.left.mas_equalTo(self.playerTextLabel.mas_right);
        make.right.mas_equalTo(-ScaleW(20));
        make.height.mas_equalTo(ScaleW(30));
    }];
    [collectionView registerClass:[EGPlayerCollectionViewCell class] forCellWithReuseIdentifier:@"EGPlayerCollectionViewCell"];
    
    self.playerView = collectionView;
//    self.playerView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            [self getMemberlist];
//    }];
    //end 球队成员背号
    
    //字体大小 行
    title = [[UILabel alloc] init];
    title.text = @"字體大小";
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightBold];
    title.textColor = [UIColor whiteColor];
    
    [self.baseView addSubview:title];
    self.FontTextLabel = title;
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.SettingTextLabel.mas_left);
        make.top.mas_equalTo( self.playerView.mas_bottom).offset(ScaleW(0));
        make.width.mas_equalTo(ScaleW(72));
        make.height.mas_equalTo(ScaleW(50));
    }];
    
    
    //add 短语button
    bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(20, 150, 72, 32)];
    bt.titleLabel.font = [UIFont boldSystemFontOfSize:FontSize(16)];
    [bt setTitle:@"小" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(setTextsize:) forControlEvents:(UIControlEventTouchUpInside)];
    bt.tag = 30001;
    [self.baseView addSubview:bt];
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.SettingTextLabel.mas_right).offset(ScaleW(10));
        make.centerY.mas_equalTo(self.FontTextLabel.mas_centerY);
        make.width.mas_equalTo(ScaleW(30));
        make.height.mas_equalTo(ScaleW(50));
    }];
    [bt setColor:[UIColor colorWithRed:16.0/255.0 green:38.0/255.0 blue:73.0/255 alpha:1.0]];
    self.smallbt = bt;
    
    bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(20, 150, 72, 32)];
    bt.titleLabel.font = [UIFont boldSystemFontOfSize:FontSize(16)];
    [bt setTitle:@"中" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(setTextsize:) forControlEvents:(UIControlEventTouchUpInside)];
    bt.tag = 30002;
    [self.baseView addSubview:bt];
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sanzhenbt.mas_right).offset(ScaleW(25));
        make.centerY.mas_equalTo(self.FontTextLabel.mas_centerY);
        make.width.mas_equalTo(ScaleW(30));
        make.height.mas_equalTo(ScaleW(50));
    }];
    [bt setColor:[UIColor whiteColor]];
    self.middlebt = bt;
    
    bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(20, 150, 72, 32)];
    bt.titleLabel.font = [UIFont boldSystemFontOfSize:FontSize(16)];
    [bt setTitle:@"大" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(setTextsize:) forControlEvents:(UIControlEventTouchUpInside)];
    bt.tag = 30003;
    [self.baseView addSubview:bt];
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.quanleidabt.mas_right).offset(ScaleW(20));
        make.centerY.mas_equalTo(self.FontTextLabel.mas_centerY);
        make.width.mas_equalTo(ScaleW(30));
        make.height.mas_equalTo(ScaleW(50));
    }];
    [bt setColor:[UIColor colorWithRed:16.0/255.0 green:38.0/255.0 blue:73.0/255 alpha:1.0]];
    self.lagerbt = bt;
    
    //end
        
    //播放速度 行
    title = [[UILabel alloc] init];
    title.text = @"播放速度";
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightBold];
    title.textColor = [UIColor whiteColor];
    
    [self.baseView addSubview:title];
    self.SpeedLabel = title;
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.SettingTextLabel.mas_left);
        make.top.mas_equalTo(self.FontTextLabel.mas_bottom).offset(ScaleW(15));
        make.width.mas_equalTo((70));
        make.height.mas_equalTo((30));
    }];

    bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(20, 150, 72, 32)];
    bt.titleLabel.font = [UIFont boldSystemFontOfSize:FontSize(16)];
    [bt setTitle:@"0.8X" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(setSpeed:) forControlEvents:(UIControlEventTouchUpInside)];
    bt.tag = 20001;
    [self.baseView addSubview:bt];
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.smallbt.mas_centerX);
        make.centerY.mas_equalTo(self.SpeedLabel.mas_centerY);
        make.width.mas_equalTo(ScaleW(40));
        make.height.mas_equalTo(ScaleW(50));
    }];
    [bt setColor:[UIColor colorWithRed:16.0/255.0 green:38.0/255.0 blue:73.0/255 alpha:1.0]];
    self.One_X_bt = bt;
    
    bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(20, 150, 72, 32)];
    bt.titleLabel.font = [UIFont boldSystemFontOfSize:FontSize(16)];
    [bt setTitle:@"1X" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(setSpeed:) forControlEvents:(UIControlEventTouchUpInside)];
    bt.tag = 20002;
    [self.baseView addSubview:bt];
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.middlebt.mas_centerX);
        make.centerY.mas_equalTo(self.One_X_bt.mas_centerY);
        make.width.mas_equalTo(ScaleW(35));
        make.height.mas_equalTo(ScaleW(50));
    }];
    [bt setColor:[UIColor whiteColor]];
    self.Two_X_bt = bt;
    
    bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(20, 150, 72, 32)];
    bt.titleLabel.font = [UIFont boldSystemFontOfSize:FontSize(16)];
    [bt setTitle:@"1.5X" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(setSpeed:) forControlEvents:(UIControlEventTouchUpInside)];
    bt.tag = 20003;
    [self.baseView addSubview:bt];
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.lagerbt.mas_centerX);
        make.centerY.mas_equalTo(self.One_X_bt.mas_centerY);
        make.width.mas_equalTo(ScaleW(35));
        make.height.mas_equalTo(ScaleW(50));
    }];
    [bt setColor:[UIColor colorWithRed:16.0/255.0 green:38.0/255.0 blue:73.0/255 alpha:1.0]];
    self.Thredd_X_bt = bt;
    
    //end speed 行
    //颜色
    title = [[UILabel alloc] init];
    title.text = @"顏色";
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightBold];
    title.textColor = [UIColor whiteColor];
    [self.baseView addSubview:title];
    self.SettingColorLabel = title;
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.SettingTextLabel.mas_left);
        make.top.mas_equalTo(self.SpeedLabel.mas_bottom).offset(ScaleW(30));
        make.width.mas_equalTo(ScaleW(80));
        make.height.mas_equalTo(ScaleW(30));
    }];
    
    
    title = [[UILabel alloc] init];
    title.text = @"字體";
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightBold];
    title.textColor = [UIColor whiteColor];
    [self.baseView addSubview:title];
    self.fontColorLabel = title;
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.SettingColorLabel.mas_right);
        make.centerY.mas_equalTo(self.SettingColorLabel.mas_centerY);
        make.width.mas_equalTo(ScaleW(35));
        make.height.mas_equalTo(ScaleW(30));
    }];
    
    
    UIButton *blackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    blackButton.tag = 10001;
    blackButton.clipsToBounds = true;
    blackButton.layer.cornerRadius = ScaleW(32)/2;
    blackButton.layer.masksToBounds = YES;
    blackButton.layer.borderWidth = 2.0;
    blackButton.layer.borderColor = UIColor.whiteColor.CGColor;
    [blackButton addTarget:self action:@selector(colorSettingView:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.baseView addSubview:blackButton];
    [blackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.SettingColorLabel.mas_centerY);
        make.left.mas_equalTo(self.fontColorLabel.mas_right).offset(ScaleW(10));
        make.width.mas_equalTo(ScaleW(32));
        make.height.mas_equalTo(ScaleW(32));
    }];
    self.blackbt = blackButton;
    self.blackbt.selected = YES;
    
    title = [[UILabel alloc] init];
    title.text = @"背景";
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightBold];
    title.textColor = [UIColor whiteColor];
    [self.baseView addSubview:title];
    self.backColorLabel = title;
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.blackbt.mas_right).offset(ScaleW(50));
        make.top.mas_equalTo(self.SpeedLabel.mas_bottom).offset(ScaleW(30));
        make.width.mas_equalTo(ScaleW(35));
        make.height.mas_equalTo(ScaleW(30));
    }];
    
    UIButton *greanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    greanButton.tag = 10002;
    greanButton.clipsToBounds = true;
    greanButton.layer.cornerRadius = ScaleW(32)/2;
    greanButton.layer.masksToBounds = YES;
    greanButton.layer.borderWidth = 2.0;
    greanButton.layer.borderColor = UIColor.whiteColor.CGColor;
    [greanButton addTarget:self action:@selector(colorSettingView:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.baseView addSubview:greanButton];
    [greanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.SettingColorLabel.mas_centerY);
        make.left.mas_equalTo(self.backColorLabel.mas_right).offset(ScaleW(10));
        make.width.mas_equalTo(ScaleW(32));
        make.height.mas_equalTo(ScaleW(32));
    }];
    self.greenbt = greanButton;
    self.greenbt.selected = YES;
    
    self.blackbt.selected = YES;
    self.greenbt.selected = YES;

}


//弹出pickerView
- (void)popPickerView:(NSDictionary*)info
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    self.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:0];
    [[[[UIApplication sharedApplication]windows] firstObject] addSubview:self];

    self.baseView.frame = CGRectMake(0, Device_Height, screenWidth, screenHeight);
    self.baseView.alpha = 0.0;
    [UIView animateWithDuration:0.25
                     animations:^{
        self.baseView.alpha = 1.0;
        [self.baseView setFrame:CGRectMake(0,  ScaleH(320), Device_Width, Device_Height-ScaleH(320))];
        //[self.baseView setFrame:CGRectMake(0,  ScaleH(400), Device_Width, Device_Height-ScaleH(400))];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    }];
    
    //[self.playerView.mj_header beginRefreshing];
    [self getMemberlist];
    
    self.settingDic = [NSMutableDictionary dictionaryWithDictionary:info];
    [self updateUI];
}


-(void)updateUI
{
    self.SettingContentString.text = [self.settingDic objectForKey:@"showText"];
    
    [self.One_X_bt setColor:[UIColor colorWithRed:16.0/255.0 green:38.0/255.0 blue:73.0/255 alpha:1.0]];
    [self.Two_X_bt setColor:[UIColor colorWithRed:16.0/255.0 green:38.0/255.0 blue:73.0/255 alpha:1.0]];
    [self.Thredd_X_bt setColor:[UIColor colorWithRed:0 green:71.0/255.0 blue:56.0/255 alpha:1.0]];
    if([[self.settingDic objectForKey:@"textspeed"] floatValue]==0.5f)
        [self.One_X_bt setColor:UIColor.whiteColor] ;
    if([[self.settingDic objectForKey:@"textspeed"] floatValue]==1.0f)
        [self.Two_X_bt setColor:UIColor.whiteColor] ;
    if([[self.settingDic objectForKey:@"textspeed"] floatValue]==3.0f)
        [self.Thredd_X_bt setColor:UIColor.whiteColor] ;
    
    
    [self.smallbt setColor:[UIColor colorWithRed:16.0/255.0 green:38.0/255.0 blue:73.0/255 alpha:1.0]];
    [self.middlebt setColor:[UIColor colorWithRed:16.0/255.0 green:38.0/255.0 blue:73.0/255 alpha:1.0]];
    [self.lagerbt setColor:[UIColor colorWithRed:0 green:71.0/255.0 blue:56.0/255 alpha:1.0]];
    if([[self.settingDic objectForKey:@"textsize"] floatValue]==0.8f)
        [self.smallbt setColor:UIColor.whiteColor] ;
    if([[self.settingDic objectForKey:@"textsize"] floatValue]==1.0f)
        [self.middlebt setColor:UIColor.whiteColor] ;
    if([[self.settingDic objectForKey:@"textsize"] floatValue]==1.5f)
        [self.lagerbt setColor:UIColor.whiteColor] ;
    
    
    CGFloat back_r = [[self.settingDic objectForKey:@"showBackgroundcolor_r"] floatValue];
    CGFloat back_g = [[self.settingDic objectForKey:@"showBackgroundcolor_g"] floatValue];
    CGFloat back_b = [[self.settingDic objectForKey:@"showBackgroundcolor_b"] floatValue];
    CGFloat back_alpha = [[self.settingDic objectForKey:@"showBackgroundcolor_alpha"] floatValue];
    self.greenbt.backgroundColor = [UIColor colorWithRed:back_r/255.0 green:back_g/255.0 blue:back_b/255.0 alpha:back_alpha];
    
    CGFloat text_r = [[self.settingDic objectForKey:@"showTextcolor_r"] floatValue];
    CGFloat text_g = [[self.settingDic objectForKey:@"showTextcolor_g"] floatValue];
    CGFloat text_b = [[self.settingDic objectForKey:@"showTextcolor_b"] floatValue];
    CGFloat text_alpha = [[self.settingDic objectForKey:@"showTextcolor_alpha"] floatValue];
    self.blackbt.backgroundColor = [UIColor colorWithRed:text_r/255.0 green:text_g/255.0 blue:text_b/255.0 alpha:text_alpha];
    
    NSInteger phraseIndex = [[self.settingDic objectForKey:@"phraseIndex"] floatValue];
    [self.sanzhenbt setColor:[UIColor colorWithRed:16.0/255.0 green:38.0/255.0 blue:73.0/255 alpha:1.0]];
    [self.quanleidabt setColor:[UIColor colorWithRed:16.0/255.0 green:38.0/255.0 blue:73.0/255 alpha:1.0]];
    [self.taigangxiongyingbt setColor:[UIColor colorWithRed:16.0/255.0 green:38.0/255.0 blue:73.0/255 alpha:1.0]];
    [self.jiayoubt setColor:[UIColor colorWithRed:16.0/255.0 green:38.0/255.0 blue:73.0/255 alpha:1.0]];
    [self.chibangyinglebt setColor:[UIColor colorWithRed:16.0/255.0 green:38.0/255.0 blue:73.0/255 alpha:1.0]];
    switch (phraseIndex) {
        case 0:
        {
            [self.sanzhenbt setColor:[UIColor whiteColor]];
        }
            break;
            
        case 1:
            [self.quanleidabt setColor:[UIColor whiteColor]];
            break;
        case 2:
            [self.taigangxiongyingbt setColor:[UIColor whiteColor]];
            break;
        case 3:
            [self.jiayoubt setColor:[UIColor whiteColor]];
            break;
            
        case 4:
            [self.chibangyinglebt setColor:[UIColor whiteColor]];
            break;
    }
  
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self removeFromSuperview];
//        if(self.gBlock)
//        {
//            self.gBlock(self.settingDic);
//        }
    }
}

-(void)closeSettingView
{
    [self removeFromSuperview];
//    if(self.gBlock)
//    {
//        self.gBlock(self.settingDic);
//    }
}


-(void)colorSettingView:(UIButton*)bt
{
    self.blackbt.selected = YES;
    self.greenbt.selected = YES;
    
    GoroundColorView *picker = [[GoroundColorView alloc] init];
    picker.from_type = bt.tag;//10001 is from 字体颜色buttonclick
    
    CGFloat text_r= [[self.settingDic objectForKey:@"showTextcolor_r"] floatValue];
    CGFloat text_g = [[self.settingDic objectForKey:@"showTextcolor_g"] floatValue];
    CGFloat text_b = [[self.settingDic objectForKey:@"showTextcolor_b"] floatValue];
    CGFloat text_alpha = [[self.settingDic objectForKey:@"showTextcolor_alpha"] floatValue];
    CGFloat text_slider = [[self.settingDic objectForKey:@"showTextcolor_slider"] floatValue];
    CGFloat text_o_r = [[self.settingDic objectForKey:@"showTextcolor_original_r"] floatValue];
    CGFloat text_o_g = [[self.settingDic objectForKey:@"showTextcolor_original_g"] floatValue];
    CGFloat text_o_b = [[self.settingDic objectForKey:@"showTextcolor_original_b"] floatValue];
    CGFloat text_p_x = [[self.settingDic objectForKey:@"showTextcolor_point_x"] floatValue];
    CGFloat text_p_y = [[self.settingDic objectForKey:@"showTextcolor_point_y"] floatValue];
    
    picker.r_value = text_r;
    picker.g_value = text_g;
    picker.b_value = text_b;
    picker.alpha_value = text_alpha;
    picker.text_slider_value = text_slider;
    picker.text_original_r_value = text_o_r;
    picker.text_original_g_value = text_o_g;
    picker.text_original_b_value = text_o_b;
    picker.text_pointX_value = text_p_x;
    picker.text_pointY_value = text_p_y;
    
    CGFloat back_r= [[self.settingDic objectForKey:@"showBackgroundcolor_r"] floatValue];
    CGFloat back_g = [[self.settingDic objectForKey:@"showBackgroundcolor_g"] floatValue];
    CGFloat back_b = [[self.settingDic objectForKey:@"showBackgroundcolor_b"] floatValue];
    CGFloat back_alpha = [[self.settingDic objectForKey:@"showBackgroundcolor_alpha"] floatValue];
    CGFloat back_slider = [[self.settingDic objectForKey:@"showBackgroundcolor_slider"] floatValue];
    CGFloat back_o_r = [[self.settingDic objectForKey:@"showBackgroundcolor_original_r"] floatValue];
    CGFloat back_o_g = [[self.settingDic objectForKey:@"showBackgroundcolor_original_g"] floatValue];
    CGFloat back_o_b = [[self.settingDic objectForKey:@"showBackgroundcolor_original_b"] floatValue];
    CGFloat back_p_x = [[self.settingDic objectForKey:@"showBackgroundcolor_point_x"] floatValue];
    CGFloat back_p_y = [[self.settingDic objectForKey:@"showBackgroundcolor_point_y"] floatValue];
    picker.rback_value = back_r;
    picker.gback_value = back_g;
    picker.bback_value = back_b;
    picker.backalpha_value = back_alpha;
    picker.back_slider_value = back_slider;
    picker.back_original_r_value = back_o_r;
    picker.back_original_g_value = back_o_g;
    picker.back_original_b_value = back_o_b;
    picker.back_pointX_value = back_p_x;
    picker.back_pointY_value = back_p_y;
    
    [picker updateUI];
    
    picker.gcolorBlock = ^(NSMutableDictionary* dic){
        
        NSString *r_string = [NSString stringWithFormat:@"%f",[[dic objectForKey:@"r_color"] floatValue]];
        NSString *g_string = [NSString stringWithFormat:@"%f",[[dic objectForKey:@"g_color"] floatValue]];
        NSString *b_string = [NSString stringWithFormat:@"%f",[[dic objectForKey:@"b_color"] floatValue]];
        NSString *alpha_string = [NSString stringWithFormat:@"%f",[[dic objectForKey:@"alpha_color"] floatValue]];
        NSString *textslider = [NSString stringWithFormat:@"%f",[[dic objectForKey:@"textslider"] floatValue]];
        NSString *text_original_red = [NSString stringWithFormat:@"%f",[[dic objectForKey:@"text_original_r_value"] floatValue]];
        NSString *text_original_green = [NSString stringWithFormat:@"%f",[[dic objectForKey:@"text_original_g_value"] floatValue]];
        NSString *text_original_blue = [NSString stringWithFormat:@"%f",[[dic objectForKey:@"text_original_b_value"] floatValue]];
        NSString *text_point_x = [NSString stringWithFormat:@"%f",[[dic objectForKey:@"text_point_x"] floatValue]];
        NSString *text_point_y = [NSString stringWithFormat:@"%f",[[dic objectForKey:@"text_point_y"] floatValue]];
        
        
        NSString *rback_string = [NSString stringWithFormat:@"%f",[[dic objectForKey:@"rback_color"] floatValue]];
        NSString *gback_string = [NSString stringWithFormat:@"%f",[[dic objectForKey:@"gback_color"] floatValue]];
        NSString *bback_string = [NSString stringWithFormat:@"%f",[[dic objectForKey:@"bback_color"] floatValue]];
        NSString *backalpha_string = [NSString stringWithFormat:@"%f",[[dic objectForKey:@"backalpha_color"] floatValue]];
        NSString *backslider = [NSString stringWithFormat:@"%f",[[dic objectForKey:@"backslider"] floatValue]];
        NSString *back_original_red = [NSString stringWithFormat:@"%f",[[dic objectForKey:@"back_original_r_value"] floatValue]];
        NSString *back_original_green = [NSString stringWithFormat:@"%f",[[dic objectForKey:@"back_original_g_value"] floatValue]];
        NSString *back_original_blue = [NSString stringWithFormat:@"%f",[[dic objectForKey:@"back_original_b_value"] floatValue]];
        NSString *back_point_x = [NSString stringWithFormat:@"%f",[[dic objectForKey:@"back_point_x"] floatValue]];
        NSString *back_point_y = [NSString stringWithFormat:@"%f",[[dic objectForKey:@"back_point_y"] floatValue]];
        
        [self.settingDic setObject:r_string forKey:@"showTextcolor_r"];
        [self.settingDic setObject:g_string forKey:@"showTextcolor_g"];
        [self.settingDic setObject:b_string forKey:@"showTextcolor_b"];
        [self.settingDic setObject:alpha_string forKey:@"showTextcolor_alpha"];
        [self.settingDic setObject:textslider forKey:@"showTextcolor_slider"];
        [self.settingDic setObject:text_original_red forKey:@"showTextcolor_original_r"];
        [self.settingDic setObject:text_original_green forKey:@"showTextcolor_original_g"];
        [self.settingDic setObject:text_original_blue forKey:@"showTextcolor_original_b"];
        [self.settingDic setObject:text_point_x forKey:@"showTextcolor_point_x"];
        [self.settingDic setObject:text_point_y forKey:@"showTextcolor_point_y"];
        
        
        CGFloat text_r = [[dic objectForKey:@"r_color"] floatValue];
        CGFloat text_g = [[dic objectForKey:@"g_color"] floatValue];
        CGFloat text_b = [[dic objectForKey:@"b_color"] floatValue];
        CGFloat text_alpha = [[dic objectForKey:@"alpha_color"] floatValue];
        self.blackbt.backgroundColor = [UIColor colorWithRed:text_r/255.0 green:text_g/255.0 blue:text_b/255.0 alpha:text_alpha];
        
        
        [self.settingDic setObject:rback_string forKey:@"showBackgroundcolor_r"];
        [self.settingDic setObject:gback_string forKey:@"showBackgroundcolor_g"];
        [self.settingDic setObject:bback_string forKey:@"showBackgroundcolor_b"];
        [self.settingDic setObject:backalpha_string forKey:@"showBackgroundcolor_alpha"];
        [self.settingDic setObject:backslider forKey:@"showBackgroundcolor_slider"];
        [self.settingDic setObject:back_original_red forKey:@"showBackgroundcolor_original_r"];
        [self.settingDic setObject:back_original_green forKey:@"showBackgroundcolor_original_g"];
        [self.settingDic setObject:back_original_blue forKey:@"showBackgroundcolor_original_b"];
        [self.settingDic setObject:back_point_x forKey:@"showBackgroundcolor_point_x"];
        [self.settingDic setObject:back_point_y forKey:@"showBackgroundcolor_point_y"];
        
        CGFloat back_r = [[dic objectForKey:@"rback_color"] floatValue];
        CGFloat back_g = [[dic objectForKey:@"gback_color"] floatValue];
        CGFloat back_b = [[dic objectForKey:@"bback_color"] floatValue];
        CGFloat back_alpha = [[dic objectForKey:@"backalpha_color"] floatValue];
        self.greenbt.backgroundColor = [UIColor colorWithRed:back_r/255.0 green:back_g/255.0 blue:back_b/255.0 alpha:back_alpha];
        
//        NSInteger type = [[dic objectForKey:@"color_type"] intValue];
//        switch (type)
//        {
//            case 10001:
//            {
//                [self.settingDic setObject:r_string forKey:@"showTextcolor_r"];
//                [self.settingDic setObject:g_string forKey:@"showTextcolor_g"];
//                [self.settingDic setObject:b_string forKey:@"showTextcolor_b"];
//                [self.settingDic setObject:alpha_string forKey:@"showTextcolor_alpha"];
//                
//                CGFloat text_r = [[dic objectForKey:@"r_color"] floatValue];
//                CGFloat text_g = [[dic objectForKey:@"g_color"] floatValue];
//                CGFloat text_b = [[dic objectForKey:@"b_color"] floatValue];
//                CGFloat text_alpha = [[dic objectForKey:@"alpha_color"] floatValue];
//                self.blackbt.backgroundColor = [UIColor colorWithRed:text_r/255.0 green:text_g/255.0 blue:text_b/255.0 alpha:text_alpha];
//            }
//                break;
//                
//            case 10002:{
//                [self.settingDic setObject:rback_string forKey:@"showBackgroundcolor_r"];
//                [self.settingDic setObject:gback_string forKey:@"showBackgroundcolor_g"];
//                [self.settingDic setObject:bback_string forKey:@"showBackgroundcolor_b"];
//                [self.settingDic setObject:backalpha_string forKey:@"showBackgroundcolor_alpha"];
//                
//                
//                CGFloat back_r = [[dic objectForKey:@"rback_color"] floatValue];
//                CGFloat back_g = [[dic objectForKey:@"gback_color"] floatValue];
//                CGFloat back_b = [[dic objectForKey:@"bback_color"] floatValue];
//                CGFloat back_alpha = [[dic objectForKey:@"backalpha_color"] floatValue];
//                self.greenbt.backgroundColor = [UIColor colorWithRed:back_r/255.0 green:back_g/255.0 blue:back_b/255.0 alpha:back_alpha];
//            }
//                break;
//        }
                
        if(self.gBlock)
        {
            self.gBlock(self.settingDic);
        }
    } ;
    
    [picker popPickerView];
    
}

-(void)setTextsize:(LXYHyperlinksButton*)bt
{
    [self.smallbt setColor:[UIColor colorWithRed:16.0/255.0 green:38.0/255.0 blue:73.0/255 alpha:1.0]];
    [self.middlebt setColor:[UIColor colorWithRed:16.0/255.0 green:38.0/255.0 blue:73.0/255 alpha:1.0]];
    [self.lagerbt setColor:[UIColor colorWithRed:16.0/255.0 green:38.0/255.0 blue:73.0/255 alpha:1.0]];
    
    switch (bt.tag) {
        case 30001:
        {
            [self.smallbt setColor:[UIColor whiteColor]];
            [self.settingDic setObject:@"0.8" forKey:@"textsize"];
        }
            break;
        case 30002:
        {
            [self.middlebt setColor:[UIColor whiteColor]];
            [self.settingDic setObject:@"1.0" forKey:@"textsize"];
        }
            break;
        case 30003:
        {
            [self.lagerbt setColor:[UIColor whiteColor]];
            [self.settingDic setObject:@"1.5" forKey:@"textsize"];
        }
            break;
    }
    
    if(self.gBlock)
    {
        self.gBlock(self.settingDic);
    }
    
}

-(void)setText:(LXYHyperlinksButton*)bt
{
    [self.sanzhenbt setColor:[UIColor colorWithRed:16.0/255.0 green:38.0/255.0 blue:73.0/255 alpha:1.0]];
    [self.quanleidabt setColor:[UIColor colorWithRed:16.0/255.0 green:38.0/255.0 blue:73.0/255 alpha:1.0]];
    [self.taigangxiongyingbt setColor:[UIColor colorWithRed:16.0/255.0 green:38.0/255.0 blue:73.0/255 alpha:1.0]];
    [self.jiayoubt setColor:[UIColor colorWithRed:16.0/255.0 green:38.0/255.0 blue:73.0/255 alpha:1.0]];
    [self.chibangyinglebt setColor:[UIColor colorWithRed:16.0/255.0 green:38.0/255.0 blue:73.0/255 alpha:1.0]];
    
    
    switch (bt.tag) {
        case 30001:
        {
            [self.sanzhenbt setColor:[UIColor whiteColor]];
            [self.settingDic setObject:@"三振 !" forKey:@"showText"];
            [self.settingDic setObject:@"0" forKey:@"phraseIndex"];
        }
            break;
        case 30002:
        {
            [self.quanleidabt setColor:[UIColor whiteColor]];
            [self.settingDic setObject:@"全壘打" forKey:@"showText"];
            [self.settingDic setObject:@"1" forKey:@"phraseIndex"];
        }
            break;
        case 30003:
        {
            [self.taigangxiongyingbt setColor:[UIColor whiteColor]];
            [self.settingDic setObject:@"台鋼天鷹" forKey:@"showText"];
            [self.settingDic setObject:@"2" forKey:@"phraseIndex"];
        }
            break;
        case 30004:
        {
            [self.jiayoubt setColor:[UIColor whiteColor]];
            [self.settingDic setObject:@"加油" forKey:@"showText"];
            [self.settingDic setObject:@"3" forKey:@"phraseIndex"];
        }
            break;
        case 30005:
        {
            [self.chibangyinglebt setColor:[UIColor whiteColor]];
            [self.settingDic setObject:@"翅膀硬了" forKey:@"showText"];
            [self.settingDic setObject:@"4" forKey:@"phraseIndex"];
        }
            break;
        default:
            break;
    }
    
    if(self.gBlock)
    {
        self.gBlock(self.settingDic);
    }
    
    NSString *meg_str = @"";
    NSString *player_name = [self.settingDic objectForKey:@"playername"];
    NSString *player_num = [self.settingDic objectForKey:@"playerNO"];
    meg_str = [NSString stringWithFormat:@"%@ %@ %@",[self.settingDic objectForKey:@"showText"],player_name,player_num];
    self.SettingContentString.text = meg_str;
}


-(void)setSpeed:(LXYHyperlinksButton*)bt
{
    [self.One_X_bt setColor:[UIColor colorWithRed:16.0/255.0 green:38.0/255.0 blue:73.0/255 alpha:1.0]];
    [self.Two_X_bt setColor:[UIColor colorWithRed:16.0/255.0 green:38.0/255.0 blue:73.0/255 alpha:1.0]];
    [self.Thredd_X_bt setColor:[UIColor colorWithRed:16.0/255.0 green:38.0/255.0 blue:73.0/255 alpha:1.0]];
    
    switch (bt.tag) {
        case 20001:
        {
            [self.One_X_bt setColor:[UIColor whiteColor]];
            [self.settingDic setObject:@"0.5" forKey:@"textspeed"];
        }
            break;
        case 20002:
        {
            [self.Two_X_bt setColor:[UIColor whiteColor]];
            [self.settingDic setObject:@"1.0" forKey:@"textspeed"];
        }
            break;
        case 20003:
        {
            [self.Thredd_X_bt setColor:[UIColor whiteColor]];
            [self.settingDic setObject:@"3.0" forKey:@"textspeed"];
        }
            break;
    }
    
    if(self.gBlock)
    {
        self.gBlock(self.settingDic);
    }
}

#pragma mark 获取球员信息页面
-(NSArray*)inorderArray
{
    NSArray *sortedArray;
    return sortedArray = [self.All_playerArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSInteger valueA = [a[@"UniformNo"] integerValue];
            NSInteger valueB = [b[@"UniformNo"] integerValue];
            return valueA > valueB;
        }];
  
    
}

-(void)getMemberlistforPreyear
{
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentDate];
    NSInteger currentMonth = [components year]-1;
    NSString *currentMonthstringValue = [NSString stringWithFormat:@"%ld", (long)currentMonth];

    NSString *authString = [NSString stringWithFormat:@"%@:%@", [[EGCredentialManager sharedManager] getUsername], [[EGCredentialManager sharedManager] getPassword]];    // Base64 编码
    NSData *authData = [authString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64AuthString = [authData base64EncodedStringWithOptions:0];
    // 添加 Basic Auth 请求头
    NSString *authHeader = [NSString stringWithFormat:@"Basic %@", base64AuthString];
 
    NSDictionary *dict_header = @{@"Authorization":authHeader};
    //[MBProgressHUD showMessage:@"數據獲取中...."];
    NSString *url = [EGServerAPI getTeamMembers:currentMonthstringValue];
    [[WAFNWHTTPSTool sharedManager] getWithURL:url parameters:@{} headers:@{} success:^(id  _Nonnull response) {
        self.All_playerArray = response[@"ResponseDto"];
        self.All_playerArray = [self inorderArray];
        [self mergeArray];
        //[self.playerView.mj_header endRefreshing];
        
        [self.playerView reloadData];
    } failure:^(NSError * _Nonnull error) {
        //[self.playerView.mj_header endRefreshing];
    }];
    
}
-(void)getMemberlist
{
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentDate];
    NSInteger currentMonth = [components year];
    NSString *currentMonthstringValue = [NSString stringWithFormat:@"%ld", (long)currentMonth];
    
    NSString *authString = [NSString stringWithFormat:@"%@:%@", [[EGCredentialManager sharedManager] getUsername], [[EGCredentialManager sharedManager] getPassword]];
    // Base64 编码
    NSData *authData = [authString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64AuthString = [authData base64EncodedStringWithOptions:0];
    // 添加 Basic Auth 请求头
    NSString *authHeader = [NSString stringWithFormat:@"Basic %@", base64AuthString];
 
    NSDictionary *dict_header = @{@"Authorization":authHeader};
    //[MBProgressHUD showMessage:@"數據獲取中...."];
    NSString *url = [EGServerAPI getTeamMembers:currentMonthstringValue];
    [[WAFNWHTTPSTool sharedManager] getWithURL:url parameters:@{} headers:@{} success:^(id  _Nonnull response) {
        
        self.All_playerArray = response[@"ResponseDto"];
        if(self.All_playerArray.count>0)
        {
            self.All_playerArray = [self inorderArray];
            [self mergeArray];
        }
        else
        {
            [self getMemberlistforPreyear];
        }
       
        //[self.playerView.mj_header endRefreshing];
        [self.playerView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        //[self.playerView.mj_header endRefreshing];
    }];
    
}


-(void)mergeArray
{
    
    for(int i=0;i<self.All_playerArray.count;i++)
    {
        self.All_ArrayDic = [NSMutableDictionary new];
        [self.All_ArrayDic setObject:[self.All_playerArray objectAtIndex:i] forKey:@"playeritem"];
        [self.All_ArrayDic setObject:@"0" forKey:@"hightlight"];
        [self.All_Array addObject:self.All_ArrayDic];
    }
}

#pragma mark -----------TextField delegate---------------
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self.settingDic setObject:@"" forKey:@"showText"];
    [self.settingDic setObject:@"" forKey:@"playername"];
    [self.settingDic setObject:@"" forKey:@"playerNO"];
    
    
    if(self.gBlock)
    {
        self.gBlock(self.settingDic);
    }
    return YES;
    
}

- (void)textFieldDidChangeSelection:(UITextField *)textField
{
    NSString *currentText = textField.text;
        NSInteger maxLength = 21; // 例如限制最大长度为20个字符
        if (currentText.length > maxLength) {
            textField.text = [currentText substringToIndex:maxLength];
            [self.settingDic setObject:[currentText substringToIndex:maxLength] forKey:@"showText"];
        }
        else
        {
            [self.settingDic setObject:currentText forKey:@"showText"];
        }

    
    if(self.gBlock)
    {
        self.gBlock(self.settingDic);
    }
}


#pragma  mark collection View for  delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.All_Array.count;
}

//// 4. 设置 footer 大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    return CGSizeMake(collectionView.frame.size.width, 0); // 设置高度为50
//}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EGPlayerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EGPlayerCollectionViewCell" forIndexPath:indexPath];
    if(indexPath.item<self.All_Array.count)
    {
        NSDictionary *All_dic = [self.All_Array objectAtIndex:indexPath.item];
        NSDictionary*dic = [All_dic objectForKey:@"playeritem"];
        
        if([[All_dic objectForKey:@"hightlight"] intValue]==0){
            cell.titleLB.textColor = UIColor.whiteColor;
            cell.baseView.backgroundColor = [UIColor colorWithRed:16.0/255.0 green:38.0/255.0 blue:73.0/255 alpha:1.0];
        }
        else{
            cell.baseView.backgroundColor = UIColor.whiteColor;
            cell.titleLB.textColor = UIColor.blackColor;
        }
        
        [cell setInfo:dic];
    }
    return cell;
}
//选中 collectionView
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{    
    [self.All_Array removeAllObjects];
    for(int i=0;i<self.All_playerArray.count;i++)
    {
        self.All_ArrayDic = [NSMutableDictionary new];
        [self.All_ArrayDic setObject:[self.All_playerArray objectAtIndex:i] forKey:@"playeritem"];
        [self.All_ArrayDic setObject:@"0" forKey:@"hightlight"];
        [self.All_Array addObject:self.All_ArrayDic];
    }
    
    if(indexPath.item<self.All_playerArray.count)
    {
        NSDictionary *dic = [self.All_playerArray objectAtIndex:indexPath.item];
        [self.settingDic setObject:[dic objectForKey:@"CHName"] forKey:@"playername"];
        [self.settingDic setObject:[dic objectForKey:@"UniformNo"] forKey:@"playerNO"];
        
        NSMutableDictionary *info = [NSMutableDictionary new];
        [info setObject:[self.All_playerArray objectAtIndex:indexPath.item] forKey:@"playeritem"];
        [info setObject:@"1" forKey:@"hightlight"];
        [self.All_Array replaceObjectAtIndex:indexPath.item withObject:info];
        
        [self.playerView reloadData];
    }
    
    
    NSString *player_name = [self.settingDic objectForKey:@"playername"];
    NSString *player_num = [self.settingDic objectForKey:@"playerNO"];
    NSString *meg_str = [NSString stringWithFormat:@"%@ %@ %@",[self.settingDic objectForKey:@"showText"],player_name,player_num];
    self.SettingContentString.text = meg_str;
    [self.settingDic setObject:meg_str forKey:@"showText"];
    
    if(self.gBlock)
    {
        self.gBlock(self.settingDic);
    }
    
    
    
}
// 设置cell大小 itemSize：可以给每一个cell指定不同的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat width =ScaleW(56);
    CGFloat height =ScaleW(23);
    return CGSizeMake(width, height);
}
// 设置UIcollectionView整体的内边距（这样item不贴边显示）
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // 上 左 下 右
    return UIEdgeInsetsMake(0,0,0,0);
}
// 设置minimumLineSpacing：cell上下之间最小的距离(一行左右间距)
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
// 设置minimumInteritemSpacing：cell左右之间最小的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
/*
#pragma mark----------Color------------
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject]; // 获取任意一个触摸对象
    
    if(self.blackbt.state==1)
    {
        CGPoint location = [touch locationInView:_textcolor_View];
        NSLog(@"location = %@",NSStringFromCGPoint(location));
        UIColor * color = [self colorAtPixel:location inImage:[UIImage imageNamed:@"colorselect"]];
        self.blackbt.backgroundColor = color;
    }// 获取触摸点相对于当前视图的坐标
    else
    {
        CGPoint location = [touch locationInView:_backcolor_View];
        UIColor * color = [self colorAtPixel:location inImage:[UIImage imageNamed:@"colorselect"]];
        self.greenbt.backgroundColor = color;
    }
    
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    UITouch *touch = [touches anyObject]; // 获取任意一个触摸对象
    
    if(self.blackbt.state==1)
    {
        CGPoint location = [touch locationInView:_textcolor_View];
        NSLog(@"location = %@",NSStringFromCGPoint(location));
        UIColor * color = [self colorAtPixel:location inImage:[UIImage imageNamed:@"colorselect"]];
        self.blackbt.backgroundColor = color;
    }// 获取触摸点相对于当前视图的坐标
    else
    {
        CGPoint location = [touch locationInView:_backcolor_View];
        UIColor * color = [self colorAtPixel:location inImage:[UIImage imageNamed:@"colorselect"]];
        self.greenbt.backgroundColor = color;
    }
}


- (UIColor *)colorAtPixel:(CGPoint)point inImage:(UIImage *)image {
    // 首先，将UIImage转换为CGImage
    CGImageRef inImage = image.CGImage;
    
    // 获取图像的宽度和高度
    size_t width = CGImageGetWidth(inImage);
    size_t height = CGImageGetHeight(inImage);
    
    // 创建一个颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // 如果像素在图像之外，返回nil
    if (point.x < 0 || point.y < 0 || point.x >= width || point.y >= height) {
        CGColorSpaceRelease(colorSpace);
        return nil;
    }
    
    // 创建一个可以绘制图像的位图上下文
    unsigned char *rawData = malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    // 在位图上下文中绘制图像
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), inImage);
    
    // 读取像素数据
    int byteIndex = (bytesPerRow * point.y) + point.x * bytesPerPixel;
    CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
    CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
    CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
    CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
    
    // 清理并返回颜色对象
    CGContextRelease(context);
    free(rawData);
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (void)handleGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        self.textcolor_View.hidden = YES;
        self.backcolor_View.hidden = YES;
    }
}
*/
@end
	
