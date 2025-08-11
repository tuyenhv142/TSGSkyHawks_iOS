//
//  SceneDelegate.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/1/20.
//

#import "SceneDelegate.h"

#import "EGMainTabBarController.h"
#import "EGPointsViewController.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions  API_AVAILABLE(ios(13.0)){
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    
//    self.window.backgroundColor = [UIColor whiteColor];
    EGMainTabBarController *tabBarVC = [[EGMainTabBarController alloc] init];
    
    self.window.rootViewController = tabBarVC;
    [self.window makeKeyAndVisible];
    
//    UIView *statue = [UIView new];
//    if (@available(iOS 13.0, *)) {
//        statue.frame = [[[UIApplication sharedApplication] windows] firstObject].windowScene.statusBarManager.statusBarFrame;
//        statue.backgroundColor = rgba(0, 71, 56, 1);
//        [self.window addSubview:statue];
//    } else {
//        // Fallback on earlier versions
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    }
}


- (void)sceneDidDisconnect:(UIScene *)scene  API_AVAILABLE(ios(13.0)){
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene  API_AVAILABLE(ios(13.0)){
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    
    EGUserOauthModel *oathModel = [EGLoginUserManager getOauthDataModel];
    if (!oathModel || !oathModel.accessToken || [oathModel.accessToken isEqualToString:@""]) {
        [[EGetTokenViewModel sharedManager] getAuthForOnlyOneCRM:^(BOOL success) {
        }];
    }
    EGRelayTokenModel *tokenModel = [EGLoginUserManager getRelayToken];
    if (!tokenModel) {
        [[EGetTokenViewModel sharedManager] getAuthForOnlyOneCRM:^(BOOL success) {
        }];
    }
    
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"checkEventlistByAppActivty"
//                                                        object:nil
//                                                      userInfo:nil];
    
}


- (void)sceneWillResignActive:(UIScene *)scene  API_AVAILABLE(ios(13.0)){
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene  API_AVAILABLE(ios(13.0)){
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene  API_AVAILABLE(ios(13.0)){
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}

- (void)redirectToTargetViewController:(NSDictionary *)dict
{
    UIWindow *window = self.window;
    UIViewController *rootViewController = window.rootViewController;


    UITabBarController *tabBarController = (EGMainTabBarController *)rootViewController;
    tabBarController.selectedIndex = 1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 获取 EGPointsViewController
        UINavigationController *nav = (UINavigationController *)tabBarController.selectedViewController;
   
        EGPointsViewController *targetVC = nil;
        for (UIViewController *vc in nav.viewControllers) {
            if ([vc isKindOfClass:[EGPointsViewController class]]) {
                targetVC = (EGPointsViewController *)vc;
                break;
            }
        }
        
        if (targetVC) {
            // 如果找到了 EGPointsViewController，将其设置为顶层控制器
            [nav popToViewController:targetVC animated:YES];
            NSString *taskCode = dict[@"task_code"];
            [targetVC triggerFirstCellAction:taskCode];
        }
        
    });

}
@end
