//
//  UISwitch.h
//  dddd
//
//  Created by Dragon_Zheng on 6/24/25.
//

#ifndef UISwitch_h
#define UISwitch_h
#import <UIKit/UIKit.h>

 

@interface UISwitch (tagged)

+ (UISwitch *) switchWithLeftText: (NSString *) tag1 andRight: (NSString *) tag2;

@property (nonatomic, readonly) UILabel *label1;

@property (nonatomic, readonly) UILabel *label2;

@end

#endif /* UISwitch_h */
