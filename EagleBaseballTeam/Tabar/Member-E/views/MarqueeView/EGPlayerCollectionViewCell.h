//
//  OABtnImgCollectionViewCell.h
//  NewsoftOA24
//
//  Created by dragon_zheng on 2024/5/9.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGPlayerCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UILabel *titleLB;
@property (nonatomic,strong) UIView *baseView;

-(void) setInfo:(NSDictionary *)info;
@end

NS_ASSUME_NONNULL_END
