//
//  OASearchFilterView.h
//  NewsoftOA24
//
//  Created by dragon on 7/31/24.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoroundColorView.h"
NS_ASSUME_NONNULL_BEGIN
typedef void (^ EagleBlock)(NSMutableDictionary*);


@interface GoroundSettingView : UIView
@property (nonatomic, retain)NSMutableDictionary *settingDic;
@property (nonatomic, copy) EagleBlock gBlock;
@property (nonatomic, strong) NSArray *All_playerArray;
@property (nonatomic, strong) NSMutableDictionary *All_ArrayDic;//带状态的Dictionary
@property (nonatomic, strong) NSMutableArray *All_Array;//带状态的Array
/**
 * 显示view
 */
- (void)popPickerView:(NSDictionary*)info;
@end

NS_ASSUME_NONNULL_END
