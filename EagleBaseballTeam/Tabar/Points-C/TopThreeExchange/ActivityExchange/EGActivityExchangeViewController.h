//
//  EGActivityExchangeViewController.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/4/27.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface EGActivityExchangeViewController : EGBaseViewController

@property (nonatomic, assign) NSInteger points;
@property (nonatomic, assign) NSInteger sort_type;//0 is sort by date 降序 1 is sort by date 升序 2 is sort by point 降序
@end

NS_ASSUME_NONNULL_END
