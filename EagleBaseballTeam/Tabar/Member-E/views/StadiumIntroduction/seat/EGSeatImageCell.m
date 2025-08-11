//
//  GiftTBViewHeaderFooterView.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/4/28.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGSeatImageCell.h"
#import "UISwitch.h"
#import "UIImageView+ColorAtPoint.h"
@implementation EGSeatImageCell

+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"EGSeatImageCell";
    EGSeatImageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[EGSeatImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//cell选中无色
    
    return cell;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        {
            self.contentView.backgroundColor = ColorRGB(0xF5F5F5);
            
            self.helpLableView = [UIView new];
            [self.contentView addSubview:self.helpLableView];
            [self.helpLableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.contentView.mas_centerX);
                make.top.mas_equalTo(self.contentView.mas_top);
                make.width.mas_equalTo(ScaleW(300));
                make.height.mas_equalTo(ScaleW(300));
            }];
            
            self.googleMapView = [UIImageView new];
            self.googleMapView.contentMode = UIViewContentModeScaleAspectFit;
            self.googleMapView.image = [UIImage imageNamed:@"chengqinghuchangdi"];
            self.googleMapView.userInteractionEnabled = YES;
            [self.helpLableView addSubview:self.googleMapView];
            [self.googleMapView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.helpLableView.mas_centerX);
                make.top.mas_equalTo(ScaleW(0));
                make.width.mas_equalTo(ScaleW(300));
                make.height.mas_equalTo(ScaleW(300));
            }];
                        
            // 添加点击手势
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [self.googleMapView addGestureRecognizer:tapGesture];
            
            [self setImagView];
            
            self.helpTitle = [UILabel new];
            self.helpTitle.textAlignment = NSTextAlignmentCenter;
            self.helpTitle.text = @"點擊座位區，查看票價及資訊";
            self.helpTitle.textColor = ColorRGB(0x007A60);
            self.helpTitle.font = [UIFont boldSystemFontOfSize:FontSize(20)];
            [self.helpLableView addSubview:self.helpTitle];
            [self.helpTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.googleMapView.mas_bottom);
                make.centerX.mas_equalTo(self.googleMapView.mas_centerX);
                make.width.mas_equalTo(ScaleW(300));
                make.height.mas_equalTo(ScaleW(28));
            }];
            
            
            self.swichbackView = [UIView new];
            self.swichbackView.backgroundColor = ColorRGB(0x007A60);
            self.swichbackView.layer.cornerRadius = ScaleW(10);
            self.swichbackView.layer.masksToBounds = YES;
            [self.contentView addSubview:self.swichbackView];
            [self.swichbackView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.width.mas_equalTo(ScaleW(75));
                make.height.mas_equalTo(ScaleW(24));
            }];
            
            self.left_bt = [UIButton new];
            self.left_bt.tag = 101;
            self.left_bt.backgroundColor = UIColor.whiteColor;
            self.left_bt.layer.cornerRadius = ScaleW(20)/2;
            [self.left_bt addTarget:self action:@selector(switchAddress:) forControlEvents:UIControlEventTouchUpInside];
            [self.swichbackView addSubview:self.left_bt];
            [self.left_bt mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.swichbackView.mas_centerY);
                make.left.mas_equalTo(ScaleW(5));
                make.width.mas_equalTo(ScaleW(20));
                make.height.mas_equalTo(ScaleW(20));
            }];
            self.left_bt.hidden = YES;
            
            self.left_label = [UILabel new];
            self.left_label.textAlignment = NSTextAlignmentLeft;
            self.left_label.text = @"嘉義";
            self.left_label.textColor = UIColor.whiteColor;
            self.left_label.font = [UIFont systemFontOfSize:FontSize(14)];
            [self.swichbackView addSubview:self.left_label];
            [self.left_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.swichbackView.mas_centerY);
                make.left.mas_equalTo(self.left_bt.mas_right).offset(ScaleW(3));
                make.width.mas_equalTo(ScaleW(300));
                make.height.mas_equalTo(ScaleW(28));
            }];
            self.left_label.hidden = YES;
            
            self.right_bt = [UIButton new];
            self.right_bt.tag = 102;
            self.right_bt.backgroundColor = UIColor.whiteColor;
            [self.right_bt addTarget:self action:@selector(switchAddress:) forControlEvents:UIControlEventTouchUpInside];
            self.right_bt.layer.cornerRadius = ScaleW(20)/2;
            [self.swichbackView addSubview:self.right_bt];
            [self.right_bt mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.swichbackView.mas_centerY);
                make.right.mas_equalTo(-ScaleW(5));
                make.width.mas_equalTo(ScaleW(20));
                make.height.mas_equalTo(ScaleW(20));
            }];
            
            self.right_label = [UILabel new];
            self.right_label.textAlignment = NSTextAlignmentRight;
            self.right_label.text = @"澄清湖";
            self.right_label.textColor = UIColor.whiteColor;
            self.right_label.font = [UIFont systemFontOfSize:FontSize(14)];
            [self.swichbackView addSubview:self.right_label];
            [self.right_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.swichbackView.mas_centerY);
                make.right.mas_equalTo(self.right_bt.mas_left).offset(-ScaleW(3));
                make.width.mas_equalTo(ScaleW(300));
                make.height.mas_equalTo(ScaleW(28));
            }];
            
            _click_type = -1;
            _changdi_type = 101;
            _changdi_clickIndex = 0;
            _changdi_selectdic = [NSMutableDictionary new];
            [_changdi_selectdic setObject:[NSNumber numberWithInteger:_changdi_type] forKey:@"changdi_type"];
            [_changdi_selectdic setObject:[NSNumber numberWithInteger:_changdi_clickIndex] forKey:@"changdi_area"];
            [_changdi_selectdic setObject:[NSNumber numberWithInteger:_click_type] forKey:@"click_area"];
            
            
            _chengqinghu_hotarea_View.hidden = YES;//Image base全图
            _chengqinghu_waiye_View.hidden = YES;//Image base全图
            _chengqinghu_kedui_View.hidden = YES;//Image base全图
            _chengqinghu_yingyuanxi_View.hidden = YES;//Image base全图
            _chengqinghu_VIP_View.hidden = YES;//Image base全图
            _jiayi_neiye_View.hidden = YES;//Image base全图
            _jiayi_waiye_View.hidden = YES;//Image base全图
        }
    }
    return self;
}

-(void)setImagView
{
    self.chengqinghu_hotarea_View = [UIImageView new];
    self.chengqinghu_hotarea_View.alpha = 0.5;
    self.chengqinghu_hotarea_View.backgroundColor = ColorRGB(0x000000);
    self.chengqinghu_hotarea_View.contentMode = UIViewContentModeScaleAspectFit;
    self.chengqinghu_hotarea_View.image = [UIImage imageNamed:@"澄清湖棒球場_熱區"];
    [self.helpLableView addSubview:self.chengqinghu_hotarea_View];
    [self.chengqinghu_hotarea_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.helpLableView.mas_centerX);
        make.top.mas_equalTo(ScaleW(0));
        make.width.mas_equalTo(ScaleW(300));
        make.height.mas_equalTo(ScaleW(300));
    }];
    
     
    
    self.chengqinghu_waiye_View = [UIImageView new];
    self.chengqinghu_waiye_View.alpha = 0.5;
    self.chengqinghu_waiye_View.backgroundColor = ColorRGB(0x000000);
    self.chengqinghu_waiye_View.contentMode = UIViewContentModeScaleAspectFit;
    self.chengqinghu_waiye_View.image = [UIImage imageNamed:@"澄清湖棒球場_外野"];
    [self.helpLableView addSubview:self.chengqinghu_waiye_View];
    [self.chengqinghu_waiye_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.helpLableView.mas_centerX);
        make.top.mas_equalTo(ScaleW(0));
        make.width.mas_equalTo(ScaleW(300));
        make.height.mas_equalTo(ScaleW(300));
    }];
    
    self.chengqinghu_kedui_View = [UIImageView new];
    self.chengqinghu_kedui_View.alpha = 0.5;
    self.chengqinghu_kedui_View.backgroundColor = ColorRGB(0x000000);
    self.chengqinghu_kedui_View.contentMode = UIViewContentModeScaleAspectFit;
    self.chengqinghu_kedui_View.image = [UIImage imageNamed:@"澄清湖棒球場_客隊應援區"];
    [self.helpLableView addSubview:self.chengqinghu_kedui_View];
    [self.chengqinghu_kedui_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.helpLableView.mas_centerX);
        make.top.mas_equalTo(ScaleW(0));
        make.width.mas_equalTo(ScaleW(300));
        make.height.mas_equalTo(ScaleW(300));
    }];
    
    self.chengqinghu_yingyuanxi_View = [UIImageView new];
    self.chengqinghu_yingyuanxi_View.alpha = 0.5;
    self.chengqinghu_yingyuanxi_View.backgroundColor = ColorRGB(0x000000);
    self.chengqinghu_yingyuanxi_View.contentMode = UIViewContentModeScaleAspectFit;
    self.chengqinghu_yingyuanxi_View.image = [UIImage imageNamed:@"澄清湖棒球場_鷹援席"];
    [self.helpLableView addSubview:self.chengqinghu_yingyuanxi_View];
    [self.chengqinghu_yingyuanxi_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.helpLableView.mas_centerX);
        make.top.mas_equalTo(ScaleW(0));
        make.width.mas_equalTo(ScaleW(300));
        make.height.mas_equalTo(ScaleW(300));
    }];
    
    self.chengqinghu_VIP_View = [UIImageView new];
    self.chengqinghu_VIP_View.alpha = 0.5;
    self.chengqinghu_VIP_View.backgroundColor = ColorRGB(0x000000);
    self.chengqinghu_VIP_View.contentMode = UIViewContentModeScaleAspectFit;
    self.chengqinghu_VIP_View.image = [UIImage imageNamed:@"澄清湖棒球場_鷹眼席"];
    [self.helpLableView addSubview:self.chengqinghu_VIP_View];
    [self.chengqinghu_VIP_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.helpLableView.mas_centerX);
        make.top.mas_equalTo(ScaleW(0));
        make.width.mas_equalTo(ScaleW(300));
        make.height.mas_equalTo(ScaleW(300));
    }];
    
    
    self.jiayi_neiye_View = [UIImageView new];
    self.jiayi_neiye_View.alpha = 0.5;
    self.jiayi_neiye_View.backgroundColor = ColorRGB(0x000000);
    self.jiayi_neiye_View.contentMode = UIViewContentModeScaleAspectFit;
    self.jiayi_neiye_View.image = [UIImage imageNamed:@"嘉義市棒球場_內野全區"];
    [self.helpLableView addSubview:self.jiayi_neiye_View];
    [self.jiayi_neiye_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.helpLableView.mas_centerX);
        make.top.mas_equalTo(ScaleW(0));
        make.width.mas_equalTo(ScaleW(300));
        make.height.mas_equalTo(ScaleW(300));
    }];
    
    
    self.jiayi_waiye_View = [UIImageView new];
    self.jiayi_waiye_View.alpha = 0.5;
    self.jiayi_waiye_View.backgroundColor = ColorRGB(0x000000);
    self.jiayi_waiye_View.contentMode = UIViewContentModeScaleAspectFit;
    self.jiayi_waiye_View.image = [UIImage imageNamed:@"嘉義市棒球場_外野區"];
    [self.helpLableView addSubview:self.jiayi_waiye_View];
    [self.jiayi_waiye_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.helpLableView.mas_centerX);
        make.top.mas_equalTo(ScaleW(0));
        make.width.mas_equalTo(ScaleW(300));
        make.height.mas_equalTo(ScaleW(300));
    }];
    
    
    _chengqinghu_hotarea_data = self.chengqinghu_hotarea_View.image;
    _chengqinghu_waiye_data = self.chengqinghu_waiye_View.image;
    _chengqinghu_kedui_data = self.chengqinghu_kedui_View.image;
    _chengqinghu_yingyuanxi_data = self.chengqinghu_yingyuanxi_View.image;
    _chengqinghu_VIP_data = self.chengqinghu_VIP_View.image;
    _jiayi_neiye = self.jiayi_neiye_View.image;
    _jiayi_waiye = self.jiayi_waiye_View.image;
    
    
    
    _chengqinghu_hotarea_View.hidden = YES;//Image base全图
    _chengqinghu_waiye_View.hidden = YES;//Image base全图
    _chengqinghu_kedui_View.hidden = YES;//Image base全图
    _chengqinghu_yingyuanxi_View.hidden = YES;//Image base全图
    _chengqinghu_VIP_View.hidden = YES;//Image base全图
    _jiayi_neiye_View.hidden = YES;//Image base全图
    _jiayi_waiye_View.hidden = YES;//Image base全图
                
}

-(void)switchAddress:(UIButton *)btn
{
    _chengqinghu_hotarea_View.hidden = YES;//Image base全图
    _chengqinghu_waiye_View.hidden = YES;//Image base全图
    _chengqinghu_kedui_View.hidden = YES;//Image base全图
    _chengqinghu_yingyuanxi_View.hidden = YES;//Image base全图
    _chengqinghu_VIP_View.hidden = YES;//Image base全图
    _jiayi_neiye_View.hidden = YES;//Image base全图
    _jiayi_waiye_View.hidden = YES;//Image base全图
    
    [_changdi_selectdic setObject:[NSNumber numberWithInteger:-1] forKey:@"changdi_area"];
    [_changdi_selectdic setObject:[NSNumber numberWithInteger:0] forKey:@"click_area"];
    switch (btn.tag) {
        case 101:
        {
            self.right_bt.hidden = NO;
            self.right_label.hidden = NO;
            self.left_bt.hidden = YES;
            self.left_label.hidden = YES;
            self.swichbackView.backgroundColor = ColorRGB(0x007A60);
            //
            self.googleMapView.image = [UIImage imageNamed:@"chengqinghuchangdi"];
            _changdi_type = 101;
            [_changdi_selectdic setObject:[NSNumber numberWithInteger:_changdi_type] forKey:@"changdi_type"];
        }
            break;
            
        case 102:
        {
            self.left_bt.hidden = NO;
            self.left_label.hidden = NO;
            self.right_bt.hidden = YES;
            self.right_label.hidden = YES;
            self.swichbackView.backgroundColor = ColorRGB(0xD9AE35);
            self.googleMapView.image = [UIImage imageNamed:@"jiayichangdi"];
            
            _changdi_type = 102;
            [_changdi_selectdic setObject:[NSNumber numberWithInteger:_changdi_type] forKey:@"changdi_type"];
        }
            break;
    }

    
    //发block
    if(self.changditypeblock)
    {
        self.changditypeblock(_changdi_selectdic);
    }
    
}

- (void)IntalImageView:(NSInteger)select
{
    _chengqinghu_hotarea_View.hidden = YES;//Image base全图
    _chengqinghu_waiye_View.hidden = YES;//Image base全图
    _chengqinghu_kedui_View.hidden = YES;//Image base全图
    _chengqinghu_yingyuanxi_View.hidden = YES;//Image base全图
    _chengqinghu_VIP_View.hidden = YES;//Image base全图
    _jiayi_neiye_View.hidden = YES;//Image base全图
    _jiayi_waiye_View.hidden = YES;//Image base全图
    
    if(_changdi_type == 101){
        switch (select) {
            case 0:
            {
                _chengqinghu_hotarea_View.hidden = NO;
                _changdi_clickIndex = 0;
                [_changdi_selectdic setObject:[NSNumber numberWithInteger:_changdi_clickIndex] forKey:@"changdi_area"];
            }
                break;
                
            case 1:
            {
                _chengqinghu_VIP_View.hidden = NO;//Image base全图
                _changdi_clickIndex = 1;
                [_changdi_selectdic setObject:[NSNumber numberWithInteger:_changdi_clickIndex] forKey:@"changdi_area"];
            }
                break;
                
            case 2:
            {
                _chengqinghu_yingyuanxi_View.hidden = NO;
                _changdi_clickIndex = 2;
                [_changdi_selectdic setObject:[NSNumber numberWithInteger:_changdi_clickIndex] forKey:@"changdi_area"];
            }
                break;
                
            case 3:
            {
                _chengqinghu_waiye_View.hidden = NO;
                _changdi_clickIndex = 3;
                [_changdi_selectdic setObject:[NSNumber numberWithInteger:_changdi_clickIndex] forKey:@"changdi_area"];
            }
                break;
                
            case 4:
            {
                _chengqinghu_kedui_View.hidden = NO;
                _changdi_clickIndex = 4;
                [_changdi_selectdic setObject:[NSNumber numberWithInteger:_changdi_clickIndex] forKey:@"changdi_area"];
            }
                break;
                
            
        }
        
    }
    else
    {
        switch (select) {
            case 0:
            {
                _jiayi_neiye_View.hidden = NO;
                _changdi_clickIndex = 0;
                [_changdi_selectdic setObject:[NSNumber numberWithInteger:_changdi_clickIndex] forKey:@"changdi_area"];
            }
                break;
                
            case 1:
            {
                _jiayi_waiye_View.hidden = NO;
                _changdi_clickIndex = 1;
                [_changdi_selectdic setObject:[NSNumber numberWithInteger:_changdi_clickIndex] forKey:@"changdi_area"];
            }
                break;
        }
    }
    
}

- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    _chengqinghu_hotarea_View.hidden = YES;//Image base全图
    _chengqinghu_waiye_View.hidden = YES;//Image base全图
    _chengqinghu_kedui_View.hidden = YES;//Image base全图
    _chengqinghu_yingyuanxi_View.hidden = YES;//Image base全图
    _chengqinghu_VIP_View.hidden = YES;//Image base全图
    _jiayi_neiye_View.hidden = YES;//Image base全图
    _jiayi_waiye_View.hidden = YES;//Image base全图
    
    [_changdi_selectdic setObject:[NSNumber numberWithInteger:1] forKey:@"click_area"];
    
    CGPoint tapPoint = [gesture locationInView:self.googleMapView];
    if(_changdi_type == 101){
                UIColor *chengqinghu_VIP_color = [self.googleMapView colorAtPoint:tapPoint data:self.chengqinghu_VIP_data];
        if (chengqinghu_VIP_color) {
            // 获取RGB分量
            CGFloat red, green, blue, alpha;
            [chengqinghu_VIP_color getRed:&red green:&green blue:&blue alpha:&alpha];
            if(alpha>0.1)
            {
//                NSLog(@"进入鹰眼区");
                _chengqinghu_VIP_View.hidden = NO;//Image base全图
                _changdi_clickIndex = 1;
                [_changdi_selectdic setObject:[NSNumber numberWithInteger:_changdi_clickIndex] forKey:@"changdi_area"];
                //发block
                if(self.changditypeblock)
                {
                    self.changditypeblock(_changdi_selectdic);
                }
            }
            
        }
        
        
        UIColor *chengqinghu_hotarea_color = [self.googleMapView colorAtPoint:tapPoint data:_chengqinghu_hotarea_data];
        if (chengqinghu_hotarea_color) {
            // 获取RGB分量
            CGFloat red, green, blue, alpha;
            [chengqinghu_hotarea_color getRed:&red green:&green blue:&blue alpha:&alpha];
            if(alpha>0.1)
            {
//                NSLog(@"进入热点区");
                _chengqinghu_hotarea_View.hidden = NO;
                _changdi_clickIndex = 0;
                [_changdi_selectdic setObject:[NSNumber numberWithInteger:_changdi_clickIndex] forKey:@"changdi_area"];
                
                //发block
                if(self.changditypeblock)
                {
                    self.changditypeblock(_changdi_selectdic);
                }
            }
            
        }
        
        
        
        UIColor *chengqinghu_waiye_color = [self.googleMapView colorAtPoint:tapPoint data:_chengqinghu_waiye_data];
        if (chengqinghu_waiye_color) {
            // 获取RGB分量
            CGFloat red, green, blue, alpha;
            [chengqinghu_waiye_color getRed:&red green:&green blue:&blue alpha:&alpha];
            if(alpha>0.1)
            {
//                NSLog(@"进入澄清胡外野区");
                _chengqinghu_waiye_View.hidden = NO;
                _changdi_clickIndex = 3;
                [_changdi_selectdic setObject:[NSNumber numberWithInteger:_changdi_clickIndex] forKey:@"changdi_area"];
                
                //发block
                if(self.changditypeblock)
                {
                    self.changditypeblock(_changdi_selectdic);
                }
            }
        }
        
        
        
        UIColor *chengqinghu_kedui_color = [self.googleMapView colorAtPoint:tapPoint data:_chengqinghu_kedui_data];
        if (chengqinghu_kedui_color) {
            // 获取RGB分量
            CGFloat red, green, blue, alpha;
            [chengqinghu_kedui_color getRed:&red green:&green blue:&blue alpha:&alpha];
            if(alpha>0.1)
            {
//                NSLog(@"进入客队应援休息区");
                _chengqinghu_kedui_View.hidden = NO;
                _changdi_clickIndex = 4;
                [_changdi_selectdic setObject:[NSNumber numberWithInteger:_changdi_clickIndex] forKey:@"changdi_area"];
                
                //发block
                if(self.changditypeblock)
                {
                    self.changditypeblock(_changdi_selectdic);
                }
            }
        }
        
        
        UIColor *chengqinghu_yingyuanxi_color = [self.googleMapView colorAtPoint:tapPoint data:_chengqinghu_yingyuanxi_data];
        if (chengqinghu_yingyuanxi_color) {
            // 获取RGB分量
            CGFloat red, green, blue, alpha;
            [chengqinghu_yingyuanxi_color getRed:&red green:&green blue:&blue alpha:&alpha];
            if(alpha>0.1)
            {
//                NSLog(@"进入主队应援席区");
                _chengqinghu_yingyuanxi_View.hidden = NO;
                _changdi_clickIndex = 2;
                [_changdi_selectdic setObject:[NSNumber numberWithInteger:_changdi_clickIndex] forKey:@"changdi_area"];
                
                //发block
                if(self.changditypeblock)
                {
                    self.changditypeblock(_changdi_selectdic);
                }
            }
        }
    }
    else{
        UIColor *jiayi_neiye_color = [self.googleMapView colorAtPoint:tapPoint data:_jiayi_neiye];
        if (jiayi_neiye_color) {
            // 获取RGB分量
            CGFloat red, green, blue, alpha;
            [jiayi_neiye_color getRed:&red green:&green blue:&blue alpha:&alpha];
            if(alpha>0.1)
            {
//                NSLog(@"进入嘉怡主场内野区");
                _jiayi_neiye_View.hidden = NO;
                _changdi_clickIndex = 0;
                [_changdi_selectdic setObject:[NSNumber numberWithInteger:_changdi_clickIndex] forKey:@"changdi_area"];
                
                //发block
                if(self.changditypeblock)
                {
                    self.changditypeblock(_changdi_selectdic);
                }
            }
        }
        UIColor *jiayi_waiye_color = [self.googleMapView colorAtPoint:tapPoint data:_jiayi_waiye];
        if (jiayi_waiye_color) {
            // 获取RGB分量
            CGFloat red, green, blue, alpha;
            [jiayi_waiye_color getRed:&red green:&green blue:&blue alpha:&alpha];
            if(alpha>0.1)
            {
//                NSLog(@"进入嘉怡主场外野区");
                _jiayi_waiye_View.hidden = NO;
                _changdi_clickIndex = 1;
                [_changdi_selectdic setObject:[NSNumber numberWithInteger:_changdi_clickIndex] forKey:@"changdi_area"];
                
                //发block
                if(self.changditypeblock)
                {
                    self.changditypeblock(_changdi_selectdic);
                }
            }
        }
    }
    
    
}


@end
