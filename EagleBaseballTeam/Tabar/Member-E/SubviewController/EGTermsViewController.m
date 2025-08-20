//
//  EGTermsViewController.m
//  EagleBaseballTeam
//
//  Created by rick on 4/3/25.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGTermsViewController.h"
#import <WebKit/WebKit.h>

@interface EGTermsViewController () <WKNavigationDelegate>
@property (nonatomic,strong) WKWebView *wkWebView;
@end

@implementation EGTermsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"使用者條款";
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    webView.scrollView.alwaysBounceHorizontal = NO;
    webView.scrollView.bounces = NO;
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([UIDevice de_navigationFullHeight]);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    NSString *htmlString;
    if ([self.navigationItem.title isEqualToString:@"使用者條款"]) {
        htmlString = @"<!DOCTYPE html>\
        <html lang='zh-TW'>\
        <head>\
            <meta charset='UTF-8'>\
            <meta name='viewport' content='width=device-width, initial-scale=1.0'>\
            <style>\
                        body {\
                            font-family: -apple-system, 'PingFang TC';\
                            line-height: 1.8;\
                            font-size: 15px;\
                            margin: 0;\
                            color: #333;\
                            background-color: #ffffff;\
                            overflow-x: hidden;\
                            width: 100%;\
                            box-sizing: border-box;\
                            -webkit-text-size-adjust: 100%;\
                        }\
                        h1 {\
                            font-family: 'PingFangTC-Semibold';\
                            font-size: 16px;\
                            color: #333;\
                            font-weight: normal;\
                            padding: 8px 16px;\
                            padding-top:16px;\
                            margin: 0;\
                        }\
                        h2 {\
                            font-family: 'PingFang TC';\
                            font-size: 15px;\
                            color: #333;\
                            font-weight: normal;\
                            padding: 8px 16px;\
                            margin: 0;\
                            line-height: 1.8;\
                        }\
                        p {\
                            font-family: 'PingFang TC';\
                            padding: 0 16px;\
                            margin: 0px 0;\
                            line-height: 1.8;\
                            font-size: 15px;\
                        }\
                        .content {\
                            width: 100%;\
                            overflow-x: hidden;\
                            padding-bottom: 16px;\
                        }\
                    ul {\
                        margin-left:8px;\
                        margin-right:16px;\
                        list-style-type: disc;\
                    }\
                    li {\
                        font-family: 'PingFang TC';\
                        font-size: 15px;\
                        line-height: 1.8;\
                        color: #333;\
                    }\
                    </style>\
        </head>\
        <body>\
            <div class='content'>\
                <h1>TSG SkyHawks 使用者條款</h1>\
                <p>歡迎您來到台鋼天鷹APP(以下簡稱本APP)，當您使用本APP時，即表示您已閱讀、瞭解並同意接受本APP之所有服務聲明之內容(包括但不限於服務聲明內容有任何修改或變更)。若您無法確實遵守服務聲明內容或對於服務聲明內容之全部或部份不同意時，請您立即停止使用本APP。若您未滿十八歲或無完全行為能力者，須經由您的法定代理人(監護人)閱讀、瞭解並同意服務聲明內容後，方得使用本APP所提供的服務；當您開始使用本APP所提供之服務時，則視為您的法定代理人(監護人)亦已閱讀、瞭解並同意服務聲明內容(包括但不限於服務聲明內容有任何修改或變更)。 </p>\
                <h2>一、本APP之廣告內容、文字、圖片說明、展示樣品或其他資訊等，均係各廣告商、產品與服務之供應商所提供，您應自行斟酌與判斷該廣告之可信度與真實性。 </h2>\
                <h2>二、本APP服務可能因故發生中斷或故障等現象，或許將造成您使用上的不便、資料喪失、錯誤、遭人篡改或其他包括但不限於經濟上之損失等情形，故您於使用本APP時應自行採取防護措施，且發生前述情事時，不論發生原因為何，本APP不負任何責任。 </h2>\
                <h2>三、本APP將依一般合理之技術及方式，維持本APP及服務之正常運作。若因相關之軟硬體設備需進行搬遷、更新、升級、保養或維修或依據法律、政府機關法令或主管機關要求，以及因天災或其他不可抗力事件、不可預期因素，導致本系統或設備有損壞、停止或中斷之情形，或因應公司組織變更或業務調整所需導致之系統停止或中斷，您明白並同意本APP得以暫停或終止APP之全部或部分，且本APP無須負任何責任。 </h2>\
                <h2>四、您在使用本系統之各項服務均受服務條款之規範，且必須保證絕不為任何非法目的或以任何非法方式瀏覽使用本APP服務，並不得利用本APP侵害他人權益或違法行為（包括但不限於公開張貼任何誹謗、侮辱、具威脅性、攻擊性、不雅、猥褻、不實、違反公共秩序或善良風俗或其他不法之文字、圖片等），違反者除應自負法律責任外，本APP有權依其單獨裁量逕行拒絕或移除任何您涉及違反服務聲明內容或法令規定之言論及圖文內容。 </h2>\
                <h2>五、除服務聲明內容已有之其他規範外，本APP服務及使用之風險是由您個人負擔，亦不對以下事項作出任何擔保或賠償。 </h2>\
                    <ul>\
                        <li>本APP之內容因有涉於不實、人身攻擊、毀謗，或引起任何爭議所造成之任何侵權、賠償。</li>\
                        <li>本APP或連結第三方之內容、資訊、產品、服務、軟體未符合您的需求。</li>\
                        <li>任何經由本APP或連結之第三方網站所購買或取得之任何商品及服務，未符合您的期望、毫無錯誤瑕疵、安全可靠。</li>\
                        <li>任何因瀏覽使用本APP所引發之以下情事，包括但不限於因下載行為而感染電腦病毒、排誘、毀損、版權或侵犯智慧財產權所造成的任何損失。</li>\
                        <li>本系統發生中斷或故障等現象。</li>\
                    </ul>\
                <h2>六、本APP所使用之軟體程式及本APP上所有內容，包括但不限於文字、圖片、檔案、資訊、網站架構、報導、專欄、照片、插圖、影像、錄音、畫面的安排、網頁設計等，均由台鋼天鷹排球隊股份有限公司（以下簡稱本公司）或其他權利人依法擁有其所有權與智慧財產權（包括但不限於商標權、專利權、著作權、營業秘密、及技術等），任何人與您不得逕自使用、修改、重製、公開播送、公開傳輸、公開演出、改作、散布、發行、公開發表、進行還原工程、解編、反向組譯或為任何違反法令之行為。 </h2>\
                <h2>七、若您欲引用或轉載前述軟體、程式或網站內容，除明確為法律所許可者外，必須依法取得台鋼天鷹排球隊股份有限公司或其他權利人的事前書面同意。尊重智慧財產權及法令規定是您應盡的義務，如有違反，您應對本公司或第三人負起民刑事法律責任。本APP為行銷宣傳服務內容，就服務內容相關之商品或服務名稱、圖樣等，依其註冊或使用之狀態，享有智慧財產權及相關法令規定之保護，在未經本公司事前書面許可或其他權利人授權之前，您同意不以任何方式使用。本系統上所刊載內容之圖片浮水印、商標或其他聲明，嚴禁更改或移除。 </h2>\
                <h2>八、您聲明及保證就本APP之使用及所有內容，僅限於供您個人、非商業用途之合理使用，否則您應另與本APP洽談授權合作事宜，且您保證使用、修改、重製、公開播送、改作、散布、發行、公開發表、公開傳輸、公開上映、翻譯、轉授權本系統之資料，不致侵害任何第三人之智慧財產權或任何權利。您違反任何服務聲明內容，致本APP受有任何損害時，您應對本APP負損害賠償責任（包括但不限於訴訟費用、鑑定費用、律師費用、本APP與第三人之和解金、賠償金等）。</h2>\
                <h2>九、若任何一服務條款無效，不影響其他條款之效力。您與本APP所引起之疑義、爭執或糾紛，雙方同意依中華民國法令解釋及規章為依據，以誠信原則解決之。 </h2>\
            </div>\
        </body>\
        </html>";
        
        [webView loadHTMLString:htmlString baseURL:nil];
        
    }else if ([self.navigationItem.title isEqualToString:@"隱私條款"]){
        htmlString =@"<!DOCTYPE html>\
            <html lang='zh-TW'>\
            <head>\
                <meta charset='UTF-8'>\
                <meta name='viewport' content='width=device-width, initial-scale=1.0'>\
                <style>\
                    body {\
                        font-family: -apple-system, 'PingFang TC';\
                        line-height: 1.6;\
                        font-size: 15px;\
                        margin: 0;\
                        color: #333;\
                        background-color: #ffffff;\
                        overflow-x: hidden;\
                        width: 100%;\
                        box-sizing: border-box;\
                        -webkit-text-size-adjust: 100%;\
                    }\
                    h1 {\
                        font-family: 'PingFangTC-Semibold';\
                        font-size: 16px;\
                        color: #333;\
                        font-weight: normal;\
                        padding: 0px 16px;\
                        padding-top: 20px;\
                        padding-bottom: 8px;\
                        margin: 0;\
                    }\
                    h2 {\
                        font-family: 'PingFangTC-Semibold';\
                        font-size: 15px;\
                        color: #333;\
                        font-weight: normal;\
                        padding: 12px 16px;\
                        margin: 0;\
                        line-height: 1.6;\
                        background-color: rgba(245, 245, 245, 1);\
                    }\
                    p {\
                        padding: 0 16px;\
                        margin: 12px 0;\
                        line-height: 1.6;\
                        font-size: 15px;\
                        font-family: 'PingFangTC';\
                    }\
                    .bold-title {\
                        font-family: 'PingFangTC-Semibold';\
                    }\
                    ul {\
                        margin: 0;\
                        padding: 0 32px;\
                        margin-left: 8px;\
                        list-style-type: disc;\
                    }\
                    li {\
                        font-family: 'PingFangTC';\
                        font-size: 15px;\
                        line-height: 1.6;\
                        margin-bottom: 8px;\
                        color: #333;\
                    }\
                    .content {\
                        width: 100%;\
                        overflow-x: hidden;\
                        padding-bottom: 16px;\
                    }\
                </style>\
            </head>\
            <body>\
                <div class='content'>\
                    <h1>台鋼天鷹會員註冊隱私權聲明</h1>\
                    <p>【使用本服務的同意條款與註冊義務】</p>\
                    <p>當會員（以下簡稱甲方）瀏覽或使用【台鋼天鷹官方APP】所提供之服務，即表示您已詳細閱讀並同意遵守以下所有規範及條款。</p>\
                    <h2>一、會員註冊與使用規範</h2>\
                    <p>當您註冊成為【台鋼天鷹 APP】會員（以下簡稱會員），即表示您已閱讀、理解並同意遵守本服務條款及隱私權政策之內容。</p>\
                    <p>會員須提供真實且完整的個人資料，包括但不限於姓名、身分證字號、出生年月日、聯絡電話、電子郵件等資訊，以供購票及商品購買實名制驗證之用。</p>\
                    <p>為保障會員權益及帳號安全，每一組有效的身分證字號及手機號碼僅能註冊一個會員帳號，帳號註冊後恕無法修改。</p>\
                    <p>若會員所提供資料經查證有不實、遺漏或未即時更新，台鋼天鷹有權暫停或終止會員帳號及服務，直至會員完成資料補正。</p>\
                    <p>會員有責任妥善保管帳號與密碼，若因個人管理不善、轉讓或出借帳號予他人而造成權益受損，須自行負責；若有發現帳號疑似遭他人盜用，請立即聯繫客服協助處理。</p>\
                    <h2>二、個人資料蒐集、處理及利用</h2>\
                    <p>為提供您完整的購票及商品購買服務，本 APP 將於下列情境中蒐集必要的個人資料：</p>\
                    <p class=bold-title>註冊資料：</p>\
                    <p>姓名、身分證字號、出生年月日、聯絡電話、電子郵件等，主要用於購票與商品訂購時的身分驗證（實名制）及會員專屬服務。</p>\
                    <p class=bold-title>購票與商品購買：</p>\
                    <p>基於票務系統及購物服務須符合實名制規範，會員進行購票或下單時，將再次確認身分證號與生日。</p>\
                    <p class=bold-title>參加活動與調查：</p>\
                    <p>參與抽獎、促銷、問卷等，依活動性質另行公告蒐集必要資料。</p>\
                    <p class=bold-title>一般瀏覽：</p>\
                    <p>系統將紀錄會員於 APP 內的瀏覽行為及操作紀錄（如 IP、裝置資訊、使用時間等）作為優化服務及用戶體驗之參考。</p>\
                    <h2>三、個人資料使用範圍</h2>\
                    <p class=bold-title>使用期間：</p>\
                    <p>會員帳號存續期間及法令或契約另有規定之保存期間</p>\
                    <p class=bold-title>使用區域：</p>\
                    <p>限於中華民國（台灣）地區及相關服務作業所必要之地區。</p>\
                    <p class=bold-title>使用對象：</p>\
                    <p>台鋼天鷹股份有限公司及其委託或合作之第三方（如票務、物流、金流、資訊處理等合作廠商）。</p>\
                    <p>前述第三方於受託範圍內得使用會員個人資料，惟須遵守個資法及本 APP 隱私政策。</p>\
                    <p class=bold-title>使用目的：</p>\
                     <ul>\
                                            <li>完成購票、訂單處理、活動參與及會員服務。</li>\
                                            <li>實名制驗證與會員權益保障。</li>\
                                            <li>內部數據分析與服務改善。</li>\
                                            <li>依法令規定或主管機關要求之其他用途。</li>\
                                        </ul>\
                    <h2>四、會員權利</h2>\
                    <p>依據個人資料保護法，會員得行使以下權利：</p>\
                    <ul>\
                                            <li>查詢、閱覽或請求複製所提供的個人資料。</li>\
                                            <li>請求補充、更正個人資料。</li>\
                                            <li>請求停止蒐集、處理或利用，或請求刪除個人資料，但依法應保存者不在此限。</li>\
                                        </ul>\
                    <p>若您欲行使上述權利，請聯繫本 APP 客服中心申請。</p>\
                    <h2>五、資料提供不足之影響</h2>\
                    <p>若會員選擇不提供必要的個人資料，或不同意提供給 APP 使用，將無法使用部分或全部與購票、商品購買、會員服務、活動參與相關之功能與權益。</p>\
                    <h2>六、兒童個人資料保護</h2>\
                    <p>本網站無意在未經兒童父母或未成年人之法定代理人同意前，向12歲以下兒童或未成年人蒐集任何個人資料，惟如任何十二歲以下兒童或未成年人自願於本網站加入會員或參加台鋼天鷹相關網路活動時，台鋼天鷹將因此取得該名兒童或未成年人所提供之姓名、地址及電話等會員或活動所需之資料（以下簡稱「兒童個人資料」）。關於所蒐集來的兒童個人資料，將僅限依據本隱私權聲明規定使用。台鋼天鷹提請家長對其子女在使用網際網路時個人訊息的使用進行監管和負責，如兒童或未成年人通過公告版或類似形式自願提供及公開的資料被他人使用或發放郵件，與本APP無關。</p>\
                </div>\
            </body>\
            </html>";
        
        [webView loadHTMLString:htmlString baseURL:nil];
        
    }else if ([self.navigationItem.title isEqualToString:@"註冊條款"]){
        
        NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
        if (htmlPath) {
            NSURL *url = [NSURL fileURLWithPath:htmlPath];
            [webView loadFileURL:url allowingReadAccessToURL:[url URLByDeletingLastPathComponent]];
        }
        
    }
   
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"buttonClicked"]) {
        NSLog(@"收到来自HTML的消息: %@", message.body);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"HTML按钮被点击" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
@end
