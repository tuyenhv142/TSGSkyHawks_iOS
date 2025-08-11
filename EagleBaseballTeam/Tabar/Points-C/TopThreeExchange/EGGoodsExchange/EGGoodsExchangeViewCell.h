//
//  OABtnImgCollectionViewCell.h
//  NewsoftOA24
//
//  Created by dragon_zheng on 2024/5/9.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGGoodsExchangeViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *baseIMGView;

@property (nonatomic,strong) UIImageView *imageView;//商品图片
@property (nonatomic,strong) UIImageView *iconImageView;//价格前面图片
@property (nonatomic,strong) UIImageView *hearticonView;//心形图片
@property (nonatomic,strong) UIImageView *yellowcornerimageView;//右上角半黄色图片
@property (nonatomic,strong) UILabel *titleLB_Tag;

@property (nonatomic,strong) UILabel *titleLB;
@property (nonatomic,strong) UIView *baseView;
@property (nonatomic,strong) UILabel *titleLA;
@property (nonatomic,strong) UIButton *openbt;
@property (nonatomic,strong) UIButton *harticonbt;
@property (nonatomic,strong) UILabel *usertypeLB;//会员等级显示

- (void)setupCellInfo:(id )task;
@end

NS_ASSUME_NONNULL_END
