//
//  EGPointsViewController.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/7.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EGTaskManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface EGPointsViewController : EGBaseViewController

@property (nonatomic, strong) NSString *taskCode;

@property (nonatomic, strong) UICollectionView *limitedTasksCollectionView;
@property (nonatomic, strong) UICollectionView *memberTasksCollectionView;
//@property (nonatomic,weak) UITableView *tableView;

//- (void)taskCell:(UICollectionViewCell *)cell didClickStateButtonAtIndexPath:(NSIndexPath *)indexPath;
//- (void)listTBCell:(UITableViewCell *)cell didClickStateButtonAtIndexPath:(NSIndexPath *)indexPath;

- (void)triggerFirstCellAction:(NSString *)taskCode;
@end

NS_ASSUME_NONNULL_END
