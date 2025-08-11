//
//  EGPublicWebViewController.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/1/23.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGPublicWebViewController.h"

#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>

@interface EGPublicWebViewController ()

@property (nonatomic,strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation EGPublicWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)loadWebView
{
    //创建网页配置对象
//    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
//    config.selectionGranularity = WKSelectionGranularityDynamic;
//    config.allowsInlineMediaPlayback = YES;
//    
//    // 创建设置对象
//    WKPreferences *preference=[WKPreferences new];
//    preference.javaScriptEnabled = YES;
//    preference.javaScriptCanOpenWindowsAutomatically=YES;
//    
//    config.preferences = preference;
//    config.ignoresViewportScaleLimits=YES;
//    config.allowsPictureInPictureMediaPlayback=YES;
//    config.dataDetectorTypes=NO;
    
    
//        WKUserContentController *userCC = [WKUserContentController new];
//        //JS调用OC 添加处理脚本
//        [userCC addScriptMessageHandler:self name:@"funUploadCameraPhoto"];
//        [userCC addScriptMessageHandler:self name:@"funUploadFile"];
//        config.userContentController = userCC;
        
//    WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
////    wkWebView.UIDelegate = self;// UI代理
////    wkWebView.navigationDelegate = self;// 导航代理
////    wkWebView.scrollView.delegate = self;
////    wkWebView.scrollView.scrollEnabled = NO;
//    [self.view addSubview:wkWebView];
//    [wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo([UIDevice de_navigationFullHeight]);
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
//    }];
//    self.wkWebView = wkWebView;
    
}

- (WKWebView *)wkWebView
{
    if (!_wkWebView) {
        // Create configuration first
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.selectionGranularity = WKSelectionGranularityDynamic;
        config.allowsInlineMediaPlayback = YES;
        config.preferences.javaScriptEnabled = YES;
        config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        config.allowsPictureInPictureMediaPlayback = YES;
        
        // Initialize WKWebView with configuration
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
//        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_wkWebView];
        [_wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo([UIDevice de_navigationFullHeight]);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
        // Add progress observer
        [_wkWebView addObserver:self
                     forKeyPath:@"estimatedProgress"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
    }
    return _wkWebView;
}

- (void)setWebUrl:(NSString *)webUrl
{
    NSURL *nsurl = [[NSURL alloc] initWithString:webUrl];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [self.wkWebView loadRequest:nsrequest];
}

// 添加观察者方法
- (void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.wkWebView.estimatedProgress;
        if (self.progressView.progress == 1.0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.hidden = YES;
            });
        } else {
            self.progressView.hidden = NO;
        }
    }
}

// 添加进度条初始化和相关方法
- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.progressTintColor = rgba(0, 71, 56, 1);
        _progressView.trackTintColor = [UIColor clearColor];
        [self.view addSubview:_progressView];
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo([UIDevice de_navigationFullHeight]);
            make.height.mas_equalTo(2);
        }];
    }
    return _progressView;
}

// 在 dealloc 中移除观察者
- (void)dealloc {
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}
@end
