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

@interface EGStadiumViewHeaderFooterView : UITableViewCell<GMSMapViewDelegate>

+(instancetype)cellWithUITableView:(UITableView *)tableView;

@property (nonatomic,strong) UILabel *helptitleLb0;
@property (nonatomic,strong) UILabel *helptitleLb1;
@property (nonatomic,strong) UILabel *helptitleLb2;
@property (nonatomic,strong) UILabel *helptitleLb3;
@property (nonatomic,strong) UIImageView *helpView0;
@property (nonatomic,strong) UIImageView *helpView1;
@property (nonatomic,strong) UIImageView *helpView2;
@property (nonatomic,strong) UIImageView *helpView3;

@property (nonatomic,strong) UIButton *arrowBtn;

@property (nonatomic,strong) UIImageView *googleMapView;
@property (nonatomic,strong) UIView *helpLableView;
@property (nonatomic,strong) GMSMapView* mapView;
@property (nonatomic, strong) GMSMarker *googleMapAddressicon_marker;
@property (nonatomic,strong) UIImageView *googleMapAddressicon_View;

@property (nonatomic,copy) showOrHiddenBlcok showOrHiddenBlcok;
@end

NS_ASSUME_NONNULL_END
