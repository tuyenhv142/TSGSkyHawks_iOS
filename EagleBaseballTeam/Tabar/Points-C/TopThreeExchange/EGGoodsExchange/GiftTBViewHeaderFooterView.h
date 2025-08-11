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

@interface GiftTBViewHeaderFooterView : UITableViewHeaderFooterView

+(instancetype)cellHeaderWithUITableView:(UITableView *)tableView;

@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UIButton *arrowBtn;

@property (nonatomic,copy) showOrHiddenBlcok showOrHiddenBlcok;
@end

NS_ASSUME_NONNULL_END
