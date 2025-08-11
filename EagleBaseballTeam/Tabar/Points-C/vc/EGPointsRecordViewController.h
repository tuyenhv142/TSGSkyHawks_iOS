//
//  EGPointsRecordViewController.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/8.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface EGPointsRecordViewController : EGBaseViewController
@property (nonatomic, strong) NSMutableArray *pointList;
@property (nonatomic, assign) NSInteger totalpoint; //点数总计

@end


@interface PointsRecordTBVCell : UITableViewCell

+(instancetype)cellWithUITableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
