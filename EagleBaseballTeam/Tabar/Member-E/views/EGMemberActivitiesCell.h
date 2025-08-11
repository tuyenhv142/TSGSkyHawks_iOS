//
//  EGMemberActivitiesCell.h
//  EagleBaseballTeam
//
//  Created by rick on 1/24/25.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^goAroundCollectionBtnBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface EGMemberActivitiesCell : UITableViewCell
{
    
}
@property (nonatomic,retain)UINavigationController *controller;
@property (nonatomic,copy) goAroundCollectionBtnBlock goAroundBtnBlock;
@property (nonatomic, copy) void (^showliveActivities)(void);

+(instancetype)cellWithUITableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
