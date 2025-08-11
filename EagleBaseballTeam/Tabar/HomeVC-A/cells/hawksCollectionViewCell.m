//
//  hawksCollectionViewCell.m
//  QuickstartApp
//
//  Created by rick on 1/22/25.
//

#import "hawksCollectionViewCell.h"

@implementation hawksCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.contentView.backgroundColor = rgba(243, 243, 243, 1);
        
        [self.contentView addSubview:self.baseView];
        [self.baseView addSubview:self.imageView];
        [self.baseView addSubview:self.titleLB];
        [self.baseView addSubview:self.dateLB];
    }
    return self;
}

-(void)layoutSubviews
{
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.dateLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.dateLB.mas_top).offset(-ScaleW(5));
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
//        make.height.mas_equalTo(ScaleW(194));
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(self.titleLB.mas_top).offset(-ScaleW(5));
    }];
}

- (UIView *)baseView
{
    if (_baseView == nil) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = rgba(243, 243, 243, 1);
    }
    return _baseView;
}
-(UIImageView *)imageView
{
    if(_imageView == nil)
    {
        _imageView = [[UIImageView alloc]init];
//        _imageView.contentMode = UIViewContentModeScaleAspectFill;
//        _imageView.image = [UIImage imageNamed:@"Familycard"];
        _imageView.layer.cornerRadius = 10;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}
- (UILabel *)dateLB
{
    if (_dateLB == nil) {
        _dateLB = [[UILabel alloc] init];
        _dateLB.textColor = rgba(115, 115, 115, 1);
//        _dateLB.text = @"2025-01-10";
        _dateLB.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightMedium];
    }
    return _dateLB;
}

- (UILabel *)titleLB
{
    if (_titleLB == nil) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.textColor = rgba(38, 38, 38, 1);
//        _titleLB.text = @"《The Chance 機會》台鋼雄鷹創隊紀錄片(...";
        _titleLB.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    }
    return _titleLB;
}

@end
