//
//  UIImage+Color.h
//  NewsoftOA24
//
//  Created by rick on 7/2/24.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage(Extend)

+(UIImage*) imageWithColor:(UIColor*)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+(UIImage*)image:(UIImage*)image withRoundCorner:(float )corner;
+ (UIImage *)createGradientImageWithSize:(CGSize)size startColor:(UIColor *)startColor endColor:(UIColor *)endColor;

- (UIImage *)imageWithNewSize:(CGSize)size;

- (UIImage *)imageWithAlpha:(CGFloat)alpha;
@end

NS_ASSUME_NONNULL_END
