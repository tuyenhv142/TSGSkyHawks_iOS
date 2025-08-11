//
//  EGiftExchangeCLTionViewCell.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/10.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGiftExchangeCLTionViewCell.h"

@implementation EGiftExchangeCLTionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.backgroundColor = UIColor.whiteColor;
        
        self.contentView.layer.cornerRadius = ScaleW(8);
        self.contentView.layer.masksToBounds = true;
        
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(ScaleW(167));
        }];
        
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImageView.mas_bottom).offset(ScaleW(0));
            make.right.mas_equalTo(-ScaleW(10));
            make.left.mas_equalTo(ScaleW(10));
        }];
        
        [self.statueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.titleLb.mas_bottom).offset(ScaleW(40));
            make.height.mas_equalTo(ScaleW(35));
            make.right.mas_equalTo(-ScaleW(10));
            make.left.mas_equalTo(ScaleW(10));
            make.bottom.mas_equalTo(-ScaleW(20));
        }];
    }
    return self;
}


- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.backgroundColor = UIColor.whiteColor;
//        _iconImageView.layer.cornerRadius = 10;
//        _iconImageView.layer.masksToBounds = true;
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
//        _titleLb.backgroundColor = [UIColor redColor];
        _titleLb.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightMedium];
        [self.contentView addSubview:_titleLb];
    }
    return _titleLb;
}

- (UIButton *)statueBtn
{
    if (!_statueBtn) {
        _statueBtn = [[UIButton alloc] init];
        [_statueBtn setTitle:@"贈品兌換" forState: UIControlStateNormal];
        _statueBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:(UIFontWeightMedium)];
        [_statueBtn setTitleColor:rgba(255, 255, 255, 1) forState:UIControlStateNormal];
        _statueBtn.backgroundColor = rgba(0, 122, 96, 1);
        _statueBtn.layer.cornerRadius = ScaleW(8);
        _statueBtn.layer.masksToBounds = true;
        
        [_statueBtn setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateDisabled];  // 禁用状态文字颜色
        [_statueBtn setTitle:@"即將開放" forState: UIControlStateDisabled];
        [_statueBtn setBackgroundImage:[UIImage imageWithColor:rgba(229, 229, 229, 1)] forState:UIControlStateDisabled];  // 禁用状态背景色
        
        _statueBtn.enabled = NO;  // 设置按钮为禁用状态
        [self.contentView addSubview:_statueBtn];
    }
    return _statueBtn;
}

-(void)setModeInfo:(NSDictionary *)dict{
    [self.iconImageView setImage:[UIImage imageNamed:dict[@"image"]]];
    [self.titleLb setText:dict[@"name"]];
    
}
@end
