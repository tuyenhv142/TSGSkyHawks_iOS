//
//  ScheduleViewModel.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/26.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "ScheduleViewModel.h"

#import "EGScheduleModel.h"

@implementation ScheduleViewModel

//赛程 模块
- (void)getScheduleCalendarData:(NSString *)year Completion:(void (^)(NSError *error,NSArray *array))completionHandler
{
    WS(weakSelf);
    NSString *authString = [NSString stringWithFormat:@"%@:%@", [[EGCredentialManager sharedManager] getUsername], [[EGCredentialManager sharedManager] getPassword]];
    NSData *authData = [authString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64AuthString = [authData base64EncodedStringWithOptions:0];
    NSString *authHeader = [NSString stringWithFormat:@"Basic %@", base64AuthString];
    NSDictionary *dict_header = @{@"Authorization":authHeader};
    ELog(@"%@", authString)
    
    NSString *url = [EGServerAPI getSchedule_api];
//    NSString *url = @"http://tsg-hawks-akaqhvfyb7euhdh7.a03.azurefd.net/wp-json/th_game/v1/GetSchedule";//CDN 测试 无网路 数据请求
//    [MBProgressHUD showMessage:@""];
    [[WAFNWHTTPSTool sharedManager] getWithURL:url parameters:@{@"year":year,@"kindCode":@"A",@"teamNo":@"AKP011"} headers:dict_header success:^(id  _Nonnull response) {
        
        [MBProgressHUD hideHUD];
        NSArray *responseDto = [response objectForKey:@"ResponseDto"];
        NSArray *modelArr = [EGScheduleModel mj_objectArrayWithKeyValuesArray:responseDto];
        
        NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:0];
        for (EGScheduleModel *model in modelArr) {
            if ([model.HomeTeamName isEqualToString:@"AKP011"] || [model.VisitingTeamName isEqualToString:@"AKP011"]) {
                [arrayM addObject:model];
            }
        }
        
        NSArray *akpArray = arrayM;
        
        NSArray *sortedArray = [weakSelf sortArrayByDate:akpArray];
        
        if (completionHandler) {
            completionHandler(nil,sortedArray);
        }
        
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        if ([error.localizedDescription containsString:@"offline"] || error.code == -1009) {
            [MBProgressHUD showDelayHidenMessage:@"請檢查您的網路連線，確保裝置已連接至網路後再重試。"];
        }
    }];
    
}
- (void)getScheduleCalendarDataTest:(NSString *)year Completion:(void (^)(NSError *error,NSArray *array))completionHandler
{
    WS(weakSelf);
    NSDictionary *headerDict = @{@"Accept": @"application/json",  // 添加 Accept 头
                   @"Content-Type": @"application/json"  // 添加 Content-Type 头
    };
    
    NSString *url = [EGServerAPI getSchedule_api_test];
//    NSString *url = @"http://tsg-hawks-akaqhvfyb7euhdh7.a03.azurefd.net/wp-json/th_game/v1/GetSchedule";//CDN 测试 无网路 数据请求
//    [MBProgressHUD showMessage:@""];
    [[WAFNWHTTPSTool sharedManager] getWithURL:url parameters:@{@"year":year} headers:headerDict success:^(id  _Nonnull response) {
        
        [MBProgressHUD hideHUD];
        NSArray *responseDto = [response objectForKey:@"ResponseDto"];
//        ELog(@"%@", responseDto)
        NSArray *modelArr = [EGScheduleModel mj_objectArrayWithKeyValuesArray:responseDto];
//        
        NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:0];
        for (EGScheduleModel *model in modelArr) {
            if ([model.HomeTeamName isEqualToString:@"台鋼天鷹"] || [model.VisitingTeamName isEqualToString:@"台鋼天鷹"]) {
                [arrayM addObject:model];

            }
        }
//        
        NSArray *akpArray = arrayM;
        
        NSArray *sortedArray = [weakSelf sortArrayByDate:akpArray];
        
        if (completionHandler) {
            completionHandler(nil,sortedArray);
        }
        
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        if ([error.localizedDescription containsString:@"offline"] || error.code == -1009) {
            [MBProgressHUD showDelayHidenMessage:@"請檢查您的網路連線，確保裝置已連接至網路後再重試。"];
        }
    }];
    
}


//首页 模块
//- (void)getScheduleData:(NSString *)year Completion:(void (^)(NSError *error,NSArray *array))completionHandler
//{
//    WS(weakSelf);
//    self.year = [year integerValue];
//    self.model = nil;
//    NSString *authString = [NSString stringWithFormat:@"%@:%@", [[EGCredentialManager sharedManager] getUsername], [[EGCredentialManager sharedManager] getPassword]];
//    NSData *authData = [authString dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *base64AuthString = [authData base64EncodedStringWithOptions:0];
//    NSString *authHeader = [NSString stringWithFormat:@"Basic %@", base64AuthString];
//    NSDictionary *dict_header = @{@"Authorization":authHeader};
//    ELog(@"%@",dict_header);
//    NSString *url = [EGServerAPI getSchedule_api];
////    NSString *url = @"https://www.tsghawks.com/wp-json/th_game/v1/GetSchedule";//雄鹰 测试 无网路 数据请求 需要加 dict_header
////    [MBProgressHUD showMessage:@""];
//    [[WAFNWHTTPSTool sharedManager] getWithURL:url parameters:@{@"year":year,@"kindCode":@"A",@"teamNo":@"AKP011"} headers:dict_header success:^(id  _Nonnull response) {
//        
//        [MBProgressHUD hideHUD];
//        NSArray *responseDto = [response objectForKey:@"ResponseDto"];
//        NSArray *modelArr = [EGScheduleModel mj_objectArrayWithKeyValuesArray:responseDto];
//        
//        NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:0];
//        for (EGScheduleModel *model in modelArr) {
//            if ([model.HomeTeamName isEqualToString:@"台鋼天鷹"] || [model.VisitingTeamName isEqualToString:@"台鋼天鷹"]) {
//                [arrayM addObject:model];
//            }
//        }
//        
//        NSArray *akpArray = arrayM;
//        
//        NSArray *sortedArray = [weakSelf sortArrayByDate:akpArray];
//        
//        [weakSelf pastCompetitionRecords:sortedArray];
//        
//        if (completionHandler) {
//            completionHandler(nil,sortedArray);
//        }
//        
//    } failure:^(NSError * _Nonnull error) {
//        [MBProgressHUD hideHUD];
//        if ([error.localizedDescription containsString:@"offline"] || error.code == -1009) {
//            [MBProgressHUD showDelayHidenMessage:@"請檢查您的網路連線，確保裝置已連接至網路後再重試。"];
//        }
//    }];
//    
//}

- (void)getScheduleData:(NSString *)year Completion:(void (^)(NSError *error,NSArray *array))completionHandler
{
    WS(weakSelf);
    self.year = [year integerValue];
    self.model = nil;
    NSDictionary *headerDict = @{@"Accept": @"application/json",  // 添加 Accept 头
                   @"Content-Type": @"application/json"  // 添加 Content-Type 头
    };
    NSString *url = [EGServerAPI getSchedule_api_test];
//    NSString *url = @"https://www.tsghawks.com/wp-json/th_game/v1/GetSchedule";//雄鹰 测试 无网路 数据请求 需要加 dict_header
//    [MBProgressHUD showMessage:@""];
    [[WAFNWHTTPSTool sharedManager] getWithURL:url parameters:@{@"year":year} headers:headerDict success:^(id  _Nonnull response) {
        
        [MBProgressHUD hideHUD];
        NSArray *responseDto = [response objectForKey:@"ResponseDto"];
        NSArray *modelArr = [EGScheduleModel mj_objectArrayWithKeyValuesArray:responseDto];
        
        NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:0];
        for (EGScheduleModel *model in modelArr) {
            if ([model.HomeTeamName isEqualToString:@"台鋼天鷹"] || [model.VisitingTeamName isEqualToString:@"台鋼天鷹"]) {
                [arrayM addObject:model];
            }
        }
        
        NSArray *akpArray = arrayM;
        
        NSArray *sortedArray = [weakSelf sortArrayByDate:akpArray];
        
        [weakSelf pastCompetitionRecords:sortedArray];
        
        if (completionHandler) {
            completionHandler(nil,sortedArray);
        }
        
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        if ([error.localizedDescription containsString:@"offline"] || error.code == -1009) {
            [MBProgressHUD showDelayHidenMessage:@"請檢查您的網路連線，確保裝置已連接至網路後再重試。"];
        }
    }];
    
}


#pragma mark - 根据字典中的时间字段对数组进行排序
- (NSArray *)sortArrayByDate:(NSArray *)array
{
    // 使用 sortedArrayUsingComparator: 方法
    NSArray *sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(EGScheduleModel *dict1, EGScheduleModel *dict2) {
        // 将时间字符串转换为 NSDate
        NSDate *date1 = [self dateFromString:dict1.GameDateTimeS];
        NSDate *date2 = [self dateFromString:dict2.GameDateTimeS];
        // 比较日期
        return [date1 compare:date2];
    }];
    return sortedArray;
}

#pragma mark - 将时间字符串转换为 NSDate
- (NSDate *)dateFromString:(NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"]; // 设置日期格式
    return [formatter dateFromString:dateString];
}


- (void)pastCompetitionRecords:(NSArray *)array
{
    if (self.model) {
        return;
    }
    
    NSDateFormatter *formatterDd = [[NSDateFormatter alloc] init];
    [formatterDd setDateFormat:@"yyyy"];
    NSString *yearNow = [formatterDd stringFromDate:[NSDate date]];
    
    if (self.year < [yearNow intValue]) {
        
        EGScheduleModel *model = [array lastObject];
        self.model = model;
        if (self.blockRecords) {
            self.blockRecords(self.model);
        }
    }else{
        
        for (int j = 0; j < array.count; j++ )
        {
//            EGScheduleModel *model = array[j];
//            NSString *timeStr = model.GameDateTimeS;
//            NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
//            [formatter1 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
//            NSDate *dataDate = [formatter1 dateFromString:timeStr];
//            
//            NSInteger result = [self compareDate:dataDate withDate:[NSDate date]];
//            if (result < 1 ) {//&& [model.GameResult isEqualToString:@"0"]
//                self.model = model;
//                if (self.blockRecords) {
//                    self.blockRecords(self.model);
//                }
////                break;
//            }
            EGScheduleModel *displayMatch = nil;
            NSMutableArray *upcomingMatches = [NSMutableArray array];

            for (EGScheduleModel *model in array) {
                NSString *timeStr = model.GameDateTimeS;
                NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
                [formatter1 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                NSDate *dataDate = [formatter1 dateFromString:timeStr];
                
                NSInteger result = [self compareDate:dataDate withDate:[NSDate date]];
                
                if (result < 1) { // trận đã hoặc đang diễn ra
                    displayMatch = model;
                    break; // tìm được trận gần nhất đã/đang diễn ra thì dừng
                } else {
                    [upcomingMatches addObject:model]; // trận chưa diễn ra
                }
            }

            // Nếu không có trận đã/đang diễn ra, lấy trận sắp diễn ra gần nhất
            if (!displayMatch && upcomingMatches.count > 0) {
                // Sắp xếp theo thời gian tăng dần
                NSArray *sortedMatches = [upcomingMatches sortedArrayUsingComparator:^NSComparisonResult(EGScheduleModel *a, EGScheduleModel *b) {
                    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
                    [formatter1 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                    NSDate *dateA = [formatter1 dateFromString:a.GameDateTimeS];
                    NSDate *dateB = [formatter1 dateFromString:b.GameDateTimeS];
                    return [dateA compare:dateB];
                }];
                
                displayMatch = sortedMatches.firstObject;
            }

            if (displayMatch) {
                self.model = displayMatch;
                if (self.blockRecords) {
                    self.blockRecords(self.model);
                }
            }


        }
    }
    
    
    if (!self.model) {
        self.year --;
        [self getScheduleData:[NSString stringWithFormat:@"%ld",self.year] Completion:^(NSError * _Nonnull error, NSArray * _Nonnull array) {
            
        }];
    }
}
- (NSInteger )compareDate:(NSDate *)date1 withDate:(NSDate *)date2
{
    NSInteger resultNum = 0;
    NSComparisonResult result = [date1 compare:date2];
    switch (result) {
        case NSOrderedAscending:
//            NSLog(@"%@ 早于 %@", [self stringFromDate:date1], [self stringFromDate:date2]);
            resultNum = -1;
            break;
        case NSOrderedSame:
//            NSLog(@"%@ 等于 %@", [self stringFromDate:date1], [self stringFromDate:date2]);
            resultNum = 0;
            break;
        case NSOrderedDescending:
//            NSLog(@"%@ 晚于 %@", [self stringFromDate:date1], [self stringFromDate:date2]);
            resultNum = 1;
            break;
    }
    return resultNum;
}
@end
