//
//  MSSegmentedControl.h
//  EShareMall
//
//  Created by SongMin on 2019/11/20.
//  Copyright © 2019 lovsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MSSegmentedControlDelegate <NSObject>
/**
 *  选中的segment的下标
 *
 *  @param index 0 是第一个 1 是第二个
 */
- (void)didSelectSegmentWithIndex:(NSInteger)index ControlTAG:(NSInteger)controlid;

@end


@interface MSSegmentedControl : UIView

@property (nonatomic, weak) id<MSSegmentedControlDelegate>delegate;


/**
 *
 *  @param titleArs                     标题数组
 *  @param radius                       整体圆角半径
 *  @param btnRadius                    单个标签圆角半径
 *  @param backgroundColor              整体背景颜色
 *  @param borderColor                  整体描边颜色
 *  @param borderWidth                  整体描边宽度
 *  @param normalTitleColor             未选中的标签文字颜色
 *  @param selectedTitleColor           选中的标签文字颜色
 *  @param normalBtnBackgroundColor     未选中的标签背景颜色
 *  @param selectedBtnBackgroundColor   选中的标签背景颜色
 *  @param tag      设置不同的segment 控件的tag
 *  @param bt_H    bt的高度
 *  @param bt_W   bt的宽度
 *  @param bt_inter bt的间距
 *
 */

+(instancetype)creatSegmentedControlWithTitle:(NSArray *)titleArs withRadius:(NSInteger)radius withBtnRadius:(NSInteger)btnRadius withBackgroundColor:(UIColor *)backgroundColor withBorderColor:(UIColor *)borderColor withBorderWidth:(CGFloat)borderWidth withNormalTitleColor:(UIColor *)normalTitleColor withSelectedTitleColor:(UIColor *)selectedTitleColor withNormalBtnBackgroundColor:(UIColor *)normalBtnBackgroundColor withSelectedBtnBackgroundColor:(UIColor *)selectedBtnBackgroundColor controlid:(NSInteger)tag Top:(NSInteger)xtop btheight:(NSInteger)bt_H btwidth:(NSInteger)bt_W btInterval:(NSInteger)bt_inter;

/**
 *  有些情况的特殊需要 比如 初始化的时候默认 第二个是选中状态
 */
- (void)updateSelectedWithIndex:(NSInteger)index;


@end

NS_ASSUME_NONNULL_END
