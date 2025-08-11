//
//  EGRegisterData.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/13.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGRegisterData : NSObject

@property (nonatomic,strong) NSMutableArray *dataMArray;

@property (nonatomic,strong) NSMutableDictionary *paramsDict;


-(void)textFieldChangeString:(NSString *)string index:(NSInteger )row;

- (BOOL )determineIfThereIsNil;
@end

NS_ASSUME_NONNULL_END
