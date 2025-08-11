//
//  ELTmpFileManager.h
//  EagleBaseballTeam
//
//  Created by Elvin on 2025/6/20.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ELTmpFileManager : NSObject

+(instancetype)shareTmpFile;


/**
 * @brief 生成一个存放临时文件的路径。
 * @return 一个路径 如果出错则返回 nil。
 */
- (NSString *)generateTmpPathWithName:(NSString *)fileName;

/**
 * @brief 获取临时目录下所有项目（文件和文件夹）的完整路径列表。
 * @return 一个包含所有项目完整路径的 NSArray，如果出错则返回 nil。
 */
- (NSArray<NSString *> *)getAllPathsInTemporaryDirectory;
/**
 * @brief 从应用的临时目录中删除指定的文件。
 *
 * @param fileName 要删除的文件名 (例如 "my_video.mp4" 或 "temp_data.json")。
 * @return 如果文件成功删除或文件原本就不存在，则返回 YES；如果删除失败，则返回 NO。
 */
- (BOOL)deleteTemporaryFileWithName:(NSString *)fileName;
@end

NS_ASSUME_NONNULL_END
