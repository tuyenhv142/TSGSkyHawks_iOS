//
//  OABtnImgCollectionViewCell.m
//  NewsoftOA24
//
//  Created by dragon_zheng on 2024/5/9.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import "EGGoodsExchangeViewCell.h"

@implementation EGGoodsExchangeViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        
        [self.contentView addSubview:self.baseIMGView];
        
        [self.contentView addSubview:self.baseView];
        
        [self.baseView addSubview:self.imageView];
        
        [self.baseView addSubview:self.titleLB_Tag];
        
        [self.baseView addSubview:self.titleLB];
        
        [self.baseView addSubview:self.iconImageView];
        
        [self.baseView addSubview:self.titleLA];
        
        [self.baseView addSubview:self.yellowcornerimageView];
        
        [self.baseView addSubview:self.usertypeLB];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(0));
        make.left.mas_equalTo(ScaleW(0));
        make.right.mas_equalTo(ScaleW(0));
        make.bottom.mas_equalTo(0);
    }];
    
    [self.baseIMGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(0));
        make.left.mas_equalTo(ScaleW(0));
        make.right.mas_equalTo(ScaleW(0));
        make.bottom.mas_equalTo(0);
    }];
    
    //商品图片
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(ScaleW(150));
        make.width.mas_equalTo(self.baseView);
    }];
    
    //特別優惠
    [self.titleLB_Tag mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.mas_equalTo(ScaleW(8));
        make.top.equalTo(self.imageView.mas_bottom).offset(ScaleW(10));
//             make.width.mas_equalTo(Device_Width/2 - ScaleW(20));
        make.right.mas_equalTo(-ScaleW(8));
         }];
    //文字
   [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(ScaleW(45));
            make.left.mas_equalTo(ScaleW(8));
       make.top.equalTo(self.titleLB_Tag.mas_bottom).offset(ScaleW(10));
//            make.width.mas_equalTo(Device_Width/2 - ScaleW(20));
       make.right.mas_equalTo(-ScaleW(8));
        }];
    
    //圆圈图片
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.baseView.mas_centerX).offset(ScaleW(-5));
         make.height.mas_equalTo(ScaleW(24));
         make.width.mas_equalTo(ScaleW(24));
        make.bottom.mas_equalTo(-ScaleW(40));
//        make.top.equalTo(self.titleLB.mas_bottom).offset(ScaleW(20));
         }];
    //价格
    [self.titleLA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(ScaleW(5));
         make.height.mas_equalTo(ScaleW(24));
         make.centerY.mas_equalTo(self.iconImageView);
         }];
    
    [self.yellowcornerimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(5));
        make.right.mas_equalTo(-ScaleW(5));
        make.height.mas_equalTo(ScaleW(17));
        make.width.mas_equalTo(ScaleW(80));
    }];
    
    //价格
    [self.usertypeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.yellowcornerimageView.mas_top);
         make.height.mas_equalTo(ScaleW(17));
        make.width.mas_equalTo(ScaleW(100));
        make.centerX.mas_equalTo(self.yellowcornerimageView.mas_centerX);
         }];
    
    
//    //点击button
//    [self.openbt mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.titleLA.mas_bottom).offset(ScaleW(15));
//        make.centerX.mas_equalTo(self.baseView.mas_centerX);
//        make.height.mas_equalTo(ScaleW(38));
//        make.right.mas_equalTo(-ScaleW(8));
//        make.left.mas_equalTo(ScaleW(8));
//    }];
    
}

- (UIImageView *)baseIMGView
{
    if (!_baseIMGView) {
        _baseIMGView = [UIImageView new];
        _baseIMGView.image = [UIImage imageNamed:@"giftBgIMG"];
        _baseIMGView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _baseIMGView;
}
- (UIView *)baseView
{
    if (_baseView == nil) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = [UIColor clearColor];
        _baseView.layer.cornerRadius = ScaleW(8);
        _baseView.layer.masksToBounds = YES;
    }
    return _baseView;
}

-(UIImageView *)yellowcornerimageView
{
    if(_yellowcornerimageView == nil)
    {
        _yellowcornerimageView = [[UIImageView alloc]init];
        _yellowcornerimageView.contentMode = UIViewContentModeScaleToFill;
        //_yellowcornerimageView.image = [UIImage imageNamed:@"Vector 1"];
//        _imageView.backgroundColor = rgba(174, 178, 191, 1);
//        _imageView.layer.cornerRadius = ScaleW(8);
//        _imageView.layer.masksToBounds = YES;
    }
    return _yellowcornerimageView;
}



- (UILabel *)usertypeLB
{
    if (_usertypeLB == nil) {
        _usertypeLB = [[UILabel alloc] init];
        _usertypeLB.text = @"";
        _usertypeLB.textColor = UIColor.whiteColor;
        _usertypeLB.textAlignment = NSTextAlignmentCenter;
        _usertypeLB.numberOfLines = 0;
        _usertypeLB.font = [UIFont systemFontOfSize:FontSize(12) weight:UIFontWeightRegular];
        [_usertypeLB sizeToFit];
    }
    return _usertypeLB;
}

-(UIImageView *)imageView
{
    if(_imageView == nil)
    {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleToFill;
//        _imageView.backgroundColor = rgba(174, 178, 191, 1);
//        _imageView.layer.cornerRadius = ScaleW(8);
//        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}
- (UILabel *)titleLB_Tag
{
    if (_titleLB_Tag == nil) {
        _titleLB_Tag = [[UILabel alloc] init];
        _titleLB_Tag.text = @"特別優惠";
        _titleLB_Tag.textColor = rgba(0, 122, 96, 1);
        _titleLB_Tag.textAlignment = NSTextAlignmentLeft;
        _titleLB_Tag.numberOfLines = 0;
        _titleLB_Tag.font = [UIFont systemFontOfSize:FontSize(12) weight:UIFontWeightSemibold];
        [_titleLB_Tag sizeToFit];
    }
    return _titleLB_Tag;
}

- (UILabel *)titleLB
{
    if (_titleLB == nil) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.textColor = [UIColor blackColor];
        _titleLB.textAlignment = NSTextAlignmentLeft;
        _titleLB.numberOfLines = 0;
        _titleLB.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightBold];
        [_titleLB sizeToFit];
    
    }
    return _titleLB;
}
    
-(UIImageView *)iconImageView{
    if(_iconImageView == nil)
    {
        _iconImageView = [[UIImageView alloc]init];
//        _iconImageView.contentMode = UIViewContentModeScaleToFill;
//        _iconImageView.backgroundColor = rgba(0, 122, 96, 1);
//        _iconImageView.layer.cornerRadius = ScaleW(12);
//        _iconImageView.layer.masksToBounds = YES;
//        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImageView.image = [UIImage imageNamed:@"TSG_Dark"];
    }
    return _iconImageView;
}
- (UILabel *)titleLA //价格
{
    if (_titleLA == nil) {
        _titleLA = [[UILabel alloc] init];
        _titleLA.text = @"123";
        _titleLA.textColor = UIColor.blackColor;//rgba(0, 122, 96, 1);
        _titleLA.textAlignment = NSTextAlignmentRight;
        _titleLA.font = [UIFont systemFontOfSize:FontSize(18) weight:UIFontWeightRegular];
    }
    return _titleLA;
}

- (void)setupCellInfo:(id )task {
    if ([task  isEqual: @(1)]) {
        UILabel *lable = [[UILabel alloc]initWithFrame: CGRectMake(ScaleW(3), ScaleW(3), ScaleW(82), ScaleW(22))];
        lable.backgroundColor = rgba(0, 0, 0, 0.5);
        lable.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = [UIColor whiteColor];
        lable.text = @"鷹國皇家限定";
        [self.imageView addSubview:lable];
        self.imageView.hidden = YES;
    }
}


//-(UIButton *)openbt{
//    if(_openbt == nil)
//    {
//        _openbt = [[UIButton alloc]init];
//        [_openbt setTitle:@"即將開放" forState:UIControlStateNormal];
//        [_openbt setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
//        _openbt.backgroundColor = rgba(0, 122, 96, 1);
//        _openbt.layer.masksToBounds = YES;
//        _openbt.layer.cornerRadius = ScaleW(8);
//        
//        [_openbt setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateDisabled];  // 禁用状态文字颜色
//        [_openbt setTitle:@"即將開放" forState: UIControlStateDisabled];
//        [_openbt setBackgroundImage:[UIImage imageWithColor:rgba(229, 229, 229, 1)] forState:UIControlStateDisabled];  // 禁用状态背景色
//        _openbt.enabled = NO;  // 设置按钮为禁用状态
//    }
//    return _openbt;
//}
//
//-(UIButton *)harticonbt{
//    if(_harticonbt == nil)
//    {
//        _harticonbt = [[UIButton alloc]init];
//        _harticonbt.contentMode = UIViewContentModeScaleToFill;
//        _harticonbt.backgroundColor = UIColor.clearColor;
//        _harticonbt.layer.cornerRadius = 10.0f;
//        _harticonbt.layer.masksToBounds = YES;
//        [_harticonbt setImage:[UIImage imageNamed:@"nohart"] forState:UIControlStateNormal];
//        [_harticonbt setImage:[UIImage imageNamed:@"hart"] forState:UIControlStateSelected];
//        [_harticonbt addTarget:self action:@selector(selectgoodsState:) forControlEvents:UIControlEventTouchUpInside];
//        
//    }
//    return _harticonbt;
//}

//-(void)selectgoodsState:(UIButton *)sender
//{
//    if (sender.selected == YES) {
//        sender.selected = !sender.selected;
//        
//    }else{
//        sender.selected = !sender.selected;
//    }
//}



@end
