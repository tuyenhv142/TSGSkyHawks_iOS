//
//  EGUserGuideViewController.m
//  EagleBaseballTeam
//
//  Created by rick on 3/21/25.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGUserGuideViewController.h"

@interface EGUserGuideViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation EGUserGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"使用導覽";
    self.view.backgroundColor = rgba(245, 245, 245, 1);
    // 创建scrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, Device_Height-[UIDevice de_navigationFullHeight]-[UIDevice de_safeDistanceBottom])];
//    self.scrollView.backgroundColor= [UIColor greenColor];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;  // 禁用垂直滚动条
    self.scrollView.bounces = NO;  // 禁用弹性效果 为了禁止上下滑动 必须添加
    self.scrollView.contentSize = CGSizeMake(Device_Width * 7, Device_Height-[UIDevice de_navigationFullHeight]-[UIDevice de_safeDistanceBottom]);
    [self.view addSubview:self.scrollView];
    
    // 让 ScrollView 的滑动手势在返回手势失败后触发
    UIGestureRecognizer *popGesture = self.navigationController.interactivePopGestureRecognizer;
    [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:popGesture];
    
    // 添加图片
    for (int i = 0; i < 7; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(Device_Width * i, 0, Device_Width, self.scrollView.frame.size.height)];
                NSString *imageName = [NSString stringWithFormat:@"3x_Useguide_%02d", i + 1];
        imageView.image = [UIImage imageNamed:imageName];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.scrollView addSubview:imageView];
    }
    
    // 创建pageControl
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.numberOfPages = 7;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = rgba(212, 212, 212, 1);
    self.pageControl.currentPageIndicatorTintColor = rgba(0, 121, 192, 1);
    [self.view addSubview:self.pageControl];
    
    // 设置pageControl约束
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-30);
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger currentPage = offsetX / scrollView.bounds.size.width;
    self.pageControl.currentPage = currentPage;
}

@end
