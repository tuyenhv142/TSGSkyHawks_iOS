//
//  UIDevice+DEAddition.m
//  HomeCommunity
//
//  Created by dragon_zheng on 2024/5/6.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import "UIDevice+DEAddition.h"

@implementation UIDevice (DEAddition)

/// 顶部安全区高度
+ (CGFloat)de_safeDistanceTop {
    if (@available(iOS 13.0, *)) {
        CGFloat safetop =  [[kUserDefaults objectForKey:@"safeDistanceTop"] doubleValue];
        if (safetop) {
            return safetop;
        }else{
            NSSet *set = [UIApplication sharedApplication].connectedScenes;
            UIWindowScene *windowScene = [set anyObject];
            UIWindow *window = windowScene.windows.firstObject;
            CGFloat topH = window.safeAreaInsets.top;
            [kUserDefaults setObject:@(topH) forKey:@"safeDistanceTop"];
            return window.safeAreaInsets.top;
        }
        
    } else if (@available(iOS 11.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        return window.safeAreaInsets.top;
    }
    return 0;
}

/// 顶部安全区高度
//    static func vg_safeDistanceTop() -> CGFloat {
//        if #available(iOS 13.0, *) {
//            let scene = UIApplication.shared.connectedScenes.first
//            guard let windowScene = scene as? UIWindowScene else { return 0 }
//            guard let window = windowScene.windows.first else { return 0 }
//            return window.safeAreaInsets.top
//        } else if #available(iOS 11.0, *) {
//            guard let window = UIApplication.shared.windows.first else { return 0 }
//            return window.safeAreaInsets.top
//        }
//        return 0;
//    }


/// 底部安全区高度
+ (CGFloat)de_safeDistanceBottom {
    if (@available(iOS 13.0, *)) {
        
        CGFloat safebottom =  [[kUserDefaults objectForKey:@"safebottom"] doubleValue];
        if (safebottom && safebottom > 0) {
            return safebottom;
        }else{
            NSSet *set = [UIApplication sharedApplication].connectedScenes;
            UIWindowScene *windowScene = [set anyObject];
            UIWindow *window = windowScene.windows.firstObject;
            CGFloat safebottomH = window.safeAreaInsets.bottom;
            [kUserDefaults setObject:@(safebottomH) forKey:@"safebottom"];
            return safebottomH;
        }
        
    } else if (@available(iOS 11.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        return window.safeAreaInsets.bottom;
    }
    return 0;
}

/// 顶部状态栏高度（
+ (CGFloat)de_statusBarHeight {
    if (@available(iOS 13.0, *)) {

        CGFloat statusH =  [[kUserDefaults objectForKey:@"statusHeight"] doubleValue];
        if (statusH && statusH > 0) {
            return statusH;
        }else{
            NSSet *set = [UIApplication sharedApplication].connectedScenes;
            UIWindowScene *windowScene = [set anyObject];
            UIStatusBarManager *statusBarManager = windowScene.statusBarManager;
            CGFloat statusH = statusBarManager.statusBarFrame.size.height;
            [kUserDefaults setObject:@(statusH) forKey:@"statusHeight"];
            return statusH;
        }
    } else {
        return [UIApplication sharedApplication].statusBarFrame.size.height;
    }
}

/// 导航栏高度
+ (CGFloat)de_navigationBarHeight {
    return 44.0f;
}

/// 状态栏+导航栏的高度
+ (CGFloat)de_navigationFullHeight {
    return [UIDevice de_statusBarHeight] + [UIDevice de_navigationBarHeight]-1;
}

/// 底部导航栏高度
+ (CGFloat)de_tabBarHeight {
    return 49.0f;
}

/// 底部导航栏高度（包括安全区）
+ (CGFloat)de_tabBarFullHeight {
    return [UIDevice de_tabBarHeight] + [UIDevice de_safeDistanceBottom];
}

@end
