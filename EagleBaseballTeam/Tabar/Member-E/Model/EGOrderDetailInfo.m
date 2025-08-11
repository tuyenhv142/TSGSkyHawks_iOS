#import "EGOrderDetailInfo.h"

@implementation EGOrderProductInfo
@end


@implementation EGOrderDetailInfo

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

@end




// 订单详情模型 =- 现场消费
@implementation OrderDetailModel


@end
