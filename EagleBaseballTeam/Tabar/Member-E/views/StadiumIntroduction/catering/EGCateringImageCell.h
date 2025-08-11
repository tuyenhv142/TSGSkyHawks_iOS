//
//  GiftTBViewHeaderFooterView.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/4/28.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSSegmentedControl.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^CateringBlcok)(NSInteger type);

@interface EGCateringImageCell : UITableViewCell<MSSegmentedControlDelegate>

+(instancetype)cellWithUITableView:(UITableView *)tableView;

@property (nonatomic,strong) UIImageView *googleMapView;//Image base全图
@property (nonatomic,strong) UIView *helpLableView;
@property (nonatomic, strong)MSSegmentedControl *scontr;
@property (nonatomic, copy) CateringBlcok block_catering;
@end

NS_ASSUME_NONNULL_END
