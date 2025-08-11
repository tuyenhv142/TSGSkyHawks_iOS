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

@interface EGSeatSecondRowCell : UITableViewCell

+(instancetype)cellWithUITableView:(UITableView *)tableView;

@property (nonatomic,strong) UIImageView *googleMapView;
@property (nonatomic,strong) UIView *helpLableView;
@property (nonatomic,strong) UILabel *helpTitle; //热区
@property (nonatomic,strong) UILabel *city_Title;
@property (nonatomic,strong) UILabel *allticks_Title;
@property (nonatomic,strong) UILabel *halfticks_Title;
@property (nonatomic,strong) UIImageView *line_Title;

@property (nonatomic,copy) showOrHiddenBlcok showOrHiddenBlcok;

@property (nonatomic,assign) NSInteger from_type;//1 is 显示热区，2显示 半票，全票cell

-(void)updaeUI:(NSDictionary*)dic;
@end

NS_ASSUME_NONNULL_END
