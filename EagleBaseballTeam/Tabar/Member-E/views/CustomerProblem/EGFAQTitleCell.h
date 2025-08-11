//
//  EGMemberCardCell.h
//  EagleBaseballTeam
//
//  Created by rick on 1/24/25.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^ EGFAQblock)(BOOL type,NSDictionary* dic);

@interface EGFAQTitleCell : UITableViewCell

+(instancetype)cellWithUITableView:(UITableView *)tableView;
- (void)setupWithInfo:(NSDictionary *)info sectioninfo:(NSDictionary*)sectioninfodic;
-(void)setbtstate:(BOOL)state;
@property (nonatomic, retain)NSDictionary *sendDic;
@property (nonatomic, copy) EGFAQblock FAQInfoBlock;
@end

NS_ASSUME_NONNULL_END
