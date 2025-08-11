//
//  EGPolicyViewController.h
//  EagleBaseballTeam
//
//  Created by rick on 3/5/25.
//  Copyright © 2025 NewSoft. All rights reserved.
//


NS_ASSUME_NONNULL_BEGIN

typedef void(^clickBottomAgreeBlock)(void);

@interface EGPolicyViewController : UIViewController

/**
 * 0 注册账号转移  1会员隐私  2注册说明
 */
@property (nonatomic,assign) NSInteger type;

@property (nonatomic,copy) clickBottomAgreeBlock agreeBlock;
@end

NS_ASSUME_NONNULL_END
