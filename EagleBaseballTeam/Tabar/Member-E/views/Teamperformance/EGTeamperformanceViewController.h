//
//  ViewController.h
//  music
//
//  Created by Dragon_Zheng on 2/5/25.
//

#import <UIKit/UIKit.h>
#import "LXYHyperlinksButton.h"
@interface EGTeamperformanceViewController : EGBaseViewController
{
    NSArray *Mainarray;
    
    
}
@property (nonatomic,retain)NSArray *Mainarray;
@property (nonatomic,retain)NSArray *teamProformentsArray;//球队战绩数据链结构
@property (nonatomic,retain)NSArray *playerTopArray;//打者排行数据链结构
@property (nonatomic,retain)NSArray *sendplayerTopArray;//投手排行数据链结构


@property (nonatomic,assign)NSString *playerTopType; //打击率，安打，打点，盗垒，全垒打
@property (nonatomic,assign)NSString *sendplayerTopType;// 防御率，胜投，三阵，中继，救援
@end

