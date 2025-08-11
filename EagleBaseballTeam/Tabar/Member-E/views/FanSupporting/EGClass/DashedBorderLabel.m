//
//  DashedBorderLabel.m
//  EagleBaseballTeam
//
//  Created by Dragon_Zheng on 6/30/25.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DashedBorderLabel.h"
 
@implementation DashedBorderLabel
 
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, ColorRGB(0xD9AE35).CGColor); // 设置边框颜色
    
    CGFloat dashPattern[] = {5, 5};
    CGContextSetLineWidth(context, 2.0); // 设置线宽
    CGContextSetLineDash(context, 0, dashPattern, 2); // 设置虚线样式，这里是5像素实线，5像素空白
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.layer.cornerRadius];
    
    if(_is_currentDate)
    // 绘制边框
    [path stroke];

}
 
@end
