//
//  GiftTBViewHeaderFooterView.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/4/28.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGParkViewHeaderFooterView.h"

@implementation EGParkViewHeaderFooterView

+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"EGParkViewHeaderFooterView";
    EGParkViewHeaderFooterView *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
          cell = [[EGParkViewHeaderFooterView alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class

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
            
        }
    }
    return self;
}

-(void)updateGoogeMap
{
    //set icon in map view
    NSMutableString *icon_string = [NSMutableString new];
    [self.mapView clear];
    for(int i=0;i<self.E_N_Array.count;i++)
    {
        NSDictionary *dic = [self.E_N_Array objectAtIndex:i];
        double latitude = [[dic objectForKey:@"section_E"] doubleValue];
        double longitude = [[dic objectForKey:@"section_N"] doubleValue];
        BOOL selected = [[dic objectForKey:@"section_status"] boolValue];
        NSArray* array = [dic objectForKey:@"section_content"];//取section_content第一个节点，拿row_park_status
        NSNumber *park = [array objectAtIndex:0][@"row_park_status"];
        
        [icon_string setString:@""];
        switch ([park intValue]) {
            case 0:
            {
                //绿色图标
                [icon_string appendString:@"park_green_"];
            }
                break;
                
            case 1:
            {
                //huangse图标
                [icon_string appendString:@"park_yellow_"];
                
            }
                break;
            case 2:
            {
                //灰色图标
                [icon_string appendString:@"park_gray_"];
            }
                break;
            case 3:
            {
                //红色图标
                [icon_string appendString:@"park_red_"];
            }
                break;
        }
        
        if(selected)
        {
            _googleMapAddressicon_View = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(25), ScaleW(25))];
            _googleMapAddressicon_View.contentMode = UIViewContentModeScaleAspectFit;
            [icon_string appendString:@"L.png"];
            _googleMapAddressicon_View.image = [UIImage imageNamed:icon_string];
        }
            else
            {
                _googleMapAddressicon_View = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(16), ScaleW(16))];
                _googleMapAddressicon_View.contentMode = UIViewContentModeScaleAspectFit;
                [icon_string appendString:@"S.png"];
                _googleMapAddressicon_View.image = [UIImage imageNamed:icon_string];
            }
            
        
            CLLocationCoordinate2D position2D = CLLocationCoordinate2DMake(latitude,longitude);
            self.googleMapAddressicon_marker = [GMSMarker markerWithPosition:position2D];
            self.googleMapAddressicon_marker.iconView = _googleMapAddressicon_View;
            self.googleMapAddressicon_marker.map = self.mapView;
        
            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude longitude:longitude zoom:14];
            [self.mapView animateToCameraPosition:camera];
    }
}

-(NSInteger)getIndextfromMapView:(NSString*)latitude_String N:(NSString*)longitude_String
{
    NSInteger index = 0;
    for(int i=0;i<self.E_N_Array.count;i++)
    {
        NSDictionary *dic = [self.E_N_Array objectAtIndex:i];
        if([latitude_String isEqualToString:[dic objectForKey:@"section_E"]]
           &&[longitude_String isEqualToString:[dic objectForKey:@"section_N"]])
        {
            index = i;
            break;
        }
    }
    
    return index;
}

#pragma mark ---
- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture
{
    //ELog(@"%@1position:%d",NSStringFromSelector(_cmd),gesture);
}
- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position
{
    //ELog(@"%@3position:%@",NSStringFromSelector(_cmd),position);
    
}
- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    //ELog(@"%@4coordinate:%f-%f",NSStringFromSelector(_cmd),coordinate.latitude,coordinate.longitude);
}
//点击map自己添加的回调
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    NSString *latitudeString = [NSString stringWithFormat:@"%f",marker.position.latitude];
    NSString *longitudeString = [NSString stringWithFormat:@"%f",marker.position.longitude];
    NSInteger selected = [self getIndextfromMapView:latitudeString N:longitudeString];
    if (self.sendTo) {
        self.sendTo(selected);
    }
//    NSDictionary *locationDict = @{@"Latitude":latitudeString,@"Longitude":longitudeString};
//    ELog(@"5snippet---%@",locationDict);
    return NO;
}
//点击map随意某处回调
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSString *latitudeString = [NSString stringWithFormat:@"%f",coordinate.latitude];
    NSString *longitudeString = [NSString stringWithFormat:@"%f",coordinate.longitude];
    NSDictionary *locationDict = @{@"Latitude":latitudeString,@"Longitude":longitudeString};
    //ELog(@"%@coordinate------%@",NSStringFromSelector(_cmd),locationDict);
}




@end
