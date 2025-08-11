//
//  UIView+DEFrame.m
//  HomeCommunity
//
//  Created by dragon_zheng on 2024/5/6.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import "UIView+DEFrame.h"

@implementation UIView (DEFrame)

- (void)setX:(CGFloat)x{
    CGFloat y = self.frame.origin.y;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    self.frame = CGRectMake(x, y, width, height);
}

- (CGFloat)x{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y{
    CGFloat x = self.frame.origin.x;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    self.frame = CGRectMake(x, y, width, height);
}

- (CGFloat)y{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    CGFloat height = self.frame.size.height;
    self.frame = CGRectMake(x, y, width, height);
}

- (CGFloat)width{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height{
    CGFloat x = self.frame.origin.x;
    CGFloat width = self.frame.size.width;
    CGFloat y = self.frame.origin.y;
    self.frame = CGRectMake(x, y, width, height);
}

- (CGFloat)height{
    return self.frame.size.height;
}

// 为圆形视图添加阴影
- (void)addShadowCornerRadius:(CGFloat )radius shadowColor:(UIColor *)color
{
    self.layer.cornerRadius = radius;  // 使视图变为圆形
    self.layer.masksToBounds = NO;    // 必须设置为NO阴影才可见
    
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 4.0;
    // 创建圆形阴影路径
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                               cornerRadius:self.layer.cornerRadius].CGPath;
}

@end
