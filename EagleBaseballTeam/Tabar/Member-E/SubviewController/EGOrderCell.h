#import <UIKit/UIKit.h>

@class OrderHistoryModel;
@interface EGOrderCell : UITableViewCell

- (void)setupWithOrder:(NSDictionary *)order;
+(instancetype)cellWithUITableView:(UITableView *)tableView;

@property (nonatomic,strong) OrderHistoryModel *historyModel;

@end
