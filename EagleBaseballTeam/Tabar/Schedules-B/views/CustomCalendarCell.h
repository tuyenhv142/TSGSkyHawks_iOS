//
//  CustomCalendarCell.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/6.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "FSCalendarCell.h"

NS_ASSUME_NONNULL_BEGIN

@class EGScheduleModel;

@interface CustomCalendarCell : FSCalendarCell

-(void)setCanlenderData:(NSString *)index;
//
//-(void)setSchedulesModel:(EGScheduleModel *)model;
@end

NS_ASSUME_NONNULL_END
