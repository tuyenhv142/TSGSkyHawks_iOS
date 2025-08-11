#import "EGPointsRuleViewController.h"

@interface EGPointsRuleViewController ()

@end

@implementation EGPointsRuleViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    // 设置导航栏颜色
       [UIView animateWithDuration:0.3 animations:^{
           self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
       }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.962 green:0.962 blue:0.962 alpha:1.0];
    self.navigationItem.title = @"點數辦法";
    
    // 创建滚动视图
    UIScrollView *scrollView = [[UIScrollView alloc] init];
//    scrollView.backgroundColor = [UIColor colorWithRed:0.962 green:0.962 blue:0.962 alpha:1.0];
    [self.view addSubview:scrollView];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-ScaleW(20));
        make.left.mas_equalTo(ScaleW(20));
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo([UIDevice de_navigationFullHeight]);
//        make.edges.equalTo(self.view);
    }];
    scrollView.showsVerticalScrollIndicator = NO;
    // 内容视图
    UIView *contentView = [[UIView alloc] init];
//    contentView.backgroundColor =  [UIColor redColor];
    [scrollView addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
//        make.height.equalTo(scrollView);
//        make.bottom.mas_equalTo(scrollView);
        
    }];
    
    NSArray *Array =@[@{@"title":@"點數辦法：",
                        @"subtitles":@[],
                        @"contents":@[@"天鷹點數為台鋼天鷹 APP (以下簡稱本程式)內提供之獎勵點數，鼓勵消費者免費下載本程式註冊使用，在依照本程式內說明完成相關任務指定條件後，即可累積點數兌換限量贈品、活動報名或抽獎券。 "],
                        @"numContents":@[
                            @"消費者可免費下載本程式並註冊使用，每組帳號均需綁定一組身分證號碼(外籍人士可使用居留證號碼)及行動電話號碼。身分證字號(或居留證號碼)與會員生日經註冊後即不得更改，其餘資料可透過本程式會員中心自行修改調整。",
                            @"如欲申辦付費會員，需先註冊免費會員後方可進行申辦。 ",
                            @"如欲刪除帳號結束使用本程式，請透過本程式內會員資料中刪除帳號功能進行。帳號一經刪除後即無法再次要求回復原有資料，所有點數及兌換資料均無法回朔。後續如欲再次使用本程式請重新申請。"
                        ]},
                      @{@"title":@"點數說明：",
                        @"subtitles":@[],
                        @"contents":@[],
                        @"numContents":@[
                            @"本 APP 提供之點數均有時效性，每年依照公告時間重新計算會員點數。該年度未使用之點數將全數歸零，未領取之贈品、服務及未參加之活動等相關兌換均視為放棄領取，不得要求任何補償保留。\n\n點數任務發放期限：2025 年 12 月 31 日截止 \n點數贈品兌換期限：2026 年 02 月 02 日截止 ",
                            @"凡完成本程式相關任務後、點數將於 24 小時內發放完成(特殊任務不在此限，以任務內文字說明為主) ",
                            @"獲得之點數限該帳號會員本人使用，不可移轉、合併或以任何形式進行銷售。 "
                        ]},
                      @{@"title":@"任務說明：",
                        @"contents":@[@"一、本程式內提供之各式點數任務，請參考任務內說明文字進行。每個任務同一會員帳號及行動裝置每日僅計算一次(消費型任務除外)，恕不接受申請追溯或補登次數。任務僅限會員本人完成。\n\n二、台鋼天鷹主場例行賽事相關之每日任務，在賽事結束後依照實際賽況給予不同點數獎勵。各任務均為獨立事件，易可同時達成(如和局與延長賽)。依類別區分說明如下： "],
                        @"subtitles":@[@"會員專屬任務",@"每日任務",@"限時任務"],
                        @"numContents":@[
                            @"需先申辦付費會員，即可增加會員專屬任務，每一會員帳號不限申辦一個會員資格，詳細內容可查看任務說明。 ",
                            @[@"須購買台鋼天鷹主場內野門票並至球場內野指定感應區，透過個人行動裝置(需開啟藍芽、定位與APP權限)開啟本程式，即可完成每日任務｢鷹雄軍報到｣。系統將自動觸發指定日期進場任務(空投給點)及累積成就勳章進場次數。",
                             @"同一帳號及裝置每場限計算一次，如同一裝置以多帳號登入，僅限當日第一個帳號可感應觸發。場次紀錄恕不接受事後補登，如現場未能完成感應，請於當日離場前置球迷服務台進行確認，離場後恕無法提供補登服務。",
                            @"｢比賽結果(如:勝敗和)｣、｢賽事內容(如天鷹無失誤等)｣類須先完成每日任務｢鷹雄軍報到｣後，系統將於當天23:59前依據比賽內容、結果、日期等條件，自動進行計算累積給點(非賽後即時)。未於當日完成該場賽事｢每日任務-鷹雄軍報到｣者，將無法成功觸發本任務。 ",
                            @"當日於台鋼天鷹球場實體店面消費，結帳前須出示本程式會員條碼，系統將於隔日自動累積消費金額，若達成任務指定消費，將給予對應點數。 "],
                            @[@"不定時發布限時任務，依照任務說明完成後將另以人工方式空投給點、掃碼給點或即時給點(特殊任務將另以任務內文字說明為準)，請隨時關注台鋼天鷹APP或開啟推播通知已獲得額外點數回饋。",
                            @"於台鋼天鷹實體店面消費，結帳前須出示本程式會員條碼，系統將於隔日自動累積年度消費金額，若達成任務指定消費，將給予對應點數。 "]
                        ]},
                      @{@"title":@"其他說明：",
                        @"contents":@[@""],
                        @"subtitles":@[@""],
                        @"numContents":@[
                            @"凡持中華職棒大聯盟或台鋼天鷹球團核發證件之球場從業人員及其親屬、使用無價票券及台鋼天鷹全體員工，均不得兌換、參加本點數相關贈品及活動。 ",
                            @"凡參與積點活動之會員，須保證過程中所填寫或提出之資料均正確無誤。若以大量創建帳號、冒用或盜用他人資料、資料不正確、使用惡意電腦程式或其他任何違反點數任務說明及影響公平性之方式完成任務、進行點數蒐集或贈品兌換者，台鋼天鷹球團得凍結該會員帳號及取消其所獲得之點數與使用權利。 ",
//                            @"如有點數相關疑問，請洽現場球迷服務台工作人員或透過APP內聯絡客服功能詢問。 ",
                            @"會員權益（含購物折扣及消費回饋點數）僅限會員本人使用，恕無法以任何方式轉讓或轉借予他人。如有發現上述行為本公司保留將不當紅利點數積點扣除及終止會員卡權益之權利。如有點數相關疑問，請洽現場球迷服務台工作人員或透過APP內聯絡客服功能詢問。",
                            @"台鋼天鷹保留隨時增訂、修改、解釋與中指本辦法之權利，並以官方公告為準，不另個別通知",
                            @"本程式提供之各項功能受使用者行動裝置之廠牌、軟體系統版本、網路狀態、定位狀態、低功耗藍牙、藍牙的無線通訊特性、以及其他可能之第三方應用程式影響，因此無法保證所有使用者之行動裝置於任何情境下皆可正常使用本系統所有的功能。 "
                        ]}
    ];
    UIView *previousView = nil;
    for (NSDictionary * model in Array) {
        //就一个
        UIView *ruleView = [self createContentViewWithTitle:[model objectForKey:@"title"]
                                                 subtitles:[model objectForKey:@"subtitles"]
                                                 contents:[model objectForKey:@"contents"]
                                            numberContents:[model objectForKey:@"numContents"]];
//        ruleView.backgroundColor = [UIColor redColor];
        [contentView addSubview:ruleView];

        [ruleView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (previousView) {
                make.top.equalTo(previousView.mas_bottom).offset(ScaleW(16));
            } else {
                make.top.equalTo(contentView).offset(ScaleW(16));
            }
            make.left.right.equalTo(contentView);
        }];
        
        previousView = ruleView;
    }
    
    // 设置 contentView 的底部约束
    if (previousView) {
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(previousView.mas_bottom).offset(ScaleW(16));
        }];
    }
}

// 生成规则内容视图
- (UIView *)createContentViewWithTitle:(NSString *)title
                            subtitles:(NSArray<NSString *> *)subtitles
                            contents:(NSArray<NSString *> *)contents
                       numberContents:(NSArray *)numberContents {
    UIView *containerView = [[UIView alloc] init];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightSemibold];
    titleLabel.textColor = rgba(0, 78, 162, 1);
    [containerView addSubview:titleLabel];
//    titleLabel.backgroundColor = [UIColor redColor];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(containerView);
    }];
    
    UIView *lastView = titleLabel;
    NSInteger contentIndex = 0;

    // 添加contentIndex的内容
    
    while (contentIndex < contents.count) {
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.text = contents[contentIndex];
        contentLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
        contentLabel.textColor = rgba(38, 38, 38, 1);
        contentLabel.numberOfLines = 0;
        [containerView addSubview:contentLabel];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if ([contents[contentIndex] isEqualToString:@""]) {
                make.top.equalTo(lastView.mas_bottom).offset(0);
            }else{
                make.top.equalTo(lastView.mas_bottom).offset(ScaleW(12));
            }

            make.left.right.equalTo(containerView);
        }];
        
        lastView = contentLabel;
        contentIndex++;
    }
    
    
    // 添加带序号的内容
    for (NSInteger i = 0; i < numberContents.count; i++) {
        NSString *subtitle = (i < subtitles.count) ? subtitles[i] : @"";
        UIView *itemView;
  
        itemView = [self createItemViewWithNumber:(i + 1)
                                                text:numberContents[i]
                                            subtitle:subtitle];
//        itemView.backgroundColor  = [UIColor greenColor];
        [containerView addSubview:itemView];
        
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastView.mas_bottom).offset(ScaleW(12));
            make.left.right.equalTo(containerView);
        }];
        
        lastView = itemView;
    }
       
    
    // 设置容器视图的底部约束
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView.mas_bottom);
    }];
    
    return containerView;
}


// 生成单个条目的视图
- (UIView *)createItemViewWithNumber:(NSInteger)number text:(id )text subtitle:(NSString *)subtitle {
    UIView *containerView = [[UIView alloc] init];
    
    // 序号标签
    UILabel *numberLabel = [[UILabel alloc] init];
    numberLabel.text = [NSString stringWithFormat:@"%ld.", (long)number];
    numberLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
    numberLabel.textColor = rgba(38, 38, 38, 1);
    [containerView addSubview:numberLabel];
    
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(containerView);
        make.width.mas_equalTo(ScaleW(15));
    }];
    
    UIView *lastView = numberLabel;
    
    // 如果有副标题，添加副标题标签
    if (subtitle.length > 0) {
        UILabel *subtitleLabel = [[UILabel alloc] init];
        subtitleLabel.text = subtitle;
        subtitleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
        subtitleLabel.textColor = rgba(38, 38, 38, 1);
        subtitleLabel.numberOfLines = 0;
        
        numberLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
        [containerView addSubview:subtitleLabel];
        
        [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastView);
            make.left.equalTo(numberLabel.mas_right).offset(ScaleW(4));
            make.right.equalTo(containerView);
        }];
        
        lastView = subtitleLabel;
    }
    
    // 内容标签
    if ([text isKindOfClass:[NSString class]]) {
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.text = text;
        contentLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
        contentLabel.textColor = rgba(38, 38, 38, 1);
        contentLabel.numberOfLines = 0;
        [containerView addSubview:contentLabel];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (subtitle.length > 0) {
                make.top.equalTo(lastView.mas_bottom).offset(ScaleW(8));
            } else {
                make.top.equalTo(containerView);
            }
            make.left.equalTo(numberLabel.mas_right).offset(ScaleW(4));
            make.right.bottom.equalTo(containerView);
        }];
    }else if([text isKindOfClass:[NSArray class]]){
        UIView *itemView = [self createItemViewWithDot:text];
        [containerView addSubview:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (subtitle.length > 0) {
                make.top.equalTo(lastView.mas_bottom).offset(ScaleW(12));
            } else {
                make.top.equalTo(containerView);
            }
            make.left.equalTo(numberLabel.mas_right).offset(ScaleW(4));
            make.right.bottom.equalTo(containerView);
        }];
    }
    
    
    return containerView;
}

// 生成多个Dot条目的视图
- (UIView *)createItemViewWithDot:(NSArray<NSString *> *)contents   {
    UIView *containerView = [[UIView alloc] init];
    
    UIView *lastView = nil;
    for (NSInteger i = 0; i < contents.count; i++) {
        UIView *itemView = [[UIView alloc] init];;
        
        // 序号标签
        UILabel *numberLabel = [[UILabel alloc] init];
        numberLabel.text = @"●";
        numberLabel.font = [UIFont systemFontOfSize:FontSize(5) weight:UIFontWeightRegular];
        numberLabel.textColor = rgba(38, 38, 38, 1);
        [itemView addSubview:numberLabel];
        

        // 内容标签
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.text = contents[i];
        contentLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
        contentLabel.textColor = rgba(38, 38, 38, 1);
        contentLabel.numberOfLines = 0;
        [itemView addSubview:contentLabel];
        
        
        [containerView addSubview:itemView];
        
        // 设置圆点标签约束
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(itemView).offset(ScaleW(4));
            make.left.equalTo(itemView);
            make.width.mas_equalTo(ScaleW(10));
        }];
        
        // 设置内容标签约束
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(itemView);
            make.left.equalTo(numberLabel.mas_right).offset(ScaleW(4));
            make.right.bottom.equalTo(itemView);
        }];
        
        
        
        // 设置 itemView 约束
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom).offset(ScaleW(8));
            } else {
                make.top.equalTo(containerView);
            }
            make.left.right.equalTo(containerView);
        }];
        
        lastView = itemView;
    }
    
    // 设置容器视图的底部约束
    if (lastView) {
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lastView.mas_bottom);
        }];
    }
    
    return containerView;
}

@end
