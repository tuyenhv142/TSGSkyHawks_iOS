//
//  EGMemberInfoTBHFooterView.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/17.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGMemberInfoTBHFooterView : UITableViewHeaderFooterView

@property (nonatomic,strong) UILabel *titleLabel;

+(instancetype)headerViewWithTableView:(UITableView*)tableView;

@end

NS_ASSUME_NONNULL_END
