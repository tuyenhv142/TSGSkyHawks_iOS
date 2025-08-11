//
//  OABtnImgCollectionViewCell.h
//  NewsoftOA24
//
//  Created by dragon_zheng on 2024/5/9.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashedBorderLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface EGClassDateCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) DashedBorderLabel *titleLB;//日子
@property (nonatomic,strong) UILabel *titleLA;//星期
@property (nonatomic,strong) UIView *baseView;

-(void) setInfo:(NSString *)info iscurrentdate:(BOOL)is_current;
@end

NS_ASSUME_NONNULL_END
