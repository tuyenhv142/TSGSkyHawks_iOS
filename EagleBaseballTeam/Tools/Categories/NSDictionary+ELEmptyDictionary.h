//
//  NSDictionary+ELEmptyDictionary.h
//  YLWirelessFleetPassenger
//
//  Created by dragon_zheng on 2024/3/15.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (ELEmptyDictionary)
/**
 字典取值判空
 */
- (id)objectOrNilForKey:(id)akey;


- (id)objectIsNilReturnSteForKey:(id)akey;
@end

NS_ASSUME_NONNULL_END
