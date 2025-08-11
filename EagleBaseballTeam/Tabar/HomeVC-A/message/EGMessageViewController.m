//
//  EGMessageViewController.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/11.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGMessageViewController.h"
#import "EGTopButtonsView.h"
#import "EGTmpDataManager.h"
#import "EGActivityMegTableViewCell.h"
#import "EGMessageModel.h"
#import "EGActivityNotifcationDetailViewController.h"
#import "EGMainTabBarController.h"
#import "EGGoodsExchangeController.h"
#import "EGActivityExchangeViewController.h"
#import "EGActivityDetailViewController.h"
#import "EGiftDetailController.h"
#import "EGComingSoonPopupView.h"

@interface EGMessageViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) EGTopButtonsView *topBtnView;

@property (nonatomic, strong) UIScrollView *mainscrollView;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;

@property (nonatomic, assign) BOOL isUserScrolling;
@property (nonatomic, assign) BOOL isRightView;

@property (nonatomic, strong) NSMutableArray *activitys;
@property (nonatomic, strong) NSMutableArray *systems;

@property (nonatomic, assign) NSInteger leftPage;
@property (nonatomic, assign) NSInteger rightPage;

@property (nonatomic, assign) NSInteger totalpoint;

@property (nonatomic, strong) NSString *memberCode;
@end

@implementation EGMessageViewController

- (NSMutableArray *)activitys
{
    if (!_activitys) {
        _activitys = [NSMutableArray array];
    }
    return _activitys;
}

- (NSMutableArray *)systems
{
    if (!_systems) {
        _systems = [NSMutableArray array];
    }
    return _systems;
}
- (UITableView *)leftTableView
{
    if (_leftTableView == nil) {
        
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _leftTableView.tag = 555;
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.backgroundColor = [UIColor clearColor];
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.estimatedRowHeight = 100;
        _leftTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.leftPage = 1;
            [self getDataMethod];
            [self getMessageStatus];
        }];
        _leftTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            self.leftPage++;
            [self getDataMethod];
        }];
    }
    return _leftTableView;
}
- (UITableView *)rightTableView
{
    if (_rightTableView == nil) {
        _rightTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _rightTableView.tag = 666;
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.backgroundColor = [UIColor clearColor];
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.showsVerticalScrollIndicator = NO;
        _rightTableView.estimatedRowHeight = 100;
        _rightTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.rightPage = 1;
            [self getDataMethod];
            [self getMessageStatus];
        }];
        
        _rightTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            self.rightPage++;
            [self getDataMethod];
        }];
    }
    return _rightTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"訊息通知";
    self.view.backgroundColor = rgba(243, 243, 243, 1);
    
    [self getDataQrcode];
    
    self.isRightView = false;
    //布局
    [self createUILayout];
    
    self.leftPage = 1;
    self.rightPage = 1;
    
    [self fetchMemberInfomation];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getMessageStatus];
    [self getDataMethod];
}

-(void)fetchMemberInfomation {
    WS(weakSelf);
    [[EGetTokenViewModel sharedManager] fetchMemberInfo:^(BOOL isSuccess) {
        if (isSuccess) {
            NSInteger points = [EGLoginUserManager getMemberInfoPoints].Points;
            weakSelf.totalpoint = points;
        }
    }];
}
-(void)getDataMethod
{
    UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
    if (!model) {
        return;
    }
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
    NSDictionary *dict_header = @{@"Authorization":tokenString};
    NSString *url ;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    if (self.isRightView) {
        url = [EGServerAPI messageList_api:model.ID page:[NSString stringWithFormat:@"%ld",self.rightPage] type:@"system"];
    }else{
        url = [EGServerAPI messageList_api:model.ID page:[NSString stringWithFormat:@"%ld",self.leftPage] type:@"activity"];
    }
    
    [[WAFNWHTTPSTool sharedManager] getWithURL:url parameters:parameters headers:dict_header success:^(NSDictionary * _Nonnull response) {
        
        NSArray *array = response[@"data"];
        NSArray *model = [EGMessageModel mj_objectArrayWithKeyValuesArray:array];
        
        NSDictionary *metaDict = response[@"meta"];
        NSInteger total = [metaDict[@"total"] intValue];
        
        if (self.isRightView) {
            if (self.rightPage == 1) {
                [self.systems removeAllObjects];
                [self.rightTableView.mj_header endRefreshing];
            }
            [self.systems addObjectsFromArray:model];
            
            if (self.systems.count == total) {
                [self.rightTableView.mj_footer endRefreshingWithNoMoreData];
                
            }else{
                [self.rightTableView.mj_footer endRefreshing];
            }
            
            [self.rightTableView reloadData];
            
        }else{
            
            if (self.leftPage == 1) {
                [self.activitys removeAllObjects];
                [self.leftTableView.mj_header endRefreshing];
            }
            [self.activitys addObjectsFromArray:model];
            
            if (self.activitys.count == total) {
                [self.leftTableView.mj_footer endRefreshingWithNoMoreData];
                
            }else{
                [self.leftTableView.mj_footer endRefreshing];
            }
            [self.leftTableView reloadData];
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        
        if ([error.localizedDescription containsString:@"offline"] || error.code == -1009) {
            [MBProgressHUD showDelayHidenMessage:@"請檢查您的網路連線，確保裝置已連接至網路後再重試。"];
        }else{
            [MBProgressHUD showDelayHidenMessage:error.localizedDescription];
        }
        
    }];
}

-(void)createUILayout
{
    WS(weakSelf);
    CGRect rectTop = CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, ScaleW(52));
    self.topBtnView = [[EGTopButtonsView alloc] initWithFrame:rectTop];
    [self.topBtnView setupUIForArray:@[@"活動通知",@"系統通知"]];
    self.topBtnView.clickBtnBlock = ^(NSInteger index) {
        weakSelf.isRightView = index;
        [weakSelf getDataMethod];
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf.mainscrollView setContentOffset:CGPointMake(index * Device_Width, 0)];
        }];
    };
    [self.view addSubview:self.topBtnView];
    
    UIButton *messageStatusBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    messageStatusBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:(UIFontWeightMedium)];
    [messageStatusBtn setImage:[UIImage imageNamed:@"read"] forState:UIControlStateNormal];
    [messageStatusBtn setTitle:@"全部已讀" forState:UIControlStateNormal];
    [messageStatusBtn setTitleColor:rgba(0, 0, 0, 0.75) forState:UIControlStateNormal];
    [messageStatusBtn addTarget:self action:@selector(messageStatusBtnMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:messageStatusBtn];
    [messageStatusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ScaleW(24));
        make.width.mas_equalTo(ScaleW(88));
        make.right.mas_equalTo(-ScaleW(5));
        make.top.equalTo(self.topBtnView.mas_bottom).offset(ScaleW(8));
    }];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:messageStatusBtn];
    
    // 滚动视图
    CGFloat scrtop = [UIDevice de_navigationFullHeight] + ScaleW(96);
    CGRect rectScro = CGRectMake(0, scrtop, Device_Width, Device_Height - scrtop);
    self.mainscrollView = [[UIScrollView alloc] init];
    self.mainscrollView.frame = rectScro;
    self.mainscrollView.backgroundColor = [UIColor colorWithRed:0.962 green:0.962 blue:0.962 alpha:1.0];
    self.mainscrollView.delegate = self;
    self.mainscrollView.pagingEnabled = YES;
    self.mainscrollView.scrollEnabled = YES;
    self.mainscrollView.bounces = YES;
    self.mainscrollView.showsHorizontalScrollIndicator = false;
    [self.view addSubview:self.mainscrollView];
    self.mainscrollView.contentSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width * 2, 0);
    
    
    CGRect contentRect = CGRectMake(0, 0, Device_Width*2, Device_Height-scrtop);
    UIView *contentview = [UIView new];
    contentview.backgroundColor = UIColor.clearColor;
    contentview.frame = contentRect;
    [self.mainscrollView addSubview:contentview];
    
    [contentview addSubview:self.leftTableView];
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(Device_Width);
        make.bottom.mas_equalTo(-[UIDevice de_safeDistanceBottom]);
    }];
    
    [contentview addSubview:self.rightTableView];
    [self.rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(Device_Width);
        make.width.mas_equalTo(Device_Width);
        make.bottom.mas_equalTo(-[UIDevice de_safeDistanceBottom]);
    }];
}

//MARK: all已读消息
-(void)messageStatusBtnMethod
{
    UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
    if (!model) {
        return;
    }
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
    NSDictionary *headerDict = @{@"Authorization":tokenString};
    
    NSString *url;
    if (self.isRightView) {
        url = [EGServerAPI allMessageMarkRead_api:model.ID type:@"system"];
    }else { url = [EGServerAPI allMessageMarkRead_api:model.ID type:@"activity"]; }
    [[WAFNWHTTPSTool sharedManager] postWithURL:url parameters:@{} headers:headerDict success:^(NSDictionary * _Nonnull response) {
        
        [self.topBtnView setRedViewStatueActivity:true systemView:true];
        [self getDataMethod];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark ----是否有未读
-(void)getMessageStatus
{
    UserInfomationModel *userModel = [EGLoginUserManager getUserInfomation];
    if (!userModel) {
        return;
    }
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",userModel.accessToken];
    NSDictionary *headerDict = @{@"Authorization":tokenString};
    
    NSString *url = [EGServerAPI messageUnRead_api:userModel.ID type:@"activity"];
    [[WAFNWHTTPSTool sharedManager] getWithURL:url parameters:@{} headers:headerDict success:^(NSDictionary * _Nonnull response) {
        
        NSDictionary *data = response[@"data"];
        BOOL isHave = [data[@"hasUnread"] intValue];
        self.topBtnView.redView_acivity.hidden = !isHave;
        
        } failure:^(NSError * _Nonnull error) {
            
        }];
    
    
    NSString *url_activity = [EGServerAPI messageUnRead_api:userModel.ID type:@"system"];
    [[WAFNWHTTPSTool sharedManager] getWithURL:url_activity parameters:@{} headers:headerDict success:^(NSDictionary * _Nonnull response) {
        
        NSDictionary *data = response[@"data"];
        BOOL isHave = [data[@"hasUnread"] intValue];
        self.topBtnView.redView_system.hidden = !isHave;
        
        } failure:^(NSError * _Nonnull error) {
            
        }];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if ([scrollView isKindOfClass:[UITableView class]])
    {
        return;
    }
    if (self.isUserScrolling) {
        NSInteger index = scrollView.contentOffset.x / UIScreen.mainScreen.bounds.size.width;
        [self.topBtnView setStatusLableForIndex:index];
    }
    
    [self getDataMethod];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isUserScrolling = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.isUserScrolling)
        return;
    
    if ([scrollView isKindOfClass:[UITableView class]])
    {
        return;
    }
    NSInteger index = scrollView.contentOffset.x / UIScreen.mainScreen.bounds.size.width;
    [self.topBtnView setStatusLableForIndex:index];
    
    self.isRightView = index;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if (tableView == self.leftTableView) {
        return self.activitys.count;
    }else{
        return self.systems.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView) {
        EGActivityMegTableViewCell *cell = [EGActivityMegTableViewCell cellWithUITableView:tableView];
        [cell setActivityModel:self.activitys[indexPath.row]];
        return cell;
        
    }else{
        
        NotificationTBVCell *cell = [NotificationTBVCell cellWithUITableView:tableView];
        [cell setSystemModel:self.systems[indexPath.row]];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScaleW(140);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EGMessageModel *model;
    if (!self.isRightView) {
        model = self.activitys[indexPath.row];
    }else{ model = self.systems[indexPath.row];}
    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
    UIViewController *rootViewController = window.rootViewController;
    EGMainTabBarController *tabBarController = (EGMainTabBarController *)rootViewController;
    
    if ([model.targetUrl isEqualToString:@"home"]) {
        [self.navigationController popViewControllerAnimated:true];
    }else if ([model.targetUrl isEqualToString:@"point"] || [model.targetUrl isEqualToString:@"task"]){
        tabBarController.selectedIndex = 1;
        [self.navigationController popViewControllerAnimated:true];
    }else if ([model.targetUrl isEqualToString:@"ticket"]){
        tabBarController.selectedIndex = 3;
        [self.navigationController popViewControllerAnimated:true];
    }else if ([model.targetUrl isEqualToString:@"member"]){
        tabBarController.selectedIndex = 0;
        [self.navigationController popViewControllerAnimated:true];
    }else if ([model.targetUrl isEqualToString:@"schedule"]){
        tabBarController.selectedIndex = 4;
        [self.navigationController popViewControllerAnimated:true];
    }else if ([model.targetUrl containsString:@"task."]){
        NSArray *array;
        if ([model.targetUrl containsString:@"."]) {
            array = [model.targetUrl componentsSeparatedByString:@"."];
            [self getTaskDetail:[array lastObject]];
           }
    }else if ([model.targetUrl containsString:@"coupon"]){
        if ([model.targetUrl isEqualToString:@"coupon"]){
            EGGoodsExchangeController *goods = [EGGoodsExchangeController new];
            goods.points = self.totalpoint;
            [self.navigationController pushViewController:goods animated:true];
        }else{
            NSArray *array;
            if ([model.targetUrl containsString:@"."]) {
                array = [model.targetUrl componentsSeparatedByString:@"."];
                EGiftDetailController *giftVc = [EGiftDetailController new];
                giftVc.goods_id = [array lastObject];
                giftVc.from_type = 0;
                giftVc.points = self.totalpoint;
                [self.navigationController pushViewController:giftVc animated:true];}}
    }else if ([model.targetUrl containsString:@"activity"]){
        if ([model.targetUrl isEqualToString:@"activity"]){
            EGActivityExchangeViewController *activity = [EGActivityExchangeViewController new];
            activity.points = self.totalpoint;
            [self.navigationController pushViewController:activity animated:true];
        }else{
            NSArray *array;
            if ([model.targetUrl containsString:@"."]) {
                array = [model.targetUrl componentsSeparatedByString:@"."];
                EGActivityDetailViewController *detailVC = [[EGActivityDetailViewController alloc] init];
                detailVC.activty_id = [array lastObject];
                detailVC.from_type = 0;
                detailVC.points = self.totalpoint;
                [self.navigationController pushViewController:detailVC animated:YES];}
            }
    }else{
        EGActivityNotifcationDetailViewController *detailVC = [EGActivityNotifcationDetailViewController new];
        [detailVC setDataModel:model];
        [self.navigationController pushViewController:detailVC animated:true];}
    [self batchSetAsRead:model.ID];
}

-(void)batchSetAsRead:(NSString *)megId
{
    UserInfomationModel *userModel = [EGLoginUserManager getUserInfomation];
    if (!userModel) {
        return;
    }
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",userModel.accessToken];
    NSDictionary *headerDict = @{@"Authorization":tokenString};
    NSDictionary *dict = @{
        @"messageIds": @[megId]
    };
    NSString *url = [EGServerAPI messageMarkRead_api:userModel.ID];
    [[WAFNWHTTPSTool sharedManager] postWithURL:url parameters:dict headers:headerDict success:^(NSDictionary * _Nonnull response) {
        
        [self getDataMethod];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

-(void)getDataQrcode{
    
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
        self.memberCode = qrCode;

    } failure:^(NSError * _Nonnull error) {

        
    }];
    
}
-(void)getTaskDetail:(NSString *)uuid
{
    uuid = @"679a0676-8e31-4a75-9f4e-237b31bd584c";
    UserInfomationModel *userModel = [EGLoginUserManager getUserInfomation];
    if (!userModel || !self.memberCode) {
        return;
    }
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",userModel.accessToken];
    NSDictionary *headerDict = @{@"Authorization":tokenString};
    NSDictionary *dict = @{};
    NSString *url = [EGServerAPI taskDetailInfo_api:uuid QRCode:self.memberCode];
    [[WAFNWHTTPSTool sharedManager] getWithURL:url parameters:dict headers:headerDict success:^(NSDictionary * _Nonnull response) {
        ELog(@"<----%@--->",response);
        [self handleTaskwithInfo:response];
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)handleTaskwithInfo:(NSDictionary *)taskInfo
{
    if (![taskInfo[@"triggerType"] isEqualToString:@"app"]) {
        return;
    }
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [outputFormatter setTimeZone:timeZone];
    [outputFormatter setDateFormat:@"yyyy年M月d日"];
    NSDate *startDate = [inputFormatter dateFromString:taskInfo[@"startDate"]];
    NSDate *endDate = [inputFormatter dateFromString:taskInfo[@"endDate"]];
    NSString *dateRange = [NSString stringWithFormat:@"%@ ~ %@",
                           [outputFormatter stringFromDate:startDate],
                           [outputFormatter stringFromDate:endDate]];
    
    NSDictionary *info = [self getEventModel:taskInfo];
    
    NSString *pointsStr = taskInfo[@"point"];
    NSInteger points = [pointsStr integerValue];
    
    NSMutableDictionary *config = [NSMutableDictionary dictionary];
    config[@"containerHeight"] =@(660);
    
    config[@"title"] = taskInfo[@"topic"];
    
    config[@"locationType"] =  info[@"locationType"];
    config[@"isBluetooth"] = info[@"isBlue"];
    config[@"status"] = info[@"status"];
    
    config[@"sectionHeaders"] = @[@"",@"活動期間：", @"活動期間：", @"活動期間："];
    config[@"cellContents"] = @[
        pointsStr,
        dateRange,
        taskInfo[@"content"],
        @[taskInfo[@"pointProcess"]]
    ];
    config[@"isAdd"] = @(NO);
    config[@"type"] = taskInfo[@"triggerTag"];
   
    config[@"callback"] = @"";
   
    config[@"buttonTitle"] = taskInfo[@"buttonTitle"]?taskInfo[@"buttonTitle"]: @"確定";
    
    
    if ([config[@"status"] isEqualToString:@"領取"] ) {
        [MBProgressHUD showDelayHidenMessage:[NSString stringWithFormat:@"正在領取 + %ld 天鷹點",points]];
        
    }else{ // if([config[@"status"] isEqualToString:@"即將開放"])
        [EGComingSoonPopupView showTableViewPopupWithConfig:config confirmBlock:^{
            
            if ([config[@"type"] isEqualToString:@"fb"]) {
                NSLog(@"FB");
                [self openURL:@"fb://profile/100083409097537" fallback:@"https://www.facebook.com/100083409097537"];
            }else if([config[@"type"] isEqualToString:@"instagram"]) {
                [self  openURL:@"instagram://user?username=tsg_hawks"
                      fallback:@"https://www.instagram.com/tsg_hawks/"];
            }else if([config[@"type"] isEqualToString:@"yt"]) {
                [self  openURL:@"youtube://www.youtube.com/channel/UCVBlrH9PZRWtgrfcrjmXZMA"
                      fallback:@"https://www.youtube.com/channel/UCVBlrH9PZRWtgrfcrjmXZMA"];
            }else if([config[@"type"] isEqualToString:@"survey"]) {
                [self  openURL:@"https://www.surveycake.com/s/LnnMR"
                      fallback:@"https://www.surveycake.com/s/LnnMR"];
            }else{
                
            }

        }];
    }
}
-(NSDictionary *)getEventModel:(NSDictionary *)model{

    BOOL isBlue = NO;
    if ([model[@"triggerTag"] isEqualToString:@"checkin"]) {
        isBlue = YES;
    }
    NSString *taskID;
    if ([model[@"triggerTag"] isEqualToString:@"survey"]) {
        taskID = model[@"id"];
    }
    NSString *stauts;
    if ([model[@"personalEventTaskStatus"] isEqualToString:@"unlock"]) {
        stauts = @"即將開放";
    }else if ([model[@"personalEventTaskStatus"] isEqualToString:@"unlockNot"]){
        stauts = @"尚未解鎖";
    }else if ([model[@"personalEventTaskStatus"] isEqualToString:@"pending"]){
        stauts = @"未完成";
    }else if ([model[@"personalEventTaskStatus"] isEqualToString:@"completed"]){
        stauts = @"已完成";
    }else if ([model[@"personalEventTaskStatus"] isEqualToString:@"reward"]){
//                    stauts = @"已領取";
        stauts = @"已完成";
    }else if ([model[@"personalEventTaskStatus"] isEqualToString:@"expired"]){
        stauts = @"已過期";
    }else{
        stauts = @"即將開放";
    }
    
    EGLocationRestrictionType locationType;
    if ([model[@"triggerTag"] isEqualToString:@"item"] || [model[@"triggerTag"] isEqualToString:@"mvp"] ||
        [model[@"triggerTag"] isEqualToString:@"takao"] || [model[@"triggerTag"] isEqualToString:@"ytMember"] || [model[@"triggerTag"] isEqualToString:@"threshold"] ) {
        //扫码给点
        locationType =  EGLocationRestrictionTypeGiveScan;
    }else if([model[@"triggerTag"] isEqualToString:@"instagram"] ||
             [model[@"triggerTag"] isEqualToString:@"fb"] ||
             [model[@"triggerTag"] isEqualToString:@"yt"] ||
             [model[@"triggerTag"] isEqualToString:@"survey"] ){
        // 即时给点
        locationType =  EGLocationRestrictionTypeGiveNow;
    }else if([model[@"triggerTag"] isEqualToString:@"checkin"] ){
        //信标给点
        locationType =  EGLocationRestrictionTypeGiveBecon;
    }else if([model[@"triggerTag"] isEqualToString:@"card"] || [model[@"triggerTag"] isEqualToString:@"attendance"] || [model[@"triggerTag"] isEqualToString:@"thanks"] ){
        //空投給點
        locationType =  EGLocationRestrictionTypeGiveAir;
    }else{
        //空投給點
        locationType =  EGLocationRestrictionTypeGiveAir;
    }
    return @{@"isBlue":@(isBlue),
             @"locationType":@(locationType),
             @"status":stauts};
}


- (void)openURL:(NSString *)appURL fallback:(NSString *)webURL {
    NSURL *appSchemeURL = [NSURL URLWithString:appURL];
    NSURL *webFallbackURL = [NSURL URLWithString:webURL];
    
    [[UIApplication sharedApplication] openURL:appSchemeURL
                                     options:@{}
                           completionHandler:^(BOOL success) {
        if (!success) {
            [[UIApplication sharedApplication] openURL:webFallbackURL
                                            options:@{}
                                  completionHandler:nil];
        }
    }];
}
@end





