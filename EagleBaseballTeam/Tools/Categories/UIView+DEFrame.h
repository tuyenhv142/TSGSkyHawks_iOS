//
//  UIView+DEFrame.h
//  HomeCommunity
//
//  Created by dragon_zheng on 2024/5/6.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (DEFrame)

@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;

- (void)addShadowCornerRadius:(CGFloat )radius shadowColor:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
