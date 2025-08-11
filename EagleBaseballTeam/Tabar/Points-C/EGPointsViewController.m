//
//  EGPointsViewController.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/7.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGPointsViewController.h"
#import "EGPointsHeaderView.h"
#import "EGPointsListTBVCell.h"
#import "EGTBVSectionHeaderFooterView.h"
#import "EGPointsRecordViewController.h"

#import "EGGoodsExchangeController.h"
#import "EGPointsRuleViewController.h"
#import "EGTaskCollectionViewCell.h"
#import "EGComingSoonPopupView.h"
#import "EGTmpDataManager.h"
#import "EGPointsTaskListViewController.h"
#import "EGPointsModel.h"
//#import "EGCircleRefreshHeader.h"
#import "EGMemberCodeViewController.h"//条形码
#import "EGmedalViewController.h"//胸章
#import "EGActivityExchangeViewController.h"//活动详情
#import "EGExchangeRecordViewController.h"//兑换历程

#import <CommonCrypto/CommonDigest.h>

#import "EGTaskeventsModel.h"
#import "EGTaskManager.h"
#import "EGFunInteractionCell.h"
#import "EGSortView.h"
#import "EGPhotoGraphViewController.h"


@interface EGPointsViewController ()<PointsHeaderViewDelegate,UICollectionViewDelegate, UICollectionViewDataSource/*,EGTaskCollectionViewCellDelegate*/,EGPointsListTBVCellDelegate,UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,weak) EGPointsHeaderView *headerView;

@property (nonatomic, strong) NSMutableArray *limitedTasks;  // 限時任務
@property (nonatomic, strong) NSMutableArray *dataArray;// 每日
@property (nonatomic, strong) NSMutableArray *memberTasks;   // 會員專屬任務

@property (nonatomic, strong) NSMutableArray *pointList; //点数列表
@property (nonatomic, assign) NSInteger totalpoint; //点数总计

@property (nonatomic, assign) NSInteger AddPoints; //需添加的点数
@property (nonatomic, strong) NSString *memberCode;

@property (nonatomic, assign) NSInteger dailyTaskCount; //日常任务数量

@property (nonatomic, assign) NSInteger type; //0限时 1每日 2英国人

@property (nonatomic, strong) NSMutableArray *states; //查看全部 states
@property (nonatomic, strong) UIButton *backTopBtn;//回到顶部
@end

@implementation EGPointsViewController

- (NSMutableArray *)pointList{
    if (!_pointList) {
        _pointList = [NSMutableArray array];
    }
    return _pointList;
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)limitedTasks
{
    if (_limitedTasks == nil) {
        _limitedTasks = [NSMutableArray array];
    }
    return _limitedTasks;
}

- (NSMutableArray *)memberTasks{
    if (_memberTasks == nil) {
        _memberTasks = [NSMutableArray array];
    }
    return _memberTasks;
}
- (NSMutableArray *)states
{
    if (!_states) {
        _states = [NSMutableArray arrayWithObjects:@0,@0,@0, nil];
    }
    return _states;
}

- (NSString *)xy_noDataViewMessage {
    
    if (self.type == 0) {
        
    }else if (self.type == 1){
        
    }else{
        
    }
    return @"尚無任務";
}

- (UIImage *)xy_noDataViewImage {
    return [UIImage imageNamed:@"nodata"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // [self.navigationController setNavigationBarHidden:YES animated:YES];
    
   [self setNavigationItem];

    UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
    if (!model) {
        
        if (self.totalpoint != 0) {
            //登录过 self.totalpoint 会不为0，这再退出，会未登录，需要刷为0
            [self.tableView.mj_header beginRefreshing];
           // [self getdata];
        }else{
           
        }
        //未登录时不刷
        return;
    }
    else if (self.totalpoint == 0) {
        //第一次登录及self.totalpoint == 0 需要刷
        [self.tableView.mj_header beginRefreshing];
        [self getdata];
//        [self getTask:^(BOOL success) {
//            
//        }];
//        [self getEventTast];
        return;
    }
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
  //  [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.type = 0;
    self.dailyTaskCount= -1;
    self.totalpoint = 0;

    // 添加通知观察者
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleTaskStatusUpdate:)
                                                 name:@"TaskStatusUpdateNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
            selector:@selector(receiveLogoutNotification:)
            name:@"closebeaconNotification"
            object:nil];
   
   
//
    NSArray *array  = [EGTaskManager sharedManager].taskArray;
    if (array && array.count > 0) {
           [self separateThreeDataArray:array isConvertStatus:YES];
    }else{
//        [self setupData];
    }

    self.tableView.clipsToBounds = NO;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    EGCircleRefreshHeader *header = [EGCircleRefreshHeader headerWithRefreshingBlock:^{
        // 进行刷新操作
        [self getdata];
        [self getEventTast];
        
    }];
    header.activityIndicator.color = rgba(10, 63, 145, 1);

    // 设置下拉的触发距离
    self.tableView.mj_header = header;
    
    self.tableView.delegate =self;
    self.tableView.dataSource =self;
 
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([UIDevice de_navigationFullHeight]-1);//
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-[UIDevice de_tabBarFullHeight]);
    }];
    
    // 创建渐变色图层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    //       gradientLayer.frame = self.tableView.bounds;
    gradientLayer.frame = self.view.bounds;
    // 定义渐变色（示例：从蓝色到绿色）
    gradientLayer.colors = @[
        (__bridge id)rgba(0, 78, 162, 1).CGColor,
        (__bridge id)rgba(0, 78, 162, 1).CGColor,
        //           (id)rgba(0, 122, 96, 1).CGColor,
        (__bridge id)rgba(243, 243, 243, 1).CGColor
    ];
    gradientLayer.locations = @[@0.0, @0.3,@0.4];
    // 设置渐变方向（水平/垂直）
    gradientLayer.startPoint = CGPointMake(0.5, 0.0); // 垂直从上到下
    gradientLayer.endPoint = CGPointMake(0.5, 1.0);
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
    
    // 确保单元格透明（关键步骤！）
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self setupTasksUI];
    //[self.tableView.mj_header beginRefreshing];
    
}

////MARK: 下拉为绿色背景
//// 实现 UIScrollViewDelegate 方法
///// 或者通过代理方法控制
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView){
        if (scrollView.contentOffset.y < -ScaleW(150)) { // 最大下拉距离
            scrollView.contentOffset = CGPointMake(0, -ScaleW(150));
        }
    
        // 计算最大可滚动距离
        CGFloat maxScrollableDistance = MAX(0, scrollView.contentSize.height - scrollView.bounds.size.height);
        // 限制上拉最大距离
        if (scrollView.contentOffset.y > maxScrollableDistance + ScaleW(150)) {
            scrollView.contentOffset = CGPointMake(0, maxScrollableDistance + ScaleW(150));
        }
        
        if (scrollView.contentOffset.y < 0) {
            self.backTopBtn.hidden = true;
        }else{
            [self shareGoodsPublished];
            self.backTopBtn.hidden = false;
        }
    }
}
/**
 * 收到通知处理
 */
- (void)triggerFirstCellAction:(NSString *)taskCode {
    if (!taskCode) return;
    NSArray *codes = [taskCode componentsSeparatedByString:@"-"];
    if (codes.count == 2) {
        if ([codes[0] isEqualToString:@"1"]) {
            if ([codes[1] isEqualToString:@"1"]) {
                if (self.dataArray.count > 0) {
                    NSMutableDictionary *task = [self.dataArray[0] mutableCopy];
                    if ([task[@"status"] isEqualToString:@"即將開放"]){
                        // 触发 1-1 的点击事件
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                        if (cell) {
                            [self listTBCell:cell didClickStateButtonAtIndexPath:indexPath];
                        }else {
                            // 如果 cell 还未加载,等待下一个运行循环再试
                            dispatch_async(dispatch_get_main_queue(), ^{
                                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                                if (cell) {
                                    [self listTBCell:cell didClickStateButtonAtIndexPath:indexPath];
                                }
                            });
                        }
                    }
                }
            }else if([codes[1] isEqualToString:@"2"]){
                // 只有当 task_code 为 1-0 时才修改状态
                if (self.dataArray.count > 0) {
                    NSMutableDictionary *task = [self.dataArray[0] mutableCopy];
                    if ([task[@"status"] isEqualToString:@"即將開放"]) {
                        //只有即將開放 才修改当前状态
                        task[@"status"] = @"領取";
                        self.dataArray[0] = task;
                        [self.tableView reloadData];
                    }
                }
            }
        }
    }
}

//MARK: 接收通知处理方法
-(void)receiveLogoutNotification:(NSNotification *) notification{
    self.totalpoint = 0;
    [self getEventTast];
    [self.tableView reloadData];
}
// 添加通知处理方法
- (void)handleTaskStatusUpdate:(NSNotification *)notification {
    
    [self getdata];
    [self getEventTast];
}

//MARK: 点数 （获取总点数）
-(void)getdata{
    WS(weakSelf);
    [[EGetTokenViewModel sharedManager] fetchMemberInfo:^(BOOL isSuccess) {
        if (isSuccess) {
            NSInteger points = [EGLoginUserManager getMemberInfoPoints].Points;
            weakSelf.totalpoint = points;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_header endRefreshing];
            });
        }else{
            [weakSelf.tableView.mj_header endRefreshing];
        }
    }];
}
//将model中的personalEventTaskStatus，locationType，是否显示蓝牙 转为对应字典
-(NSDictionary *)getEventModel:(EGTaskeventsModel *)model{

    BOOL isBlue = NO;
    if ( [model.triggerTag isEqualToString:@"checkin"]) {
        isBlue = YES;
    }
    NSString *taskID;
    if (   [model.triggerTag isEqualToString:@"survey"]) {
        taskID = model.ID;
    }
    
    NSString *stauts;
    if ([model.personalEventTaskStatus isEqualToString:@"unlock"]) {
        stauts = @"即將開放";
    }else if ([model.personalEventTaskStatus isEqualToString:@"unlockNot"]){
        stauts = @"尚未解鎖";
    }else if ([model.personalEventTaskStatus isEqualToString:@"pending"]){
        stauts = @"未完成";
    }else if ([model.personalEventTaskStatus isEqualToString:@"completed"]){
        stauts = @"已完成";
    }else if ([model.personalEventTaskStatus isEqualToString:@"reward"]){
//                    stauts = @"已領取";
        stauts = @"已完成";
    }else if ([model.personalEventTaskStatus isEqualToString:@"expired"]){
        stauts = @"已過期";
    }else{
        stauts = @"即將開放";
    }
    
    EGLocationRestrictionType locationType;
    if ([model.triggerTag isEqualToString:@"item"] || [model.triggerTag isEqualToString:@"mvp"] ||
        [model.triggerTag isEqualToString:@"takao"] || [model.triggerTag isEqualToString:@"ytMember"] || [model.triggerTag isEqualToString:@"threshold"] ) {
        //扫码给点
        locationType =  EGLocationRestrictionTypeGiveScan;
    }else if([model.triggerTag isEqualToString:@"instagram"] ||
             [model.triggerTag isEqualToString:@"fb"] ||
             [model.triggerTag isEqualToString:@"yt"] ||
             [model.triggerTag isEqualToString:@"survey"] ){
        // 即时给点
        locationType =  EGLocationRestrictionTypeGiveNow;
    }else if([model.triggerTag isEqualToString:@"checkin"] ){
        //信标给点
        locationType =  EGLocationRestrictionTypeGiveBecon;
    }else if([model.triggerTag isEqualToString:@"card"] || [model.triggerTag isEqualToString:@"attendance"] || [model.triggerTag isEqualToString:@"thanks"] ){
        //空投給點
        locationType =  EGLocationRestrictionTypeGiveAir;
    }else{
        //空投給點
        locationType =  EGLocationRestrictionTypeGiveAir;
    }
    
    return @{@"isBlue":@(isBlue),
             @"locationType":@(locationType),
             @"stauts":stauts};
}

-(void)separateThreeDataArray:(NSArray *)array isConvertStatus:(BOOL)isConvert {
    // 日期格式转换
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    //            NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Taipei"];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [outputFormatter setTimeZone:timeZone];
    [outputFormatter setDateFormat:@"yyyy年M月d日"];
    if (array.count > 0 ) {
        [self.dataArray removeAllObjects];
        [self.memberTasks removeAllObjects];
        [self.limitedTasks removeAllObjects];
    }else{
        return;
    }
    
    for (EGTaskeventsModel *model in array) {
        
        NSDate *startDate = [inputFormatter dateFromString:model.startDate];
        NSDate *endDate = [inputFormatter dateFromString:model.endDate];
        
        NSString *dateRange = [NSString stringWithFormat:@"%@ ~ %@",
                               [outputFormatter stringFromDate:startDate],
                               [outputFormatter stringFromDate:endDate]];
       
        NSDictionary *info = [self getEventModel:model];
   
        NSString *stauts;
        if (isConvert) {
             stauts = info[@"stauts"]?:@"";
        }else{
            if ([model.personalEventTaskStatus isEqualToString:@""]) {
                stauts = @"即將開放";
            }else{
                stauts =  model.personalEventTaskStatus;
            }
        }
     
//                ELog(@"model.topic:%@  stauts: %@",model.topic,stauts);
        if([model.eventType isEqualToString:@"limited"]) {
            //限時
            [self.limitedTasks addObject:@{
                @"startDate":model.startDate,
                @"title": model.topic,
                @"subtitle":model.content,
                @"dateRange": dateRange,
                @"points": model.point,
                @"status": stauts,
                @"UUID":model.ID,
                @"taskDetail":@{
                    @"title": model.topic,
                    @"buttonTitle":@"點選參加",
                    @"cellContents":@[
                        dateRange,
                        model.content,
                        model.point,
                        @[model.pointProcess],
                    ],
                    @"footerContent":@"TAKAO：進場就有點數拿！爽看比賽還能賺獎勵，這麼划算的事還不衝？",
                    @"type":model.triggerTag,
                    @"locationType":info[@"locationType"],
                    @"isBluetooth":info[@"isBlue"],
                    @"callback":@"",
                    @"isAdd":@(NO)
                }}];
        }else if([model.eventType isEqualToString:@"exclusive"]) {
            // exclusive: 專屬,
            [self.memberTasks addObject:@{
                @"startDate":model.startDate,
                @"title": model.topic,
                @"subtitle":model.content,
                @"dateRange": dateRange,
                @"points": model.point,
                @"status": stauts,
                @"UUID":model.ID,
                @"taskDetail":@{
                    @"title": model.topic,
                    @"buttonTitle":@"點選參加",
                    @"cellContents":@[
                        dateRange,
                        model.content,
                        model.point,
                        @[model.pointProcess],
                    ],
                    @"footerContent":@"TAKAO：進場就有點數拿！爽看比賽還能賺獎勵，這麼划算的事還不衝？",
                    @"type":model.triggerTag,
                    @"locationType":info[@"locationType"],
                    @"isBluetooth":info[@"isBlue"],
                    @"callback":@"",
                    @"isAdd":@(NO)
                }}];
        }else if ([model.eventType isEqualToString:@"daily"]) {
            [self.dataArray addObject:@{
                @"startDate":model.startDate,
                @"title": model.topic,
                @"subtitle":model.content,
                @"dateRange": dateRange,
                @"points": model.point,
                @"status": stauts,
                @"UUID":model.ID,
                @"taskDetail":@{
                    @"title": model.topic,
                    @"buttonTitle":@"點選參加",
                    @"cellContents":@[
                        dateRange,
                        model.content,
                        model.point,
                        @[model.pointProcess],
                    ],
                    @"footerContent":@"TAKAO：進場就有點數拿！爽看比賽還能賺獎勵，這麼划算的事還不衝？",
                    @"type":model.triggerTag,
                    @"locationType":info[@"locationType"],
                    @"isBluetooth":info[@"isBlue"],
                    @"callback":@"",
                    @"isAdd":@(NO)
                }}];
        }
    }
    
}

//MARK: 获取全部任务
-(void)getEventTast{
 
    NSString *url2 = [EGServerAPI getEventtasks];
    [[WAFNWHTTPSTool sharedManager] getWithURL:url2 parameters:@{} headers:@{} success:^(NSDictionary * _Nonnull response) {
        NSArray *eventTasks  = [EGTaskeventsModel mj_objectArrayWithKeyValuesArray:response];
      //  NSArray *eventTasks  = [EGTaskManager sharedManager].taskArray;
        [EGTaskManager sharedManager].taskArray = eventTasks;
        
        // 先获取带有状态信息的任务数据
        [self getTask:^(BOOL success) {
            if (success) {
                // 遍历 eventTasks，查找匹配的任务状态
                for (EGTaskeventsModel *eventTask in eventTasks) {
                  
                    NSMutableArray *allTasks = [NSMutableArray array];
                    [allTasks addObjectsFromArray:self.memberTasks];
                    [allTasks addObjectsFromArray:self.limitedTasks];
                    [allTasks addObjectsFromArray:self.dataArray];
                    // 在 memberTasks、limitedTasks 和 dataArray 中查找匹配的任务
                    for (NSDictionary *task in allTasks) {
                        if ([task[@"UUID"] isEqualToString:eventTask.ID]) {
                            
                            eventTask.personalEventTaskStatus = task[@"status"];
                          //  break;
                        }
                    }
                }
            }
            [self separateThreeDataArray:eventTasks isConvertStatus:NO];
//            if (self.dailyTaskCount != -1 && self.dataArray.count != self.dailyTaskCount ) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskCountChangeNotification"
//                                                                    object:nil
//                                                                  userInfo:@{
//                }];
//            }
//            self.dailyTaskCount = self.dataArray.count;
            
    //        // 刷新表格
            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.limitedTasksCollectionView reloadData];
//                [self.memberTasksCollectionView reloadData];
                [self.tableView reloadData];
             
            });
            [self.tableView.mj_header endRefreshing];

        }];
    } failure:^(NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        dispatch_async(dispatch_get_main_queue(), ^{
       
            if ([error.localizedDescription containsString:@"offline"] || error.code == -1009) {
                [MBProgressHUD showDelayHidenMessage:@"請檢查您的網路連線，確保裝置已連接至網路後再重試。"];
            }else{
                [MBProgressHUD showDelayHidenMessage:error.localizedDescription];
            }
        });
    }];
}

//获取member任务 添加完成回调，完成后再做后面的事情
-(void)getTask:(void(^)(BOOL success))completion {
    
    UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
    if (!model) {
        self.totalpoint = 0;
//        [self getEventTast];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
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
        self.memberCode = qrCode;
        
        NSString *url2 = [EGServerAPI getEventmembertasks:qrCode];
        //  NSString *url2 = [EGServerAPI getEventtasks];
        [[WAFNWHTTPSTool sharedManager] getWithURL:url2 parameters:@{} headers:dict_header success:^(NSDictionary * _Nonnull response) {
//            ELog(@"%@",response);
            NSArray *array  = [EGTaskeventsModel mj_objectArrayWithKeyValuesArray:response];
            // 日期格式转换
            [self separateThreeDataArray:array isConvertStatus:YES];
            // 刷新表格
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.limitedTasksCollectionView reloadData];
                [self.memberTasksCollectionView reloadData];
                [self.tableView reloadData];
//                [self.tableView.mj_header endRefreshing];
            });
            if (completion) {
                completion(YES);
            }
            
        } failure:^(NSError * _Nonnull error) {
            [self.tableView.mj_header endRefreshing];
            dispatch_async(dispatch_get_main_queue(), ^{
           
                if ([error.localizedDescription containsString:@"offline"] || error.code == -1009) {
                    [MBProgressHUD showDelayHidenMessage:@"請檢查您的網路連線，確保裝置已連接至網路後再重試。"];
                }else{
                    [MBProgressHUD showDelayHidenMessage:error.localizedDescription];
                }
            });
            if (completion) {
                completion(NO);
            }
        }];
        
    } failure:^(NSError * _Nonnull error) {

        if ([error.localizedDescription containsString:@"offline"] || error.code == -1009) {
            [MBProgressHUD showDelayHidenMessage:@"請檢查您的網路連線，確保裝置已連接至網路後再重試。"];
        }else{
            [MBProgressHUD showDelayHidenMessage:error.localizedDescription];
        }
        [self.tableView.mj_header endRefreshing];
        if (completion) {
            completion(NO);
        }
    }];
}
// 获取单页数据的方法
-(void)getPointsHistoryWithPage:(NSInteger)page completion:(void(^)(NSDictionary *data))completion {
    UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
    NSString *url = [EGServerAPI pointHistoryBy:model.ID Page:page andSize:500];
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
    NSDictionary *dict_header = @{@"Authorization":tokenString};
    
    [[WAFNWHTTPSTool sharedManager] getWithURL:url parameters:@{} headers:dict_header success:^(NSDictionary * _Nonnull response) {
        NSDictionary *data = [response objectForKey:@"data"];
        if (completion) {
            completion(data);
        }
    } failure:^(NSError * _Nonnull error) {
        if (completion) {
            completion(nil);
        }
        if ([error.localizedDescription containsString:@"offline"] || error.code == -1009) {
            [MBProgressHUD showDelayHidenMessage:@"請檢查您的網路連線，確保裝置已連接至網路後再重試。"];
        }else{
            [MBProgressHUD showDelayHidenMessage:error.localizedDescription];
        }
    }];
}

- (NSString *)getCurrentTimeUTCString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
   // [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    return [formatter stringFromDate:[NSDate date]];
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
        
        self.memberCode = qrCode;
        //这里调用 check IN
        NSString *url2 = [EGServerAPI getEventcheckins];
        NSDictionary *dict = @{@"encryptedIdentity":qrCode,@"taskId":para[@"UUID"]};
        ELog(@"url2:%@",url2);
        [[WAFNWHTTPSTool sharedManager] postWithURL:url2 parameters:dict headers:dict_header success:^(NSDictionary * _Nonnull response) {
            
//            [self animatePointsIncrease:self.AddPoints];
            
            if (completion) {
                completion(YES);
            }
            //后台调用网络求情刷新点数
            [self getdata];
            //后台调用网络求情刷新任务状态
            [self getTask:^(BOOL success) {
                
            }];
            [self.tableView reloadData];
            
        } failure:^(NSError * _Nonnull error) {
            if ([error.localizedDescription containsString:@"offline"] || error.code == -1009) {
                [MBProgressHUD showDelayHidenMessage:@"請檢查您的網路連線，確保裝置已連接至網路後再重試。"];
            }else{
                [MBProgressHUD showDelayHidenMessage:error.localizedDescription];
            }
        }];

    } failure:^(NSError * _Nonnull error) {

        if ([error.localizedDescription containsString:@"offline"] || error.code == -1009) {
            [MBProgressHUD showDelayHidenMessage:@"請檢查您的網路連線，確保裝置已連接至網路後再重試。"];
        }else{
            [MBProgressHUD showDelayHidenMessage:error.localizedDescription];
        }
        if (completion) {
            completion(NO);
        }
    }];
}
// 添加工具方法
- (NSString *)sha256HashForString:(NSString *)input {
    const char *str = [input UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, (CC_LONG)strlen(str), result);
    
    NSMutableString *hash = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}
-(void)setNavigationItem
{
    self.navigationItem.title = @"";
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [leftBtn setTitle:[EGLoginUserManager isLogIn] ? NSLocalizedString(@"點數", nil) : NSLocalizedString(@"登入", nil) forState:(UIControlStateNormal)];
    [leftBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [rightBtn setImage:[UIImage imageNamed:@"medal"] forState:UIControlStateNormal];
//    [rightBtn setTitle:NSLocalizedString(@"點數辦法", nil) forState:(UIControlStateNormal)];
    [rightBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightNavigationButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

-(void)leftBtnClick:(UIButton *)sender
{
    if (![EGLoginUserManager isLogIn]) {
        WS(weakSelf);
        EGLogInViewController *login = [EGLogInViewController new];
        EGNavigationController *nav = [[EGNavigationController alloc] initWithRootViewController:login];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        nav.navigationBar.backgroundColor = rgba(0, 71, 56, 1);
        login.logInBlock = ^{
            [weakSelf setNavigationItem];
        };
        [self presentViewController:nav animated:true completion:^{
        }];
        return;
    }
}
// 实现跳转方法
-(void)rightNavigationButton
{
//  點數辦法
//    EGPointsRuleViewController *ruleVC = [[EGPointsRuleViewController alloc] init];
//    [self.navigationController pushViewController:ruleVC animated:YES];
//    二维码
//    EGMemberCodeViewController *memberVC = [[EGMemberCodeViewController alloc] init];
//    memberVC.memberCode =@""; //self.infoModel.Code?self.infoModel.Code:@"";
//    memberVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    [self presentViewController:memberVC animated:YES completion:nil];
//    胸章
    
    if (![EGLoginUserManager isLogIn]) {
           [self goLogin];
           return;
       }
    
    EGmedalViewController*vc = [EGmedalViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleTaskwithInfo:(NSMutableDictionary *)taskInfo completion:(void(^)(BOOL isReceivable))completion
{

    NSMutableDictionary *config = [NSMutableDictionary dictionary];
    config[@"containerHeight"] =@(660);
    config[@"title"] = taskInfo[@"title"];
    config[@"buttonTitle"] = taskInfo[@"buttonTitle"]?taskInfo[@"buttonTitle"]: @"確定";
    config[@"sectionHeaders"] = @[@"",@"活動期間：", @"活動內容：", @"點數發放過程："];
    config[@"cellContents"] = @[
        taskInfo[@"cellContents"][2],//点数
        taskInfo[@"cellContents"][0],
        taskInfo[@"cellContents"][1],
        taskInfo[@"cellContents"][3],
    ];
//    config[@"footerContent"] = taskInfo[@"footerContent"];
    config[@"isAdd"] = taskInfo[@"isAdd"];
    config[@"type"] = taskInfo[@"type"];
    config[@"status"] = taskInfo[@"status"];
    config[@"locationType"] =  taskInfo[@"locationType"];
    //如果是领取状态 则弹出+ 几点。
    NSString *pointsStr = taskInfo[@"cellContents"][2];
    NSInteger points = [pointsStr integerValue];
    self.AddPoints = points;
    
    if ([config[@"status"] isEqualToString:@"領取"] ) {
        [MBProgressHUD showDelayHidenMessage:[NSString stringWithFormat:@"正在領取 + %ld 天鷹點",self.AddPoints]];
        if (completion) {
            completion(NO);
        }
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
            }
            //增加点数，（点数增加成功 则置为已完成，暂时项）。
            //刷新任务列表 或 刷新点数查看该点数 是否已被添加来确认 该任务是否已完成。
            // 执行完成回调
            if (completion) {
                completion(YES);
            }
        }];
    }
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

#pragma mark --- PointsHeaderViewDelegate
-(void)pointsHeaderViewButtonTag:(NSInteger)tag
{
    if (![EGLoginUserManager isLogIn]) {
        [self goLogin];
        return;
    }
    if (tag == 27) {//点数记录
        EGPointsRecordViewController *record = [EGPointsRecordViewController new];
        record.pointList = [NSMutableArray arrayWithArray:self.pointList]; // 复制 pointList 给 record
        record.totalpoint = self.totalpoint;
        [self.navigationController pushViewController:record animated:true];
    }else if(tag==28)//贈品兌換
    {
        //商品兑换界面
        EGGoodsExchangeController *goods = [EGGoodsExchangeController new];
        //goods.is_fav = NO;
        goods.points = self.totalpoint;
        [self.navigationController pushViewController:goods animated:true];
    }
    else if(tag==29)//活动兑换
    {
        EGActivityExchangeViewController *activity = [EGActivityExchangeViewController new];
        activity.points = self.totalpoint;
        [self.navigationController pushViewController:activity animated:true];
    }
    else//兌換歷程
    {
        EGExchangeRecordViewController *record = [EGExchangeRecordViewController new];
        [self.navigationController pushViewController:record animated:true];
    }
}
-(void)goLogin
{
    EGNavigationController *nav = [[EGNavigationController alloc] initWithRootViewController:[EGLogInViewController new]];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    nav.navigationBar.backgroundColor = rgba(0, 71, 56, 1);
    [self presentViewController:nav animated:true completion:^{
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)lookAllData
{
    if (self.type == 0) {
        [self.states replaceObjectAtIndex:0 withObject:@1];
    }else if (self.type == 1){
        [self.states replaceObjectAtIndex:1 withObject:@1];
    }else{
        [self.states replaceObjectAtIndex:2 withObject:@1];
    }
    [self.tableView reloadData];
}

#pragma mark   ------回到顶部
- (void)shareGoodsPublished
{
    WS(weakSelf);
    if (!self.backTopBtn) {
        self.backTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backTopBtn.layer.borderColor = rgba(212, 212, 212, 1).CGColor;
        self.backTopBtn.layer.borderWidth = 1;
        self.backTopBtn.layer.cornerRadius = ScaleW(25);
        self.backTopBtn.layer.masksToBounds = true;
        self.backTopBtn.backgroundColor = UIColor.whiteColor;
        [self.backTopBtn setTitle:@"一" forState:UIControlStateNormal];
        [self.backTopBtn setTitleColor:rgba(0, 122, 96, 1) forState:UIControlStateNormal];
        [self.backTopBtn setImage:[UIImage imageNamed:@"paomadengback"] forState:UIControlStateNormal];
        [self.view addSubview:self.backTopBtn];
        [self.backTopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(ScaleW(50));
            make.width.mas_equalTo(ScaleW(50));
            make.height.mas_equalTo(ScaleW(50));
            make.right.mas_equalTo(-ScaleW(15));
        }];
        [self.backTopBtn layoutButtonWithEdgeInsetsStyle:ZYButtonEdgeInsetsStyleBottom imageTitleSpace:0];
        [self.backTopBtn addClickBlock:^(UIButton *button) {
            NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [weakSelf.tableView scrollToRowAtIndexPath:topIndexPath
                                     atScrollPosition:UITableViewScrollPositionTop
                                             animated:YES];
        }];
    }
}

#pragma mark --- 排序
-(void)popSortView
{
    EGSortView *picker = [[EGSortView alloc] init];
    picker.gBlock = ^(NSInteger index){
        
        switch (index) {
            case 0:
                [self dataSortForDate:NO];
                break;
                
            case 1:
                [self dataSortForDate:YES];
                break;
                
            case 2:
                [self dataSortForPoint:NO];
                break;
                
            case 3:
                [self dataSortForPoint:YES];
                break;
        }
        [self.tableView reloadData];
    };
    [picker popPickerView];
}
-(void)dataSortForDate:(BOOL )ascending
{
    
    NSArray *array;
    if (self.type == 0) {
        array = self.limitedTasks;
    }else if (self.type == 1){
        array = self.dataArray;
    }else{
        array = self.memberTasks;
    }
    if (!array) {
        return;
    }
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:ascending];
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    if (self.type == 0) {
        [self.limitedTasks removeAllObjects];
        [self.limitedTasks addObjectsFromArray:sortedArray];
        
    }else if (self.type == 1){
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:sortedArray];
        
    }else{
        [self.memberTasks removeAllObjects];
        [self.memberTasks addObjectsFromArray:sortedArray];
    }
    
}
-(void)dataSortForPoint:(BOOL )ascending
{
    NSArray *array;
    if (self.type == 0) {
        array = self.limitedTasks;
    }else if (self.type == 1){
        array = self.dataArray;
    }else{
        array = self.memberTasks;
    }
    if (!array) {
        return;
    }
    NSArray *sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *dict1, NSDictionary *dict2) {
        NSNumber *point1 = [NSNumber numberWithInt:[dict1[@"points"] intValue]];
        NSNumber *point2 = [NSNumber numberWithInt:[dict2[@"points"] intValue]];
        if (!ascending) {
            return [point2 compare:point1];
        }else{
            return [point1 compare:point2];
        }
    }];
    
    if (self.type == 0) {
        [self.limitedTasks removeAllObjects];
        [self.limitedTasks addObjectsFromArray:sortedArray];
        
    }else if (self.type == 1){
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:sortedArray];
        
    }else{
        [self.memberTasks removeAllObjects];
        [self.memberTasks addObjectsFromArray:sortedArray];
    }
    
}

//MARK: tableViewDeleagte

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WS(weakSelf);
    if (section == 1) {
        EGTBVSectionHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"EGTBVSectionHeaderFooterView"];
        if (!view) {
            view = [[EGTBVSectionHeaderFooterView alloc] initWithReuseIdentifier:@"EGTBVSectionHeaderFooterView"] ;
        }
        view.moreBtnClickBlock = ^(NSInteger section) {
            if (section == 3) {
                [weakSelf popSortView];
            }else{
                weakSelf.type = section;
                [weakSelf.tableView reloadData];
            }
        };
        return view;
    }else{
        return [UIView new];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 1 ? ScaleW(120) : 0.001;//50
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, ScaleW(50))];
        headerView.backgroundColor = UIColor.clearColor;
        UIButton *lookAllBtn = [[UIButton alloc] init];
        [lookAllBtn setTitle:@"查看全部" forState:UIControlStateNormal];
        [lookAllBtn setTitleColor:rgba(10, 63, 145, 1) forState:UIControlStateNormal];
        [lookAllBtn addTarget:self action:@selector(lookAllData) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:lookAllBtn];
        [lookAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(ScaleW(150));
            make.height.mas_equalTo(ScaleW(30));
            make.centerY.mas_equalTo(0);
        }];
        NSInteger state = [self.states[self.type] intValue];
        if (self.type == 0) {
            if (state == 1 || self.limitedTasks.count == 0) {
                return [UIView new];
            }
        }else if (self.type == 1  || self.dataArray.count == 0){
            if (state == 1) {
                return [UIView new];
            }
        }else{
            if (state == 1  || self.memberTasks.count == 0) {
                return [UIView new];
            }
        }
        return headerView;
    }else{
        return [UIView new];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 /*|| section == 1*/) {
        return 0;
    }else{
        NSInteger state = [self.states[self.type] intValue];
        if (self.type == 0) {
            if (state == 1) {
                return 0;
            }
        }else if (self.type == 1){
            if (state == 1) {
                return 0;
            }
        }else{
            if (state == 1) {
                return 0;
            }
        }
        return ScaleW(50);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;//4
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 /*|| section == 1*/) {
        return 1;
    }else{
        NSInteger state = [self.states[self.type] intValue];
        if (self.type == 0) {
            if (state == 1) {
                return self.limitedTasks.count;
            }else{
                return self.limitedTasks.count>4?4:self.limitedTasks.count;
            }
        }else if (self.type == 1){
            if (state == 1) {
                return self.dataArray.count;
            }else{
                return self.dataArray.count>4?4:self.dataArray.count;
            }
        }else{
            if (state == 1) {
                return self.memberTasks.count;
            }else{
                return self.memberTasks.count>4?4:self.memberTasks.count;
            }
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *headerCellID = @"HeaderCell";
//    static NSString *limitedTasksCellID = @"LimitedTasksCell";
//    static NSString *memberTasksCellID = @"MemberTasksCell";
    
    if (indexPath.section == 0) {
        UITableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:headerCellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headerCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            EGPointsHeaderView *header = [[EGPointsHeaderView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, ScaleW(157))];
            header.delegate = self;
            self.headerView = header;
            [self.headerView.pointsBtn setTitle:@"" forState:UIControlStateNormal];
            [self.headerView.pointsBtn layoutButtonWithEdgeInsetsStyle:ZYButtonEdgeInsetsStyleRight imageTitleSpace:1];
            [cell.contentView addSubview:self.headerView];
            [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(cell.contentView);
                make.height.mas_equalTo(ScaleW(220));
            }];
        }
        NSString *total = [NSString stringWithFormat:@"%ld",self.totalpoint];
        [self.headerView.pointsBtn setTitle:total forState:UIControlStateNormal];
        [self.headerView.pointsBtn layoutButtonWithEdgeInsetsStyle:ZYButtonEdgeInsetsStyleRight imageTitleSpace:1];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
//    }else if (indexPath.section == 1){
//        
//        EGFunInteractionCell *cell = [EGFunInteractionCell cellWithUITableView:tableView];
//        cell.clickItemBlock = ^(NSString * _Nonnull idString) {
//            
//            UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
//            if (!model) {
//                return;
//            }
//            NSMutableDictionary *config = [NSMutableDictionary dictionary];
//            config[@"containerHeight"] =@(660);
//            config[@"title"] = @"捕捉 TAKAO";
//            config[@"buttonTitle"] = @"前往";
//            config[@"sectionHeaders"] = @[@"",@"活動期間：", @"活動內容：", @"點數發放過程："];
//            config[@"cellContents"] = @[
//                @"5 點",
//                @"2025年X月X日(當日賽事)",
//                @"當日賽事在現場拍攝捕捉到TAKAO身影，並上傳照片或影片，即可獲得活動點數獎勵! ",
//                @[@"參加資格：活動期間內，首次登入雄鷹 APP 的球迷即可獲得點數。",
//                  @"活動達成條件：成功登入並完成註冊，即可獲得點數獎勵。",
//                  @"點數發送：比賽結束後 24 小時內，自動發放至會員帳戶，可於 App 查詢點數並兌換獎品。"],
//            ];
//        //    config[@"footerContent"] = taskInfo[@"footerContent"];
//            config[@"isAdd"] = @"0";
//            config[@"type"] = @"fb";
//            config[@"status"] = @"status";
//            config[@"locationType"] =  @"locationType";
//            [EGComingSoonPopupView showTableViewPopupWithConfig:config confirmBlock:^{
//                EGPhotoGraphViewController *camer = [EGPhotoGraphViewController new];
//                [self.navigationController pushViewController:camer animated:true];
//            }];
//        };
//        return cell;
//        
    } else{
        EGPointsListTBVCell *cell = [EGPointsListTBVCell cellWithUITableView:tableView];
        cell.delegate = self;
        cell.indexPath = indexPath;
        NSDictionary *dict;
        if (self.type == 0) {
            dict = self.limitedTasks[indexPath.row];
        }else if (self.type == 1){
            dict = self.dataArray[indexPath.row];
        }else{
            dict = self.memberTasks[indexPath.row];
        }
        [cell setModeInfo:dict];//self.dataArray[indexPath.row]
        cell.contentView.backgroundColor = rgba(243, 243, 243, 1);
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return ScaleW(157);
        case 1:
        case 2:
            return UITableViewAutomaticDimension;
        case 3:
            return UITableViewAutomaticDimension;
        default:
            return UITableViewAutomaticDimension;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WS(weakSelf);
    UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
    if (!model) {
        return;
    }
    if (indexPath.section != 2) {
        return;
    }
    if (self.type == 0) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary: self.limitedTasks[indexPath.row][@"taskDetail"]];
        dict[@"status"] =self.limitedTasks[indexPath.row][@"status"];
        dict[@"title"] =self.limitedTasks[indexPath.row][@"title"];
        dict[@"UUID"] =self.limitedTasks[indexPath.row][@"UUID"];
        
        [self handleTaskwithInfo:dict completion:^(BOOL isReceivable) {
            // 更新任务状态
            NSMutableDictionary *task = [self.limitedTasks[indexPath.row] mutableCopy];
            if (![dict[@"status"] isEqualToString:@"未完成"]) {
                return;
            }
            [weakSelf pointGrant:@{@"Points":@(self.AddPoints),
                                   @"UUID":dict[@"UUID"]}
                      completion:^(BOOL success) {
                if (success) {
                    NSLog(@"任务完成");
                } else {
                    // 处理失败情况
                    NSLog(@"添加点数失败");
                }
            }];
        }];
        
    } else if (self.type == 1) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary: self.dataArray[indexPath.row][@"taskDetail"]];
        dict[@"status"] =self.dataArray[indexPath.row][@"status"];
        dict[@"title"] =self.dataArray[indexPath.row][@"title"];
        dict[@"UUID"] =self.dataArray[indexPath.row][@"UUID"];
        [self handleTaskwithInfo:dict completion:^(BOOL isReceivable){
            // 在这里处理任务完成后的操作
            // 更新任务状态
            NSMutableDictionary *task = [self.dataArray[indexPath.item] mutableCopy];
            if (![dict[@"status"] isEqualToString:@"未完成"]) {
                return;
            }
            [weakSelf pointGrant:@{@"Points":@(self.AddPoints),
                                   @"UUID":dict[@"UUID"]}
                                   completion:^(BOOL success) {
                if (success) {
                } else {
                    // 处理失败情况
                    NSLog(@"添加点数失败");
                }
            }];
            NSLog(@"任务完成");
        }];
        
    }else{
        
        // 处理会员任务
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary: self.memberTasks[indexPath.row][@"taskDetail"]];
        dict[@"status"] =self.memberTasks[indexPath.row][@"status"];
        dict[@"title"] =self.memberTasks[indexPath.row][@"title"];
        dict[@"UUID"] =self.memberTasks[indexPath.row][@"UUID"];
        [self handleTaskwithInfo:dict completion:^(BOOL isReceivable) {
            // isReceivable yes 代表点击后 状态 变为领取，NO 代表领取后 添加点数
            // 更新任务状态
            NSMutableDictionary *task = [self.memberTasks[indexPath.row] mutableCopy];
            if (![dict[@"status"] isEqualToString:@"未完成"]) {
                return;
            }
            [weakSelf pointGrant:@{@"Points":@(self.AddPoints),
                                   @"UUID":dict[@"UUID"]}
                      completion:^(BOOL success) {
                if (success) {
                    // 处理成功情况
                    NSLog(@"任务完成");
                } else {
                    NSLog(@"添加点数失败");
                }
            }];
        }];
    }
}



#pragma mark - EGPointsListTBVCellDelegate
- (void)listTBCell:(UITableViewCell *)cell didClickStateButtonAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - EGTaskCollectionViewCellDelegate
//- (void)taskCell:(UICollectionViewCell *)cell didClickStateButtonAtIndexPath:(NSIndexPath *)indexPath
//{
//}


- (void)setupData
{
//     限時任務数据
    self.limitedTasks = [NSMutableArray arrayWithArray:@[
        @{
            @"title": @"感謝有你",
            @"dateRange": @"2025/01/01 ~ 2025/04/30",
            @"points": @"5",
            @"status": @"即將開放",
            @"taskDetail":@{
                @"title": @"開幕戰感謝有你",
                @"buttonTitle":@"點選參加",
                @"cellContents":@[
                    @"2025/01/01 ~ 2025/04/30",
                    @"第一次登入天鷹 APP 的球迷可立即獲得超值點數！不僅是賽事速報，還有專屬活動等你來參與！",
                    @"5",
                    @[@"參加資格：活動期間內，首次登入天鷹 APP 的球迷即可獲得點數。",
                      @"活動達成條件：成功登入並完成註冊，即可獲得點數獎勵。",
                      @"點數發送：比賽結束後 24 小時內，自動發放至會員帳戶，可於 App 查詢點數並兌換獎品。"],
                ],
                @"footerContent":@"TAKAO：進場就有點數拿！爽看比賽還能賺獎勵，這麼划算的事還不衝？",
                @"type":@"",
                @"isBluetooth":@NO,
                @"locationType":@1,
                @"callback":@""
            }
        },
        @{
            @"title": @"按讚官方 Facebook",
            @"dateRange": @"2025/01/01 ~ 2025/04/30",
            @"points": @"1",
            @"status": @"即將開放",
            @"taskDetail":@{
                @"title": @"按讚官方 Facebook",
                @"buttonTitle":@"前往連結",
                @"cellContents":@[
                    @"2025/01/01 ~ 2025/04/30",
                    @"只要按讚並追蹤台鋼天鷹官方 Facebook，就能輕鬆拿點數！",
                    @"1",
                    @[@"參加資格：活動期間內，按讚並追蹤官方 FB 的球迷即可獲得點數。",
                      @"活動達成條件：成功按讚並追蹤官方 FB，即觸發點數獎勵。",
                      @"點數發送：比賽結束後 24 小時內，自動發放至會員帳戶，可於 App 查詢點數並兌換獎品。"],
                ],
                @"footerContent":@"TAKAO：按個讚就能拿點數，這麼簡單的事，還不快來！趕緊點個讚，一起支持天鷹！",
                @"type":@"FB",
                @"status": @"即將開放",
                @"isBluetooth":@NO,
                @"locationType":@0,
                @"callback":@""
            }
        },
        @{
            @"title": @"追蹤官方 Instagram",
            @"dateRange": @"2025/01/01 ~ 2025/04/30",
            @"points": @"1",
            @"status": @"即將開放",
            @"taskDetail":@{
                @"title": @"追蹤官方 Instagram",
                @"buttonTitle":@"前往連結",
                @"cellContents":@[
                    @"2025/01/01 ~ 2025/04/30",
                    @"追蹤台鋼天鷹官方 Instagram，即可獲得點數獎勵！隨時掌握最新賽事資訊、精彩花絮。",
                    @"1",
                    @[@"參加資格：活動期間內，按讚並追蹤官方 IG 的球迷即可獲得點數。",
                      @"活動達成條件：成功按讚並追蹤官方 IG，即觸發點數獎勵。",
                      @"點數發送：比賽結束後 24 小時內，自動發放至會員帳戶，可於 App 查詢點數並兌換獎品。"],
                ],
                @"footerContent":@"TAKAO：追蹤 IG，點數 GET！不只拿獎勵，還能看到天鷹最猛瞬間！還不快來一起追蹤，錯過就虧大啦！📲",
                @"type":@"IG",
                @"status": @"即將開放",
                @"isBluetooth":@NO,
                @"locationType":@0,
                @"callback":@""
            }
        },
        @{
            @"title": @"訂閱官方 Youtube",
            @"dateRange": @"2025/01/01 ~ 2025/04/30",
            @"points": @"1",
            @"status": @"即將開放",
            @"taskDetail":@{
                @"title": @"訂閱官方 Youtube",
                @"buttonTitle":@"前往連結",
                @"cellContents":@[
                    @"2025/01/01 ~ 2025/04/30",
                    @"只要按讚並追蹤台鋼天鷹官方 Facebook，就能輕鬆拿點數！",
                    @"1",
                    @[@"參加資格：活動期間內，按讚並訂閱官方 Youtube 的球迷即可獲得點數。",
                      @"活動達成條件：成功按讚並追蹤官方 Youtube，即觸發點數獎勵。",
                      @"點數發送：比賽結束後 24 小時內，自動發放至會員帳戶，可於 App 查詢點數並兌換獎品。"],
                ],
                @"footerContent":@"TAKAO：按個讚就能拿點數，這麼簡單的事，還不快來！趕緊點個讚，一起支持天鷹！",
                @"type":@"Youtube",
                @"status": @"即將開放",
                @"isBluetooth":@NO,
                @"locationType":@0,
                @"callback":@""
            }
        },
        @{
            @"title": @"4月主打商品 (緹花運動毛巾)",
            @"dateRange": @"2025/01/01 ~ 2025/04/30",
            @"points": @"5",
            @"status": @"即將開放",
            @"taskDetail":@{
                @"title": @"4月主打商品 (緹花運動毛巾)",
                @"buttonTitle":@"確定",
                @"cellContents":@[
                    @"2025/04/01 ~ 2025/04/30",
                    @"4 月限定主打商品 TAKAO 茶包 10 入組 熱銷中！活動期間內，至天鷹實體店面購買，即可獲得 5 點，好茶好禮一起帶回家！",
                    @"5",
                    @[@"參加資格：活動期間內，於天鷹實體店面購買 TAKAO 茶包 10 入組。",
                      @"活動達成條件：成功結帳購買，即可獲得點數。",
                      @"點數發送：購買後 24 小時內，自動發放至會員帳戶，可至 APP 查詢並使用點數。"],
                ],
                @"footerContent":@"TAKAO：買茶還能拿點數？這麼划算的事，當然是喝爆啊！",
                @"type":@"",
                @"status": @"即將開放",
                @"isBluetooth":@NO,
                @"locationType":@2,
                @"callback":@""
            }
        }
    ]];
    
    // 會員專屬任務数据
    self.memberTasks = [NSMutableArray arrayWithArray:@[
        @{
            @"title": @"成功申辦鷹國皇家",
            @"dateRange": @"2025/01/01 ~ 2025/04/30",
            @"points": @"300",
            @"status": @"即將開放",
            @"taskDetail":@{
                @"title": @"開幕戰感謝有你",
                @"buttonTitle":@"點選參加",
                @"cellContents":@[
                    @"2025/01/01 ~ 2025/04/30",
                    @"第一次登入天鷹 APP 的球迷可立即獲得超值點數！不僅是賽事速報，還有專屬活動等你來參與！",
                    @"5",
                    @[@"參加資格：活動期間內，首次登入天鷹 APP 的球迷即可獲得點數。",
                      @"活動達成條件：成功登入並完成註冊，即可獲得點數獎勵。",
                      @"點數發送：比賽結束後 24 小時內，自動發放至會員帳戶，可於 App 查詢點數並兌換獎品。"],
                ],
                @"footerContent":@"TAKAO：進場就有點數拿！爽看比賽還能賺獎勵，這麼划算的事還不衝？",
                @"type":@"",
                @"isBluetooth":@NO,
                @"locationType":@0,
                @"callback":@""
            }
        },
        @{
            @"title": @"成功申辦鷹國尊爵",
            @"dateRange": @"2025/01/01 ~ 2025/04/30",
            @"points": @"200",
            @"status": @"即將開放",
            @"taskDetail":@{
                @"title": @"開幕戰感謝有你",
                @"buttonTitle":@"點選參加",
                @"cellContents":@[
                    @"2025/01/01 ~ 2025/04/30",
                    @"第一次登入天鷹 APP 的球迷可立即獲得超值點數！不僅是賽事速報，還有專屬活動等你來參與！",
                    @"5",
                    @[@"參加資格：活動期間內，首次登入天鷹 APP 的球迷即可獲得點數。",
                      @"活動達成條件：成功登入並完成註冊，即可獲得點數獎勵。",
                      @"點數發送：比賽結束後 24 小時內，自動發放至會員帳戶，可於 App 查詢點數並兌換獎品。"],
                ],
                @"footerContent":@"TAKAO：進場就有點數拿！爽看比賽還能賺獎勵，這麼划算的事還不衝？",
                @"type":@"",
                @"isBluetooth":@NO,
                @"locationType":@0,
                @"callback":@""
            }
        },
        @{
            @"title": @"成功申辦 Takao 親子卡",
            @"dateRange": @"2025/01/01 ~ 2025/04/30",
            @"points": @"100",
            @"status": @"即將開放",
            @"taskDetail":@{
                @"title": @"開幕戰感謝有你",
                @"buttonTitle":@"點選參加",
                @"cellContents":@[
                    @"2025/01/01 ~ 2025/04/30",
                    @"第一次登入天鷹 APP 的球迷可立即獲得超值點數！不僅是賽事速報，還有專屬活動等你來參與！",
                    @"5",
                    @[@"參加資格：活動期間內，首次登入天鷹 APP 的球迷即可獲得點數。",
                      @"活動達成條件：成功登入並完成註冊，即可獲得點數獎勵。",
                      @"點數發送：比賽結束後 24 小時內，自動發放至會員帳戶，可於 App 查詢點數並兌換獎品。"],
                ],
                @"footerContent":@"TAKAO：進場就有點數拿！爽看比賽還能賺獎勵，這麼划算的事還不衝？",
                @"type":@"",
                @"isBluetooth":@NO,
                @"locationType":@0,
                @"callback":@""
            }
        },
        @{
            @"title": @"成功申辦鷹國人",
            @"dateRange": @"2025/01/01 ~ 2025/04/30",
            @"points": @"50",
            @"status": @"即將開放",
            @"taskDetail":@{
                @"title": @"成功申辦鷹國人",
                @"buttonTitle":@"點選參加",
                @"cellContents":@[
                    @"2025/01/01 ~ 2025/04/30",
                    @"第一次登入天鷹 APP 的球迷可立即獲得超值點數！不僅是賽事速報，還有專屬活動等你來參與！",
                    @"5",
                    @[@"參加資格：活動期間內，首次登入天鷹 APP 的球迷即可獲得點數。",
                      @"活動達成條件：成功登入並完成註冊，即可獲得點數獎勵。",
                      @"點數發送：比賽結束後 24 小時內，自動發放至會員帳戶，可於 App 查詢點數並兌換獎品。"],
                ],
                @"footerContent":@"TAKAO：進場就有點數拿！爽看比賽還能賺獎勵，這麼划算的事還不衝？",
                @"type":@"",
                @"isBluetooth":@NO,
                @"locationType":@0,
                @"callback":@""
            }
        }
    ]];
    //
    //    self.limitedTasks = [EGTmpDataManager sharedManager].limitedTasks;
    //    self.memberTasks = [EGTmpDataManager sharedManager].memberTasks;
    
    // 每日任務数据
//    self.dataArray = [NSMutableArray arrayWithArray:@[
//        @{
//            @"title": @"鷹援軍報道",
//            @"subtitle":@"",
//            @"dateRange": @"2025/XX/XX（當日賽事）",
//            @"points": @"1",
//            @"status": @"即將開放",
//            @"taskDetail":@{
//                @"title": @"當日賽事進場",
//                @"buttonTitle":@"點選參加",
//                @"cellContents":@[
//                    @"2025/XX/XX（當日賽事）",
//                    @"當日入場觀賽的球迷，不論戰況如何，都能獲得點數獎勵！",
//                    @"1",
//                    @[@"參加資格：當日入場觀賽並連接球場藍芽至 APP 的球迷，可獲得點數。",
//                      @"活動達成條件：成功入場並完成藍芽連線，即贈發點數獎勵。",
//                      @"點數發送：比賽結束後 24 小時內，自動發放至會員帳戶，可於 App 查詢點數並兌換獎品。"],
//                ],
//                @"footerContent":@"TAKAO：按個讚就能拿點數，這麼簡單的事，還不快來！趕緊點個讚，一起支持雄鷹！",
//                @"type":@"",
//                @"status": @"即將開放",
//                @"isBluetooth":@YES,
//                @"locationType":@1,
//                @"callback":@""
//            }
//        },
//        @{
//            @"title": @"打擊爆發",
//            @"subtitle":@"當日賽事台鋼雄鷹安打總數達 15 支以上",
//            @"dateRange": @"2025/XX/XX（當日賽事）",
//            @"points": @"3",
//            @"status": @"即將開放",
//            @"taskDetail":@{
//                @"title": @"打擊爆發",
//                @"buttonTitle":@"點選參加",
//                @"cellContents":@[
//                    @"2025/XX/XX（當日賽事）",
//                    @"當日台鋼雄鷹全隊累積安打數達 15 支以上，全場球迷可獲得活動點數獎勵！",
//                    @"3",
//                    @[@"參加資格：當日入場觀賽並連接球場藍芽至 APP 的球迷，可獲得點數。",
//                      @"活動達成條件：台鋼雄鷹在比賽中累積安打達指定數量，即觸發對應點數獎勵。",
//                      @"點數發送：比賽結束後 24 小時內，自動發放至會員帳戶，可於 App 查詢點數並兌換獎品。"],
//                ],
//                @"footerContent":@"TAKAO：還不趕快來？台鋼雄鷹都在拚了，你連點數都懶得拿嗎？",
//                @"type":@"",
//                @"status": @"即將開放",
//                @"isBluetooth":@NO,
//                @"locationType":@1,
//                @"callback":@""
//            }
//        },
//        @{
//            @"title": @"煙火展示",
//            @"subtitle": @"當日賽事台鋼雄鷹奪三振總數達10次以上",
//            @"dateRange": @"2025/XX/XX（當日賽事）",
//            @"points": @"5",
//            @"status": @"即將開放",
//            @"taskDetail":@{
//                @"title": @"煙火展示",
//                @"buttonTitle":@"點選參加",
//                @"cellContents":@[
//                    @"2025/XX/XX（當日賽事）",
//                    @"當日賽事中，台鋼雄鷹全隊累積全壘打 3 支以上，全場球迷還可獲得活動點數獎勵！",
//                    @"5",
//                    @[@"參加資格：當日入場觀賽並連接球場藍芽至 APP 的球迷，可獲得點數。",
//                      @"活動達成條件：台鋼雄鷹當場比賽全壘打總數達 3 支，即觸發點數獎勵。",
//                      @"點數發送：比賽結束後 24 小時內，自動發放至會員帳戶，可於 App 查詢點數並兌換獎品。"],
//                ],
//                @"footerContent":@"TAKAO：全壘打炸裂，煙火炸開！一起嗨翻天～🎆🔥",
//                @"type":@"",
//                @"status": @"即將開放",
//                @"isBluetooth":@NO,
//                @"locationType":@1,
//                @"callback":@""
//            }
//        },
//        @{
//            @"title": @"K功不凡",
//            @"subtitle": @"當日賽事台鋼雄鷹全壘打總數達 3 支以上",
//            @"dateRange": @"2025/XX/XX（當日賽事）",
//            @"points": @"3",
//            @"status": @"即將開放",
//            @"taskDetail":@{
//                @"title": @"K功不凡",
//                @"buttonTitle":@"點選參加",
//                @"cellContents":@[
//                    @"2025/XX/XX（當日賽事）",
//                    @"當日賽事中，台鋼雄鷹投手奪三振 10 次以上，全場球迷可獲得活動點數獎勵！",
//                    @"3",
//                    @[@"參加資格：當日入場觀賽並連接球場藍芽至 APP 的球迷，可獲得點數。",
//                      @"活動達成條件：台鋼雄鷹當場比賽奪三振數達 10 次，即觸發點數獎勵。",
//                      @"點數發送：比賽結束後 24 小時內，自動發放至會員帳戶，可於 App 查詢點數並兌換獎品。"],
//                ],
//                @"footerContent":@"TAKAO：三振全場，台鋼雄鷹就是這麼強！⚾💪",
//                @"type":@"",
//                @"status": @"即將開放",
//                @"isBluetooth":@NO,
//                @"locationType":@1,
//                @"callback":@""
//            }
//        }
//    ]];
}

- (void)setupTasksUI {
    // 创建 Collection View 布局
    UICollectionViewFlowLayout *limitedLayout = [[UICollectionViewFlowLayout alloc] init];
    limitedLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    limitedLayout.itemSize =CGSizeMake(ScaleW(255), ScaleW(109));
    limitedLayout.minimumLineSpacing = ScaleW(12);
    limitedLayout.sectionInset =  UIEdgeInsetsMake(0, 0, 0, 0);
    
    // 限時任務 Collection View
    self.limitedTasksCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:limitedLayout];
    self.limitedTasksCollectionView.delegate = self;
    self.limitedTasksCollectionView.dataSource = self;
    self.limitedTasksCollectionView.backgroundColor = [UIColor clearColor];
    self.limitedTasksCollectionView.showsHorizontalScrollIndicator = NO;
    [self.limitedTasksCollectionView registerClass:[EGTaskCollectionViewCell class] forCellWithReuseIdentifier:@"TaskCell"];
    //    [self.view addSubview:self.limitedTasksCollectionView];
    
    // 會員專屬任務 Collection View
    UICollectionViewFlowLayout *memberLayout = [[UICollectionViewFlowLayout alloc] init];
    memberLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    memberLayout.itemSize = CGSizeMake( ScaleW(255), ScaleW(109));
    memberLayout.minimumLineSpacing = ScaleW(12);
    memberLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.memberTasksCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:memberLayout];
    self.memberTasksCollectionView.delegate = self;
    self.memberTasksCollectionView.dataSource = self;
    self.memberTasksCollectionView.backgroundColor = [UIColor clearColor];
    self.memberTasksCollectionView.showsHorizontalScrollIndicator = NO;
    [self.memberTasksCollectionView registerClass:[EGTaskCollectionViewCell class] forCellWithReuseIdentifier:@"TaskCell"];
    //    [self.view addSubview:self.memberTasksCollectionView];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.limitedTasksCollectionView) {
        return self.limitedTasks.count>4?4:self.limitedTasks.count;
    } else {
        return self.memberTasks.count>4?4:self.memberTasks.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EGTaskCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TaskCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    NSDictionary *task;
    if (collectionView == self.limitedTasksCollectionView) {
        task = self.limitedTasks[indexPath.item];
    } else {
        task = self.memberTasks[indexPath.item];
    }
    
    [cell setupWithTask:task];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
    if (!model) {
        return;
    }
    WS(weakSelf);
    if (collectionView == self.limitedTasksCollectionView) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary: self.limitedTasks[indexPath.item][@"taskDetail"]];
        dict[@"status"] =self.limitedTasks[indexPath.row][@"status"];
        dict[@"title"] =self.limitedTasks[indexPath.row][@"title"];
        dict[@"UUID"] =self.limitedTasks[indexPath.row][@"UUID"];
        [self handleTaskwithInfo:dict completion:^(BOOL isReceivable) {
            // 更新任务状态
            NSMutableDictionary *task = [self.limitedTasks[indexPath.item] mutableCopy];
            if (![dict[@"status"] isEqualToString:@"未完成"]) {
                return;
            }
            
//            if (isReceivable) {
//                task[@"status"] = @"領取";
//                self.limitedTasks[indexPath.item] = task;
//                [self.limitedTasksCollectionView reloadData];
//            }else{
                [weakSelf pointGrant:@{@"Points":@(self.AddPoints),
                                       @"UUID":dict[@"UUID"]}
                          completion:^(BOOL success) {
                    if (success) {
                        // 处理成功情况
//                            task[@"status"] = @"已完成";
//                            self.limitedTasks[indexPath.item] = task;
//                            [self.limitedTasksCollectionView reloadData];
                        NSLog(@"任务完成");
                    } else {
                        // 处理失败情况
                        NSLog(@"添加点数失败");
                    }
                }];
            
//                task[@"status"] = @"已完成";
//                self.limitedTasks[indexPath.item] = task;
//                [self.limitedTasksCollectionView reloadData];
//            }
        }];
        // 处理限时任务
//            [[EGTmpDataManager sharedManager] addLimitedTasksDataToNotifcationForIndex:indexPath.item];
//            [collectionView reloadData];
    } else if (collectionView == self.memberTasksCollectionView) {
        // 处理会员任务
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary: self.memberTasks[indexPath.item][@"taskDetail"]];
        dict[@"status"] =self.memberTasks[indexPath.row][@"status"];
        dict[@"title"] =self.memberTasks[indexPath.row][@"title"];
        dict[@"UUID"] =self.memberTasks[indexPath.row][@"UUID"];
        [self handleTaskwithInfo:dict completion:^(BOOL isReceivable) {
            // isReceivable yes 代表点击后 状态 变为领取，NO 代表领取后 添加点数
            // 更新任务状态
          
            
            NSMutableDictionary *task = [self.memberTasks[indexPath.item] mutableCopy];
            if (![dict[@"status"] isEqualToString:@"未完成"]) {
                return;
            }
//
//            if (isReceivable) {
//                task[@"status"] = @"領取";
//                self.memberTasks[indexPath.item] = task;
//                [self.memberTasksCollectionView reloadData];
//            }else{
            
                [weakSelf pointGrant:@{@"Points":@(self.AddPoints),
                                       @"UUID":dict[@"UUID"]}
                          completion:^(BOOL success) {
                    if (success) {
                        // 处理成功情况
//                            task[@"status"] = @"已完成";
//                            self.limitedTasks[indexPath.item] = task;
//                            [self.limitedTasksCollectionView reloadData];
                        NSLog(@"任务完成");
                    } else {
                        // 处理失败情况
                        NSLog(@"添加点数失败");
                    }
                }];
//                task[@"status"] = @"已完成";
//                self.memberTasks[indexPath.item] = task;
//                [self.memberTasksCollectionView reloadData];
//            }
        }];
    }
}

//MARK: 新增点数 加 动画
- (void)animatePointsIncrease:(NSInteger)increment
{
    NSInteger startValue = self.totalpoint;
    NSInteger endValue = startValue + increment;
    NSInteger steps = 20; // 动画步数
    NSTimeInterval duration = 0.5; // 动画持续时间
    NSTimeInterval stepDuration = duration / steps;
    
    // 计算每步增加的值
    CGFloat valuePerStep = (CGFloat)increment / steps;
    
    // 创建定时器执行动画
    __block NSInteger currentStep = 0;
    __block NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:stepDuration repeats:YES block:^(NSTimer * _Nonnull timer) {
        currentStep++;
        
        if (currentStep <= steps) {
            NSInteger currentValue = startValue + (valuePerStep * currentStep);
            [self.headerView.pointsBtn setTitle:[NSString stringWithFormat:@"%ld", currentValue] forState:UIControlStateNormal];
            [self.headerView.pointsBtn layoutButtonWithEdgeInsetsStyle:ZYButtonEdgeInsetsStyleRight imageTitleSpace:1];
        } else {
            // 确保最终显示精确的值
            [self.headerView.pointsBtn setTitle:[NSString stringWithFormat:@"%ld", endValue] forState:UIControlStateNormal];
            [self.headerView.pointsBtn layoutButtonWithEdgeInsetsStyle:ZYButtonEdgeInsetsStyleRight imageTitleSpace:1];
            self.totalpoint = endValue;
            [timer invalidate];
            timer = nil;
        }
    }];
}
@end
