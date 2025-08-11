//
//  EGHotGoodsView.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/5.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HotGoodsViewDelegate <NSObject>

@optional
/**
 * goodsID == more 查看更多
 */
-(void)clickHotGoodsForItem:(NSString *)goodsID;

@end

@interface EGHotGoodsView : UIView

@property (nonatomic,weak) id<HotGoodsViewDelegate> delegate;

-(void)getHotGoodsData;
@end

NS_ASSUME_NONNULL_END
