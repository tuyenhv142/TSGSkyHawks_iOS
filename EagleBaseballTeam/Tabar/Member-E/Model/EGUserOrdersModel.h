//
//  EGUserOrdersModel.h
//  EagleBaseballTeam
//
//  Created by rick on 2/18/25.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGimageModel : NSObject
//@property (nonatomic, copy ) NSString *id;
@property (nonatomic, copy ) NSString *src;
@end

@interface EGLineItemModel : NSObject

//@property (nonatomic, copy ) NSString *ID;
@property (nonatomic, copy ) NSString *quantity;
//@property (nonatomic, copy ) NSString *tax_class;
//@property (nonatomic, copy ) NSString *subtotal_tax;
//@property (nonatomic, strong) NSArray *meta_data;
//@property (nonatomic, copy ) NSString *parent_name;
@property (nonatomic, copy ) NSString *total;
//@property (nonatomic, copy ) NSString *total_tax;
//@property (nonatomic, copy ) NSString *sku;
@property (nonatomic, copy ) NSString *subtotal;
@property (nonatomic, copy ) NSString *price;
@property (nonatomic, strong) EGimageModel *image;
//@property (nonatomic, copy ) NSString *product_id;
//@property (nonatomic, strong) NSArray *taxes;
//@property (nonatomic, copy ) NSString *variation_id;
@property (nonatomic, copy ) NSString *name;

@end

@interface EGUserOrdersModel : NSObject
@property (nonatomic, copy ) NSString *ID;
@property (nonatomic, copy ) NSString *date_created;
@property (nonatomic, copy ) NSString *total; //金额总数
@property (nonatomic, assign ) BOOL prices_include_tax;

@property (nonatomic, copy ) NSArray<EGLineItemModel *> *line_items; //订单内容 name 获取订单名称
@property (nonatomic, copy ) NSArray<NSDictionary *> *shipping_lines; //运单，取total 代表运费
@property (nonatomic, copy ) NSArray<NSDictionary *> *meta_data; //th_points_get th_points_use


@end


@interface OrderHistoryModel : NSObject
@property (nonatomic, copy ) NSString *CheckoutTime;
@property (nonatomic, copy ) NSString *OrderId;
@property (nonatomic, copy ) NSString *ShopName;
@property (nonatomic, copy ) NSString *PurchasedItem;
@property (nonatomic, assign ) double TotalPrice;
@end


NS_ASSUME_NONNULL_END
