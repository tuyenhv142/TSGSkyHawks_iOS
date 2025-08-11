//
//  EGiftDetailTableViewCell.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/4/29.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGiftDetailTableViewCell : UITableViewCell

+(instancetype)cellWithUITableView:(UITableView *)tableView;

@property (nonatomic,assign)NSDictionary* info;
@property (nonatomic,assign)NSInteger from_type;
@property (nonatomic,assign)NSInteger currentIndex;
@property (nonatomic,assign)NSArray* image_array;
-(void)updateUI;
@end


@interface LeftRightLBTableViewCell : UITableViewCell

+(instancetype)cellWithUITableView:(UITableView *)tableView;

@property (nonatomic,strong) UILabel *leftLb;
@property (nonatomic,strong) UILabel *rightLb;
@end

NS_ASSUME_NONNULL_END
