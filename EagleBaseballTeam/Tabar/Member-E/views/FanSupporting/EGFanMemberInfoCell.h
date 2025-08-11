//
//  EGMemberCardCell.h
//  EagleBaseballTeam
//
//  Created by dragon on 1/24/25.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^ EGFansInfoblock)(NSMutableDictionary * _Nullable params,NSInteger type);


@interface EGFanMemberInfoCell : UITableViewCell

+(instancetype)cellWithUITableView:(UITableView *)tableView;
- (void)setupWithInfo:(NSDictionary *)info;
@property (nonatomic, retain)NSMutableDictionary *sendDic;
@property (nonatomic, copy) EGFansInfoblock fansInfoBlock;

@end

NS_ASSUME_NONNULL_END
