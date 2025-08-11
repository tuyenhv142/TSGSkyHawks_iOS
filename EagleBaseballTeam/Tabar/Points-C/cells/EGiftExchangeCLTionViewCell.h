//
//  EGiftExchangeCLTionViewCell.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/10.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGiftExchangeCLTionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UIButton *statueBtn;

-(void)setModeInfo:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
