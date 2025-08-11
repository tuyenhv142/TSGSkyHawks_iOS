#import "EGMembershipLevelViewController.h"
#import "EGMembershipContentView.h"

@interface EGMembershipScrollView ()

@end

@implementation EGMembershipScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.panGestureRecognizer.delegate = self;
    }
    return self;
}


//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    if (self.contentOffset.x <= 0) {
//        return NO;
//    }
//    return YES;
//}
//
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    if (self.contentOffset.x <= 0) {
//        return NO;
//    }
//    return YES;
//}
//#pragma mark - UIGestureRecognizerDelegate
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    // 判断 otherGestureRecognizer 是不是系统 POP 手势
//    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
//        // 判断 POP 手势的状态是 begin 还是 fail，同时判断 scrollView 的 ContentOffset.x 是不是在最左边
//        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.contentOffset.x == 0) {
//            return YES;
//        }
//    }
//    return NO;
//}
@end


@interface EGMembershipLevelViewController () <UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *buttonContainerView;
@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) UIView *sliderLabel;
@property (nonatomic, strong) EGMembershipScrollView *scrollView;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) BOOL isUserScrolling;  // 添加标记区分用户滑动和按钮点击

@property (nonatomic, strong) NSMutableArray *containMember;
// 添加属性声明
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactivePopTransition;

@end

@implementation EGMembershipLevelViewController
- (NSMutableArray *)containMember{
    if (!_containMember) {
        _containMember = [NSMutableArray arrayWithArray:@[@1,@0,@0,@0]];
    }
    return _containMember;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if (self.MemberCards){
        NSString *MemberTypeId;
        for (NSDictionary *dict in self.MemberCards) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                MemberTypeId = [dict objectOrNilForKey:@"MemberTypeId"];
                if ([MemberTypeId isEqualToString:@"A001"]) {
                    [self.containMember replaceObjectAtIndex:3 withObject:@0];
                }else if([MemberTypeId isEqualToString:@"A002"]){
                    [self.containMember replaceObjectAtIndex:2 withObject:@0];
                }else if([MemberTypeId isEqualToString:@"A003"]){
                    [self.containMember replaceObjectAtIndex:1 withObject:@0];
                }else if([MemberTypeId isEqualToString:@"A004"]){
                    [self.containMember replaceObjectAtIndex:0 withObject:@0];
                }else {

                }
            }
        }
    }
    [self updateContentViewsWithMemberInfo];
}


// 添加新方法用于更新内容
- (void)updateContentViewsWithMemberInfo {
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[EGMembershipContentView class]]) {
            EGMembershipContentView *contentView = (EGMembershipContentView *)obj;
            id info = self.containMember[idx];
            [contentView setContentInfo:info];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"鷹國會員";
    
    [self setupUI];
    self.scrollView.bounces = YES;
    
    // 让 ScrollView 的滑动手势在返回手势失败后触发 右滑可返回
    UIGestureRecognizer *popGesture = self.navigationController.interactivePopGestureRecognizer;
    [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:popGesture];
}


- (void)setupUI {
    // 按钮容器视图
    self.buttonContainerView = [[UIView alloc] init];
    _buttonContainerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.buttonContainerView];
     
  
    
    [self.buttonContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset([UIDevice de_navigationFullHeight]-1);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(52);
    }];
    
 
    
    // 创建按钮
    NSArray *titles = @[@"鷹國人", @"Takao 親子", @"鷹國尊爵", @"鷹國皇家"];
    NSMutableArray *btns = [NSMutableArray array];
    CGFloat buttonWidth = UIScreen.mainScreen.bounds.size.width / titles.count;
    
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
        [button setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateSelected];
//        button.adjustsImageWhenHighlighted = NO;
        button.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonContainerView addSubview:button];
        [btns addObject:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.buttonContainerView);
            make.width.mas_equalTo(buttonWidth);
//            make.height.mas_equalTo(44);
            make.left.equalTo(self.buttonContainerView).offset(i * buttonWidth);
        }];
    }
    self.buttons = btns;
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = rgba(212, 212, 212, 1);
    [self.buttonContainerView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.buttonContainerView);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(1.5);
    }];
    
    // 滑块指示器
    self.sliderLabel = [[UIView alloc] init];
    self.sliderLabel.backgroundColor = rgba(0, 122, 96, 1); //rgba(0, 122, 96, 1)
    [self.buttonContainerView addSubview:self.sliderLabel];
    
    [self.sliderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.buttonContainerView);
        make.width.mas_equalTo(buttonWidth);
        make.height.mas_equalTo(ScaleW(4));
        make.left.equalTo(self.buttonContainerView);
    }];
    
  
    
    // 滚动视图
    self.scrollView = [[EGMembershipScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor colorWithRed:0.962 green:0.962 blue:0.962 alpha:1.0];

    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
  
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:self.scrollView];
    

    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buttonContainerView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    self.scrollView.contentSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width * 4, 0);
    
    // 添加内容视图
    for (NSInteger i = 0; i < titles.count; i++) {
        EGMembershipContentView *contentView = [[EGMembershipContentView alloc] initWithMembershipType:i];
        contentView.backgroundColor = [UIColor colorWithRed:0.962 green:0.962 blue:0.962 alpha:1.0];
        [self.scrollView addSubview:contentView];
                
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.scrollView);
            make.width.equalTo(@(UIScreen.mainScreen.bounds.size.width));
            make.height.mas_equalTo(self.scrollView);
            if (i == 0) {
                make.left.equalTo(self.scrollView);
            } else {
                UIView *previousView = [self.scrollView.subviews objectAtIndex:i-1];
                make.left.equalTo(previousView.mas_right);
            }
            if (i == titles.count - 1) {
                make.right.equalTo(self.scrollView);
            }
        }];
        
        if (i == 0) {
            [self setupFirstPageUI:contentView];
        }else if (i == 1) {
           // contentView.backgroundColor = [UIColor yellowColor];
        }else if (i == 2) {
           // contentView.backgroundColor = [UIColor orangeColor];
        }
    }

    // 设置初始选中状态
    [self updateSelectedButton:0];
}

- (void)setupFirstPageUI:(UIView *)contentView {
    // 在这里添加第一个页面的 UI 元素
}

- (void)buttonTapped:(UIButton *)sender {
    self.isUserScrolling = NO;  // 标记为按钮点击
    [self updateSelectedButton:sender.tag];
    [self.scrollView setContentOffset:CGPointMake(sender.tag * UIScreen.mainScreen.bounds.size.width, 0) animated:YES];

}

- (void)updateSelectedButton:(NSInteger)index {
    self.currentIndex = index;
    
    [self.buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        button.selected = (idx == index);
//        button.titleLabel.font = button.selected ?
//                  [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold] :
//                  [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    }];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.sliderLabel.transform = CGAffineTransformMakeTranslation(index * (UIScreen.mainScreen.bounds.size.width / self.buttons.count), 0);
    }];
    
   
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.isUserScrolling) {  // 只在用户滑动时更新
            NSInteger index = scrollView.contentOffset.x / UIScreen.mainScreen.bounds.size.width;
            [self updateSelectedButton:index];
        }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isUserScrolling = YES;  // 标记为用户滑动
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.isUserScrolling) return;  // 非用户滑动时不更新滑块位置
    
    CGFloat pageWidth = scrollView.frame.size.width;
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat progress = offsetX / pageWidth;
    
    // 更新滑块位置
    CGFloat buttonWidth = UIScreen.mainScreen.bounds.size.width / self.buttons.count;
    self.sliderLabel.transform = CGAffineTransformMakeTranslation(progress * buttonWidth, 0);
    
    if (offsetX <= 0) {
        // 当滚动到最左侧时，启用系统返回手势
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//        [self.navigationController popViewControllerAnimated:YES];
    } else {
        // 当在滚动过程中，禁用系统返回手势
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
