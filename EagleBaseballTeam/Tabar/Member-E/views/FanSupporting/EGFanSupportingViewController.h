//
//  ViewController.h
//  music
//
//  Created by Dragon_Zheng on 2/5/25.
//

#import <UIKit/UIKit.h>
#import "LXYHyperlinksButton.h"
@interface EGFanSupportingViewController : EGBaseViewController
{
    NSArray *Mainarray;
    
    
}
@property (nonatomic,retain)NSArray *Mainarray;
@property (nonatomic,retain)NSArray *girlArray;
@property (nonatomic,retain)NSMutableDictionary *girldic;
@property (nonatomic,assign)NSInteger fansType;
@end

