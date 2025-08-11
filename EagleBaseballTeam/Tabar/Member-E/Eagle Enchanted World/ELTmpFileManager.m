//
//  ELTmpFileManager.m
//  EagleBaseballTeam
//
//  Created by Elvin on 2025/6/20.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "ELTmpFileManager.h"

@implementation ELTmpFileManager

+ (instancetype)shareTmpFile
{
    static ELTmpFileManager *tmpFile;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tmpFile = [[ELTmpFileManager alloc] init];
    });
    return tmpFile;
}

/**
 * @brief 生成一个存放临时文件的路径。
 * @return 一个路径 如果出错则返回 nil。
 */
- (NSString *)generateTmpPathWithName:(NSString *)fileName
{
    // 1. 设置输出文件路径
    NSString *outputPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"movie.mov"];
    NSURL *outputURL = [NSURL fileURLWithPath:outputPath];
    
    // 删除已存在的文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:outputPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:outputPath error:nil];
    }
    return outputPath;
}
/**
 * @brief 获取临时目录下所有项目（文件和文件夹）的完整路径列表。
 * @return 一个包含所有项目完整路径的 NSArray，如果出错则返回 nil。
 */
- (NSArray<NSString *> *)getAllPathsInTemporaryDirectory {
    // 1. 获取临时目录路径
    NSString *tempDirectoryPath = NSTemporaryDirectory();
    
    // 2. 获取文件管理器实例
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 3. 获取目录下所有项目的文件名（不含路径）
    NSError *error = nil;
    NSArray<NSString *> *fileNames = [fileManager contentsOfDirectoryAtPath:tempDirectoryPath error:&error];
    
    if (fileNames == nil) {
        // 如果出错，打印错误信息并返回 nil
        NSLog(@"获取临时目录内容失败: %@", [error localizedDescription]);
        return nil;
    }
    
    // 4. 遍历文件名数组，拼接成完整路径
    NSMutableArray<NSString *> *fullPaths = [NSMutableArray array];
    for (NSString *fileName in fileNames) {
        NSString *fullPath = [tempDirectoryPath stringByAppendingPathComponent:fileName];
        [fullPaths addObject:fullPath];
    }
    // 返回一个不可变副本，这是个好习惯
    return [fullPaths copy];
}

/**
 * @brief 从应用的临时目录中删除指定的文件。
 *
 * @param fileName 要删除的文件名 (例如 "my_video.mp4" 或 "temp_data.json")。
 * @return 如果文件成功删除或文件原本就不存在，则返回 YES；如果删除失败，则返回 NO。
 */
- (BOOL)deleteTemporaryFileWithName:(NSString *)fileName {
    // 1. 获取临时目录的路径
    NSString *tempDirectoryPath = NSTemporaryDirectory();
    
    // 2. 构造文件的完整路径
    // 使用 stringByAppendingPathComponent: 是最安全的方式，它会自动处理路径分隔符 "/"
    NSString *filePath = [tempDirectoryPath stringByAppendingPathComponent:fileName];
    
    // 3. 获取文件管理器实例
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 4. (推荐) 首先检查文件是否存在
    if ([fileManager fileExistsAtPath:filePath]) {
        // 5. 文件存在，执行删除操作
        NSError *error = nil;
        BOOL success = [fileManager removeItemAtPath:filePath error:&error];
        
        if (success) {
            NSLog(@"文件已成功删除: %@", filePath);
            return YES;
        } else {
            // 如果删除失败，打印错误信息
            NSLog(@"删除文件失败: %@, 原因: %@", filePath, [error localizedDescription]);
            return NO;
        }
    } else {
        // 文件如果不存在，我们认为操作也是“成功”的，因为目的（文件不在）已经达到
        NSLog(@"文件不存在，无需删除: %@", filePath);
        return YES;
    }
}

@end
