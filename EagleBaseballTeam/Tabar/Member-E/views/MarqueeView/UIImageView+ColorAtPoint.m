//
//  UIImageView+ColorAtPoint.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/6/5.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "UIImageView+ColorAtPoint.h"

@implementation UIImageView (ColorAtPoint)

// 将视图坐标系的点转换为图片坐标系的点
- (CGPoint)convertPointToImage:(CGPoint)point {
    // 如果图片为空，返回原点
    if (!self.image) {
        return CGPointZero;
    }
    
    // 获取图片在视图中的实际显示尺寸和位置
    CGSize imageSize = self.image.size;
    CGSize viewSize = self.bounds.size;
    
    // 计算图片的缩放模式和实际显示区域
    CGFloat scaleX = viewSize.width / imageSize.width;
    CGFloat scaleY = viewSize.height / imageSize.height;
    CGFloat scale = MIN(scaleX, scaleY);
    
    // 计算图片在视图中的实际显示区域
    CGFloat offsetX = (viewSize.width - imageSize.width * scale) / 2;
    CGFloat offsetY = (viewSize.height - imageSize.height * scale) / 2;
    
    // 转换坐标点
    CGPoint imagePoint = CGPointMake((point.x - offsetX) / scale,
                                    (point.y - offsetY) / scale);
    
    // 确保坐标点在图片范围内
    imagePoint.x = MAX(0, MIN(imageSize.width - 1, imagePoint.x));
    imagePoint.y = MAX(0, MIN(imageSize.height - 1, imagePoint.y));
    
    return imagePoint;
}

- (CGPoint)convertPointToImage:(CGPoint)point image:(UIImage*)imge{
    // 如果图片为空，返回原点
    if (!self.image) {
        return CGPointZero;
    }
    
    // 获取图片在视图中的实际显示尺寸和位置
    CGSize imageSize = imge.size;
    CGSize viewSize = self.bounds.size;
    
    // 计算图片的缩放模式和实际显示区域
    CGFloat scaleX = viewSize.width / imageSize.width;
    CGFloat scaleY = viewSize.height / imageSize.height;
    CGFloat scale = MIN(scaleX, scaleY);
    
    // 计算图片在视图中的实际显示区域
    CGFloat offsetX = (viewSize.width - imageSize.width * scale) / 2;
    CGFloat offsetY = (viewSize.height - imageSize.height * scale) / 2;
    
    // 转换坐标点
    CGPoint imagePoint = CGPointMake((point.x - offsetX) / scale,
                                    (point.y - offsetY) / scale);
    
    // 确保坐标点在图片范围内
    imagePoint.x = MAX(0, MIN(imageSize.width - 1, imagePoint.x));
    imagePoint.y = MAX(0, MIN(imageSize.height - 1, imagePoint.y));
    
    return imagePoint;
}

// 获取图片指定位置的颜色
- (UIColor *)colorAtPoint:(CGPoint)point alpha:(CGFloat)alphavalue{
    // 先转换坐标点
    CGPoint imagePoint = [self convertPointToImage:point];
    
    // 如果转换后的点超出图片范围，返回透明色
    if (imagePoint.x < 0 || imagePoint.y < 0) {
        return [UIColor clearColor];
    }
    
    // 获取图片的CGImageRef
    CGImageRef imageRef = self.image.CGImage;
    if (!imageRef) {
        return nil;
    }
    
    // 获取图片的宽度和高度
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    
    // 检查点是否在图片范围内
    if (imagePoint.x >= width || imagePoint.y >= height) {
        return nil;
    }
    
    // 创建颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (!colorSpace) {
        return nil;
    }
    
    // 分配内存空间
    unsigned char *rawData = malloc(4);
    if (!rawData) {
        CGColorSpaceRelease(colorSpace);
        return nil;
    }
    
    // 创建位图上下文
    CGContextRef context = CGBitmapContextCreate(rawData,
                                                1,
                                                1,
                                                8,
                                                4,
                                                colorSpace,
                                                kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    if (!context) {
        free(rawData);
        return nil;
    }
    
    // 绘制单个像素
    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1),
                      CGImageCreateWithImageInRect(imageRef,
                                                 CGRectMake(imagePoint.x,
                                                           imagePoint.y,
                                                           1,
                                                           1)));
    
    // 获取颜色值
    CGFloat red = rawData[0] / 255.0f;
    CGFloat green = rawData[1] / 255.0f;
    CGFloat blue = rawData[2] / 255.0f;
    CGFloat alpha = alphavalue;//rawData[3] / 255.0f;
    
    // 释放资源
    CGContextRelease(context);
    free(rawData);
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

// 获取图片指定位置的颜色
- (UIColor *)colorAtPoint:(CGPoint)point data:(UIImage*)I_data{
    // 先转换坐标点
    CGPoint imagePoint = [self convertPointToImage:point image:I_data];
    
    // 如果转换后的点超出图片范围，返回透明色
    if (imagePoint.x < 0 || imagePoint.y < 0) {
        return [UIColor clearColor];
    }
    
    // 获取图片的CGImageRef
    CGImageRef imageRef = I_data.CGImage;
    if (!imageRef) {
        return nil;
    }
    
    // 获取图片的宽度和高度
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    
    // 检查点是否在图片范围内
    if (imagePoint.x >= width || imagePoint.y >= height) {
        return nil;
    }
    
    // 创建颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (!colorSpace) {
        return nil;
    }
    
    // 分配内存空间
    unsigned char *rawData = malloc(4);
    if (!rawData) {
        CGColorSpaceRelease(colorSpace);
        return nil;
    }
    
    // 创建位图上下文
    CGContextRef context = CGBitmapContextCreate(rawData,
                                                1,
                                                1,
                                                8,
                                                4,
                                                colorSpace,
                                                kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    if (!context) {
        free(rawData);
        return nil;
    }
    
    // 绘制单个像素
    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1),
                      CGImageCreateWithImageInRect(imageRef,
                                                 CGRectMake(imagePoint.x,
                                                           imagePoint.y,
                                                           1,
                                                           1)));
    
    // 获取颜色值
    CGFloat red = rawData[0] / 255.0f;
    CGFloat green = rawData[1] / 255.0f;
    CGFloat blue = rawData[2] / 255.0f;
    CGFloat alpha = rawData[3] / 255.0f;
    
    // 释放资源
    CGContextRelease(context);
    free(rawData);
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
@end
