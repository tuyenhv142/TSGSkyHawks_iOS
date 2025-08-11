//
//  EGMemberInfoData.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/17.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGMemberInfoData : NSObject

@property (nonatomic,strong) NSMutableArray *dataMArray;

@property (nonatomic,strong) NSDictionary *dataDictionary;

@property (nonatomic,strong) NSMutableDictionary *paramesDictionary;
@property (nonatomic,strong) NSMutableDictionary *extraDataDict;

@property (nonatomic,strong) NSArray *headerArray;

@property (nonatomic,strong) NSMutableArray *addressMArray;

@property (nonatomic,strong) NSMutableArray *storeMArray;

@property (nonatomic,strong) NSMutableArray *playerMArray;

@property (nonatomic,strong) NSMutableArray *ticketArray;


-(void)cellTextFieldChange:(NSString *)string indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
