#import "EGComingSoonPopupView.h"

@interface EGComingSoonPopupView ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation EGComingSoonPopupView

+ (void)showInView:(UIView *)view {
    EGComingSoonPopupView *popupView = [[EGComingSoonPopupView alloc] initWithFrame:view.bounds];
    [view addSubview:popupView];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
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
    self.contentView.layer.cornerRadius = 16;
    self.contentView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    [self.containerView addSubview:self.contentView];
    
    // 图标
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.image = [UIImage imageNamed:@"coming_soon"];
    self.iconImageView.layer.cornerRadius = ScaleW(50);
    self.iconImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.iconImageView];
    
    // 文本标签
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.text = @"現場活動，即將登場！";
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.textColor = rgba(23, 23, 23, 1);
    self.messageLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightMedium];
    [self.contentView addSubview:self.messageLabel];
    
    // 确定按钮
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmButton setTitle:@"確定" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.confirmButton.backgroundColor = rgba(0, 122, 96, 1);
    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightMedium];
    [self.confirmButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.confirmButton];
    
    // 布局
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(ScaleW(300));
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.containerView);
        make.height.mas_equalTo(ScaleW(240));
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView).offset(-ScaleW(20));
        make.width.height.mas_equalTo(ScaleW(100));
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(ScaleW(16));
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.containerView);
        make.height.mas_equalTo(ScaleW(60));
    }];
    
    // 添加动画
    self.containerView.transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.transform = CGAffineTransformIdentity;
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

@end