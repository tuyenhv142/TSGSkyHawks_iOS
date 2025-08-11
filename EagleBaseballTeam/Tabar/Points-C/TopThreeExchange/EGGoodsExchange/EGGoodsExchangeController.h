//
//  ViewController.h
//  music
//
//  Created by Dragon_Zheng on 2/5/25.
//

#import <UIKit/UIKit.h>
#import "LXYHyperlinksButton.h"
@interface EGGoodsExchangeController : EGBaseViewController
{
    
    
}
@property (nonatomic,retain)NSArray *goodsArray;
@property (nonatomic,strong)NSMutableArray  *goodsfilterData;        //存放筛选出来的数组

@property (nonatomic,retain)NSMutableDictionary *playerldic;
@property (nonatomic,assign)BOOL is_fav;//临时用，等数据来了，就不用了，实时读取数据

@property (nonatomic, assign) NSInteger points;

@property (nonatomic, assign) NSInteger sort_type;//0 is sort by date 降序 1 is sort by date 升序 2 is sort by point 降序
@end

