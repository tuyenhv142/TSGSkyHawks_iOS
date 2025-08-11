//
//  EGLogInTools.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/13.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGLogInTools : NSObject

+ (BOOL)isValidTaiwanMobileNumber:(NSString *)phoneNumber;

+ (NSString *)formatTimeFromSeconds:(NSInteger)seconds;

+ (BOOL)isValidPswdString:(NSString *)inputString;

+ (BOOL)isValidEmailString:(NSString *)inputString;

+ (BOOL)isValidateTaiwanIDString:(NSString *)idNumber;

+ (BOOL)isInvoiceNnumber:(NSString *)input;

@end

NS_ASSUME_NONNULL_END
