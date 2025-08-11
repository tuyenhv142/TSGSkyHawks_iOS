//
//  GiftTBViewHeaderFooterView.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/4/28.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGSeatSecondRowCell.h"

@implementation EGSeatSecondRowCell

+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"EGSeatSecondRowCell";
    EGSeatSecondRowCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
          cell = [[EGSeatSecondRowCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//cell选中无色

    return cell;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        {
            self.contentView.backgroundColor = ColorRGB(0x404040);
            
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
            self.helpTitle.text = @"熱區";
            self.helpTitle.textColor = UIColor.whiteColor;
            self.helpTitle.font = [UIFont systemFontOfSize:FontSize(14)];
            [self.helpLableView addSubview:self.helpTitle];
            [self.helpTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.helpLableView.mas_centerY);
                make.centerX.mas_equalTo(self.helpLableView.mas_centerX);
                make.width.mas_equalTo(ScaleW(80));
                make.height.mas_equalTo(ScaleW(25));
            }];
            
            
            self.city_Title  = [UILabel new];
            self.city_Title.textAlignment = NSTextAlignmentCenter;
            self.city_Title.text = @"";
            self.city_Title.textColor = UIColor.whiteColor;
            self.city_Title.font = [UIFont systemFontOfSize:FontSize(14)];
            [self.helpLableView addSubview:self.city_Title];
            [self.city_Title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.helpLableView.mas_centerY);
                make.left.mas_equalTo(ScaleW(5));
                make.width.mas_equalTo(ScaleW(50));
                make.height.mas_equalTo(ScaleW(25));
            }];
            
            self.allticks_Title  = [UILabel new];
            self.allticks_Title.textAlignment = NSTextAlignmentCenter;
            self.allticks_Title.text = @"全票";
            self.allticks_Title.textColor = UIColor.whiteColor;
            self.allticks_Title.font = [UIFont systemFontOfSize:FontSize(14)];
            [self.helpLableView addSubview:self.allticks_Title];
            [self.allticks_Title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.helpLableView.mas_centerY);
                make.left.mas_equalTo(self.city_Title.mas_right).offset(ScaleW(80));
                make.width.mas_equalTo(ScaleW(28));
                make.height.mas_equalTo(ScaleW(25));
            }];
            
            
            self.halfticks_Title  = [UILabel new];
            self.halfticks_Title.textAlignment = NSTextAlignmentCenter;
            self.halfticks_Title.text = @"半票";
            self.halfticks_Title.textColor = UIColor.whiteColor;
            self.halfticks_Title.font = [UIFont systemFontOfSize:FontSize(14)];
            [self.helpLableView addSubview:self.halfticks_Title];
            [self.halfticks_Title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.helpLableView.mas_centerY);
                make.left.mas_equalTo(self.allticks_Title.mas_right).offset(ScaleW(100));
                make.width.mas_equalTo(ScaleW(28));
                make.height.mas_equalTo(ScaleW(25));
            }];
            
            UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 1)];
            line.backgroundColor = UIColor.whiteColor;
            [self.contentView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(ScaleW(0));
                make.height.mas_equalTo(ScaleW(1));
                //make.width.mas_equalTo(self.contentView.frame.size.width);
                make.right.mas_equalTo(0);
            }];
            self.line_Title = line;
            
        }
    }
    return self;
}

-(void)updaeUI:(NSDictionary*)dic
{
    _city_Title.text = [dic objectForKey:@"row_content_city"];
    _helpTitle.text = [dic objectForKey:@"row_content_header"];
    
    _helpTitle.hidden = YES; //热区
    _city_Title.hidden = YES;
    _allticks_Title.hidden = YES;
    _halfticks_Title.hidden = YES;
    self.line_Title.hidden = YES;
    
    if(self.from_type ==1)
    {
        _helpTitle.hidden = NO;
    }
    else
    {
        _city_Title.hidden = NO;
        _allticks_Title.hidden = NO;
        _halfticks_Title.hidden = NO;
        self.line_Title.hidden = NO;
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
