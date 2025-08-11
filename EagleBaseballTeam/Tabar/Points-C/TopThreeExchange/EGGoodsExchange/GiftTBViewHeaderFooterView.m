//
//  GiftTBViewHeaderFooterView.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/4/28.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "GiftTBViewHeaderFooterView.h"

@implementation GiftTBViewHeaderFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(instancetype)cellHeaderWithUITableView:(UITableView *)tableView{
    
    NSString *headerIndentifer = @"GiftTBViewHeaderFooterView";
    GiftTBViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIndentifer];
    if (!headerView) {
        headerView = [[GiftTBViewHeaderFooterView alloc] initWithReuseIdentifier:headerIndentifer];
    }
    return headerView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        self.contentView.backgroundColor = UIColor.whiteColor;
        
        UILabel *titleLb = [UILabel new];
        titleLb.text = @"兌換地點";
        titleLb.textColor = rgba(115, 115, 115, 1);
        titleLb.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
        [self.contentView addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(ScaleW(20));
        }];
        self.titleLb = titleLb;
        UIButton *moreBtn = [[UIButton alloc] init];
        [moreBtn setImage:[UIImage imageNamed:@"chevron-down"] forState:UIControlStateNormal];
        [moreBtn setImage:[UIImage imageNamed:@"chevron-up"] forState:UIControlStateSelected];
        [moreBtn addTarget:self action:@selector(clickArrowBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:moreBtn];
        [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-ScaleW(20));
            make.height.mas_equalTo(ScaleW(30));
        }];
        [moreBtn layoutButtonWithEdgeInsetsStyle:ZYButtonEdgeInsetsStyleRight imageTitleSpace:1];
        moreBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-20, -20, -20, -20);
        self.arrowBtn = moreBtn;
    }
    return self;
}
-(void)clickArrowBtn:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (self.showOrHiddenBlcok) {
        self.showOrHiddenBlcok(btn.selected);
    }
}
@end
