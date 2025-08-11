//
//  EGMemberInfoViewController.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/15.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^MemberInfomationChangeBlock)(NSString *invoice_number);

@interface EGMemberInfoViewController : EGBaseViewController

@property (nonatomic,copy) MemberInfomationChangeBlock infomationBlock;
@end

NS_ASSUME_NONNULL_END
