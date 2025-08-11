#import "EGCircleRefreshHeader.h"

@interface EGCircleRefreshHeader()



@end

@implementation EGCircleRefreshHeader

#pragma mark - 重写方法
- (void)prepare {
    [super prepare];
    
    // 初始化活动指示器
    if (@available(iOS 13.0, *)) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    } else {
        // Fallback on earlier versions
    }
//    self.activityIndicator.color = rgba(0, 122, 96, 1);
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

//下拉到一定程度时就立即触发刷新
//- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
//    [super scrollViewContentOffsetDidChange:change];
//    
//    // 获取当前下拉距离
//    CGFloat pullingPercent = self.pullingPercent;
//    
//    // 当下拉到 70% 时立即触发刷新
//    if (pullingPercent >= 0.7 && self.state == MJRefreshStateIdle) {
//        [self beginRefreshing];
//    }
//}

//- (void)beginRefreshing {
//    [super beginRefreshing];
//    
//    // 获取关联的 scrollView
//    UIScrollView *scrollView = self.scrollView;
//    
//    // 停止当前的拖拽
//    [scrollView setScrollEnabled:NO];
//    
//    // 使用动画让 tableView 回到刷新位置
//    [UIView animateWithDuration:0.25 animations:^{ 
//        scrollView.contentOffset = CGPointMake(0, -self.height);
//    } completion:^(BOOL finished) {
//        // 动画完成后重新启用滚动
//        [scrollView setScrollEnabled:YES];
//    }];
//}

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
            [self.activityIndicator startAnimating];
            break;
            
        case MJRefreshStateRefreshing:
            [self.activityIndicator startAnimating];
            break;
        case   MJRefreshStateWillRefresh:
            [self.activityIndicator startAnimating];
            break;
        default:
            break;
    }
}
//
//- (void)setPullingPercent:(CGFloat)pullingPercent {
//    [super setPullingPercent:pullingPercent];
//    
//    // 根据下拉进度控制指示器的透明度
//    self.activityIndicator.alpha = pullingPercent;
//}

@end
