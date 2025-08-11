//
//  EGAlertViewHelper.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/3/7.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGAlertViewHelper : NSObject

+ (EGAlertViewHelper *)sharedManager;

/**
 * @bgColor 背景view   1red   2 yellow
 *  title message
 */
-(void)alertViewColor:(NSInteger )type message:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
