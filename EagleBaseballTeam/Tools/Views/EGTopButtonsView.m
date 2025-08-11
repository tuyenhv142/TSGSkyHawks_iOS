//
//  EGTopButtonsView.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/4/18.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGTopButtonsView.h"

#import "LXYHyperlinksButton.h"

@interface EGTopButtonsView ()
@property (nonatomic,strong) UIView *bustatuslable;

@property (nonatomic,strong) NSMutableArray *buttons;



@end

@implementation EGTopButtonsView

- (NSMutableArray *)buttons
{
    if (!_buttons) {
        _buttons = [NSMutableArray arrayWithCapacity:0];
    }
    return _buttons;
}
- (UIView *)redView_acivity
{
    if (!_redView_acivity) {
        _redView_acivity = [UIView new];
        _redView_acivity.backgroundColor = UIColor.redColor;
        _redView_acivity.layer.cornerRadius = ScaleW(3);
        _redView_acivity.layer.masksToBounds = true;
    }
    return _redView_acivity;
}
- (UIView *)redView_system
{
    if (!_redView_system) {
        _redView_system = [UIView new];
        _redView_system.backgroundColor = UIColor.redColor;
        _redView_system.layer.cornerRadius = ScaleW(3);
        _redView_system.layer.masksToBounds = true;
    }
    return _redView_system;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)setupUIForArray:(NSArray *)array
{
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = rgba(212, 212, 212, 1);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(0);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(1.5);
    }];
    
    
    CGFloat bwidth = Device_Width / array.count;
    
    for (int i = 0; i < array.count; i++) {
        
        LXYHyperlinksButton *bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(0, 0, 100, 36)];
        bt.tag = 18 + i;
        [bt setTitle:array[i] forState:UIControlStateNormal];
        bt.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
        [bt setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateSelected];
        [bt setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
        [bt setSelected:YES];
        [bt addTarget:self action:@selector(buttonclick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:bt];
        [bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
        [bt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bwidth * i);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(bwidth);
            make.height.mas_equalTo(ScaleW(50));
        }];
        [self.buttons addObject:bt];
    }
    
    // 滑块指示器
    self.bustatuslable = [[UIView alloc] init];
    self.bustatuslable.backgroundColor = rgba(0, 122, 96, 1); //rgba(0, 122, 96, 1)
    [self addSubview:self.bustatuslable];
    [self.bustatuslable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.width.mas_equalTo(bwidth);
        make.height.mas_equalTo(ScaleW(4));
        make.left.equalTo(self);
    }];
    
    
    [self addSubview:self.redView_acivity];
    [self.redView_acivity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(12));
        make.width.mas_equalTo(ScaleW(6));
        make.height.mas_equalTo(ScaleW(6));
        make.left.mas_equalTo(ScaleW(120));
    }];
    [self addSubview:self.redView_system];
    [self.redView_system mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(12));
        make.width.mas_equalTo(ScaleW(6));
        make.height.mas_equalTo(ScaleW(6));
        make.right.mas_equalTo(-ScaleW(60));
    }];
    self.redView_acivity.hidden = true;
    self.redView_system.hidden = true;
}

-(void)buttonclick:(UIButton*)bt
{
    for (UIButton *btn in self.buttons) {
        if ([bt isEqual:btn]) {
            btn.selected = true;
        }else{
            btn.selected = false;
        }
    }
    NSInteger index = bt.tag - 18;
    [UIView animateWithDuration:0.3 animations:^{
        self.bustatuslable.transform = CGAffineTransformMakeTranslation(index * (UIScreen.mainScreen.bounds.size.width / 2), 0);
    }];
    if (self.clickBtnBlock) {
        self.clickBtnBlock(index);
    }
}
-(void)setStatusLableForIndex:(NSInteger)index
{
    if (index >= self.buttons.count) {
        return;
    }
    
    for (UIButton *btn in self.buttons) {
        if (btn.tag == index+18) {
            btn.selected = true;
        }else{
            btn.selected = false;
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.bustatuslable.transform = CGAffineTransformMakeTranslation(index * (UIScreen.mainScreen.bounds.size.width / 2), 0);
    }];
    
}


-(void)setRedViewStatueActivity:(BOOL )activity systemView:(BOOL )system
{
    self.redView_acivity.hidden = activity;
    self.redView_system.hidden = system;
}
@end
