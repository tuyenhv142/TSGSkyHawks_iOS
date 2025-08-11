//
//  OABtnImgCollectionViewCell.m
//  NewsoftOA24
//
//  Created by dragon_zheng on 2024/5/9.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import "EGyingyuantuanViewCell.h"

@implementation EGyingyuantuanViewCell

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
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
//        make.height.mas_equalTo(180);
    }];
    
   [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(ScaleW(24));
            make.left.mas_equalTo(ScaleW(0));
            make.bottom.mas_equalTo(-ScaleW(20));
            make.width.mas_equalTo(ScaleW(100));
        }];
    
    [self.titleLA mas_makeConstraints:^(MASConstraintMaker *make) {
             make.height.mas_equalTo(ScaleW(24));
             make.right.mas_equalTo(ScaleW(0));
             make.bottom.mas_equalTo(-ScaleW(20));
         }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.titleLB.mas_top).offset(-ScaleW(12));
        make.centerX.mas_equalTo(0);
//        make.height.mas_equalTo(ScaleW(198));
//        make.width.mas_equalTo(ScaleW(159));
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
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
        _imageView.layer.cornerRadius = ScaleW(8) ;
        _imageView.layer.masksToBounds = YES;
        
    }
    return _imageView;
}
- (UILabel *)titleLB
{
    if (_titleLB == nil) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.textColor = [UIColor blackColor];
        _titleLB.textAlignment = NSTextAlignmentLeft;
        _titleLB.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightMedium];
    }
    return _titleLB;
}
    
    
- (UILabel *)titleLA
    {
        if (_titleLA == nil) {
            _titleLA = [[UILabel alloc] init];
            _titleLA.text = @"123";
            _titleLA.textColor = rgba(0, 122, 96, 1);
            _titleLA.textAlignment = NSTextAlignmentRight;
            _titleLA.font = [UIFont systemFontOfSize:FontSize(24) weight:UIFontWeightMedium];
        }
        return _titleLA;
    }
@end
