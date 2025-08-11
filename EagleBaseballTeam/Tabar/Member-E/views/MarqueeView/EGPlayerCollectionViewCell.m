//
//  OABtnImgCollectionViewCell.m
//  NewsoftOA24
//
//  Created by dragon_zheng on 2024/5/9.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import "EGPlayerCollectionViewCell.h"

@implementation EGPlayerCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self.contentView addSubview:self.baseView];
        [self.baseView addSubview:self.titleLB];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(0));
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
   [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(ScaleW(24));
            make.left.mas_equalTo(ScaleW(0));
            make.bottom.mas_equalTo(-ScaleW(0));
            make.width.mas_equalTo(ScaleW(56));
        }];
    
    
}

- (UIView *)baseView
{
    if (_baseView == nil) {
        _baseView = [[UIView alloc] init];
//        _baseView.backgroundColor = [UIColor yellowColor];
        _baseView.layer.cornerRadius = 10;
        _baseView.layer.masksToBounds = YES;
        _baseView.layer.borderColor = UIColor.whiteColor.CGColor;
        _baseView.layer.borderWidth = 1.0;
    }
    return _baseView;
}

- (UILabel *)titleLB
{
    if (_titleLB == nil) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.textColor = [UIColor whiteColor];
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
    }
    return _titleLB;
}
    

-(void) setInfo:(NSDictionary *)info{
    self.titleLB.text  = [info objectForKey:@"CHName"];
}
@end
