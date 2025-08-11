//
//  ELBannerView.h
//  BurgerKing
//
//  Created by elvin on 2025/4/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ELBannerView : UIView

//轮播图 数组
@property (nonatomic,strong) NSArray <NSString *>*images;
@property (nonatomic,assign) NSInteger current_index;
@property (nonatomic,assign) NSInteger scroller_width;

- (void)setImages:(NSArray *)images showTitle:(BOOL)show width:(NSInteger)width border:(BOOL)showborder;
- (NSInteger)getCurrentImageIndex;
- (void)setCurrentImage:(NSInteger)currentIndex;
@end

NS_ASSUME_NONNULL_END
