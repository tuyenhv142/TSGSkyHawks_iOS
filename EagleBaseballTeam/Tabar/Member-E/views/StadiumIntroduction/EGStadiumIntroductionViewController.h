//
//  ViewController.h
//  music
//
//  Created by Dragon_Zheng on 2/5/25.
//

#import <UIKit/UIKit.h>
#import "LXYHyperlinksButton.h"

typedef enum : NSUInteger {
    Stadium_Park_TableView= 50000,//停车资讯table view
    Stadium_TableView,//交通table view
    Seat_TableView,//座位资讯table view
    Catering_TableView,//餐饮table view
    Intrueduce_TableView//介绍table view
} EGTableView_Type;


@interface EGStadiumIntroductionViewController : EGBaseViewController
{
    NSArray *Mainarray;
}
@property (nonatomic,retain)NSArray *Mainarray;
@property (nonatomic,retain)NSArray *girlArray;
@property (nonatomic,retain)NSMutableDictionary *girldic;
@property (nonatomic,assign)EGTableView_Type tableView_Type;
@property (nonatomic,assign)BOOL seattableView_imagecell_clear;
@property (nonatomic,assign)NSInteger seattableView_imagecell_index;
@property (nonatomic,assign)NSInteger changdi_type;//101 is 澄清胡
@property (nonatomic,strong)NSMutableDictionary *latiorlongitude;

@property (nonatomic,assign)NSInteger catering_type;//0 is all, 1 is 美食，2 is 商品 ， 3 is 活动;
@end

