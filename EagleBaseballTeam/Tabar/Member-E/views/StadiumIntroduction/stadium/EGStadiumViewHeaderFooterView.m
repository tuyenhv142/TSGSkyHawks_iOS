//
//  GiftTBViewHeaderFooterView.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/4/28.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGStadiumViewHeaderFooterView.h"

@implementation EGStadiumViewHeaderFooterView

+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"EGStadiumViewHeaderFooterView";
    EGStadiumViewHeaderFooterView *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
          cell = [[EGStadiumViewHeaderFooterView alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//cell选中无色

    return cell;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        {
            self.contentView.backgroundColor = ColorRGB(0xF5F5F5);
            
            double E = 22.655577;
            double N = 120.360034;
            
            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:E longitude:N zoom:14];
            self.mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, ScaleW(335), ScaleW(180)) camera:camera];
            [self.mapView animateToCameraPosition:camera];
            self.mapView.layer.cornerRadius = 10.0f;
            self.mapView.layer.masksToBounds = YES;
            self.mapView.delegate = self;
            self.mapView.settings.compassButton = YES;
            self.mapView.myLocationEnabled = NO;
            self.mapView.trafficEnabled = YES;
            self.mapView.mapType = kGMSTypeNormal;
            [self.contentView addSubview:self.mapView];
            [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.contentView.mas_centerX);
                make.top.mas_equalTo(ScaleW(0));
                make.width.mas_equalTo(ScaleW(345));
                make.height.mas_equalTo(ScaleW(220));
            }];
            
            
            _googleMapAddressicon_View = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(25), ScaleW(25))];
            _googleMapAddressicon_View.contentMode = UIViewContentModeScaleAspectFit;
            _googleMapAddressicon_View.image = [UIImage imageNamed:@"room"];
            CLLocationCoordinate2D position2D = CLLocationCoordinate2DMake(E,N);
            self.googleMapAddressicon_marker = [GMSMarker markerWithPosition:position2D];
            self.googleMapAddressicon_marker.iconView = _googleMapAddressicon_View;
            self.googleMapAddressicon_marker.map = self.mapView;
            
        }
    }
    return self;
}


-(void)clickArrowBtn:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (self.showOrHiddenBlcok) {
        self.showOrHiddenBlcok(btn.selected);
    }
}
@end
