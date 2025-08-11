//
//  ScheduleViewModel.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/26.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EGScheduleModel;
typedef void(^ScheduleModelBlock)(EGScheduleModel * _Nullable model);

NS_ASSUME_NONNULL_BEGIN


@interface ScheduleViewModel : NSObject

/**
 * 日历 模块数据（请求一次）
 */
- (void)getScheduleCalendarData:(NSString *)year Completion:(void (^)(NSError *error,NSArray *array))completionHandler;

- (void)getScheduleCalendarDataTest:(NSString *)year Completion:(void (^)(NSError *error,NSArray *array))completionHandler;

/**
 * 首页 模块数据（有可能请求去年的数据）
 */
- (void)getScheduleData:(NSString *)year Completion:(void (^)(NSError *error,NSArray *array))completionHandler;

- (void)getScheduleDataTest:(NSString *)year Completion:(void (^)(NSError *error,NSArray *array))completionHandler;
/**
 * 赛事回顾
 */
@property (nonatomic,strong) EGScheduleModel * _Nullable model;

@property (nonatomic,copy) ScheduleModelBlock blockRecords;

@property (nonatomic,assign) NSInteger year;
@end

NS_ASSUME_NONNULL_END
