//
//  EGExchangeRecordTBViewCell.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/4/27.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGExchangeRecordTBViewCell : UITableViewCell

+(instancetype)cellWithUITableView:(UITableView *)tableView;


@property (nonatomic, copy) void (^openCodeBlock)(NSString *codeStr,NSString *goodsid);
@property (nonatomic, strong)NSDictionary *info;
@property (nonatomic, assign)NSString* qrcode_id;
-(void)updateUI;
@end



@interface UsedAlreadyTBViewCell : UITableViewCell

+(instancetype)cellWithUITableView:(UITableView *)tableView;

@property (nonatomic, strong)NSDictionary *info;

-(void)updateUI;
@end


NS_ASSUME_NONNULL_END
