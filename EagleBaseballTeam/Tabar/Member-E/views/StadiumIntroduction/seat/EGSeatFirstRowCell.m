//
//  GiftTBViewHeaderFooterView.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/4/28.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGSeatFirstRowCell.h"

@implementation EGSeatFirstRowCell

+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"EGSeatFirstRowCell";
    EGSeatFirstRowCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
          cell = [[EGSeatFirstRowCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//cell选中无色

    return cell;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        {
            self.contentView.backgroundColor = UIColor.whiteColor;
            
            self.helpLableView = [UIView new];
            [self.contentView addSubview:self.helpLableView];
            [self.helpLableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(ScaleW(0));
                make.centerY.mas_equalTo(self.contentView.mas_centerY);
                make.width.mas_equalTo(ScaleW(300));
                make.height.mas_equalTo(ScaleW(25));
            }];
            
            self.googleMapView = [UIImageView new];
            self.googleMapView.backgroundColor = UIColor.redColor;
            [self.helpLableView addSubview:self.googleMapView];
            [self.googleMapView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.helpLableView.mas_left).offset(ScaleW(10));
                make.centerY.mas_equalTo(self.helpLableView.mas_centerY);
                make.width.mas_equalTo(ScaleW(20));
                make.height.mas_equalTo(ScaleW(20));
            }];
            
            self.helpTitle = [UILabel new];
            self.helpTitle.textAlignment = NSTextAlignmentLeft;
            self.helpTitle.text = @"";
            self.helpTitle.font = [UIFont systemFontOfSize:FontSize(14)];
            [self.helpLableView addSubview:self.helpTitle];
            [self.helpTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.googleMapView.mas_right).offset(ScaleW(10));
                make.centerY.mas_equalTo(self.helpLableView.mas_centerY);
                make.width.mas_equalTo(ScaleW(300));
                make.height.mas_equalTo(ScaleW(28));
            }];
            
           
            
            
        }
    }
    return self;
}

-(void)updateUI:(NSDictionary*)info row:(NSInteger)row_index type:(NSInteger)changditype
{
    
    self.helpTitle.text = [info objectForKey:@"row_title"];
    
    if(changditype==101)
    {
        switch (row_index) {
            case 0:
                self.googleMapView.backgroundColor = ColorRGB(0xD9AE35);
                break;
                
            case 1:
                self.googleMapView.backgroundColor = ColorRGB(0x004636);
                break;
            case 2:
                self.googleMapView.backgroundColor = ColorRGB(0x216A59);
                break;
            case 3:
                self.googleMapView.backgroundColor = ColorRGB(0x8AB395);
                break;
            case 4:
                self.googleMapView.backgroundColor = ColorRGB(0x956034);
                break;
        }
    }
    else
    {
        switch (row_index) {
            case 0:
                self.googleMapView.backgroundColor = ColorRGB(0x004636);
                break;
                
            case 1:
                self.googleMapView.backgroundColor = ColorRGB(0x8AB395);
                break;
        }
    }
}

-(void)clickArrowBtn:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (self.showOrHiddenBlcok) {
        self.showOrHiddenBlcok(btn.selected);
    }
}
@end
