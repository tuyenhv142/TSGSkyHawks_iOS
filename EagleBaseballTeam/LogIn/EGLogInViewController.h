//
//  EGLogInViewController.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/7.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^UserLogInSuccessBlock)(void);

@interface EGLogInViewController : UIViewController

@property (nonatomic,copy) UserLogInSuccessBlock logInBlock;
@end

NS_ASSUME_NONNULL_END
