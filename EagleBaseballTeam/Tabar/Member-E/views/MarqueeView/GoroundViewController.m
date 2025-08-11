//
//  ViewController.m
//  UUMarqueeViewDemo
//
//  Created by dragon on 25/01/7.
//  Copyright © 2025年 iceyouyou. All rights reserved.
//

#import "GoroundViewController.h"
#import "UUMarqueeView.h"
#import "GoroundSettingView.h"

#define textbase_Speed  300.0f
#define textbase_Size  200.0f

@interface GoroundViewController () <UUMarqueeViewDelegate>

@property (nonatomic, strong) UUMarqueeView *leftwardMarqueeView;

@property (nonatomic, strong) NSArray *leftwardMarqueeViewData;

@property (nonatomic, strong) UIColor *textcolor;

@property (nonatomic, strong)UIColor *backcolor;

@property (nonatomic,assign)NSInteger textspeed;

@property (nonatomic,assign)CGFloat textsize;

@property (nonatomic,strong)UIButton *closebt;

@property (nonatomic,strong)UIButton *settingbt;

@property (nonatomic,strong)NSMutableDictionary *MarqueeDic;

@end

@implementation GoroundViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    // something good for saving energy
    if (_leftwardMarqueeView) {
        [_leftwardMarqueeView start];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.backgroundColor = UIColor.clearColor;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.backgroundColor = rgba(16, 38, 73, 1);
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [UIView setAnimationsEnabled:YES];
    
    if (_leftwardMarqueeView) {
        [_leftwardMarqueeView pause];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    [self.view setBackgroundColor:UIColor.whiteColor];

    //旋转屏幕，可是仅仅旋转当前的View
    self.view.transform = CGAffineTransformMakeRotation(M_PI/2);
    self.view.bounds = CGRectMake(0, 0, screenHeight, screenWidth);

    NSDictionary *MarqueeinfoDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"Marqueeinfo"];
    if(MarqueeinfoDic)
    {
        self.MarqueeDic = [NSMutableDictionary dictionaryWithDictionary:MarqueeinfoDic];
        [self.MarqueeDic setObject:@"" forKey:@"playerNO"];
        [self.MarqueeDic setObject:@"" forKey:@"playername"];
        
        CGFloat back_r = [[self.MarqueeDic objectForKey:@"showBackgroundcolor_r"] floatValue];
        CGFloat back_g = [[self.MarqueeDic objectForKey:@"showBackgroundcolor_g"] floatValue];
        CGFloat back_b = [[self.MarqueeDic objectForKey:@"showBackgroundcolor_b"] floatValue];
        CGFloat back_alpha = [[self.MarqueeDic objectForKey:@"showBackgroundcolor_alpha"] floatValue];
        
        self.backcolor = [UIColor colorWithRed:back_r/255.0 green:back_g/255.0 blue:back_b/255.0 alpha:back_alpha];
        
        CGFloat text_r = [[self.MarqueeDic objectForKey:@"showTextcolor_r"] floatValue];
        CGFloat text_g = [[self.MarqueeDic objectForKey:@"showTextcolor_g"] floatValue];
        CGFloat text_b = [[self.MarqueeDic objectForKey:@"showTextcolor_b"] floatValue];
        CGFloat text_alpha = [[self.MarqueeDic objectForKey:@"showTextcolor_alpha"] floatValue];
        self.textcolor = [UIColor colorWithRed:text_r/255.0 green:text_g/255.0 blue:text_b/255.0 alpha:text_alpha];
        
        self.textspeed = textbase_Speed * [[self.MarqueeDic objectForKey:@"textspeed"] floatValue];
        self.textsize = textbase_Size * [[self.MarqueeDic objectForKey:@"textsize"] floatValue];
    }
    else
    {
        _MarqueeDic = [NSMutableDictionary new];
        [self.MarqueeDic setObject:@"I’m IN!I’m 鷹!我們是台天天鷹!" forKey:@"showText"];
        
        [self.MarqueeDic setObject:@"0" forKey:@"showBackgroundcolor_r"];
        [self.MarqueeDic setObject:@"78" forKey:@"showBackgroundcolor_g"];
        [self.MarqueeDic setObject:@"162" forKey:@"showBackgroundcolor_b"];
        [self.MarqueeDic setObject:@"1.0" forKey:@"showBackgroundcolor_alpha"];
        [self.MarqueeDic setObject:@"0.0" forKey:@"showBackgroundcolor_slider"];
        [self.MarqueeDic setObject:@"0" forKey:@"showBackgroundcolor_original_r"];
        [self.MarqueeDic setObject:@"78" forKey:@"showBackgroundcolor_original_g"];
        [self.MarqueeDic setObject:@"162" forKey:@"showBackgroundcolor_original_b"];
        [self.MarqueeDic setObject:@"0" forKey:@"showBackgroundcolor_point_x"];
        [self.MarqueeDic setObject:@"0" forKey:@"showBackgroundcolor_point_y"];
        
        [self.MarqueeDic setObject:@"0" forKey:@"showTextcolor_r"];
        [self.MarqueeDic setObject:@"0" forKey:@"showTextcolor_g"];
        [self.MarqueeDic setObject:@"0" forKey:@"showTextcolor_b"];
        [self.MarqueeDic setObject:@"1.0" forKey:@"showTextcolor_alpha"];
        [self.MarqueeDic setObject:@"0.0" forKey:@"showTextcolor_slider"];
        [self.MarqueeDic setObject:@"0" forKey:@"showTextcolor_original_r"];
        [self.MarqueeDic setObject:@"0" forKey:@"showTextcolor_original_g"];
        [self.MarqueeDic setObject:@"0" forKey:@"showTextcolor_original_b"];
        [self.MarqueeDic setObject:@"0" forKey:@"showTextcolor_point_x"];
        [self.MarqueeDic setObject:@"0" forKey:@"showTextcolor_point_y"];
        
        [self.MarqueeDic setObject:@"1.0" forKey:@"textsize"];
        [self.MarqueeDic setObject:@"" forKey:@"playername"];
        [self.MarqueeDic setObject:@"" forKey:@"playerNO"];
        [self.MarqueeDic setObject:@"1.0" forKey:@"textspeed"];
        [self.MarqueeDic setObject:@"0" forKey:@"phraseIndex"];
        
        CGFloat back_r = [[self.MarqueeDic objectForKey:@"showBackgroundcolor_r"] floatValue];
        CGFloat back_g = [[self.MarqueeDic objectForKey:@"showBackgroundcolor_g"] floatValue];
        CGFloat back_b = [[self.MarqueeDic objectForKey:@"showBackgroundcolor_b"] floatValue];
        CGFloat back_alpha = [[self.MarqueeDic objectForKey:@"showBackgroundcolor_alpha"] floatValue];
        self.backcolor = [UIColor colorWithRed:back_r/255.0 green:back_g/255.0 blue:back_b/255.0 alpha:back_alpha];
        
        CGFloat text_r = [[self.MarqueeDic objectForKey:@"showTextcolor_r"] floatValue];
        CGFloat text_g = [[self.MarqueeDic objectForKey:@"showTextcolor_g"] floatValue];
        CGFloat text_b = [[self.MarqueeDic objectForKey:@"showTextcolor_b"] floatValue];
        CGFloat text_alpha = [[self.MarqueeDic objectForKey:@"showTextcolor_alpha"] floatValue];
        self.textcolor = [UIColor colorWithRed:text_r/255.0 green:text_g/255.0 blue:text_b/255.0 alpha:text_alpha];
        
        self.textspeed = textbase_Speed * [[self.MarqueeDic objectForKey:@"textspeed"] floatValue];
        self.textsize = textbase_Size * [[self.MarqueeDic objectForKey:@"textsize"] floatValue];
        
        [[NSUserDefaults standardUserDefaults] setObject:_MarqueeDic forKey:@"Marqueeinfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    [self prepareDataSource];
    
    // Leftward MarqueeView
    self.leftwardMarqueeView = [[UUMarqueeView alloc] initWithFrame:CGRectMake(0, 0, screenHeight, screenWidth) direction:UUMarqueeViewDirectionLeftward];
    _leftwardMarqueeView.delegate = self;
    _leftwardMarqueeView.timeIntervalPerScroll = 0.0f;
    _leftwardMarqueeView.scrollSpeed = self.textspeed;
    _leftwardMarqueeView.itemSpacing = 20.0f;
    [self.view addSubview:_leftwardMarqueeView];
    [_leftwardMarqueeView reloadData];
    //[UIView setAnimationsEnabled:NO];    //
    
    GoroundSettingView *picker = [[GoroundSettingView alloc] init];
    
    picker.gBlock = ^(NSMutableDictionary* dic){
        NSString *player_name = [dic objectForKey:@"playername"];
        NSString *player_num = [dic objectForKey:@"playerNO"];
        NSString *meg_str = [NSString stringWithFormat:@"%@ %@ %@",[dic objectForKey:@"showText"],player_name,player_num];
        self.leftwardMarqueeViewData = [NSArray arrayWithObject:meg_str];
        
        CGFloat text_r = [[dic objectForKey:@"showTextcolor_r"] floatValue];
        CGFloat text_g = [[dic objectForKey:@"showTextcolor_g"] floatValue];
        CGFloat text_b = [[dic objectForKey:@"showTextcolor_b"] floatValue];
        CGFloat text_alpha = [[dic objectForKey:@"showTextcolor_alpha"] floatValue];
        self.textcolor = [UIColor colorWithRed:text_r/255.0 green:text_g/255.0 blue:text_b/255.0 alpha:text_alpha];
        
        
        CGFloat back_r = [[dic objectForKey:@"showBackgroundcolor_r"] floatValue];
        CGFloat back_g = [[dic objectForKey:@"showBackgroundcolor_g"] floatValue];
        CGFloat back_b = [[dic objectForKey:@"showBackgroundcolor_b"] floatValue];
        CGFloat back_alpha = [[dic objectForKey:@"showBackgroundcolor_alpha"] floatValue];
        self.backcolor = [UIColor colorWithRed:back_r/255.0 green:back_g/255.0 blue:back_b/255.0 alpha:back_alpha];
        
        
        self.textspeed = textbase_Speed * [[dic objectForKey:@"textspeed"] floatValue];
        self.textsize = textbase_Size * [[dic objectForKey:@"textsize"] floatValue];
        self.leftwardMarqueeView.timeIntervalPerScroll = 0.0f;
        self.leftwardMarqueeView.scrollSpeed = self.textspeed;
        self.leftwardMarqueeView.itemSpacing = 20.0f;
        
        [UIView setAnimationsEnabled:YES];
        [self.leftwardMarqueeView start];
        [self.leftwardMarqueeView reloadData];
        
        
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"Marqueeinfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } ;
    [picker popPickerView:self.MarqueeDic];
    
    UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
    [backView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:backView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [backView addGestureRecognizer:tapGestureRecognizer];
    
    [self setUI];
}

-(void)setUI
{
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"paomadengback"] forState:UIControlStateNormal];
    closeButton.transform = CGAffineTransformMakeRotation(M_PI * 270.0 / 180.0); // 45度
    [closeButton addTarget:self action:@selector(backView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(60));
        make.top.mas_equalTo(ScaleW(15));
        make.width.mas_equalTo(ScaleW(48));
        make.height.mas_equalTo(ScaleW(48));
    }];
    self.closebt = closeButton;
    //self.closebt.hidden = YES;
    
    UIButton *setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [setButton setImage:[UIImage imageNamed:@"paomadengset"] forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(showSettingView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:setButton];
    [setButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(ScaleW(-60));
        make.top.mas_equalTo(ScaleW(15));
        make.width.mas_equalTo(ScaleW(48));
        make.height.mas_equalTo(ScaleW(48));
    }];
    self.settingbt = setButton;
    //self.settingbt.hidden = YES;
}





#pragma mark - UUMarqueeViewDelegate
- (NSUInteger)numberOfVisibleItemsForMarqueeView:(UUMarqueeView*)marqueeView {
        // for upwardDynamicHeightMarqueeView
        return 2;
    
}

- (NSUInteger)numberOfDataForMarqueeView:(UUMarqueeView*)marqueeView {
        // for leftwardMarqueeView
        return _leftwardMarqueeViewData ? _leftwardMarqueeViewData.count : 0;
}

- (void)createItemView:(UIView*)itemView forMarqueeView:(UUMarqueeView*)marqueeView {
   
        // for leftwardMarqueeView
    itemView.backgroundColor = self.backcolor;//[UIColor yellowColor];

        UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(5.0f + 16.0f + 5.0f, 0.0f, CGRectGetWidth(itemView.bounds) - 5.0f - 16.0f - 5.0f - 5.0f, CGRectGetHeight(itemView.bounds))];
        content.font = [UIFont boldSystemFontOfSize:self.textsize];
        content.textColor = self.textcolor;//[UIColor blackColor];
        content.tag = 1001;
        
        [itemView addSubview:content];
}

- (void)updateItemView:(UIView*)itemView atIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {
    {
        // for leftwardMarqueeView
        UILabel *content = [itemView viewWithTag:1001];
        content.text = _leftwardMarqueeViewData[index];
    }
}



- (CGFloat)itemViewWidthAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {
    // for leftwardMarqueeView
    UILabel *content = [[UILabel alloc] init];
    content.font = [UIFont boldSystemFontOfSize:self.textsize];
    content.text = _leftwardMarqueeViewData[index];
    return (5.0f + 16.0f + 5.0f) + content.intrinsicContentSize.width;  // icon width + label width (it's perfect to cache them all)
}

- (void)didTouchItemViewAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {
}

#pragma mark - Nothing Important
- (void)prepareDataSource {
    self.leftwardMarqueeViewData = [NSArray arrayWithObject:[self.MarqueeDic objectForKey:@"showText"]];
}

- (void)handleLeftwardPauseAction:(id)sender {
    if (_leftwardMarqueeView) {
        [_leftwardMarqueeView pause];
    }
}

-(void)backView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showSettingView
{
    self.MarqueeDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"Marqueeinfo"]];
    [self.MarqueeDic setObject:@"" forKey:@"playername"];
    [self.MarqueeDic setObject:@"" forKey:@"playerNO"];
    
    GoroundSettingView *picker = [[GoroundSettingView alloc] init];
    picker.gBlock = ^(NSMutableDictionary* dic){
        NSString *player_name = [dic objectForKey:@"playername"];
        NSString *player_num = [dic objectForKey:@"playerNO"];
        NSString *meg_str = [NSString stringWithFormat:@"%@ %@ %@",[dic objectForKey:@"showText"],player_name,player_num];
        self.leftwardMarqueeViewData = [NSArray arrayWithObject:meg_str];
        CGFloat back_r = [[dic objectForKey:@"showBackgroundcolor_r"] floatValue];
        CGFloat back_g = [[dic objectForKey:@"showBackgroundcolor_g"] floatValue];
        CGFloat back_b = [[dic objectForKey:@"showBackgroundcolor_b"] floatValue];
        CGFloat back_alpha = [[dic objectForKey:@"showBackgroundcolor_alpha"] floatValue];
        self.backcolor = [UIColor colorWithRed:back_r/255.0 green:back_g/255.0 blue:back_b/255.0 alpha:back_alpha];
        
        CGFloat text_r = [[dic objectForKey:@"showTextcolor_r"] floatValue];
        CGFloat text_g = [[dic objectForKey:@"showTextcolor_g"] floatValue];
        CGFloat text_b = [[dic objectForKey:@"showTextcolor_b"] floatValue];
        CGFloat text_alpha = [[dic objectForKey:@"showTextcolor_alpha"] floatValue];
        self.textcolor = [UIColor colorWithRed:text_r/255.0 green:text_g/255.0 blue:text_b/255.0 alpha:text_alpha];
        self.textspeed = textbase_Speed * [[dic objectForKey:@"textspeed"] floatValue];
        self.textsize = textbase_Size * [[dic objectForKey:@"textsize"] floatValue];
        self.leftwardMarqueeView.timeIntervalPerScroll = 0.0f;
        self.leftwardMarqueeView.scrollSpeed = self.textspeed;
        self.leftwardMarqueeView.itemSpacing = 20.0f;
        [UIView setAnimationsEnabled:YES];
        [self.leftwardMarqueeView start];
        [self.leftwardMarqueeView reloadData];
        
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"Marqueeinfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } ;
    [self prepareDataSource];
    [picker popPickerView:self.MarqueeDic];
    
    //[self.leftwardMarqueeView pause];
    
}

- (void)handleGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        if(self.closebt.hidden)
            self.closebt.hidden = NO;
        else
            self.closebt.hidden = YES;
        
        if(self.settingbt.hidden)
            self.settingbt.hidden = NO;
        else
            self.settingbt.hidden = YES;
    }
}

@end
