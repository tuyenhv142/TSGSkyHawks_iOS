//
//  EGetTokenViewModel.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/3/18.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGetTokenViewModel : NSObject

+ (EGetTokenViewModel *)sharedManager;

/**
 * 获取 两个服务器的token
 */
-(void)getAuthForCRM;

/**
 *获取CRM token (服务器停了)
 */
- (void)getAuthForOnlyOneCRM:(void(^)(BOOL success))completion;
/**
 *单独 获取中继 token
 */
-(void)getAuthForRelayResponseState:(void (^) (BOOL state, id result3))stateBlock;


- (void)getAppStoreVersionWithAppID:(NSString *)appID completion:(void (^)(NSString *appStoreVersion, NSError *error))completion;

/**
 * 登录获取 token 为了刷新
 */
-(void)loginActionCompletionHandler:(void (^)(BOOL successLogin))completion;

/**
 *防止用户信息在网页发生变化
 */
-(void)getUserData:(void(^)(BOOL isSuccess,NSString *gmail))completion;

//MARK:  获取会员信息
- (void)fetchMemberInfo:(void(^)(BOOL isSuccess))completion;
@end

NS_ASSUME_NONNULL_END
