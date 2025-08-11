//
//  GiftTBViewHeaderFooterView.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/4/28.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^changdiBlcok)(NSDictionary* type);

@interface EGSeatImageCell : UITableViewCell

+(instancetype)cellWithUITableView:(UITableView *)tableView;

@property (nonatomic,strong) UIImageView *googleMapView;//Image base全图
@property (nonatomic,strong) UIImageView *alpha_View;//半透明View
@property (nonatomic,strong) UIImageView *chengqinghu_hotarea_View;//Image base全图
@property (nonatomic,strong) UIImageView *chengqinghu_waiye_View;//Image base全图
@property (nonatomic,strong) UIImageView *chengqinghu_kedui_View;//Image base全图
@property (nonatomic,strong) UIImageView *chengqinghu_yingyuanxi_View;//Image base全图
@property (nonatomic,strong) UIImageView *chengqinghu_VIP_View;//Image base全图
@property (nonatomic,strong) UIImageView *jiayi_neiye_View;//Image base全图
@property (nonatomic,strong) UIImageView *jiayi_waiye_View;//Image base全图

@property (nonatomic,strong) UIView *helpLableView;
@property (nonatomic,strong) UILabel *helpTitle;
@property (nonatomic,copy) changdiBlcok changditypeblock;

@property (nonatomic,strong) UIView *swichbackView;
@property (nonatomic,strong) UIButton *left_bt;
@property (nonatomic,strong) UIButton *right_bt;
@property (nonatomic,strong) UILabel *left_label;
@property (nonatomic,strong) UILabel *right_label;

@property (nonatomic,strong) UIImage *chengqinghu_hotarea_data ;
@property (nonatomic,strong) UIImage *chengqinghu_waiye_data;
@property (nonatomic,strong) UIImage *chengqinghu_kedui_data;
@property (nonatomic,strong) UIImage *chengqinghu_yingyuanxi_data;
@property (nonatomic,strong) UIImage *chengqinghu_VIP_data;
@property (nonatomic,strong) UIImage *jiayi_neiye;
@property (nonatomic,strong) UIImage *jiayi_waiye;

@property (nonatomic,assign) NSInteger changdi_type;//101 is 澄清胡  102 is 嘉怡
@property (nonatomic,assign) NSInteger changdi_clickIndex;//按区域点击，给值
@property (nonatomic,strong) NSMutableDictionary* changdi_selectdic;
@property (nonatomic,assign) NSInteger click_type;//0 is click swich button , 1 is click in imageView , default is -1
-(void)IntalImageView:(NSInteger)select;
@end

NS_ASSUME_NONNULL_END
