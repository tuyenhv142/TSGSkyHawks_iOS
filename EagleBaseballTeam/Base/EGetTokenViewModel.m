//
//  EGetTokenViewModel.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/3/18.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGetTokenViewModel.h"

#import "EGMemberInfoModel.h"

@interface EGetTokenViewModel ()
@property (nonatomic, strong) dispatch_semaphore_t requestSemaphore;
@property (nonatomic, assign) BOOL isRequesting;
@end

@implementation EGetTokenViewModel


- (instancetype)init {
    self = [super init];
    if (self) {
        _requestSemaphore = dispatch_semaphore_create(1); // 初始值为 1
        _isRequesting = NO;
    }
    return self;
}


+ (EGetTokenViewModel *)sharedManager
{
    static EGetTokenViewModel *viewModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        viewModel = [[self alloc] init];
    });
    return viewModel;
}

//获取两个服务器token 并向中继发fcmtoken
- (void)getAuthForCRM
{
    if (self.isRequesting) {
        ELog(@"⚠️ 请求正在进行，请勿重复调用");
        return;
    }
    // 加锁，防止重复请求token往中继发
    dispatch_semaphore_wait(self.requestSemaphore, DISPATCH_TIME_FOREVER);
    self.isRequesting = YES;
    
    dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue, ^{
        
        [self getAuthForOnlyOneCRM:^(BOOL success) {
            if (success) {
                
                dispatch_async(serialQueue, ^{
                    [self getAuthForRelayResponseState:^(BOOL state, id result3) {
                        if (state) {
                            
                            dispatch_async(serialQueue, ^{
                                [self fcmTokenResponseState:^(BOOL state, id result4) {
                                    if (state) {
                                        
                                        // 请求全部成功，解锁
                                        self.isRequesting = NO;
                                        dispatch_semaphore_signal(self.requestSemaphore);
                                        
                                        dispatch_async(serialQueue, ^{
                                            [self setFcmTokenToRelayServer];
                                        });
                                        
                                    }else{
                                        // 第3个请求失败，解锁
                                        self.isRequesting = NO;
                                        dispatch_semaphore_signal(self.requestSemaphore);
                                    }
                                    
                                }];
                                
                            });
                            
                        }else{
                            // 第2个请求失败，解锁
                            self.isRequesting = NO;
                            dispatch_semaphore_signal(self.requestSemaphore);
                        }
                    }];
                });
                
            }else{
                // 第一个请求失败，解锁
                self.isRequesting = NO;
                dispatch_semaphore_signal(self.requestSemaphore);
            }
        }];
        
    });
    
}

//单独 获取CRM token (服务器停了)
- (void)getAuthForOnlyOneCRM:(void(^)(BOOL success))completion
{
    NSString* apikey = [[EGCredentialManager sharedManager] getCRMApiKey];
    NSLog(@"[DEBUG] CRM API Key: %@", apikey);

    NSDictionary *dict = @{
        @"apiKey": apikey ? apikey:@"",
        @"scope": @[@""],
        @"tokenType": @"Bearer"};
    [[WAFNWHTTPSTool sharedManager] postWithURL:[EGServerAPI oauthVerify_api] parameters:dict headers:@{} success:^(NSDictionary * _Nonnull response) {
        NSDictionary *dataDict = [response objectForKey:@"data"];
        EGUserOauthModel *userModel = [EGUserOauthModel mj_objectWithKeyValues:dataDict];
        [EGLoginUserManager saveOauthDataModel:userModel];
        if (completion) {
            completion(YES);
        }
        ELog(@"getTokenFor CRM_0001");
    } failure:^(NSError * _Nonnull error) {
        if (completion) {
            completion(NO);
        }
        if (error) {
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            if (errorData) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:&error];
                NSString *message = dictionary[@"message"];
                [[EGAlertViewHelper sharedManager] alertViewColor:1 message:message];
            }
        }
    }];
}

//单独 获取中继 token
-(void)getAuthForRelayResponseState:(void (^) (BOOL state, id result3))stateBlock
{
    NSString *app_secret = [[EGCredentialManager sharedManager] getZjApiSecretKey];
    [[WAFNWHTTPSTool sharedManager] getWithURL:[EGServerAPI getTokenForAppId_api] parameters:@{} headers:@{@"appsecret":app_secret ? app_secret:@""} success:^(id  _Nonnull response) {
        NSInteger codeNum = [[response objectForKey:@"code"] intValue];
        if (codeNum == 2000) {
            NSDictionary *dataDict = [response objectForKey:@"data"];
            EGRelayTokenModel *userModel = [EGRelayTokenModel mj_objectWithKeyValues:dataDict];
            [EGLoginUserManager saveRelayToken:userModel];
            ELog(@"getTokenFor_Relay_success_0002");
            if (stateBlock) {
                stateBlock(true,userModel.token);
            }
        }
    } failure:^(NSError * _Nonnull error) {
        if (stateBlock) {
            stateBlock(false,nil);
        }
    }];
}


-(void)fcmTokenResponseState:(void (^) (BOOL state, id result3))stateBlock
{
    NSString *fcmToken = [kUserDefaults objectForKey:FCMTokenInfo];
    if (!fcmToken) {
        [EGLoginUserManager getFCMTokenSuccess:^(BOOL success, NSString * _Nonnull token) {
            ELog(@"getFCMTokenSuccess_success_0003");
            if (stateBlock) {
                stateBlock(success,token);
            }
        }];
    }else{
        if (stateBlock) {
            stateBlock(true,fcmToken);
        }
    }
}

-(void)setFcmTokenToRelayServer
{
    EGUserOauthModel *userModel = [EGLoginUserManager getOauthDataModel];
    NSString *crmClientToken = userModel.accessToken;
    NSString *fcmToken = [kUserDefaults objectForKey:FCMTokenInfo];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSString *loginTime = [formatter stringFromDate:[NSDate date]];
    loginTime = [loginTime stringByReplacingOccurrencesOfString:@" " withString:@"T"];
    NSString *uuidStr = [UIDevice currentDevice].identifierForVendor.UUIDString;
    NSDictionary *dict = @{
        @"deviceId": uuidStr,
        @"fcmToken": fcmToken ? fcmToken:@"",
        @"deviceIsPush": @(0),
        @"deviceType": @(0),
        @"memberType": @(0),
        @"loginTime": [loginTime stringByAppendingString:@"+08:00"],
        @"crmClientToken":crmClientToken
    };
    EGRelayTokenModel *tokenModel = [EGLoginUserManager getRelayToken];
    NSDictionary *headerDict;
    if (tokenModel) {
        headerDict = @{@"Authorization":tokenModel.token ? tokenModel.token:@""};
    }
    [[WAFNWHTTPSTool sharedManager] postWithURL:[EGServerAPI mobile_crm_API] parameters:dict headers:headerDict success:^(NSDictionary * _Nonnull response) {
        ELog(@"success 未登录向中继 传fcmToken 0004");
        [kUserDefaults setObject:@"OK" forKey:SETFCMTokenState];
        [kUserDefaults synchronize];
    } failure:^(NSError * _Nonnull error) {
        ELog(@"error::::::未登录向中继 传fcmToken 0004");
    }];
}


- (void)getAppStoreVersionWithAppID:(NSString *)appID completion:(void (^)(NSString *appStoreVersion, NSError *error))completion
{
    NSString *urlString = [NSString stringWithFormat:@"https://itunes.apple.com/tw/lookup?id=%@", appID];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        NSError *jsonError;
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError) {
            completion(nil, jsonError);
            return;
        }
        
        NSArray *results = jsonResponse[@"results"];
        if (results.count > 0) {
            NSString *appStoreVersion = results[0][@"version"];
            completion(appStoreVersion, nil);
        } else {
            completion(nil, [NSError errorWithDomain:@"com.yourapp.domain" code:404 userInfo:@{NSLocalizedDescriptionKey: @"App not found in App Store"}]);
        }
    }];
    [task resume];
}


/**
 * 登录获取 token 为了刷新
 */
-(void)loginActionCompletionHandler:(void (^)(BOOL successLogin))completion
{
    EGUserOauthModel *model = [EGLoginUserManager getOauthDataModel];
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
    NSDictionary *dict_header = @{@"Authorization":tokenString};
    NSDictionary *dictUser = [kUserDefaults objectForKey:@"TokenRefreshLogIn"];
    if (!dictUser) {
        return;
    }
    [[WAFNWHTTPSTool sharedManager] postWithURL:[EGServerAPI signIn_api] parameters:dictUser headers:dict_header success:^(NSDictionary * _Nonnull response) {
        [MBProgressHUD hideHUD];
        
        NSDictionary *dataDict = [response objectForKey:@"data"];
        UserInfomationModel *userModel = [UserInfomationModel mj_objectWithKeyValues:dataDict];
        [EGLoginUserManager saveUserInfomation:userModel];
        if (completion) {
            completion(true);
        }
        
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        if (error) {
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            if (errorData) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:&error];
                NSString *message = dictionary[@"message"];
                [[EGAlertViewHelper sharedManager] alertViewColor:1 message:message];
            }
            if (completion) {
                completion(false);
            }
        }
    }];
}

//防止用户信息在网页发生变化
-(void)getUserData:(void(^)(BOOL isSuccess,NSString *gmail))completion
{
    UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
    NSDictionary *dict_header = @{@"Authorization":tokenString};
    [[WAFNWHTTPSTool sharedManager] getWithURL:[EGServerAPI basicMemberContact_api:model.ID] parameters:@{} headers:dict_header success:^(NSDictionary * _Nonnull response) {
        
        NSDictionary *dataDict = response[@"data"];
        NSDictionary *dictExtra = [dataDict objectOrNilForKey:@"NewsoftExtraData"];
        
        if (completion) {
            completion(true,[dictExtra objectOrNilForKey:@"email"]);
        }
        
        } failure:^(NSError * _Nonnull error) {
            if (completion) {
                completion(false,@"");
            }
        }];
}

//MARK:  获取会员信息
- (void)fetchMemberInfo:(void(^)(BOOL isSuccess))completion
{
    UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
    if (!model) {
        if (completion) {
            completion(false);
        }
        return;
    }
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
    NSDictionary *dict_header = @{@"Authorization":tokenString};
    NSString *url = [EGServerAPI basicMember_api:model.ID];
    [[WAFNWHTTPSTool sharedManager] getWithURL:url parameters:@{} headers:dict_header success:^(NSDictionary * _Nonnull response) {
        
        NSDictionary *dataDict = response[@"data"];
        EGMemberInfoModel *infoModel = [EGMemberInfoModel mj_objectWithKeyValues:dataDict];
        [EGLoginUserManager saveMemberInfoPoints:infoModel];
        if (completion) {
            completion(true);
        }
        } failure:^(NSError * _Nonnull error) {
            if (completion) {
                completion(false);
            }
            if ([error.localizedDescription containsString:@"offline"] || error.code == -1009) {
                [MBProgressHUD showDelayHidenMessage:@"請檢查您的網路連線，確保裝置已連接至網路後再重試。"];
            }else{
                [MBProgressHUD showDelayHidenMessage:error.localizedDescription];
            }
            
        }];
}
@end
    