//
//  EGTmpDataManager.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/19.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGTmpDataManager.h"

static NSString * const KeyMessageData = @"array_Message";
static NSString * const KeyLimitedTasksData = @"array_LimitedTasks";
static NSString * const KeyMemberTasksData = @"array_MemberTasks";
static NSString * const KeyPointTotal = @"point_Total";

@implementation EGTmpDataManager


+ (EGTmpDataManager *)sharedManager
{
    static EGTmpDataManager *handle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handle = [[EGTmpDataManager alloc] init];
    });
    return handle;
}

- (NSMutableArray *)notificationData
{
    if (!_notificationData) {
        
        NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:KeyMessageData];

        if (!array) {
            _notificationData = [NSMutableArray arrayWithObject:@{
                @"title": @"首次登入天鷹 APP，好禮立即送！",
                @"dateRange": @"2025/01/01 ~ 2025/04/30",
                @"points": @"5",
                @"status": @"已完成",
                @"isRead": @"0"
            }];
        }else{
            _notificationData = [NSMutableArray arrayWithArray:array];
        }
        
    }
    return _notificationData;
}
//标记 已读
-(void)markMessageReadForIndex:(NSInteger )index
{
    NSDictionary *dict = self.notificationData[index];
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [mDict setObject:@"1" forKey:@"isRead"];
    
    [self.notificationData replaceObjectAtIndex:index withObject:mDict];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.notificationData forKey:KeyMessageData];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)pointNum
{
    if (!_pointNum) {
        
        NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:KeyPointTotal];
        if (number) {
            self.pointNum = [number intValue];
        }else{
            self.pointNum = 0;
        }
    }
    return _pointNum;
}

//限时任务 加入通知
-(void)addLimitedTasksDataToNotifcationForIndex:(NSInteger )index
{
    NSDictionary *dict = self.limitedTasks[index];
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [mDict setObject:@"已完成" forKey:@"status"];
    
    NSInteger point = [dict[@"points"] intValue];
    self.pointNum += point;
    [[NSUserDefaults standardUserDefaults] setObject:@(self.pointNum) forKey:KeyPointTotal];
    
    [self.notificationData addObject:mDict];
    [[NSUserDefaults standardUserDefaults] setObject:self.notificationData forKey:KeyMessageData];
    
    
    [self.limitedTasks replaceObjectAtIndex:index withObject:mDict];
    [[NSUserDefaults standardUserDefaults] setObject:self.limitedTasks forKey:KeyLimitedTasksData];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//會員專屬任務数据 加入通知
-(void)addMemberTasksDataToNotifcationForIndex:(NSInteger )index
{
    NSDictionary *dict = self.memberTasks[index];
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [mDict setObject:@"已完成" forKey:@"status"];
    
    NSInteger point = [dict[@"points"] intValue];
    self.pointNum += point;
    [[NSUserDefaults standardUserDefaults] setObject:@(self.pointNum) forKey:KeyPointTotal];
    
    [self.notificationData addObject:mDict];
    [[NSUserDefaults standardUserDefaults] setObject:self.notificationData forKey:KeyMessageData];
    
    
    [self.memberTasks replaceObjectAtIndex:index withObject:mDict];
    [[NSUserDefaults standardUserDefaults] setObject:self.memberTasks forKey:KeyMemberTasksData];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (NSMutableArray *)limitedTasks
{
    if (!_limitedTasks) {
        NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:KeyLimitedTasksData];
        if (array) {
            _limitedTasks = [NSMutableArray arrayWithArray:array];
        }else{
            NSArray *arr = @[@{
                @"title": @"首次登入天鷹 APP，好禮立即送！",
                @"dateRange": @"2025/01/01 ~ 2025/04/30",
                @"points": @"5",
                @"status": @"已完成",
                @"isRead": @"0"
            },
            @{
                @"title": @"按讚官方 Facebook",
                @"dateRange": @"2025/01/01 ~ 2025/04/30",
                @"points": @"1",
                @"status": @"任務詳情",
                @"isRead": @"0"
            },
            @{
                @"title": @"追蹤官方 Instagram",
                @"dateRange": @"2025/01/01 ~ 2025/04/30",
                @"points": @"1",
                @"status": @"任務詳情",
                @"isRead": @"0"
            },
            @{
                @"title": @"訂閱官方 Youtube",
                @"dateRange": @"2025/01/01 ~ 2025/04/30",
                @"points": @"1",
                @"status": @"任務詳情",
                @"isRead": @"0"
            }];
            _limitedTasks = [NSMutableArray arrayWithArray:arr];
        }
    }
    return _limitedTasks;
}

- (NSMutableArray *)memberTasks
{
    if (!_memberTasks) {
        NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:KeyMemberTasksData];
        if (array) {
            _memberTasks = [NSMutableArray arrayWithArray:array];
        }else{
            NSArray *arr = @[@{
                @"title": @"成功申辦鷹國皇家",
                @"dateRange": @"2025/01/01 ~ 2025/04/30",
                @"points": @"300",
                @"status": @"任務詳情",
                @"isRead": @"0"
            },
            @{
                @"title": @"成功申辦鷹國尊爵",
                @"dateRange": @"2025/01/01 ~ 2025/04/30",
                @"points": @"200",
                @"status": @"任務詳情",
                @"isRead": @"0"
            },
            @{
                @"title": @"成功申辦 Takao 親子卡",
                @"dateRange": @"2025/01/01 ~ 2025/04/30",
                @"points": @"100",
                @"status": @"任務詳情",
                @"isRead": @"0"
            },
            @{
                @"title": @"成功申辦鷹國人",
                @"dateRange": @"2025/01/01 ~ 2025/04/30",
                @"points": @"50",
                @"status": @"任務詳情",
                @"isRead": @"0"
            }];
            _memberTasks = [NSMutableArray arrayWithArray:arr];
        }
    }
    return _memberTasks;
}


//- (NSPersistentContainer *)persistentContainer
//{
//    if (_persistentContainer == nil) {
//        _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"TmpModel"];
//        _persistentContainer.viewContext.undoManager = nil; // 禁用撤销功能以提升性能
//        [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
//            if (error != nil) {
//                NSLog(@"Unresolved error %@, %@", error, error.userInfo);
//                abort();
//            }
//        }];
//    }
//    return _persistentContainer;
//}
//
//- (void)saveData
//{
//    NSManagedObjectContext *context = [self.persistentContainer viewContext];
//    NSManagedObject *newEntity = [NSEntityDescription insertNewObjectForEntityForName:@"PointMessage" inManagedObjectContext:context]; // EntityName是你的实体名称
//    [newEntity setValue:@"Value" forKey:@"attributeName"]; // attributeName是你的属性名称，Value是你要设置的值
//    NSError *error = nil;
//    if ([context save:&error]) {
//        NSLog(@"Data saved successfully");
//        
//        [self fetchData];
//    } else {
//        NSLog(@"Error saving data: %@", error.localizedDescription);
//    }
//}
//- (void)fetchData
//{
//    NSManagedObjectContext *context = [self.persistentContainer viewContext];
//    
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"PointMessage"];
//    
//    NSError *error = nil;
//    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
//    
//    NSLog(@"array : %@",results);
//    
//    if (error != nil) {
//        NSLog(@"Error fetching data: %@", error.localizedDescription);
//    } else {
//        for (NSManagedObject *object in results) {
//            NSString *value = [object valueForKey:@"attributeName"]; // attributeName是你的属性名称
//            NSLog(@"1  Data: %@", value);
//        }
//    }
//}
//
//- (void)updateData:(NSManagedObject *)object withValue:(NSString *)newValue
//{
//    NSManagedObjectContext *context = [self.persistentContainer viewContext];
//    
//    [object setValue:newValue forKey:@"attributeName"]; // attributeName是你的属性名称，newValue是你想要更新的新值
//    NSError *error = nil;
//    if ([context save:&error]) {
//        NSLog(@"Data updated successfully");
//    } else {
//        NSLog(@"Error updating data: %@", error.localizedDescription);
//    }
//}
//
//- (void)deleteData:(NSManagedObject *)object
//{
//    NSManagedObjectContext *context = [self.persistentContainer viewContext];
//    
//    [context deleteObject:object];
//    NSError *error = nil;
//    if ([context save:&error]) {
//        NSLog(@"Data deleted successfully");
//    } else {
//        NSLog(@"Error deleting data: %@", error.localizedDescription);
//    }
//}

//- (void)savePersonWithHobbies:(NSArray<NSString *> *)hobbies
//{
//    NSManagedObjectContext *context = [self.persistentContainer viewContext]; // 获取 context
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PointMessage" inManagedObjectContext:context];
//    NSManagedObject *person = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
//    [person setValue:hobbies forKey:@"hobbies"]; // 设置 hobbies 属性
//    NSError *error = nil;
//    [context save:&error]; // 保存 context
////    [context release]; // 释放 context
//}
//- (NSArray<NSString *> *)fetchHobbiesForPerson:(NSManagedObject *)person
//{
//    return [person valueForKey:@"hobbies"]; // 直接读取 hobbies 属性
//}
@end
