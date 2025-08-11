//
//  ViewController.h
//  music
//
//  Created by Dragon_Zheng on 2/5/25.
//

#import <UIKit/UIKit.h>
#import "LXYHyperlinksButton.h"
@interface EGmedalViewController : EGBaseViewController
{
    NSArray *Mainarray;
    
    
}
@property (nonatomic,retain)NSArray *Mainarray;
@property (nonatomic,retain)NSMutableArray *girlArray;
@property (nonatomic,retain)NSMutableDictionary *girldic;
@property (nonatomic,assign)NSInteger type;//0 is 里程碑数据  1 is 模范生  2 is 勋章

@end

