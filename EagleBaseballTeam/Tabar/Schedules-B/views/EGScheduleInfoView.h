//
//  EGScheduleInfoView.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/7.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class EGScheduleModel;

@protocol EGScheduleInfoViewDelegate <NSObject>

@optional
/**
 * 11 加入行事历  12 前往购票
 */
-(void)botomButtonEvent:(NSInteger)tag dataModel:(EGScheduleModel *)model;

@end

@interface EGScheduleInfoView : UIView


/**
 * model
 */
-(void)setSchedulesInformation:(EGScheduleModel *)model;

/**
 * EGScheduleInfoViewDelegate
 */
@property (nonatomic,weak) id<EGScheduleInfoViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
