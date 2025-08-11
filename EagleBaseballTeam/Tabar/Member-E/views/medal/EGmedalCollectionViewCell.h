//
//  OABtnImgCollectionViewCell.h
//  NewsoftOA24
//
//  Created by dragon_zheng on 2024/5/9.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICustomSlider.h"
NS_ASSUME_NONNULL_BEGIN

@interface EGmedalCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UIView *baseView;
@property (nonatomic,strong) UILabel *name_label;//*titleLA;  描述
@property (nonatomic,strong) UILabel *status_label;//*titleLB;  Name
@property (nonatomic,strong) UILabel *percent_label;


@property (nonatomic,strong) UICustomSlider *status;//*titleLB;



@property (nonatomic,assign)CGFloat rate;

-(void)setprogress:(BOOL)enable;
@end

NS_ASSUME_NONNULL_END
