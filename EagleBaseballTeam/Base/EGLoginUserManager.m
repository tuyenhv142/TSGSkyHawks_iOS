//
//  EGLoginUserManager.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/11.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGLoginUserManager.h"

#import "EGMainTabBarController.h"
#import "EGLogInViewController.h"

#import "EGUserOauthModel.h"


static NSString * const KeyUserInfoInfo = @"userInfo";
static NSString * const KeyRelaytoken = @"relaytoken";
static NSString * const KeyOauthInfo = @"oauthInfo";
static NSString * const KeyMemberInfo = @"MemberInfo";
static NSString * const KeyMemberInfoPoint = @"MemberInfoPoint";

@implementation EGLoginUserManager


+ (EGLoginUserManager *)sharedManager
{
    static EGLoginUserManager *handle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handle = [[EGLoginUserManager alloc] init];
    });
    return handle;
}

+(void)getFCMTokenSuccess:(void (^)(BOOL success,NSString *token))completion
{
    NSData *token1 = [kUserDefaults objectForKey:DeviceTokenInfo];
    [FIRMessaging messaging].APNSToken = token1;
    [[FIRMessaging messaging] tokenWithCompletion:^(NSString *token, NSError *error) {
      if (error != nil) {
        ELog(@"getFCMToken Error:%@", error);
          if (completion) {
              completion(false,@"");
          }
      } else {
          if (completion) {
              completion(true,token);
          }
          ELog(@"getFCMToken success: %@", token);
          [kUserDefaults setObject:token forKey:FCMTokenInfo];
          [kUserDefaults synchronize];
      }
    }];
}

//#pragma mark ==== 登入
//+(void)login{
//    
//    return [[self sharedManager] logInAccount];
//}
//-(void)logInAccount
//{
////    UIWindow *window =[UIApplication sharedApplication].windows.firstObject;
////    EGMainTabBarController *mainVC = [EGMainTabBarController new];
////    window.rootViewController = mainVC;
//}

#pragma mark ====  登出
+(void)logout{
    
    return [[self sharedManager] logOutAccount];
}
-(void)logOutAccount
{
//    UIWindow *window =[UIApplication sharedApplication].windows.firstObject;
//    EGLogInViewController *loginVc = [[EGLogInViewController alloc]init];
//    [window setRootViewController:loginVc];
    
    [kUserDefaults setValue:@"NO" forKey:EGLoginStatus];
    [kUserDefaults removeObjectForKey:KeyUserInfoInfo];
    [kUserDefaults removeObjectForKey:KeyMemberInfo];
    [kUserDefaults synchronize];
    
    [[EGCredentialManager sharedManager] clearCredentials];
    
    [[NSNotificationCenter defaultCenter]
                        postNotificationName:@"closebeaconNotification"
                        object:self];
    
}

+ (BOOL )isLogIn
{
    if ([[kUserDefaults objectForKey:EGLoginStatus] boolValue] == true){
        return true;
    }else{
        return false;
    }
}

#pragma mark ==== Oauth
+(EGUserOauthModel *)getOauthDataModel
{
    NSDictionary *infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:KeyOauthInfo];
    EGUserOauthModel *userInfoModel = [EGUserOauthModel mj_objectWithKeyValues:infoDic];
    return userInfoModel;
}
+ (void)saveOauthDataModel:(EGUserOauthModel *)userInfo
{
    if (userInfo)
    {
        [[NSUserDefaults standardUserDefaults] setObject:userInfo.mj_keyValues forKey:KeyOauthInfo];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


#pragma mark ==== 用户信息
+(UserInfomationModel *)getUserInfomation
{
    NSDictionary *infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:KeyUserInfoInfo];
    UserInfomationModel *userInfoModel = [UserInfomationModel mj_objectWithKeyValues:infoDic];
    return userInfoModel;
}

+ (void)saveUserInfomation:(UserInfomationModel *)userInfo
{
    if (userInfo)
    {
        [kUserDefaults setValue:@"YES" forKey:EGLoginStatus];
        [kUserDefaults synchronize];
        [[NSUserDefaults standardUserDefaults] setObject:userInfo.mj_keyValues forKey:KeyUserInfoInfo];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}



#pragma mark ==== Member infomation
/**
 * 会员信息获取
 */
+(MemberInfomationModel *)getMemberInfomation
{
    NSDictionary *infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:KeyMemberInfo];
    MemberInfomationModel *userInfoModel = [MemberInfomationModel mj_objectWithKeyValues:infoDic];
    return userInfoModel;
}
/**
 * 会员信息保存
 */
+ (void)saveMemberInfomation:(MemberInfomationModel *)userInfo
{
    if (userInfo)
    {
        [[NSUserDefaults standardUserDefaults] setObject:userInfo.mj_keyValues forKey:KeyMemberInfo];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark ==== 中继 服务器tokenModel
/**
 * 中继 服务器
 */
+(EGRelayTokenModel *)getRelayToken
{
    NSDictionary *infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:KeyRelaytoken];
    EGRelayTokenModel *tokenModel = [EGRelayTokenModel mj_objectWithKeyValues:infoDic];
    return tokenModel;
}
/**
 * 中继 服务器
 */
+ (void)saveRelayToken:(EGRelayTokenModel *)tokenModel
{
    if (tokenModel)
    {
        [[NSUserDefaults standardUserDefaults] setObject:tokenModel.mj_keyValues forKey:KeyRelaytoken];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


/**
 *
 */
+(EGMemberInfoModel *)getMemberInfoPoints
{
    NSDictionary *infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:KeyMemberInfoPoint];
    EGMemberInfoModel *tokenModel = [EGMemberInfoModel mj_objectWithKeyValues:infoDic];
    return tokenModel;
}
/**
 * 
 */
+ (void)saveMemberInfoPoints:(EGMemberInfoModel *)tokenModel
{
    if (tokenModel)
    {
        [[NSUserDefaults standardUserDefaults] setObject:tokenModel.mj_keyValues forKey:KeyMemberInfoPoint];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
@end
