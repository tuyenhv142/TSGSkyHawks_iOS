//
//  EGMemberActivitiesCell.m
//  EagleBaseballTeam
//
//  Created by rick on 1/24/25.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGMemberActivitiesCell.h"
#import "EGVerticalButton.h"

@interface EGMemberActivitiesCell()

@property (nonatomic, weak) UIButton *btnLeft;
@property (nonatomic, weak) UIButton *btnRight;

@end

@implementation EGMemberActivitiesCell
+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"EGMemberActivitiesCell";
    EGMemberActivitiesCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
          cell = [[EGMemberActivitiesCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//cell选中无色

    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithRed:0.962 green:0.962 blue:0.962 alpha:1.0];
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeSystem];
    btnLeft.backgroundColor = [UIColor whiteColor];
    btnLeft.layer.cornerRadius = ScaleW(8);
    btnLeft.clipsToBounds = YES;
    [btnLeft setTitle:NSLocalizedString(@"歡呼模式", @"")  forState:UIControlStateNormal];
    [btnLeft setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateNormal];
    [btnLeft.titleLabel setFont:[UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightMedium]];
    [btnLeft addTarget:self action:@selector(goAroundAction) forControlEvents:UIControlEventTouchUpInside];

    
    [btnLeft setImage:[[UIImage imageNamed:@"mascot1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//    [btnLeft setContentMode:UIViewContentModeScaleAspectFill];
    [btnLeft.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    btnLeft.titleLabel.textAlignment = NSTextAlignmentLeft;
    btnLeft.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btnLeft.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    btnLeft.titleEdgeInsets = UIEdgeInsetsMake(ScaleW(16), -ScaleW(158)+ScaleW(16), 0, 0); // 调整文字位置使其在图片下方
    btnLeft.imageEdgeInsets = UIEdgeInsetsMake(ScaleW(55), 0, 0, 0);
    [self.contentView addSubview:btnLeft];
    
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeSystem];
    btnRight.backgroundColor = [UIColor whiteColor];
    btnRight.layer.cornerRadius = ScaleW(8);
    btnRight.clipsToBounds = YES;
    [btnRight setTitle:NSLocalizedString(@"現場活動", @"")  forState:UIControlStateNormal];
    [btnRight setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateNormal];
    [btnRight.titleLabel setFont:[UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightMedium]];
    
    [btnRight setFrame:CGRectMake(0, 0, ScaleW(158), ScaleW(168))];

    [btnRight setImage:[[UIImage imageNamed:@"mascot2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    [btnRight addTarget:self action:@selector(liveActivities) forControlEvents:UIControlEventTouchUpInside];
    [btnRight setContentMode:UIViewContentModeScaleAspectFit];
 
    btnRight.titleLabel.textAlignment = NSTextAlignmentLeft;
    btnRight.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btnRight.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    btnRight.titleEdgeInsets = UIEdgeInsetsMake(ScaleW(16), -ScaleW(158)+ScaleW(16), 0, 0); // 调整文字位置使其在图片下方
    btnRight.imageEdgeInsets = UIEdgeInsetsMake(ScaleW(48), 0, 0, 0); // 调整图片位置使其在文字上方
   
    [self.contentView addSubview:btnRight];

    self.btnLeft = btnLeft;
    self.btnRight = btnRight;
    
    [self.btnLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(20));
        make.left.mas_equalTo(ScaleW(0));
        make.width.mas_equalTo(ScaleW(158));
        make.height.mas_equalTo(ScaleW(168));
        make.bottom.mas_equalTo(-ScaleW(0));
        
    }];
    
    [self.btnRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(20));
        make.right.mas_equalTo(-ScaleW(0));
        make.width.mas_equalTo(ScaleW(158));
        make.height.mas_equalTo(ScaleW(168));
        make.bottom.mas_equalTo(-ScaleW(0));
    }];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)liveActivities{
    if(self.showliveActivities)
    {
        self.showliveActivities();
    }
}

#pragma mark 跑马灯功能
-(void)goAroundAction
{
    if(self.goAroundBtnBlock)
    {
        self.goAroundBtnBlock();
    }
        
}



@end
