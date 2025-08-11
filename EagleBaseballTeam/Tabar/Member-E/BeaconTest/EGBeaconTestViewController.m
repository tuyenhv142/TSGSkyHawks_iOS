//
//  EGBeaconTestViewController.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/3/15.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGBeaconTestViewController.h"

#import <CoreLocation/CoreLocation.h>
#import "EGBeaconInfoView.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface EGBeaconTestViewController ()<CLLocationManagerDelegate,CBCentralManagerDelegate,GMSMapViewDelegate>

@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray<CLBeaconRegion *> *beaconRegions;
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) UILabel *infomationLable;
@property (nonatomic, strong) UILabel *infomationLableNear;
@property (nonatomic, strong) UILabel *infomationLableFar;


@property (nonatomic, strong) GMSMapView *mapView;
@property (nonatomic, strong) GMSMarker *marker;
@end

@implementation EGBeaconTestViewController

- (UILabel *)infomationLable
{
    if (!_infomationLable) {
        _infomationLable = [UILabel new];
        _infomationLable.backgroundColor = [UIColor whiteColor];
        _infomationLable.layer.masksToBounds = true;
        _infomationLable.layer.cornerRadius = 10;
        _infomationLable.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightBold];
        _infomationLable.textColor = [UIColor blackColor];
        _infomationLable.numberOfLines = 0;
    }
    return _infomationLable;
}

- (UILabel *)infomationLableNear
{
    if (!_infomationLableNear) {
        _infomationLableNear = [UILabel new];
        _infomationLableNear.backgroundColor = [UIColor whiteColor];
        _infomationLableNear.layer.masksToBounds = true;
        _infomationLableNear.layer.cornerRadius = 10;
        _infomationLableNear.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightBold];
        _infomationLableNear.textColor = [UIColor blackColor];
        _infomationLableNear.numberOfLines = 0;
    }
    return _infomationLableNear;
}

- (UILabel *)infomationLableFar
{
    if (!_infomationLableFar) {
        _infomationLableFar = [UILabel new];
        _infomationLableFar.backgroundColor = [UIColor whiteColor];
        _infomationLableFar.layer.masksToBounds = true;
        _infomationLableFar.layer.cornerRadius = 10;
        _infomationLableFar.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightBold];
        _infomationLableFar.textColor = [UIColor blackColor];
        _infomationLableFar.numberOfLines = 0;
    }
    return _infomationLableFar;
}


-(void)locationAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    [self handleLocationAuthorizationStatus:status];
    
}
- (void)handleLocationAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            // 未决定状态，请求权限
            [self.locationManager requestWhenInUseAuthorization];
            break;
            
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways:
            // 已有权限，开始定位
            [self startLocationServices];
            break;
            
        default:
            // 处理其他状态（拒绝、受限等）
            [self handleLocationAccessDenied];
            break;
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    [self handleLocationAuthorizationStatus:status];
}
- (void)startLocationServices {
    // 开始定位相关服务
    [self.locationManager startUpdatingLocation];
}

- (void)handleLocationAccessDenied {
    // 处理权限被拒绝的情况
    // 例如显示提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"定位权限" message:@"您的定位权限被限制不可用请在设置中修改" preferredStyle:UIAlertControllerStyleAlert];
     UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
         [self.navigationController popViewControllerAnimated:true];
       }];
     UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
         if([[UIApplication sharedApplication] canOpenURL:url]){
             [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
             }];
         }
     }];
     [alert addAction:cancleAction];
     [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:34 longitude:108 zoom:14];
    self.mapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    self.mapView.delegate = self;
    self.mapView.settings.compassButton = YES;
    self.mapView.myLocationEnabled = NO;
    self.mapView.trafficEnabled = YES;
    self.mapView.mapType = kGMSTypeNormal;
    [self.view addSubview:self.mapView];
    
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    bgImageView.contentMode = UIViewContentModeScaleAspectFit;
    bgImageView.image = [UIImage imageNamed:@"parachute"];
    
    [self.marker.map clear];
    CLLocationCoordinate2D position2D = CLLocationCoordinate2DMake(34,108);
    self.marker = [GMSMarker markerWithPosition:position2D];
    self.marker.iconView = bgImageView;
    self.marker.map = self.mapView;
    
}
#pragma mark ---
- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture
{
    ELog(@"%@1position:%d",NSStringFromSelector(_cmd),gesture);
}
- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position
{
    ELog(@"%@3position:%@",NSStringFromSelector(_cmd),position);
    
}
- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    ELog(@"%@4coordinate:%f-%f",NSStringFromSelector(_cmd),coordinate.latitude,coordinate.longitude);
}
//点击map自己添加的回调
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    NSString *latitudeString = [NSString stringWithFormat:@"%f",marker.position.latitude];
    NSString *longitudeString = [NSString stringWithFormat:@"%f",marker.position.longitude];
    NSDictionary *locationDict = @{@"Latitude":latitudeString,@"Longitude":longitudeString};
    
    ELog(@"5snippet---%@",locationDict);
    return NO;
}
//点击map随意某处回调
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSString *latitudeString = [NSString stringWithFormat:@"%f",coordinate.latitude];
    NSString *longitudeString = [NSString stringWithFormat:@"%f",coordinate.longitude];
    NSDictionary *locationDict = @{@"Latitude":latitudeString,@"Longitude":longitudeString};
    ELog(@"%@coordinate------%@",NSStringFromSelector(_cmd),locationDict);
}


-(void)sssds
{
    self.navigationItem.title = @"進場藍牙設定檢測";
    self.view.backgroundColor = rgba(243, 243, 243, 1);
    
    [self locationAuthorization];
    
    [self.view addSubview:self.infomationLable];
    [self.infomationLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([UIDevice de_navigationFullHeight] + 20);
        make.left.mas_equalTo(ScaleW(20));
        make.width.mas_equalTo(Device_Width-ScaleW(40));
        make.height.mas_equalTo(ScaleW(180));
    }];
    
    [self.view addSubview:self.infomationLableNear];
    [self.infomationLableNear mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infomationLable.mas_bottom).offset(ScaleW(20));
        make.left.mas_equalTo(ScaleW(20));
        make.width.mas_equalTo(Device_Width-ScaleW(40));
        make.height.mas_equalTo(ScaleW(180));
    }];
    
    [self.view addSubview:self.infomationLableFar];
    [self.infomationLableFar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infomationLableNear.mas_bottom).offset(ScaleW(20));
        make.left.mas_equalTo(ScaleW(20));
        make.width.mas_equalTo(Device_Width-ScaleW(40));
        make.height.mas_equalTo(ScaleW(180));
    }];
    
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    
    EGRelayTokenModel *tokenModel = [EGLoginUserManager getRelayToken];
    NSDictionary *headerDict;
    if (tokenModel) {
        headerDict = @{@"Authorization":tokenModel.token ? tokenModel.token:@""};
    }
    
    
    [[WAFNWHTTPSTool sharedManager] getWithURL:[EGServerAPI mobile_beaconList] parameters:@{} headers:headerDict success:^(NSDictionary * _Nonnull response) {
        
        NSDictionary* deviceRecord =  response[@"data"];
        NSArray *array = deviceRecord[@"records"];
        NSMutableArray *arraym = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            [arraym addObject:dict[@"btbUuid"]];
        }
        [self setBeaconsArray:arraym];
        
    } failure:^(NSError * _Nonnull error) {
    }];
    
    [self startScanningBeacon];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSMutableArray<CLBeaconRegion *> *)beaconRegions
{
    if (!_beaconRegions) {
        _beaconRegions = [NSMutableArray array];
    }
    return _beaconRegions;
}
/**
 * 初始化位置管理器 请求定位权限
 */
- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        [_locationManager requestAlwaysAuthorization];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
    }
    return _locationManager;
}

/**
 *beacona 列表
 */
-(void)setBeaconsArray:(NSArray *)beaconas
{
    
    for (NSString *uuid_str in beaconas) {
        NSUUID *uuid1 = [[NSUUID alloc] initWithUUIDString:uuid_str];
        CLBeaconRegion *region1 = [[CLBeaconRegion alloc] initWithProximityUUID:uuid1 identifier:uuid_str];
        [self.beaconRegions addObject:region1];
    }
    [self startScanningBeacon];
}
/**
 * 开始扫描
 */
-(void)startScanningBeacon
{
    [self.locationManager startUpdatingLocation];
    [self startScanningAllBeacons];
}
/**
 * 停止扫描
 */
-(void)stopScanningBeacon
{
    for (CLBeaconRegion *region in self.beaconRegions) {
        [self.locationManager stopMonitoringForRegion:region];
        [self.locationManager stopRangingBeaconsInRegion:region];
    }
    [self.locationManager stopUpdatingLocation];
}

- (void)startScanningAllBeacons
{
    for (CLBeaconRegion *region in self.beaconRegions) {
        [self.locationManager startMonitoringForRegion:region];
        [self.locationManager startRangingBeaconsInRegion:region];
    }
}

//- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager
//{
//    if (@available(iOS 14.0, *)) {
//        switch (manager.authorizationStatus) {
//            case kCLAuthorizationStatusNotDetermined:
//                [self.locationManager requestWhenInUseAuthorization];
//                break;
//            case kCLAuthorizationStatusRestricted:
//                [self.locationManager requestWhenInUseAuthorization];
//                break;
//            case kCLAuthorizationStatusDenied:
////                [self locationAuthorization];
//                if ([CLLocationManager locationServicesEnabled]) {
//                    ELog(@"Status Denied -13");
//                }else{
//                    ELog(@"Status Denied -23");
//                }
//                break;
//            case kCLAuthorizationStatusAuthorizedAlways:
//                [self.locationManager requestAlwaysAuthorization];
//                
//                break;
//            case kCLAuthorizationStatusAuthorizedWhenInUse:
//                [self.locationManager requestWhenInUseAuthorization];
//                
//                break;
//            default:
//                break;
//        }
//    } else {
//        // Fallback on earlier versions
//    }
//}
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region {
    if (beacons.count > 0) {
        // 按距离排序
        NSArray *sortedBeacons = [beacons sortedArrayUsingComparator:^NSComparisonResult(CLBeacon *beacon1, CLBeacon *beacon2) {
            return [@(beacon1.accuracy) compare:@(beacon2.accuracy)];
        }];
        
        // 处理每个检测到的 Beacon
        for (CLBeacon *beacon in sortedBeacons) {
            [self handleBeacon:beacon inRegion:region];
        }
    }
}

- (void)handleBeacon:(CLBeacon *)beacon inRegion:(CLBeaconRegion *)region
{
    if (@available(iOS 13.0, *)) {
         
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
        NSString *dateTime = [formatter stringFromDate:beacon.timestamp];
        
        NSString *uuidStr = [NSString stringWithFormat:@"%@",beacon.UUID];
        NSString *majorStr = [NSString stringWithFormat:@"%@",beacon.major];
        NSString *beaconInfo = [NSString stringWithFormat:@" 時間: %@\n 訊號強度: %ld\n Major: %@\n Minor: %@\n Accuracy: %.2fm\n UUID: %@",
                                dateTime,
                                (long)beacon.rssi,
                                majorStr,
                                beacon.minor,
                                beacon.accuracy,
                                uuidStr];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:beaconInfo];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5;
        [attributedString addAttribute:NSParagraphStyleAttributeName
                                 value:paragraphStyle
                                 range:NSMakeRange(0, [beaconInfo length])];
        
        switch (beacon.proximity) {
            case CLProximityImmediate:
                //NSLog(@"非常近的 Beacon:\n%@", beaconInfo);
//                self.infomationLable.attributedText = attributedString;
                break;
                
            case CLProximityNear:
                //NSLog(@"较近的 Beacon:\n%@", beaconInfo);
//                self.infomationLableNear.attributedText = attributedString;
                break;
                
            case CLProximityFar:
                //NSLog(@"较远的 Beacon:\n%@", beaconInfo);
//                self.infomationLableFar.attributedText = attributedString;
                break;
                
            default:
                //NSLog(@"未知距离的 Beacon:\n%@", beaconInfo);
                break;
        }
        
        if (self.infomationLable.text.length == 0) {
            self.infomationLable.attributedText = attributedString;
        }else{
            if ([self.infomationLable.text containsString:uuidStr] && [self.infomationLable.text containsString:majorStr]) {
                self.infomationLable.attributedText = attributedString;
            }else{
                if (self.infomationLableNear.text.length == 0) {
                    self.infomationLableNear.attributedText = attributedString;
                }else{
                    if ([self.infomationLableNear.text containsString:uuidStr] && [self.infomationLableNear.text containsString:majorStr]) {
                        self.infomationLableNear.attributedText = attributedString;
                    }else{
                        if (self.infomationLableFar.text.length == 0) {
                            self.infomationLableFar.attributedText = attributedString;
                        }else{
                            if ([self.infomationLableFar.text containsString:uuidStr] && [self.infomationLableFar.text containsString:majorStr]) {
                                self.infomationLableFar.attributedText = attributedString;
                            }
                        }
                    }
                }
            }
        }
        
    } else {
        // Fallback on earlier versions
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        NSLog(@"进入区域: %@", region.identifier);
        [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        NSLog(@"离开区域: %@", region.identifier);
        [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"区域 %@ 监听失败: %@", region.identifier, error);
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error {
    NSLog(@"区域 %@ 测距失败: %@", region.identifier, error);
}

- (void)dealloc {
    for (CLBeaconRegion *region in self.beaconRegions) {
        [self.locationManager stopMonitoringForRegion:region];
        [self.locationManager stopRangingBeaconsInRegion:region];
    }
    
    [self.centralManager stopScan];
}


#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state == CBManagerStatePoweredOn) {
        // 开始扫描 Beacon
        [self startScanningBeacons];
    }
}

- (void)startScanningBeacons {
    // 扫描特定服务的 Beacon
//    [self.centralManager scanForPeripheralsWithServices:nil
//                                             options:@{CBCentralManagerScanOptionAllowDuplicatesKey: @YES}];
    NSArray *services = @[[CBUUID UUIDWithString:@"180A"],[CBUUID UUIDWithString:@"2A01"],[CBUUID UUIDWithString:@"3CA4"]];
    [self.centralManager scanForPeripheralsWithServices:services options:nil];
    
}

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary<NSString *,id> *)advertisementData
                  RSSI:(NSNumber *)RSSI {
    
    // 检查是否包含电量服务
    if (advertisementData[CBAdvertisementDataServiceDataKey]) {
        // 解析电量数据
        [self parseBatteryLevel:advertisementData forBeacon:peripheral];
    }
}

- (void)parseBatteryLevel:(NSDictionary *)advertisementData forBeacon:(CBPeripheral *)peripheral {
    // 注意：具体的电量数据格式取决于 Beacon 制造商
    // 这里以一个示例格式演示
    NSDictionary *serviceData = advertisementData[CBAdvertisementDataServiceDataKey];
    for (NSData *data in serviceData.allValues) {
        if (data.length >= 1) {
            // 假设电量数据在第一个字节
            uint8_t batteryLevel = 0;
            [data getBytes:&batteryLevel length:1];
            
            // 保存电量数据
//            self.beaconBatteryLevels[peripheral.identifier.UUIDString] = @(batteryLevel);
            
            // 显示电量信息
            [self displayBatteryLevel:batteryLevel forBeacon:peripheral];
        }
    }
}

- (void)displayBatteryLevel:(uint8_t)batteryLevel forBeacon:(CBPeripheral *)peripheral
{
    NSString *message = [NSString stringWithFormat:@"Beacon: %@\n电量: %d%%",
                        peripheral.identifier.UUIDString,
                        batteryLevel];
    NSLog(@"%@", message);
    if (batteryLevel < 80) {
        [self showLowBatteryWarning:peripheral];
    }
}

- (void)showLowBatteryWarning:(CBPeripheral *)peripheral {
    NSString *message = [NSString stringWithFormat:@"Beacon %@ 电量低",
                        peripheral.identifier.UUIDString];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"电量警告"
                                                                 message:message
                                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定"
                                                      style:UIAlertActionStyleDefault
                                                    handler:nil];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
