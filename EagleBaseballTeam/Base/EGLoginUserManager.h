//
//  EGLoginUserManager.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/11.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class EGUserOauthModel,UserInfomationModel,MemberInfomationModel,EGRelayTokenModel,EGMemberInfoModel;

@interface EGLoginUserManager : NSObject

+ (EGLoginUserManager *)sharedManager;

/**
 * firebase token
 */
+(void)getFCMTokenSuccess:(void (^)(BOOL success,NSString *token))completion;
/**
 login
 */
//+ (void)login;

/**
 logout
 */
+ (void)logout;

/**
 is LogIn
 */
+ (BOOL )isLogIn;


#pragma mark ==== Oauth
/**
 API 是  client / sigin_up  的使用
 */
+(EGUserOauthModel *)getOauthDataModel;
/**
 API 是  client / sigin_up  的使用
 */
+ (void)saveOauthDataModel:(EGUserOauthModel *)userInfo;

#pragma mark ==== LogIn
/**
 API 是 basic / member 的使用
 */
+(UserInfomationModel *)getUserInfomation;
/**
 API 是 basic / member 的使用
 */
+ (void)saveUserInfomation:(UserInfomationModel *)userInfo;


#pragma mark ==== Member infomation
/**
 * 会员信息获取
 */
+(MemberInfomationModel *)getMemberInfomation;
/**
 * 会员信息保存
 */
+ (void)saveMemberInfomation:(MemberInfomationModel *)userInfo;



#pragma mark ==== 中继 服务器tokenModel
/**
 * 中继 服务器
 */
+(EGRelayTokenModel *)getRelayToken;
/**
 * 中继 服务器
 */
+ (void)saveRelayToken:(EGRelayTokenModel *)tokenModel;


/**
 *
 */
+(EGMemberInfoModel *)getMemberInfoPoints;
/**
 *
 */
+ (void)saveMemberInfoPoints:(EGMemberInfoModel *)tokenModel;

@end

NS_ASSUME_NONNULL_END
