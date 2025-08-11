//
//  EGEagleFansBigImageViewController.h
//  EagleBaseballTeam
//
//  Created by Elvin on 2025/6/19.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGEagleFansBigImageViewController : UIViewController

@property (nonatomic,assign) NSInteger isFans;
@property (nonatomic,strong) NSIndexPath *selectIndexPath;

@property (nonatomic, strong) NSArray<NSString *> *publics;
@property (nonatomic, strong) NSArray<UIImage *> *privates;
@end

NS_ASSUME_NONNULL_END
