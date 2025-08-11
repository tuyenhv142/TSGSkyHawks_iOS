//
//  ViewController.h
//  music
//
//  Created by Dragon_Zheng on 2/5/25.
//

#import <UIKit/UIKit.h>
#import "LXYHyperlinksButton.h"
@interface EGPlayerSupportingViewController : EGBaseViewController
{
     
}


@property (nonatomic,retain)NSArray *All_playerArray;
@property (nonatomic,retain)NSArray *playerArray;
@property (nonatomic,retain)NSMutableDictionary *playerldic;
@property (nonatomic,assign)NSInteger playerType;//0 is 投手，1 is 捕手，2 is 内野手，3 is 外野兽，4，教练团


@end

