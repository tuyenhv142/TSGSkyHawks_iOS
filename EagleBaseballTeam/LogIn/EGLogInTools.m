//
//  EGLogInTools.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/13.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGLogInTools.h"

@implementation EGLogInTools


+ (NSString *)formatTimeFromSeconds:(NSInteger)seconds
{
    if (seconds <= 0) {
        return @" ";
    }
    NSInteger minutes = seconds / 60;
    NSInteger remainingSeconds = seconds % 60;
    return [NSString stringWithFormat:@"重新發送 %02ld:%02ld", (long)minutes, (long)remainingSeconds];
}

+ (BOOL)isValidTaiwanMobileNumber:(NSString *)phoneNumber
{
    NSString *regex = @"^09[0-9]{8}$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [predicate evaluateWithObject:phoneNumber];
}

+ (BOOL)isValidPswdString:(NSString *)inputString
{
    
    NSString *regex = @"^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,20}$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [predicate evaluateWithObject:inputString];
}

+ (BOOL)isValidEmailString:(NSString *)inputString
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:inputString];
}

+ (BOOL)isValidateTaiwanIDString:(NSString *)idNumber
{
//    NSString *pattern = @"^[A-Z][1-2][0-9]{8}$";
//    NSError *error = nil;
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
//    if (error) {
//        NSLog(@"正则表达式错误: %@", error.localizedDescription);
//        return NO;
//    }
//    NSRange range = NSMakeRange(0, idNumber.length);
//    NSTextCheckingResult *match = [regex firstMatchInString:idNumber options:0 range:range];
//    return match != nil;
    
    {
        NSString* number=@"^[A-Z][1-2][0-9]{8}$";
        NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
        
       if(![numberPre evaluateWithObject:idNumber])
             return NO;
        
        NSDictionary *dic5 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @(1), @"A", @(10), @"B",
                              @(19), @"C",@(28), @"D",
                              @(37), @"E",@(46), @"F",
                              @(55), @"G",@(64), @"H",
                              @(39), @"I",@(73), @"J",
                              @(82), @"K",@(2), @"L",
                              @(11), @"M",@(20), @"N",
                              @(48), @"O",@(29), @"P",
                              @(38), @"Q",@(47), @"R",
                              @(56), @"S",@(65), @"T",
                              @(74), @"U",@(83), @"V",
                              @(21), @"W",@(3), @"X",
                              @(12), @"Y",@(30), @"Z",
                              nil];

        /**
         const map: { [key: string]: number } = {
             A: 1 + 0 * 9, //  10  台北市  1
             B: 1 + 1 * 9, //  11  台中市   10
             C: 1 + 2 * 9, //  12  基隆市  19
             D: 1 + 3 * 9, //  13  台南市  28
             E: 1 + 4 * 9, //  14  高雄市  37
             F: 1 + 5 * 9, //  15  台北县  46
             G: 1 + 6 * 9, //  16  宜兰县  55
             H: 1 + 7 * 9, //  17  桃园县  64
             I: 3 + 4 * 9, //  34  嘉义市  39
             J: 1 + 8 * 9, //  18  新竹县  73
             K: 1 + 9 * 9, //  19  苗栗县  82
             L: 2 + 0 * 9, //  20  台中县  2
             M: 2 + 1 * 9, //  21  南投县  11
             N: 2 + 2 * 9, //  22  彰化县  20
             O: 3 + 5 * 9, //  35  新竹市  48
             P: 2 + 3 * 9, //  23  云林县   29
             Q: 2 + 4 * 9, //  24  嘉义县  38
             R: 2 + 5 * 9, //  25  台南县  47
             S: 2 + 6 * 9, //  26  高雄县  56
             T: 2 + 7 * 9, //  27  屏东县  65
             U: 2 + 8 * 9, //  28  花莲县  74
             V: 2 + 9 * 9, //  29  台东县  83
             W: 3 + 2 * 9, //  32  金门县  21
             X: 3 + 0 * 9, //  30  澎湖县  3
             Y: 3 + 1 * 9, //  31  阳明山管理局  12
             Z: 3 + 3 * 9 // 33  连江县  30
           };
         */

        //First char
        NSString* ch1 = [idNumber  substringToIndex:1];
        int first = [[dic5 objectForKey:ch1] intValue];
        //second char
        NSString *ch2 = [idNumber substringWithRange:NSMakeRange(1, 1)];
        int second = ch2.intValue * 8;
        
        int len = 9;
        int indext = 7;
        int result = 0;
        for(int i=2;i<len;i++)
        {
            unichar ch = [idNumber characterAtIndex: i];
            NSString *str_item2 = [NSString stringWithFormat:@"%C",ch];
            result = result + str_item2.intValue * indext;
    //        NSLog(@"%d * %d = %d",str_item2.intValue,indext,result);
            indext--;
        }
        int value = 10 - (first + second + result) % 10;
        if(value==10)
            value = 0;
        
        NSString *string8 = [idNumber substringFromIndex:idNumber.length-1];
    //    NSLog(@"last string = %d",string8.intValue);
        if(value != string8.intValue)
            return  NO;
        
        return YES;
    }
}

/**
 * 载具
 */
+ (BOOL)isInvoiceNnumber:(NSString *)input
{
    NSString *pattern = @"/[0-9A-Z.+\\-]{7}";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    NSTextCheckingResult *match = [regex firstMatchInString:input options:0 range:NSMakeRange(0, input.length)];
    if (match) {
        return true;
    } else {
        return false;
    }
}

@end
