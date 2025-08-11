//
//  EGUserOauthModel.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/13.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGUserOauthModel.h"

@implementation EGUserOauthModel

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


@implementation EGRelayTokenModel

@end


@implementation UserInfomationModel

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



@implementation MemberInfomationModel
//将没有的key 转换为空字串
- (void)mj_didConvertToObjectWithKeyValues:(NSDictionary *)keyValues{
   // NSLog(@"mj_didConvertToObjectWithKeyValues");
    Class clazz = [self class];
    [clazz mj_enumerateProperties:^(MJProperty *property, BOOL *stop) {
        id value = [property valueForObject:self];
        
        Class propertyClass = property.type.typeClass;
        if (value == nil) {
            if (propertyClass == [NSString class]) {
                [self setValue:@"" forKey:property.name];
               // [keyValues setValue:@"" forKey:property.name];
            }else if(propertyClass == [NSNumber class]){
                [self setValue:@(0) forKey:property.name];
//                [keyValues setValue:@(0) forKey:property.name];
            }
            //自行进行其他类型的匹配处理
        }
    }];
}

- (void)mj_objectDidConvertToKeyValues:(NSDictionary *)keyValues{

    //NSLog(@"mj_objectDidConvertToKeyValues");
    Class clazz = [self class];
    
    [clazz mj_enumerateProperties:^(MJProperty *property, BOOL *stop) {
        id value = [property valueForObject:self];
        
        Class propertyClass = property.type.typeClass;
        if (value == nil) {
            if (propertyClass == [NSString class]) {
                [keyValues setValue:@"" forKey:property.name];
            }else if(propertyClass == [NSNumber class]){
                [keyValues setValue:@(0) forKey:property.name];
            }
            //自行进行其他类型的匹配处理
            
        }
    }];
}
@end
@implementation NewsoftExtraData
@end
