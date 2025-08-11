//
//  EGActivityExchangeTBViewCell.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/4/27.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGActivityExchangeTBViewCell : UITableViewCell

+(instancetype)cellWithUITableView:(UITableView *)tableView;

@property (nonatomic, assign) NSDictionary *info;
-(void)updateUI;
@end

NS_ASSUME_NONNULL_END
