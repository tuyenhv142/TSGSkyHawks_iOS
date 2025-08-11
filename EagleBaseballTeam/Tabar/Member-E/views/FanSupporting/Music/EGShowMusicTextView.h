//
//  OASearchFilterView.h
//  NewsoftOA24
//
//  Created by rick on 7/31/24.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^ OASearchFilterBlock)(NSDictionary * _Nullable params, NSArray  * _Nullable array);


@interface EGShowMusicTextView : UIView
@property (nonatomic, copy) OASearchFilterBlock SearchFilterReslutBlock;
/**
 * 显示view
 */
- (void)popPickerView;
- (void)setMusicText:(NSDictionary*)music_text;
@end

NS_ASSUME_NONNULL_END
