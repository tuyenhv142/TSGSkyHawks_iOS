//
//  EGSocialLinksCellTableViewCell.h
//  EagleBaseballTeam
//
//  Created by rick on 1/26/25.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^ EagleSwitchBlock)(BOOL);
@interface EGSortCell : UITableViewCell


@property (nonatomic, copy) EagleSwitchBlock gSwitchBlock;
@property (nonatomic, assign)NSString *cellTitle;

-(void)setTitle:(NSString*)title;
-(void)setCheckstatus:(NSNumber*)sta;
+(instancetype)cellWithUITableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
