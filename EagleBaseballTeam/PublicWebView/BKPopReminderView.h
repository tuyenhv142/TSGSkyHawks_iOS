//
//  BKPopReminderView.h
//  BurgerKing
//
//  Created by elvin on 2025/5/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CloseButtonBlock)(NSInteger btnTag);

@interface BKPopReminderView : UIView

/**
 * 传入 显示的 字串
 */
- (instancetype)initWithTitle:(NSString *)message buttons:(NSArray *)array;

/**
 * 显示 view
 */
-(void)showPopView;

@property (nonatomic,copy) CloseButtonBlock closeBlock;

@end

NS_ASSUME_NONNULL_END
