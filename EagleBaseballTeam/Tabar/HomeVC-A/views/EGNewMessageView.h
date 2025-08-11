//
//  EGNewMessageView.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/6.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NewMessageViewDelegate <NSObject>

@optional
/**
 * goodsID == more 查看更多
 */
-(void)clickNewMessageForItem:(NSString *)newId;

@end

@interface EGNewMessageView : UIView

@property (nonatomic,weak) id<NewMessageViewDelegate> delegate;

-(void)getDataForTsghawks;

@end

NS_ASSUME_NONNULL_END
