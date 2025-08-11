//
//  EGBarQRCodeView.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/4/27.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^SuceessBlock)(void);
@interface EGBarQRCodeView : UIView

-(void)showBarQRCodeView:(NSString*)g_id;
-(void)setgoodsID:(NSString*)goodsid;


@property (nonatomic,copy) SuceessBlock closeBlock;
@end

NS_ASSUME_NONNULL_END
