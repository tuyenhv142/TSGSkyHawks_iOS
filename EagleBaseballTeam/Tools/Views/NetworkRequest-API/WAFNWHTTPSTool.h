//
//  WAFNWHTTPSTool.h
//  WorkAttendanceManager
//
//  Created by elvin on 2024/9/29.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WAFNWHTTPSTool : NSObject

@property (nonatomic,assign) BOOL isNeedJson;

+ (instancetype)sharedManager;
/**
 *  普通 POST
 *
 *  @param url     url description
 *  @param parameters  params description
 *  @param headers  headers description
 *  @param success success description
 *  @param failure failure description
 */
- (void)postWithURL:(NSString *)url
         parameters:(NSDictionary *)parameters
            headers:(NSDictionary *)headers
            success:(void (^)(NSDictionary *response))success
            failure:(void (^)(NSError *error))failure;
/**
 *  普通 GET
 *
 *  @param url     url description
 *  @param parameters  params description
 *  @param headers  headers description
 *  @param success success description
 *  @param failure failure description
 */
- (void)getWithURL:(NSString *)url
        parameters:(NSDictionary *)parameters
           headers:(NSDictionary *)headers
           success:(void (^)(NSDictionary *response))success
           failure:(void (^)(NSError *error))failure;

/**
 *  普通 PUT
 *
 *  @param url     url description
 *  @param parameters  params description
 *  @param headers  headers description
 *  @param success success description
 *  @param failure failure description
 */
- (void)putWithURL:(NSString *)url
        parameters:(NSDictionary *)parameters
           headers:(NSDictionary *)headers
           success:(void (^)(NSDictionary *response))success
           failure:(void (^)(NSError *error))failure ;
@end

NS_ASSUME_NONNULL_END
