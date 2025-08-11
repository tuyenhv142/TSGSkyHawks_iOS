//
//  EGFunInteractionCell.h
//  EagleBaseballTeam
//
//  Created by Elvin on 2025/6/24.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGFunInteractionCell : UITableViewCell

+(instancetype)cellWithUITableView:(UITableView *)tableView;

@property (nonatomic, copy) void (^clickItemBlock)(NSString *idString);
@end

NS_ASSUME_NONNULL_END
