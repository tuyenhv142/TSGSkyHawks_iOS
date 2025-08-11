//
//  AppDelegate.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/1/20.
//

#import "AppDelegate.h"
#import "EGPointsViewController.h"
#import "EGMainTabBarController.h"
#import "EGPointsViewController.h"
#import "SceneDelegate.h"


@interface AppDelegate ()<FIRMessagingDelegate,UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [GMSServices provideAPIKey:@"AIzaSyAVDKSMqhCGyv0u481Hsm0lEY1RMR2qHFg"];
    [GMSPlacesClient provideAPIKey:@"AIzaSyAVDKSMqhCGyv0u481Hsm0lEY1RMR2qHFg"];
    
    [ZYNetworkAccessibity start];
    [ZYNetworkAccessibity setAlertEnable:YES];
    
    [FIRApp configure];
    
    [self configureNotification:application];
    
    // 设置 NavigationBar 全局样式 旧API
    [[UINavigationBar appearance] setBarTintColor:rgba(16, 38, 73, 1)];  // 设置背景色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];    // 设置按钮颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{
        NSForegroundColorAttributeName: [UIColor whiteColor]  // 设置标题颜色
    }];
        
    // 设置 TabBar 全局样式
    [[UITabBar appearance] setBarTintColor:rgba(16, 38, 73, 1)];
    // 设置背景色
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    

    // iOS 15及以上需要额外设置  新API
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *navBarAppearance = [[UINavigationBarAppearance alloc] init];
        [navBarAppearance configureWithOpaqueBackground];
        
        // 使用渐变背景替换单色背景
        CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, 88);
        UIImage *gradientImage = [self gradientImageWithSize:size
                                                  startColor:[UIColor colorWithRed:16/255.0 green:38/255.0 blue:73/255.0 alpha:1]
                                                    endColor:[UIColor colorWithRed:0/255.0 green:78/255.0 blue:162/255.0 alpha:1]];
        navBarAppearance.backgroundImage = gradientImage;
        
        // 设置分隔线颜色与背景色一致
        navBarAppearance.shadowColor = rgba(16, 38, 73, 1);
        // 或者直接移除分隔线
         navBarAppearance.shadowImage = [[UIImage alloc] init];
         navBarAppearance.shadowColor = nil;
        
        navBarAppearance.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
        [UINavigationBar appearance].standardAppearance = navBarAppearance;
        [UINavigationBar appearance].scrollEdgeAppearance = navBarAppearance;
        
        //设置TabBar 背景
        UITabBarAppearance *tabBarAppearance = [[UITabBarAppearance alloc] init];
        [tabBarAppearance configureWithOpaqueBackground];
        tabBarAppearance.backgroundColor = rgba(16, 38, 73, 1);
        [UITabBar appearance].standardAppearance = tabBarAppearance;
        [UITabBar appearance].scrollEdgeAppearance = tabBarAppearance;
  
    }
    

    return YES;
}

// 辅助方法: 创建渐变图片
- (UIImage *)gradientImageWithSize:(CGSize)size startColor:(UIColor *)startColor endColor:(UIColor *)endColor {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSArray *colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
    CGFloat locations[] = {0.0, 1.0};
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
    CGPoint startPoint = CGPointMake(0, 0);
    CGPoint endPoint = CGPointMake(0, size.height); // 垂直渐变（上到下）

    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    return image;
}


- (void)configureNotification:(UIApplication *)application {
    // 请求推送权限
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
    [center requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [FIRMessaging messaging].delegate = self;
            });
        }else{
    //             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //                 dispatch_async(dispatch_get_main_queue(), ^{
    //                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
    //                 });
    //             });
        }
    }];
    [application registerForRemoteNotifications];
    [FIRMessaging messaging].delegate = self;
}


#pragma mark - UISceneSession lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options  API_AVAILABLE(ios(13.0)){
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions  API_AVAILABLE(ios(13.0)){
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

#pragma mark ----
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [FIRMessaging messaging].APNSToken = deviceToken;
    [kUserDefaults setObject:deviceToken forKey:DeviceTokenInfo];
    [kUserDefaults synchronize];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    if (error) {
        ELog(@"deviceToken error:%@",error);
    }else{
        ELog(@"deviceToken Success");
    }
}
#pragma mark ---- FIRMessaging Delegate
- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken
{
    [[FIRMessaging messaging] tokenWithCompletion:^(NSString *token, NSError *error) {
      if (error != nil) {
        ELog(@"Error getting FCM registration token:%@", error);
      } else {
          ELog(@"FCM registration token success: %@", token);
          [kUserDefaults setObject:token forKey:FCMTokenInfo];
      }
        [kUserDefaults synchronize];
    }];
}


#pragma mark --- UNUserNotificationCenterDelegate
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    NSDictionary *dict = notification.request.content.userInfo;
    [[FIRMessaging messaging] appDidReceiveMessage:dict];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    ELog(@"Q--userNotificationCenter:%@",json);
    if (@available(iOS 14.0, *)) {
        completionHandler(UNNotificationPresentationOptionBanner | UNNotificationPresentationOptionList);
    } else {
        // Fallback on earlier versions
    }
    
}
//已经完成推送 app后台进入
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    ELog(@"userNotificationCenter--H:%@",json);
    if (@available(iOS 13.0, *)) {
        UIWindowScene *windowScene = (UIWindowScene *)[UIApplication sharedApplication].connectedScenes.anyObject;
        SceneDelegate *sceneDelegate = (SceneDelegate *)windowScene.delegate;
        [sceneDelegate redirectToTargetViewController:userInfo];
    } else {
        // Fallback on earlier versions
    }
    completionHandler();
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    NSData *data = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    ELog(@"did Receive Remote Notification:%@",json);
//    completionHandler(UIBackgroundFetchResultNewData);
    
}


@end
