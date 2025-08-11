//
//  OABtnImgCollectionViewCell.m
//  NewsoftOA24
//
//  Created by dragon_zheng on 2024/5/9.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import "EGmedalCollectionViewCell.h"



@implementation EGmedalCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self.contentView addSubview:self.baseView];
        
        [self.baseView addSubview:self.imageView];
        
        [self.baseView addSubview:self.status_label];
        
        [self.baseView addSubview:self.name_label];
        
        [self.baseView addSubview:self.status];
        
        [self.baseView addSubview:self.percent_label];
    }
    return self;
}

-(void)layoutSubviews
{
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(30));
        make.left.mas_equalTo(ScaleW(5));
        make.right.mas_equalTo(-ScaleW(5));
        //make.bottom.mas_equalTo(0);
       // make.height.mas_equalTo(self.contentView.height);
        //make.bottom.mas_equalTo(ScaleW(150));
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        //make.bottom.mas_equalTo(self.status_label.mas_top).offset(-ScaleW(5));
        make.centerX.mas_equalTo(self.baseView.mas_centerX);
        make.width.mas_equalTo(ScaleW(98));
        make.height.mas_equalTo(ScaleW(98));
    }];
    
//    self.status_label.backgroundColor = [UIColor redColor];
   [self.status_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.imageView.mas_bottom).offset(ScaleW(8));
            make.centerX.mas_equalTo(self.imageView.mas_centerX);
            make.width.mas_equalTo(ScaleW(98));
            make.height.mas_equalTo(ScaleW(24));
        }];
    
    //self.name_label.backgroundColor = [UIColor redColor];
    [self.name_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.status_label.mas_bottom).offset(ScaleW(10));
            // make.height.mas_equalTo(ScaleW(24));
            make.centerX.mas_equalTo(self.baseView.mas_centerX);
            //make.width.mas_equalTo(ScaleW(100));
         }];
    
    [self.status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.status_label.mas_bottom).offset(ScaleW(8));
        make.centerX.mas_equalTo(self.baseView.mas_centerX);
        make.width.mas_equalTo(ScaleW(98));
        make.bottom.mas_equalTo(0);
       // make.height.mas_equalTo(ScaleW(20));
    }];
    
    
    [self.percent_label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.status.mas_centerY);
        make.top.mas_equalTo(self.status_label.mas_bottom).offset(ScaleW(8));
        make.centerX.mas_equalTo(self.status.mas_centerX);
        make.width.mas_equalTo(ScaleW(60));
        make.height.mas_equalTo(ScaleW(20));
        make.bottom.mas_equalTo(0);
    }];
    
}

- (UIView *)baseView
{
    if (_baseView == nil) {
        _baseView = [[UIView alloc] init];
        //_baseView.backgroundColor = [UIColor yellowColor];
        _baseView.backgroundColor=rgba(245, 245, 245, 1);;
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
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor=rgba(245, 245, 245, 1);;
        _imageView.layer.cornerRadius = 10.0f;
        _imageView.layer.masksToBounds = YES;
        
    }
    return _imageView;
}
- (UILabel *)status_label
{
    if (_status_label== nil) {
        _status_label = [[UILabel alloc] init];
        _status_label.text = @"";
        _status_label.textColor = [UIColor blackColor];
        _status_label.textAlignment = NSTextAlignmentCenter;
        _status_label.font = [UIFont systemFontOfSize:FontSize(14)];
        [_status_label sizeToFit];
    }
    return _status_label;
}
    
    
- (UILabel *)name_label
    {
        if (_name_label == nil) {
            _name_label = [[UILabel alloc] init];
            _name_label.text = @"";
            _name_label.textColor = [UIColor grayColor];
            _name_label.textAlignment = NSTextAlignmentCenter;
            _name_label.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
            [_name_label sizeToFit];
        }
        
        _name_label.hidden = YES;
        return _name_label;
    }

- (UICustomSlider *)status
    {
        if (_status == nil) {
            _status = [[UICustomSlider alloc] initWithFrame:CGRectMake(ScaleW(20), ScaleW(100), ScaleW(98), ScaleW(20))];
        }
        return _status;
    }

-(UILabel*)percent_label
{
    if (_percent_label == nil) {
        _percent_label = [[UILabel alloc] init];
        _percent_label.text = @"";
        _percent_label.textColor = [UIColor blackColor];
        _percent_label.textAlignment = NSTextAlignmentCenter;
        _percent_label.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
        [_percent_label sizeToFit];
    }
    return _percent_label;
}


-(void)setprogress:(BOOL)enable
{
    [_status setStatus:enable Rate:self.rate];
}
@end
