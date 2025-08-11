//
//  EGTmpDataManager.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/19.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGTmpDataManager : NSObject

+ (EGTmpDataManager *)sharedManager;

//message
@property (nonatomic,strong) NSMutableArray *notificationData;
-(void)markMessageReadForIndex:(NSInteger )index;
//@property (nonatomic,strong) NSPersistentContainer *persistentContainer;


@property (nonatomic,assign) NSInteger pointNum;
// 限時任務数据
@property (nonatomic,strong) NSMutableArray *limitedTasks;
// 會員專屬任務数据
@property (nonatomic,strong) NSMutableArray *memberTasks;

//限时任务 加入通知
-(void)addLimitedTasksDataToNotifcationForIndex:(NSInteger )index;

//會員專屬任務数据 加入通知 送红花 PopUpRedFlowerView
-(void)addMemberTasksDataToNotifcationForIndex:(NSInteger )index;

@end

NS_ASSUME_NONNULL_END
