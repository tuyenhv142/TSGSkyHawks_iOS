//
//  ELAlbumManager.m
//  EagleBaseballTeam
//
//  Created by Elvin on 2025/7/2.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "ELAlbumManager.h"
#import <Photos/Photos.h>

@implementation ELAlbumManager

// 检查并创建相簿
+ (void)createAppAlbumIfNeededWithCompletion:(void(^)(PHAssetCollection *album, BOOL success))completion {
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"] ?: [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleNameKey];
    
    PHFetchResult *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                                        subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                        options:nil];
    
    __block PHAssetCollection *appAlbum = nil;
    [collections enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL *stop) {
        if ([collection.localizedTitle isEqualToString:appName]) {
            appAlbum = collection;
            *stop = YES;
        }
    }];
    
    if (appAlbum) {
        if (completion) completion(appAlbum, YES);
        return;
    }
    
    __block PHObjectPlaceholder *placeholder;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetCollectionChangeRequest *createRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:appName];
        placeholder = createRequest.placeholderForCreatedAssetCollection;
    } completionHandler:^(BOOL success, NSError *error) {
        if (success) {
            PHFetchResult *collection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[placeholder.localIdentifier] options:nil];
            appAlbum = collection.firstObject;
        }
        if (completion) completion(appAlbum, success);
    }];
}

// 保存图片到指定相簿
+ (void)saveImage:(UIImage *)image toAlbum:(PHAssetCollection *)album completion:(void(^)(BOOL success))completion {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        PHAssetCollectionChangeRequest *albumRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:album];
        PHObjectPlaceholder *placeholder = assetRequest.placeholderForCreatedAsset;
        [albumRequest addAssets:@[placeholder]];
    } completionHandler:^(BOOL success, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(success);
        });
    }];
}
// 保存多张图片到指定相簿
+ (void)saveImages:(NSArray<UIImage *> *)images toAlbum:(PHAssetCollection *)album {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetCollectionChangeRequest *albumRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:album];
        NSMutableArray *placeholders = [NSMutableArray array];
        
        for (UIImage *image in images) {
            PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            [placeholders addObject:assetRequest.placeholderForCreatedAsset];
        }
        
        [albumRequest addAssets:placeholders];
    } completionHandler:nil];
}

// 获取App相簿（返回nil表示不存在）
+ (PHAssetCollection *)fetchAppAlbum {
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"] ?:
                       [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleNameKey];
    
    PHFetchResult *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                                        subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                        options:nil];
    
    __block PHAssetCollection *appAlbum = nil;
    [collections enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL *stop) {
        if ([collection.localizedTitle isEqualToString:appName]) {
            appAlbum = collection;
            *stop = YES;
        }
    }];
    
    return appAlbum;
}
// 获取相簿中的所有图片
+ (NSArray<PHAsset *> *)fetchAllAssetsInAppAlbum {
    PHAssetCollection *appAlbum = [self fetchAppAlbum];
    if (!appAlbum) return @[];
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    
    PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:appAlbum options:options];
    
    NSMutableArray *result = [NSMutableArray array];
    [assets enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
        [result addObject:asset];
    }];
    
    return [result copy];
}

// 获取图片的元数据（如创建时间、位置等）
+ (void)loadAssetMetadata:(PHAsset *)asset completion:(void(^)(NSDictionary *metadata))completion {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.version = PHImageRequestOptionsVersionCurrent;
    
    [[PHImageManager defaultManager] requestImageDataAndOrientationForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, CGImagePropertyOrientation orientation, NSDictionary * _Nullable info) {
        if (completion) completion(info);
    }];
//    [[PHImageManager defaultManager] requestImageDataForAsset:asset
//                                                    options:options
//                                              resultHandler:^(NSData *imageData,
//                                                            NSString *dataUTI,
//                                                            UIImageOrientation orientation,
//                                                            NSDictionary *info) {
//        // 从info字典获取元数据
//        if (completion) completion(info);
//    }];
}
@end
