//
//  EGNavigationController.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/1/23.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGNavigationController.h"

@interface EGNavigationController ()<UINavigationControllerDelegate>

@end

@implementation EGNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.delegate = self;
    
//    UIFont *font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightBold];//[UIFont fontWithName:@"Arial-ItalicMT" size:21];
//    NSDictionary *dict = @{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor whiteColor]};
//    self.navigationBar.titleTextAttributes = dict;
    
    
    __weak typeof(self) weakself = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = (id)weakself;
    }
    
    if (@available(iOS 13.0, *)) {
//        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
//        [appearance configureWithOpaqueBackground];
//        appearance.backgroundColor = rgba(0, 71, 56, 1);
//        self.navigationBar.standardAppearance = appearance;
//        self.navigationBar.scrollEdgeAppearance = appearance;
//        NSDictionary *titleAttributes = @{
//            NSForegroundColorAttributeName: [UIColor whiteColor], // 字体颜色
//            NSFontAttributeName: [UIFont boldSystemFontOfSize:FontSize(16)] // 字体大小
//        };
//        [[UINavigationBar appearance] setTitleTextAttributes:titleAttributes];
        
    }else{
        
    }
    
    NSDictionary *titleAttributes = @{
        NSForegroundColorAttributeName: [UIColor whiteColor], // 字体颜色
        NSFontAttributeName: [UIFont boldSystemFontOfSize:FontSize(16)] // 字体大小
    };
    self.navigationBar.titleTextAttributes = titleAttributes;
//    self.navigationBar.backgroundColor = rgba(0, 71, 56, 1);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIGestureRecognizerDelegate
//这个方法是在手势将要激活前调用：返回YES允许右滑手势的激活，返回NO不允许右滑手势的激活
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
//        [self.navigationBar setBackgroundColor:nil];
        //屏蔽调用rootViewController的滑动返回手势，避免右滑返回手势引起死机问题
        if (self.viewControllers.count < 2 ||
            self.visibleViewController == [self.viewControllers objectAtIndex:0]) {
            return NO;
        }
    }
    //这里就是非右滑手势调用的方法啦，统一允许激活
    return YES;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0)
    {
        //[self.navigationBar setBackgroundColor:rgba(23, 43, 77, 1)];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"arrow-left"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBtnBack)];
        backItem.imageInsets = UIEdgeInsetsMake(4, -4, -4, 0);
        viewController.navigationItem.leftBarButtonItem = backItem;
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
-(void)clickBtnBack
{
    [self popViewControllerAnimated:YES];
}

@end
