//
//  UIDevice+DEAddition.h
//  HomeCommunity
//
//  Created by dragon_zheng on 2024/5/6.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (DEAddition)

/// 顶部安全区高度
+ (CGFloat)de_safeDistanceTop;

/// 底部安全区高度
+ (CGFloat)de_safeDistanceBottom;

/// 顶部状态栏高度（包括安全区）
+ (CGFloat)de_statusBarHeight;

/// 导航栏高度
+ (CGFloat)de_navigationBarHeight;

/// 状态栏+导航栏的高度
+ (CGFloat)de_navigationFullHeight;

/// 底部导航栏高度
+ (CGFloat)de_tabBarHeight;

/// 底部导航栏高度（包括安全区）
+ (CGFloat)de_tabBarFullHeight;


@end

NS_ASSUME_NONNULL_END
