//
//  EGRegisterTBViewCell.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/13.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TextFieldStringBlock)(NSString *textString,BOOL isBtn);

@interface EGRegisterTBViewCell : UITableViewCell


+(instancetype)cellWithUITableView:(UITableView *)tableView;

@property (nonatomic,strong) NSDictionary *dataDict;

@property (nonatomic,copy) TextFieldStringBlock textStringBlock;

@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong) UIButton *policyBtn;

-(void)setRightButtonStatue;
@property (nonatomic,strong) UILabel *subtitleLabel;

- (void)setSubtitleLabelString:(NSString *)subtitleLabel;
@property (nonatomic,strong) UITextField *contentTextField;

@end

NS_ASSUME_NONNULL_END
