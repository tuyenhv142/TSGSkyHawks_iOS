//
//  EGPointsModel.h
//  EagleBaseballTeam
//
//  Created by rick on 2/25/25.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGPointsModel : NSObject
@property (nonatomic, copy ) NSString *CreditedAt;
@property (nonatomic, copy ) NSString *Description;
@property (nonatomic, copy ) NSString *Id;
@property (nonatomic, copy ) NSString *CheckoutTime;
@property (nonatomic, copy ) NSString *UUID;
@property (nonatomic, copy ) NSString *Type;
@property (nonatomic, copy ) NSString *Status;
@property (nonatomic, copy ) NSString *OrderId;
@property (nonatomic, copy ) NSString *ShopName;
@property (nonatomic, copy ) NSString *Invoice;
@property (nonatomic, assign ) NSInteger Points;
@property (nonatomic, copy ) NSString *ExpiredAt;
@end

NS_ASSUME_NONNULL_END
