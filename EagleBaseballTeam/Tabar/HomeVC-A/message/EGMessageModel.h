//
//  EGMessageModel.h
//  EagleBaseballTeam
//
//  Created by Elvin on 2025/6/23.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGMessageModel : NSObject

@property (nonatomic, copy) NSString * categories;
@property (nonatomic, copy) NSString * content;

@property (nonatomic, copy) NSString * CreatedAt;
@property (nonatomic, copy) NSString * deletedAt;
@property (nonatomic, copy) NSString * deliveredAt;
@property (nonatomic, copy) NSString * ID;

@property (nonatomic, copy) NSString * coverImage;
@property (nonatomic, strong) NSArray * images;//array

@property (nonatomic, strong) NSArray * payload;//array
@property (nonatomic, copy) NSString * readAt;
@property (nonatomic, copy) NSString * scheduledMessageId;
@property (nonatomic, assign) NSInteger  status;
@property (nonatomic, copy) NSString * targetUrl;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * UpdatedAt;
@property (nonatomic, copy) NSString * type;
@end

//{
//CreatedAt = "2025-06-19T15:24:15.449439+08:00";
//UpdatedAt = "2025-06-19T15:57:22.558215+08:00";
//categories = system;
//content = "\U60a8\U7684 150 \U9ede\U5373\U5c07\U65bc 2025/06/30 \U5230\U671f\Uff0c\U5feb\U4f86\U514c\U63db\U5c08\U5c6c\U597d\U79ae";
//coverImage = "http://wecncjhnj12345t_001.png";
//id = "a7971297-f8be-47f6-9adc-6949fbf49756";
//images =             (
//  http://wecncjhnj12345t_000.png,http://wecncjhnj12345t_003.png
//);
//payload =             (
//);
//readAt = "2025-06-19T15:57:22.557938+08:00";
//status = 1;
//targetUrl = "";
//title = "\U9ede\U6578\U5373\U5c07\U5230\U671f";
//type = notification;
//},

NS_ASSUME_NONNULL_END
