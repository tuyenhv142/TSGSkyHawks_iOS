//
//  GiftTBViewHeaderFooterView.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/4/28.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGSeatThirdRowCell.h"

@implementation EGSeatThirdRowCell

+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"EGSeatThirdRowCell";
    EGSeatThirdRowCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
          cell = [[EGSeatThirdRowCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class

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
                make.centerX.mas_equalTo(self.contentView.mas_centerX);
                make.centerY.mas_equalTo(self.contentView.mas_centerY);
                make.width.mas_equalTo(ScaleW(300));
                make.height.mas_equalTo(ScaleW(25));
            }];
            
            self.helpTitle = [UILabel new];
            self.helpTitle.textAlignment = NSTextAlignmentCenter;
            self.helpTitle.text = @"";
            self.helpTitle.textColor = UIColor.blackColor;
            self.helpTitle.font = [UIFont systemFontOfSize:FontSize(14)];
            [self.helpLableView addSubview:self.helpTitle];
            [self.helpTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.helpLableView.mas_centerY);
                make.centerX.mas_equalTo(self.helpLableView.mas_centerX);
                make.width.mas_equalTo(ScaleW(28));
                make.height.mas_equalTo(ScaleW(25));
            }];
            
            
            self.singal_Title = [UILabel new];
            self.singal_Title.textAlignment = NSTextAlignmentCenter;
            self.singal_Title.text = @"";
            self.singal_Title.textColor = UIColor.blackColor;
            self.singal_Title.font = [UIFont systemFontOfSize:FontSize(14)];
            [self.helpLableView addSubview:self.singal_Title];
            [self.singal_Title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.helpLableView.mas_centerY);
                make.centerX.mas_equalTo(self.helpLableView.mas_centerX).offset(ScaleW(60));
                make.width.mas_equalTo(ScaleW(28));
                make.height.mas_equalTo(ScaleW(25));
            }];
            
            
            self.count_Title  = [UILabel new];
            self.count_Title.textAlignment = NSTextAlignmentCenter;
            self.count_Title.text = @"";
            self.count_Title.textColor = UIColor.blackColor;
            self.count_Title.font = [UIFont systemFontOfSize:FontSize(14)];
            [self.helpLableView addSubview:self.count_Title];
            [self.count_Title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.helpLableView.mas_centerY);
                make.left.mas_equalTo(ScaleW(5));
                make.width.mas_equalTo(ScaleW(50));
                make.height.mas_equalTo(ScaleW(25));
            }];
            
            self.halfticks_Title  = [UILabel new];
            self.halfticks_Title.textAlignment = NSTextAlignmentCenter;
            self.halfticks_Title.text = @"半票";
            self.halfticks_Title.textColor = UIColor.blackColor;
            self.halfticks_Title.font = [UIFont systemFontOfSize:FontSize(14)];
            [self.helpLableView addSubview:self.halfticks_Title];
            [self.halfticks_Title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.helpLableView.mas_centerY);
                make.left.mas_equalTo(self.helpTitle.mas_right).offset(ScaleW(100));
                make.width.mas_equalTo(ScaleW(28));
                make.height.mas_equalTo(ScaleW(25));
            }];
            
            
            UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 1)];
            line.backgroundColor = ColorRGB(0xE5E5E5);
            [self.contentView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(ScaleW(0));
                make.height.mas_equalTo(ScaleW(1));
                make.right.mas_equalTo(0);
            }];
            self.line_Title = line;
            
        }
    }
    return self;
}

-(void)updaeUI:(NSDictionary*)dic
{
    NSDictionary *holidaydic = [dic objectForKey:@"row_content_holiday"];
    NSDictionary *normaldic = [dic objectForKey:@"row_content_normal"];
    
    BOOL is_singalLine = NO;
    NSRange range = [[dic objectForKey:@"row_title"] rangeOfString:@"熱區"];
    if (range.location != NSNotFound) {
        is_singalLine = YES;
    }
    
    range = [[dic objectForKey:@"row_title"] rangeOfString:@"外野"];
    if (range.location != NSNotFound) {
        is_singalLine = YES;
    }
    
    self.helpTitle.hidden = YES;
    self.singal_Title.hidden = YES;
    self.halfticks_Title.hidden = YES;
    self.line_Title.hidden = YES;
    
    if(self.from_type ==3)
    {
        self.helpTitle.text = [NSString stringWithFormat:@"%d",[[holidaydic objectForKey:@"row_content_holidayPrice"] intValue]];
        self.singal_Title.text = [NSString stringWithFormat:@"%d",[[holidaydic objectForKey:@"row_content_holidayPrice"] intValue]];
        self.halfticks_Title.text = [NSString stringWithFormat:@"%d",[[holidaydic objectForKey:@"row_content_holidayhalfPrice"] intValue]];
        self.count_Title.text = @"例假日";
        
        if(is_singalLine)
        {
            self.singal_Title.hidden = NO;
        }
        else
        {
            self.halfticks_Title.hidden = NO;
            self.helpTitle.hidden = NO;
        }
    }
    else
    {
        self.line_Title.hidden = NO;
        self.helpTitle.text = [NSString stringWithFormat:@"%d",[[normaldic objectForKey:@"row_content_normalPrice"] intValue]];
        self.singal_Title.text = [NSString stringWithFormat:@"%d",[[normaldic objectForKey:@"row_content_normalPrice"] intValue]];
        self.halfticks_Title.text = [NSString stringWithFormat:@"%d",[[normaldic objectForKey:@"row_content_normalhalfPrice"] intValue]];
        self.count_Title.text = @"平日";
        
        if(is_singalLine)
        {
            self.singal_Title.hidden = NO;
        }
        else
        {
            self.halfticks_Title.hidden = NO;
            self.helpTitle.hidden = NO;
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
