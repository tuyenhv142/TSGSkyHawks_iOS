@interface EGCircleRefreshHeader()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation EGCircleRefreshHeader

#pragma mark - 重写方法
- (void)prepare {
    [super prepare];
    
    // 初始化活动指示器
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    self.activityIndicator.color = rgba(0, 122, 96, 1);
    self.activityIndicator.hidesWhenStopped = YES;
    [self addSubview:self.activityIndicator];
}

- (void)placeSubviews {
    [super placeSubviews];
    
    // 设置活动指示器位置
    CGFloat centerX = self.mj_w * 0.5;
    CGFloat centerY = self.mj_h * 0.5;
    self.activityIndicator.center = CGPointMake(centerX, centerY);
}

#pragma mark - 监听控件的刷新状态
- (void)setState:(MJRefreshState)state {
    MJRefreshState oldState = self.state;
    [super setState:state];
    
    switch (state) {
        case MJRefreshStateIdle:
            if (oldState == MJRefreshStateRefreshing) {
                [self.activityIndicator stopAnimating];
            }
            break;
            
        case MJRefreshStatePulling:
            break;
            
        case MJRefreshStateRefreshing:
            [self.activityIndicator startAnimating];
            break;
            
        default:
            break;
    }
}

- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
    
    // 根据下拉进度控制指示器的透明度
    self.activityIndicator.alpha = pullingPercent;
}

@end