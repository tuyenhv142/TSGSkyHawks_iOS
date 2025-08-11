//
//  EGDateTimeView.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/13.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DatePickerViewDateNoDayMode,//年月
    DatePickerViewDateTimeMode,//年月日,时分
    DatePickerViewDateMode,//年月日
    DatePickerViewDateYearMode,//年
    DatePickerViewTimeMode//时分
} DatePickerViewMode;


NS_ASSUME_NONNULL_BEGIN

@protocol DateTimeViewDelegate <NSObject>
@optional
/**
 *确定按钮 非时间选择
 */
-(void)clickConfirmButtonEvent:(nullable id)idString;
/**
 *时间选择回调 2024-10  or 2024
 */
-(void)selectTimeToReturnString:(NSString *)dateString;
@end


@interface EGDateTimeView : UIView

-(void)addViewToWindow;

- (instancetype)initWithDatePickerModeType:(DatePickerViewMode)type;

@property (nonatomic, assign) DatePickerViewMode pickerViewMode;

@property(nonatomic,weak) id<DateTimeViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
