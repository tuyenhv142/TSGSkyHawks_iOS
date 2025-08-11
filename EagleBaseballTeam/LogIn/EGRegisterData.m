//
//  EGRegisterData.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/13.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGRegisterData.h"

@implementation EGRegisterData

- (NSMutableArray *)dataMArray
{
    if (!_dataMArray) {
        NSArray *array = @[@{@"title":@"姓名",@"placeholder":@"請輸入姓名",@"subTitle":@"",@"value":@""},
                           @{@"title":@"手機號碼",@"placeholder":@"請輸入手機號碼",@"subTitle":@"",@"value":@""},
                           @{@"title":@"手機驗證碼",@"placeholder":@"請輸入手機驗證碼",@"subTitle":@"",@"value":@""},
                           @{@"title":@"密碼",@"placeholder":@"請輸入密碼",@"subTitle":@"密碼限 8~20 個字元，必須包含至少一個英文字母及數字。",@"value":@""},
                           
                           @{@"title":@"密碼確認",@"placeholder":@"請再次輸入相同密碼",@"subTitle":@"",@"value":@""},
                           @{@"title":@"E-mail",@"placeholder":@"請輸入常用 E-mail",@"subTitle":@"",@"value":@""},
                           @{@"title":@"身分證字號",@"placeholder":@"請輸入身分證字號",@"subTitle":@"",@"value":@""},
                           @{@"title":@"生日",@"placeholder":@"年/月/日",@"subTitle":@"*可獲得生日專屬禮，註冊後將無法修改",@"value":@""}
        ];
        _dataMArray = [NSMutableArray arrayWithArray:array];
    }
    return _dataMArray;
}
- (NSMutableDictionary *)paramsDict
{
    if (!_paramsDict) {
        _paramsDict = [NSMutableDictionary dictionary];
    }
    return _paramsDict;
}


-(void)textFieldChangeString:(NSString *)string index:(NSInteger )row
{
    switch (row) {
        case 0:
            [self.paramsDict setObject:string forKey:@"name"];
            [self.dataMArray replaceObjectAtIndex:row withObject:@{@"title":@"姓名",@"placeholder":@"請輸入姓名",@"subTitle":@"",@"value":string}];
            break;
            
        case 1:
            [self.paramsDict setObject:string forKey:@"phone"];
            [self.dataMArray replaceObjectAtIndex:row withObject:@{@"title":@"手機號碼",@"placeholder":@"請輸入手機號碼",@"subTitle":@"",@"value":string}];
            break;
        case 2:
            [self.paramsDict setObject:string forKey:@"otp"];
            [self.dataMArray replaceObjectAtIndex:row withObject:@{@"title":@"手機驗證碼",@"placeholder":@"請輸入手機驗證碼",@"subTitle":@"",@"value":string}];
            break;
            
        case 3:
            [self.paramsDict setObject:string forKey:@"password"];
            [self.dataMArray replaceObjectAtIndex:row withObject:@{@"title":@"密碼",@"placeholder":@"請輸入密碼",@"subTitle":@"密碼限 8~20 個字元，必須包含至少一個英文字母及數字。",@"value":string}];
            break;
        case 4:
            [self.paramsDict setObject:string forKey:@"password_again"];
            [self.dataMArray replaceObjectAtIndex:row withObject:@{@"title":@"密碼確認",@"placeholder":@"請再次輸入相同密碼",@"subTitle":@"",@"value":string}];
            break;
            
        case 5:
            [self.paramsDict setObject:string forKey:@"email"];
            [self.dataMArray replaceObjectAtIndex:row withObject:@{@"title":@"E-mail",@"placeholder":@"請輸入常用 E-mail",@"subTitle":@"",@"value":string}];
            break;
            
        case 6:
            [self.paramsDict setObject:@{@"identity":string} forKey:@"extraData"];
            [self.dataMArray replaceObjectAtIndex:row withObject:@{@"title":@"身分證字號",@"placeholder":@"請輸入身分證字號",@"subTitle":@"",@"value":string}];
            break;
            
        case 7:
            [self.paramsDict setObject:string forKey:@"birthday"];
            [self.dataMArray replaceObjectAtIndex:row withObject:@{@"title":@"生日",@"placeholder":@"年/月/日",@"subTitle":@"*可獲得生日專屬禮，註冊後將無法修改",@"value":string}];//@"年/月/日
            break;
        default:
            break;
    }
}

- (BOOL )determineIfThereIsNil
{
    NSString *name = self.paramsDict[@"name"];
    if (name.length == 0) {
        return false;
    }
   
    NSString *phone = self.paramsDict[@"phone"];
    if (phone.length == 0) {
        return false;
    }
    NSString *otp = self.paramsDict[@"otp"];
    if (otp.length == 0) {
        return false;
    }
    NSString *password = self.paramsDict[@"password"];
    if (password.length == 0) {
        return false;
    }
    NSString *email = self.paramsDict[@"email"];
    if (email.length == 0) {
        return false;
    }
    NSString *id_number = self.paramsDict[@"extraData"][@"identity"];
    if (id_number.length == 0) {
       // return false;
    }
    NSString *birthday = self.paramsDict[@"birthday"];
    if (birthday.length == 0) {
        self.paramsDict[@"birthday"] = @"2025-03-29";
       // return false;
    }
    
//    self.paramsDict[@"gender"] = @"S";
    NSString *gender = self.paramsDict[@"gender"];
    if (gender.length == 0) {
//        return false;
    }
    
    return true;
}

@end

