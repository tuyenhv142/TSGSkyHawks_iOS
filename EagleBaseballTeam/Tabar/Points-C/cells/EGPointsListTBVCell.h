//
//  EGPointsListTBVCell.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/8.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EGPointsListTBVCellDelegate <NSObject>
- (void)listTBCell:(UITableViewCell *_Nullable)cell didClickStateButtonAtIndexPath:(NSIndexPath *_Nullable)indexPath;
@end

NS_ASSUME_NONNULL_BEGIN

@interface EGPointsListTBVCell : UITableViewCell

@property (nonatomic, weak) id<EGPointsListTBVCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

+(instancetype)cellWithUITableView:(UITableView *)tableView;

-(void)setModeInfo:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
