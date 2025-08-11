//
//  EGEventStoreTool.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/6.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGEventStoreTool.h"

#import <EventKit/EKEventStore.h>
#import <EventKit/EKEvent.h>
#import <EventKit/EKReminder.h>
#import <EventKit/EKCalendar.h>
#import <EventKit/EKAlarm.h>
#import "EGScheduleModel.h"


@implementation EGEventStoreTool

+ (EGEventStoreTool *)shareEvent
{
    static EGEventStoreTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [EGEventStoreTool new];
    });
    return tool;
}

-(void)showGoToSettingsAlert
{
   UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"需要日曆的許可權限"
                                                                message:@"請在設定中允許訪問日曆"
                                                         preferredStyle:UIAlertControllerStyleAlert];
   UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:@"去設定"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action) {
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]
                                        options:@{}
                              completionHandler:nil];
   }];
   UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil];
   [alert addAction:settingsAction];
   [alert addAction:cancelAction];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *rootViewController = window.rootViewController;
   [rootViewController presentViewController:alert animated:YES completion:nil];
    
    
//    NSString *message = @"是否同意存取您的行事曆，以便輕鬆掌握比賽通知及賽程安排";
//    [ELAlertController alertControllerWithTitleName:@"賽程訂閱" andMessage:message cancelButtonTitle:@"不允許" confirmButtonTitle:@"允許" showViewController:rootViewController addCancelClickBlock:^(UIAlertAction * _Nonnull cancelAction) {
//            
//        } addConfirmClickBlock:^(UIAlertAction * _Nonnull SureAction) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]
//                                             options:@{}
//                                   completionHandler:nil];
//        }];
    
}


-(void)addEventToCalender:(nonnull id)dict
{
    EGScheduleModel *model;
    if ([dict isKindOfClass:[EGScheduleModel class]]) {
        model = (EGScheduleModel *)dict;
    }
    
    NSString *titleStr = [NSString stringWithFormat:@"%@ VS %@ (%@)",model.HomeTeamName,model.VisitingTeamName,model.FieldAbbe];
    NSString *GameDateTimeS = model.GameDateTimeS;
    NSString *GameDateTimeE = model.GameDateTimeS;
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *dateS = [formatter1 dateFromString:GameDateTimeS];
    NSDate *dateE = [formatter1 dateFromString:GameDateTimeE];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *previousMonth = [gregorian dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:dateS options:0];
    
    // 创建新事件
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        if (error) {
            NSLog(@"requestAccessToEntityType %@",error);
        }
        
        if (granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                EKCalendar *myCalendar = [eventStore defaultCalendarForNewEvents];
                if (!myCalendar) {
                    NSLog(@"无法获取默认日历");
                    return;
                }
                EKEvent *newEvent = [EKEvent eventWithEventStore:eventStore];
                [newEvent setCalendar:myCalendar];
                [newEvent setStartDate:dateS];
                if (dateE) {
                    [newEvent setEndDate:dateE];
                }else{
                    NSDate *endD = [NSDate dateWithTimeInterval:60*180 sinceDate:dateS];
                    [newEvent setEndDate:endD];
                }
                [newEvent setTitle:titleStr];
                [newEvent setNotes:model.FieldNo];
                [newEvent setLocation:model.FieldAbbe];
                EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:previousMonth];//提醒时间
                [newEvent addAlarm:alarm];

//                // 获取日历列表
//                NSArray *calendars = [eventStore calendarsForEntityType:EKEntityTypeEvent];
//                // 遍历日历列表，找出你想要设置的日历
//                for (EKCalendar *calendar in calendars) {
////                    if ([calendar.title isEqualToString:titleStr]) { // 自定义日历名称
////                        newEvent.calendar = calendar;
////                        break;
////                    }
//                    NSLog(@"calendar.title ------ %@", calendar.title);
//                }
                // 创建一个谓词来查找事件
                NSDate *fff = [gregorian dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:dateS options:0];
                NSDate *lll = [gregorian dateByAddingUnit:NSCalendarUnitDay value:1 toDate:dateS options:0];
                NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:fff endDate:lll calendars:nil];
               // 获取符合条件的事件
               NSArray *eventArr = [eventStore eventsMatchingPredicate:predicate];
               // 遍历并打印事件
               for (EKEvent *event in eventArr) {
                   if ([event.title isEqualToString:titleStr] && [event.startDate isEqualToDate:dateS]) {
                       [MBProgressHUD showDelayHidenMessage:@"該事件已加入行事曆"];
                       return;
                   }
//                   NSLog(@"Event Title: %@", event.title);
//                   NSLog(@"Event Start Date: %@", event.startDate);
//                   NSLog(@"Event End Date: %@", event.endDate);
               }
                NSError *error = nil;
                BOOL success = [eventStore saveEvent:newEvent span:EKSpanThisEvent error:&error];// 将事件保存到日历中
                if (!success) {
                    NSLog(@"Error saving event %@: %@", newEvent, error);
                }else{
                    [MBProgressHUD showDelayHidenMessage:@"行事曆加入成功"];
                }
            });
        }else{
            NSLog(@"未获得日历访问权限：%@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showGoToSettingsAlert];
            });
        }
    }];
    
}

-(void)addReminderToCalender:(nonnull id)dict
{
    EGScheduleModel *model;
    if ([dict isKindOfClass:[EGScheduleModel class]]) {
        model = (EGScheduleModel *)dict;
    }
    
    NSString *timeStr = model.GameDateTimeS;
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentMonth = [formatter1 dateFromString:timeStr];
    NSDate *previousMonth = [gregorian dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:currentMonth options:0];
    
    
    NSString *titleStr = [NSString stringWithFormat:@"%@ VS %@ (%@)",model.HomeTeamName,model.VisitingTeamName,model.FieldAbbe];
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    [eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error) {
        if (error) {
            NSLog(@"EKEntityTypeReminder %@",error);
        }
    }];
//    NSInteger nn = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
//    NSLog(@"nn: %ld",nn);
    EKReminder *newReminder = [EKReminder reminderWithEventStore:eventStore];
    [newReminder setTitle:titleStr];
    
//    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    NSDate *date = [formatter dateFromString:@"2025-02-05 14:34"];
//    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute ) fromDate:date];
//    [newReminder setStartDateComponents:components];
//    [newReminder setDueDateComponents:components];
    [newReminder setPriority:2];
//    [newReminder setCompletionDate:[formatter dateFromString:@"2025-02-26 13:40"]];
    
    EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:previousMonth];//提醒时间
    [newReminder setAlarms:@[alarm]];
    
    EKCalendar *myCalendar = [eventStore defaultCalendarForNewReminders];
    [newReminder setCalendar:myCalendar];
    
    NSError *error = nil;
    if (![eventStore saveReminder:newReminder commit:true error:&error]) {
        NSLog(@"Error Reminder event %@: %@", newReminder, error);
    }else{
        [MBProgressHUD showDelayHidenMessage:@"行事曆加入成功"];
    }
}


+ (instancetype)sharedManager
{
    static EGEventStoreTool *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _eventStore = [[EKEventStore alloc] init];
    }
    return self;
}

// 请求日历访问权限
- (void)requestAccessWithCompletion:(void(^)(BOOL granted))completion {
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(granted);
            }
        });
    }];
}

// 创建日程事件
- (void)createEvent:(NSString *)title
         startDate:(NSDate *)startDate
           endDate:(NSDate *)endDate
             notes:(NSString *)notes
         completion:(void(^)(BOOL success, NSError *error))completion {
    
    EKEvent *event = [EKEvent eventWithEventStore:self.eventStore];
    event.title = title;
    event.startDate = startDate;
    event.endDate = endDate;
    event.notes = notes;
    event.calendar = [self.eventStore defaultCalendarForNewEvents];
    
    NSError *error = nil;
    BOOL success = [self.eventStore saveEvent:event span:EKSpanThisEvent error:&error];
    if (completion) {
        completion(success, error);
    }
}
// 获取指定时间范围的事件
- (NSArray *)fetchEventsFromDate:(NSDate *)startDate toDate:(NSDate *)endDate
{
    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate
                                                                    endDate:endDate
                                                                  calendars:nil];
    return [self.eventStore eventsMatchingPredicate:predicate];
}

// 删除事件
- (BOOL)deleteEvent:(EKEvent *)event error:(NSError **)error {
    return [self.eventStore removeEvent:event span:EKSpanThisEvent error:error];
}



// 创建提醒事件
- (void)createReminderWithTitle:(NSString *)title
                         notes:(NSString *)notes
                      dueDate:(NSDate *)dueDate
                   completion:(void(^)(BOOL success, NSError *error))completion {
    
    EKReminder *reminder = [EKReminder reminderWithEventStore:self.eventStore];
    reminder.title = title;
    reminder.notes = notes;
    reminder.calendar = [self.eventStore defaultCalendarForNewReminders];
    if (dueDate) {
        reminder.dueDateComponents = [[NSCalendar currentCalendar] components:
                                    (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
                                     NSCalendarUnitHour | NSCalendarUnitMinute)
                                                                   fromDate:dueDate];
    }
    NSError *error = nil;
    BOOL success = [self.eventStore saveReminder:reminder commit:YES error:&error];
    if (completion) {
        completion(success, error);
    }
}

- (void)fetchAllRemindersWithCompletion:(void(^)(NSArray<EKReminder *> *reminders, NSError *error))completion {
    NSPredicate *predicate = [self.eventStore predicateForRemindersInCalendars:nil];
    
    [self.eventStore fetchRemindersMatchingPredicate:predicate completion:^(NSArray *reminders) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(reminders, nil);
            }
        });
    }];
}
- (void)deleteReminder:(EKReminder *)reminder
            completion:(void(^)(BOOL success, NSError *error))completion {
    NSError *error = nil;
    BOOL success = [self.eventStore removeReminder:reminder commit:YES error:&error];
    if (completion) {
        completion(success, error);
    }
}
- (void)updateReminder:(EKReminder *)reminder
             newTitle:(NSString *)newTitle
             newNotes:(NSString *)newNotes
          newDueDate:(NSDate *)newDueDate
           completion:(void(^)(BOOL success, NSError *error))completion {
    reminder.title = newTitle;
    reminder.notes = newNotes;
    if (newDueDate) {
        reminder.dueDateComponents = [[NSCalendar currentCalendar] components:
                                    (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
                                     NSCalendarUnitHour | NSCalendarUnitMinute)
                                                                   fromDate:newDueDate];
    }
    NSError *error = nil;
    BOOL success = [self.eventStore saveReminder:reminder commit:YES error:&error];
    
    if (completion) {
        completion(success, error);
    }
}



- (NSString *)getOrCreateUUID
{
//    ss:5DB20135-81B7-4B96-BB71-5B0866EDE210  yourappuuid:E3A871BE-3E47-46CC-B93D-110975F287F5
    NSString *ss = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSString *uuidKey = @"yourappuuid";
    NSString *uuid = [self getUUIDFromKeychain:uuidKey];
    if (!uuid) {
        uuid = [[NSUUID UUID] UUIDString];
        [self saveUUIDToKeychain:uuidKey uuid:uuid];
    }
    NSLog(@"ss:%@  yourappuuid:%@",ss,uuid);
    return uuid;
}

- (NSString *)getUUIDFromKeychain:(NSString *)key {
    NSDictionary *query = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrAccount: key,
        (__bridge id)kSecReturnData: @YES,
        (__bridge id)kSecMatchLimit: (__bridge id)kSecMatchLimitOne
    };
    CFTypeRef result = NULL;
    SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    if (result) {
        return [[NSString alloc] initWithData:(__bridge NSData *)result encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (void)saveUUIDToKeychain:(NSString *)key uuid:(NSString *)uuid {
    NSDictionary *query = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrAccount: key,
        (__bridge id)kSecValueData: [uuid dataUsingEncoding:NSUTF8StringEncoding]
    };
    SecItemAdd((__bridge CFDictionaryRef)query, NULL);
}
- (void)checkNotificationPermission {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        switch (settings.authorizationStatus) {
            case UNAuthorizationStatusNotDetermined:
                NSLog(@"--------------------Notification permission not determined.");
                break;
            case UNAuthorizationStatusDenied:
                NSLog(@"--------------------Notification permission denied.");
                break;
            case UNAuthorizationStatusAuthorized:
                NSLog(@"--------------------Notification permission granted.");
                break;
            case UNAuthorizationStatusProvisional:
                NSLog(@"--------------------Notification permission provisional.");
                break;
            case UNAuthorizationStatusEphemeral:
                NSLog(@"--------------------Notification permission ephemeral (app clips).");
                break;
            default:
                break;
        }
    }];
}
@end
