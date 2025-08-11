//
//  MBProgressHUD+ELAddMB.h
//  MobileCaptureDemo
//
//  Created by dragon_zheng on 2023/12/5.
//

#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (ELAddMB)

+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

/**
 纯文本 需要手动消失
 */
+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (void)hideHUD;

/**
 纯文本 2秒后自动消失
 */
+ (MBProgressHUD *)showDelayHidenMessage:(NSString *)message;
+ (MBProgressHUD *)showDelayHidenMessageNoImage:(NSString *)message;

/**
 带菊花
 */
+ (MBProgressHUD *)showIndeterminateDelayHidenMessage:(NSString *)message;
@end

NS_ASSUME_NONNULL_END
