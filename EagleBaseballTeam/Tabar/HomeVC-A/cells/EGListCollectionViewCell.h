//
//  EGListCollectionViewCell.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/1/23.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface EGListCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,copy) NSString *teamCode;
@end

NS_ASSUME_NONNULL_END
