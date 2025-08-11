//
//  EGAlertViewHelper.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/3/7.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGAlertViewHelper.h"

@interface EGAlertViewHelper ()

@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *message;

@end

@implementation EGAlertViewHelper

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.layer.cornerRadius = ScaleW(6);
        _bgView.layer.masksToBounds = true;
    }
    return _bgView;
}
- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [UIImageView new];
        _imgView.image = [UIImage imageNamed:@"exclamation-triangle"];
    }
    return _imgView;
}
- (UILabel *)message
{
    if (!_message) {
        _message = [UILabel new];
        _message.textColor = UIColor.whiteColor;
        _message.font = [UIFont systemFontOfSize:FontSize(14)];
    }
    return _message;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark ---
+ (EGAlertViewHelper *)sharedManager
{
    static EGAlertViewHelper *handle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handle = [[self alloc] init];
    });
    return handle;
}

-(void)alertViewColor:(NSInteger )type message:(NSString *)title
{
    UIColor *bgColor;
    if (type == 2) {
        bgColor = rgba(217, 174, 53, 1);//黄色
    }else{
        bgColor = rgba(220, 38, 38, 1);//红色
    }
    self.bgView.backgroundColor = bgColor;
    self.bgView.frame = CGRectMake(0, 0, Device_Width - ScaleW(40), ScaleW(52));
    self.bgView.center = CGPointMake(Device_Width/2.0, Device_Height-ScaleW(80));
    
    self.imgView.frame = CGRectMake(ScaleW(16), ScaleW(16), ScaleW(20), ScaleW(20));
    [self.bgView addSubview:self.imgView];
    
    self.message.frame = CGRectMake(ScaleW(48), ScaleW(16), ScaleW(270), ScaleW(20));
    self.message.text = title;
    [self.bgView addSubview:self.message];
    
    NSSet *set = [UIApplication sharedApplication].connectedScenes;
    UIWindowScene *windowScene = [set anyObject];
    UIWindow *keyWindow = windowScene.windows.firstObject;
    
    [keyWindow addSubview:self.bgView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.bgView removeFromSuperview];
    });
}
@end
