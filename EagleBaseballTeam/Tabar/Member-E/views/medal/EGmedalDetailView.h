//
//  OASearchFilterView.h
//  NewsoftOA24
//
//  Created by rick on 7/31/24.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define autoTextHeight

NS_ASSUME_NONNULL_BEGIN
typedef void (^ EagleBlock)(NSMutableDictionary*);


@interface EGmedalDetailView : UIView
@property (nonatomic, assign) NSDictionary* dicinfo;
@property (nonatomic, copy) EagleBlock gBlock;
@property (nonatomic,assign) NSInteger TextViewHeight;
 
- (instancetype)initWithObject:(NSInteger)object;


/**
 * 显示view
 */
- (void)popPickerView;
-(void)updateUI;
@end

NS_ASSUME_NONNULL_END
