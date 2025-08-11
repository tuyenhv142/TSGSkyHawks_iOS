#import "EGBeaconPopupView.h"
#import "CoreBluetooth/CoreBluetooth.h"
#import <CoreLocation/CoreLocation.h>
API_AVAILABLE(ios(13.0))

static NSString *const ibeaconDeviceUUID = @"D57092AC-DFAA-446C-8EF3-C81AA22815B5";//
static NSString *const ibeaconDeviceUUID2 = @"F57092AC-DFAA-446C-8EF3-C81AA22815B5";//


API_AVAILABLE(ios(13.0))
@interface EGBeaconPopupView ()<CBCentralManagerDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, copy) void(^confirmBlock)(void);


// tableview style 在头部添加属性声明
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *sectionHeaders;
@property (nonatomic, strong) NSArray *cellContents;
@property (nonatomic, copy) NSString *footerContent;

//bluetooth
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, assign) BOOL is_bluetooth;

//ibeacon
@property (nonatomic)NSArray *ibeacon_devicearray;
/** 检查定位权限 */
@property (nonatomic, strong) CLLocationManager *locationManager;
/** 需要被监听的beacon */
@property (nonatomic, strong) CLBeaconRegion *beaconRegion;
/** 需要被监听的beacon参数 */
@property (nonatomic, strong) CLBeaconIdentityConstraint *beaconConstrait;

@property (nonatomic, strong)NSArray *devicearray;

@end

@implementation EGBeaconPopupView

//敬请期待UI
+ (void)showInView:(UIView *)view {
    // 获取 keyWindow
    UIWindow *keyWindow = nil;
    if (@available(iOS 13.0, *)) {
        keyWindow = [UIApplication sharedApplication].windows.firstObject;
    } else {
        keyWindow = [UIApplication sharedApplication].keyWindow;
    }
    
    EGBeaconPopupView *popupView = [[EGBeaconPopupView alloc] initWithFrame:keyWindow.bounds];
    [keyWindow addSubview:popupView];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.is_bluetooth = NO;
        [self setupUI];
    }
    return self;
}

// 添加新的初始化方法
- (instancetype)initWithTableViewConfig:(NSDictionary *)config confirmBlock:(void(^)(void))confirmBlock {
    if (self = [super initWithFrame:[UIApplication sharedApplication].windows.firstObject.bounds]) {
        self.confirmBlock = confirmBlock;
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    // 添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tap];
    
    // 容器视图
    self.containerView = [[UIView alloc] init];
    [self addSubview:self.containerView];
    
    // 内容视图（白色背景）
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = ScaleW(16);
    self.contentView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    [self.containerView addSubview:self.contentView];
    
    // 图标
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.image = [UIImage imageNamed:@"dialog_TAKAMEI"];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.iconImageView];
    
    // 文本标签
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.text = @"現場活動，即將登場！";
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.textColor = rgba(23, 23, 23, 1);
    self.messageLabel.font = [UIFont systemFontOfSize:FontSize(18) weight:UIFontWeightSemibold];
    [self.contentView addSubview:self.messageLabel];
    
    // 确定按钮
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmButton setTitle:@"確定" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.confirmButton.backgroundColor = rgba(0, 122, 96, 1);
    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightSemibold];
    [self.confirmButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    self.confirmButton.titleEdgeInsets = UIEdgeInsetsMake(-ScaleW(40), 0, 0, 0);
    [self.containerView addSubview:self.confirmButton];
    
    
    // 布局
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(ScaleW(342));
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.containerView);
        make.height.mas_equalTo(ScaleW(260));
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(ScaleW(30));
        make.width.height.mas_equalTo(ScaleW(160));
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(ScaleW(16));
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.containerView);
        make.height.mas_equalTo(ScaleW(82));
    }];
    
    // 添加动画
    self.containerView.transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.transform = CGAffineTransformIdentity;
    }];
    
    //增加蓝牙检测机制
    [self startBluetoothservice];
}



- (void)dismiss {
    
    for(int i=0;i<self.devicearray.count;i++)
    {
        NSUUID *estimoteUUID = self.devicearray[i];
        if (@available(iOS 13.0, *)) {
            _beaconRegion = [[CLBeaconRegion alloc] initWithUUID:estimoteUUID identifier:@""];
            _beaconConstrait  = [[CLBeaconIdentityConstraint alloc] initWithUUID:estimoteUUID];
        }
        if (@available(iOS 13.0, *)) {
            [self.locationManager stopRangingBeaconsSatisfyingConstraint:_beaconConstrait];
        } else {
            // Fallback on earlier versions
        }
        [self.locationManager stopMonitoringForRegion:_beaconRegion];
    }

    
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark 蓝牙代理
-(void)startBluetoothservice
{
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    });
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state == CBManagerStatePoweredOn) {
        self.messageLabel.textColor = UIColor.systemGreenColor;
        self.messageLabel.text = @"蓝牙开启，可以使用";
        self.is_bluetooth = YES;
        [self checkLocationstatus];
        [central scanForPeripheralsWithServices:nil options:nil];
    }
    else{
        self.is_bluetooth = NO;
        self.messageLabel.textColor = UIColor.systemRedColor;
        self.messageLabel.text = @"蓝牙未开启，不可以使用";
    }
}

#pragma mark beacon device flow
#pragma mark 检查定位功能是否开启

-(void)checkLocationstatus
{
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager requestAlwaysAuthorization];
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _locationManager.delegate = self;
    //实时更新定位位置
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    [_locationManager startUpdatingLocation];
    
    // 在开始监控之前，我们需要判断改设备是否支持，和区域权限请求
    BOOL availableMonitor = [CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]];
    if (availableMonitor) {
        CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
        switch (authorizationStatus) {
            case kCLAuthorizationStatusNotDetermined:
                [self.locationManager requestAlwaysAuthorization];
                break;
            case kCLAuthorizationStatusRestricted:
            case kCLAuthorizationStatusDenied:
                NSLog(@"受限制或者拒绝");
                break;
            case kCLAuthorizationStatusAuthorizedAlways:
            case kCLAuthorizationStatusAuthorizedWhenInUse:{
                [self monitorDevice];
            }
                break;
        }
    } else {
        NSLog(@"该设备不支持 CLBeaconRegion 区域检测");
    }
}


- (void)locationManager:(CLLocationManager *)manager locationManagerDidChangeAuthorization:(CLAuthorizationStatus)status  {
    if (status == kCLAuthorizationStatusAuthorizedAlways
        || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.messageLabel.textColor=UIColor.systemGreenColor;
        self.messageLabel.text=@"允许获取定位";
        NSLog(@"允许获取定位");
    }
    else
    {
        self.messageLabel.textColor=UIColor.systemRedColor;
        self.messageLabel.text=@"拒绝获取定位权限";
        NSLog(@"拒绝获取定位权限");
    }
}

#pragma mark Location delegate
#pragma mark -- Monitoring
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
     NSLog(@"Locations : %@", locations);
  }


/** 进入区域 */
- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region  {
    
    self.messageLabel.textColor=UIColor.systemRedColor;
    self.messageLabel.text=@"进入区域";
    NSLog(@"进入区域");
    
}


/** 离开区域 */
- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region  {
    
    self.messageLabel.textColor=UIColor.systemRedColor;
    self.messageLabel.text=@"离开区域";
    NSLog(@"离开区域");
}


/** Monitoring有错误产生时的回调 */
- (void)locationManager:(CLLocationManager *)manager
monitoringDidFailForRegion:(nullable CLRegion *)region
              withError:(NSError *)error {
}

/** Monitoring 成功回调 */
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    
    NSLog(@"Monitoring 成功回调");
    
}

#pragma mark 监控ibeacon device
-(void)monitorDevice
{
    if (@available(iOS 13.0, *)) {
        self.devicearray = @[[[NSUUID alloc] initWithUUIDString:ibeaconDeviceUUID],
                                 [[NSUUID alloc] initWithUUIDString:ibeaconDeviceUUID2]];
        
        for(int i=0;i<self.devicearray.count;i++)
        {
            NSUUID *estimoteUUID = self.devicearray[i];
            if (@available(iOS 13.0, *)) {
                _beaconRegion = [[CLBeaconRegion alloc] initWithUUID:estimoteUUID identifier:@""];
                _beaconConstrait  = [[CLBeaconIdentityConstraint alloc] initWithUUID:estimoteUUID];
            }
            _beaconRegion.notifyEntryStateOnDisplay = YES;
            _beaconRegion.notifyOnEntry = YES;
            _beaconRegion.notifyOnExit = YES;
            
            [self checkMonitoringAuth:_beaconRegion constra:_beaconConstrait];
            
        }
    } else {
        // Fallback on earlier versions
    }
}

- (void)checkMonitoringAuth:(CLBeaconRegion*)region constra:(CLBeaconIdentityConstraint*)con
API_AVAILABLE(ios(13.0)){
    [self.locationManager startRangingBeaconsSatisfyingConstraint:con];
    [self.locationManager startMonitoringForRegion:region];
}

#pragma mark -- Ranging
/** 1秒钟执行1次 */ //进入和离开、点亮屏幕也会调这个方法
- (void)locationManager:(CLLocationManager *)manager
     didRangeBeacons:(NSArray<CLBeacon *> *)beacons
satisfyingConstraint:(CLBeaconIdentityConstraint *)beaconConstraint
API_AVAILABLE(ios(13.0)){
    for (CLBeacon *beacon in beacons) {
//        NSLog(@" rssi is :%ld",(long)beacon.rssi);
//        NSLog(@" beacon proximity :%ld",(long)beacon.proximity);
//        NSLog(@" accuracy : %f",beacon.accuracy);
//        NSLog(@" proximityUUID : %@",beacon.UUID.UUIDString);
//        NSLog(@" major :%ld",(long)beacon.major.integerValue);
//        NSLog(@" minor :%ld",(long)beacon.minor.integerValue);
        self.messageLabel.textColor=UIColor.purpleColor;
        self.messageLabel.text=beacon.UUID.UUIDString;
        
    }
}

/** ranging有错误产生时的回调  */
- (void)locationManager:(CLLocationManager *)manager
didFailRangingBeaconsForConstraint:(CLBeaconIdentityConstraint *)beaconConstraint
                  error:(NSError *)error API_AVAILABLE(ios(13.0)){
    NSLog(@"ranging有错误产生时的回调");
}
#pragma mark -- Kill callBack
/** 杀掉进程之后的回调，直接锁屏解锁，会触发 */
- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
}

@end
