//
//  GiftTBViewHeaderFooterView.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/4/28.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^showOrHiddenBlcok)(BOOL showHidden);

@interface EGSeatFirstRowCell : UITableViewCell

+(instancetype)cellWithUITableView:(UITableView *)tableView;

@property (nonatomic,strong) UIImageView *googleMapView;
@property (nonatomic,strong) UIView *helpLableView;
@property (nonatomic,strong) UILabel *helpTitle;

@property (nonatomic,copy) showOrHiddenBlcok showOrHiddenBlcok;

-(void)updateUI:(NSDictionary*)info row:(NSInteger)row_index type:(NSInteger)changditype;
@end

NS_ASSUME_NONNULL_END
