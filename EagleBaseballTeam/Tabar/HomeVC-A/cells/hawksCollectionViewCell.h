//
//  hawksCollectionViewCell.h
//  QuickstartApp
//
//  Created by rick on 1/22/25.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@interface hawksCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIView *baseView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *titleLB;
@property (nonatomic,strong) UILabel *dateLB;
@end

NS_ASSUME_NONNULL_END
