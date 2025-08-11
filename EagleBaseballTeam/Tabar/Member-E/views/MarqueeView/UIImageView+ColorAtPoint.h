//
//  UIImageView+ColorAtPoint.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/6/5.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (ColorAtPoint)

- (UIColor *)colorAtPoint:(CGPoint)point alpha:(CGFloat)alphavalue;
- (UIColor *)colorAtPoint:(CGPoint)point data:(UIImage*)I_data;
- (CGPoint)convertPointToImage:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
