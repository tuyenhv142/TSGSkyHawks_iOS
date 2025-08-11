#import <UIKit/UIKit.h>

// 定义枚举类型 变为 给点类型
typedef NS_ENUM(NSInteger, EGLocationRestrictionType) {
    EGLocationRestrictionTypeNone = 0,        // 不限地点
    EGLocationRestrictionTypeStadium = 1,     // 澄清湖棒球場
    EGLocationRestrictionTypeShop = 2,         // 球場商品販售區
    //以上的不用了EGLocationRestrictionTypeGiveAir
    EGLocationRestrictionTypeGiveNow = 3,  //
    EGLocationRestrictionTypeGiveAir = 4,
    EGLocationRestrictionTypeGiveScan = 5,
    EGLocationRestrictionTypeGiveBecon = 6
    
};

@interface EGComingSoonPopupView : UIView

//@property (nonatomic, assign) BOOL isBluetooth;
@property (nonatomic, assign) EGLocationRestrictionType locationType;
+ (void)showInView:(UIView *)view;
//+ (void)showWelcomePopup;  // 新增欢迎弹窗方法
+ (void)showCustomPopupWithConfig:(void(^)(NSMutableDictionary *config))configBlock
                     confirmBlock:(void(^)(void))confirmBlock;
//+ (void)showTableViewPopupWithConfig:(void(^)(NSMutableDictionary *config))configBlock
//                        confirmBlock:(void(^)(void))confirmBlock;

+ (void)showTableViewPopupWithConfig:(NSMutableDictionary *) config
                        confirmBlock:(void(^)(void))confirmBlock;
@end
