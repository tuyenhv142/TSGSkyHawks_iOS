//
//  EGEventStoreTool.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/6.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <EventKit/EventKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGEventStoreTool : NSObject

+(EGEventStoreTool *)shareEvent;

/**
 *日程
 */
-(void)addEventToCalender:(nonnull id)dict;

/**
 *提醒事件
 */
-(void)addReminderToCalender:(nonnull id)dict;//nonnull  nullable



@property (nonatomic, strong) EKEventStore *eventStore;
+ (instancetype)sharedManager;

- (void)requestAccessWithCompletion:(void(^)(BOOL granted))completion;

- (void)createEvent:(NSString *)title
         startDate:(NSDate *)startDate
           endDate:(NSDate *)endDate
           notes:(NSString *)notes
         completion:(void(^)(BOOL success, NSError *error))completion;

- (NSArray *)fetchEventsFromDate:(NSDate *)startDate
                          toDate:(NSDate *)endDate;

- (BOOL)deleteEvent:(EKEvent *)event
              error:(NSError **)error;



- (void)createReminderWithTitle:(NSString *)title
                         notes:(NSString *)notes
                      dueDate:(NSDate *)dueDate
                     completion:(void(^)(BOOL success, NSError *error))completion;

- (void)fetchAllRemindersWithCompletion:(void(^)(NSArray<EKReminder *> *reminders, NSError *error))completion;

- (void)deleteReminder:(EKReminder *)reminder
            completion:(void(^)(BOOL success, NSError *error))completion;

- (void)updateReminder:(EKReminder *)reminder
             newTitle:(NSString *)newTitle
             newNotes:(NSString *)newNotes
          newDueDate:(NSDate *)newDueDate
            completion:(void(^)(BOOL success, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
