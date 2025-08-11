//
//  EGActivityMegTableViewCell.h
//  EagleBaseballTeam
//
//  Created by Elvin on 2025/6/11.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EGMessageModel;
NS_ASSUME_NONNULL_BEGIN

@interface EGActivityMegTableViewCell : UITableViewCell

+(instancetype)cellWithUITableView:(UITableView *)tableView;

@property (nonatomic, strong) EGMessageModel *activityModel;
@end



@interface NotificationTBVCell : UITableViewCell

+(instancetype)cellWithUITableView:(UITableView *)tableView;

@property (nonatomic, strong) EGMessageModel *systemModel;

@end

NS_ASSUME_NONNULL_END
