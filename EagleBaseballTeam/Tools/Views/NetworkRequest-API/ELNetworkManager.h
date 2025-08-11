//
//  ELNetworkManager.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/3/11.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^NetworkAuthorizationCallback)(BOOL isAuthorized);
typedef void(^InitialDataCallback)(BOOL success);


@interface ELNetworkManager : NSObject
/**
 *网路检测*
 */
+ (instancetype)sharedManager;

/**
 *检查网络权限并监听变化
 */
- (void)checkAndMonitorNetworkAuthorization:(NetworkAuthorizationCallback)callback;

/**
 *初始化数据
 */
- (void)initializeDataIfNeeded:(InitialDataCallback)callback;


@end

NS_ASSUME_NONNULL_END
