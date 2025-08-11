//
//  EGMemberInfoTbViewCell.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/17.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TextFieldStringBlock)(NSString *textString,BOOL isBtn);

@interface EGMemberInfoTbViewCell : UITableViewCell

+(instancetype)cellWithUITableView:(UITableView *)tableView;

@property (nonatomic,strong) NSDictionary *dataDict;

@property (nonatomic,copy) TextFieldStringBlock textStringBlock;

@property (nonatomic,strong) UITextField *contentTextField;

@end



@interface MemberInfoTextFieldTbViewCell : UITableViewCell

+(instancetype)cellWithUITableView:(UITableView *)tableView;

@property (nonatomic,copy) TextFieldStringBlock textFSingleBlock;

@property (nonatomic,strong) UITextField *contentTextField;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong) UILabel *alterLb;

- (void)setTextFieldTextAndPlaceholder:(NSDictionary *)dataDict;


@end


@interface MemberInfoTwoBtnTbViewCell : UITableViewCell

+(instancetype)cellWithUITableView:(UITableView *)tableView;

@property (nonatomic,strong) UILabel *titleLb;

- (void)setTitleAndButtonText:(NSDictionary *)dataDict;

@property (nonatomic,copy) TextFieldStringBlock buttonSelectBlock;
@end

NS_ASSUME_NONNULL_END
