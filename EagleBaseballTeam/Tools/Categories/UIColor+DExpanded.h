//
//  UIColor+DExpanded.h
//  HomeCommunity
//
//  Created by dragon_zheng on 2024/4/28.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (DExpanded)

+(UIColor *) hexStringToColor: (NSString *) stringToConvert;
+(UIColor *) hexStringToColor: (NSString *) stringToConvert andAlpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
