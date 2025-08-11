//
//  OASearchFilterView.m
//  NewsoftOA24
//
//  Created by rick on 7/31/24.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import "EGmedalDetailView.h"
#import "LXYHyperlinksButton.h"


@interface EGmedalDetailView ()<UIGestureRecognizerDelegate>
{

}

@property (nonatomic,weak) UIView * baseView;
@property (nonatomic,weak) UIImageView *imView;
@property (nonatomic,weak) UILabel *SettingTitleLabel;

@property (nonatomic,weak) UITextView *SettingTitleTextView;

@property (nonatomic,assign) NSInteger popViewHeight;

@end


@implementation EGmedalDetailView

- (instancetype)initWithObject:(NSInteger)object {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    self = [super initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    if (self) {
        self.TextViewHeight = object;
        // 初始化代码
        [self createUI];
    }
    return self;
}


-(instancetype)initWithFrame:(CGRect)frame{
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    self = [super initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
//    self.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.2];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    
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
    baseView.backgroundColor = UIColor.whiteColor;
    baseView.layer.cornerRadius = 8;
    baseView.layer.masksToBounds = YES;
    self.baseView = baseView;
    [self addSubview:self.baseView];
    
    
    
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"台鋼雄鷹Logo"];
    [self.baseView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.baseView.mas_centerX);
        make.top.mas_equalTo(ScaleW(30));
        make.width.mas_equalTo(ScaleW(140));
        make.height.mas_equalTo(ScaleW(140));
    }];
    self.imView = imageView;
    
    
//    UILabel *title = [[UILabel alloc] init];
//    title.text = @"台鋼雄鷹歡呼模式";
//    title.numberOfLines = 0;
//    title.textAlignment = NSTextAlignmentCenter;
//    title.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
//    title.textColor = ColorRGB(0x525252);
//    
//    [self.baseView addSubview:title];
//    self.SettingTitleLabel = title;
//    
//    [title mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.baseView.mas_centerX);
//        make.top.mas_equalTo(self.imView.mas_bottom).offset(ScaleW(10));
//        make.width.mas_equalTo((ScaleW(350)));
//        make.height.mas_equalTo(ScaleW(80));
//    }];
 
        UITextView *title = [[UITextView alloc] init];
        title.editable = NO;
        title.selectable = NO;
        title.text = @"";
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
        title.textColor = ColorRGB(0x525252);
    
        [self.baseView addSubview:title];
        self.SettingTitleTextView = title;
#ifdef autoTextHeight
    //CGFloat height = [self calculateTextViewHeightForText:title.text textViewWidth:ScaleW(350)] + ScaleW(25);
    self.popViewHeight = self.TextViewHeight + ScaleW(150)+ ScaleW(30)+ ScaleW(15) + ScaleW(60);
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.baseView.mas_centerX);
        make.top.mas_equalTo(self.imView.mas_bottom).offset(ScaleW(15));
        make.width.mas_equalTo((ScaleW(350)));
        make.height.mas_equalTo(/*ScaleW(80)*/self.TextViewHeight);
    }];
#else
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.baseView.mas_centerX);
        make.top.mas_equalTo(self.imView.mas_bottom).offset(ScaleW(30));
        make.width.mas_equalTo((ScaleW(350)));
        make.height.mas_equalTo(ScaleW(100));
    }];
#endif
        
    
}

-(void)updateUI
{
    self.imView.image = [self.dicinfo objectForKey:@"IMG"];
    //self.SettingTitleLabel.text = [self.dicinfo objectForKey:@"reason"];
    self.SettingTitleTextView.text = [self.dicinfo objectForKey:@"reason"];
    
}

//弹出pickerView
- (void)popPickerView
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
#ifdef autoTextHeight
        [self.baseView setFrame:CGRectMake(0,  /*ScaleH(400)*/Device_Height- self.popViewHeight, Device_Width, /*Device_Height-ScaleH(400)*/self.popViewHeight)];
#else
        [self.baseView setFrame:CGRectMake(0,  ScaleW(500), Device_Width, Device_Height-ScaleW(500))];
#endif
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    }];
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
    
}

- (CGFloat)calculateTextViewHeightForText:(NSString *)text textViewWidth:(CGFloat)width {
    // 设置文本属性
    NSDictionary *attributes = @{
        NSFontAttributeName: /*[UIFont systemFontOfSize:15]*/[UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular], // 字体和字号
        NSParagraphStyleAttributeName: [NSParagraphStyle defaultParagraphStyle] // 段落样式，可自定义行间距等
    };
    
    // 计算文本在给定宽度下的高度
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil].size;
    
    // 返回计算出的高度
    return ceilf(size.height); // 使用ceilf函数确保高度为整数
}


@end
