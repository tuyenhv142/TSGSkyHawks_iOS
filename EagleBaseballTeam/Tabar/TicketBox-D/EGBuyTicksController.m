//
//  ViewController.m
//  music
//
//  Created by Dragon_Zheng on 2/5/25.
//

#import "EGBuyTicksController.h"

#import "EGMainTabBarController.h"

@interface EGBuyTicksController ()<UITabBarControllerDelegate>


@property (nonatomic,strong)UIView *baseView;
@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,strong)UIButton *byticks;
@end

@implementation EGBuyTicksController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"";
    self.view.backgroundColor = rgba(243, 243, 243, 1);
//    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectZero];
//    [leftBtn setTitle:NSLocalizedString(@"票匣", nil) forState:(UIControlStateNormal)];
//    [leftBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [self setupUI];
    
    self.tabBarController.delegate = self;
    
    
//    NSString *message = @"即將開啟 台鋼雄鷹 FamiTicket";
//    [ELAlertController alertControllerWithTitleName:@"票匣" andMessage:message cancelButtonTitle:@"取消" confirmButtonTitle:@"確定開啟" showViewController:self addCancelClickBlock:^(UIAlertAction * _Nonnull cancelAction) {
//
//        } addConfirmClickBlock:^(UIAlertAction * _Nonnull SureAction) {
//            [self buyTickets];
//        }];
//    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
//    UIViewController *rootViewController = window.rootViewController;
//    EGMainTabBarController *tabBarController = (EGMainTabBarController *)rootViewController;
//    tabBarController.selectedIndex = 2;
}

-(void)setupUI
{
    
    EGPublicWebViewController *webVc = [[EGPublicWebViewController alloc] init];
        webVc.webUrl = @"https://ticket.tsgskyhawks.com";
    [self addChildViewController:webVc];
        webVc.view.frame = self.view.bounds;
    [self.view addSubview:webVc.view];
        [webVc didMoveToParentViewController:self];
//    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, Device_Height)];
//    bView.backgroundColor = rgba(245, 245, 245, 1);
//    [self.view addSubview:bView];
//    self.baseView = bView;
//
//
//    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], 160, 160)];
//    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
//    self.imgView.image =// [UIImage imageNamed:@"sendok"];
//    self.imgView.image =  [UIImage imageNamed:@"dialogTAKAO2"];
//    
//    [self.baseView addSubview:self.imgView];
//    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(ScaleW(100));
//        make.left.mas_equalTo(self.baseView.mas_centerX).offset(-120);
//        make.height.mas_equalTo(ScaleW(160));
//        make.width.mas_equalTo(Device_Width-ScaleW(160));
//    }];
//    
//    self.byticks = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
//    self.byticks.backgroundColor = rgba(0, 122, 96, 1);
//    [self.byticks addTarget:self action:@selector(buyTickets) forControlEvents:UIControlEventTouchUpInside];
//    self.byticks.titleLabel.font = [UIFont boldSystemFontOfSize:FontSize(18)];
//    [self.byticks setTitle:@"前往購票" forState:UIControlStateNormal];
//    [self.byticks setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
//    [self.baseView addSubview:self.byticks];
//    [self.byticks mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.imgView.mas_bottom).offset(FontSize(30));
//        make.left.mas_equalTo(self.baseView.mas_centerX).offset(-120);
//        make.height.mas_equalTo(ScaleW(45));
//        make.width.mas_equalTo(Device_Width-ScaleW(160));
//    }];
    
}

#pragma mark - UITabBarControllerDelegate

//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
//{
//    // 获取所有 viewControllers
//    NSArray *viewControllers = tabBarController.viewControllers;
//    // 检查是否点击的是第二个 tab
//    if ([viewControllers indexOfObject:viewController] == 3) {
//        // 手动选中第一个 tab
//        [tabBarController setSelectedIndex:2];
//        
//        NSString *message = @"即將開啟 台鋼雄鷹 FamiTicket";
//        [ELAlertController alertControllerWithTitleName:@"票匣" andMessage:message cancelButtonTitle:@"取消" confirmButtonTitle:@"確定開啟" showViewController:self addCancelClickBlock:^(UIAlertAction * _Nonnull cancelAction) {
//                
//            } addConfirmClickBlock:^(UIAlertAction * _Nonnull SureAction) {
//                [self buyTickets];
//            }];
//        // 在这里可以添加你想要在"点击"第二个 tab 时执行的代码
//        // 例如调用某个方法或显示某些内容
//        
//        return NO; // 阻止实际选中第二个 tab
//    }
//    
//    return YES; // 允许选中其他 tab
//}


-(void)buyTickets
{
    NSString *shopUrl = @"https://www.famiticket.com.tw/Home/Activity/Info/WgB5AFAAZwBSAG0ARgBJAFIAVABWAC8AYQBOAFEAdQAvAEkAZQA1AHcAdQBxAEIATgB3ADkAVgBvAG8AZAAzAG0AZgB2AEwARwAyAG4AQwB2AE4AQQA9AA2";
//    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:shopUrl]];
//    safariVC.delegate = self;
//    [self presentViewController:safariVC animated:YES completion:nil];
    [self openURL:@"" fallback:shopUrl];
}
- (void)openURL:(NSString *)appURL fallback:(NSString *)webURL
{
    NSURL *appSchemeURL = [NSURL URLWithString:appURL];
    NSURL *webFallbackURL = [NSURL URLWithString:webURL];
    
    [[UIApplication sharedApplication] openURL:appSchemeURL
                                     options:@{}
                           completionHandler:^(BOOL success) {
        if (!success) {
            [[UIApplication sharedApplication] openURL:webFallbackURL
                                            options:@{}
                                  completionHandler:nil];
        }
    }];
}
@end
