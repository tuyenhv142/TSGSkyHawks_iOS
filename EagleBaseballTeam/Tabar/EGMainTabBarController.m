//
//  EGMainTabBarController.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/1/21.
//  Copyright © 2025 NewSoft. All rights reserved.
//#define showLog
//#define testrssi

//#define showLogUI


#import "EGMainTabBarController.h"

#import "EGNavigationController.h"
#import "EGHomeViewController.h"
#import "EGSchedulesViewController.h"
#import "EGPointsViewController.h"

#import "EGMemberViewController.h"
#import "EGBuyTicksController.h"

//#import "CoreBluetooth/CoreBluetooth.h"
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
#import <Security/Security.h>
#import <Network/Network.h>
#import <CoreTelephony/CTCellularData.h>
#import "EGTaskeventsModel.h"
#import "EGComingSoonPopupView.h"
#import "EGTaskManager.h"

API_AVAILABLE(ios(13.0))
@interface EGMainTabBarController ()<UITabBarDelegate,/*CBCentralManagerDelegate*/CLLocationManagerDelegate>
//bluetooth
//@property (nonatomic, strong) CBCentralManager *centralManager;
//@property (nonatomic, strong) CBPeripheral *peripheral;
//@property (nonatomic, assign) BOOL is_bluetooth;

//ibeacon
@property (nonatomic)NSMutableArray *ibeacon_devicearray;
/** 检查定位权限 */
@property (nonatomic, strong) CLLocationManager *locationManager;
/** 需要被监听的beacon */
@property (nonatomic, strong) CLBeaconRegion *beaconRegion;
/** 需要被监听的beacon参数 */
@property (nonatomic, strong) CLBeaconIdentityConstraint *beaconConstrait;

@property (nonatomic, strong)NSArray *devicearray;

@property (nonatomic, assign)BOOL inSound;
@property (nonatomic, assign)BOOL outSound;

@property (nonatomic,copy) NSString *beaconUUID;
@property (nonatomic,strong) NSArray *beaconInfoArray;


@property (nonatomic, strong) NSString *memberQRCode;
@property (nonatomic, strong) NSString *Event_ID;
@property (nonatomic, strong) CTCellularData *cellularData;

@property (nonatomic)NSMutableArray *all_event_array;
@property (nonatomic, assign)BOOL get_all_event_OK;//记录侦测rssi 次数


@property (nonatomic, strong)NSArray *special_event_array;
@property (nonatomic, assign)NSInteger rssiTime;//记录侦测rssi 次数
@property (nonatomic, strong) UIView *highlightCircleView;


#ifdef showLogUI
@property (nonatomic, strong)UITextView *showlogView;
#endif

@end



@implementation EGMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.clearColor;
    
    [self startMonitoringNetwork];

    [self loadViewControllers];

      self.tabBar.delegate = self;
      self.tabBar.clipsToBounds = NO;

      [self tabBar:self.tabBar didSelectItem:self.tabBar.items[self.selectedIndex]];

//    self.tabBar.backgroundColor = rgba(0, 71, 56, 1);
//    self.tabBar.backgroundColor = rgba(10, 63, 245, 1);
    EGUserOauthModel *oathModel = [EGLoginUserManager getOauthDataModel];
    if(!oathModel || !oathModel.accessToken || [oathModel.accessToken isEqualToString:@""]){
        [[EGetTokenViewModel sharedManager] getAuthForOnlyOneCRM:^(BOOL success) {
        }];
    }
    EGRelayTokenModel *tokenModel = [EGLoginUserManager getRelayToken];
    if (!tokenModel) {
        [[EGetTokenViewModel sharedManager] getAuthForRelayResponseState:^(BOOL state, id  _Nonnull result3) {
        }];
    }
    
    
    self.all_event_array = [[NSMutableArray alloc] init];
    //如果登录成功，开始侦测ibeacon device
    [[NSNotificationCenter defaultCenter] addObserver:self
            selector:@selector(receivecheckbeaconNotification:)
            name:@"checkbeaconNotification"
            object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
            selector:@selector(receiveclosebeaconNotification:)
            name:@"closebeaconNotification"
            object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//            selector:@selector(checkEventlistByAppActivty:)
//            name:@"checkEventlistByAppActivty"
//            object:nil];
    
    if ([EGLoginUserManager isLogIn]) {
        [self getAllEventList];
        [self checkibeancon];
    }
    
    
#ifdef showLogUI
    UITextView *view = [[UITextView alloc] init];
    view.textAlignment = NSTextAlignmentCenter;
    view.font = [UIFont systemFontOfSize:FontSize(16)];
    view.scrollEnabled = YES;
    view.editable = NO;
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(10));
        make.top.mas_equalTo(140);
        make.width.mas_equalTo(Device_Width);
        make.bottom.mas_equalTo(-22);
    }];
    self.showlogView = view;
#endif
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self checkAppVersion];
    });
    
}
- (void) receivecheckbeaconNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.

    if ([[notification name] isEqualToString:@"checkbeaconNotification"])
    {
        [self getAllEventList];
        [self checkibeancon];
    }
}


-(void)checkEventlistByAppActivty:(NSNotification *)notification
{
    if ([EGLoginUserManager isLogIn]) {
        //stop beacom
        if(self.locationManager){
               for(int i=0;i<self.devicearray.count;i++)
               {
                   NSDictionary*tempInfo = self.devicearray[i];
                   NSUUID *estimoteUUID = [[NSUUID alloc] initWithUUIDString:[tempInfo objectForKey:@"btbUuid"]];
                   
                   //NSUUID *estimoteUUID = self.devicearray[i];
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
               
               self.locationManager=nil;
           }
        
        usleep(10000);
        
        [self getAllEventList];
        [self checkibeancon];
    }
}

- (void)receiveclosebeaconNotification:(NSNotification *) notification
{
    if(self.locationManager){
           for(int i=0;i<self.devicearray.count;i++)
           {
               NSDictionary*tempInfo = self.devicearray[i];
               NSUUID *estimoteUUID = [[NSUUID alloc] initWithUUIDString:[tempInfo objectForKey:@"btbUuid"]];
               
               //NSUUID *estimoteUUID = self.devicearray[i];
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
           
           self.locationManager=nil;
       }
}


-(void)loadViewControllers
{
    EGSchedulesViewController *schedules = [[EGSchedulesViewController alloc] init];
    schedules.tabBarItem.tag = 1;
    [self setUpChildViewController:schedules title:@"賽程" imageNamed:@"calendar" selectedImageNamed:@"calendar_B"];
   
    
    EGPointsViewController *points = [[EGPointsViewController alloc] init];
    points.tabBarItem.tag = 2;
    [self setUpChildViewController:points title:@"點數" imageNamed:@"tsgskyhawk" selectedImageNamed:@"sky_B"];
    
    EGHomeViewController *home = [[EGHomeViewController alloc] init];
    home.tabBarItem.tag = 0;
    [self setUpChildViewController:home title:@"首頁" imageNamed:@"home" selectedImageNamed:@"home_B"];
    
    EGBuyTicksController *home3 = [[EGBuyTicksController alloc] init];
    home3.tabBarItem.tag = 3;
    [self setUpChildViewController:home3 title:@"票匣" imageNamed:@"ticket" selectedImageNamed:@"ticket_B"];
    
    EGMemberViewController *member = [[EGMemberViewController alloc] init];
    member.tabBarItem.tag = 4;
    [self setUpChildViewController:member title:@"會員" imageNamed:@"user" selectedImageNamed:@"user_B"];
        
    self.selectedIndex = 2;
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self tabBar:self.tabBar didSelectItem:self.tabBar.selectedItem];
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger index = [self.tabBar.items indexOfObject:item];
    if (index == NSNotFound) return;

    CGFloat tabBarWidth = tabBar.bounds.size.width;
    CGFloat tabWidth = tabBarWidth / self.tabBar.items.count;
    CGFloat circleSize = 55;

    CGFloat centerX = tabWidth * index + tabWidth / 2.0;
    CGFloat centerY = tabBar.bounds.size.height / 2.0 - 45;

    
    // Tạo highlight circle
    if (!self.highlightCircleView) {
        self.highlightCircleView = [[UIView alloc] init];
        self.highlightCircleView.backgroundColor = UIColor.whiteColor;
        self.highlightCircleView.layer.cornerRadius = circleSize / 2;
        self.highlightCircleView.layer.shadowColor = UIColor.blackColor.CGColor;
        self.highlightCircleView.layer.shadowOpacity = 0.2;
        self.highlightCircleView.layer.shadowOffset = CGSizeMake(0, 2);
        self.highlightCircleView.layer.shadowRadius = 4;

        [tabBar insertSubview:self.highlightCircleView atIndex:0];
    }

    self.highlightCircleView.frame = CGRectMake(0, 0, circleSize, circleSize);
    self.highlightCircleView.center = CGPointMake(centerX, centerY);
    self.highlightCircleView.hidden = NO;
//    self.highlightCircleView.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.8];

    // Đẩy icon lên và đặt màu nền icon
    for (int i = 0; i < self.viewControllers.count; i++) {
        UINavigationController *nav = (UINavigationController *)self.viewControllers[i];
        if (nav.tabBarItem == item) {
            nav.tabBarItem.imageInsets = UIEdgeInsetsMake(-22, 0, 22, 0);
        } else {
            nav.tabBarItem.imageInsets = UIEdgeInsetsZero;
        }
    }
}
-(void)setUpChildViewController:(UIViewController *)controller title:(NSString *)title imageNamed:(NSString *)defImage selectedImageNamed:(NSString *)selImage
{
    EGNavigationController *nav = [[EGNavigationController alloc] initWithRootViewController:controller];
    nav.navigationBar.backgroundColor = rgba(16, 38, 73, 1);

    if (self.childViewControllers.count > 0) {
        self.navigationController.navigationBarHidden = NO;
    }else{
        self.navigationController.navigationBarHidden = YES;
    }
    
    controller.title = title;
    controller.tabBarItem.image = [[UIImage imageNamed:defImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *imageHome = [UIImage imageNamed:selImage];
    imageHome = [imageHome imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [controller.tabBarItem setSelectedImage:imageHome];
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = rgba(255, 255, 255, 1);
//    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:FontSize(10)];
    
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = rgba(255, 255, 255, 1);
//    selectTextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:FontSize(10)];
    
    [controller.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [controller.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    
    if (@available(iOS 10.0, *)) {
        [[UITabBar appearance] setUnselectedItemTintColor:UIColor.grayColor];
    } else {
        // Fallback on earlier versions
    }
    [self addChildViewController:nav];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
//{
//
//}

- (void)startMonitoringNetwork
{
    nw_path_monitor_t monitor = nw_path_monitor_create();
    nw_path_monitor_set_update_handler(monitor, ^(nw_path_t path) {
        if (nw_path_get_status(path) == nw_path_status_satisfied) {
            NSLog(@"Network is available. Network permission is granted.");
            if (nw_path_uses_interface_type(path, nw_interface_type_wifi)) {
                NSLog(@"Connected via WiFi.");
            } else if (nw_path_uses_interface_type(path, nw_interface_type_cellular)) {
                NSLog(@"Connected via cellular data.");
            }
            NSString *state = [kUserDefaults objectForKey:SETFCMTokenState];
            if (!state) {
                [[EGetTokenViewModel sharedManager] getAuthForCRM];
                [self checkAppVersion];
            }
            
        } else {//No network connection
            NSLog(@"No network connection. Check if network permission is disabled.");
        }
    });
    nw_path_monitor_start(monitor);
    
    self.cellularData = [[CTCellularData alloc] init];
    self.cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
       if (state == kCTCellularDataNotRestricted) {
           ELog(@"User has granted network permission, retrying requests...CTCellularData");
       }
    };
    
    [ZYNetworkAccessibity setStateDidUpdateNotifier:^(ZYNetworkAccessibleState state) {
        if (state == ZYNetworkAccessible) {
            ELog(@"User has granted network permission, retrying requests...ZYNetworkAccessibity");
        }
    }];
}


-(void)checkAppVersion
{
    [[EGetTokenViewModel sharedManager] getAppStoreVersionWithAppID:STOREAPPID completion:^(NSString *appStoreVersion, NSError *error) {
        // 获取当前安装的版本号
        NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        NSLog(@"iphone 上的版本号: %@", currentVersion);
        if (error) {
            NSLog(@"获取App Store版本失败: %@", error.localizedDescription);
        } else {
            NSLog(@"App Store上的版本号: %@", appStoreVersion);
            
            if ([appStoreVersion compare:currentVersion options:NSNumericSearch] == NSOrderedDescending) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSSet *set = [UIApplication sharedApplication].connectedScenes;
                    UIWindowScene *windowScene = [set anyObject];
                    UIWindow *keyWindow = windowScene.windows.firstObject;
                    UIViewController *rootVC = keyWindow.rootViewController;
                    
                    NSString *message = [NSString stringWithFormat:@"台鋼天鷹已推出新版%@\n前往更新，以獲得最佳使用體驗",appStoreVersion];
                    [ELAlertController alertControllerWithTitleName:@"發現新版本" andMessage:message cancelButtonTitle:nil confirmButtonTitle:@"立即更新" showViewController:rootVC addCancelClickBlock:^(UIAlertAction * _Nonnull cancelAction) {
                    } addConfirmClickBlock:^(UIAlertAction * _Nonnull SureAction) {
                        
                        NSString *appStoreStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", STOREAPPID];
                        NSURL *appStoreURL = [NSURL URLWithString:appStoreStr];
                        [[UIApplication sharedApplication] openURL:appStoreURL options:@{} completionHandler:^(BOOL success) {
                            if (!success) {
                                [[UIApplication sharedApplication] openURL:appStoreURL options:@{} completionHandler:nil];
                            }
                        }];
                        
                    }];
                });
                
            }
        }
    }];
    
//    NSString *url = [NSString stringWithFormat:@"https://itunes.apple.com/tw/lookup?id=%@",STOREAPPID];
//    NSString *URL_String = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    
//    [[WAFNWHTTPSTool sharedManager] getWithURL:url parameters:@{} headers:@{} success:^(id  _Nonnull response) {
//        
//        NSArray *resultArr = response[@"results"];
//        NSDictionary *resultDic = resultArr.firstObject;
//        
//        NSDictionary *infoDic = [[NSBundle mainBundle]infoDictionary];
//        NSString *appCurrentVersion = infoDic[@"CFBundleShortVersionString"];
//        
//        NSString *appStoreVersion = resultDic[@"version"];
//        NSString *message1 = [NSString stringWithFormat:@"台鋼雄鷹已推出新版 %@\n 前往更新，已獲得最佳使用體驗",appStoreVersion];
//        
//        if ([appCurrentVersion compare:appStoreVersion options:NSNumericSearch] == NSOrderedAscending)
//        {
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"發現新版本" message:message1 preferredStyle:UIAlertControllerStyleAlert];
//                
////                // Create the actions.
////                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
////                }];
//                
//                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//                    [self jumpToAppStoreApp];
//                }];
//                
//                // Add the actions.
//                //[alertController addAction:cancelAction];
//                [alertController addAction:otherAction];
//            
////            UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
////            UIViewController *rootViewController = window.rootViewController;
//            
//            [self presentViewController:alertController animated:YES completion:^{
//                
//            }];
//            
//        }
//        
//    } failure:^(NSError * _Nonnull error) {
//    }];
}
- (void)jumpToAppStoreApp {
    NSString *appStoreURLStr = @"https://apps.apple.com/us/app/6743694362";
    NSURL *appStoreURL = [NSURL URLWithString:appStoreURLStr];
    if ([[UIApplication sharedApplication]canOpenURL:appStoreURL]) {
        if ([UIDevice currentDevice].systemVersion.doubleValue >= 10.0) {
            [[UIApplication sharedApplication] openURL:appStoreURL options:@{UIApplicationOpenURLOptionsAnnotationKey: @"YES"} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:appStoreURL];
        }
    }
}

#pragma mark 获取任务信息-QRCode- 任务ID--然后将相关信息传给Server(CRM and 中继服务器)
-(void)getAllEventList
{
    UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
    if (!model) {
        return;
    }
    
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
    NSDictionary *dict_header = @{@"Authorization":tokenString};
    
    NSString *url2 =  [EGServerAPI getEventtasks];
    [[WAFNWHTTPSTool sharedManager] getWithURL:url2 parameters:@{} headers:dict_header success:^(NSDictionary * _Nonnull response) {
        NSArray *array  = [EGTaskeventsModel mj_objectArrayWithKeyValuesArray:response];
        
        //將所有任務傳給點數界面
        [EGTaskManager sharedManager].taskArray = array;
        //獲取member event list 將 status merge到 All list
        [self getAlllist:(NSArray*)array];
        self.get_all_event_OK = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getEventList];
        });
        
    } failure:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.all_event_array = nil;
            self.get_all_event_OK = NO;
            if ([error.localizedDescription containsString:@"offline"] || error.code == -1009) {
                [MBProgressHUD showDelayHidenMessage:@"請檢查您的網路連線，確保裝置已連接至網路後再重試。"];
            }else{
                [MBProgressHUD showDelayHidenMessage:error.localizedDescription];
            }
        });
    }];
    
}

//主要是将 服务器返回的 List，转换成可变长度的NSMutableArray
-(void)getAlllist:(NSArray*)array
{
    [self.all_event_array removeAllObjects];
    for(int i=0;i<array.count;i++)
    {
        NSMutableDictionary* dictemp = [[NSMutableDictionary alloc] init];
        EGTaskeventsModel *dic = [array objectAtIndex:i];

        [dictemp setObject:dic.content forKey:@"content"];
        [dictemp setObject:dic.endDate forKey:@"endDate"];
        [dictemp setObject:dic.eventType forKey:@"eventType"];
        [dictemp setObject:dic.ID forKey:@"id"];
        [dictemp setObject:dic.point forKey:@"point"];
        [dictemp setObject:dic.pointProcess forKey:@"pointProcess"];
        [dictemp setObject:dic.startDate forKey:@"startDate"];
        [dictemp setObject:dic.supportInfo forKey:@"supportInfo"];
//        [dictemp setObject:dic. forKey:@"targetAudience"];
        [dictemp setObject:dic.topic forKey:@"topic"];
        [dictemp setObject:dic.triggerTag forKey:@"triggerTag"];
        [dictemp setObject:dic.triggerType forKey:@"triggerType"];
        [dictemp setObject:@"" forKey:@"event_status"];
        [dictemp setObject:@"0" forKey:@"has_send"];
        [self.all_event_array addObject:dictemp];
    }
    
}

//获取QR and 发送给CRM，发送CRM前调用
-(void)getQRtoCRM:(NSString*)event_id EvEIndex:(NSInteger)index
{
    if(!self.get_all_event_OK)
    return;

UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
if (!model) {
    return;
}

NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
NSDictionary *dict_header = @{@"Authorization":tokenString};

MemberInfomationModel *infoModel = [EGLoginUserManager getMemberInfomation];
    if (!infoModel) {
        return;
    }
NSDictionary *dict_body = @{@"Mobile":infoModel.Phone};

[[WAFNWHTTPSTool sharedManager] postWithURL:[EGServerAPI basicMemberGenqrcode:model.ID] parameters:dict_body headers:dict_header success:^(NSDictionary * _Nonnull response) {
    if (![response isKindOfClass:[NSDictionary class]]) {

        //[MBProgressHUD showDelayHidenMessage:@"數據格式錯誤"];
        return;
    }
    NSDictionary *data = [response objectOrNilForKey:@"data"];
    if (![data isKindOfClass:[NSDictionary class]]) {
        //[MBProgressHUD showDelayHidenMessage:@"數據格式錯誤"];
        return;
    }
    
    NSString *qrCode =  [data objectOrNilForKey:@"MEMQRCODE"];
    if (!qrCode || ![qrCode isKindOfClass:[NSString class]]) {
        //[MBProgressHUD showDelayHidenMessage:@"數據格式錯誤"];
        return;
    }
    
#ifdef showLog
    NSLog(@"获取QR code token 成功");
#endif
    
    self.memberQRCode = qrCode;
    [self sendBeaconIDForCRMr:event_id EventIndex:index];
    
} failure:^(NSError * _Nonnull error) {
#ifdef showLog
    NSLog(@"获取QR code token 失败，表示发送CRM打卡失败，所以将has_send 设置为 0");
#endif
    NSMutableDictionary* dic = [self.all_event_array objectAtIndex:index];
    [dic setObject:@"0" forKey:@"has_send"];
    [self.all_event_array replaceObjectAtIndex:index withObject:dic];
    if ([error.localizedDescription containsString:@"offline"] || error.code == -1009) {
       // [MBProgressHUD showDelayHidenMessage:@"請檢查您的網路連線，確保裝置已連接至網路後再重試。"];
    }else{
        //[MBProgressHUD showDelayHidenMessage:error.localizedDescription];
    }
}];
    
}

//获取QR code and menber Event list, 发送完CRM后调用
-(void)getEventList
{
    if(!self.get_all_event_OK)
        return;
#ifdef showLog
    NSLog(@"任务列表获取成功");
#endif
    
    UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
    if (!model) {
        return;
    }
    
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
    NSDictionary *dict_header = @{@"Authorization":tokenString};
    
    MemberInfomationModel *infoModel = [EGLoginUserManager getMemberInfomation];
    if (!infoModel) {
        return;
    }
    NSDictionary *dict_body = @{@"Mobile":infoModel.Phone};
    
    
    [[WAFNWHTTPSTool sharedManager] postWithURL:[EGServerAPI basicMemberGenqrcode:model.ID] parameters:dict_body headers:dict_header success:^(NSDictionary * _Nonnull response) {
        if (![response isKindOfClass:[NSDictionary class]]) {
   
            [MBProgressHUD showDelayHidenMessage:@"數據格式錯誤"];
            return;
        }
        NSDictionary *data = [response objectOrNilForKey:@"data"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            [MBProgressHUD showDelayHidenMessage:@"數據格式錯誤"];
            return;
        }
        
        NSString *qrCode =  [data objectOrNilForKey:@"MEMQRCODE"];
        if (!qrCode || ![qrCode isKindOfClass:[NSString class]]) {
            [MBProgressHUD showDelayHidenMessage:@"數據格式錯誤"];
            return;
        }
        self.memberQRCode = qrCode;
        
        NSString *url2 =  [EGServerAPI getEventmembertasks:qrCode];
        [[WAFNWHTTPSTool sharedManager] getWithURL:url2 parameters:@{} headers:dict_header success:^(NSDictionary * _Nonnull response) {
            self.special_event_array = (NSArray*)response;
            [self mergArrayToAllevent];
            dispatch_async(dispatch_get_main_queue(), ^{

    
            });
            
        } failure:^(NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.special_event_array = nil;
                if ([error.localizedDescription containsString:@"offline"] || error.code == -1009) {
                    [MBProgressHUD showDelayHidenMessage:@"請檢查您的網路連線，確保裝置已連接至網路後再重試。"];
                }else{
                    [MBProgressHUD showDelayHidenMessage:error.localizedDescription];
                }
            });
        }];
        
    } failure:^(NSError * _Nonnull error) {

        if ([error.localizedDescription containsString:@"offline"] || error.code == -1009) {
            [MBProgressHUD showDelayHidenMessage:@"請檢查您的網路連線，確保裝置已連接至網路後再重試。"];
        }else{
            [MBProgressHUD showDelayHidenMessage:error.localizedDescription];
        }
    }];
    
}

-(void)mergArrayToAllevent
{
    if(!self.all_event_array)
        return;
    if(!self.special_event_array)
        return;
    
    for(int i=0;i<self.all_event_array.count;i++)
    {
        NSMutableDictionary* alldic = [self.all_event_array objectAtIndex:i];
        NSString *e_id = [alldic objectForKey:@"id"];
        for(int j=0;j<self.special_event_array.count;j++)
        {
            NSDictionary* spedic = [self.special_event_array objectAtIndex:j];
            NSString *s_id = [spedic objectForKey:@"id"];
            if([e_id isEqualToString:s_id])
            {
                [alldic setObject:[spedic objectForKey:@"personalEventTaskStatus"] forKey:@"event_status"];
                [self.all_event_array replaceObjectAtIndex:i withObject:alldic];
            }
        }
    }
}



-(void)playSound:(NSInteger)In
{
    //low_power.caf
    NSURL *fileURL = [NSURL URLWithString:@"/System/Library/Audio/UISounds/sms-received1.caf"];
    switch (In) {
        case 0:
            fileURL = [NSURL URLWithString:@"/System/Library/Audio/UISounds/low_power.caf"];
            break;
            
        case 1:
            fileURL = [NSURL URLWithString:@"/System/Library/Audio/UISounds/sms-received1.caf"];
            break;
            
        case 2:
            fileURL = [NSURL URLWithString:@"/System/Library/Audio/UISounds/sms-received4.caf"];
            break;
        default:
            break;
    }

    if (fileURL)
        {
            SystemSoundID theSoundID;
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &theSoundID);
            if (error == kAudioServicesNoError)
            {
                AudioServicesPlaySystemSoundWithCompletion(theSoundID, ^{
                    AudioServicesDisposeSystemSoundID(theSoundID);
                });
            }
        }
}

-(void)sendTo:(NSString*)u_id RSSI:(NSInteger)rs
{
    if(!self.get_all_event_OK)
        return;
    
    for(int i=0;i<self.ibeacon_devicearray.count;i++)
    {
        NSMutableDictionary *dic = [self.ibeacon_devicearray objectAtIndex:i];
        // 创建一个数组来存储符合条件的键
        NSMutableArray *keysForStringValues = [NSMutableArray array];
                // 遍历字典
        for (NSString *key in dic) {
            // 检查值是否为NSString类型
            if ([dic[key] isKindOfClass:[NSNumber class]]) {
                // 如果是，添加键到数组中
            [keysForStringValues addObject:key];
            }
        }
        
        NSArray* keyarray = keysForStringValues;//[dic allKeys];
        NSString* id_string = [keyarray objectAtIndex:0];
        
        if([id_string isEqualToString:u_id])
        {
#ifdef testrssi
            NSInteger thisdevicerssitest = [[dic objectForKey:@"rssithreshold"] intValue];
            if(thisdevicerssitest>rs)
            {
                break;
            }
            [self playSound:1];
#endif
            
            
            
            NSInteger current_index = [self getspecialevent:self.all_event_array ForCRM:NO];
            if(current_index==-1)
                return;
            
            NSInteger thisdevicerssi = [[dic objectForKey:@"rssithreshold"] intValue];
#ifdef showLogUI
            self.showlogView.text = [NSString stringWithFormat:@"实际信号 = %ld 阈值 = %ld",rs,thisdevicerssi];
#endif
            if(thisdevicerssi>rs)
            {
#ifdef showLogUI
                NSLog(@"实际信号 = %ld 小于阈值 = %ld",rs,thisdevicerssi);
                [self.showlogView setText:[NSString stringWithFormat:@"实际信号 = %ld 小于阈值 = %ld 不做任何操作",rs,thisdevicerssi]];
#endif
                break;
            }
                

            
            /*5分钟发一次给中继*/
            NSNumber* time = [dic objectForKey:u_id];
            if(time.intValue == 0)
            {
                
#ifdef showLog
                [self playSound:1];
                NSLog(@"第一次发送中继，device id = %@  event id = %@",u_id,[[self.all_event_array objectAtIndex:current_index] objectForKey:@"id"]);
#endif
                [self sendNewsoftServe:dic Event:[[self.all_event_array objectAtIndex:current_index] objectForKey:@"id"]];//发送信息给中继
                [dic setObject:[NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]] forKey:u_id];
                [self.ibeacon_devicearray replaceObjectAtIndex:i withObject:dic];
            }
            else
            {
                NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
                if(end - time.intValue>300)
                {
#ifdef showLog
                    [self playSound:0];
                    NSLog(@"五分钟发送一次中继，device id = %@  event id = %@",u_id,[[self.all_event_array objectAtIndex:current_index] objectForKey:@"id"]);
#endif
                    [self sendNewsoftServe:dic Event:[[self.all_event_array objectAtIndex:current_index] objectForKey:@"id"]];//发送信息给中继
                    [dic setObject:[NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]] forKey:u_id];
                    [self.ibeacon_devicearray replaceObjectAtIndex:i withObject:dic];
                }
            }
            
            /*检测rssi的值，平均值 大于-75, 才给CRM发*/
            NSInteger currentevent_index = [self getspecialevent:self.all_event_array ForCRM:YES];
            if(currentevent_index==-1)
                return;
            BOOL has_send = [[[self.all_event_array objectAtIndex:currentevent_index] objectForKey:@"has_send"] boolValue];
            NSString *eventStatus = [[self.all_event_array objectAtIndex:currentevent_index] objectForKey:@"event_status"];

            if(!has_send&&[eventStatus isEqualToString:@"pending"])
            {
                NSMutableDictionary* dic = [self.all_event_array objectAtIndex:currentevent_index];
                [dic setObject:@"1" forKey:@"has_send"];
#ifdef showLog
                [self playSound:2];
                NSLog(@"event id = %@, 已经发送CRM打卡 = %d",[[self.all_event_array objectAtIndex:currentevent_index] objectForKey:@"id"],has_send);
#endif
                [self.all_event_array replaceObjectAtIndex:currentevent_index withObject:dic];
                //发送给CRM
                [self getQRtoCRM:[[self.all_event_array objectAtIndex:currentevent_index] objectForKey:@"id"] EvEIndex:currentevent_index];
                
            }
        }
        }
        
}

/*向中继和CRM发送信息*/
-(void)sendBeaconIDForCRMr:(NSString*)event_id EventIndex:(NSInteger)index
{
        self.Event_ID = event_id;
        [self saveCRM:self.Event_ID EventIndex:index];
}

-(void)sendNewsoftServe:(NSDictionary*)dev Event:(NSString*)event_id
{
   self.Event_ID = event_id;
   NSLog(@"QR code = %@, event id = %@",self.memberQRCode,self.Event_ID);
   [self saveBeaconID:dev Event:self.Event_ID];//发送中继成功
}

/*按照当前时间，过滤符合时间段的任务，并记录任务 id*/
-(BOOL)getconditionsEvent:(NSString*)startTime  end:(NSString*)endTime current:(NSDate*)curTime
{
    BOOL is_OKEvent = NO;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
    //[formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    NSDate *date1 = [formatter dateFromString:startTime];
    NSDate *date2 = [formatter dateFromString:endTime];
    
    NSDate *dateToCheck = curTime; // 需要检查的日期
    NSDate *startDate = date1; // 起始日期
    NSDate *endDate = date2; // 结束日期
     
    NSTimeInterval intervalToStart = [dateToCheck timeIntervalSinceDate:startDate];
    NSTimeInterval intervalToEnd = [endDate timeIntervalSinceDate:dateToCheck];
     
    if (intervalToStart >= 0 && intervalToEnd >= 0) {
        //NSLog(@"日期在两个时间段内");
        is_OKEvent = YES;
    } else {
        //NSLog(@"日期不在两个时间段内");
    }
    
    return is_OKEvent;
}

/*向中继服务器 传送信息*/
-(void)saveBeaconID:(NSDictionary*)deviceinfo Event:(NSString*)eventid
{
    NSMutableDictionary *para =  [NSMutableDictionary dictionary];
    [para setObject:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"deviceId"];
        
//    NSLog(@"%@,%@",[deviceinfo objectForKey:@"deviceNoid"],[deviceinfo objectForKey:@"deviceUID"]);
    
    [para setObject:[deviceinfo objectForKey:@"deviceNoid"] forKey:@"btbId"];
    [para setObject:[self getCurrentTimeWithTimeZone]  forKey:@"interactionTime"];
   
    
    [para setObject:eventid forKey:@"taskUuid"];
    [para setObject:[deviceinfo objectForKey:@"deviceUID"] forKey:@"beaconUuid"];
    [para setObject:[deviceinfo objectForKey:@"Major_Device"] forKey:@"beaconMajor"];
    [para setObject:[deviceinfo objectForKey:@"Minor_Device"] forKey:@"beaconMinor"];
    
    [para setObject:@"设备其他信息" forKey:@"deviceOtherInfo"];
    [para setObject:@"蓝牙其他信息" forKey:@"additionalBluetoothInfo"];
    
    EGRelayTokenModel *tokenModel = [EGLoginUserManager getRelayToken];
    NSDictionary *headerDict;
    if (tokenModel) {
        headerDict = @{@"Authorization":tokenModel.token ? tokenModel.token:@""};
    }
    [[WAFNWHTTPSTool sharedManager] postWithURL:[EGServerAPI mobile_beaconSave] parameters:para headers:headerDict success:^(NSDictionary * _Nonnull response) {
        NSLog(@"发送中继成功");
    } failure:^(NSError * _Nonnull error) {
        if ([error.localizedDescription containsString:@"offline"] || error.code == -1009) {
            //[MBProgressHUD showDelayHidenMessage:@"請檢查您的網路連線，確保裝置已連接至網路後再重試。"];
        }else{
            //[MBProgressHUD showDelayHidenMessage:error.localizedDescription];
        }
    }];
}

-(void)saveCRM:(NSString*)eventid EventIndex:(NSInteger)index
{
    NSMutableDictionary *para =  [NSMutableDictionary dictionary];
    [para setObject:self.memberQRCode forKey:@"encryptedIdentity"];
    [para setObject:eventid forKey:@"taskId"];
    
    UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
    if (!model) {
        return;
    }
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
    NSDictionary *dict_header = @{@"Authorization":tokenString};
    
    [[WAFNWHTTPSTool sharedManager] postWithURL:[EGServerAPI getEventcheckins] parameters:para headers:dict_header success:^(NSDictionary * _Nonnull response) {
#ifdef showLog
        NSLog(@"发送CRM成功");
        NSLog(@"重新获取一次Member event状态");
#endif
        [self getEventList];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self playSound:1];
            [EGComingSoonPopupView showCustomPopupWithConfig:^(NSMutableDictionary *config) {
                config[@"containerHeight"] = @(414);
                config[@"iconImage"] = @"dialog_TAKAO";
                config[@"message"] = @"翅膀硬了！";
                config[@"detail"] = @"恭喜你完成每日任務「鷹雄軍報到」";
                config[@"buttonTitle"] = @"確定";
            } confirmBlock:^{
                
            }];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskStatusUpdateNotification"
                                                                object:nil
                                                              userInfo:@{
                @"section": @"",
                @"index": @"",
                @"status": @"",
                @"points": @""
            }];
            
        });
        
    } failure:^(NSError * _Nonnull error) {
#ifdef showLog
        NSLog(@"发送打卡信息失败，将has_send 设置为 0");
#endif
        NSMutableDictionary* dic = [self.all_event_array objectAtIndex:index];
        [dic setObject:@"0" forKey:@"has_send"];
        [self.all_event_array replaceObjectAtIndex:index withObject:dic];
        if ([error.localizedDescription containsString:@"offline"] || error.code == -1009) {
            //[MBProgressHUD showDelayHidenMessage:@"請檢查您的網路連線，確保裝置已連接至網路後再重試。"];
        }else{
            //[MBProgressHUD showDelayHidenMessage:error.localizedDescription];
        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//        });
    }];
}


// 在实现部分添加方法
- (NSString *)getCurrentTimeWithTimeZone {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    return [formatter stringFromDate:[NSDate date]];
}

-(NSInteger)getspecialevent:(NSArray*)array ForCRM:(BOOL)crm//checkin ytMember item
{
    NSInteger e_dicindex = -1;
    for(int w=0;w<array.count;w++)
    {
        NSDictionary* dic = [array objectAtIndex:w];
        BOOL isevent = [self getconditionsEvent:[dic objectForKey:@"startDate"] end:[dic objectForKey:@"endDate"] current:[NSDate date]];
    
        if(crm)//如果给CRM发送，需要加event_statues判断
        {
            if([[dic objectForKey:@"triggerType"] isEqualToString:@"app"]&&
               [[dic objectForKey:@"triggerTag"] isEqualToString:@"checkin"]&&
               isevent&&[[dic objectForKey:@"event_status"] isEqualToString:@"pending"])
            {
                e_dicindex = w;
                break;
            }
        }
        else
        {
            if([[dic objectForKey:@"triggerType"] isEqualToString:@"app"]&&
               [[dic objectForKey:@"triggerTag"] isEqualToString:@"checkin"]&&
               isevent)
            {
                e_dicindex = w;
                break;
            }
        }
        
    }
    
    return e_dicindex;
}

//- (void)setupTabBarCornerRadius
//{
//    // 获取 UITabBar 的 layer // 设置 UITabBar 的圆角
//    CALayer *tabBarLayer = self.tabBar.layer;
//    // 设置圆角半径
//    tabBarLayer.cornerRadius = 25.0; // 圆角大小
//    tabBarLayer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner | kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner; // 只设置顶部左右两个角
//    // 添加阴影（可选）
//    tabBarLayer.shadowColor = [UIColor blackColor].CGColor;
//    tabBarLayer.shadowOffset = CGSizeMake(0, -2);
//    tabBarLayer.shadowOpacity = 0.1;
//    tabBarLayer.shadowRadius = 4.0;
//    // 裁剪超出圆角的部分
//    self.tabBar.clipsToBounds = NO;
//    // 设置背景颜色 // 设置 UITabBar 的外观
////    self.tabBar.backgroundColor = [UIColor whiteColor];
//    // 设置背景透明度
//    self.tabBar.backgroundImage = [UIImage new];
//    self.tabBar.shadowImage = [UIImage new]; // 移除默认的顶部阴影线
//}
//
//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    
////    CGRect tabFrame = self.tabBar.frame;
////    tabFrame.size.width =  Device_Width -40;
////    tabFrame.size.height = 49;
////    tabFrame.origin.y = self.view.frame.size.height - self.view.safeAreaInsets.bottom - 49;
////    tabFrame.origin.x = 20;
////    self.tabBar.frame = tabFrame;
//}


#pragma mark 开启蓝牙侦测和处理代理
-(void)checkibeancon
{
    self.inSound = NO;
    self.outSound = NO;
//    if(!self.centralManager)
//       [self startBluetoothservice];
    if(!_locationManager)
       [self checkLocationstatus];
}


//-(void)startBluetoothservice
//{
//    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
//    });
//}
//
//- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
//    if (central.state == CBManagerStatePoweredOn) {
//        self.is_bluetooth = YES;
//        //[self checkLocationstatus];
//        [central scanForPeripheralsWithServices:nil options:nil];
//    }
//    else{
//        [MBProgressHUD showDelayHidenMessage:@"藍牙功能未開啟，請開啟藍牙功能"];
//        self.is_bluetooth = NO;
//    }
//}

#pragma mark 检查定位功能是否开启和搜索beacon device
-(void)checkLocationstatus
{
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager requestAlwaysAuthorization];
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _locationManager.delegate = self;
    //_locationManager.allowsBackgroundLocationUpdates = YES;
    _locationManager.pausesLocationUpdatesAutomatically = NO;
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
                _locationManager.allowsBackgroundLocationUpdates = YES;
                break;
            case kCLAuthorizationStatusAuthorizedWhenInUse:{
                //[self monitorDevice];
                _locationManager.allowsBackgroundLocationUpdates = NO;
            }
                break;
        }
    } else {
        NSLog(@"该设备不支持 CLBeaconRegion 区域检测");
    }
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        _locationManager.allowsBackgroundLocationUpdates = NO;
        [self monitorDevice];
        NSLog(@"允许获取定位");
    }
    else if(status == kCLAuthorizationStatusAuthorizedAlways)
    {
        _locationManager.allowsBackgroundLocationUpdates = YES;
        [self monitorDevice];
        NSLog(@"允许获取定位");
    }
    else
    {
        NSLog(@"拒绝获取定位权限");
    }
}

#pragma mark Location delegate
#pragma mark -- Monitoring
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  }


/** 进入区域 */
- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region  {
    
    NSLog(@"进入区域");
}


/** 离开区域 */
- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region  {
    
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
    self.rssiTime = 0;
    
    /*获取要侦测的device id*/
    self.ibeacon_devicearray = [[NSMutableArray alloc] init];
    
    if (@available(iOS 13.0, *)) {
        
        EGRelayTokenModel *tokenModel = [EGLoginUserManager getRelayToken];
        NSDictionary *headerDict;
        if (tokenModel) {
            headerDict = @{@"Authorization":tokenModel.token ? tokenModel.token:@""};
        }
        [[WAFNWHTTPSTool sharedManager] getWithURL:[EGServerAPI mobile_beaconList] parameters:@{} headers:headerDict success:^(NSDictionary * _Nonnull response) {
            
            NSDictionary* deviceRecord =  response[@"data"];
            self.devicearray = deviceRecord[@"records"];
            //self.devicearray = @[[[NSUUID alloc] initWithUUIDString:ibeaconDeviceUUID],
                                     //[[NSUUID alloc] initWithUUIDString:ibeaconDeviceUUID2]];
            
            for(int i=0;i<self.devicearray.count;i++)
            {
                NSDictionary*tempInfo = self.devicearray[i];
                NSUUID *estimoteUUID = [[NSUUID alloc] initWithUUIDString:[tempInfo objectForKey:@"btbUuid"]];
                if (@available(iOS 13.0, *)) {
                    if (!estimoteUUID) {
                        break;
                    }
                    self.beaconRegion = [[CLBeaconRegion alloc] initWithUUID:estimoteUUID identifier:@""];
                    self.beaconConstrait  = [[CLBeaconIdentityConstraint alloc] initWithUUID:estimoteUUID];
                }
                self.beaconRegion.notifyEntryStateOnDisplay = YES;
                self.beaconRegion.notifyOnEntry = YES;
                self.beaconRegion.notifyOnExit = YES;
                
                [self checkMonitoringAuth:self.beaconRegion constra:self.beaconConstrait];
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                //产生唯一标识 UUID + major +minor
                NSString *maj = [NSString stringWithFormat:@"%@",[tempInfo objectForKey:@"major"]];
                NSString *min = [NSString stringWithFormat:@"%@",[tempInfo objectForKey:@"minor"]];
                NSString *deviceUUID = [NSString stringWithFormat:@"%@",[tempInfo objectForKey:@"btbUuid"]];
                NSMutableString *deviceKey = [NSMutableString stringWithFormat:@"%@%@%@",[tempInfo objectForKey:@"btbUuid"],maj,min];
                
                [dic setObject:[NSNumber numberWithInt:0] forKey:deviceKey];
                [dic setObject:deviceUUID forKey:@"deviceUID"];
                [dic setObject:maj forKey:@"Major_Device"];
                [dic setObject:min forKey:@"Minor_Device"];
                [dic setObject:[tempInfo objectForKey:@"id"] forKey:@"deviceNoid"];
                
                NSInteger rssi_value = [[tempInfo objectForKey:@"signalIntensityThreshold"] intValue];
                [dic setObject:[NSString stringWithFormat:@"%ld",rssi_value] forKey:@"rssithreshold"];
                [self.ibeacon_devicearray addObject:dic];
            }
            
        } failure:^(NSError * _Nonnull error) {
            [MBProgressHUD showDelayHidenMessage:@"無法獲取信標設備"];
            
        }];
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
//        NSLog(@" rssi is :%ld",(long)beacon.rssi);//接收指定信标的信号强度（以分贝为单位）。该值是自上次报告此信标以来收集的 RSSI 样本的平均值。
//        NSLog(@" beacon proximity :%ld",(long)beacon.proximity);//信标与设备的距离。.
//        NSLog(@" accuracy : %f",beacon.accuracy);//表示测量设备位置以信标设备为参考的 1 西格玛水平精度（以米为单位）
//        NSLog(@" proximityUUID : %@",beacon.UUID.UUIDString);
//        self.beaconUUID = beacon.UUID.UUIDString;
//        NSLog(@" major :%ld",(long)beacon.major.integerValue);
//        NSLog(@" minor :%ld",(long)beacon.minor.integerValue);
        
//        NSString *string = @"";
//        /*用rssi 侦测*/
//        string = [string stringByAppendingFormat:@"beacon proximity :%ld\n  accuracy : %f\n rssi is :%ld",(long)beacon.proximity,beacon.accuracy,(long)beacon.rssi];
//        self.showMusic.text = string;
        
        /*用proximity 侦测
         CLProximityUnknown,
         CLProximityImmediate,
         CLProximityNear,
         CLProximityFar;
        */
        switch (beacon.proximity) {
            case CLProximityUnknown:
            {
                //NSLog(@"Unknown");
            }
            break;
            case CLProximityFar:
            {
                    //if(beacon.rssi>-75)
                    {
                        NSString *major_string = [NSString  stringWithFormat:@"%ld",[beacon.major integerValue]];
                        NSString *minor_string = [NSString  stringWithFormat:@"%ld",[beacon.minor integerValue]];
                        NSMutableString *deviceKey = [NSMutableString stringWithFormat:@"%@%@%@",beacon.UUID.UUIDString,major_string,minor_string];
                        [self sendTo:deviceKey RSSI:beacon.rssi];
                    }
                  
            }
                    break;
            case CLProximityNear:
            case CLProximityImmediate:
            {
                //NSLog(@"Near");
                NSString *major_string = [NSString  stringWithFormat:@"%ld",[beacon.major integerValue]];
                NSString *minor_string = [NSString  stringWithFormat:@"%ld",[beacon.minor integerValue]];
                NSMutableString *deviceKey = [NSMutableString stringWithFormat:@"%@%@%@",beacon.UUID.UUIDString,major_string,minor_string];
                
                [self sendTo:deviceKey RSSI:beacon.rssi];
            }
                break;
        }
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
