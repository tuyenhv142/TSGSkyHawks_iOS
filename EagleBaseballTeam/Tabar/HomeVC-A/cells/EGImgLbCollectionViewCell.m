//
//  EGImgLbCollectionViewCell.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/1/24.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGImgLbCollectionViewCell.h"

@interface EGImgLbCollectionViewCell ()



@end

@implementation EGImgLbCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.backgroundColor = rgba(243, 243, 243, 1);
        
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(ScaleW(167));
        }];
        
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImageView.mas_bottom);
            make.right.mas_equalTo(0);
            make.left.mas_equalTo(0);
        }];
        
        [self.priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.titleLb.mas_bottom);
            make.right.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
    return self;
}


- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.backgroundColor = UIColor.whiteColor;
        _iconImageView.layer.cornerRadius = 10;
        _iconImageView.layer.masksToBounds = true;
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImageView.image = [UIImage imageNamed:@"樂天桃猿"];
        [self.contentView addSubview:_iconImageView];
    }
    return _iconImageView;
}
- (UILabel *)titleLb
{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.numberOfLines = 2;
        _titleLb.textAlignment = NSTextAlignmentLeft;
        _titleLb.text = @"TAKAO X TAKAMEI 軟軟球";
        _titleLb.textColor = rgba(38, 38, 38, 1);
        _titleLb.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightMedium];
        [self.contentView addSubview:_titleLb];
    }
    return _titleLb;
}
- (UILabel *)priceLb
{
    if (!_priceLb) {
        _priceLb = [UILabel new];
        _priceLb.textAlignment = NSTextAlignmentLeft;
        _priceLb.text = @"$150";
        _priceLb.textColor = rgba(0, 121, 192, 1);
        _priceLb.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightSemibold];
        [self.contentView addSubview:_priceLb];
    }
    return _priceLb;
}

@end
