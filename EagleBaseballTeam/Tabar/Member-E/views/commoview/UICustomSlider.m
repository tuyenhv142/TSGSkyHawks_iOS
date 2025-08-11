//
//  UICustomSlider.m
//  music
//
//  Created by Dragon_Zheng on 3/10/25.
//

#import <Foundation/Foundation.h>
#import "UICustomSlider.h"
#import "HLProgressView.h"

@interface UICustomSlider ()
@property (nonatomic, strong) HLProgressView *progressView;
@end

@implementation UICustomSlider

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:212.0/255.0 green:212.0/255.0 blue:212.0/255.0 alpha:1.0];
        self.clipsToBounds = YES; //不显示超过父视图的内容
        self.layer.cornerRadius = 8;
        self.progressView = [[HLProgressView alloc] initWithFrame:CGRectMake(0, 0, 140, 20)];
        [self addSubview:self.progressView];
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleW(0));
            make.left.mas_equalTo(0);
            //make.centerX.mas_equalTo(self.mas_centerX);
            make.width.mas_equalTo(ScaleW(0));
            make.height.mas_equalTo(ScaleW(20));
        }];
        
    }
    return self;
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    CGPoint point = [touches.anyObject locationInView:self];
//    self.progressView.viewSize = CGSizeMake(point.x, self.bounds.size.height);
//}
//
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    CGPoint point = [touches.anyObject locationInView:self];
//    self.progressView.viewSize = CGSizeMake(point.x, self.bounds.size.height);
//}
//
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    CGPoint point = [touches.anyObject locationInView:self];
//    self.progressView.viewSize = CGSizeMake(point.x, self.bounds.size.height);
//}

-(void)setPercentfor:(CGFloat)rate
{
    CGFloat x = rate * self.bounds.size.width;
    self.progressView.viewSize = CGSizeMake(x, self.bounds.size.height);
    
    [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(0));
        //make.centerX.mas_equalTo(self.mas_centerX);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(x);
        make.height.mas_equalTo(ScaleW(20));
    }];
}

-(void)setStatus:(BOOL)is_enable  Rate:(CGFloat)rete
{
    if(is_enable)
       self.progressView.enableColor = YES;
    else
        self.progressView.enableColor = NO;
    
    [self setPercentfor:rete];
}

@end
