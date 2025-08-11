//
//  EGTaskeventsModel.h
//  EagleBaseballTeam
//
//  Created by rick on 3/10/25.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGTaskeventsModel : NSObject
@property (nonatomic, strong) NSArray *supportInfo;
@property (nonatomic, copy ) NSString *content;
@property (nonatomic, copy ) NSString *endDate;
@property (nonatomic, copy ) NSString *ID;
@property (nonatomic, copy ) NSString *eventType;
@property (nonatomic, copy ) NSString *startDate;
@property (nonatomic, copy ) NSString *point;
@property (nonatomic, copy ) NSString *topic;
@property (nonatomic, copy ) NSString *pointProcess;
@property (nonatomic, copy ) NSString *triggerType;
@property (nonatomic, copy ) NSString *triggerTag;
@property (nonatomic, copy ) NSString *personalEventTaskStatus;


@end

NS_ASSUME_NONNULL_END
