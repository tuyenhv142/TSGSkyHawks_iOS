//
//  GiftTBViewHeaderFooterView.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/4/28.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGParkTitleCell.h"

@implementation EGParkTitleCell

+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"EGParkTitleCell";
    EGParkTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
          cell = [[EGParkTitleCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//cell选中无色

    return cell;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        {
            self.contentView.backgroundColor = UIColor.whiteColor;
            
            self.parkTitle_View = [UIView new];
            [self.contentView addSubview:self.parkTitle_View];
            [self.parkTitle_View mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(ScaleW(5));
                make.centerY.mas_equalTo(self.contentView.mas_centerY);
                make.width.mas_equalTo(ScaleW(330));
                make.height.mas_equalTo(ScaleW(25));
            }];
            
            _park_title = [UILabel new];//Title
            self.park_title.textAlignment = NSTextAlignmentLeft;
            self.park_title.text = @"";
            self.park_title.numberOfLines = 0;
            self.park_title.textColor = rgba(0, 122, 96, 1);
            self.park_title.font = [UIFont boldSystemFontOfSize:FontSize(16)];
            [self.parkTitle_View addSubview:self.park_title];
            [self.park_title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.parkTitle_View.mas_centerY);
                make.left.mas_equalTo(ScaleW(5));
                make.width.mas_equalTo(ScaleW(310));
                make.height.mas_equalTo(ScaleW(25));
            }];
            
            
            
            _park_count = [UILabel new];;//停车数量
            self.park_count.textAlignment = NSTextAlignmentCenter;
            self.park_count.text = @"";
            self.park_count.textColor = UIColor.blackColor;
            self.park_count.layer.cornerRadius = ScaleW(25) / 2;
            self.park_count.layer.masksToBounds = YES;
            self.park_count.backgroundColor = ColorRGB(0xF5F5F5);
            self.park_count.font = [UIFont boldSystemFontOfSize:FontSize(14)];
            [self.parkTitle_View addSubview:self.park_count];
            [self.park_count mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.parkTitle_View.mas_centerY);
                make.right.mas_equalTo(0);
                make.width.mas_equalTo(ScaleW(80));
                make.height.mas_equalTo(ScaleW(25));
            }];
        }
    }
    return self;
}

-(void)updaeUI:(NSDictionary*)info
{
    /*NSInteger staus = [[info objectForKey:@"row_park_status"] intValue];
    switch (staus) {
        case 0:
            _park_count.text = @"尚有車位";
            _park_count.textColor = ColorRGB(0x007A60);
            break;
                                
        case 1:
            _park_count.text = @"即將停滿";
            _park_count.textColor = ColorRGB(0xD9AE35);
                break;
                                
        case 2:
            _park_count.text = @"依現場為準";
            _park_count.textColor = ColorRGB(0x525252);
                break;
                                
        case 3:
            _park_count.text = @"車位已滿";
            _park_count.textColor = ColorRGB(0xD62400);
                break;
            }
    */
    
    
    _park_count.text = @"依現場為準";
    _park_count.textColor = ColorRGB(0x525252);
    self.park_title.text = [info objectForKey:@"row_content"];
}

@end
