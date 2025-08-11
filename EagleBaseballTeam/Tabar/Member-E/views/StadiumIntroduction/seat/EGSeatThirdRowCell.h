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

@interface EGSeatThirdRowCell : UITableViewCell

+(instancetype)cellWithUITableView:(UITableView *)tableView;

@property (nonatomic,strong) UIImageView *googleMapView;
@property (nonatomic,strong) UIView *helpLableView;
@property (nonatomic,strong) UILabel *helpTitle; //全票
@property (nonatomic,strong) UILabel *count_Title;//header
@property (nonatomic,strong) UILabel *halfticks_Title;//半票
@property (nonatomic,strong) UILabel *singal_Title;//热区，外野只显示一个数据
@property (nonatomic,strong) UIImageView *line_Title;
@property (nonatomic,copy) showOrHiddenBlcok showOrHiddenBlcok;

@property (nonatomic,assign) NSInteger from_type;//1 is 显示热区，2显示 半票，全票cell

-(void)updaeUI:(NSDictionary*)dic;
@end

NS_ASSUME_NONNULL_END
