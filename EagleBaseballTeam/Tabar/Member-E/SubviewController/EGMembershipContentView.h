#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EGMembershipType) {
    EGMembershipTypeNormal = 0,    // 鷹國人
    EGMembershipTypeParent,        // 鷹國親子
    EGMembershipTypeVIP,           // 鷹國尊爵
    EGMembershipTypeRoyal          // 鷹國皇家
};

@interface EGMembershipContentView : UIView

/// 初始化方法
/// @param type 会员类型
- (instancetype)initWithMembershipType:(EGMembershipType)type;

/// 设置会员类型
/// @param type 会员类型
- (void)setupWithMembershipType:(EGMembershipType)type;

// 设置UI内容
-(void)setContentInfo:(id ) info;

/// 购买按钮点击回调
@property (nonatomic, copy) void(^purchaseButtonClickBlock)(EGMembershipType type);

@end
