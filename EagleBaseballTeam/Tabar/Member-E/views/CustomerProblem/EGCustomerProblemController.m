//
//  ViewController.m
//  music
//
//  Created by Dragon_Zheng on 2/5/25.
//

#import "EGCustomerProblemController.h"
#import <WebKit/WebKit.h>
@interface EGCustomerProblemController ()<WKNavigationDelegate>


@property (nonatomic,strong)UIView *baseView;
@property (nonatomic,strong)WKWebView *problemWKView;
@end

@implementation EGCustomerProblemController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"常見問題";
    [self setupUI];
}

-(void)setupUI
{
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, Device_Height)];
    bView.backgroundColor = rgba(245, 245, 245, 1);
    [self.view addSubview:bView];
    self.baseView = bView;
    
    // 修改 WKWebView 配置
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKPreferences *preferences = [[WKPreferences alloc] init];
    preferences.javaScriptEnabled = YES;
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    [preferences setValue:@YES forKey:@"allowFileAccessFromFileURLs"];
    config.preferences = preferences;
    
    // 添加用户脚本
    WKUserScript *script = [[WKUserScript alloc] initWithSource:@"localStorage.setItem('javascript-enabled', 'true');"
                                                  injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                               forMainFrameOnly:YES];
    [config.userContentController addUserScript:script];
    
    self.problemWKView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];


    [self.view addSubview:self.problemWKView];
    [self.problemWKView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([UIDevice de_navigationFullHeight]);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(Device_Width);
        make.height.mas_equalTo(Device_Height-[UIDevice de_navigationFullHeight]);
    }];
    
    NSURL *nsurl = [[NSURL alloc] initWithString:@"https://hawkmember.newretail.app/"];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [self.problemWKView loadRequest:nsrequest];
    self.problemWKView.navigationDelegate = self;
//    self.problemWKView.UIDelegate = self;
    
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    // 方法2：使用 JavaScript
      [webView evaluateJavaScript:@"window.scrollTo({top: 3850, behavior: 'smooth'});" completionHandler:nil];
    
//    [webView.scrollView setContentOffset:CGPointMake(0, 500) animated:YES];
//    // 延长等待时间，确保页面完全加载
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            NSString *scrollScript = @"function scrollToText() {"
//                                    "    const searchText = '贈品領取/出貨說明';"
//                                    "    let elements = Array.from(document.getElementsByTagName('*'));"
//                                    "    for (let element of elements) {"
//                                    "        if (element.textContent.includes(searchText)) {"
//                                    "            try {"
//                                    "                const rect = element.getBoundingClientRect();"
//                                    "                const scrollTop = window.pageYOffset + rect.top - (window.innerHeight / 2);"
//                                    "                window.scrollTo({"
//                                    "                    top: scrollTop,"
//                                    "                    behavior: 'smooth'"
//                                    "                });"
//                                    "                return { found: true, top: scrollTop };"
//                                    "            } catch (error) {"
//                                    "                return { found: true, error: error.toString() };"
//                                    "            }"
//                                    "        }"
//                                    "    }"
//                                    "    return { found: false };"
//                                    "}"
//                                    "scrollToText();";
//            
//            [webView evaluateJavaScript:scrollScript completionHandler:^(id result, NSError *error) {
//                if (error) {
//                    NSLog(@"滚动脚本执行错误：%@", error);
//                } else {
//                    NSLog(@"滚动执行结果：%@", result);
//                    // 如果 JS 滚动失败，尝试使用原生滚动
//                    if ([result isKindOfClass:[NSDictionary class]] &&
//                        [[result objectForKey:@"found"] boolValue]) {
//                        NSNumber *scrollTop = [result objectForKey:@"top"];
//                        if (scrollTop) {
//                            //fabsf([scrollTop floatValue]
//                            [webView.scrollView setContentOffset:CGPointMake(0, 377)
//                                                      animated:YES];
//                        }
//                    }
//                }
//            }];
//        });
}

@end
