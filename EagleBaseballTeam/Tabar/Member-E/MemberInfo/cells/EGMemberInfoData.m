//
//  EGMemberInfoData.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/17.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGMemberInfoData.h"

#import "EGLogInTools.h"

@implementation EGMemberInfoData


- (NSMutableArray *)dataMArray
{
    if (!_dataMArray) {
        NSArray *array = @[@{@"title":@"姓名",@"placeholder":@"請輸入姓名",@"enabled_TextF":@"0",@"value":@""},
                           @{@"title":@"手機號碼",@"placeholder":@"請輸入手機號碼",@"enabled_TextF":@"0",@"value":@""},
                           @{@"title":@"E-mail",@"placeholder":@"請輸入常用 E-mail",@"enabled_TextF":@"0",@"value":@""},
                           @{@"title":@"身分證字號",@"placeholder":@"請輸入身分證字號",@"enabled_TextF":@"1",@"value":@""},
                           @{@"title":@"生日",@"placeholder":@"年/月/日",@"enabled_TextF":@"1",@"value":@""}];
        _dataMArray = [NSMutableArray arrayWithArray:array];
    }
    return _dataMArray;
}
- (NSMutableArray *)addressMArray
{
    if (!_addressMArray) {
        NSArray *array = @[@{@"placeholder":@"縣市/區域",@"value":@"",@"BtnHidden":@(0)},
                           @{@"placeholder":@"地址",  @"value":@"",@"BtnHidden":@(1)}];
        _addressMArray = [NSMutableArray arrayWithArray:array];
    }
    return _addressMArray;
}
- (NSMutableArray *)storeMArray
{
    if (!_storeMArray) {
        NSArray *array2 = @[@{@"placeholder":@"城市/區域",@"value":@"",@"BtnHidden":@(0)},
                           @{@"placeholder":@"先選擇區域",  @"value":@"",@"BtnHidden":@(0)}];
        _storeMArray = [NSMutableArray arrayWithArray:array2];
    }
    return _storeMArray;
}
- (NSMutableArray *)playerMArray{
    if (!_playerMArray) {
        NSArray *array3 = @[@{@"placeholder":@"第一順位",@"value":@"",@"BtnHidden":@(1)},
                            @{@"placeholder":@"第二順位",  @"value":@"",@"BtnHidden":@(1)},
                            @{@"placeholder":@"第三順位",@"value":@"",@"BtnHidden":@(1)}];
        _playerMArray = [NSMutableArray arrayWithArray:array3];
    }
    return _playerMArray;
}
- (NSMutableArray *)ticketArray
{
    if (!_ticketArray) {
        NSArray *arraytic = @[@{@"title":@"發票開立",@"array":@[@{@"titleType":@"手機條碼載具",@"state":@(0)},
                                                            @{@"titleType":@"寄送到 E-mail (同上)",@"state":@(0)}]},
                              @{@"placeholder":@"輸入手機載具",@"value":@"",@"BtnHidden":@(1)},
                              @{@"title":@"性別",@"array":@[@{@"titleType":@" 男",@"state":@(0)},
                                                          @{@"titleType":@" 女",@"state":@(0)},
                                                          @{@"titleType":@" 保密",@"state":@(0)}]}];
        _ticketArray = [NSMutableArray arrayWithArray:arraytic];
    }
    return _ticketArray;
}

- (void)setDataDictionary:(NSDictionary *)dataDictionary
{
    [self.paramesDictionary addEntriesFromDictionary:dataDictionary];
    
    NSDictionary *ExtraData = [dataDictionary objectOrNilForKey:@"ExtraData"];
    
    NSString *isEdit_Identity;
    NSString *idNumber = [dataDictionary objectIsNilReturnSteForKey:@"Identity"];
    if (idNumber) {
        if ([EGLogInTools isValidateTaiwanIDString:idNumber]) {//you shen fen id
            [self.paramesDictionary removeObjectForKey:@"Identity"];
            isEdit_Identity = @"0";//合法
        }else{
            isEdit_Identity = @"0";//不合法
        }
    }else{
        idNumber = @"";
        isEdit_Identity = @"1";
    }
    
    NSString *isEdit_brithday;
    NSString *Birthday = [dataDictionary objectIsNilReturnSteForKey:@"Birthday"];
    Birthday = [Birthday substringToIndex:10];
    if ([Birthday containsString:@"2025-03-29"]) {//is edit
        isEdit_brithday = @"1";
    }else{
        [self.paramesDictionary removeObjectForKey:@"Birthday"];
        isEdit_brithday = @"0";
    }
    Birthday = [Birthday stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    
    NSArray *array = @[@{@"title":@"姓名",@"placeholder":@"請輸入姓名",@"enabled_TextF":@"0",@"value":[dataDictionary objectOrNilForKey:@"Name"]},
                       @{@"title":@"手機號碼",@"placeholder":@"請輸入手機號碼",@"enabled_TextF":@"0",@"value":[dataDictionary objectOrNilForKey:@"Phone"]},
                       @{@"title":@"E-mail",@"placeholder":@"請輸入常用 E-mail",@"enabled_TextF":@"0",@"value":[dataDictionary objectOrNilForKey:@"Email"]},
                       @{@"title":@"身分證字號",@"placeholder":@"請輸入身分證字號",@"enabled_TextF":isEdit_Identity,@"value":idNumber},
                       @{@"title":@"生日",@"placeholder":@"年/月/日",@"enabled_TextF":isEdit_brithday,@"value":Birthday}];
//    _dataMArray = [NSMutableArray arrayWithArray:array];
    [self.dataMArray removeAllObjects];
    [self.dataMArray addObjectsFromArray:array];
    
    
//    delivery_city  delivery_district delivery_address
    NSString *delivery_city = [ExtraData objectIsNilReturnSteForKey:@"delivery_city"];
    NSString *delivery_district = [ExtraData objectIsNilReturnSteForKey:@"delivery_district"];
    NSString *delivery_address = [ExtraData objectIsNilReturnSteForKey:@"delivery_address"];
    NSArray *array1 = @[@{@"placeholder":@"縣市/區域",@"value":[delivery_city stringByAppendingString:delivery_district],@"BtnHidden":@(0)},
                       @{@"placeholder":@"地址",  @"value":delivery_address,@"BtnHidden":@(1)}];
//    _addressMArray = [NSMutableArray arrayWithArray:array1];
    [self.addressMArray removeAllObjects];
    [self.addressMArray addObjectsFromArray:array1];
    
    
    
//   store_city store_county store_address
    NSString *store_city = [ExtraData objectIsNilReturnSteForKey:@"store_city"];
    NSString *store_county = [ExtraData objectIsNilReturnSteForKey:@"store_county"];
    NSString *store_address = [ExtraData objectIsNilReturnSteForKey:@"store_address"];
    NSArray *array2 = @[@{@"placeholder":@"城市/區域",@"value":[[store_city stringByAppendingString:@"/"] stringByAppendingString:store_county],@"BtnHidden":@(0)},
                       @{@"placeholder":@"先選擇區域",  @"value":store_address,@"BtnHidden":@(0)}];
//    _storeMArray = [NSMutableArray arrayWithArray:array2];
    [self.storeMArray removeAllObjects];
    [self.storeMArray addObjectsFromArray:array2];
    
    
    NSArray *favorite_players = [ExtraData objectOrNilForKey:@"favorite_players"];
    NSString *firstname = @"";
    NSString *secondname = @"";
    NSString *threename = @"";
    if (favorite_players.count == 1) {
        firstname = [favorite_players firstObject];
    }
    if (favorite_players.count == 2) {
        firstname = [favorite_players firstObject];
        secondname = [favorite_players lastObject];
    }
    if (favorite_players.count >= 3) {
        firstname = [favorite_players firstObject];
        secondname = [favorite_players objectAtIndex:1];
        threename = [favorite_players lastObject];
    }
    NSArray *array3 = @[@{@"placeholder":@"第一順位",@"value":firstname,@"BtnHidden":@(1)},
                        @{@"placeholder":@"第二順位",  @"value":secondname,@"BtnHidden":@(1)},
                        @{@"placeholder":@"第三順位",@"value":threename,@"BtnHidden":@(1)}];
//    _playerMArray = [NSMutableArray arrayWithArray:array3];
    [self.playerMArray removeAllObjects];
    [self.playerMArray addObjectsFromArray:array3];
    
    
    NSString *Gender = [dataDictionary objectIsNilReturnSteForKey:@"Gender"];
    NSInteger mState = 0;
    NSInteger wState = 0;
    NSInteger sState = 0;
    if ([Gender isEqualToString:@"M"]) {
        mState = 1;
        wState = 0;
        sState = 0;
    }else if ([Gender isEqualToString:@"F"]) {
        mState = 0;
        wState = 1;
        sState = 0;
    }else{
        mState = 0;
        wState = 0;
        sState = 1;
    }
    NSString *invoice_option = [ExtraData objectIsNilReturnSteForKey:@"invoice_option"];
    NSInteger phoneState = 0;
    NSInteger emailState = 0;
    if ([invoice_option isEqualToString:@"mobileCarrier"]) {
        phoneState = 1;
        emailState = 0;
    }else if ([invoice_option isEqualToString:@"email"]) {
        phoneState = 0;
        emailState = 1;
    }else{
        phoneState = 0;
        emailState = 0;
    }
    NSString *invoice_number = [ExtraData objectIsNilReturnSteForKey:@"invoice_number"];
    NSArray *arraytic = @[@{@"title":@"發票開立",@"array":@[@{@"titleType":@"手機條碼載具",@"state":@(phoneState)},
                                                        @{@"titleType":@"寄送到 E-mail (同上)",@"state":@(emailState)}]},
                          @{@"placeholder":@"輸入手機載具",@"value":invoice_number,@"BtnHidden":@(1)},
                          @{@"title":@"性別",@"array":@[@{@"titleType":@" 男",@"state":@(mState)},
                                                      @{@"titleType":@" 女",@"state":@(wState)},
                                                      @{@"titleType":@" 保密",@"state":@(sState)}]}];
//    _ticketArray = [NSMutableArray arrayWithArray:arraytic];
    [self.ticketArray removeAllObjects];
    [self.ticketArray addObjectsFromArray:arraytic];
    
    
    [self.extraDataDict setValue:invoice_option forKey:@"invoice_option"];
    [self.extraDataDict setValue:invoice_number forKey:@"invoice_number"];
    [self.extraDataDict setValue:[ExtraData objectIsNilReturnSteForKey:@"store_id"] forKey:@"store_id"];
    [self.extraDataDict setValue:[ExtraData objectIsNilReturnSteForKey:@"store_name"] forKey:@"store_name"];
    [self.extraDataDict setValue:[ExtraData objectIsNilReturnSteForKey:@"update_time"] forKey:@"update_time"];
    [self.extraDataDict setValue:[ExtraData objectIsNilReturnSteForKey:@"register_time"] forKey:@"register_time"];
    [self.extraDataDict setValue:idNumber forKey:@"id_number"];
    [self.extraDataDict setValue:delivery_city forKey:@"delivery_city"];
    [self.extraDataDict setValue:delivery_district forKey:@"delivery_address"];
    [self.extraDataDict setValue:delivery_address forKey:@"delivery_district"];
    [self.extraDataDict setValue:store_city forKey:@"store_city"];
    [self.extraDataDict setValue:store_county forKey:@"store_county"];
    [self.extraDataDict setValue:store_address forKey:@"store_address"];
    [self.extraDataDict setValue:favorite_players forKey:@"favorite_players"];
    
}



- (NSMutableDictionary *)paramesDictionary
{
    if (!_paramesDictionary) {
        _paramesDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _paramesDictionary;
}
- (NSMutableDictionary *)extraDataDict
{
    if (!_extraDataDict) {
        _extraDataDict = [NSMutableDictionary dictionary];
    }
    return _extraDataDict;
}
- (NSArray *)headerArray
{
    if (!_headerArray) {
        _headerArray = @[@"",@"",@"通訊地址（可收包裹之地址）",@"7-11 門市選擇",@"喜歡球員 / 教練團",@""];
    }
    return _headerArray;
}


-(void)cellTextFieldChange:(NSString *)string indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSInteger row = indexPath.row;
        switch (row) {
            case 0:
                [self.paramesDictionary setObject:string forKey:@"Name"];
                [self.dataMArray replaceObjectAtIndex:row withObject:@{@"title":@"姓名",@"placeholder":@"請輸入姓名",@"enabled_TextF":@"0",@"value":string}];
                break;
            case 2:
                [self.paramesDictionary setObject:string forKey:@"Email"];
                [self.dataMArray replaceObjectAtIndex:row withObject:@{@"title":@"E-mail",@"placeholder":@"請輸入常用 E-mail",@"enabled_TextF":@"1",@"value":string}];
                break;
            case 3:
                [self.paramesDictionary setObject:string forKey:@"Identity"];
                [self.dataMArray replaceObjectAtIndex:row withObject:@{@"title":@"身分證字號",@"placeholder":@"請輸入身分證字號",@"enabled_TextF":@"1",@"value":string}];
                break;
            case 4:
            {
                [self.paramesDictionary setObject:string forKey:@"Birthday"];
                NSString *birthday = [string stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
                [self.dataMArray replaceObjectAtIndex:row withObject:@{@"title":@"生日",@"placeholder":@"年/月/日",@"enabled_TextF":@"1",@"value":birthday}];
            }
                break;
            default:
                break;
        }
        
    }else if (indexPath.section == 1){
        
        NSInteger mState = 0;
        NSInteger wState = 0;
        NSInteger sState = 0;
        if ([string isEqualToString:@"0"]) {
            mState = 1;
            wState = 0;
            sState = 0;
            [self.paramesDictionary setObject:@"M" forKey:@"Gender"];
        }else if ([string isEqualToString:@"1"]) {
            mState = 0;
            wState = 1;
            sState = 0;
            [self.paramesDictionary setObject:@"F" forKey:@"Gender"];
        }else{
            mState = 0;
            wState = 0;
            sState = 1;
            [self.paramesDictionary setObject:@"S" forKey:@"Gender"];
        }
        [self.ticketArray replaceObjectAtIndex:2 withObject:@{@"title":@"性別",@"array":@[@{@"titleType":@" 男",@"state":@(mState)},
                                                                                        @{@"titleType":@" 女",@"state":@(wState)},
                                                                                        @{@"titleType":@" 保密",@"state":@(sState)}]}];
        
    }else if (indexPath.section == 2){
        
        NSInteger row = indexPath.row;
        switch (row) {
            case 0:
            {
                NSArray *array1 = [string componentsSeparatedByString:@"/"];
                [self.extraDataDict setObject:[array1 firstObject] forKey:@"delivery_city"];
                [self.extraDataDict setObject:[array1 lastObject] forKey:@"delivery_district"];
                [self.addressMArray replaceObjectAtIndex:row withObject:@{@"placeholder":@"縣市/區域",@"value":string,@"BtnHidden":@(0)}];
            }
                break;
            case 1:
                [self.extraDataDict setObject:string forKey:@"delivery_address"];
                [self.addressMArray replaceObjectAtIndex:row withObject:@{@"placeholder":@"地址",@"value":string,@"BtnHidden":@(1)}];
                break;
            default:
                break;
        }
        
    }else if (indexPath.section == 3){
        
        NSInteger row = indexPath.row;
        switch (row) {
            case 0:
            {
                NSArray *array1 = [string componentsSeparatedByString:@"/"];
                
                NSString *cityOld = [array1 firstObject];
                NSString *districtOld = [array1 lastObject];
                NSString *city = self.extraDataDict[@"store_city"];
                NSString *district = self.extraDataDict[@"store_county"];
                
                [self.extraDataDict setObject:[array1 firstObject] forKey:@"store_city"];
                [self.extraDataDict setObject:[array1 lastObject] forKey:@"store_county"];
                [self.storeMArray replaceObjectAtIndex:row withObject:@{@"placeholder":@"城市/區域",@"value":string,@"BtnHidden":@(0)}];
                
                if (![cityOld isEqualToString:city] || ![districtOld isEqualToString:district]) {
                    [self.extraDataDict setObject:@"" forKey:@"store_address"];
                    [self.storeMArray replaceObjectAtIndex:1 withObject:@{@"placeholder":@"先選擇區域",@"value":@"",@"BtnHidden":@(0)}];
                }
                
            }
                break;
            case 1:
                [self.extraDataDict setObject:string forKey:@"store_address"];
                [self.storeMArray replaceObjectAtIndex:row withObject:@{@"placeholder":@"先選擇區域",@"value":string,@"BtnHidden":@(0)}];
                break;
            default:
                break;
        }
        
    }else if (indexPath.section == 4){
        
        NSInteger row = indexPath.row;
        switch (row) {
            case 0:
                
                [self.playerMArray replaceObjectAtIndex:row withObject:@{@"placeholder":@"第一順位",@"value":string,@"BtnHidden":@(1)}];
                break;
            case 1:
                
                [self.playerMArray replaceObjectAtIndex:row withObject:@{@"placeholder":@"第二順位",  @"value":string,@"BtnHidden":@(1)}];
                break;
            case 2:
                
                [self.playerMArray replaceObjectAtIndex:row withObject:@{@"placeholder":@"第三順位",  @"value":string,@"BtnHidden":@(1)}];
                break;
                
            default:
                break;
        }
        
        NSMutableArray *nameArr = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dict in self.playerMArray) {
            [nameArr addObject:dict[@"value"]];
        }
        [self.extraDataDict setObject:nameArr forKey:@"favorite_players"];
        
    }else if (indexPath.section == 5){
        
        NSInteger row = indexPath.row;
        switch (row) {
            case 0:
            {
                NSInteger phoneState = 0;
                NSInteger emailState = 0;
                if ([string isEqualToString:@"0"]) {
                    phoneState = 1;
                    emailState = 0;
                    [self.extraDataDict setObject:@"mobileCarrier" forKey:@"invoice_option"];
                    
                }else if ([string isEqualToString:@"1"]) {
                    phoneState = 0;
                    emailState = 1;
                    [self.extraDataDict setObject:@"email" forKey:@"invoice_option"];
                    
                }else{
                    phoneState = 0;
                    emailState = 0;
                }
                [self.ticketArray replaceObjectAtIndex:row withObject:@{@"title":@"發票開立",@"array":@[@{@"titleType":@"手機條碼載具",@"state":@(phoneState)},
                                                                                                  @{@"titleType":@"寄送到 E-mail (同上)",@"state":@(emailState)}]}];
            }
                break;
            case 1:
                [self.extraDataDict setValue:string forKey:@"invoice_number"];
                [self.ticketArray replaceObjectAtIndex:row withObject:@{@"placeholder":@"輸入手機載具",@"value":string,@"BtnHidden":@(1)}];
                break;
                
            default:
                break;
        }
    }
}

@end
