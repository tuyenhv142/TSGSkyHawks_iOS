//
//  EGUserOauthModel.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/13.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class NewsoftExtraData;

@interface EGUserOauthModel : NSObject

@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *refreshToken;
@property (nonatomic,copy) NSString *accessToken;
@property (nonatomic,copy) NSString *tokenType;
@property (nonatomic,copy) NSString *userType;

@end

@interface EGRelayTokenModel : NSObject
@property (nonatomic,copy) NSString *refresh_token;
@property (nonatomic,copy) NSString *refresh_token_expired;

@property (nonatomic,copy) NSString *token_expired;
@property (nonatomic,copy) NSString *token;
@end


@interface UserInfomationModel : NSObject

@property (nonatomic,copy) NSString *accessToken;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *refreshToken;
@property (nonatomic,copy) NSString *tokenType;
@property (nonatomic,copy) NSString *userType;

@end


@interface MemberInfomationModel : NSObject

@property (nonatomic,copy) NSString *Name;
@property (nonatomic,copy) NSString *Phone;
@property (nonatomic,copy) NSString *Email;
@property (nonatomic,copy) NSString *Birthday;
@property (nonatomic,copy) NSString *Gender;
@property (nonatomic,strong) NewsoftExtraData *NewsoftExtraData;

@end

@interface NewsoftExtraData : NSObject
@property (nonatomic, copy) NSString *email;
@end


NS_ASSUME_NONNULL_END
