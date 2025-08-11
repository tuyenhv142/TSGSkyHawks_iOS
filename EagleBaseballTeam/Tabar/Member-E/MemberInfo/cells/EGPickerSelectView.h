//
//  EGPickerSelectView.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/18.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PickerViewComponent) {
    PickerViewComponent_One = 1,
    PickerViewComponent_Two = 2
};

typedef void (^MyBasicBlock)(id result,NSInteger index,NSArray *store_address);



@interface EGPickerSelectView : UIView

-(instancetype)initWithChooseTitleNSArray:(NSArray *)array;
/**
 * 列数
 */
@property (nonatomic,assign) PickerViewComponent componentNumber;
/**
 * 参数 数组
 */
@property (retain, nonatomic) NSArray *arrPickerData;

@property (retain, nonatomic) UIPickerView *pickerView;
/**
 * block
 */
@property (nonatomic, copy) MyBasicBlock selectBlock;
/**
 * 显示view
 */
- (void)popPickerView;

-(void)setPickerDefaultValue:(NSString * _Nonnull )default1 Value:(NSString * _Nullable )default2;

@end

NS_ASSUME_NONNULL_END
