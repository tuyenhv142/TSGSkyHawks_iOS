//
//  EGMessageModel.m
//  EagleBaseballTeam
//
//  Created by Elvin on 2025/6/23.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGMessageModel.h"

@implementation EGMessageModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _ID = value;
    }
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}
@end
