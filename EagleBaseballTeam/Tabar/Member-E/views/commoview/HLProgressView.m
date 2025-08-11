//
//  HLProgressView.m
//  music
//
//  Created by Dragon_Zheng on 3/7/25.
//

#import <Foundation/Foundation.h>
#import "HLProgressView.h"
@implementation HLProgressView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setViewSize:(CGSize)viewSize {
    _viewSize = viewSize;
    self.frame = CGRectMake(0, 0, viewSize.width, viewSize.height);
    // setNeedsDisplay会自动调用drawRect方法
    [self setNeedsDisplay];
}
    
- (void)drawRect:(CGRect)rect {
    CGSize size = self.bounds.size;
    // 获取图形上下文对象CGContextRef
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 创建一个颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // 设置的颜色 每四个元素表示一种颜色，值的范围0~1，分别表示R、G、B、透明度
    
    if(self.enableColor){
        CGFloat colors[] = {
            217/255.0, 174/255.0, 53/255.0, 1.0,
            217/255.0, 174/255.0, 53/255.0, 1.0
        };
        
        // 渐变的位置信息范围0~1 0表示开始的位置 1表示结束的位置
        CGFloat gradientLocations[] = {0, 0};
        // 渐变的个数
        size_t locationCount = 2;
        // 创建渐变
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, gradientLocations, locationCount);
        // 指定渐变的开始位置和结束位置 这里设置完效果是整块区域的水平方向的渐变
        CGPoint gradientStartPoint = CGPointMake(0, size.height/2);
        CGPoint gradientEndPoint = CGPointMake(size.width, size.height/2);
        // 将渐变画到上下文中，最后一个参数表示发散的方式
        CGContextDrawLinearGradient(context, gradient, gradientStartPoint, gradientEndPoint, kCGGradientDrawsBeforeStartLocation);
        // 释放内存
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
        
    }else
    {
        CGFloat colors[] = {
            212.0/255.0, 212.0/255.0, 212.0/255.0, 1.0,
            212.0/255.0, 212.0/255.0, 212.0/255.0, 1.0
        };
        
        // 渐变的位置信息范围0~1 0表示开始的位置 1表示结束的位置
        CGFloat gradientLocations[] = {0, 0};
        // 渐变的个数
        size_t locationCount = 2;
        // 创建渐变
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, gradientLocations, locationCount);
        // 指定渐变的开始位置和结束位置 这里设置完效果是整块区域的水平方向的渐变
        CGPoint gradientStartPoint = CGPointMake(0, size.height/2);
        CGPoint gradientEndPoint = CGPointMake(size.width, size.height/2);
        // 将渐变画到上下文中，最后一个参数表示发散的方式
        CGContextDrawLinearGradient(context, gradient, gradientStartPoint, gradientEndPoint, kCGGradientDrawsBeforeStartLocation);
        // 释放内存
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
        
    }
    
}

@end
