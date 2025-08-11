//
//  GiftTBViewHeaderFooterView.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/4/28.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGCateringImageCell.h"
@implementation EGCateringImageCell

+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"EGCateringImageCell";
    EGCateringImageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[EGCateringImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class
        
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
                make.top.mas_equalTo(0);
                make.width.mas_equalTo(ScaleW(350));
                make.height.mas_equalTo(ScaleW(300));
            }];
            
            self.googleMapView = [UIImageView new];
            self.googleMapView.contentMode = UIViewContentModeScaleAspectFit;
            self.googleMapView.image = [UIImage imageNamed:@"WechatIMG27"];
            [self.helpLableView addSubview:self.googleMapView];
            [self.googleMapView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.helpLableView.mas_centerX);
                make.top.mas_equalTo(ScaleW(0));
                make.width.mas_equalTo(ScaleW(350));
                make.height.mas_equalTo(ScaleW(214));
            }];
                        
            
            
            UIColor *backgroundColor = ColorRGB(0xFFFFFF);
            UIColor *borderColor = ColorRGB(0xFFFFFF);
            UIColor *titleColor = [UIColor blackColor];
            UIColor *titleSelectColor = [UIColor whiteColor];
            UIColor *normalColor = ColorRGB(0xFFFFFF);
            UIColor *selectedColor = ColorRGB(0x004738);
            self.scontr = [MSSegmentedControl creatSegmentedControlWithTitle:@[@"所有",@"美食",@"商品",@"活動"] withRadius:10 withBtnRadius:10 withBackgroundColor:backgroundColor withBorderColor:borderColor withBorderWidth:0 withNormalTitleColor:titleColor withSelectedTitleColor:titleSelectColor withNormalBtnBackgroundColor:normalColor withSelectedBtnBackgroundColor:selectedColor controlid:101 Top:ScaleW(5) btheight:ScaleW(30) btwidth:ScaleW(60) btInterval:ScaleW(30)];
            _scontr.delegate = self;
            [self.helpLableView addSubview:_scontr];
            [_scontr mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(ScaleW(15));
                make.top.mas_equalTo(self.googleMapView.mas_bottom).offset(ScaleW(30));
                make.width.mas_equalTo(ScaleW(335));
                make.height.mas_equalTo(40);
            }];
            
        }
    }
    return self;
}

#pragma mark - CustomSegmentedControlDelegate
- (void)didSelectSegmentWithIndex:(NSInteger)index ControlTAG:(NSInteger)control_tag{
    
    if(self.block_catering)
        self.block_catering(index);
}

@end
