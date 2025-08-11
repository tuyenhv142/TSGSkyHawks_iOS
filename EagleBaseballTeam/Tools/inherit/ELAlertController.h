//
//  ELAlertController.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/3/11.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^CancelButtonBlock)(UIAlertAction *cancelAction);
typedef void (^SureButtonBlock)(UIAlertAction *SureAction);


@interface ELAlertController : UIAlertController

@property(nonatomic,copy) CancelButtonBlock cancelBlock;
@property(nonatomic,copy) SureButtonBlock SureBlock;

+ (void)alertControllerWithTitleName:(NSString*)titleName andMessage:(NSString*)message cancelButtonTitle:(NSString*_Nullable)cancelTitle confirmButtonTitle:(NSString*)confirmTitle showViewController:(UIViewController*)currentVC addCancelClickBlock:(CancelButtonBlock)cancelBlock addConfirmClickBlock:(SureButtonBlock)SureBlock;

@end

NS_ASSUME_NONNULL_END
