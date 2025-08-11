    #import "EGPointsTaskListViewController.h"
    #import "EGPointsListTBVCell.h"
    #import "EGComingSoonPopupView.h"
    #import "EGTaskeventsModel.h"
    //#import "UITableView+XY.h"

    #import <CommonCrypto/CommonDigest.h>
    //#import "UITableView+XY.h"

    @interface EGPointsTaskListViewController ()<UITableViewDelegate, UITableViewDataSource,EGPointsListTBVCellDelegate>
    @property (nonatomic, assign) NSInteger AddPoints; //需添加的点数
    @end

    @implementation EGPointsTaskListViewController

    -(void)viewWillAppear:(BOOL)animated{
        [super viewWillAppear:animated];
        [self.tableView reloadData];
    }
    - (void)viewDidLoad {
        [super viewDidLoad];
        
        // 设置标题
        NSArray *titles = @[@"", @"限時任務", @"鷹國會員專屬任務", @"每日任務"];
        self.navigationItem.title = titles[self.currentSection];
        
        // 设置 TableView
    //    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = rgba(243, 243, 243, 1);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.tableView];
        
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.mas_equalTo([UIDevice de_navigationFullHeight]);
        }];

        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getTask];
          //  [self.tableView reloadData];
    //        [self.tableView.mj_header endRefreshing];
        }];
    //    [self.tableView.mj_header beginRefreshing];

        [self.tableView reloadData];
    }
    //-(void)getEventTast{
    //    NSString *url2 = [EGServerAPI getEventtasks];
    //    [[WAFNWHTTPSTool sharedManager] getWithURL:url2 parameters:@{} headers:@{} success:^(NSDictionary * _Nonnull response) {
    //        ELog(@"%@",response);
    //        NSArray *array  = [EGTaskeventsModel mj_objectArrayWithKeyValuesArray:response];
    //        // 日期格式转换
    //        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    //        [inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    //        
    //        
    //        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    //        //            NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Taipei"];
    //        NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    //        [outputFormatter setTimeZone:timeZone];
    //        [outputFormatter setDateFormat:@"yyyy年M月d日"];
    //        
    //        [self.dailyTasks removeAllObjects];
    //        
    //        for (EGTaskeventsModel *model in array) {
    //            
    //            NSDate *startDate = [inputFormatter dateFromString:model.startDate];
    //            NSDate *endDate = [inputFormatter dateFromString:model.endDate];
    //            
    //            NSString *dateRange = [NSString stringWithFormat:@"%@ ~ %@",
    //                                   [outputFormatter stringFromDate:startDate],
    //                                   [outputFormatter stringFromDate:endDate]];
    //            BOOL isBlue = NO;
    //            if ( [model.triggerTag isEqualToString: @"attendance"] ||
    //                [model.triggerTag isEqualToString: @"mvp"] ||
    //                [model.triggerTag isEqualToString: @"takao"] ||
    //                [model.triggerTag isEqualToString: @"thanks"] ||
    //                [model.triggerTag isEqualToString: @"checkin"]  ) {
    //                isBlue = YES;
    //            }
    //            NSString *stauts;
    //            if ([model.personalEventTaskStatus isEqualToString:@"unlock"]) {
    //                stauts = @"即將開放";
    //            }else if ([model.personalEventTaskStatus isEqualToString:@"unlockNot"]){
    //                stauts = @"尚未解鎖";
    //            }else if ([model.personalEventTaskStatus isEqualToString:@"pending"]){
    //                stauts = @"未完成";
    //            }else if ([model.personalEventTaskStatus isEqualToString:@"completed"]){
    //                stauts = @"已完成";
    //            }else if ([model.personalEventTaskStatus isEqualToString:@"reward"]){
    //                stauts = @"已完成";
    //            }else if ([model.personalEventTaskStatus isEqualToString:@"expired"]){
    //                stauts = @"已過期";
    //            }else{
    //                stauts = @"即將開放";
    //            }
    //            
    //            
    //            EGLocationRestrictionType locationType;
    //            if ([model.triggerTag isEqualToString:@"item"]) {
    //                locationType =  EGLocationRestrictionTypeShop;
    //            }else if([model.triggerTag isEqualToString:@"mvp"] ||
    //                     [model.triggerTag isEqualToString:@"takao"] ||
    //                     [model.triggerTag isEqualToString:@"attendance"] ||
    //                     [model.triggerTag isEqualToString:@"checkin"] ||
    //                     [model.triggerTag isEqualToString:@"thanks"]){
    //                locationType =  EGLocationRestrictionTypeStadium;
    //            }else{
    //                locationType =  EGLocationRestrictionTypeNone;
    //            }
    //            
    //            if (self.currentSection == 1) {
    //                if ([model.eventType isEqualToString:@"limited"]) {
    //                    [self.dailyTasks addObject:@{
    //                        @"title": model.topic,
    //                        @"subtitle":model.content,
    //                        @"dateRange": dateRange,
    //                        @"points": model.point,
    //                        @"status": stauts,
    //                        @"UUID":model.ID,
    //                        @"taskDetail":@{
    //                            @"title": model.topic,
    //                            @"buttonTitle":@"點選參加",
    //                            @"cellContents":@[
    //                                dateRange,
    //                                model.content,
    //                                model.point,
    //                                @[model.pointProcess],
    //                            ],
    //                            @"footerContent":@"TAKAO：進場就有點數拿！爽看比賽還能賺獎勵，這麼划算的事還不衝？",
    //                            @"type":model.triggerTag,
    //                            @"locationType":@(1),
    //                            @"isBluetooth":@(isBlue),
    //                            @"callback":@""
    //                        }}];
    //                }
    //            }else if (self.currentSection == 2){
    //                // exclusive: 專屬,
    //                if ([model.eventType isEqualToString:@"exclusive"]) {
    //                    [self.dailyTasks addObject:@{
    //                        @"title": model.topic,
    //                        @"subtitle":model.content,
    //                        @"dateRange": dateRange,
    //                        @"points": model.point,
    //                        @"status": stauts,
    //                        @"UUID":model.ID,
    //                        @"taskDetail":@{
    //                            @"title": model.topic,
    //                            @"buttonTitle":@"點選參加",
    //                            @"cellContents":@[
    //                                dateRange,
    //                                model.content,
    //                                model.point,
    //                                @[model.pointProcess],
    //                            ],
    //                            @"footerContent":@"TAKAO：進場就有點數拿！爽看比賽還能賺獎勵，這麼划算的事還不衝？",
    //                            @"type":model.triggerTag,
    //                            @"locationType":@(1),
    //                            @"isBluetooth":@(isBlue),
    //                            @"callback":@""
    //                        }}];
    //                    
    //                }
    //            }else if(self.currentSection == 3){
    //                if ([model.eventType isEqualToString:@"daily"]) {
    //                    [self.dailyTasks addObject:@{
    //                        @"title": model.topic,
    //                        @"subtitle":model.content,
    //                        @"dateRange": dateRange,
    //                        @"points": model.point,
    //                        @"status": stauts,
    //                        @"UUID":model.ID,
    //                        @"taskDetail":@{
    //                            @"title": model.topic,
    //                            @"buttonTitle":@"點選參加",
    //                            @"cellContents":@[
    //                                dateRange,
    //                                model.content,
    //                                model.point,
    //                                @[model.pointProcess],
    //                            ],
    //                            @"footerContent":@"TAKAO：進場就有點數拿！爽看比賽還能賺獎勵，這麼划算的事還不衝？",
    //                            @"type":model.triggerTag,
    //                            @"locationType":@(1),
    //                            @"isBluetooth":@(isBlue),
    //                            @"callback":@""
    //                        }}];
    //                }
    //            }
    //        }
    //        //        // 刷新表格
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            [self.tableView reloadData];
    //        });
    //        [self.tableView.mj_header endRefreshing];
    //        
    //    } failure:^(NSError * _Nonnull error) {
    //        [self.tableView.mj_header endRefreshing];
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            
    //            if ([error.localizedDescription containsString:@"offline"] || error.code == -1009) {
    //                [MBProgressHUD showDelayHidenMessage:@"請檢查您的網路連線，確保裝置已連接至網路後再重試。"];
    //            }else{
    //                [MBProgressHUD showDelayHidenMessage:error.localizedDescription];
    //            }
    //        });
    //    }];
    //    [self.tableView.mj_header endRefreshing];
    //    
    //}

    //获取任务
    -(void)getTask{
        
        UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
        if (!model) {
    //        [self getEventTast];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            return;
        }
        
        NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
        NSDictionary *dict_header = @{@"Authorization":tokenString};
        
        MemberInfomationModel *infoModel = [EGLoginUserManager getMemberInfomation];
        if (!infoModel) {
            [self.tableView.mj_header endRefreshing];
            return;
        }
        NSDictionary *dict_body = @{@"Mobile":infoModel.Phone};
        
        [[WAFNWHTTPSTool sharedManager] postWithURL:[EGServerAPI basicMemberGenqrcode:model.ID] parameters:dict_body headers:dict_header success:^(NSDictionary * _Nonnull response) {
            
            if (![response isKindOfClass:[NSDictionary class]]) {
                [MBProgressHUD showDelayHidenMessage:@"數據格式錯誤"];
                [self.tableView.mj_header endRefreshing];
                return;
            }
            NSDictionary *data = [response objectOrNilForKey:@"data"];
            if (![data isKindOfClass:[NSDictionary class]]) {
                [MBProgressHUD showDelayHidenMessage:@"數據格式錯誤"];
                [self.tableView.mj_header endRefreshing];
                return;
            }
            NSString *qrCode =  [data objectOrNilForKey:@"MEMQRCODE"];
            if (!qrCode || ![qrCode isKindOfClass:[NSString class]]) {
                [MBProgressHUD showDelayHidenMessage:@"數據格式錯誤"];
                [self.tableView.mj_header endRefreshing];
                return;
            }
            
            NSString *url2 = [EGServerAPI getEventmembertasks:qrCode];
            //  NSString *url2 = [EGServerAPI getEventtasks];
            ELog(@"url2:%@",url2);
            [[WAFNWHTTPSTool sharedManager] getWithURL:url2 parameters:@{} headers:dict_header success:^(NSDictionary * _Nonnull response) {
                ELog(@"%@",response);
                NSArray *array  = [EGTaskeventsModel mj_objectArrayWithKeyValuesArray:response];
                // 遍历现有任务，更新状态
                for (NSInteger i = 0; i < self.dailyTasks.count; i++) {
                    NSMutableDictionary *task = [self.dailyTasks[i] mutableCopy];
                    
                    // 在新数据中查找匹配的任务
                    for (EGTaskeventsModel *model in array) {
                        if ([task[@"UUID"] isEqualToString:model.ID]) {
                            // 根据 model 的状态更新 task 的状态
                            NSString *newStatus;
                            if ([model.personalEventTaskStatus isEqualToString:@"unlock"]) {
                                newStatus = @"即將開放";
                            } else if ([model.personalEventTaskStatus isEqualToString:@"unlockNot"]) {
                                newStatus = @"尚未解鎖";
                            } else if ([model.personalEventTaskStatus isEqualToString:@"pending"]) {
                                newStatus = @"未完成";
                            } else if ([model.personalEventTaskStatus isEqualToString:@"completed"]) {
                                newStatus = @"已完成";
                            } else if ([model.personalEventTaskStatus isEqualToString:@"reward"]) {
                                newStatus = @"已完成";
                            } else if ([model.personalEventTaskStatus isEqualToString:@"expired"]) {
                                newStatus = @"已過期";
                            } else {
                                newStatus = @"即將開放";
                            }
                            
                            task[@"status"] = newStatus;
                            self.dailyTasks[i] = task;
                            break;
                        }
                    }
                }

                // 刷新表格
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
                [self.tableView.mj_header endRefreshing];
                
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
            
        } failure:^(NSError * _Nonnull error) {
            
            if ([error.localizedDescription containsString:@"offline"] || error.code == -1009) {
                [MBProgressHUD showDelayHidenMessage:@"請檢查您的網路連線，確保裝置已連接至網路後再重試。"];
            }else{
                [MBProgressHUD showDelayHidenMessage:error.localizedDescription];
            }
        }];
    }


    //MARK:- 添加点数请求
    - (NSString *)getCurrentTimeUTCString {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
       // [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        return [formatter stringFromDate:[NSDate date]];
    }

    -(void)pointGrant:(NSDictionary *)para completion:(void(^)(BOOL success))completion {

        UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
        if (!model) {
           // [self.tableView.mj_header endRefreshing];
            if (completion) {
                completion(NO);
            }
            return;
        }
        
        
        MemberInfomationModel *infoModel = [EGLoginUserManager getMemberInfomation];
        if (!infoModel) {
            return;
        }
        NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
        NSDictionary *dict_header = @{@"Authorization":tokenString};
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
            
    //        self.memberCode = qrCode;
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
                [self getTask];
                [self.tableView reloadData];
                
            } failure:^(NSError * _Nonnull error) {
                if ([error.localizedDescription containsString:@"offline"]  || error.code == -1009) {
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

    #pragma mark - UITableViewDataSource
    - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        WS(weakSelf);
        UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
        if (!model) {
            return;
        }
    //    if (self.currentSection == 2) {
    //        return;
    //    }
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary: self.dailyTasks[indexPath.row][@"taskDetail"]];
        dict[@"status"] =self.dailyTasks[indexPath.row][@"status"];
        dict[@"index"] =  [NSString stringWithFormat:@"%ld",indexPath.row ];
        dict[@"UUID"] =self.dailyTasks[indexPath.row][@"UUID"];
        [self handleTaskwithInfo:dict completion:^(BOOL isReceivable){
            // 在这里处理任务完成后的操作
            // 更新任务状态
            NSMutableDictionary *task = [self.dailyTasks[indexPath.item] mutableCopy];
    //        if (isReceivable) {
    //            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"任務領取成功"
    //                                                                           message:@"點數將於比賽結束後發放到您的帳戶"
    //                                                                    preferredStyle:UIAlertControllerStyleAlert];
    //            
    //            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"確認"
    //                                                                    style:UIAlertActionStyleDefault
    //                                                                  handler:nil];
    //            [alert addAction:confirmAction];
    //            [self presentViewController:alert animated:YES completion:nil];
    //            if (self.currentSection == 3) {
    //                
    //            }else{
    //                task[@"status"] = @"領取";
    //           
    //                [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskStatusUpdateNotification"
    //                                                                    object:nil
    //                                                                  userInfo:@{
    //                    @"section": @(self.currentSection),
    //                    @"index": @(indexPath.row),
    //                    @"status": @"領取",
    //                    @"points": @(self.AddPoints)
    //                }];
    //            }
    //            self.dailyTasks[indexPath.row] = task;
    //            [self.tableView reloadData];
    //        }else{
            if (![dict[@"status"] isEqualToString:@"未完成"]) {
                return;
            }
                [weakSelf pointGrant:@{@"Points":@(self.AddPoints),
                                       @"UUID":dict[@"UUID"]}
                                       completion:^(BOOL success) {
                    if (success) {
                        // 处理成功情况
                        dispatch_async(dispatch_get_main_queue(), ^{

                            [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskStatusUpdateNotification"
                                                                                object:nil
                                                                              userInfo:@{
                                @"section": @(self.currentSection),
                                @"index": @(indexPath.row),
                                @"status": @"已完成",
                                @"points": @(self.AddPoints)
                            }];
                        });
                        
                    } else {
                        // 处理失败情况
                        NSLog(@"添加点数失败");
                    }
                }];
    //            task[@"status"] = @"已完成";
    //            self.dailyTasks[indexPath.row] = task;
    //            [self.tableView reloadData];
    //        }

            NSLog(@"任务完成");
        }];
        
    }

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dailyTasks.count;
//    switch (self.currentSection) {
//        case 1:
//            return self.limitedTasks.count;
//        case 2:
//            return self.memberTasks.count;
//        case 3:
//            return self.dailyTasks.count;
//        default:
//            return 0;
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EGPointsListTBVCell *cell = [EGPointsListTBVCell cellWithUITableView:tableView];
    
    NSDictionary *data;
//    switch (self.currentSection) {
//        case 1:
//            data = self.limitedTasks[indexPath.row];
//            break;
//        case 2:
//            data = self.memberTasks[indexPath.row];
//            break;
//        case 3:
//            data = self.dailyTasks[indexPath.row];
//            break;
//        default:
//            break;
//    }
    data = self.dailyTasks[indexPath.row];
    cell.delegate = self;
    cell.indexPath = indexPath;
    [cell setModeInfo:data];
    return cell;
}

- (NSString *)xy_noDataViewMessage {
    return @"尚無任務";
}

- (UIImage *)xy_noDataViewImage {
    return [UIImage imageNamed:@"nodata"];
}

#pragma mark - EGPointsListTBVCellDelegate

- (void)handleTaskwithInfo:(NSMutableDictionary *)taskInfo completion:(void(^)(BOOL isReceivable))completion {

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
    config[@"type"] = taskInfo[@"type"];
    config[@"status"] = taskInfo[@"status"];
//    config[@"isBluetooth"] =  taskInfo[@"isBluetooth"];
    config[@"locationType"] =  taskInfo[@"locationType"];
    NSString *pointsStr = taskInfo[@"cellContents"][2];
    NSInteger points = [pointsStr integerValue];
    self.AddPoints = points;
    
    if ([config[@"status"] isEqualToString:@"領取"] ) {
        //如果是领取状态 则弹出+ 几点。
        [MBProgressHUD showDelayHidenMessage:[NSString stringWithFormat:@"正在領取 + %ld 天鷹點",self.AddPoints]];
        if (completion) {
            completion(NO);
        }
    }else { // if([config[@"status"] isEqualToString:@"詳情"])
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
            // 在适当的位置添加动画效果，这里假设点数在 cellContents[2] 中
//            NSString *pointsStr = taskInfo[@"cellContents"][2];
//            NSInteger points = [pointsStr integerValue];
//            self.AddPoints = points;
     
            NSString *ddd = taskInfo[@"index"];
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

-(NSDictionary *)getEventModel:(EGTaskeventsModel *)model{

    BOOL isBlue = NO;
    BOOL isShowStauts = NO;
    if (  [model.triggerTag isEqualToString:@"checkin"]) {
        isBlue = YES;
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

@end
