//
//  GiftTBViewHeaderFooterView.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/4/28.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGStadiumViewCell.h"

@implementation EGStadiumViewCell

+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"EGStadiumViewCell";
    EGStadiumViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
          cell = [[EGStadiumViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class

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
                make.width.mas_equalTo(ScaleW(335));
                make.height.mas_equalTo(ScaleW(70));
            }];
            
            
            self.helpTitle = [UILabel new];
            self.helpTitle.textAlignment = NSTextAlignmentLeft;
            self.helpTitle.text = @"";
            self.helpTitle.font = [UIFont boldSystemFontOfSize:FontSize(14)];
            [self.helpLableView addSubview:self.helpTitle];
            [self.helpTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(ScaleW(5));
                make.left.mas_equalTo(0);
                make.width.mas_equalTo(ScaleW(300));
            }];
            
            self.helpContent = [UILabel new];
            self.helpContent.textAlignment = NSTextAlignmentLeft;
            self.helpContent.text = @"";
            self.helpContent.numberOfLines=0;
            self.helpContent.font = [UIFont systemFontOfSize:FontSize(14)];
            [self.helpLableView addSubview:self.helpContent];
            [self.helpContent mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.helpTitle.mas_bottom).offset(ScaleW(10));
                make.left.mas_equalTo(ScaleW(15));
                make.width.mas_equalTo(ScaleW(300));
            }];
            
            
            
        }
    }
    return self;
}


-(void)updateUI:(NSDictionary*)info
{
    self.helpTitle.text = [info objectForKey:@"row_title"];
    self.helpContent.text = [info objectForKey:@"row_content"];
}


-(void)clickArrowBtn:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (self.showOrHiddenBlcok) {
        self.showOrHiddenBlcok(btn.selected);
    }
}
@end
