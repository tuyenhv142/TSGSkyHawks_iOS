//
//  EGMemberCardCell.h
//  EagleBaseballTeam
//
//  Created by rick on 1/24/25.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface EGTeamperformanceCell : UITableViewCell

+(instancetype)cellWithUITableView:(UITableView *)tableView;
- (void)setupWithInfo:(NSDictionary *)info;
@property (nonatomic, retain)NSDictionary *sendDic;

@end

NS_ASSUME_NONNULL_END
