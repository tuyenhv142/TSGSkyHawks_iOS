//
//  EGMemberInfoModel.h
//  EagleBaseballTeam
//
//  Created by rick on 2/17/25.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGMemberTierModel : NSObject

@property (nonatomic, copy ) NSString *TierId;
@property (nonatomic, copy ) NSString *Reason;
@property (nonatomic, copy ) NSString *ExpirationDate;
@property (nonatomic, copy ) NSString *TierGroupId;
@property (nonatomic, copy ) NSString *EffectiveDate;
@property (nonatomic, copy ) NSString *TierName;
@property (nonatomic, copy ) NSString *TierSeq;
@property (nonatomic, copy ) NSString *BenefitsAssigned;
@end


@interface EGMemberInfoModel : NSObject

@property (nonatomic, copy ) NSString *Code;
@property (nonatomic, copy ) NSString *TotalPointsExpired;
@property (nonatomic, copy ) NSString *NextTokenExpiredDate;
@property (nonatomic, copy ) NSString *CreatedAt;
@property (nonatomic, copy ) NSString *LockedPoints;
@property (nonatomic, copy ) NSString *TotalPointsEarned;

@property (nonatomic, copy ) NSString *UpdatedAt;
@property (nonatomic, copy ) NSString *Name;
@property (nonatomic, copy ) NSString *Gender;
@property (nonatomic, strong) NSArray *MemberCards;
@property (nonatomic, strong) EGMemberTierModel *MemberTier;

@property (nonatomic, assign ) NSInteger Points;
@property (nonatomic, copy ) NSString *Birthday;
@property (nonatomic, copy ) NSString *TotalPointsWillExpired;
@property (nonatomic, copy ) NSString *Email;
@property (nonatomic, copy ) NSString *Id;
@property (nonatomic, copy ) NSString *Phone;
@property (nonatomic, strong) NSArray *Coupon;
@property (nonatomic, copy ) NSString *UserId;
@property (nonatomic, copy ) NSString *LineId;
@property (nonatomic, copy ) NSString *TotalPointsRedeemed;

@end
NS_ASSUME_NONNULL_END
