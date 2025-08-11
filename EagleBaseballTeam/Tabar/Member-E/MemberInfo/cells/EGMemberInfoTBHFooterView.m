//
//  EGMemberInfoTBHFooterView.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/17.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGMemberInfoTBHFooterView.h"

@implementation EGMemberInfoTBHFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(instancetype)headerViewWithTableView:(UITableView*)tableView
{
    
    static NSString *headerID = @"EGMemberInfoTBHFooterView";
    
    EGMemberInfoTBHFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    
    if(headerView == nil){
        headerView = [[EGMemberInfoTBHFooterView alloc] initWithReuseIdentifier:headerID];
    }
    
    return headerView;
}


        

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
    
        self.titleLabel.text = @"header";
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = rgba(23, 23, 23, 1);
        self.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ScaleW(24));
            make.centerY.mas_equalTo(0);
        }];
     
    }
    return self;
}
@end
