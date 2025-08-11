//
//  OABtnImgCollectionViewCell.m
//  NewsoftOA24
//
//  Created by dragon_zheng on 2024/5/9.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import "EGirlClassCollectionViewCell.h"

@implementation EGirlClassCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self.contentView addSubview:self.baseView];
        
        [self.baseView addSubview:self.imageView];
        
        [self.baseView addSubview:self.titleLB];
        
        [self.baseView addSubview:self.titleLA];
    }
    return self;
}

-(void)layoutSubviews
{
//    self.contentView.backgroundColor = [UIColor redColor];
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(0));
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
//        make.height.mas_equalTo(180);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
      make.height.mas_equalTo(ScaleW(75));
        make.width.mas_equalTo(ScaleW(75));
    }];
    
   [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(ScaleW(24));
            make.centerX.mas_equalTo(self.imageView.mas_centerX);
            make.top.mas_equalTo(self.imageView.mas_bottom);
            make.width.mas_equalTo(ScaleW(75));
        }];
    
    [self.titleLA mas_makeConstraints:^(MASConstraintMaker *make) {
             make.height.mas_equalTo(ScaleW(24));
            make.centerX.mas_equalTo(self.imageView.mas_centerX);
            make.top.mas_equalTo(self.titleLB.mas_bottom);
             make.width.mas_equalTo(ScaleW(75));
         }];
    
}

- (UIView *)baseView
{
    if (_baseView == nil) {
        _baseView = [[UIView alloc] init];
        //_baseView.backgroundColor = [UIColor yellowColor];
        _baseView.layer.cornerRadius = 10;
        _baseView.layer.masksToBounds = YES;
    }
    return _baseView;
}
-(UIImageView *)imageView
{
    if(_imageView == nil)
    {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.backgroundColor = rgba(174, 178, 191, 1);
        _imageView.layer.cornerRadius = ScaleW(75)/2;
        _imageView.layer.masksToBounds = YES;
        
    }
    return _imageView;
}
- (UILabel *)titleLB
{
    if (_titleLB == nil) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.textColor = [UIColor blackColor];
        _titleLB.text = @"2";
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
    }
    return _titleLB;
}
    
    
- (UILabel *)titleLA
    {
        if (_titleLA == nil) {
            _titleLA = [[UILabel alloc] init];
            _titleLA.text = @"一粒";
            _titleLA.textColor = [UIColor blackColor];
            _titleLA.textAlignment = NSTextAlignmentCenter;
            _titleLA.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightRegular];
        }
        return _titleLA;
    }
@end
