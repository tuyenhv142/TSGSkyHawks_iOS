//
//  EGEventScheduleView.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/1/23.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class EGScheduleModel;

typedef void(^EventReviewBtnBlock)(EGScheduleModel *model,NSInteger type);

@interface EGEventScheduleView : UIView

//@property (nonatomic,strong) NSArray *array;

@property (nonatomic,copy) EventReviewBtnBlock reviewBlock;

@property (nonatomic,strong) EGScheduleModel *model;

-(void)setDataForModel:(EGScheduleModel *)model;

@end

NS_ASSUME_NONNULL_END
