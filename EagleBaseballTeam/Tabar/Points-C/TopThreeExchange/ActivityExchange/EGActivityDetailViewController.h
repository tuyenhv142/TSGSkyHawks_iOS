//
//  EGActivityDetailViewController.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/4/28.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface EGActivityDetailViewController : EGBaseViewController

@property (nonatomic, assign) NSInteger points;
@property (nonatomic, strong) NSDictionary* info;
@property (nonatomic, assign) NSInteger from_type;//0 is from 活动界面  1 is from 活动记录界面
@property (nonatomic, assign) NSInteger status;//已使用，未使用
@property (nonatomic, assign) NSString* qrcode_string;
@property (nonatomic, copy) NSString* activty_id;//推波界面传过来的  id
-(void)updateUI;
@end

NS_ASSUME_NONNULL_END
