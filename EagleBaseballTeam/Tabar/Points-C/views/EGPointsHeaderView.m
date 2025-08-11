//
//  EGPointsHeaderView.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/8.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGPointsHeaderView.h"

@interface EGPointsHeaderView ()

@property (nonatomic,strong) UIImageView *bgImageView;

@property (nonatomic,strong) UIButton *titleBtn;
//@property (nonatomic,strong) UILabel *titleLb;


@property (nonatomic,strong) UIButton *goodsExchangeBtn;
@property (nonatomic,strong) UIButton *collectBtn;
@property (nonatomic,strong) UIButton *giftExchangeBtn;
//高度为 217-nav = 114+43 = 157
@end


@implementation EGPointsHeaderView

- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [UIImageView new];
//        _bgImageView.layer.cornerRadius = 5;
//        _bgImageView.layer.masksToBounds = true;
//        _bgImageView.backgroundColor = rgba(0, 71, 56, 1);
        _bgImageView.image = [UIImage imageNamed:@"TSG-gray"];
        [self addSubview:_bgImageView];
    }
    return _bgImageView;
}
- (UIButton *)titleBtn
{
    if (!_titleBtn) {
        _titleBtn = [[UIButton alloc] init];
//        [_titleBtn setTitle:@"雄鷹點數" forState:UIControlStateNormal];
//        _titleBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:(UIFontWeightMedium)];
//        [_titleBtn setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
//        _titleBtn.backgroundColor = rgba(52, 211, 153, 1);
//        _titleBtn.layer.cornerRadius = ScaleW(12);
//        _titleBtn.layer.masksToBounds = true;
//        [_titleBtn setBackgroundImage:[UIImage imageNamed:@"Ellipse"] forState:UIControlStateNormal];
        [_titleBtn setImage:[UIImage imageNamed:@"TSG_LIGHT"] forState:UIControlStateNormal];
        [self addSubview:_titleBtn];
    }
    return _titleBtn;
}
//- (UILabel *)titleLb
//{
//    if (!_titleLb) {
//        _titleLb = [UILabel new];
//        _titleLb.textAlignment = NSTextAlignmentLeft;
//        _titleLb.text = @"雄鷹點數";
//        _titleLb.textColor = UIColor.whiteColor;
//        _titleLb.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightMedium];
//        [self addSubview:_titleLb];
//    }
//    return _titleLb;
//}

- (UIButton *)pointsBtn
{
    if (!_pointsBtn) {
        _pointsBtn = [[UIButton alloc] init];
        _pointsBtn.tag = 27;
        [_pointsBtn setTitle:@"5" forState:UIControlStateNormal];
        _pointsBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(20) weight:(UIFontWeightSemibold)];
        [_pointsBtn setImage:[UIImage imageNamed:@"chevron-right-white"] forState:UIControlStateNormal];
        [_pointsBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_pointsBtn addTarget:self action:@selector(pointsGoodsCollectExchangee:) forControlEvents:UIControlEventTouchUpInside];
        [_pointsBtn layoutButtonWithEdgeInsetsStyle:ZYButtonEdgeInsetsStyleRight imageTitleSpace:1];
        [self addSubview:_pointsBtn];
        _pointsBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-20, -30, -20, -20);
    }
    return _pointsBtn;
}
#pragma mark --- 3个按钮
- (UIButton *)goodsExchangeBtn
{
    if (!_goodsExchangeBtn) {
        _goodsExchangeBtn = [[UIButton alloc] init];
        _goodsExchangeBtn.tag = 28;
        [_goodsExchangeBtn setTitle:@"贈品兌換" forState:UIControlStateNormal];
        _goodsExchangeBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:(UIFontWeightMedium)];
        [_goodsExchangeBtn setImage:[UIImage imageNamed:@"gift"] forState:UIControlStateNormal];
        [_goodsExchangeBtn setTitleColor:rgba(38, 38, 38, 1) forState:UIControlStateNormal];
        [_goodsExchangeBtn addTarget:self action:@selector(pointsGoodsCollectExchangee:) forControlEvents:UIControlEventTouchUpInside];
//        [_goodsExchangeBtn layoutButtonWithEdgeInsetsStyle:ZYButtonEdgeInsetsStyleTop imageTitleSpace:1];
//        [self addSubview:_goodsExchangeBtn];
    }
    return _goodsExchangeBtn;
}
- (UIButton *)collectBtn
{
    if (!_collectBtn) {
        _collectBtn = [[UIButton alloc] init];
        _collectBtn.tag = 29;
        [_collectBtn setTitle:@"活動兌換" forState:UIControlStateNormal];
        _collectBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:(UIFontWeightMedium)];
        [_collectBtn setImage:[UIImage imageNamed:@"activity"] forState:UIControlStateNormal];
        [_collectBtn setTitleColor:rgba(38, 38, 38, 1) forState:UIControlStateNormal];
        [_collectBtn addTarget:self action:@selector(pointsGoodsCollectExchangee:) forControlEvents:UIControlEventTouchUpInside];
//        [_collectBtn layoutButtonWithEdgeInsetsStyle:ZYButtonEdgeInsetsStyleTop imageTitleSpace:1];
//        [self addSubview:_collectBtn];
    }
    return _collectBtn;
}
- (UIButton *)giftExchangeBtn
{
    if (!_giftExchangeBtn) {
        _giftExchangeBtn = [[UIButton alloc] init];
        _giftExchangeBtn.tag = 30;
        [_giftExchangeBtn setTitle:@"兌換歷程" forState:UIControlStateNormal];
        _giftExchangeBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:(UIFontWeightMedium)];
        [_giftExchangeBtn setImage:[UIImage imageNamed:@"history"] forState:UIControlStateNormal];
        [_giftExchangeBtn setTitleColor:rgba(38, 38, 38, 1) forState:UIControlStateNormal];
        [_giftExchangeBtn addTarget:self action:@selector(pointsGoodsCollectExchangee:) forControlEvents:UIControlEventTouchUpInside];
//        [_giftExchangeBtn layoutButtonWithEdgeInsetsStyle:ZYButtonEdgeInsetsStyleTop imageTitleSpace:1];
//        [self addSubview:_giftExchangeBtn];
    }
    return _giftExchangeBtn;
}

-(void)pointsGoodsCollectExchangee:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(pointsHeaderViewButtonTag:)]) {
        [self.delegate pointsHeaderViewButtonTag:sender.tag];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, ScaleW(114))];
        [self addSubview:topView];
        self.backgroundColor =  rgba(243, 243, 243, 1);
        // 使用 CAGradientLayer 设置背景色
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        gradientLayer.frame = topView.bounds;
        gradientLayer.colors = @[(id)rgba(0, 78, 162, 1).CGColor,(id)rgba(0, 121,192, 1).CGColor];
        [topView.layer insertSublayer:gradientLayer atIndex:0];
        //220-157
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleW(-55));
            make.width.mas_equalTo(ScaleW(185));
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(ScaleW(185));
        }];
     
        
        [self.titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleW(20));
            make.left.mas_equalTo(ScaleW(20));
            make.width.height.mas_equalTo(ScaleW(24));
        }];
//        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.titleBtn);
//            make.left.mas_equalTo(ScaleW(53));
//        }];

        [self.pointsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.titleBtn);
            make.left.mas_equalTo(ScaleW(61));
            make.height.mas_equalTo(ScaleW(35));
//            make.width.mas_equalTo(ScaleW(150));
//            make.right.mas_equalTo(-ScaleW(20));
        }];
        
        // 设置按钮内容对齐
//        self.pointsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        // 调整文字和图片位置
//        CGFloat spacing = ScaleW(8);
//        CGFloat imageWidth = self.pointsBtn.imageView.image.size.width;
//        // 文字靠左，图片靠右
//        self.pointsBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, imageWidth + spacing);
//        self.pointsBtn.imageEdgeInsets = UIEdgeInsetsMake(0, ScaleW(150) - imageWidth - spacing, 0, 0);
        
        UIView *bottomView = [[UIView alloc] init];
        bottomView.layer.cornerRadius = 8;
        bottomView.layer.masksToBounds = true;
        bottomView.backgroundColor = UIColor.whiteColor;
        [self addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(ScaleW(20));
            make.right.mas_equalTo(-ScaleW(20));
            make.height.mas_equalTo(ScaleW(86));
        }];
        
        [bottomView addSubview:self.collectBtn];
        [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
        }];
        [self.collectBtn layoutButtonWithEdgeInsetsStyle:ZYButtonEdgeInsetsStyleTop imageTitleSpace:1];
        
        [bottomView addSubview:self.goodsExchangeBtn];
        [self.goodsExchangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ScaleW(30));
            make.centerY.mas_equalTo(0);
        }];
        [self.goodsExchangeBtn layoutButtonWithEdgeInsetsStyle:ZYButtonEdgeInsetsStyleTop imageTitleSpace:1];
        
        [bottomView addSubview:self.giftExchangeBtn];
        [self.giftExchangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-ScaleW(30));
            make.centerY.mas_equalTo(0);
        }];
        [self.giftExchangeBtn layoutButtonWithEdgeInsetsStyle:ZYButtonEdgeInsetsStyleTop imageTitleSpace:1];
        
    }
    return self;
}



@end
