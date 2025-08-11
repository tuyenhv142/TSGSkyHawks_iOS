//
//  EGTopButtonsView.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/4/18.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ClickTopViewButtonBlock)(NSInteger index);

@interface EGTopButtonsView : UIView

@property (nonatomic, strong) UIView *redView_acivity;
@property (nonatomic, strong) UIView *redView_system;

-(void)setupUIForArray:(NSArray *)array;

-(void)setStatusLableForIndex:(NSInteger)index;

@property (nonatomic,copy) ClickTopViewButtonBlock clickBtnBlock;

-(void)setRedViewStatueActivity:(BOOL )activity systemView:(BOOL )system;
@end

NS_ASSUME_NONNULL_END
