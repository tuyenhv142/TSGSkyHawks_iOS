#import <UIKit/UIKit.h>
#import "EGOrderDetailInfo.h"

@interface EGOrderDetailViewController : EGBaseViewController

@property (nonatomic, strong) EGOrderDetailInfo *orderInfo;

@property (nonatomic, copy) NSString *orderID;

@end
