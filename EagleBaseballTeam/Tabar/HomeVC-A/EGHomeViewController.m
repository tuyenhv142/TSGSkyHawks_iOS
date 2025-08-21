//
//  EGHomeViewController.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/1/21.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGHomeViewController.h"
#import <WebKit/WebKit.h>


#import "EGListCollectionViewCell.h"
#import "EGMessageViewController.h"

#import "EGEventScheduleView.h"
#import "EGEventListView.h"
#import "EGHotGoodsView.h"
#import "EGYoutubeView.h"
#import "EGYoutubeLiveView.h"
#import "EGNewMessageView.h"
#import "EGMessagesFBView.h"

#import "EGScheduleModel.h"
#import "ScheduleViewModel.h"

#import <SafariServices/SFSafariViewController.h>
#import <Network/Network.h>
#import "EGEagleFansWorldViewController.h"

@interface EGHomeViewController ()<UIScrollViewDelegate,HotGoodsViewDelegate,NewMessageViewDelegate,SFSafariViewControllerDelegate>
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIScrollView *baseScrollView;
@property (nonatomic,strong) UICollectionView *mainCollectionView;
@property (nonatomic,strong) ScheduleViewModel *viewModel;
@property (nonatomic,strong) EGEventScheduleView *header;
@property (nonatomic,strong) EGEventListView *list;
@property (nonatomic,strong) EGHotGoodsView *goods;
@property (nonatomic,strong) EGYoutubeView *youtube;
@property (nonatomic,strong) EGYoutubeLiveView *liveView;
@property (nonatomic,strong) EGNewMessageView *message;
@property (nonatomic,strong) EGMessagesFBView *messageFB;


@end

@implementation EGHomeViewController

- (ScheduleViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [ScheduleViewModel new];
    }
    return _viewModel;
}
- (UIScrollView *)baseScrollView
{
    if (!_baseScrollView) {
        _baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], self.view.frame.size.width, self.view.frame.size.height - ([UIDevice de_navigationFullHeight]+[UIDevice de_tabBarFullHeight]))];
        _baseScrollView.backgroundColor = rgba(243, 243, 243, 1);
        _baseScrollView.showsVerticalScrollIndicator = false;
        _baseScrollView.delegate = self;
    }
    return _baseScrollView;
}

//MARK: 下拉为绿色背景
// 实现 UIScrollViewDelegate 方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.baseScrollView) {
        if (scrollView.contentOffset.y < 0) {
            // 下拉时显示绿色背景
            self.baseScrollView.backgroundColor = rgba(0, 78, 162, 1);
        } else {
            // 上滑时显示灰色背景
            self.baseScrollView.backgroundColor = rgba(243, 243, 243, 1);
        }
    }
}

- (void)startMonitoringNetwork
{
    [ZYNetworkAccessibity setStateDidUpdateNotifier:^(ZYNetworkAccessibleState state) {
        if (state == ZYNetworkAccessible) {
            [self getAllData];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([EGLoginUserManager isLogIn]) {
        self.leftBtn.enabled = false;
    }else{
        self.leftBtn.enabled = true;
    }
    
    self.navigationItem.title = @"";
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(116), ScaleW(25))];
    // 创建容器视图
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(116), ScaleW(25))];
    containerView.backgroundColor = [UIColor clearColor];
    containerView.backgroundColor = [UIColor redColor];
    
    // 创建图片视图
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"TSG_Logo"];
    [containerView addSubview:imageView];
    
    // 使用 Masonry 设置图片视图约束
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(containerView).offset(ScaleW(-5));
        make.centerX.equalTo(containerView).offset(ScaleW(0));;
        make.width.mas_equalTo(ScaleW(116));
        make.height.mas_equalTo(ScaleW(25));
    }];
    
    self.navigationItem.titleView = containerView;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self startMonitoringNetwork];
    
    [self setSelfView];
    
    [self createAddViews];
    
    WS(weakSelf);
    EGCircleRefreshHeader *header = [EGCircleRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf getAllData];
        [weakSelf.baseScrollView.mj_header endRefreshing];
    }];
    header.activityIndicator.color = rgba(0, 121, 192, 1);
    self.baseScrollView.mj_header = header;
    
    self.viewModel.blockRecords = ^(EGScheduleModel * _Nonnull model) {
        [weakSelf.header setDataForModel:model];
    };
    
    if (![EGLoginUserManager isLogIn]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self goLogin];
        });
    }
//    [self getData];
}


-(void)setSelfView
{
    self.view.backgroundColor = rgba(243, 243, 243, 1);
    self.navigationItem.title = @"";
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    leftBtn.tag = 3;
    [leftBtn setTitle:NSLocalizedString(@"首頁 ", nil) forState:UIControlStateDisabled];
    [leftBtn setTitle:NSLocalizedString(@"登入", nil) forState:UIControlStateNormal];
    [leftBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [leftBtn setTitleColor:UIColor.whiteColor forState:UIControlStateDisabled];
    [leftBtn addTarget:self action:@selector(rightNavigationButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.leftBtn = leftBtn;
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [rightBtn setImage:[UIImage imageNamed:@"notify"] forState:UIControlStateNormal];
    [rightBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    rightBtn.tag = 2;
    [rightBtn addTarget:self action:@selector(rightNavigationButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemS = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    
//    UIButton *logInBtn = [[UIButton alloc]initWithFrame:CGRectZero];
//    logInBtn.tag = 1;
//    [logInBtn setImage:[UIImage imageNamed:@"logInTopBtn"] forState:UIControlStateNormal];
//    [logInBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
//    [logInBtn addTarget:self action:@selector(rightNavigationButton:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *itemF = [[UIBarButtonItem alloc]initWithCustomView:logInBtn];
    self.navigationItem.rightBarButtonItems = @[itemS];
    
    
}
-(void)rightNavigationButton:(UIButton *)sender
{
    if (![EGLoginUserManager isLogIn]) {
        [self goLogin];
    }else{
        if (sender.tag == 2) {
            EGMessageViewController *message = [EGMessageViewController new];
            [self.navigationController pushViewController:message animated:true];
        }
    }
}

-(void)goLogin
{
    EGNavigationController *nav = [[EGNavigationController alloc] initWithRootViewController:[EGLogInViewController new]];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    nav.navigationBar.backgroundColor = rgba(0, 78, 162, 1);
    [self presentViewController:nav animated:true completion:^{
    }];
}

-(void)createAddViews
{
    CGFloat HH = 190 + 288 + 510 + 271 + 271 + 298 /*+ 298*/ + 80;
    [self.view addSubview:self.baseScrollView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.baseScrollView setContentSize:CGSizeMake(Device_Width, ScaleW(HH))];
    });
    
    EGEventScheduleView *header = [[EGEventScheduleView alloc] initWithFrame:CGRectZero];
    header.reviewBlock = ^(EGScheduleModel * _Nonnull model, NSInteger type) {
        if (type == 0) {
            
            EGEagleFansWorldViewController *photoVC = [[EGEagleFansWorldViewController alloc] init];
            [self.navigationController pushViewController:photoVC animated:true];
            
        }else{
            
//            NSString *year = [model.GameDateTimeS substringToIndex:4];
//            NSString *shopUrl = [NSString stringWithFormat:@"https://www.cpbl.com.tw/box?year=%@&kindCode=%@&gameSno=%ld",model.GameSno];
//            SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:shopUrl]];
//            safariVC.delegate = self;
//            [self presentViewController:safariVC animated:YES completion:nil];
        }
    };
    [self.baseScrollView addSubview:header];
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(Device_Width);
        make.height.mas_equalTo(ScaleW(190));
    }];
    self.header = header;

    
    EGEventListView *list = [[EGEventListView alloc] initWithFrame:CGRectZero];
    list.backgroundColor= rgba(243, 243, 243, 1);
    [self.baseScrollView addSubview:list];
    self.list = list;
    [list mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(header.mas_bottom);
        make.width.mas_equalTo(Device_Width);
        make.height.mas_equalTo(ScaleW(308));
    }];
    
    EGHotGoodsView *hot = [[EGHotGoodsView alloc] initWithFrame:CGRectZero];
    hot.backgroundColor= rgba(243, 243, 243, 1);
    hot.delegate = self;
    [self.baseScrollView addSubview:hot];
    self.goods = hot;
    [hot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(list.mas_bottom).offset(ScaleW(0));
        make.width.mas_equalTo(Device_Width);
        make.height.mas_equalTo(ScaleW(540));
    }];
   
    
    EGYoutubeView *youTube = [[EGYoutubeView alloc] initWithFrame:CGRectZero];
    youTube.backgroundColor= rgba(243, 243, 243, 1);
    [self.baseScrollView addSubview:youTube];
    self.youtube = youTube;
    [youTube mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(hot.mas_bottom).offset(ScaleW(0));
        make.width.mas_equalTo(Device_Width);
        make.height.mas_equalTo(ScaleW(271));
    }];
    
    self.liveView = [[EGYoutubeLiveView alloc] initWithFrame:CGRectZero];
    self.liveView.backgroundColor= rgba(243, 243, 243, 1);
    [self.baseScrollView addSubview:self.liveView];
    [self.liveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(youTube.mas_bottom).offset(ScaleW(0));
        make.width.mas_equalTo(Device_Width);
        make.height.mas_equalTo(ScaleW(271));
    }];
    
    EGNewMessageView *message = [[EGNewMessageView alloc] initWithFrame:CGRectZero];
    message.backgroundColor= rgba(243, 243, 243, 1);
    message.delegate = self;
    [self.baseScrollView addSubview:message];
    self.message = message;
    [message mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(self.liveView.mas_bottom).offset(ScaleW(0));
        make.width.mas_equalTo(Device_Width);
        make.height.mas_equalTo(ScaleW(298));
    }];
    
//    self.messageFB = [[EGMessagesFBView alloc] initWithFrame:CGRectZero];
//    self.messageFB.backgroundColor= rgba(243, 243, 243, 1);
////    self.messageFB.delegate = self;
//    [self.baseScrollView addSubview:self.messageFB];
//    [self.messageFB mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(0);
//        make.top.equalTo(message.mas_bottom).offset(ScaleW(0));
//        make.width.mas_equalTo(Device_Width);
//        make.height.mas_equalTo(ScaleW(298));
//    }];
}

#pragma mark --- 获取所有数据
-(void)getAllData
{
    [self getData];
    [self.goods getHotGoodsData];
    [self.message getDataForTsghawks];
    [self.youtube fetchYouTubeVideos];
    [self.liveView fetchYouTubeLives];
}
#pragma mark --- 获取赛程相关数据
-(void)getData
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *year = [formatter stringFromDate:[NSDate date]];
    WS(weakSelf);
    [self.viewModel getScheduleData:year Completion:^(NSError * _Nonnull error, NSArray * _Nonnull array) {
        if (!error) {
            [weakSelf.list setDatas:array];
            
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - delegate
- (void)clickHotGoodsForItem:(NSString *)goodsID
{
//    EGPublicWebViewController *webVc = [[EGPublicWebViewController alloc] init];
//    webVc.navigationItem.title = @"購物商城";
//    if ([goodsID isEqualToString:@"more"]) {
//        webVc.webUrl = @"https://www.tsghawks.com/shop/";
//    }else{
//        webVc.webUrl = goodsID;
//    }
//    [self.navigationController pushViewController:webVc animated:true];
    
    NSString *urlStr;
    if ([goodsID isEqualToString:@"more"]) {
        urlStr = @"https://www.tsgskyhawks.com/categories/%E6%9C%80%E6%96%B0%E5%95%86%E5%93%81";
    }else{
        urlStr = goodsID;
    }
    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:urlStr ? urlStr : @"https://www.tsgskyhawks.com/categories/%E6%9C%80%E6%96%B0%E5%95%86%E5%93%81"]];
    safariVC.delegate = self;
    [self presentViewController:safariVC animated:YES completion:nil];
    
//    [self openURL:@"YOUR_APP_SCHEME://shop" fallback:urlStr];
    
}

- (void)clickNewMessageForItem:(NSString *)newId
{
    EGPublicWebViewController *webVc = [[EGPublicWebViewController alloc] init];
    webVc.navigationItem.title = @"最新消息";
    if ([newId isEqualToString:@"more"]) {
        webVc.webUrl = @"https://20.189.240.127/news/";
    }else{
        webVc.webUrl = newId;
    }
    [self.navigationController pushViewController:webVc animated:true];
}

- (void)webView:(WKWebView *)webView        //cho phép ssl ko hợp lệ
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *credential = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
    } else {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
////    NSURL *url = [NSURL URLWithString:@"youtube://"];
//    NSString *title = @"下午茶";
//    NSString *notes = @"下午四点半请我喝杯茶";
//    NSString *urlString = [NSString stringWithFormat:@"x-apple/reminders://?to=todo&title=%@&notes=%@", title, notes];
//    NSURL *url = [NSURL URLWithString:@"x-apple/reminders:"];
////    NSURL *url = [NSURL URLWithString:@"reminders:list/1234-5678-90AB-CDEFGHIJ/"];
//    
//    if([[UIApplication sharedApplication] canOpenURL:url])
//    {
//        [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@(false)} completionHandler:nil];
//        
//    }else {
////        [self presentViewController:[UIRemoteNotificationManager sharedInstance].presentRemindersAlertController animated:YES completion:nil];
//    }
}

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    //当用户添加事件成功后，关闭safariVC
    [controller dismissViewControllerAnimated:YES completion:nil];
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
