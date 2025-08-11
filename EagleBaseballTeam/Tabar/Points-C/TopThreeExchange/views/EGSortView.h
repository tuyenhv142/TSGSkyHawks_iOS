//
//  OASearchFilterView.h
//  NewsoftOA24
//
//  Created by rick on 7/31/24.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^ EagleBlock)(NSInteger lan);


@interface EGSortView : UIView
@property (nonatomic, copy) EagleBlock gBlock;
/**
 * 显示view
 */
- (void)popPickerView;
- (void)setinfo:(NSInteger)lan;

@end

NS_ASSUME_NONNULL_END
