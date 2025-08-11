//
//  GiftTBViewHeaderFooterView.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/4/28.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^MapBlcok)(NSInteger indext);

@interface EGParkContentCell : UITableViewCell

+(instancetype)cellWithUITableView:(UITableView *)tableView;

@property (nonatomic,strong) UIView *parkTitle_View;
@property (nonatomic,strong) UILabel *park_title;//Title
@property (nonatomic,strong) UILabel *park_count;//停车数量
@property (nonatomic,copy) MapBlcok sendTo;

-(void)updaeUI:(NSDictionary*)info status:(BOOL)is_click;
@end

NS_ASSUME_NONNULL_END
