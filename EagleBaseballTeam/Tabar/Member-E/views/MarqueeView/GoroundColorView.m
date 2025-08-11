//
//  OASearchFilterView.m
//  NewsoftOA24
//
//  Created by dragon on 7/31/24.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import "GoroundColorView.h"
#import "LXYHyperlinksButton.h"
#import "UIImageView+ColorAtPoint.h"
@interface GoroundColorView ()<UIGestureRecognizerDelegate>
{

}

@property (nonatomic,weak) UIView * baseView;
@property (nonatomic,weak) UIButton *cancelBtn; // X button

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *colorPreview;

@property (nonatomic, strong) UILabel *colorLabel;
@property (nonatomic, strong) UISlider *colorslider;
@property (nonatomic, strong) UIButton* textcolor_bt;
@property (nonatomic, strong) UIButton* backgroundcolor_bt;
@property (nonatomic, strong) UILabel *textcolorLabel;
@property (nonatomic, strong) UILabel *backcolorLabel;

@property (nonatomic, strong) UIImageView *colorbarview;
@property (nonatomic, strong) CAGradientLayer *colorbargradientLayer;

@property (nonatomic, strong) UIImageView *pointinimage;
@end


@implementation GoroundColorView

-(instancetype)initWithFrame:(CGRect)frame{
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    self = [super initWithFrame:CGRectMake(0, screenHeight, screenWidth, screenHeight/3)];
//    self.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.2];
    if (self) {
        
        self.alpha_value = 0.0;
        self.backalpha_value = 0.0;
        self.text_slider_value = 0.0;
        self.back_slider_value = 0.0;
        self.from_type = 10001;
        [self createUI];
        
        
    }
    return self;
}

-(void)createUI{
    self.settingDic = [[NSMutableDictionary alloc] init];
    self.r_value = 0;
    self.g_value = 0;
    self.b_value = 0;
    self.text_original_r_value = 0;
    self.text_original_g_value = 0;
    self.text_original_b_value = 0;
    self.alpha_value = 1.0;
    self.backalpha_value = 1.0;
    self.text_slider_value = 0.0;
    
    self.text_pointX_value = 0;
    self.text_pointY_value = 0;
    
    self.back_pointX_value = 0;
    self.back_pointY_value = 0;
    
   
    [self.settingDic setObject:[NSNumber numberWithFloat:self.from_type] forKey:@"color_type"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.r_value] forKey:@"r_color"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.g_value] forKey:@"g_color"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.b_value] forKey:@"b_color"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.alpha_value] forKey:@"alpha_color"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.text_slider_value] forKey:@"textslider"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.text_original_r_value] forKey:@"text_original_r_value"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.text_original_g_value] forKey:@"text_original_g_value"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.text_original_b_value] forKey:@"text_original_b_value"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.text_pointX_value] forKey:@"text_point_x"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.text_pointY_value] forKey:@"text_point_y"];
    
    self.rback_value = 0;
    self.gback_value = 0;
    self.bback_value = 0;
    self.backalpha_value = 0.0;
    self.back_slider_value = 0.0;
    self.back_original_r_value = 0;
    self.back_original_g_value = 0;
    self.back_original_b_value = 0;
    
    
    [self.settingDic setObject:[NSNumber numberWithFloat:self.rback_value] forKey:@"rback_color"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.gback_value] forKey:@"gback_color"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.bback_value] forKey:@"bback_color"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.backalpha_value] forKey:@"backalpha_color"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.back_slider_value] forKey:@"backslider"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.back_original_r_value] forKey:@"back_original_r_value"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.back_original_g_value] forKey:@"back_original_g_value"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.back_original_b_value] forKey:@"back_original_b_value"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.back_pointX_value] forKey:@"back_point_x"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.back_pointY_value] forKey:@"back_point_y"];
    
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight/3)];
    baseView.backgroundColor = [UIColor colorWithRed:0 green:71.0/255.0 blue:56.0/255 alpha:1.0];
    baseView.layer.cornerRadius = 15;
    baseView.layer.masksToBounds = YES;
    self.baseView = baseView;
    [self addSubview:self.baseView];
    
    // 添加颜色预览视图
    self.colorPreview = [[UIView alloc] initWithFrame:CGRectMake(20, 88, 50, 50)];
    self.colorPreview.layer.borderWidth = 1.0;
    self.colorPreview.layer.borderColor = [UIColor blackColor].CGColor;
    [self.baseView addSubview:self.colorPreview];
    [self.colorPreview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(32));
        make.top.mas_equalTo(ScaleW(32));
        make.width.mas_equalTo(ScaleW(50));
        make.height.mas_equalTo(ScaleW(50));
    }];
    self.colorPreview.hidden = YES;
    
    
    UILabel *title = [[UILabel alloc] init];
    title.text = @"字體";
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightBold];
    title.textColor = [UIColor whiteColor];
    [self.baseView addSubview:title];
    self.textcolorLabel = title;
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ScaleW(32));
            make.top.mas_equalTo(ScaleW(32));
            make.width.mas_equalTo(ScaleW(35));
            make.height.mas_equalTo(ScaleW(30));
        }];
        
        
        UIButton *blackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        blackButton.tag = 20001;
        blackButton.clipsToBounds = true;
        blackButton.layer.cornerRadius = ScaleW(32)/2;
        blackButton.layer.masksToBounds = YES;
        blackButton.layer.borderWidth = 2.0;
        blackButton.layer.borderColor = UIColor.whiteColor.CGColor;
        [blackButton addTarget:self action:@selector(colorselect:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.baseView addSubview:blackButton];
        [blackButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.textcolorLabel.mas_centerY);
            make.left.mas_equalTo(self.textcolorLabel.mas_right).offset(ScaleW(10));
            make.width.mas_equalTo(ScaleW(32));
            make.height.mas_equalTo(ScaleW(32));
        }];
       self.textcolor_bt = blackButton;
       self.textcolor_bt.selected = YES;
        
        title = [[UILabel alloc] init];
        title.text = @"背景";
        title.textAlignment = NSTextAlignmentLeft;
        title.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightBold];
        title.textColor = [UIColor whiteColor];
        [self.baseView addSubview:title];
        self.backcolorLabel = title;
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.textcolor_bt.mas_right).offset(ScaleW(20));
            make.top.mas_equalTo(ScaleW(32));
            make.width.mas_equalTo(ScaleW(35));
            make.height.mas_equalTo(ScaleW(30));
        }];
    self.backcolorLabel = title;
    
        
        UIButton *greanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        greanButton.tag = 20002;
        greanButton.clipsToBounds = true;
        greanButton.layer.cornerRadius = ScaleW(32)/2;
        greanButton.layer.masksToBounds = YES;
        greanButton.layer.borderWidth = 2.0;
        greanButton.layer.borderColor = UIColor.whiteColor.CGColor;
        [greanButton addTarget:self action:@selector(colorselect:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.baseView addSubview:greanButton];
        [greanButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.backcolorLabel.mas_centerY);
            make.left.mas_equalTo(self.backcolorLabel.mas_right).offset(ScaleW(10));
            make.width.mas_equalTo(ScaleW(32));
            make.height.mas_equalTo(ScaleW(32));
        }];
    self.backgroundcolor_bt = greanButton;
    
    
    
    // 设置图片视图
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight/3)];
    _imageView.layer.cornerRadius = ScaleW(300)/2;
    _imageView.layer.masksToBounds = YES;
    self.imageView.image = [UIImage imageNamed:@"color-2"];//[UIImage imageNamed:@"colors"];
    self.imageView.backgroundColor = [UIColor colorWithRed:0 green:71.0/255.0 blue:56.0/255 alpha:1.0];//UIColor.clearColor;//[UIColor colorWithRed:0 green:71.0/255.0 blue:56.0/255 alpha:1.0];//UIColor.blackColor;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.userInteractionEnabled = YES;
//    self.imageView.frame = self.bounds;
    [self.baseView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.baseView.mas_centerX);
        make.top.mas_equalTo(self.colorPreview.mas_bottom);
        make.width.mas_equalTo(ScaleW(300));
        make.height.mas_equalTo(ScaleW(300));
    }];
    
    
    // 添加点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.imageView addGestureRecognizer:tapGesture];
    
    // 创建平移手势识别器
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(handlePan:)];
    // 设置最小触摸点数
    panGesture.minimumNumberOfTouches = 1;
    // 设置最大触摸点数
    panGesture.maximumNumberOfTouches = 1;
    
    [self.imageView addGestureRecognizer:panGesture];
    
    UIImageView * locationview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(20), ScaleW(20))];
    locationview.image = [UIImage imageNamed:@"slidericon"];
    [self.imageView addSubview:locationview];
    self.pointinimage = locationview;
    
    
    UISlider *normalSlider = [[UISlider alloc] initWithFrame:CGRectMake(50, 100, ScaleW(260), 80)];
    normalSlider.minimumValue = 0;
    normalSlider.maximumValue = 1;
    normalSlider.minimumTrackTintColor = UIColor.clearColor;
    normalSlider.maximumTrackTintColor = UIColor.clearColor;
    normalSlider.value = 0.0f;
//    [normalSlider setThumbImage:[UIImage imageNamed:@"slidericon"] forState:UIControlStateNormal];
    [normalSlider addTarget:self action:@selector(onSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.baseView addSubview:normalSlider];
    
    self.colorslider = normalSlider;
    
    self.colorbarview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(260), ScaleW(15))];
    self.colorbarview.backgroundColor = [UIColor colorWithRed:0 green:71.0/255.0 blue:56.0/255 alpha:1.0];
    self.colorbarview.layer.cornerRadius = 8;
    self.colorbarview.layer.borderColor = UIColor.grayColor.CGColor;
    self.colorbarview.layer.borderWidth = 1.0;
    self.colorbarview.layer.masksToBounds = YES;
    
    [self.baseView insertSubview:self.colorbarview belowSubview:self.colorslider];
    
    [self.colorbarview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.imageView.mas_centerX);
            make.top.mas_equalTo(self.imageView.mas_bottom).offset(ScaleW(10));
                make.width.mas_equalTo(ScaleW(260));
                make.height.mas_equalTo(ScaleW(15));
            }];
    
    [normalSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.colorbarview.mas_centerY);
        make.centerX.mas_equalTo(self.colorbarview.mas_centerX);
            make.width.mas_equalTo(ScaleW(260));
            make.height.mas_equalTo(ScaleW(50));
        }];
    
    
    _colorbargradientLayer = [CAGradientLayer layer];
    _colorbargradientLayer.frame = self.colorbarview.bounds; // 或者你想要的任何尺寸
    _colorbargradientLayer.startPoint = CGPointMake(0.0, 0.5);
    _colorbargradientLayer.endPoint = CGPointMake(1.0, 0.5);
    [self.colorbarview.layer addSublayer:_colorbargradientLayer];
    
    
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
    
    
    // 添加颜色信息标签
    self.colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 88, 200, 50)];
    self.colorLabel.text = @"字體顏色";
    self.colorLabel.textAlignment = NSTextAlignmentCenter;
    self.colorLabel.textColor = [UIColor whiteColor];
    [self.baseView addSubview:self.colorLabel];
    [_colorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.baseView.mas_centerX);
        make.centerY.mas_equalTo(_colorPreview.mas_centerY);
        make.width.mas_equalTo(ScaleW(200));
        make.height.mas_equalTo(ScaleW(50));
    }];
    self.colorLabel.hidden = YES;
}

- (void)onSliderValueChanged:(UISlider *)sender {
    CGFloat current = sender.value;
    
    if(current==1.0)
        current = 0.95;
    
    CGPoint point = CGPointMake(current * self.colorbarview.frame.size.width, self.colorbarview.frame.size.height/2);
    
    UIColor *color = [self colorAtPoint:point inGradientLayer:_colorbargradientLayer];
    if (color) {
        self.colorPreview.backgroundColor = color;
        // 获取RGB分量
        CGFloat red, green, blue, alpha;
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
        
        switch (self.from_type) {
            case 10001:{
                self.textcolor_bt.backgroundColor = color;
                self.r_value = red * 255;
                self.g_value = green * 255;
                self.b_value = blue * 255;
                self.text_slider_value = current;
            }
                break;
                
            case 10002:{
                self.backgroundcolor_bt.backgroundColor = color;
                self.rback_value = red * 255;
                self.gback_value = green * 255;
                self.bback_value = blue * 255;
                self.back_slider_value = current;
            }
                break;
        }
        
    } else {
        self.colorPreview.backgroundColor = [UIColor clearColor];
        //self.colorLabel.text = @"无法获取颜色";
    }
    
}

-(void)updateUI
{
    self.textcolor_bt.layer.borderColor = UIColor.clearColor.CGColor;
    self.textcolor_bt.layer.borderWidth = 0.0;
    
    self.backgroundcolor_bt.layer.borderColor = UIColor.clearColor.CGColor;
    self.backgroundcolor_bt.layer.borderWidth = 0.0;
    
    if(self.from_type==10001)
    {
        self.textcolor_bt.layer.borderColor = UIColor.whiteColor.CGColor;
        self.textcolor_bt.layer.borderWidth = 2.0;
        
        [self.pointinimage setFrame:CGRectMake(self.text_pointX_value - ScaleW(20)/2, self.text_pointY_value - ScaleW(20)/2, ScaleW(20), ScaleW(20))];
        [self.colorslider setValue:self.text_slider_value];
        [self setcolorbar:[UIColor colorWithRed:self.text_original_r_value/255.0 green:self.text_original_g_value/255.0 blue:self.text_original_b_value/255.0 alpha:self.alpha_value]];
    }
    else
    {
        self.backgroundcolor_bt.layer.borderColor = UIColor.whiteColor.CGColor;
        self.backgroundcolor_bt.layer.borderWidth = 2.0;
        [self.pointinimage setFrame:CGRectMake(self.back_pointX_value - ScaleW(20)/2, self.back_pointY_value - ScaleW(20)/2, ScaleW(20), ScaleW(20))];
        [self.colorslider setValue:self.back_slider_value];
        [self setcolorbar:[UIColor colorWithRed:self.back_original_r_value/255.0 green:self.back_original_g_value/255.0 blue:self.back_original_b_value/255.0 alpha:self.backalpha_value]];
    }
    
    
    
    self.textcolor_bt.backgroundColor = [UIColor colorWithRed:self.r_value/255.0 green:self.g_value/255.0 blue:self.b_value/255.0 alpha:self.alpha_value];
    self.backgroundcolor_bt.backgroundColor = [UIColor colorWithRed:self.rback_value/255.0 green:self.gback_value/255.0 blue:self.bback_value/255.0 alpha:self.backalpha_value];
    //
    self.colorPreview.backgroundColor = [UIColor colorWithRed:self.r_value/255.0 green:self.g_value/255.0 blue:self.b_value/255.0 alpha:self.alpha_value];;
}

- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    CGPoint tapPoint = [gesture locationInView:self.imageView];
    
    //标记位置图标 if gesture.state == .began || gesture.state == .changed
    if(gesture.state==UIGestureRecognizerStateBegan ||
       gesture.state== UIGestureRecognizerStateChanged)
    {
        [self.pointinimage setFrame:CGRectMake(tapPoint.x - ScaleW(20)/2, tapPoint.y - ScaleW(20)/2, ScaleW(20), ScaleW(20))];
        
    }
    
    UIColor *color = [self.imageView colorAtPoint:tapPoint alpha:self.alpha_value];
    
    if (color) {
        self.colorPreview.backgroundColor = color;
        // 获取RGB分量
        CGFloat red, green, blue, alpha;
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
        
        switch (self.from_type) {
            case 10001:{
                self.textcolor_bt.backgroundColor = color;
                self.r_value = red * 255;
                self.g_value = green * 255;
                self.b_value = blue * 255;
                
                self.text_original_r_value = red * 255;
                self.text_original_g_value = green * 255;
                self.text_original_b_value = blue * 255;
                
                self.text_pointX_value = tapPoint.x;
                self.text_pointY_value = tapPoint.y;
                [self setcolorbar:color];
            }
                break;
                
            case 10002:{
                self.backgroundcolor_bt.backgroundColor = color;
                self.rback_value = red * 255;
                self.gback_value = green * 255;
                self.bback_value = blue * 255;
                
                self.back_original_r_value = red * 255;
                self.back_original_g_value = green * 255;
                self.back_original_b_value = blue * 255;
                
                self.back_pointX_value = tapPoint.x;
                self.back_pointY_value = tapPoint.y;
                [self setcolorbar:color];
            }
                break;
        }
        
        // 显示颜色信息
//        self.colorLabel.text = [NSString stringWithFormat:@"R:%.0f G:%.0f B:%.0f A:%.2f",
//                                red * 255,
//                                green * 255,
//                                blue * 255,
//                                alpha];
//        self.colorLabel.text = @"颜色";
//        NSLog(@"点击位置颜色: %@", color);
    } else {
        self.colorPreview.backgroundColor = [UIColor clearColor];
        //self.colorLabel.text = @"无法获取颜色";
    }
    
    self.colorslider.value = 0.0f;
}
- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    CGPoint tapPoint = [gesture locationInView:self.imageView];
    
    //标记位置图标 if gesture.state == .began || gesture.state == .changed
    if(gesture.state==UIGestureRecognizerStateBegan ||
       gesture.state== UIGestureRecognizerStateChanged)
    {
        [self.pointinimage setFrame:CGRectMake(tapPoint.x - ScaleW(20)/2, tapPoint.y - ScaleW(20)/2, ScaleW(20), ScaleW(20))];
    }
    
    UIColor *color = [self.imageView colorAtPoint:tapPoint alpha:self.alpha_value];
    
    if (color) {
        self.colorPreview.backgroundColor = color;
        // 获取RGB分量
        CGFloat red, green, blue, alpha;
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
//        self.r_value = red * 255;
//        self.g_value = green * 255;
//        self.b_value = blue * 255;
        
        switch (self.from_type) {
            case 10001:{
                self.textcolor_bt.backgroundColor = color;
                self.r_value = red * 255;
                self.g_value = green * 255;
                self.b_value = blue * 255;
                [self setcolorbar:color];
                self.text_original_r_value = red * 255;
                self.text_original_g_value = green * 255;
                self.text_original_b_value = blue * 255;
                
                self.text_pointX_value = tapPoint.x;
                self.text_pointY_value = tapPoint.y;
            }
                break;
                
            case 10002:{
                self.backgroundcolor_bt.backgroundColor = color;
                self.rback_value = red * 255;
                self.gback_value = green * 255;
                self.bback_value = blue * 255;
                [self setcolorbar:color];
                self.back_original_r_value = red * 255;
                self.back_original_g_value = green * 255;
                self.back_original_b_value = blue * 255;
                
                self.back_pointX_value = tapPoint.x;
                self.back_pointY_value = tapPoint.y;
            }
                break;
        }
        
//        // 显示颜色信息
//        self.colorLabel.text = [NSString stringWithFormat:@"R:%.0f G:%.0f B:%.0f A:%.2f",
//                                red * 255,
//                                green * 255,
//                                blue * 255,
//                                alpha];
//
//        NSLog(@"点击位置颜色: %@", color);
    } else {
        self.colorPreview.backgroundColor = [UIColor clearColor];
        //self.colorLabel.text = @"无法获取颜色";
    }
    
    self.colorslider.value = 0.0f;
}



+ (UIColor*) gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withWidth:(CGFloat)width andHeight:(CGFloat)height{
    CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
     
    NSArray* colors = [NSArray arrayWithObjects:(id)c1.CGColor, (id)c2.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (CFArrayRef)colors, NULL);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(size.width, size.height), 0);
     
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
     
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
     
    return [UIColor colorWithPatternImage:image];
}

//弹出pickerView
- (void)popPickerView
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    self.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:0];
    [[[[UIApplication sharedApplication]windows] firstObject] addSubview:self];

    self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    self.baseView.alpha = 0.0;
    [UIView animateWithDuration:0.25
                     animations:^{
        self.baseView.alpha = 1.0;
        [self.baseView setFrame:CGRectMake(0,  ScaleH(300), Device_Width, Device_Height-ScaleH(300))];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    }];
    
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self removeFromSuperview];
        if(self.gcolorBlock)
        {
            self.gcolorBlock(self.settingDic);
        }
    }
}

-(void)closeSettingView
{
    [self removeFromSuperview];
    
    [self.settingDic setObject:[NSNumber numberWithFloat:self.from_type] forKey:@"color_type"];
    
    [self.settingDic setObject:[NSNumber numberWithFloat:self.r_value] forKey:@"r_color"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.g_value] forKey:@"g_color"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.b_value] forKey:@"b_color"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.alpha_value] forKey:@"alpha_color"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.text_slider_value] forKey:@"textslider"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.text_original_r_value] forKey:@"text_original_r_value"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.text_original_g_value] forKey:@"text_original_g_value"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.text_original_b_value] forKey:@"text_original_b_value"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.text_pointX_value] forKey:@"text_point_x"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.text_pointY_value] forKey:@"text_point_y"];

    
    [self.settingDic setObject:[NSNumber numberWithFloat:self.rback_value] forKey:@"rback_color"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.gback_value] forKey:@"gback_color"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.bback_value] forKey:@"bback_color"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.backalpha_value] forKey:@"backalpha_color"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.back_slider_value] forKey:@"backslider"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.back_original_r_value] forKey:@"back_original_r_value"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.back_original_g_value] forKey:@"back_original_g_value"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.back_original_b_value] forKey:@"back_original_b_value"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.back_pointX_value] forKey:@"back_point_x"];
    [self.settingDic setObject:[NSNumber numberWithFloat:self.back_pointY_value] forKey:@"back_point_y"];

    
    if(self.gcolorBlock)
    {
        self.gcolorBlock(self.settingDic);
    }
}

-(void)colorselect:(UIButton*)bt
{
    self.textcolor_bt.layer.borderColor = UIColor.clearColor.CGColor;
    self.textcolor_bt.layer.borderWidth = 0.0;
    
    self.backgroundcolor_bt.layer.borderColor = UIColor.clearColor.CGColor;
    self.backgroundcolor_bt.layer.borderWidth = 0.0;
    
    switch (bt.tag) {
        case 20001:
        {
            self.from_type = 10001;
            self.textcolor_bt.layer.borderColor = UIColor.whiteColor.CGColor;
            self.textcolor_bt.layer.borderWidth = 2.0;
            [self.pointinimage setFrame:CGRectMake(self.text_pointX_value - ScaleW(20)/2, self.text_pointY_value - ScaleW(20)/2, ScaleW(20), ScaleW(20))];
            [self.colorslider setValue:self.text_slider_value];
            [self setcolorbar:[UIColor colorWithRed:self.text_original_r_value/255.0 green:self.text_original_g_value/255.0 blue:self.text_original_b_value/255.0 alpha:self.alpha_value]];
        }
            break;
            
        case 20002:
        {
            self.from_type = 10002;
            self.backgroundcolor_bt.layer.borderColor = UIColor.whiteColor.CGColor;
            self.backgroundcolor_bt.layer.borderWidth = 2.0;
            [self.pointinimage setFrame:CGRectMake(self.back_pointX_value - ScaleW(20)/2, self.back_pointY_value - ScaleW(20)/2, ScaleW(20), ScaleW(20))];
            [self.colorslider setValue:self.back_slider_value];
            [self setcolorbar:[UIColor colorWithRed:self.back_original_r_value/255.0 green:self.back_original_g_value/255.0 blue:self.back_original_b_value/255.0 alpha:self.backalpha_value]];
        }
            break;
    }
}


-(void)setcolorbar:(UIColor*)color
{
    // 定义颜色
    UIColor *startColor = color;
    UIColor *endColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]; // 蓝色
    // 设置渐变颜色
    _colorbargradientLayer.colors = @[(id)startColor.CGColor, (id)endColor.CGColor];
    [self.colorbarview setNeedsDisplay];
}

- (UIColor *)colorAtPoint:(CGPoint)point inGradientLayer:(CAGradientLayer *)gradientLayer {
    // 创建一个和渐变层大小相同的图像
    UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size, NO, 0.0);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 从图像中获取颜色
    CGImageRef imageRef = gradientImage.CGImage;
    NSUInteger width = self.colorbarview.frame.size.width;//ScaleW(260);//CGImageGetWidth(imageRef);
    NSUInteger height = self.colorbarview.frame.size.height;//ScaleW(15);CGImageGetHeight(imageRef);
    uint8_t *rawData = malloc(height * width * 4);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // 获取点的颜色值
    int byteIndex = (int)(bytesPerRow * (int)point.y) + (int)bytesPerPixel * (int)point.x;
    CGFloat red = rawData[byteIndex] / 255.0f;
    CGFloat green = rawData[byteIndex + 1] / 255.0f;
    CGFloat blue = rawData[byteIndex + 2] / 255.0f;
    CGFloat alpha = rawData[byteIndex + 3] / 255.0f;
    free(rawData);
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


@end
