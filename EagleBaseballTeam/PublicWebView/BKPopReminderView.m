//
//  BKPopReminderView.m
//  BurgerKing
//
//  Created by elvin on 2025/5/6.
//

#import "BKPopReminderView.h"

@interface BKPopReminderView ()

@property (nonatomic,strong) UIView *baseView;
@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,assign) CGFloat viewHeight;
@end

@implementation BKPopReminderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)showPopView
{
    UIWindowScene *windowScene = (UIWindowScene *)[UIApplication sharedApplication].connectedScenes.anyObject;
    UIWindow *window = [windowScene.windows firstObject];
    [window addSubview:self];
}

- (instancetype)initWithTitle:(NSString *)message buttons:(NSArray *)array
{
    CGRect frame = CGRectMake(0, 0, Device_Width, Device_Height);
    self = [super initWithFrame:frame];
    if (self) {
            
        [self createUITitle:message btns:array];
        
        self.titleLabel.text = message;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}
-(void)createUITitle:(NSString *)message btns:(NSArray *)array
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    
    self.baseView = [[UIView alloc] init];
    self.baseView.backgroundColor = ColorRGB(0xFFFFFF);
    self.baseView.layer.cornerRadius = ScaleW(12);
    self.baseView.layer.masksToBounds = true;
    [self addSubview:self.baseView];
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        if (array.count == 1) {
            make.height.mas_equalTo(ScaleH(186));
        }else{
            make.height.mas_equalTo(ScaleH(206));
        }
        make.width.mas_equalTo(ScaleW(316));
    }];
    
    UIImageView *arrowIMGView = [UIImageView new];
    arrowIMGView.contentMode = UIViewContentModeScaleAspectFit;
    arrowIMGView.image = [UIImage imageNamed:@"success"];
    [self.baseView addSubview:arrowIMGView];
    [arrowIMGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(16));
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(ScaleW(48));
        make.width.mas_equalTo(ScaleW(48));
    }];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = rgba(23, 23, 23, 1);
    self.titleLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightRegular];
    self.titleLabel.backgroundColor = [UIColor whiteColor];
    [self.baseView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(ScaleW(20));
        make.right.mas_equalTo(-ScaleW(20));
    }];
    
    for (int i = 0; i < array.count; i++ ) {
        
        UIButton *sureBtn = [[UIButton alloc] init];
        sureBtn.layer.cornerRadius = ScaleW(8);
        sureBtn.layer.masksToBounds = true;
        sureBtn.layer.borderWidth = 1;
        sureBtn.layer.borderColor = rgba(0, 122, 96, 1).CGColor;
        sureBtn.tag = i;
        [sureBtn setTitle:array[i] forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(sureButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.baseView addSubview:sureBtn];
        
        if (array.count == 1) {
            
            sureBtn.backgroundColor = rgba(0, 122, 96, 1);
            [sureBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(ScaleW(40));
                make.width.mas_equalTo(ScaleW(276));
                make.centerX.mas_equalTo(0);
                make.bottom.mas_equalTo(-ScaleW(16));
            }];
            
        }else{
            
            if (i == 0) {
                sureBtn.backgroundColor = UIColor.whiteColor;
                [sureBtn setTitleColor:rgba(0, 122, 96, 1) forState:UIControlStateNormal];
                [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(ScaleW(40));
                    make.right.equalTo(self.baseView.mas_centerX).offset(-ScaleW(10));
                    make.left.mas_equalTo(ScaleW(16));
                    make.bottom.mas_equalTo(-ScaleW(16));
                }];
            }else{
                sureBtn.backgroundColor = rgba(0, 122, 96, 1);
                [sureBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
                [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(ScaleW(40));
                    make.left.equalTo(self.baseView.mas_centerX).offset(ScaleW(10));
                    make.right.mas_equalTo(-ScaleW(16));
                    make.bottom.mas_equalTo(-ScaleW(16));
                }];
            }
        }
    }
}
-(void)sureButtonAction:(UIButton *)btn
{
    if (self.closeBlock) {
        self.closeBlock(btn.tag);
        [self removeFromSuperview];
    }
}

@end
