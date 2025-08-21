//
//  EGMemberViewController.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/1/21.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGUserGuideViewController.h"
#import "EGMemberViewController.h"
#import "EGMemberCardCell.h"
#import "EGMemberActivitiesCell.h"
#import "EGSocialLinksCell.h"
#import <SafariServices/SFSafariViewController.h>
#import <MessageUI/MessageUI.h>
#import "GoroundViewController.h"
#import "EGFanSupportingViewController.h"
#import "EGMemberCodeViewController.h"
#import "EGMembershipLevelViewController.h"

#import "EGPlayerSupportingViewController.h"
#import "EGTeamperformanceViewController.h"

#import "GoroundSettingView.h"
#import "EGpolicyView.h"

#import "EGComingSoonPopupView.h"
#import "EGConsumptionRecordViewController.h"
#import "EGNotificationSettingCell.h"

#import "EGMemberInfoModel.h"

#import "EGMemberInfoViewController.h"
#import "EGFAQViewController.h"
#import "EGCustomerProblemController.h"

#import "EGPlayerliftandlowerViewController.h"

#import "EGUserOrdersModel.h"
#import "EGOrderDetailInfo.h"

#import "EGPointsViewController.h"

#import "EGPolicyViewController.h"
//#import "EGServiceViewController.h"
#import "EGTermsViewController.h"

#import "EGmedalViewController.h"
#import "EGBeaconTestViewController.h"
#import "EGTaskManager.h"
#import "EGrouPhotoViewController.h"//合影
#import "EGEagleFansWorldViewController.h"//鷹迷天地

#import "EGTaskeventsModel.h"
#import "EGRegRulesViewController.h"

//球场信息
#import "EGStadiumIntroductionViewController.h"


#import "EGiftDetailController.h"



@interface EGMemberViewController ()<UITableViewDelegate,UITableViewDataSource,EGMemberCardCellDelegate,MFMailComposeViewControllerDelegate,SFSafariViewControllerDelegate>
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, weak) UITableView* tableView2;
@property (nonatomic, strong) EGMemberInfoModel* infoModel;
@property (nonatomic, strong) NSMutableArray *orderList;
@property (nonatomic, strong) NSString *consumption;//记录累计消费总金额
@property  (nonatomic, strong) NSString * userID;
@property  (nonatomic, copy) NSString * newsoftUserEmail;

@property (nonatomic, strong) UILabel *versionLabel;

@property (nonatomic, assign) NSInteger totalSpent_shop;

@property (nonatomic,strong) UIButton *leftBtn;
@end

@implementation EGMemberViewController

- (NSMutableArray *)sections
{
    if (!_sections) {
        _sections = [NSMutableArray arrayWithCapacity:0];
    }
    return _sections;
}
- (NSMutableArray *)orderList{
    if (!_orderList) {
        _orderList = [NSMutableArray array];
    }
    return _orderList;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.leftBtn setTitle:[EGLoginUserManager isLogIn] ? NSLocalizedString(@"會員", nil) : NSLocalizedString(@"登入", nil) forState:(UIControlStateNormal)];
    
    if (!self.infoModel) {
        if ([EGLoginUserManager isLogIn]){
            [self.tableView2.mj_header beginRefreshing];
        }
    }
}
- (UITableView *)tableView2
{
    if (_tableView2 == nil) {
        
//        if (@available(iOS 13.0, *)) {
            UITableView *tableView2 = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
            tableView2.delegate = self;
            tableView2.dataSource = self;
            tableView2.backgroundColor = rgba(245, 245, 245, 1);
            tableView2.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            tableView2.showsVerticalScrollIndicator = NO;
            tableView2.estimatedRowHeight = 100;
            //        tableView2.contentInset = UIEdgeInsetsMake(0, ScaleW(20), 0, -ScaleW(20));
            self.tableView2 = tableView2;
//        } else {
//            // Fallback on earlier versions
//        }
        [self.view addSubview:self.tableView2];
    }
    return _tableView2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.consumption = @"0";
    self.totalSpent_shop = 0;
    
    [self setNavigationItem];
    
    [self createUItableView2];
   
    [self setupData];

    [self fetchMemberInfo];  //获取会员信息
    

    
}
#pragma mark --- 本地数据
- (void)setupData
{
    // 会员信息区域
    NSDictionary *memberSection = @{
        @"title": @"",
        @"items": @[@{
            @"name": @"訪客",
            @"type": @"",
            @"duration": @"",
            @"consumption": @"0",
//            @"memberLevel": @0  // 会员等级 1-5
        }]
    };
    
    // 功能区域
    NSDictionary *featuresSection = @{
        @"title": @"",
        @"items": @[
            @{@"title": @"歡呼模式", @"icon": @"cheer_mode"}
        ]
    };
    
    // 成就区域
    NSDictionary *achievementSection = @{
        @"title": @"台鋼天鷹",
        @"items": @[
//从点数奖杯进入      @"成就勳章",
                    @"球隊戰績",
                    @"球隊成員",
//                    @"球隊升降",
                    @{@"title": @"鷹援資訊", @"isNew": @YES},
                    @"關於天鷹",
                    @{@"title": @"球場介紹", @"isNew": @YES},
//                    @"球迷回饋",
                    @{@"title": @"球迷互動", @"isNew": @YES},
                    /*@{@"title": @"鷹迷天地", @"isNew": @YES},*/
                    ]
    };
    
    NSString *titleStr = @"會員登入";
    if ([EGLoginUserManager isLogIn]) {
        titleStr =  @"登出";
        [self fetchMemberInfo];  // 添加获取会员信息
    }
    //會員專區
    NSDictionary *memberInfoSection = @{
        @"title": @"會員專區",
        @"items": @[
            @"會員資料",
            @"通知設定",
            @"使用導覽",
            @"常見問題"
//            @{@"title": @"常見問題", @"isNew": @YES},
            @"聯絡客服",
            @"隱私條款",
            @"使用者服務條款",
//            @"進場任務設定檢測",
            titleStr]
    };
    
    //socialMedia
    NSDictionary *socialMediaSection = @{
        @"title": @"",
        @"items": @[
            @"會員資料",
        ]
    };
    
//    [self.sections addObjectsFromArray:@[memberSection, featuresSection, achievementSection]];
    [self.sections removeAllObjects];
    [self.sections addObjectsFromArray:@[memberSection,featuresSection,achievementSection,memberInfoSection,socialMediaSection]];

    [self.tableView2 reloadData];
}

-(void)setNavigationItem
{
    self.view.backgroundColor = UIColor.clearColor;
    self.navigationItem.title = @"";
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [leftBtn setTitle:[EGLoginUserManager isLogIn] ? NSLocalizedString(@"會員", nil) : NSLocalizedString(@"登入", nil) forState:(UIControlStateNormal)];
    [leftBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.leftBtn = leftBtn;
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [rightBtn setTitle:NSLocalizedString(@"鷹國會員", nil) forState:(UIControlStateNormal)];
    [rightBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(xiongying) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    rightBtn.enabled = NO;

}

-(void)createUItableView2
{
    [self.tableView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo([UIDevice de_navigationFullHeight]);
    }];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.textColor = [UIColor lightGrayColor];
    versionLabel.font = [UIFont systemFontOfSize:FontSize(14) ];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    versionLabel.text = [NSString stringWithFormat:@"版本 %@", version];
    [footerView addSubview:versionLabel];
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footerView);
        make.centerY.equalTo(footerView);
        make.height.mas_equalTo(20);
    }];
    self.tableView2.tableFooterView = footerView;
    
    self.tableView2.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self fetchMemberInfo];  // 添加获取会员信息
    }];
    [self.tableView2.mj_header beginRefreshing];
}


//获取现场消费 -总金额
-(void)getTotalSpent
{
    UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
    NSDictionary *dict_header = @{@"Authorization":tokenString};
    [[WAFNWHTTPSTool sharedManager] getWithURL:[EGServerAPI totalSpent_api:model.ID] parameters:@{} headers:dict_header success:^(NSDictionary * _Nonnull response) {
        
        NSDictionary *dict = response[@"data"];
        NSInteger totalSpent = [[dict objectOrNilForKey:@"totalSpent"] intValue];
        [self updateConsumptionInfo:totalSpent];
        
        } failure:^(NSError * _Nonnull error) {
            
        }];
}

//更新累计消费信息
-(void)updateConsumptionInfo:(NSInteger ) money
{
    // 更新会员信息区域
//    NSDictionary *memberSection = @{
//        @"title": @"",
//        @"items": @[@{
//            @"name": infoModel.Name ?: @"",
//            @"type": infoModel.MemberTier.TierName ?:@"",
//            @"duration": @"一年期限",
//            @"consumption": @"0",
//            @"memberLevel": infoModel.MemberTier.TierSeq
//        }]
//    };
    
    NSInteger totalMoney = self.totalSpent_shop + money;
    
    NSMutableDictionary *memberSection = [NSMutableDictionary dictionaryWithDictionary:self.sections[0]];
    
    NSArray *items = [memberSection objectForKey:@"items"];
    NSMutableDictionary *itemDict = [NSMutableDictionary dictionaryWithDictionary:items[0]];
    [itemDict setObject:[NSString stringWithFormat:@"%ld",totalMoney] forKey:@"consumption"];
    
    [memberSection setObject:[NSArray arrayWithObject:itemDict] forKey:@"items"];
    [memberSection setObject:[NSString stringWithFormat:@"%ld",totalMoney] forKey:@"consumption"];
    self.consumption = [NSString stringWithFormat:@"%ld",totalMoney];
    // 更新 sections 数组中的会员信息
    if (self.sections.count > 0) {
        [self.sections replaceObjectAtIndex:0 withObject:memberSection];
    }
    [self.tableView2 reloadData];
}

//MARK:  获取会员信息
- (void)fetchMemberInfo {
    
    WS(weakSelf);
    [[EGetTokenViewModel sharedManager] fetchMemberInfo:^(BOOL isSuccess) {
        if (isSuccess) {
            
            EGMemberInfoModel *infoModel = [EGLoginUserManager getMemberInfoPoints];
            weakSelf.infoModel = infoModel;
            // 更新会员信息区域
            NSDictionary *memberSection = @{
                @"title": @"",
                @"items": @[@{
                    @"name": infoModel.Name ?: @"",
                    @"type": infoModel.MemberCards,
                    @"duration": @"一年期限",
                    @"consumption": self.consumption
                   // @"memberLevel": infoModel.MemberTier.TierSeq
                }]
            };
            // 更新 sections 数组中的会员信息
            if (self.sections.count > 0) {
                [self.sections replaceObjectAtIndex:0 withObject:memberSection];
            }
            //會員專區
            NSDictionary *memberInfoSection = @{
                @"title": @"會員專區",
                @"items": @[
                    @"會員資料",
                    @"通知設定",
                    @"使用導覽",
                    @"常見問題",
//                    @{@"title": @"常見問題", @"isNew": @YES},
                    @"聯絡客服",
                    @"隱私條款",
                    @"使用者服務條款",
                  //  @"進場任務設定檢測",
                    @"登出"
                ]
            };
            // 更新 sections 数组中的会员信息
            if (self.sections.count > 3) {
                [self.sections replaceObjectAtIndex:3 withObject:memberInfoSection];
            }
            [self getConsumptionRecord];  //获取累计消费信息
            // 刷新表格
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView2 reloadData];
                [self.tableView2.mj_header endRefreshing];
            });
        }else{
            [weakSelf.tableView2.mj_header endRefreshing];
        }
    }];
}
//MARK: 先获取gmail再获取 累计消费信息
-(void)getConsumptionRecord{
    
    UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
    if (!model) {
        [self.tableView2.mj_header endRefreshing];
        return;
    }
    [[EGetTokenViewModel sharedManager] getUserData:^(BOOL isSuccess, NSString * _Nonnull gmail) {
        if (isSuccess) {
            self.newsoftUserEmail = gmail;
            if (gmail) {
                [self getUserInfobyEmail:gmail];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    //没有数据时清空
                    [self noDataClearOldData];
                });
            }
        }
    }];
}
//MARK: 获取累计消费信息
-(void)getUserInfobyEmail:(NSString *)gMail
{
    WS(weakSelf)
    NSString *url = [EGServerAPI getUserInfobyEmail:gMail];
    //通过email 获取用户ID
    [[WAFNWHTTPSTool sharedManager] getWithURL:url parameters:@{} headers:@{} success:^(NSDictionary * _Nonnull response) {
        NSString *userID = nil;
        if ([response isKindOfClass:[NSArray class]]) {
            //&& [response objectForKey:@"id"] != nil
            NSArray *array = [NSArray arrayWithArray:(NSArray *)response];
            if (array.count>0) {
                NSDictionary *dict = array[0];
                id idValue = [dict objectForKey:@"id"];
                if ([idValue isKindOfClass:[NSString class]]) {
                    userID = idValue;
                } else if ([idValue isKindOfClass:[NSNumber class]]) {
                    userID = [idValue stringValue];
                }
            }
        }
        
        if (!userID) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //没有数据时清空
                [self noDataClearOldData];
            });
            return;
        }
        self.userID = userID;
        //根据ID获取用户消费记录
        [weakSelf getUserOrdersBy:userID success:^(id response) {
            [self.orderList removeAllObjects];
            NSArray *array = [NSArray arrayWithArray:(NSArray *)response];
            NSArray *arrayModel = [EGUserOrdersModel mj_objectArrayWithKeyValuesArray:array];
            NSInteger consumption = 0;
            for (EGUserOrdersModel *model in arrayModel) {
                
                // 转换时间格式
                NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
                [inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                // 设置固定的 locale，避免受系统设置影响
                [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
                // 设置时区
               // [inputFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
                
                NSDate *date=[inputFormatter dateFromString:model.date_created];
             

                NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
                [outputFormatter setDateFormat:@"yyyy/MM/dd"];
                NSString *formattedDate = [outputFormatter stringFromDate:date];
                
                
                //订单详情数据 结构
                EGOrderDetailInfo *orderDetail = [EGOrderDetailInfo new];
                orderDetail.orderId = model.ID;
                //获取总计
                orderDetail.totalAmount = model.total;
                orderDetail.products = [NSMutableArray array];
                
                //获取运费
                NSInteger shipping = 0;
                for (NSDictionary *dict in model.shipping_lines){
                    shipping += [[dict objectOrNilForKey:@"total"] intValue];
                }
                orderDetail.shippingFee = [NSString stringWithFormat:@"%ld",(long)shipping];
                
                //获取小计
                NSInteger subtotal = 0;
                
                //获取order name
                NSString *name;
                for (int i=0; i< model.line_items.count; i++) {
                    EGLineItemModel *model2 = [EGLineItemModel mj_objectWithKeyValues: model.line_items[i]];
                    subtotal +=[model2.total intValue];
                    if (i==0) {
                        name = model2.name?:@"";
                    }
                    
                    EGOrderProductInfo *product = [EGOrderProductInfo new];
                    product.title = model2.name?:@"";
                    
                    //产品花费（）
                    product.price = model2.total?:@"";
                    //产品图片
                    product.imageUrl = model2.image.src?:@"";
                    
                    //获取购买产品详细信息
                    [orderDetail.products addObject:product];
                }
                orderDetail.subtotal = [NSString stringWithFormat:@"%ld",subtotal];
                
                //使用红利点数 meta_data 中的meta_data
                for (NSDictionary *dict in model.meta_data){
                    NSString *key = [dict objectForKey:@"key"];
                    if ([key isEqualToString:@"th_points_get"]) {
                        NSDictionary *value = [dict objectForKey:@"value"];
                        if ([value isKindOfClass:[NSDictionary class]]) {
                            NSNumber *totalPoints = [value objectForKey:@"total_points"];
                            //获得红利点数
                            orderDetail.bonusEarned = [totalPoints stringValue];
                        }
                    } else if ([key isEqualToString:@"th_points_use"]) {
                        id value = [dict objectForKey:@"value"];
                        if ([value isKindOfClass:[NSString class]]) {
                            orderDetail.bonusUsed = value;
                        } else if ([value isKindOfClass:[NSNumber class]]) {
                            orderDetail.bonusUsed = [value stringValue];
                        }
                    }
                }
                orderDetail.bonusUsed = orderDetail.bonusUsed?:@"";
                orderDetail.bonusEarned = orderDetail.bonusEarned?:@"";
                //orderDetail
                [self.orderList addObject:@{
                    @"orderId": model.ID,
                    @"title": name?name:@"",
                    @"price": model.total?model.total:@"",
                    @"date": formattedDate?formattedDate:@"",
                    @"orderDetail":orderDetail
                }];
                consumption += [model.total integerValue];
            }
            self.totalSpent_shop = consumption;
            // 更新累计消费信息
//            [self updateConsumptionInfo:consumption];
            [self getTotalSpent];
            // 刷新表格
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView2 reloadData];
                [self.tableView2.mj_header endRefreshing];
            });
            
        } failure:^(NSError *error) {
            //没有数据时清空
            [self noDataClearOldData];
        }];
        
    } failure:^(NSError * _Nonnull error) {
        [self noDataClearOldData];
    }];
}

-(void)getUserOrdersBy:(NSString *)userID success:(void (^)(id response)) success failure:(void (^)(NSError *error))failure {
    
    // 组合用户名和密码
    NSString *authString = [NSString stringWithFormat:@"%@:%@", [[EGCredentialManager sharedManager] getUsername], [[EGCredentialManager sharedManager] getPassword]];    // Base64 编码
    NSData *authData = [authString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64AuthString = [authData base64EncodedStringWithOptions:0];
    // 添加 Basic Auth 请求头
    NSString *authHeader = [NSString stringWithFormat:@"Basic %@", base64AuthString];
 
    NSDictionary *dict_header = @{@"Authorization":authHeader};
    
    NSString *url = [EGServerAPI getUserOrders:userID pagesize:@"10"];
    [[WAFNWHTTPSTool sharedManager] getWithURL:url parameters:@{} headers:dict_header success:^(id  _Nonnull response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

//MARK: 没有数据时清空
- (void)noDataClearOldData
{
    //没有数据时清空
    [self.orderList removeAllObjects];
    // 更新累计消费信息
//        [self updateConsumptionInfo:0];
    [self getTotalSpent];
    
    self.userID = nil;
    
    [self.tableView2 reloadData];
    [self.tableView2.mj_header endRefreshing];
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sections[section][@"items"] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sections[section][@"title"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {


    NSDictionary *section = self.sections[indexPath.section];
    NSDictionary *item = section[@"items"][indexPath.row];
    
    if (indexPath.section == 0) {
        // 会员信息单元格
        EGMemberCardCell *cell= [EGMemberCardCell cellWithUITableView:tableView];
        [cell setupWithInfo:item ];
        cell.delegate = self;
        [cell.barcodeButton setHidden:![EGLoginUserManager isLogIn]];
        cell.showBarcodeBlock = ^{
            if (!self.infoModel.Code) {
                return;
            }
            
//            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[EGMemberCodeViewController new]];
//            nav.navigationBar.backgroundColor = UIColor.clearColor;
//            nav.modalPresentationStyle = UIModalPresentationFullScreen;
//            [self presentViewController:nav animated:true completion:^{
//            }];
            
            EGMemberCodeViewController *memberVC = [[EGMemberCodeViewController alloc] init];
            memberVC.memberCode =@""; //self.infoModel.Code?self.infoModel.Code:@"";
            memberVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self presentViewController:memberVC animated:YES completion:nil];
        };
        return cell;
    } else if (indexPath.section == 1) {
        // 功能按钮单元格
        EGMemberActivitiesCell *cell= [EGMemberActivitiesCell cellWithUITableView:tableView];
//        [cell setupWithInfo:item ];

        cell.goAroundBtnBlock = ^{
            if (![EGLoginUserManager isLogIn]) {
                EGNavigationController *nav = [[EGNavigationController alloc] initWithRootViewController:[EGLogInViewController new]];
                nav.modalPresentationStyle = UIModalPresentationFullScreen;
                nav.navigationBar.backgroundColor = rgba(16, 38, 73, 1);
                [self presentViewController:nav animated:true completion:^{
                }];
                return;
            }
            GoroundViewController *controller = [GoroundViewController new];
            [self.navigationController pushViewController:controller animated:YES];
        } ;
        cell.showliveActivities = ^{
            if (![EGLoginUserManager isLogIn]) {
                EGNavigationController *nav = [[EGNavigationController alloc] initWithRootViewController:[EGLogInViewController new]];
                nav.modalPresentationStyle = UIModalPresentationFullScreen;
                nav.navigationBar.backgroundColor = rgba(16, 38, 73, 1);
                [self presentViewController:nav animated:true completion:^{
                }];
                return;
            }
            [EGComingSoonPopupView showInView:nil];
        };
        return cell;
    }else if (indexPath.section == 4){
        // 功能按钮单元格
        EGSocialLinksCell *cell = [EGSocialLinksCell cellWithUITableView:tableView];

               cell.selectionStyle = UITableViewCellSelectionStyleNone;
               return cell;
    }
    else {
        
        if(indexPath.section==3&& indexPath.row==1)//通知cell
        {
            EGNotificationSettingCell *cell = [EGNotificationSettingCell cellWithUITableView:tableView];
            cell.gSwitchBlock = ^(BOOL select){
                
                NSNumber *b = [NSNumber numberWithBool:select];
                [[NSUserDefaults standardUserDefaults] setObject:b forKey:@"usenotificationsetting"];
                
                [self allowNotifications:[NSString stringWithFormat:@"%d",select]];
                
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"Cell222"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            NSDictionary *sectionData = self.sections[indexPath.section];
            id item = sectionData[@"items"][indexPath.row];
            cell.textLabel.font =  [UIFont systemFontOfSize:/*ScaleW(14)*/ScaleW(16) weight:(UIFontWeightMedium)];
            cell.textLabel.textColor = rgba(64, 64, 64, 1);
            
            if ([item isKindOfClass:[NSDictionary class]]) {
                cell.textLabel.text = item[@"title"];
//                NSLog(@"%@",item[@"title"]);
                if ([item[@"isNew"] boolValue]) {
                    UILabel *newLabel = [[UILabel alloc] init];
                    newLabel.text = @"New";
                    newLabel.textAlignment = NSTextAlignmentCenter;
                    newLabel.textColor = rgba(153, 27, 27, 1);
                    newLabel.font = [UIFont systemFontOfSize:FontSize(14)];
                    //                  [newLabel sizeToFit];
                    [newLabel setFrame:CGRectMake(Device_Width - ScaleW(110), ScaleW(15), ScaleW(49), ScaleW(24))];
                    newLabel.layer.cornerRadius = ScaleW(12);
                    newLabel.layer.backgroundColor = rgba(254, 226, 226, 1).CGColor;
                    cell.accessoryView = newLabel;
                    //[cell.contentView addSubview:newLabel];
                }
                else
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else{
                cell.textLabel.text = item;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            return cell;
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==2 ||section==3 ) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
        headerView.backgroundColor = [UIColor colorWithRed:0.962 green:0.962 blue:0.962 alpha:1.0];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ScaleW(30), 200, ScaleW(14))];
        titleLabel.text = self.sections[section][@"title"];
        titleLabel.textColor = rgba(0, 78, 162, 1);
        titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
        [headerView addSubview:titleLabel];
        
        return headerView;
    }else{
        return  [UIView new];
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==2 ||section==3 ) {
        return ScaleW(62);
    }else if(section==4){
        return ScaleW(30);;
    }else{
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==2 ||indexPath.section==3 ) {
        return ScaleW(56);
    }else if(indexPath.section==4){
        return UITableViewAutomaticDimension;
    }else{
        return UITableViewAutomaticDimension;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==2)
    {
        switch (indexPath.row) {
//            case 0://成就勋章
//            {
//                if (![EGLoginUserManager isLogIn]) {
//                    WS(weakSelf);
//                    EGLogInViewController *login = [EGLogInViewController new];
//                    EGNavigationController *nav = [[EGNavigationController alloc] initWithRootViewController:login];
//                    nav.modalPresentationStyle = UIModalPresentationFullScreen;
//                    nav.navigationBar.backgroundColor = rgba(0, 71, 56, 1);
//                    login.logInBlock = ^{
//                        [weakSelf setupData];
//                    };
//                    [self presentViewController:nav animated:true completion:^{
//                    }];
//                    return;
//                }
//                EGmedalViewController*vc = [EGmedalViewController new];
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//                break;
                
            case 0://球队战绩
            {
                EGTeamperformanceViewController *vc = [EGTeamperformanceViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1://球队成员
            {
//                EGPlayerSupportingViewController *vc = [EGPlayerSupportingViewController new];
//                [self.navigationController pushViewController:vc animated:YES];
                EGPublicWebViewController *webVc = [[EGPublicWebViewController alloc] init];
                webVc.navigationItem.title = @"球隊成員";
                    webVc.webUrl = @"https://20.189.240.127/players";
                [self.navigationController pushViewController:webVc animated:true];
            }
                break;
//            case 2://球队升降
//            {
////                EGPublicWebViewController *webVc = [[EGPublicWebViewController alloc] init];
////                webVc.navigationItem.title = @"球隊升降";
////                    webVc.webUrl = @"https://www.cpbl.com.tw/team/trans?ClubNo=AKP";
////                [self.navigationController pushViewController:webVc animated:true];
//                
//                
////                EGPlayerliftandlowerViewController *vc = [EGPlayerliftandlowerViewController new];
////                [self.navigationController pushViewController:vc animated:YES];
////                [self openLink:@"https://www.cpbl.com.tw/team/trans?ClubNo=AKP"];
//            }
//                break;
            case 2://应援资讯
            {
                if (![EGLoginUserManager isLogIn]) {
                    WS(weakSelf);
                    EGLogInViewController *login = [EGLogInViewController new];
                    EGNavigationController *nav = [[EGNavigationController alloc] initWithRootViewController:login];
                    nav.modalPresentationStyle = UIModalPresentationFullScreen;
                    nav.navigationBar.backgroundColor = rgba(16, 38, 73, 1);
                    login.logInBlock = ^{
                        [weakSelf setupData];
                    };
                    [self presentViewController:nav animated:true completion:^{
                    }];
                    return;
                }
//                EGFanSupportingViewController *vc = [EGFanSupportingViewController new];
//                [self.navigationController pushViewController:vc animated:YES];
                EGPublicWebViewController *webVc = [[EGPublicWebViewController alloc] init];
                webVc.navigationItem.title = @"應援資訊";
                    webVc.webUrl = @"";
                [self.navigationController pushViewController:webVc animated:true];
            }
                break;
            case 3://关于雄鹰
            {
                
                EGPublicWebViewController *webVc = [[EGPublicWebViewController alloc] init];
                webVc.navigationItem.title = @"關於天鷹";
                    webVc.webUrl = @"https://20.189.240.127/about-hawks/";
                [self.navigationController pushViewController:webVc animated:true];
//                [self openLink:@"https://www.tsghawks.com/about-hawks/"];
            }
                break;
            case 4://球场介绍
            {
                EGPublicWebViewController *webVc = [[EGPublicWebViewController alloc] init];
                webVc.navigationItem.title = @"球場介紹";
                webVc.webUrl = @"https://20.189.240.127/fan/chengching-lake-baseball-field/";
                [self.navigationController pushViewController:webVc animated:true];
////                [self openLink:@"https://www.tsghawks.com/fan/chengching-lake-baseball-field/"];
                
//                EGStadiumIntroductionViewController *vc = [EGStadiumIntroductionViewController new];
//                [self.navigationController pushViewController:vc animated:YES];
                
                
            }
                break;
//            case 6://球迷回馈
//            {
////                EGPublicWebViewController *webVc = [[EGPublicWebViewController alloc] init];
////                webVc.navigationItem.title = @"球迷回饋";
////                webVc.webUrl = @"https://www.tsghawks.com/fan/download/";
////                [self.navigationController pushViewController:webVc animated:true];
//                [self openLink:@"https://www.surveycake.com/s/LnnMR"];
//                // 在需要使用 taskID 的地方
//                [self getTask:^(BOOL success) {
//                    if (success) {
//                        NSString *taskID = [EGTaskManager sharedManager].taskID;
//                        if (taskID) {
//                            //需要调用check in 加点
//                            [self pointGrant:@{@"UUID":taskID}
//                                  completion:^(BOOL success) {
//                                if (success) {
//                                    // 处理成功情况
//                                    dispatch_async(dispatch_get_main_queue(), ^{
//
//                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskStatusUpdateNotification"
//                                                                                            object:nil
//                                                                                          userInfo:@{
//                                            @"section": @"",
//                                            @"index": @"",
//                                            @"status": @"",
//                                            @"points": @""
//                                        }];
//                                    });
//                                } else {
//                                    // 处理失败情况
//                                    NSLog(@"添加点数失败");
//                                }
//                            }
//                            ];
//                        }
//                    }
//                }];
//            }
//                break;
            case 5:
            {
                if (![EGLoginUserManager isLogIn]) {
                    WS(weakSelf);
                    EGLogInViewController *login = [EGLogInViewController new];
                    EGNavigationController *nav = [[EGNavigationController alloc] initWithRootViewController:login];
                    nav.modalPresentationStyle = UIModalPresentationFullScreen;
                    nav.navigationBar.backgroundColor = rgba(0, 78, 162, 1);
                    login.logInBlock = ^{
                        [weakSelf setupData];
                    };
                    [self presentViewController:nav animated:true completion:^{
                    }];
                    return;
                }
                EGrouPhotoViewController *photoVC = [[EGrouPhotoViewController alloc] init];
                [self.navigationController pushViewController:photoVC animated:true];
            }
                break;
            case 6:
            {
                if (![EGLoginUserManager isLogIn]) {
                    WS(weakSelf);
                    EGLogInViewController *login = [EGLogInViewController new];
                    EGNavigationController *nav = [[EGNavigationController alloc] initWithRootViewController:login];
                    nav.modalPresentationStyle = UIModalPresentationFullScreen;
                    nav.navigationBar.backgroundColor = rgba(16, 38, 73, 1);
                    login.logInBlock = ^{
                        [weakSelf setupData];
                    };
                    [self presentViewController:nav animated:true completion:^{
                    }];
                    return;
                }
                EGEagleFansWorldViewController *photoVC = [[EGEagleFansWorldViewController alloc] init];
                [self.navigationController pushViewController:photoVC animated:true];
            }
                break;
        }
    }
    
    if(indexPath.section==3)
    {
        NSDictionary *sectionData = self.sections[3];
        id tempid = sectionData[@"items"][indexPath.row];
        
        NSString * item = @"";
        if ([tempid isKindOfClass:[NSDictionary class]]) {
            item = tempid[@"title"];
        }
        else
           item = tempid;

        if ([item isEqualToString:@"會員資料"]) {
            if (![EGLoginUserManager isLogIn]) {
                WS(weakSelf);
                EGLogInViewController *login = [EGLogInViewController new];
                EGNavigationController *nav = [[EGNavigationController alloc] initWithRootViewController:login];
                nav.modalPresentationStyle = UIModalPresentationFullScreen;
                nav.navigationBar.backgroundColor = rgba(0, 78, 162, 1);
                login.logInBlock = ^{
                    [weakSelf setupData];
                };
                [self presentViewController:nav animated:true completion:^{
                }];
                return;
            }
            EGMemberInfoViewController *vc = [EGMemberInfoViewController new];
            vc.infomationBlock = ^(NSString * _Nonnull invoice_number) {
                if ([invoice_number isEqualToString:@"cancelUser"]) {//假註銷
                    [EGLoginUserManager logout];
                    [self setupData];
                    [self.orderList removeAllObjects];
                    self.infoModel = nil;
                    self.userID = nil;
                    
                    self.consumption = @"0";
                }
            };
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if ([item isEqualToString:@"通知設定"]) {
            
        }else if ([item isEqualToString:@"使用導覽"]) {
            EGUserGuideViewController *vc = [EGUserGuideViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if ([item isEqualToString:@"常見問題"]) {
//            EGCustomerProblemController *vc = [EGCustomerProblemController new];
//            [self.navigationController pushViewController:vc animated:YES];
            
            EGFAQViewController *vc = [EGFAQViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if ([item isEqualToString:@"聯絡客服"]) {
            [self sendEmailToCustom];
            //                    EGCustomerServiceController *vc = [EGCustomerServiceController new];
            //                    [self.navigationController pushViewController:vc animated:YES];
            
//            EGiftDetailController *giftVc = [EGiftDetailController new];
//            giftVc.goods_id = @"ddd";
//            giftVc.from_type = 0;
//            [self.navigationController pushViewController:giftVc animated:true];
            
            
            
        }else if ([item isEqualToString:@"隱私條款"]) {
//            EGPolicyViewController *policyVC = [[EGPolicyViewController alloc] init];
//            policyVC.type = 1;
//            [self.navigationController presentViewController:policyVC animated:YES completion:^{
//                
//            }];
            EGTermsViewController *ServiceVC = [[EGTermsViewController alloc] init];
            ServiceVC.navigationItem.title = @"隱私條款";
            [self.navigationController pushViewController:ServiceVC animated:YES];
            
        }else if ([item isEqualToString:@"使用者服務條款"]) {
            EGTermsViewController *ServiceVC = [[EGTermsViewController alloc] init];
            ServiceVC.navigationItem.title = @"使用者條款";
            [self.navigationController pushViewController:ServiceVC animated:YES];
//            [self.navigationController presentViewController:ServiceVC animated:YES completion:^{
//            }];
//            EGRegRulesViewController  *ServiceVC = [[EGRegRulesViewController alloc] init];
            
        }else if ([item isEqualToString:@"進場任務設定檢測"]) {
            EGBeaconTestViewController *BeaconTest = [[EGBeaconTestViewController alloc] init];
            [self.navigationController pushViewController:BeaconTest animated:true];
            
        }else if ([item isEqualToString:@"會員登入"] || [item isEqualToString:@"登出"] ) {
            [self logOutBtnMethod];
        }
    }
}


//获取member任务 添加完成回调，完成后再做后面的事情
-(void)getTask:(void(^)(BOOL success))completion {
    
    UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
    if (!model) {
        if (completion) {
            completion(NO);
        }
        return;
    }
    
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
    NSDictionary *dict_header = @{@"Authorization":tokenString};
    
    MemberInfomationModel *infoModel = [EGLoginUserManager getMemberInfomation];
    if (!infoModel) {
        return;
    }
    NSDictionary *dict_body = @{@"Mobile":infoModel.Phone};
    NSString *url =  [EGServerAPI basicMemberGenqrcode:model.ID];
    [[WAFNWHTTPSTool sharedManager] postWithURL:url parameters:dict_body headers:dict_header success:^(NSDictionary * _Nonnull response) {
        
        
        if (![response isKindOfClass:[NSDictionary class]]) {
            return;
        }
        NSDictionary *data = [response objectOrNilForKey:@"data"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            return;
        }
        NSString *qrCode =  [data objectOrNilForKey:@"MEMQRCODE"];
        if (!qrCode || ![qrCode isKindOfClass:[NSString class]]) {
            return;
        }
        
        NSString *url2 = [EGServerAPI getEventmembertasks:qrCode];
        //  NSString *url2 = [EGServerAPI getEventtasks];
        [[WAFNWHTTPSTool sharedManager] getWithURL:url2 parameters:@{} headers:dict_header success:^(NSDictionary * _Nonnull response) {
//            ELog(@"%@",response);
            NSArray *array  = [EGTaskeventsModel mj_objectArrayWithKeyValuesArray:response];
            for (EGTaskeventsModel * model in array) {
                if ( [model.triggerTag isEqualToString:@"survey"] && [model.personalEventTaskStatus isEqualToString:@"pending"]) {
                    [EGTaskManager sharedManager].taskID = model.ID;
                    if (completion) {
                        completion(YES);
                    }
                }
            }
            if (completion) {
                completion(NO);
            }
            
            
        } failure:^(NSError * _Nonnull error) {
            
            if (completion) {
                completion(NO);
            }
        }];
        
    } failure:^(NSError * _Nonnull error) {

        if (completion) {
            completion(NO);
        }
    }];
}

-(void)pointGrant:(NSDictionary *)para completion:(void(^)(BOOL success))completion {
    UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
//    EGUserOauthModel *model = [EGLoginUserManager getOauthDataModel];
    if (!model) {
       // [self.tableView.mj_header endRefreshing];
        if (completion) {
            completion(NO);
        }
        return;
    }
    
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
    NSDictionary *dict_header = @{@"Authorization":tokenString};
    
    MemberInfomationModel *infoModel = [EGLoginUserManager getMemberInfomation];
    if (!infoModel) {
        return;
    }
    NSDictionary *dict_body = @{@"Mobile":infoModel.Phone};
    NSString *url =  [EGServerAPI basicMemberGenqrcode:model.ID];
    [[WAFNWHTTPSTool sharedManager] postWithURL:url parameters:dict_body headers:dict_header success:^(NSDictionary * _Nonnull response) {
        
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
        
     
        //这里调用 check IN
        NSString *url2 = [EGServerAPI getEventcheckins];
        NSDictionary *dict = @{@"encryptedIdentity":qrCode,@"taskId":para[@"UUID"]};
        ELog(@"url2:%@",url2);
        [[WAFNWHTTPSTool sharedManager] postWithURL:url2 parameters:dict headers:dict_header success:^(NSDictionary * _Nonnull response) {

            if (completion) {
                completion(YES);
            }
            //后台调用网络求情刷新点数
            [self.tableView reloadData];
            
        } failure:^(NSError * _Nonnull error) {
//            if ([error.localizedDescription containsString:@"offline"]) {
//                [MBProgressHUD showDelayHidenMessage:@"請檢查您的網路連線，確保裝置已連接至網路後再重試。"];
//            }else{
//                [MBProgressHUD showDelayHidenMessage:error.localizedDescription];
//            }
        }];

    } failure:^(NSError * _Nonnull error) {

//        if ([error.localizedDescription containsString:@"offline"]) {
//            [MBProgressHUD showDelayHidenMessage:@"請檢查您的網路連線，確保裝置已連接至網路後再重試。"];
//        }else{
//            [MBProgressHUD showDelayHidenMessage:error.localizedDescription];
//        }
        if (completion) {
            completion(NO);
        }
    }];
}

-(void)logOutBtnMethod
{
    if (![EGLoginUserManager isLogIn]) {
        WS(weakSelf);
        EGLogInViewController *login = [EGLogInViewController new];
        EGNavigationController *nav = [[EGNavigationController alloc] initWithRootViewController:login];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        nav.navigationBar.backgroundColor = rgba(16, 38, 73, 1);
        login.logInBlock = ^{
            [weakSelf setupData];
        };
        [self presentViewController:nav animated:true completion:^{
        }];
        return;
    }
    
    [ELAlertController alertControllerWithTitleName:@"系統退出" andMessage:@"是否要登出？" cancelButtonTitle:@"否" confirmButtonTitle:@"是" showViewController:self addCancelClickBlock:^(UIAlertAction * _Nonnull cancelAction) {
            
        } addConfirmClickBlock:^(UIAlertAction * _Nonnull SureAction) {
            [EGLoginUserManager logout];
            [self setupData];
            [self.orderList removeAllObjects];
            self.infoModel = nil;
            self.userID = nil;
            self.consumption = @"0";
            self.totalSpent_shop = 0;
            [self.leftBtn setTitle:[EGLoginUserManager isLogIn] ? NSLocalizedString(@"會員", nil) : NSLocalizedString(@"登入", nil) forState:(UIControlStateNormal)];
        }];
}

#pragma mark - 联系客服 and MFMailComposeViewControllerDelegate
-(void)sendEmailToCustom
{
    if (![MFMailComposeViewController canSendMail]) {
//        @"tsghawks.baseball@gmail.com"
        NSString *subject = @"";
        NSString *body = @"";
        NSString *address = @"Service@TSGhawks.com";
       
        NSString *cc = @"";
        NSString *path = [NSString stringWithFormat:@"mailto:%@?cc=%@&subject=%@&body=%@", address, cc, subject, body];
        NSURL *url = [NSURL URLWithString:[path  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        // 创建一个字典来包含打开URL时的选项
        NSDictionary *options = @{};
        
        [[UIApplication sharedApplication] openURL:url options:options completionHandler:^(BOOL success) {
        }];}
    else{
        MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
        [mailVC setToRecipients:@[@"Service@TSGhawks.com"]];/* 收件人列表 */
        mailVC.mailComposeDelegate = self;
        [self presentViewController:mailVC animated:YES completion:nil];
    }
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error {
    // 邮件发送结果处理
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail sending canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sending failed");
            break;
        default:
            break;
    }
}

#pragma mark 使用Browser打开某些页面 and SFSafariViewControllerDelegate
-(void)openLink:(NSString*)webLink
{
    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:webLink]];
    safariVC.delegate = self;
    [self presentViewController:safariVC animated:YES completion:nil];
    
}

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    //当用户添加事件成功后，关闭safariVC
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)xiongying
{
//    [self openLink:@"https://hawkmember.dtix.tw/"];
    
    EGMembershipLevelViewController *membershipVC = [[EGMembershipLevelViewController alloc] init];
    membershipVC.MemberCards = [NSMutableArray arrayWithArray: self.infoModel.MemberCards];
    [self.navigationController pushViewController:membershipVC animated:YES];
}

-(void)leftBtnClick:(UIButton *)sender{
    if (![EGLoginUserManager isLogIn]) {
        WS(weakSelf);
        EGLogInViewController *login = [EGLogInViewController new];
        EGNavigationController *nav = [[EGNavigationController alloc] initWithRootViewController:login];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        nav.navigationBar.backgroundColor = rgba(0, 78, 162, 1);
        login.logInBlock = ^{
            [weakSelf setupData];
        };
        [self presentViewController:nav animated:true completion:^{
        }];
        return;
    }
}


#pragma mark EGMemberCardCellDelegate
// 实现代理方法
- (void)didTapConsumptionRecord {
    if (![EGLoginUserManager isLogIn]) {
        WS(weakSelf);
        EGLogInViewController *login = [EGLogInViewController new];
        EGNavigationController *nav = [[EGNavigationController alloc] initWithRootViewController:login];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        nav.navigationBar.backgroundColor = rgba(16, 38, 73, 1);
        login.logInBlock = ^{
            [weakSelf setupData];
        };
        [self presentViewController:nav animated:true completion:^{
        }];
        return;
    }
    EGConsumptionRecordViewController *vc = [[EGConsumptionRecordViewController alloc] init];
    vc.userEmail = self.newsoftUserEmail;
    vc.orderList = self.orderList;
    vc.userID = self.userID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didTapMembershipCard {
    if (![EGLoginUserManager isLogIn]) {
        WS(weakSelf);
        EGLogInViewController *login = [EGLogInViewController new];
        EGNavigationController *nav = [[EGNavigationController alloc] initWithRootViewController:login];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        nav.navigationBar.backgroundColor = rgba(0, 78, 162, 1);
        login.logInBlock = ^{
            [weakSelf setupData];
        };
        [self presentViewController:nav animated:true completion:^{
        }];
        return;
    }
//    EGMembershipLevelViewController *membershipVC = [[EGMembershipLevelViewController alloc] init];
//    [self.navigationController pushViewController:membershipVC animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)allowNotifications:(NSString *)state
{
    NSDictionary *dict;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSString *loginTime = [formatter stringFromDate:[NSDate date]];
    loginTime = [loginTime stringByReplacingOccurrencesOfString:@" " withString:@"T"];
    NSString *uuidStr = [UIDevice currentDevice].identifierForVendor.UUIDString;
    NSString *fcmToken = [kUserDefaults objectForKey:FCMTokenInfo];
    if (!fcmToken) {
        return;
    }
    
    if ([EGLoginUserManager isLogIn]) {
        UserInfomationModel *userModel = [EGLoginUserManager getUserInfomation];
        MemberInfomationModel *member = [EGLoginUserManager getMemberInfomation];
        dict = @{
            @"deviceId": uuidStr,
            @"fcmToken": fcmToken,
            @"deviceIsPush": state,
            @"deviceType": @(0),
            @"memberType": @(1),
            @"loginTime": [loginTime stringByAppendingString:@"+08:00"],
            @"crmMemberToken":userModel.accessToken ? userModel.accessToken :@"",
            @"userName":member.Name ? member.Name :@"",
            @"crmMemberId":userModel.ID ? userModel.ID :@""
        };
        
    }else{
        EGUserOauthModel *oauthModel = [EGLoginUserManager getOauthDataModel];
        dict = @{
            @"deviceId": uuidStr,
            @"fcmToken": fcmToken,
            @"deviceIsPush": state,
            @"deviceType": @(0),
            @"memberType": @(0),
            @"loginTime": [loginTime stringByAppendingString:@"+08:00"],
            @"crmClientToken":oauthModel.accessToken ? oauthModel.accessToken :@""
        };
    }
    EGRelayTokenModel *tokenModel = [EGLoginUserManager getRelayToken];
    NSDictionary *headerDict = @{@"Authorization":tokenModel.token ? tokenModel.token:@""};
    [[WAFNWHTTPSTool sharedManager] postWithURL:[EGServerAPI mobile_crm_API] parameters:dict headers:headerDict success:^(NSDictionary * _Nonnull response) {
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}

@end
