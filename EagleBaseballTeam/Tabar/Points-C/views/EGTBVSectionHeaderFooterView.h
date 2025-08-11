//
//  EGTBVSectionHeaderFooterView.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/8.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//typedef void (^MoreButtonClickBlock)(NSIndexPath *indexPath);
typedef void (^MoreButtonClickBlock)(NSInteger section);

@interface EGTBVSectionHeaderFooterView : UITableViewHeaderFooterView
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, copy) MoreButtonClickBlock moreBtnClickBlock;
-(void)setTitleInfo:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
