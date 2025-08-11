//
//  GiftTBViewHeaderFooterView.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/4/28.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGParkContentCell.h"

@implementation EGParkContentCell

+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"EGParkContentCell";
    EGParkContentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
          cell = [[EGParkContentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class

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
            self.park_title.textColor = ColorRGB(0x737373);
            self.park_title.font = [UIFont systemFontOfSize:FontSize(14)];
            [self.parkTitle_View addSubview:self.park_title];
            [self.park_title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.parkTitle_View.mas_centerY);
                make.left.mas_equalTo(ScaleW(5));
                make.width.mas_equalTo(ScaleW(330));
                make.height.mas_equalTo(ScaleW(25));
            }];
        }
    }
    return self;
}

-(void)updaeUI:(NSDictionary*)info status:(BOOL)is_click
{
    self.park_title.text = [info objectForKey:@"row_content"];
    NSString* height = [info objectForKey:@"row_height"];
    if(is_click){
        [self.park_title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.parkTitle_View.mas_centerY);
            make.left.mas_equalTo(ScaleW(5));
            make.width.mas_equalTo(ScaleW(330));
            make.height.mas_equalTo(ScaleW(height.intValue));
        }];
    }
    else
        [self.park_title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.parkTitle_View.mas_centerY);
            make.left.mas_equalTo(ScaleW(5));
            make.width.mas_equalTo(ScaleW(330));
            make.height.mas_equalTo(ScaleW(20));
        }];
}

@end
