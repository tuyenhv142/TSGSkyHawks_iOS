#import "EGComingSoonPopupView.h"
#import "CoreBluetooth/CoreBluetooth.h"
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>


@interface EGComingSoonPopupView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, copy) void(^confirmBlock)(void);

@property (nonatomic, strong)UITextView* showMusic;

// tableview style 在头部添加属性声明
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *sectionHeaders;
@property (nonatomic, strong) NSArray *cellContents;
@property (nonatomic, copy) NSString *footerContent;

@end

@implementation EGComingSoonPopupView

//MARK:  现场活动 弹出view
+ (void)showInView:(UIView *)view {

    NSSet *set = [UIApplication sharedApplication].connectedScenes;
    UIWindowScene *windowScene = [set anyObject];
    UIWindow *keyWindow = windowScene.windows.firstObject;
    
    EGComingSoonPopupView *popupView = [[EGComingSoonPopupView alloc] initWithFrame:keyWindow.bounds];
    [keyWindow addSubview:popupView];
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

//MARK: tabbar 活动弹出
+ (void)showCustomPopupWithConfig:(void(^)(NSMutableDictionary *config))configBlock
                     confirmBlock:(void(^)(void))confirmBlock {
    
    NSSet *set = [UIApplication sharedApplication].connectedScenes;
    UIWindowScene *windowScene = [set anyObject];
    UIWindow *keyWindow = windowScene.windows.firstObject;
    
    // 创建配置字典
    NSMutableDictionary *config = [NSMutableDictionary dictionary];
    // 设置默认值
    config[@"containerHeight"] = @(342);
    config[@"iconImage"] = @"dialog_TAKAMEI";
    config[@"message"] = @"現場活動，即將登場！";
    config[@"detail"] = @"";
    config[@"buttonTitle"] = @"確定";
    
    // 调用配置回调
    if (configBlock) {
        configBlock(config);
    }
    
    EGComingSoonPopupView *popupView = [[EGComingSoonPopupView alloc] initWithCustomConfig:config confirmBlock:confirmBlock];
    [keyWindow addSubview:popupView];
}
// 添加新的初始化方法
- (instancetype)initWithCustomConfig:(NSDictionary *)config confirmBlock:(void(^)(void))confirmBlock {
    
    if (self = [super initWithFrame:CGRectMake(0, 0, Device_Width, Device_Height)]) {
        self.confirmBlock = confirmBlock;
        [self setupUIWithConfig:config];
    }
    return self;
}

//MARK: 点数 列表点击弹出
+ (void)showTableViewPopupWithConfig:(NSMutableDictionary *) config
                        confirmBlock:(void(^)(void))confirmBlock {
    NSSet *set = [UIApplication sharedApplication].connectedScenes;
    UIWindowScene *windowScene = [set anyObject];
    UIWindow *keyWindow = windowScene.windows.firstObject;
    
    //    // 创建配置字典
    //    NSMutableDictionary *config = [NSMutableDictionary dictionary];
    //    // 设置默认值
    //    config[@"containerHeight"] = @(342);
    //    config[@"iconImage"] = @"dialog_TAKAMEI";
    //    config[@"message"] = @"現場活動，即將登場！";
    //    config[@"detail"] = @"";
    //    config[@"buttonTitle"] = @"確定";
    
    //    // 调用配置回调
    //    if (configBlock) {
    //        configBlock(config);
    //    }
    EGComingSoonPopupView *popupView = [[EGComingSoonPopupView alloc] initWithTableViewConfig:config confirmBlock:confirmBlock];
    [keyWindow addSubview:popupView];
    
}
// 添加新的初始化方法
- (instancetype)initWithTableViewConfig:(NSDictionary *)config confirmBlock:(void(^)(void))confirmBlock {
    if (self = [super initWithFrame:CGRectMake(0, 0, Device_Width, Device_Height)]) {
        self.confirmBlock = confirmBlock;
        [self setupTableViewWithConfig:config];
        
    }
    return self;
}


- (void)setupUI {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    // 添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tap];
    
    // 容器视图
    self.containerView = [[UIView alloc] init];
    [self addSubview:self.containerView];
    
    // 内容视图（白色背景）
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = ScaleW(16);
    self.contentView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    [self.containerView addSubview:self.contentView];
    
    // 图标
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.image = [UIImage imageNamed:@"dialog_TAKAMEI"];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.iconImageView];
    
    // 文本标签
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.text = @"現場活動，即將登場！";
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.textColor = rgba(23, 23, 23, 1);
    self.messageLabel.font = [UIFont systemFontOfSize:FontSize(18) weight:UIFontWeightSemibold];
    [self.contentView addSubview:self.messageLabel];
    
    // 确定按钮
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmButton setTitle:@"確定" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.confirmButton.backgroundColor = rgba(0, 78, 162, 1);
    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightSemibold];
    [self.confirmButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    self.confirmButton.titleEdgeInsets = UIEdgeInsetsMake(-ScaleW(40), 0, 0, 0);
    [self.containerView addSubview:self.confirmButton];
    
    
    // 布局
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(ScaleW(342));
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.containerView);
        make.height.mas_equalTo(ScaleW(260));
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(ScaleW(30));
        make.width.height.mas_equalTo(ScaleW(160));
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(ScaleW(16));
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.containerView);
        make.height.mas_equalTo(ScaleW(82));
    }];
    
    // 添加动画
    self.containerView.transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.transform = CGAffineTransformIdentity;
    }];
}

// 修改 setupTableViewWithConfig 方法
-(void)setupTableViewWithConfig:(NSDictionary *)config {
    // 配置数据
    self.sectionHeaders = config[@"sectionHeaders"];
    self.cellContents = config[@"cellContents"];
    self.footerContent = config[@"footerContent"];
    self.locationType = [config[@"locationType"] integerValue]  ;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    

    // 添加下滑手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self addGestureRecognizer:panGesture];
    
    // 容器视图
    self.containerView = [[UIView alloc] init];
    self.containerView.layer.cornerRadius = ScaleW(16);
    self.containerView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.containerView];
    
    // 内容视图（白色背景）
    self.contentView = [[UIView alloc] init];
//    self.contentView.backgroundColor = [UIColor whiteColor];
//    self.contentView.layer.cornerRadius = ScaleW(16);
//    self.contentView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    [self.containerView addSubview:self.contentView];
    

    // 添加标题和关闭按钮容器
    UIView *headerView = [[UIView alloc] init];
    [self.contentView addSubview:headerView];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = config[@"title"];
    self.titleLabel.font = [UIFont systemFontOfSize:FontSize(18) weight:UIFontWeightSemibold];
    self.titleLabel.textColor = rgba(0, 122, 96, 1);
    [headerView addSubview:self.titleLabel];
//    headerView.backgroundColor = [UIColor redColor];
    
    // 关闭按钮
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.closeButton];

    // 表格视图
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
//    self.tableView.bouncesZoom = YES;
    self.tableView.bounces = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:self.tableView];
    
    
    //测试信号强度时候用，正常版本隐藏
    UITextView* textView = [[UITextView alloc] init];
    textView.textAlignment = NSTextAlignmentCenter;
    textView.font = [UIFont systemFontOfSize:FontSize(16)];
    textView.scrollEnabled = YES;
    textView.editable = NO;
    [self.contentView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    self.showMusic = textView;
    self.showMusic.hidden = YES;
    
    // 确定按钮
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmButton setTitle:config[@"buttonTitle"] forState:UIControlStateDisabled];
    [self.confirmButton setTitle:@"前往" forState:UIControlStateNormal];
    
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.confirmButton setBackgroundImage:[UIImage imageWithColor:rgba(0, 78, 162, 1)] forState:UIControlStateNormal];
    
    [self.confirmButton setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateDisabled];  // 禁用状态文字颜色
    [self.confirmButton setBackgroundImage:[UIImage imageWithColor:rgba(229, 229, 229, 1)] forState:UIControlStateDisabled];  // 禁用状态背景色
//    [self.confirmButton setTitle:@"即將開放" forState:UIControlStateDisabled];

    
    self.confirmButton.backgroundColor = rgba(0, 78, 162, 1);
    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightSemibold];
    [self.confirmButton addTarget:self action:@selector(dismissConfirmButton) forControlEvents:UIControlEventTouchUpInside];
    self.confirmButton.titleEdgeInsets = UIEdgeInsetsMake(-ScaleW(40), 0, 0, 0);
    [self.containerView addSubview:self.confirmButton];
    
    if ([config[@"type"] isEqualToString:@"fb"] ||
        [config[@"type"] isEqualToString:@"instagram"] ||
        [config[@"type"] isEqualToString:@"yt"]  ){
        self.confirmButton.enabled = YES;
        self.confirmButton.hidden = NO;
        
        if (![config[@"isAdd"] boolValue]) {
            //没加过点 走这里
            if ([config[@"status"] isEqualToString:@"即將開放"] || [config[@"status"] isEqualToString:@"已完成"]|| [config[@"status"] isEqualToString:@"已過期"] ||
                [config[@"status"] isEqualToString:@"尚未解鎖"]) {
                self.confirmButton.enabled = NO;
                self.confirmButton.hidden = YES;
            }
        }else{
            //加过点 走这里
            self.confirmButton.enabled = NO;
            self.confirmButton.hidden = YES;
        }
        
    }else{
//        if ([config[@"type"] isEqualToString:@"checkin"]) {
//            self.confirmButton.hidden = NO;
//            self.confirmButton.enabled = NO;
//        }else{
//            self.confirmButton.enabled = NO;
//            self.confirmButton.hidden = YES;
//        }
        if ( [config[@"type"] isEqualToString:@"survey"] ) {
            self.confirmButton.enabled = YES;
            self.confirmButton.hidden = NO;
            
        }else{
            self.confirmButton.enabled = NO;
            self.confirmButton.hidden = YES;
        }
    }
    

    
    
//    self.confirmButton.enabled = NO;
    CGFloat containerHeight = [config[@"containerHeight"] floatValue];
    CGFloat contentHeight = containerHeight - (82);
    
    // 布局
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(ScaleW(containerHeight));
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.containerView);
        make.height.mas_equalTo(ScaleW(contentHeight));
    }];
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(ScaleW(56));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView).inset(ScaleW(30));
        make.left.equalTo(headerView).inset(ScaleW(20));
        make.right.equalTo(headerView).inset(ScaleW(45));
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView).offset(-ScaleW(16));
        make.centerY.equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(ScaleW(35), ScaleW(35)));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.containerView);
        make.height.mas_equalTo(ScaleW(82));
    }];
    
    // 添加动画
    self.containerView.transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.transform = CGAffineTransformIdentity;
    }];
    
    
}

-(void)setupUIWithConfig:(NSDictionary *)config {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    // 添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tap];
    
    // 容器视图
    self.containerView = [[UIView alloc] init];
    [self addSubview:self.containerView];
    
    // 内容视图（白色背景）
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = ScaleW(16);
    self.contentView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    [self.containerView addSubview:self.contentView];
    
    // 图标
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.image = [UIImage imageNamed:config[@"iconImage"]];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.iconImageView];
    
    // 文本标签
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.text = config[@"message"];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.textColor = rgba(23, 23, 23, 1);
    self.messageLabel.font = [UIFont systemFontOfSize:FontSize(18) weight:UIFontWeightSemibold];
    [self.contentView addSubview:self.messageLabel];
    
    // 添加详细说明标签
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.text = config[@"detail"];
    self.detailLabel.textAlignment = NSTextAlignmentCenter;
    self.detailLabel.textColor = rgba(82, 82, 82, 1);
    self.detailLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightRegular];
    self.detailLabel.numberOfLines = 0;
    [self.contentView addSubview:self.detailLabel];
    
    // 确定按钮
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmButton setTitle:config[@"buttonTitle"] forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.confirmButton.backgroundColor = rgba(0, 78, 162, 1);
    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightSemibold];
    [self.confirmButton addTarget:self action:@selector(dismissConfirmButton) forControlEvents:UIControlEventTouchUpInside];
    self.confirmButton.titleEdgeInsets = UIEdgeInsetsMake(-ScaleW(40), 0, 0, 0);
    [self.containerView addSubview:self.confirmButton];
    
    CGFloat containerHeight = [config[@"containerHeight"] floatValue];
    CGFloat contentHeight = containerHeight - (82);
    
    // 布局
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(ScaleW(containerHeight));
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.containerView);
        make.height.mas_equalTo(ScaleW(contentHeight));
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView).offset(-ScaleW(15));
        make.top.equalTo(self.contentView).offset(ScaleW(30));
        make.width.height.mas_equalTo(ScaleW(190));
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(ScaleW(16));
        make.left.right.equalTo(self.contentView).inset(ScaleW(20));
    }];
    
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.containerView);
        make.height.mas_equalTo(ScaleW(82));
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.messageLabel.mas_bottom).offset(ScaleW(8));
        make.left.right.equalTo(self.contentView).inset(ScaleW(20));
    }];
    
    // 添加动画
    self.containerView.transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.transform = CGAffineTransformIdentity;
    }];
}

- (void)dismissConfirmButton {
    if (self.confirmBlock) {
        self.confirmBlock();
    }
//    if (self.isBluetooth) {
//        [self saveBeaconID];
//    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

// 添加手势处理方法
- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.containerView];
    CGFloat progress = translation.y / self.containerView.bounds.size.height;
    
    switch (gesture.state) {
        case UIGestureRecognizerStateChanged: {
            if (translation.y > 0) { // 只允许向下滑动
                self.containerView.transform = CGAffineTransformMakeTranslation(0, translation.y);
//                self.alpha = 1 - progress;
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            if (progress > 0.1) { // 如果滑动超过 10% 就关闭
                [self dismiss];
            } else {
                // 恢复原位
                [UIView animateWithDuration:0.3 animations:^{
                    self.containerView.transform = CGAffineTransformIdentity;
                    self.alpha = 1;
                }];
            }
            break;
        }
        default:
            break;
    }
}
//MARK: --网络请求
-(void)saveBeaconID{
    NSMutableDictionary *para =  [NSMutableDictionary dictionary];
//    {
//        "deviceId" :"yufee-0705-1199-3210",
//        "btbId": "4",
//        "interactionTime": "2025-03-02T06:18:25.000+00:00",
//        "deviceOtherInfo": "设备其他信息",
//        "additionalBluetoothInfo": "蓝牙其他信息"
//    }
    [para setObject:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"deviceId"];
    [para setObject:@"1" forKey:@"btbId"];
    [para setObject:[self getCurrentTimeWithTimeZone]  forKey:@"interactionTime"];
    [para setObject:@"设备其他信息" forKey:@"deviceOtherInfo"];
    [para setObject:@"蓝牙其他信息" forKey:@"additionalBluetoothInfo"];
    
    [[WAFNWHTTPSTool sharedManager] postWithURL:[EGServerAPI mobile_beaconSave] parameters:para headers:@{} success:^(NSDictionary * _Nonnull response) {
        
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD showDelayHidenMessage:error.localizedDescription];
    }];
}

// 在实现部分添加方法
- (NSString *)getCurrentTimeWithTimeZone {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    return [formatter stringFromDate:[NSDate date]];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4; // 活動點數(蓝牙) 活动期间、活动内容、、点数发放过程
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return [UIView new];
    }
    UIView *headerView = [[UIView alloc] init];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightSemibold];
    titleLabel.textColor = rgba(23, 23, 23, 1);
    titleLabel.text = @"•";
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightSemibold];
    contentLabel.textColor = rgba(23, 23, 23, 1);
    contentLabel.text = self.sectionHeaders[section];

    [headerView addSubview:titleLabel];
    [headerView addSubview:contentLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(headerView).inset(ScaleW(10));
        make.left.equalTo(headerView).offset(ScaleW(20));
        make.width.mas_equalTo(ScaleW(15));
//        make.centerY.equalTo(headerView);
    }];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel.mas_right).offset(ScaleW(0));
//        make.centerY.equalTo(headerView);
        make.top.bottom.equalTo(headerView).inset(ScaleW(10));
    }];

    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    if (section == 3) {
//        UIView *footerView = [[UIView alloc] init];
//        
////        // 添加分割线
////        UIView *separatorLine = [[UIView alloc] init];
////        separatorLine.backgroundColor = rgba(238, 238, 238, 1);
////        [footerView addSubview:separatorLine];
//        
//        UILabel *takaoLabel = [[UILabel alloc] init];
//        takaoLabel.text = @"每日 12:00 系統將自動刷新，請務必即時領取點數！";//self.footerContent;
//        takaoLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
//        takaoLabel.textColor = rgba(0, 122, 96, 1);
//        takaoLabel.numberOfLines = 0;
//
//        [footerView addSubview:takaoLabel];
//        
////        // 设置分割线约束
////        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
////            make.top.equalTo(footerView);
////            make.left.right.inset(ScaleW(20));
////            make.height.mas_equalTo(1);
////        }];
//        
//        [takaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(footerView).insets(UIEdgeInsetsMake(ScaleW(0), ScaleW(35), ScaleW(16), ScaleW(20)));
//        }];
//
//        return footerView;
//    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 3 ? UITableViewAutomaticDimension : 0.00001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    // 配置cell内容
    if (indexPath.section == 3) {
        UIView *containerView = [[UIView alloc] init];
        [cell.contentView addSubview:containerView];
        
        UIView *lastView = nil;
        NSArray *array = self.cellContents[indexPath.section];
        
        for (int i=0; i<array.count; i++) {
            ELog(@"%@",array[i]);
            UIView *itemView = [self createItemViewWithNumber:(i+1)  text:array[i]];
            [containerView addSubview:itemView];
            
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i==0) {
                    make.top.equalTo(containerView);
                }else{
                    make.top.equalTo(lastView.mas_bottom).offset(ScaleW(5));
                }
                make.left.right.equalTo(containerView).inset(ScaleW(35));
                if (i==array.count-1) {
                    make.bottom.equalTo(containerView);
                }
            }];
            lastView = itemView;
        }
        
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(cell.contentView);
            
            make.bottom.equalTo(cell.contentView).offset(-ScaleW(16)); // 添加底部间距;
        }];
        
    }else if(indexPath.section == 0){
        // 创建容器视图
        UIView *containerView = [[UIView alloc] init];
        [cell.contentView addSubview:containerView];
        containerView.layer.cornerRadius = ScaleW(8);
        containerView.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
        
        // 左侧容器视图
        UIView *leftContainerView = [[UIView alloc] init];
        [containerView addSubview:leftContainerView];
        
        // 左侧图标按钮
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        leftButton.backgroundColor = rgba(0, 122, 96, 1);
//        leftButton.layer.cornerRadius = ScaleW(12);
//        leftButton.layer.masksToBounds = true;
//        [leftButton setImage:[UIImage imageNamed:@"TSG-white"] forState:UIControlStateNormal];
//        leftButton.backgroundColor = [UIColor whiteColor];
//        leftButton.layer.cornerRadius = ScaleW(8);
//        leftButton.layer.borderWidth = 1;
//        leftButton.layer.borderColor = rgba(238, 238, 238, 1).CGColor;
        [leftButton setImage:[UIImage imageNamed:@"TSG_Dark"] forState:UIControlStateNormal];
        [leftContainerView addSubview:leftButton];
        
        // 左侧点数标签
        UILabel *pointsLabel = [[UILabel alloc] init];
        pointsLabel.text = [NSString stringWithFormat:@"%@ 點", self.cellContents[0]];
        pointsLabel.textAlignment = NSTextAlignmentCenter;
        pointsLabel.textColor = rgba(23, 23, 23, 1);
        pointsLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightSemibold];
        [leftContainerView addSubview:pointsLabel];
        
        // 右侧容器视图
        UIView *rightContainerView = [[UIView alloc] init];
        [containerView addSubview:rightContainerView];
        
        // 右侧蓝牙图标
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setImage:[UIImage imageNamed:@"icon_bluetooth"] forState:UIControlStateNormal];
        rightButton.backgroundColor = [UIColor clearColor];
      
        
        // 右侧球场名称 改为给点方式
        UILabel *locationLabel = [[UILabel alloc] init];
//        if (self.locationType == EGLocationRestrictionTypeStadium) {
//            locationLabel.text = @"澄清湖棒球場";
//            [rightButton setImage:[UIImage imageNamed:@"icon_bluetooth"] forState:UIControlStateNormal];
//        }else if(self.locationType == EGLocationRestrictionTypeShop){
//            locationLabel.text = @"球場商品販售區";
//            [rightButton setImage:[UIImage imageNamed:@"storefront"] forState:UIControlStateNormal];
//        }else{
//            locationLabel.text = @"不限地點";
//            [rightButton setImage:[UIImage imageNamed:@"icon_bluetooth"] forState:UIControlStateNormal];
//        }
        NSDictionary *info = [self getCardInfoForMemberType:self.locationType];
        locationLabel.text = info[@"title"];
        [rightButton setImage:[UIImage imageNamed:info[@"image"]] forState:UIControlStateNormal];
        [rightContainerView addSubview:rightButton];
        
        locationLabel.textAlignment = NSTextAlignmentCenter;
        locationLabel.textColor = rgba(23, 23, 23, 1);
        locationLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightSemibold];
        [rightContainerView addSubview:locationLabel];
        
        // 添加中间分割线
        UIView *separatorLine = [[UIView alloc] init];
        separatorLine.backgroundColor = rgba(238, 238, 238, 1);
        [containerView addSubview:separatorLine];
        
        // 设置约束
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView).insets(UIEdgeInsetsMake(ScaleW(0), ScaleW(20), ScaleW(16), ScaleW(20)));
            make.height.mas_equalTo(ScaleW(92));
        }];
        
        // 添加分割线约束
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(containerView);
            make.top.bottom.equalTo(containerView).inset(ScaleW(16));
            make.width.mas_equalTo(1);
        }];
        
        [leftContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(containerView);
            make.top.bottom.equalTo(containerView);
            make.width.equalTo(containerView.mas_width).multipliedBy(0.45);
        }];
        
        [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(leftContainerView);
            make.centerY.equalTo(leftContainerView).offset(-ScaleW(10));
            make.size.mas_equalTo(CGSizeMake(ScaleW(24), ScaleW(24)));
        }];
        
        [pointsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(leftContainerView);
            make.top.equalTo(leftButton.mas_bottom).offset(ScaleW(8));
            make.left.right.equalTo(leftContainerView);
        }];
        
        [rightContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(containerView);
            make.top.bottom.equalTo(containerView);
            make.width.equalTo(containerView.mas_width).multipliedBy(0.45);
        }];
        
        [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(rightContainerView);
            make.centerY.equalTo(rightContainerView).offset(-ScaleW(10));
            make.size.mas_equalTo(CGSizeMake(ScaleW(30), ScaleW(30)));
        }];
        
        [locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(rightContainerView);
            make.top.equalTo(rightButton.mas_bottom).offset(ScaleW(8));
            make.left.right.equalTo(rightContainerView);
        }];
    }else{
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.numberOfLines = 0;
        contentLabel.font = [UIFont systemFontOfSize:FontSize(14)];
        contentLabel.textColor = rgba(115, 115, 115, 1);

        contentLabel.text = self.cellContents[indexPath.section];

        [cell.contentView addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView).insets(UIEdgeInsetsMake(0, ScaleW(35), ScaleW(16), ScaleW(20)));
        }];
    }
    return cell;
}

// 生成单个条目的视图
- (UIView *)createItemViewWithNumber:(NSInteger)number text:(NSString *)text {
    UIView *containerView = [[UIView alloc] init];
    
//    // 序号标签
//    UILabel *numberLabel = [[UILabel alloc] init];
//    numberLabel.text = [NSString stringWithFormat:@"%ld.", (long)number];
//    numberLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
//    numberLabel.textColor = rgba(115, 115, 115, 1);
//    [containerView addSubview:numberLabel];
//    
//    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.equalTo(containerView);
//        make.width.mas_equalTo(ScaleW(15));
//    }];
//    
//    UIView *lastView = numberLabel;
    // 内容标签
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = text;
    contentLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
    contentLabel.textColor =  rgba(115, 115, 115, 1);
    contentLabel.numberOfLines = 0;
    [containerView addSubview:contentLabel];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(containerView);
//        make.left.equalTo(numberLabel.mas_right).offset(ScaleW(4));
        make.left.equalTo(containerView).offset(ScaleW(4));
        make.right.bottom.equalTo(containerView);
    }];
    
    return containerView;
}

- (NSArray *)processString:(NSString *)inputString {
    // 1. 按换行符分割字符串
    NSArray *lines = [inputString componentsSeparatedByString:@"\n"];
    
    // 2. 处理每一行
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSString *line in lines) {
        if (line.length == 0) continue; // 跳过空行
        
        // 查找第一个空格的位置
        NSRange firstSpaceRange = [line rangeOfString:@" "];
        if (firstSpaceRange.location != NSNotFound) {
            // 从空格后开始截取
            NSString *processedLine = [line substringFromIndex:firstSpaceRange.location + 1];
            if (processedLine.length > 0) {
                [resultArray addObject:processedLine];
            }
        } else {
            // 如果没有空格，直接添加原字符串
            [resultArray addObject:line];
        }
    }
    
    return [resultArray copy];
}


- (NSDictionary *)getCardInfoForMemberType:(EGLocationRestrictionType )typeId {
    NSDictionary *cardInfoMap = @{
        @(EGLocationRestrictionTypeNone): @{
            @"image": @"icon_bluetooth",
            @"title": @"不限地点"
        },
        @(EGLocationRestrictionTypeStadium): @{
            @"image": @"icon_bluetooth",
            @"title": @"澄清湖排球球場"
        },
        @(EGLocationRestrictionTypeShop): @{
            @"image": @"storefront",
            @"title": @"球場商品販售區"
        },
        @(EGLocationRestrictionTypeGiveNow): @{
            @"image": @"rocket-launch",
            @"title": @"即時給點"
        },
        @(EGLocationRestrictionTypeGiveAir): @{
            @"image": @"parachute",
            @"title": @"空投給點"
        },
        @(EGLocationRestrictionTypeGiveScan): @{
            @"image": @"Scancode",
            @"title": @"掃碼給點"
        },
        @(EGLocationRestrictionTypeGiveBecon): @{
            @"image": @"beacon",
            @"title": @"信標給點"
        }
        
    };
    return cardInfoMap[@(typeId)];
}

@end
