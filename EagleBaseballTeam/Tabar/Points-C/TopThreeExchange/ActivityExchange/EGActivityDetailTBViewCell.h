//
//  EGActivityDetailTBViewCell.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/4/28.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGActivityDetailTBViewCell : UITableViewCell

+(instancetype)cellWithUITableView:(UITableView *)tableView;

@property (nonatomic,assign)NSDictionary *info;
-(void)updateUI;
@end


@interface ActivityDescriptionTBViewCell : UITableViewCell

+(instancetype)cellWithUITableView:(UITableView *)tableView;

@property (nonatomic,assign)NSDictionary *info;
@property (nonatomic,assign)NSString *address;
@property (nonatomic,assign)NSInteger cell_typ;//0 is  兌換地點, 1 is 使用規則
@property (nonatomic,assign)NSInteger ui_type;
@property (nonatomic,assign) NSInteger stauts;
-(void)updateUI;
@end
NS_ASSUME_NONNULL_END
