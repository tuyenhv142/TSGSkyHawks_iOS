//
//  OASearchFilterView.m
//  NewsoftOA24
//
//  Created by rick on 7/31/24.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import "EGShowMusicTextView.h"


@interface EGShowMusicTextView ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
{
}

@property (nonatomic,weak) UIView * baseView;
@property (nonatomic,weak) UIButton *cancelBtn;
@property (nonatomic,weak) UILabel *Title;
@property (nonatomic,weak) UITextView* showMusic;
@end


@implementation EGShowMusicTextView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, Device_Width, Device_Height)];
//    self.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.2];
    if (self) {
   
        [self createUI];
        
    }
    return self;
}

-(void)createUI{
    UIView *bView = [[UIView alloc] initWithFrame:self.bounds];
    [bView setBackgroundColor:rgba(0, 0, 0, 0.0)];
    [self addSubview:bView];
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0,[UIDevice de_navigationFullHeight], Device_Width, Device_Height-ScaleH(50))];
    baseView.backgroundColor = [UIColor whiteColor];
    baseView.layer.cornerRadius = 15;
    baseView.layer.masksToBounds = YES;
    self.baseView = baseView;
    [self addSubview:self.baseView ];
    
    UILabel *title = [[UILabel alloc] init];
    title.text = @"歌词";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = rgba(23, 43, 77, 1);
    title.font = [UIFont systemFontOfSize:FontSize(18) weight:UIFontWeightBold];
    
    [self.baseView addSubview:title];
    self.Title = title;
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleH(12));
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(Device_Width);
        make.height.mas_equalTo(ScaleW(30));
    }];

    UITextView *view = [[UITextView alloc] init];
    view.textAlignment = NSTextAlignmentCenter;
    view.font = [UIFont systemFontOfSize:FontSize(16)];
    view.scrollEnabled = YES;
    view.editable = NO;
    [self.baseView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(10));
        make.top.mas_equalTo(self.Title.mas_bottom);
        make.width.mas_equalTo(Device_Width-ScaleW(20));
        make.bottom.mas_equalTo(-82);
    }];
    self.showMusic = view;

    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:self.bounds];
    [bottomView setBackgroundColor:rgba(0, 122, 96, 1.0)];
    [self.baseView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.showMusic.mas_bottom).offset(2);
        make.width.mas_equalTo(ScaleW(Device_Width));
        make.height.mas_equalTo(ScaleW(82));
    }];
    
    UIButton *sureBtn = [[UIButton alloc] init];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(15) weight:UIFontWeightBold];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:UIColor.clearColor];
    [sureBtn setTitle:@"確定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.layer.cornerRadius = ScaleW(32)/2;
    sureBtn.clipsToBounds = YES;
    [self.baseView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.baseView).offset(ScaleW(-40));;
        make.width.mas_equalTo(ScaleW(50));
        make.height.mas_equalTo(ScaleW(32));
        make.centerX.mas_equalTo(self.showMusic);
    }];
    sureBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -200, -20, -200);
 
}

- (void)popPickerView
{
    self.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:0];
    [[[[UIApplication sharedApplication]windows] firstObject] addSubview:self];

    self.frame = CGRectMake(0, 0, Device_Width, Device_Height);
    self.baseView.alpha = 0.0;
    [UIView animateWithDuration:0.25
                     animations:^{
        self.baseView.alpha = 1.0;
        [self.baseView setFrame:CGRectMake(0,  ScaleH(50), Device_Width, Device_Height-ScaleH(50))];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    }];
}

- (void)setMusicText:(NSDictionary*)music_text
{
    [self.showMusic setText:[music_text objectForKey:@"memberMusictext"]];
    self.Title.text = [music_text objectForKey:@"memberName"];
    
}

-(void)ok
{
    [self removeFromSuperview];
}
@end
