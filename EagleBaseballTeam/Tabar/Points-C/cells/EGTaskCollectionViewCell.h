#import <UIKit/UIKit.h>
@protocol EGTaskCollectionViewCellDelegate <NSObject>
- (void)taskCell:(UICollectionViewCell *)cell didClickStateButtonAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface EGTaskCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *dateRange;
@property (nonatomic, copy) NSString *points;
@property (nonatomic, copy) NSString *status; // 已完成/敬請期待/任務詳情
@property (nonatomic, weak) id<EGTaskCollectionViewCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;


- (void)setupWithTask:(NSDictionary *)task;




@end
