//
//  ELNetworkManager.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/3/11.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "ELNetworkManager.h"

static NSString * const kReachabilityChangedNotification = @"kReachabilityChangedNotification";

@interface ELNetworkManager ()

@property (nonatomic, strong) Reachability *reachability;
@property (nonatomic, copy) NetworkAuthorizationCallback authCallback;
@property (nonatomic, assign) BOOL needsInitialization;
@property (nonatomic, assign) BOOL isInitializing;

@end


@implementation ELNetworkManager

+ (instancetype)sharedManager {
    static ELNetworkManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ELNetworkManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _needsInitialization = ![self isDataInitialized];
        _isInitializing = NO;
    }
    return self;
}

- (void)checkAndMonitorNetworkAuthorization:(NetworkAuthorizationCallback)callback {
    self.authCallback = callback;
    
    // 初始化网络监听
    self.reachability = [Reachability reachabilityForInternetConnection];
    
    // 添加网络状态变化通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(reachabilityChanged:)
                                               name:kReachabilityChangedNotification
                                             object:nil];
    
    [self.reachability startNotifier];
    
    // 检查当前网络状态
    [self checkCurrentNetworkStatus];
}

- (void)checkCurrentNetworkStatus {
    NetworkStatus status = [self.reachability currentReachabilityStatus];
    BOOL isReachable = (status != NotReachable);
    
    if (self.authCallback) {
        self.authCallback(isReachable);
    }
    
    if (isReachable && self.needsInitialization) {
        [self initializeDataIfNeeded:nil];
    }
}

- (void)reachabilityChanged:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self checkCurrentNetworkStatus];
    });
}

- (void)initializeDataIfNeeded:(InitialDataCallback)callback {
    if (!self.needsInitialization || self.isInitializing) {
        if (callback) callback(YES);
        return;
    }
    
    self.isInitializing = YES;
    
    // 这里执行你的数据初始化API请求
    [self fetchInitialData:^(BOOL success) {
        self.isInitializing = NO;
        if (success) {
            self.needsInitialization = NO;
            [self markDataAsInitialized];
        }
        if (callback) callback(success);
    }];
}

- (void)fetchInitialData:(InitialDataCallback)callback {
    // 这里实现具体的API请求
    // 示例：
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (callback) callback(YES);
    });
}

- (BOOL)isDataInitialized {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"DataInitialized"];
}

- (void)markDataAsInitialized {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DataInitialized"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.reachability stopNotifier];
}

@end
