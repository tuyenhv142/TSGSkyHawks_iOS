#import <Foundation/Foundation.h>

@interface EGCredentialManager : NSObject

+ (instancetype)sharedManager;
//- (void)saveCredentials;
- (void)saveToken:(NSString *)token;

- (NSString *)getUsername;
- (NSString *)getYouTubeAPIkey;
- (NSString *)getPassword;

- (NSString *)getZjApiIdKey;
- (NSString *)getZjApiSecretKey;
- (NSString *)getToken;
- (NSString *)getCRMApiKey;

- (void)clearCredentials;

@end
