//
//  OASearchFilterView.h
//  NewsoftOA24
//
//  Created by rick on 7/31/24.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^ EagleBlock)(NSMutableDictionary*);


@interface EGpolicyView : UIView
@property (nonatomic, retain)NSMutableDictionary *settingDic;
@property (nonatomic, copy) EagleBlock gBlock;
@property (nonatomic, retain)UILabel *title;

-(void)setInfo:(NSInteger)type;
/**
 * 显示view
 */
- (void)popPickerView;
@end

NS_ASSUME_NONNULL_END
