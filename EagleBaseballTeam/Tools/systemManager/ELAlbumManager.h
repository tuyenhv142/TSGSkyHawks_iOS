//
//  ELAlbumManager.h
//  EagleBaseballTeam
//
//  Created by Elvin on 2025/7/2.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface ELAlbumManager : NSObject

// 检查并创建相簿
+ (void)createAppAlbumIfNeededWithCompletion:(void(^)(PHAssetCollection *album, BOOL success))completion;
// 保存图片到指定相簿
+ (void)saveImage:(UIImage *)image toAlbum:(PHAssetCollection *)album completion:(void(^)(BOOL success))completion;
// 保存多张图片到指定相簿
+ (void)saveImages:(NSArray<UIImage *> *)images toAlbum:(PHAssetCollection *)album;

// 获取相簿中的所有图片
+ (NSArray<PHAsset *> *)fetchAllAssetsInAppAlbum;

@end

NS_ASSUME_NONNULL_END
