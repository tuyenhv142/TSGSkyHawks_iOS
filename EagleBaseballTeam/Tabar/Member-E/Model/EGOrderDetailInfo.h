#import <Foundation/Foundation.h>

// 商品项模型
@interface EGOrderProductInfo : NSObject

@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *quantity; //数量

@end

//// 订单金额信息模型
//@interface EGOrderAmountInfo : NSObject
//
//@property (nonatomic, copy) NSString *subtotal;        // 小计
//@property (nonatomic, copy) NSString *bonusUsed;       // 使用红利点数
//@property (nonatomic, copy) NSString *bonusEarned;     // 获得红利点数
//@property (nonatomic, copy) NSString *shippingFee;     // 运费
//@property (nonatomic, copy) NSString *totalAmount;     // 总金额
//
//@end

// 订单详情模型
@interface EGOrderDetailInfo : NSObject

@property (nonatomic, copy) NSString *orderId;         // 订单编号
//@property (nonatomic, copy) NSString *orderDate;       // 订单日期
@property (nonatomic, strong) NSMutableArray<EGOrderProductInfo *> *products;  // 商品列表
//@property (nonatomic, strong) EGOrderAmountInfo *amountInfo;  // 金额信息
@property (nonatomic, copy) NSString *subtotal;        // 小计
@property (nonatomic, copy) NSString *bonusUsed;       // 使用红利点数
@property (nonatomic, copy) NSString *bonusEarned;     // 获得红利点数
@property (nonatomic, copy) NSString *shippingFee;     // 运费
@property (nonatomic, copy) NSString *totalAmount;     // 总金额

@end



// 订单详情模型 =- 现场消费
@interface OrderDetailModel : NSObject

@property (nonatomic, copy) NSString *ItemName;

@property (nonatomic, assign) NSInteger ItemPrice;
@property (nonatomic, assign) NSInteger ItemCount;

//ItemCount = 1;
//ItemId = 67f4a66171fa4e64c7efd136;
//ItemName = "\U7fe0\U7389\U70cf\U9f8d";
//ItemPrice = 1000;
//SMCSubItem =                     (
//);
//SMComponetCount = "";
//SetMealCount = "";
//SetMealId = "";
//SetMealName = "";
//SetMealPrice = "";
//SubItem =                     (
//);

@end

