//
//  EGPointsHeaderView.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/8.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol PointsHeaderViewDelegate <NSObject>

@optional
-(void)pointsHeaderViewButtonTag:(NSInteger )tag;

@end

@interface EGPointsHeaderView : UIView
@property (nonatomic,strong) UIButton *pointsBtn;
@property (nonatomic,weak) id<PointsHeaderViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
