//
//  EGTBVSectionHeaderFooterView.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/8.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGTBVSectionHeaderFooterView.h"
@interface EGTBVSectionHeaderFooterView()
@property (nonatomic,weak) UILabel * titleLB;
@property (nonatomic,strong) NSMutableArray *buttons;
@end

@implementation EGTBVSectionHeaderFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray arrayWithCapacity:0];
    }
    return _buttons;
}
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        self.contentView.backgroundColor = rgba(243, 243, 243, 1);
//        UILabel *titleLb = [UILabel new];
//        titleLb.text = @"限時任務";
//        titleLb.tag = 100;  // 添加标签值
//        titleLb.textColor = rgba(38, 38, 38, 1);
//        titleLb.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightMedium];
//        [self.contentView addSubview:titleLb];
//        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(0);
//            make.left.mas_equalTo(ScaleW(20));
//        }];
//        self.titleLB =  titleLb;
//        UIButton *moreBtn = [[UIButton alloc] init];
//        [moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
//        moreBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:(UIFontWeightMedium)];
//        [moreBtn setImage:[UIImage imageNamed:@"chevron-right"] forState:UIControlStateNormal];
//        [moreBtn setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
//        [moreBtn addTarget:self action:@selector(clickMoreBtn) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:moreBtn];
//        [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(0);
//            make.right.mas_equalTo(-ScaleW(20));
//            make.height.mas_equalTo(ScaleW(30));
//        }];
//        [moreBtn layoutButtonWithEdgeInsetsStyle:ZYButtonEdgeInsetsStyleRight imageTitleSpace:1];
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 3;
        [button setImage:[UIImage imageNamed:@"sort"] forState:UIControlStateNormal];
        button.userInteractionEnabled = true;
        [button addTarget:self action:@selector(typeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleW(73));
            make.right.mas_equalTo(-ScaleW(20));
            make.size.mas_equalTo(ScaleW(25));
        }];
        
        UILabel *titleLb = [UILabel new];
        titleLb.text = @"點數任務";
        titleLb.textColor = rgba(38, 38, 38, 1);
        titleLb.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightMedium];
        [self.contentView addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleW(30));
            make.left.mas_equalTo(ScaleW(20));
            make.height.mas_equalTo(ScaleW(24));
        }];
        NSArray *titles = @[@"限時",@"每日",@"會員專屬"];
        for (int i = 0; i < titles.count; i++ ) {
            UIButton *typeBtn = [[UIButton alloc] init];
            typeBtn.tag = i;
            typeBtn.layer.borderColor = rgba(212, 212, 212, 1).CGColor;
            typeBtn.layer.borderWidth = 1;
            typeBtn.layer.cornerRadius = ScaleW(19);
            typeBtn.layer.masksToBounds = true;
            [typeBtn setTitle:titles[i] forState:UIControlStateNormal];
            [typeBtn setImage:[UIImage imageWithColor:rgba(212, 212, 212, 1)] forState:UIControlStateNormal];
            [typeBtn setImage:[UIImage imageWithColor:rgba(0, 78, 162, 1)] forState:UIControlStateSelected];
            [typeBtn setTitleColor:rgba(0, 0, 0, 1) forState:UIControlStateNormal];
            [typeBtn setTitleColor:rgba(255, 255, 255, 1) forState:UIControlStateSelected];
            [typeBtn addTarget:self action:@selector(typeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:typeBtn];
            [typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(ScaleW(70));
                make.height.mas_equalTo(ScaleW(38));
                if (i == 0) {
                    make.left.mas_equalTo(ScaleW(20));
                    make.width.mas_equalTo(ScaleW(64));
                    typeBtn.selected = YES;
                    typeBtn.backgroundColor = rgba(0, 78, 162, 1);
                }else if (i == 1){
                    make.left.mas_equalTo(ScaleW(104));
                    make.width.mas_equalTo(ScaleW(64));
                    typeBtn.selected = NO;
                }else{
                    make.left.mas_equalTo(ScaleW(188));
                    make.width.mas_equalTo(ScaleW(106));
                    typeBtn.selected = NO;
                }
            }];
            typeBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -20);
            [self.buttons addObject:typeBtn];
        }
        
        
    }
    return self;
}

-(void)clickMoreBtn{
    if (self.moreBtnClickBlock) {
        self.moreBtnClickBlock(self.section);
    }
}

-(void)setTitleInfo:(NSString *)title{
    self.titleLB.text = title;
}

//20250427
-(void)typeButtonAction:(UIButton *)sender
{
    if (sender.tag != 3) {
        for (UIButton *btn in self.buttons) {
            if ([btn isEqual:sender]) {
                btn.selected = true;
                btn.backgroundColor = rgba(0, 121, 192, 1);
            }else{
                btn.selected = false;
                btn.backgroundColor = rgba(243, 243, 243, 1);
            }
        }
    }
    
    if (self.moreBtnClickBlock) {
        self.moreBtnClickBlock(sender.tag);
    }
}
@end
