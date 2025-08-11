//
//  OASearchFilterView.h
//  NewsoftOA24
//
//  Created by dragon on 7/31/24.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^ ColorBlock)(NSMutableDictionary*);


@interface GoroundColorView : UIView
@property (nonatomic, retain)NSMutableDictionary *settingDic;
@property (nonatomic, copy) ColorBlock gcolorBlock;


@property (nonatomic, assign) NSInteger from_type;
@property (nonatomic,assign) CGFloat r_value;//圆盘取色器上的text r值
@property (nonatomic, assign) CGFloat g_value;//圆盘取色器上的text g值
@property (nonatomic, assign) CGFloat b_value;//圆盘取色器上的text b值
@property (nonatomic, assign) CGFloat alpha_value;
@property (nonatomic, assign) CGFloat text_slider_value;//text slider 的float值
@property (nonatomic, assign) CGFloat back_slider_value;//background slider 的float值

@property (nonatomic,assign) CGFloat rback_value;//圆盘取色器上的background r值
@property (nonatomic, assign) CGFloat gback_value;//圆盘取色器上的background g值
@property (nonatomic, assign) CGFloat bback_value;//圆盘取色器上的background b值
@property (nonatomic, assign) CGFloat backalpha_value;


@property (nonatomic,assign) CGFloat text_original_r_value;//slider取色器上的text r值
@property (nonatomic, assign) CGFloat text_original_g_value;//slider取色器上的text r值
@property (nonatomic, assign) CGFloat text_original_b_value;//slider取色器上的text r值
@property (nonatomic,assign) CGFloat back_original_r_value;//slider取色器上的background r值
@property (nonatomic, assign) CGFloat back_original_g_value;//slider取色器上的background g值
@property (nonatomic, assign) CGFloat back_original_b_value;//slider取色器上的background b值

@property (nonatomic,assign) CGFloat text_pointX_value;////圆盘取色器上的text point值
@property (nonatomic, assign) CGFloat text_pointY_value;//圆盘取色器上的text point值
@property (nonatomic, assign) CGFloat back_pointX_value;//圆盘取色器上的background point值
@property (nonatomic,assign) CGFloat back_pointY_value;//圆盘取色器上的background point值


/**
 * 显示view
 */
- (void)popPickerView;
-(void)updateUI;
@end

NS_ASSUME_NONNULL_END
