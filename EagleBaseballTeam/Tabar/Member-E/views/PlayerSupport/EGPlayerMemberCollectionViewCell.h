//
//  OABtnImgCollectionViewCell.h
//  NewsoftOA24
//
//  Created by dragon_zheng on 2024/5/9.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGPlayerMemberCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *titleLB;
@property (nonatomic,strong) UIView *baseView;
@property (nonatomic,strong) UILabel *titleLA;

-(void) setInfo:(NSDictionary *)info;
@end

NS_ASSUME_NONNULL_END
