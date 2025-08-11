//
//  WAFNWHTTPSTool.m
//  WorkAttendanceManager
//
//  Created by elvin on 2024/9/29.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import "WAFNWHTTPSTool.h"

@implementation WAFNWHTTPSTool {
    AFHTTPSessionManager *_sessionManager;
    BOOL _isRefreshingToken;
    NSMutableArray *_requestsQueue;
}


+ (instancetype)sharedManager {
    static WAFNWHTTPSTool *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WAFNWHTTPSTool alloc] init];
        instance.isNeedJson = YES;
    });
    return instance;
}

- (void)postWithURL:(NSString *)url
         parameters:(NSDictionary *)parameters
            headers:(NSDictionary *)headers
            success:(void (^)(NSDictionary *response))success
            failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 15.0;
    // 设置响应序列化器（支持 JSON）
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSMutableDictionary *headersDict = [NSMutableDictionary dictionaryWithDictionary:headers];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    [headersDict setObject:systemVersion forKey:@"Client"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [headersDict setObject:version forKey:@"Version"];
    
    [manager POST:url parameters:parameters headers:headersDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            if (responseObject) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    if ([[responseObject allKeys] containsObject:@"code"]) {
                        NSInteger codeNum = [[responseObject objectForKey:@"code"] intValue];
                        if (codeNum == 4005) {
                            [[EGetTokenViewModel sharedManager] getAuthForRelayResponseState:^(BOOL state, id  _Nonnull result3) {
                                if (state) {
                                    NSMutableDictionary *newHeaders = [headers mutableCopy];
                                    [newHeaders setObject:[NSString stringWithFormat:@"%@",result3]
                                                   forKey:@"Authorization"];
                                    [self postWithURL:url parameters:parameters headers:newHeaders success:success failure:failure];
                                }
                            }];
                        } }
                }
                NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
                NSString *json =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                ELog(@"POST Success json:%@",json);
            }
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
        NSLog(@"POST Bad Request: %@", error.localizedDescription);
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if (errorData) {
            NSString *errorMessage = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
            NSLog(@"POST Server Error Message: %@", errorMessage);
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:&error];
            NSString *message = dictionary[@"message"];
            if ([message containsString:@"Token"] || [message containsString:@"token"]) {//token有问题 包含client和member
                if ([url containsString:@"client"]) {
                    if ([url containsString:@"verify"]) {
                        //verify 有问题就不再处理 否则就死循环（verify是post 请求）
                    }else{
                        //        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                        //        if (response.statusCode == 401) {
                        [self handleTokenExpiredWithURL:url
                                             parameters:parameters
                                                headers:headers
                                                success:success
                                                failure:failure
                                           requestBlock:^(NSString *url, NSDictionary *parameters, NSDictionary *headers, void(^success)(id), void(^failure)(NSError *)) {
                            [self postWithURL:url parameters:parameters headers:headers success:success failure:failure];
                        }];
                    }
                }else if ([url containsString:@"member"]){//member token有问题就重新登录
                    [[EGetTokenViewModel sharedManager] loginActionCompletionHandler:^(BOOL successLogin) {
                        if (successLogin) {
                            UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
                            NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
                            NSDictionary *newHeader = @{@"Authorization":tokenString};
                            [self postWithURL:url parameters:parameters headers:newHeader success:success failure:failure];
                        }
                    }];
                }
                
            }
        }
    }];
}

- (void)getWithURL:(NSString *)url
        parameters:(NSDictionary *)parameters
           headers:(NSDictionary *)headers
           success:(void (^)(NSDictionary *response))success
           failure:(void (^)(NSError *error))failure {
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.requestCachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData; // 忽略所有缓存
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    
    //bỏ qua check ssh //skip ssh safe Statemnet
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    //
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 15.0;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSMutableDictionary *headersDict = [NSMutableDictionary dictionaryWithDictionary:headers];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    [headersDict setObject:systemVersion forKey:@"Client"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [headersDict setObject:version forKey:@"Version"];
    
    [manager GET:url parameters:parameters headers:headersDict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            if (responseObject) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    if ([[responseObject allKeys] containsObject:@"code"] ){
                        NSInteger codeNum = [[responseObject objectForKey:@"code"] intValue];
                        if (codeNum == 4005) {
                            [[EGetTokenViewModel sharedManager] getAuthForRelayResponseState:^(BOOL state, id  _Nonnull result3) {
                                if (state) {
                                    NSMutableDictionary *newHeaders = [headers mutableCopy];
                                    [newHeaders setObject:[NSString stringWithFormat:@"%@",result3]
                                                   forKey:@"Authorization"];
                                    [self getWithURL:url parameters:parameters headers:newHeaders success:success failure:failure];
                                }
                            }];
                        } }
                }
//                NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
//                NSString *json =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                NSLog(@"success json:%@",json);
            }
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"GET Bad Request: %@", error.localizedDescription);
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if (errorData) {
            NSString *errorMessage = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
            NSLog(@"GET Server Error Message: %@", errorMessage);
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:&error];
            NSString *message = dictionary[@"message"];
            if ([message containsString:@"Token"] || [message containsString:@"token"]) {//token有问题 包含client和member
                if ([url containsString:@"client"]) {
                   
                    [self handleTokenExpiredWithURL:url
                                         parameters:parameters
                                            headers:headers
                                            success:success
                                            failure:failure
                                       requestBlock:^(NSString *url, NSDictionary *parameters, NSDictionary *headers, void(^success)(id), void(^failure)(NSError *)) {
                        [self getWithURL:url parameters:parameters headers:headers success:success failure:failure];
                    }];
                    
                }else if ([url containsString:@"member"]){//member token有问题就重新登录
                    [[EGetTokenViewModel sharedManager] loginActionCompletionHandler:^(BOOL successLogin) {
                        if (successLogin) {
                            UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
                            NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
                            NSDictionary *newHeader = @{@"Authorization":tokenString};
                            [self getWithURL:url parameters:parameters headers:newHeader success:success failure:failure];
                        }
                    }];
                }
            }
        }
        if (failure) {
            failure(error);
        }
        
    }];
}

- (void)putWithURL:(NSString *)url
        parameters:(NSDictionary *)parameters
           headers:(NSDictionary *)headers
           success:(void (^)(NSDictionary *response))success
           failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 15.0;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSMutableDictionary *headersDict = [NSMutableDictionary dictionaryWithDictionary:headers];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    [headersDict setObject:systemVersion forKey:@"Client"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [headersDict setObject:version forKey:@"Version"];
    
    [manager PUT:url parameters:parameters headers:headersDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (success) {
                success(responseObject);
                NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
                NSString *json =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"put success json:%@",json);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"PUT Bad Request: %@", error.localizedDescription);
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            if (errorData) {
                NSString *errorMessage = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
                NSLog(@"GET Server Error Message: %@", errorMessage);
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:&error];
                NSString *message = dictionary[@"message"];
                if ([message containsString:@"Token"] || [message containsString:@"token"]) {//token有问题 包含client和member
                    if ([url containsString:@"client"]) {
                        
                        [self handleTokenExpiredWithURL:url
                                             parameters:parameters
                                                headers:headers
                                                success:success
                                                failure:failure
                                           requestBlock:^(NSString *url, NSDictionary *parameters, NSDictionary *headers, void(^success)(id), void(^failure)(NSError *)) {
                            [self putWithURL:url parameters:parameters headers:headers success:success failure:failure];
                        }];
                        
                    }else if ([url containsString:@"member"]){//member token有问题就重新登录
                        [[EGetTokenViewModel sharedManager] loginActionCompletionHandler:^(BOOL successLogin) {
                            if (successLogin) {
                                UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
                                NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
                                NSDictionary *newHeader = @{@"Authorization":tokenString};
                                [self putWithURL:url parameters:parameters headers:newHeader success:success failure:failure];
                            }
                        }];
                    }
                }
            }
            if (failure) {
                failure(error);
            }
        }];
    
}




- (instancetype)init {
    self = [super init];
    if (self) {
        _sessionManager = [AFHTTPSessionManager manager];
        _isRefreshingToken = NO;
        _requestsQueue = [NSMutableArray array];
    }
    return self;
}

- (void)clearRequestsQueue
{
    [_requestsQueue removeAllObjects];
}

//rick add
- (void)handleTokenExpiredWithURL:(NSString *)url
                      parameters:(NSDictionary *)parameters
                        headers:(NSDictionary *)headers
                        success:(void (^)(id response))success
                        failure:(void (^)(NSError *error))failure
                   requestBlock:(void(^)(NSString *url, NSDictionary *parameters, NSDictionary *headers, void(^success)(id response), void(^failure)(NSError *error)))requestBlock
{
    if (_isRefreshingToken) {
        [_requestsQueue addObject:@{
            @"url": url,
            @"parameters": parameters ?: @{},
            @"headers": headers ?: @{},
            @"success": success ?: ^(id response){},
            @"failure": failure ?: ^(NSError *error){},
            @"requestBlock": requestBlock
        }];
    }
    else
    {
        _isRefreshingToken = YES;
        [self refreshTokenWithSuccess:^{
            self->_isRefreshingToken = NO;
            
            // 获取新的 token
            EGUserOauthModel *model = [EGLoginUserManager getOauthDataModel];
            NSMutableDictionary *newHeaders = [headers mutableCopy];
            [newHeaders setObject:[NSString stringWithFormat:@"Bearer %@", model.accessToken]
                         forKey:@"Authorization"];
            
            // 使用传入的 requestBlock 重试请求
            requestBlock(url, parameters, newHeaders, success, failure);
            [self resumeRequests];
            
        } failure:^(NSError *error) {
            self->_isRefreshingToken = NO;
            if (failure) {
                failure(error);
            }
            [self clearRequestsQueue];
        }];
    }
}

- (void)refreshTokenWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure {
//    EGUserOauthModel *model = [EGLoginUserManager getOauthDataModel];
////    if (!model) {
////        return;
////    }
//    NSDictionary *refreshParameters = @{@"token":model.refreshToken,@"clientId":model.ID};
//    
//    [_sessionManager POST:[EGServerAPI refreshToken_api] parameters:refreshParameters headers:@{} progress:^(NSProgress * _Nonnull uploadProgress) {
//            
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            
//            NSDictionary *dataDict = [responseObject objectForKey:@"data"];
//            EGUserOauthModel *userModel = [EGUserOauthModel mj_objectWithKeyValues:dataDict];
//            [EGLoginUserManager saveOauthDataModel:userModel];
//            if (success) {
//                success();
//            }
//            
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            if (failure) {
//                failure(error);
//            }
//        }];
    
    NSString* apikey = [[EGCredentialManager sharedManager] getCRMApiKey];
    NSDictionary *dict = @{
        @"apiKey": apikey ? apikey:@"",
        @"scope": @[@""],
        @"tokenType": @"Bearer"};
    NSMutableDictionary *headersDict = [NSMutableDictionary dictionary];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    [headersDict setObject:systemVersion forKey:@"Client"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [headersDict setObject:version forKey:@"Version"];
    
    [[WAFNWHTTPSTool sharedManager] postWithURL:[EGServerAPI oauthVerify_api] parameters:dict headers:headersDict success:^(NSDictionary * _Nonnull response) {
        NSDictionary *dataDict = [response objectForKey:@"data"];
        EGUserOauthModel *userModel = [EGUserOauthModel mj_objectWithKeyValues:dataDict];
        [EGLoginUserManager saveOauthDataModel:userModel];
        if (success) {
            success();
        }
    } failure:^(NSError * _Nonnull error) {
        
        if (error) {
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            if (errorData) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:&error];
                NSString *message = dictionary[@"message"];
                [[EGAlertViewHelper sharedManager] alertViewColor:1 message:message];
            }
        }
        if (failure) {
            failure(error);
        }
    }];
}

// 修改 resumeRequests 方法
- (void)resumeRequests {
    for (NSDictionary *request in _requestsQueue) {
        void(^requestBlock)(NSString *, NSDictionary *, NSDictionary *, void(^)(id), void(^)(NSError *)) = request[@"requestBlock"];
        requestBlock(request[@"url"],
                    request[@"parameters"],
                    request[@"headers"],
                    request[@"success"],
                    request[@"failure"]);
    }
    [_requestsQueue removeAllObjects];
}



@end
