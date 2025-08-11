//
//  OAPickerView.h
//  NewsoftOA24
//
//  Created by dragon_zheng on 2024/6/27.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^SeleteBackResultBlock)(id _Nullable result,NSInteger index);//

NS_ASSUME_NONNULL_BEGIN

@interface EGPickerView : UIView


/**
 * 显示view
 */
- (void)popPickerView;

/**
 * block
 */
@property (nonatomic, copy) SeleteBackResultBlock seleteBackResultBlock;

-(EGPickerView *)initWithChooseTypeNSArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
