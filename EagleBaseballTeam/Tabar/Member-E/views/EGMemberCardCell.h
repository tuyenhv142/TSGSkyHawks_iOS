//
//  EGMemberCardCell.h
//  EagleBaseballTeam
//
//  Created by rick on 1/24/25.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EGMemberCardCellDelegate <NSObject>
@optional
- (void)didTapConsumptionRecord;
- (void)didTapMembershipCard;
@end

@interface EGMemberCardCell : UITableViewCell
@property (nonatomic, weak) id<EGMemberCardCellDelegate> delegate;
@property (nonatomic, copy) void (^showBarcodeBlock)(void);
@property (nonatomic, weak) UIButton *barcodeButton;

+(instancetype)cellWithUITableView:(UITableView *)tableView;
- (void)setupWithInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
