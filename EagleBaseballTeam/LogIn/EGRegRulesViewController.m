//
//  EGRegRulesViewController.m
//  EagleBaseballTeam
//
//  Created by rick on 3/31/25.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGRegRulesViewController.h"
//#import "EGPrivacyPolicyViewController.h"
#import <WebKit/WebKit.h>

@interface EGRegRulesViewController ()
@property (nonatomic,strong) WKWebView *wkWebView;
@end

@implementation EGRegRulesViewController

// 在 EGPointsRuleViewController.m 中添加 WebView 来显示 HTML 内容
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"註冊條款";
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    webView.scrollView.alwaysBounceHorizontal = NO;  // 禁止水平弹性滚动
    webView.scrollView.bounces = NO;  // 禁止弹性效果
    [self.view addSubview:webView];
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([UIDevice de_navigationFullHeight]);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    NSString *htmlString = @"<!DOCTYPE html>\
    <html lang='zh-TW'>\
    <head>\
        <meta charset='UTF-8'>\
        <meta name='viewport' content='width=device-width, initial-scale=1.0'>\
        <style>\
            body {\
                font-family: -apple-system, 'PingFang TC'\
                line-height: 2.0;\
                font-size: 16px;\
                margin: 0;\
                color: #333;\
                background-color: #ffffff;\
            overflow-x: hidden;\
                 width: 100%;\
                box-sizing: border-box;\
    -webkit-text-size-adjust: 100%;\
            }\
            h1, h2, .purpose-title {\
                font-family: 'PingFangTC-Semibold';\
                font-size: 17px;\
                color: #333;\
                font-weight: normal;\
                -webkit-text-size-adjust: none;\
                 padding-left: 16px;\
            }\
            h1 {\
               padding-left: 16px;\
            }\
            h2 {\
                padding-left: 16px;\
                padding-top: 8px;\
                padding-bottom: 8px;\
                background-color: rgba(245, 245, 245, 1);\
                width: 100vw;\
                position: relative;\
            }\
            p {\
                    padding-left: 16px;\
                    padding-right: 16px;\
                    margin-top: 20px;\
                }\
            .content {\
                width: 100%;\
                overflow-x: hidden;\
            }\
            .section {\
                margin-bottom: 20px;\
            }\
            .purpose-content {\
                margin: 0;\
            }\
            .purpose-content li {\
                margin-left: 16px;\
                margin-right: 16px;\
                margin-bottom: 8px;\
            }\
            .footer {\
                margin-top: 20px;\
                color: #333;\
                font-size: 16px;\
                    padding: 8px 16px;\
            }\
            .link {\
                color: rgba(0, 122, 96, 1);\
                text-decoration: none;\
                font-weight: bold;\
            }\
        </style>\
    </head>\
    <body>\
        <div class='content'>\
            <h1>註冊台鋼天鷹 APP 需要提供哪些資訊？</h1>\
            <p>感謝您註冊台鋼天鷹 APP！為了確保帳戶安全、提供完整的球迷服務，以及符合相關法規要求，我們需要您提供部分個人資訊。這些資訊將僅用於官方授權範圍內，並依照 <a href='privacy_policy' class='link'>台鋼天鷹隱私權政策</a> 及 <a href='terms_of_service' class='link'>服務條款</a> 進行保護與管理，不會用於未經授權的用途。</p>\
            <p>我們蒐集的資訊與其用途如下：</p>\
            <div class='section'>\
                <h2>一、身分證字號</h2>\
                <p class='purpose-title'>用途：</p>\
                <ul class='purpose-content'>\
                    <li>作為<strong>唯一識別資訊</strong>，確保每位會員的帳戶安全，防止重複註冊或冒用他人身份。</li>\
                    <li>確保您能順利使用 <strong>卡籍、票務、購物、會員點數</strong>等服務，並確保權益一致。</li>\
                    <li>遵循台灣購票實名制規範，確保票務安全與公平性。</li>\
                </ul>\
                <p class='purpose-title'>隱私保障：</p>\
                <ul class='purpose-content'>\
                    <li><strong>您的身分證字號不會公開顯示，亦不會提供給第三方</strong>，僅用於帳戶識別與官方用途。</li>\
                    <li>註冊後，<strong>該資訊無法修改</strong>，請確保輸入正確資訊。</li>\
                </ul>\
            </div>\
            \
            <div class='section'>\
                <h2>二、密碼</h2>\
                <p class='purpose-title'>用途：</p>\
                <ul class='purpose-content'>\
                    <li><strong>確保帳戶安全，防止未經授權的存取</strong>。</li>\
                    <li>允許您安全登入 APP，使用購票、購物及其他會員專屬服務。</li>\
                </ul>\
                <p class='purpose-title'>設定要求：</p>\
                <ul class='purpose-content'>\
                    <li>至少 8 個字元，建議包含英文字母、數字與符號的組合，以提升安全性。</li>\
                    <li><strong>請勿與其他平台使用相同密碼，</strong>避免潛在的資安風險。</li>\
                </ul>\
                    <p class='purpose-title'>隱私保障：</p>\
                    <ul class='purpose-content'>\
                        <li>密碼以加密方式儲存，不會被任何人直接存取或查看。</li>\
                        <li>忘記密碼時，可透過<strong>手機號碼</strong>進行重設。</li>\
                    </ul>\
            </div>\
            \
            <div class='section'>\
                <h2>三、手機號碼</h2>\
                <p class='purpose-title'>用途：</p>\
                <ul class='purpose-content'>\
                    <li>作為<strong>帳戶驗證機制<strong>，在註冊時發送</strong>驗證碼</strong>確保帳戶安全。</li>\
                    <li>用於<strong>密碼找回</strong>，當您忘記密碼時，可透過手機號碼進行重設。</li>\
                    <li>讓您即時收到 <strong>購票成功通知、交易提醒、會員權益資訊</strong>，不錯過重要消息。</li>\
                </ul>\
                    <p class='purpose-title'>隱私保障：</p>\
                    <ul class='purpose-content'>\
                        <li>除非您自行提供，否則您的手機號碼不會對外公開或與其他會員共享。</li>\
                        <li>註冊後，手機號碼可變更，但須重新驗證。</li>\
                    </ul>\
            </div>\
            \
            <div class='section'>\
                <h2>四、電子信箱</h2>\
                <p class='purpose-title'>用途：</p>\
                  <ul class='purpose-content'>\
                    <li>作為<strong>帳戶驗證與重要通知管道</strong>，確保您的帳戶資訊安全。</li>\
                    <li>用於 <strong>購票、購物、會員活動通知</strong>及官方優惠資訊的發送。</li>\
                </ul>\
                <p class='purpose-title'>隱私保障：</p>\
                <ul class='purpose-content'>\
                    <li><strong>您的電子信箱不會公開顯示，也不會提供給第三方使用</strong>。</li>\
                    <li>註冊後，<strong>信箱無法修改</strong>，請務必填寫常用的電子信箱。</li>\
                </ul>\
            </div>\
            \
            <div class='section'>\
                <h2>五、出生日期</h2>\
                 <p class='purpose-title'>用途：</p>\
                <ul class='purpose-content'>\
                    <li>確保符合 <strong>APP 年齡限制規範</strong>，部分服務可能對特定年齡層開放。</li>\
                    <li>作為<strong>會員專屬生日禮</strong>或<strong>特別活動邀請</strong>的依據，提供更個性化的服務。</li>\
                </ul>\
                <p class='purpose-title'>隱私保障：</p>\
                <ul class='purpose-content'>\
                    <li>除非您自行提供，否則您的出生日期不會對外公開或與其他會員共享。</li>\
                    <li>註冊後，該資訊<strong>無法修改</strong>，請確保填寫正確。</li>\
                </ul>\
            </div>\
            \
            <div class='section'>\
                <h2>六、性別</h2>\
                <p class='purpose-title'>用途：</p>\
                <ul class='purpose-content'>\
                    <li>讓我們提供更適合您的個人化內容與推薦。</li>\
                    <li>可能用於特定會員活動，讓您獲得更符合需求的專屬服務。</li>\
                </ul>\
                <p class='purpose-title'>隱私保障：</p>\
                <ul class='purpose-content'>\
                    <li>此資訊僅作為內部分析與服務優化，不會對外公開或與第三方共享。</li>\
                </ul>\
            </div>\
            \
            <div class='section'>\
                <p class='purpose-title'>隱私權保護承諾</p>\
                <ul class='purpose-content'>\
                    <li>我們不會將您的個人資訊提供給第三方，除非依法規要求或獲得您的同意。</li>\
                    <li>所有個人資訊均採取加密儲存，並符合 個人資料保護法及相關資安規範。</li>\
                    <li>您可隨時透過<a href='terms_of_service' class='link'>隱私權政策</a>了解更多資訊，並管理您的個人資料使用權限。</li>\
                </ul>\
            </div>\
            \
            <p class='footer'>若有任何疑問，請聯絡台鋼天鷹官方客服，我們將竭誠為您服務！</p>\
        </div>\
    </body>\
    </html>";
    
    [webView loadHTMLString:htmlString baseURL:nil];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *urlString = navigationAction.request.URL.absoluteString;
    
    if ([urlString containsString:@"privacy_policy"]) {
        // 跳转到隐私政策页面
        // TODO: 添加你的隐私政策页面跳转逻辑
//        EGPrivacyPolicyViewController *vc = [[EGPrivacyPolicyViewController alloc] init];
//           [self.navigationController pushViewController:vc animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    if ([urlString containsString:@"terms_of_service"]) {
        // 跳转到服务条款页面
        // TODO: 添加你的服务条款页面跳转逻辑
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
