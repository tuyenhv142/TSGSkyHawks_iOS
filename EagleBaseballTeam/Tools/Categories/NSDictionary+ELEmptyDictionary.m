//
//  NSDictionary+ELEmptyDictionary.m
//  YLWirelessFleetPassenger
//
//  Created by dragon_zheng on 2024/3/15.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import "NSDictionary+ELEmptyDictionary.h"

@implementation NSDictionary (ELEmptyDictionary)

- (id)objectOrNilForKey:(id)akey
{
    id object = [self objectForKey:akey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


- (id)objectIsNilReturnSteForKey:(id)akey
{
    id object = [self objectForKey:akey];
    return [object isEqual:[NSNull null]] ? @"" : object;
}
@end
