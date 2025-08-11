//
//  UIImage+Color.m
//  NewsoftOA24
//
//  Created by rick on 7/2/24.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import "UIImage+Extend.h"


@implementation  UIImage(Extend)
+(UIImage*) imageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
      
    return img;
}

+(UIImage*)image:(UIImage*)image withRoundCorner:(float )corner
{
//    UIGraphicsBeginImageContextWithOptions(rect.size,NO,UIScreen.mainScreen.scale);
//    CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5.0].CGPath);
//
//    CGContextClip(UIGraphicsGetCurrentContext());
//    [image drawInRect:rect];
//    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();


    UIGraphicsImageRendererFormat *format1 = [[UIGraphicsImageRendererFormat alloc] init];
    format1.scale = [UIScreen mainScreen].scale;
    format1.opaque = NO;
    UIGraphicsImageRenderer *render1 = [[UIGraphicsImageRenderer alloc] initWithSize:image.size format:format1];
    UIImage *outputImage = [render1 imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
        CGContextRef context = rendererContext.CGContext;
        CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
       // CGContextBeginPath(context);
      //  CGContextAddEllipseInRect(context, rect);
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:corner];
        CGContextAddPath(context, path.CGPath);
//        CGContextClosePath(context);
        CGContextClip(context);
        [image drawInRect:rect];

    }];
//    //imageView.image = circleImage;
    return outputImage;
}

- (UIImage *)imageWithNewSize:(CGSize)size
{

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), NO, 0.0);
    // 绘制改变大小后的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从图形上下文获取新的图片
    UIImage *resizedImage2 = UIGraphicsGetImageFromCurrentImageContext();
    // 结束图形上下文
    UIGraphicsEndImageContext();
      
    return resizedImage2;
}

// 添加创建渐变图片的方法
+ (UIImage *)createGradientImageWithSize:(CGSize)size startColor:(UIColor *)startColor endColor:(UIColor *)endColor {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    gradientLayer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    gradientLayer.locations = @[@0.2, @1.0];
    UIGraphicsBeginImageContext(size);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return gradientImage;
}

// 方法二：使用图片处理
- (UIImage *)imageWithAlpha:(CGFloat)alpha
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, self.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
