//
//  SceneDelegate.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/1/20.
//

#import <UIKit/UIKit.h>

@interface SceneDelegate : UIResponder <UIWindowSceneDelegate>

@property (strong, nonatomic) UIWindow * window;

- (void)redirectToTargetViewController:(NSDictionary *)dict;
@end

