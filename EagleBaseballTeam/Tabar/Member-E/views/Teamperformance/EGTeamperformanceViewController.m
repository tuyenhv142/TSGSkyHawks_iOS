//
//  ViewController.m
//  music
//
//  Created by Dragon_Zheng on 2/5/25.
//

#import "EGTeamperformanceViewController.h"
#import "LXYHyperlinksButton.h"
#import "EGFanMemberInfoCell.h"
#import "EGShowMusicTextView.h"
#import "EGTeamperformanceCell.h"
#import "MSSegmentedControl.h"
#import "EGPlayerTopCell.h"
#import "EGsendPlayerTopCell.h"
#import "EGPickerView.h"
@interface EGTeamperformanceViewController ()<UITableViewDelegate,UITableViewDataSource,MSSegmentedControlDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *baseview;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *fansmusicView;
@property (nonatomic, strong) UIView *wingstarsView;
@property (nonatomic, strong) UIView *fansquanView;
@property (nonatomic, strong) UIScrollView *mainscrollView;
@property (nonatomic, assign) BOOL isUserScrolling;  // 添加标记区分用户滑动和按钮点击


@property (nonatomic, strong) LXYHyperlinksButton *fansmusic_bt;
@property (nonatomic, strong) LXYHyperlinksButton *wingstars_bt;
@property (nonatomic, strong) LXYHyperlinksButton *fansquan_bt;
@property (nonatomic, strong) UITableView* MtableView;
@property (nonatomic, strong)UITableView* MtableSendTopView;//两个排行榜的table View 公用
@property (nonatomic, strong)UITableView* MtablePlayerTopView;
@property (nonatomic, strong) UIView *bustatuslable;
@property (nonatomic, assign) NSInteger currentIndex;
//球队战绩页面控件
@property (nonatomic, strong) UIView *baseteamperformentView;
@property (nonatomic, strong) UIView *topteamperformentView;
@property (nonatomic, strong) UIView *selectBtn;
@property (nonatomic, strong)UILabel* winLabel;
@property (nonatomic, strong)UILabel* failLabel;
@property (nonatomic, strong)UILabel* sameLabel;
@property (nonatomic, strong)UILabel* winrateLabel;
@property (nonatomic, strong)UILabel* winiconLabel;
@property (nonatomic, strong)UILabel* wingameLabel;

//打折排行页面控件
@property (nonatomic, strong)MSSegmentedControl *scontr;
@property (nonatomic, strong) UIView *baseplayerView;



//投手页面控件
@property (nonatomic, strong)MSSegmentedControl *sendplayerscontr;
@property (nonatomic, strong) UIView *basesendplayerView;


@property (nonatomic, strong) NSString *halfInfo; //@"" @"_h2" @"_h1"

@property (nonatomic,strong) NSMutableDictionary *sendplayerTopDict;//投手排行数据链结构
@property (nonatomic,strong) NSMutableDictionary *playerTopDict;//打者排行数据链结构

@end

@implementation EGTeamperformanceViewController
@synthesize Mainarray;

- (NSMutableDictionary *)sendplayerTopDict{
    if (!_sendplayerTopDict) {
        _sendplayerTopDict = [NSMutableDictionary dictionary];
    }
    return _sendplayerTopDict;
}

- (NSMutableDictionary *)playerTopDict{
    if (!_playerTopDict) {
        _playerTopDict = [NSMutableDictionary dictionary];
    }
    return _playerTopDict;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"球隊戰績";
    
        
    [self setupTopView];
//    [self setupTeamperformanceUI];
//    [self setupPlayerTopUI];
//    [self setupSendPlayerTopUI];
    
    
    self.playerTopType = @"Avg";//初始化获取打擊率Avg数据
    self.sendplayerTopType = @"Era";//初始化获取防禦率Era数据
//    [self.MtableView.mj_header beginRefreshing];
//    [self.MtablePlayerTopView.mj_header beginRefreshing];
//    [self.MtableSendTopView.mj_header beginRefreshing];
    //tạm cmt để ẩn data
    // 让 ScrollView 的滑动手势在返回手势失败后触发 右滑可返回
    UIGestureRecognizer *popGesture = self.navigationController.interactivePopGestureRecognizer;
    [self.mainscrollView.panGestureRecognizer requireGestureRecognizerToFail:popGesture];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.backgroundColor = rgba(0, 71, 56, 1);
}

#pragma mark 初始化数据
-(void)initplayerTopInfo:(NSString*)type
{
    
    NSString *authString = [NSString stringWithFormat:@"%@:%@", [[EGCredentialManager sharedManager] getUsername], [[EGCredentialManager sharedManager] getPassword]];
    // Base64 编码
    NSData *authData = [authString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64AuthString = [authData base64EncodedStringWithOptions:0];
    // 添加 Basic Auth 请求头
    NSString *authHeader = [NSString stringWithFormat:@"Basic %@", base64AuthString];
 
    NSDictionary *dict_header = @{@"Authorization":authHeader};
//    [MBProgressHUD showMessage:@"數據獲取中...."];
    NSString *url = [EGServerAPI getBatterStats];
    [[WAFNWHTTPSTool sharedManager] getWithURL:url parameters:@{} headers:dict_header success:^(id  _Nonnull response) {
//        self.playerTopArray= response[type];

        /*type define
         打擊率  Avg
         安打   TotalHittingCnt
         打點   RunBattedINCnt
         盜壘   StealBaseOKCnt
         全壘打  TotalHomeRunCnt
         */
        [self.playerTopDict setValue:response[@"Avg"] forKey:@"Avg"];
        [self.playerTopDict setValue:response[@"TotalHittingCnt"] forKey:@"TotalHittingCnt"];
        [self.playerTopDict setValue:response[@"RunBattedINCnt"] forKey:@"RunBattedINCnt"];
        [self.playerTopDict setValue:response[@"StealBaseOKCnt"] forKey:@"StealBaseOKCnt"];
        [self.playerTopDict setValue:response[@"TotalHomeRunCnt"] forKey:@"TotalHomeRunCnt"];

        [self.MtablePlayerTopView reloadData];
        [self.MtablePlayerTopView.mj_header endRefreshing];
//        [MBProgressHUD hideHUD];
    } failure:^(NSError * _Nonnull error) {
//        [MBProgressHUD hideHUD];
        [self.MtablePlayerTopView.mj_header endRefreshing];
    }];
}

////全年战绩
//-(void)initteamPerformentInfo
//{
//
//    NSString *authString = [NSString stringWithFormat:@"%@:%@", [[EGCredentialManager sharedManager] getUsername], [[EGCredentialManager sharedManager] getPassword]];
//    // Base64 编码
//    NSData *authData = [authString dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *base64AuthString = [authData base64EncodedStringWithOptions:0];
//    // 添加 Basic Auth 请求头
//    NSString *authHeader = [NSString stringWithFormat:@"Basic %@", base64AuthString];
//    NSDictionary *dict_header = @{@"Authorization":authHeader};
//  //  [MBProgressHUD showMessage:@"數據獲取中...."];
//    NSString *url = [EGServerAPI getTeamStanding];
//    [[WAFNWHTTPSTool sharedManager] getWithURL:url parameters:@{} headers:@{} success:^(id  _Nonnull response) {
//        self.teamProformentsArray= response;
//        [self.MtableView reloadData];
//        [self.MtableView.mj_header endRefreshing];
//       // [MBProgressHUD hideHUD];
//    } failure:^(NSError * _Nonnull error) {
//      //  [MBProgressHUD hideHUD];
//        [self.MtableView.mj_header endRefreshing];
//    }];
//}

//半年战绩
-(void)initteamhalfInfo:(NSString*)halfyear
{
    
    NSString *authString = [NSString stringWithFormat:@"%@:%@", [[EGCredentialManager sharedManager] getUsername], [[EGCredentialManager sharedManager] getPassword]];
    // Base64 编码
    NSData *authData = [authString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64AuthString = [authData base64EncodedStringWithOptions:0];
    // 添加 Basic Auth 请求头
    NSString *authHeader = [NSString stringWithFormat:@"Basic %@", base64AuthString];
 
    NSDictionary *dict_header = @{@"Authorization":authHeader};
//    [MBProgressHUD showMessage:@"數據獲取中...."];
    NSString *url = [EGServerAPI getTeamHalfStanding:halfyear];
    [[WAFNWHTTPSTool sharedManager] getWithURL:url parameters:@{} headers:dict_header success:^(id  _Nonnull response) {
        self.teamProformentsArray= response;
        [self.MtableView reloadData];
        [self.MtableView.mj_header endRefreshing];
        //[MBProgressHUD hideHUD];
    } failure:^(NSError * _Nonnull error) {
     //   [MBProgressHUD hideHUD];
        [self.MtableView.mj_header endRefreshing];
    }];
    
}

-(void)initsendplayerTopInfo:(NSString*)type
{
    
    NSString *authString = [NSString stringWithFormat:@"%@:%@", [[EGCredentialManager sharedManager] getUsername], [[EGCredentialManager sharedManager] getPassword]];
    // Base64 编码
    NSData *authData = [authString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64AuthString = [authData base64EncodedStringWithOptions:0];
    // 添加 Basic Auth 请求头
    NSString *authHeader = [NSString stringWithFormat:@"Basic %@", base64AuthString];
 
    NSDictionary *dict_header = @{@"Authorization":authHeader};
//    [MBProgressHUD showMessage:@"數據獲取中...."];
    NSString *url = [EGServerAPI getPitcherStats];
    [[WAFNWHTTPSTool sharedManager] getWithURL:url parameters:@{} headers:dict_header success:^(id  _Nonnull response) {
        /*type define
        防禦率Era
        勝投TotalWins
        三振StrikeOutCnt
        中繼TotalRelief
        救援TotalSaveOk
        */
        [self.sendplayerTopDict setValue:response[@"Era"] forKey:@"Era"];
        [self.sendplayerTopDict setValue:response[@"TotalWins"] forKey:@"TotalWins"];
        [self.sendplayerTopDict setValue:response[@"StrikeOutCnt"] forKey:@"StrikeOutCnt"];
        [self.sendplayerTopDict setValue:response[@"TotalRelief"] forKey:@"TotalRelief"];
        [self.sendplayerTopDict setValue:response[@"TotalSaveOk"] forKey:@"TotalSaveOk"];
//        self.sendplayerTopArray= response[type];
        
        [self.MtableSendTopView reloadData];
        [self.MtableSendTopView.mj_header endRefreshing];
//        [MBProgressHUD hideHUD];
    } failure:^(NSError * _Nonnull error) {
//        [MBProgressHUD hideHUD];
        [self.MtableSendTopView.mj_header endRefreshing];
    }];
    
}


#pragma  mark 初始化table View
- (UITableView *)setSendToptableView// 排行榜table View
{
    if (self.MtableSendTopView == nil) {
    
       if (@available(iOS 13.0, *)) {
           UITableView *tableView2 = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
           tableView2.tag = 555;
           tableView2.delegate = self;
           tableView2.dataSource = self;
           tableView2.backgroundColor = [UIColor clearColor];
           tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
           tableView2.showsVerticalScrollIndicator = NO;
           tableView2.estimatedRowHeight = 100;
           self.MtableSendTopView = tableView2;
           self.MtableSendTopView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
              
               [self initsendplayerTopInfo:self.sendplayerTopType];
             
           }];
           [self.fansquanView addSubview:self.MtableSendTopView];
       } else {
           // Fallback on earlier versions
       }
}
    return self.MtableSendTopView;
}

- (UITableView *)setPlayerToptableView// 打者排行榜table View
{
    if (self.MtablePlayerTopView == nil) {
    
       if (@available(iOS 13.0, *)) {
           UITableView *tableView2 = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
           tableView2.tag = 444;
           tableView2.delegate = self;
           tableView2.dataSource = self;
           tableView2.backgroundColor=[UIColor clearColor];
           tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
           tableView2.showsVerticalScrollIndicator = NO;
           tableView2.estimatedRowHeight = 100;
           self.MtablePlayerTopView = tableView2;
           self.MtablePlayerTopView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
              
               [self initplayerTopInfo:self.playerTopType];
               
              
           }];
           [self.wingstarsView addSubview:self.MtablePlayerTopView];
       } else {
           // Fallback on earlier versions
       }
}
    return self.MtablePlayerTopView;
}

//球队战绩 table View
- (UITableView *)settableView
{
   if (self.MtableView == nil) {
       if (@available(iOS 13.0, *)) {
           UITableView *tableView2 = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
           tableView2.tag = 333;
           tableView2.delegate = self;
           tableView2.dataSource = self;
           tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
           tableView2.showsVerticalScrollIndicator = NO;
           tableView2.estimatedRowHeight = 100;
           tableView2.backgroundColor = [UIColor clearColor];
           self.MtableView = tableView2;
           self.MtableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
               ELog(@"%@",self.halfInfo);
               [self initteamhalfInfo:self.halfInfo];
           }];
           [self.fansmusicView addSubview:self.MtableView];
       } else {
           // Fallback on earlier versions
       }
}
return self.MtableView;
}



#pragma mark 初始化三个界面
-(void)setupTopView
{
    UIView *bsView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, Device_Height)];
//    bsView.backgroundColor = rgba(245, 245, 245, 1);
    bsView.backgroundColor = rgba(245, 245, 245, 1);
    [self.view addSubview:bsView];
    self.baseview = bsView;
    //commant start
//    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, ScaleW(55))];
//    bView.backgroundColor = UIColor.whiteColor;
//    [self.baseview addSubview:bView];
//    self.topView = bView;
//    
//    UIView *lineView = [UIView new];
//    lineView.backgroundColor = rgba(212, 212, 212, 1);
//    [self.topView addSubview:lineView];
//    CGFloat bwidth = Device_Width /3;
//    LXYHyperlinksButton *bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(0, 0, 100, 36)];
//    bt.tag = 20001;
//    [bt setTitle:@"球隊戰績" forState:UIControlStateNormal];
//    bt.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
//    [bt setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateSelected];
//    [bt setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
//    [bt setSelected:YES];
//    [bt addTarget:self action:@selector(buttonclick:) forControlEvents:(UIControlEventTouchUpInside)];
//    [self.topView addSubview:bt];
//    [bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
//    self.fansmusic_bt = bt;
//    
//   
//    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(ScaleW(0));
//            make.top.mas_equalTo(ScaleW(5));
//            make.width.mas_equalTo(bwidth);
//            make.height.mas_equalTo(ScaleW(50));
//        }];
//    
//    bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(0, 0, 100, 36)];
//    bt.tag = 20002;
//    [bt setTitle:@"打者排行榜" forState:UIControlStateNormal];
//    [bt addTarget:self action:@selector(buttonclick:) forControlEvents:(UIControlEventTouchUpInside)];
//    [bt setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateSelected];
//    [bt setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
//    [bt setSelected:NO];
//    bt.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
//    [self.topView addSubview:bt];
//    [bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
//    self.wingstars_bt = bt;
//    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.fansmusic_bt.mas_right).offset(0);
//            make.top.mas_equalTo(ScaleW(5));
//            make.width.mas_equalTo(bwidth);
//            make.height.mas_equalTo(ScaleW(50));
//        }];
//    
//    bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(0, 0, 100, 36)];
//    bt.tag = 20003;
//    [bt setTitle:@"投手排行榜" forState:UIControlStateNormal];
//    [bt addTarget:self action:@selector(buttonclick:) forControlEvents:(UIControlEventTouchUpInside)];
//    [bt setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateSelected];
//    [bt setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
//    [bt setSelected:NO];
//    bt.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
//    [self.topView addSubview:bt];
//    [bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
//    self.fansquan_bt = bt;
//    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.wingstars_bt.mas_right).offset(0);
//            make.top.mas_equalTo(ScaleW(5));
//            make.width.mas_equalTo(bwidth);
//            make.height.mas_equalTo(ScaleW(50));
//        }];
//    
//    [self.fansquan_bt setColor:[UIColor clearColor]];
//    [self.wingstars_bt setColor:[UIColor clearColor]];
//    
//
//    
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.fansquan_bt).offset(0);
//        make.left.right.equalTo(self.view);
//        make.height.mas_equalTo(1.5);
//    }];
//    
//    // 滑块指示器
//    self.bustatuslable = [[UIView alloc] init];
//        self.bustatuslable.backgroundColor = rgba(0, 78, 162, 1); //rgba(0, 122, 96, 1)
//    [self.topView addSubview:self.bustatuslable];
//        
//        [self.bustatuslable mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.topView);
//            make.width.mas_equalTo(bwidth);
//            make.height.mas_equalTo(ScaleW(4));
//            make.left.equalTo(self.topView);
//        }];
//    
//    [self updateSelectedButton:0];
//    
//    
//    // 滚动视图
//        self.mainscrollView = [[UIScrollView alloc] init];
//    self.mainscrollView.backgroundColor = [UIColor colorWithRed:0.962 green:0.962 blue:0.962 alpha:1.0];
//
//        self.mainscrollView.delegate = self;
//        self.mainscrollView.pagingEnabled = YES;
//      
//        self.mainscrollView.scrollEnabled = YES;
//        self.mainscrollView.showsHorizontalScrollIndicator = YES;
//        [self.baseview addSubview:self.mainscrollView];
//        
//
//        [self.mainscrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.topView.mas_bottom);
//            make.left.right.bottom.equalTo(self.baseview);
//        }];
//        
//    
//  
//       self.mainscrollView.contentSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width * 3, 0);
//    self.halfInfo =  @"";
//    
//    self.mainscrollView.bounces = YES;
    //commant end
//    // 让 ScrollView 的滑动手势在返回手势失败后触发
//    UIGestureRecognizer *popGesture = self.navigationController.interactivePopGestureRecognizer;
//    [self.mainscrollView.panGestureRecognizer requireGestureRecognizerToFail:popGesture];

}

-(void)setupTeamperformanceUI
{
    self.fansmusicView = [[UIView alloc] initWithFrame:CGRectMake(0, /*[UIDevice de_navigationFullHeight]*/0, Device_Width, Device_Height-[UIDevice de_navigationFullHeight]-self.topView.frame.size.height)];
    self.fansmusicView.backgroundColor = [UIColor clearColor];

    //增加到scroller
    [self.mainscrollView addSubview:self.fansmusicView];

    //add pop up button效果
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, ScaleW(45))];
    [self.fansmusicView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(Device_Width);
        make.height.mas_equalTo(ScaleW(45));
        make.top.mas_equalTo(self.topView.mas_bottom).offset(20);
    }];
    self.topteamperformentView = view;
    
    UIButton *priorityBtn = [UIButton ZYButtonNoFrameWithTitle:NSLocalizedString(@"全年度",nil) titleFont:[UIFont systemFontOfSize:FontSize(18) weight:(UIFontWeightRegular)] Image:[UIImage imageNamed:@"chevron-down"] backgroundImage:nil backgroundColor:rgba(255, 255, 255, 1) titleColor:rgba(23, 43, 77, 1)];
    priorityBtn.layer.cornerRadius = ScaleW(8);
    priorityBtn.layer.borderColor = [UIColor colorWithRed:0.831 green:0.831 blue:0.831 alpha:1].CGColor;
//    rgba(187, 206, 228, 1).CGColor;
    priorityBtn.layer.borderWidth = 1;
    [priorityBtn addTarget:self action:@selector(prioritySeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.topteamperformentView addSubview:priorityBtn];
    [priorityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(ScaleH(20));
        make.left.mas_equalTo(ScaleW(20));
        make.height.mas_equalTo(ScaleH(33));
        make.width.mas_equalTo(Device_Width/2);
        //make.right.mas_equalTo(-ScaleW(12));
    }];
    [priorityBtn layoutButtonWithEdgeInsetsStyle:(ZYButtonEdgeInsetsStyleRight) imageTitleSpace:100];
    self.selectBtn = priorityBtn;
   //end
    
    //add 球队 胜  负  和  胜率   胜差
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, ScaleW(45))];
    view.backgroundColor=UIColor.whiteColor;
    [self.fansmusicView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.fansmusicView);
        make.width.mas_equalTo(Device_Width - ScaleW(40));
        make.height.mas_equalTo(ScaleW(45));
        make.top.mas_equalTo(self.topView.mas_bottom).offset(90);
    }];
    self.baseteamperformentView = view;
    self.baseteamperformentView.hidden = NO;
    
    self.winiconLabel = [[UILabel alloc] init];
    self.winiconLabel.text = @"球隊";
    self.winiconLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    self.winiconLabel.textAlignment = NSTextAlignmentCenter;
    [self.baseteamperformentView addSubview:self.winiconLabel];
    [self.winiconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(10));
        make.top.mas_equalTo(ScaleW(10));
        make.width.mas_equalTo(ScaleW(50));
        make.height.mas_equalTo(ScaleW(30));
    }];
    
    self.winLabel = [[UILabel alloc] init];
    self.winLabel.text = @"勝";
    self.winLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    self.winLabel.textAlignment = NSTextAlignmentCenter;
    [self.baseteamperformentView addSubview:self.winLabel];
    [self.winLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.winiconLabel.mas_right).offset(25);
        make.centerY.mas_equalTo(self.winiconLabel);
        make.width.mas_equalTo(ScaleW(30));
        make.height.mas_equalTo(ScaleW(30));
    }];
    
    
    self.failLabel = [[UILabel alloc] init];
    self.failLabel.text = @"負";
    self.failLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    self.failLabel.textAlignment = NSTextAlignmentCenter;
    [self.baseteamperformentView addSubview:self.failLabel];
    [self.failLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.winLabel.mas_right).offset(20);
        make.centerY.mas_equalTo(self.winLabel);
        make.width.mas_equalTo(ScaleW(30));
        make.height.mas_equalTo(ScaleW(30));
    }];
    
    self.sameLabel = [[UILabel alloc] init];
    self.sameLabel.text = @"和";
    self.sameLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    self.sameLabel.textAlignment = NSTextAlignmentCenter;
    [self.baseteamperformentView addSubview:self.sameLabel];
    [self.sameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.failLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(self.failLabel);
        make.width.mas_equalTo(ScaleW(30));
        make.height.mas_equalTo(ScaleW(30));
    }];
    
    self.winrateLabel = [[UILabel alloc] init];
    self.winrateLabel.text = @"勝率";
    self.winrateLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    self.winrateLabel.textAlignment = NSTextAlignmentCenter;
    [self.baseteamperformentView addSubview:self.winrateLabel];
    [self.winrateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sameLabel.mas_right).offset(25);
        make.centerY.mas_equalTo(self.sameLabel);
        make.width.mas_equalTo(ScaleW(30));
        make.height.mas_equalTo(ScaleW(30));
    }];
    
    self.wingameLabel = [[UILabel alloc] init];
    self.wingameLabel.text = @"勝差";
    self.wingameLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    self.wingameLabel.textAlignment = NSTextAlignmentCenter;
    [self.baseteamperformentView addSubview:self.wingameLabel];
    [self.wingameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.winrateLabel.mas_right).offset(35);
        make.centerY.mas_equalTo(self.winrateLabel);
        make.width.mas_equalTo(ScaleW(30));
        make.height.mas_equalTo(ScaleW(30));
    }];
    
    
   
    [self.settableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.baseteamperformentView.mas_bottom).offset(10);
        make.right.mas_equalTo(-ScaleW(20));
        make.left.mas_equalTo(ScaleW(20));
        make.bottom.mas_equalTo(0);
        
    }];
    [self.MtableView reloadData];
}

-(void)setupPlayerTopUI//打者排行榜 UI
{
    //WingStart 页面
    self.wingstarsView = [[UIView alloc] initWithFrame:CGRectMake(Device_Width, 0, Device_Width, Device_Height-[UIDevice de_navigationFullHeight]-self.topView.frame.size.height)];
    //self.wingstarsView.backgroundColor = UIColor.purpleColor;
    //增加到scroller
    [self.mainscrollView addSubview:self.wingstarsView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, ScaleW(45))];
    view.backgroundColor=UIColor.whiteColor;
    [self.wingstarsView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.wingstarsView);
        make.width.mas_equalTo(Device_Width - ScaleW(40));
        make.height.mas_equalTo(ScaleW(45));
        make.top.mas_equalTo(self.topView.mas_bottom).offset(20);
    }];
    self.baseplayerView = view;
    
    UIColor *backgroundColor = ColorRGB(0xFFFFFF);
    UIColor *borderColor = ColorRGB(0xFFFFFF);
    UIColor *titleColor = [UIColor blackColor];
    UIColor *titleSelectColor = [UIColor whiteColor];
    UIColor *normalColor = ColorRGB(0xFFFFFF);
    UIColor *selectedColor = ColorRGB(0x004080);
    
    self.scontr = [MSSegmentedControl creatSegmentedControlWithTitle:@[@"打擊率",@"安打",@"打點",@"盜壘",@"全壘打"] withRadius:5 withBtnRadius:10 withBackgroundColor:backgroundColor withBorderColor:borderColor withBorderWidth:0 withNormalTitleColor:titleColor withSelectedTitleColor:titleSelectColor withNormalBtnBackgroundColor:normalColor withSelectedBtnBackgroundColor:selectedColor controlid:101 Top:ScaleW(5) btheight:ScaleW(30) btwidth:ScaleW(60) btInterval:ScaleW(3)];
    _scontr.delegate = self;
    [self.baseplayerView addSubview:_scontr];
    [_scontr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(15));
        make.top.mas_equalTo(ScaleW(5));
        make.width.mas_equalTo(Device_Width - ScaleW(60));
        make.height.mas_equalTo(40);
    }];
    
    [self.setPlayerToptableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-ScaleW(20));
        make.left.mas_equalTo(ScaleW(20));
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.baseplayerView.mas_bottom).offset(10);
    }];
//    [self.MtablePlayerTopView reloadData];
    
    
    
}

-(void)setupSendPlayerTopUI//投手排行榜 UI
{
    //应援团界面
    self.fansquanView = [[UIView alloc] initWithFrame:CGRectMake(2*Device_Width, 0, Device_Width, Device_Height-[UIDevice de_navigationFullHeight]-self.topView.frame.size.height)];
    //self.fansquanView.backgroundColor = UIColor.yellowColor;
    //增加到scroller
    [self.mainscrollView addSubview:self.fansquanView];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, ScaleW(45))];
    view.backgroundColor=UIColor.whiteColor;
    [self.fansquanView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.fansquanView);
        make.width.mas_equalTo(Device_Width - ScaleW(40));
        make.height.mas_equalTo(ScaleW(45));
        make.top.mas_equalTo(self.topView.mas_bottom).offset(20);
    }];
    self.basesendplayerView = view;
    
    UIColor *backgroundColor = ColorRGB(0xFFFFFF);
    UIColor *borderColor = ColorRGB(0xFFFFFF);
    UIColor *titleColor = [UIColor blackColor];
    UIColor *titleSelectColor = [UIColor whiteColor];
    UIColor *normalColor = ColorRGB(0xFFFFFF);
    UIColor *selectedColor = ColorRGB(0x004080);
    
    self.sendplayerscontr = [MSSegmentedControl creatSegmentedControlWithTitle:@[@"防禦率",@"勝投",@"三振",@"中繼",@"救援"] withRadius:5 withBtnRadius:10 withBackgroundColor:backgroundColor withBorderColor:borderColor withBorderWidth:0 withNormalTitleColor:titleColor withSelectedTitleColor:titleSelectColor withNormalBtnBackgroundColor:normalColor withSelectedBtnBackgroundColor:selectedColor controlid:102 Top:ScaleW(5) btheight:ScaleW(30) btwidth:ScaleW(60) btInterval:ScaleW(3)];
    _sendplayerscontr.delegate = self;
    [self.basesendplayerView addSubview:_sendplayerscontr];
    [_sendplayerscontr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(15));
        make.top.mas_equalTo(ScaleW(5));
        make.width.mas_equalTo(Device_Width - ScaleW(60));
        make.height.mas_equalTo(40);
    }];
    
    [self.setSendToptableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-ScaleW(20));
        make.left.mas_equalTo(ScaleW(20));
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.basesendplayerView.mas_bottom).offset(10);
    }];
//    [self.MtableSendTopView reloadData];
    
    
}

- (void)updateSelectedButton:(NSInteger)index {
    self.currentIndex = index;
   
    [UIView animateWithDuration:0.3 animations:^{
        self.bustatuslable.transform = CGAffineTransformMakeTranslation(index * (UIScreen.mainScreen.bounds.size.width / 3), 0);
    }];
    
   
}

-(void)setscrollerView:(NSInteger)bt_index
{
//    self.isUserScrolling = NO;  // 标记为按钮点击
    [self.fansquan_bt setColor:[UIColor clearColor]];
    [self.fansmusic_bt setColor:[UIColor clearColor]];
    [self.wingstars_bt setColor:[UIColor clearColor]];
    
    self.fansquanView.hidden = NO;
    self.fansmusicView.hidden = NO;
    self.wingstarsView.hidden = NO;
    
    // 重置所有按钮状态
    [self.fansquan_bt setSelected:NO];
    [self.fansmusic_bt setSelected:NO];
    [self.wingstars_bt setSelected:NO];
    
    switch (bt_index) {
        case 20001:
        {
            [self.fansmusic_bt setSelected:YES];
            [self.fansmusic_bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
            self.fansmusicView.hidden = NO;
            [self.MtableView reloadData];
        }
            break;
        case 20002:
        {
            [self.wingstars_bt setSelected:YES];
            [self.wingstars_bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
            self.wingstarsView.hidden = NO;
//            [self initplayerTopInfo:@"Avg"];
//            [self.MtablePlayerTopView.mj_header beginRefreshing];
            
            [self.MtablePlayerTopView reloadData];
            
        }
            break;
        case 20003:
        {
            [self.fansquan_bt setSelected:YES];
            [self.fansquan_bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
            self.fansquanView.hidden = NO;
//            [self initsendplayerTopInfo:@"Era"];
//            [self.MtableSendTopView.mj_header beginRefreshing];
            [self.MtableSendTopView reloadData];
        }
            break;
        default:
            break;
    }
    
    //[self.mainscrollView setContentOffset:CGPointMake((bt_index-20001) * UIScreen.mainScreen.bounds.size.width, 0) animated:YES];
//    [UIView animateWithDuration:0.3 animations:^{
//            self.sliderLabel.transform = CGAffineTransformMakeTranslation(index * (UIScreen.mainScreen.bounds.size.width / self.buttons.count), 0);
//        }];
}



-(void)buttonclick:(UIButton*)bt
{
    self.isUserScrolling = NO;  // 标记为按钮点击
    [self.fansquan_bt setColor:[UIColor clearColor]];
    [self.fansmusic_bt setColor:[UIColor clearColor]];
    [self.wingstars_bt setColor:[UIColor clearColor]];
    
    self.fansquanView.hidden = YES;
    self.fansmusicView.hidden = YES;
    self.wingstarsView.hidden = YES;
    
    // 重置所有按钮状态
    [self.fansquan_bt setSelected:NO];
    [self.fansmusic_bt setSelected:NO];
    [self.wingstars_bt setSelected:NO];
    
    switch (bt.tag) {
        case 20001:
        {
            [self.fansmusic_bt setSelected:YES];
            [self.fansmusic_bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
            self.fansmusicView.hidden = NO;
            [self.MtableView reloadData];
        }
            break;
        case 20002:
        {
            [self.wingstars_bt setSelected:YES];
            [self.wingstars_bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
            self.wingstarsView.hidden = NO;
//            [self initplayerTopInfo:@"Avg"];
//            [self.MtablePlayerTopView.mj_header beginRefreshing];
            
            [self.MtablePlayerTopView reloadData];
            
        }
            break;
        case 20003:
        {
            [self.fansquan_bt setSelected:YES];
            [self.fansquan_bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
            self.fansquanView.hidden = NO;
//            [self initsendplayerTopInfo:@"Era"];
//            [self.MtableSendTopView.mj_header beginRefreshing];
            [self.MtableSendTopView reloadData];
        }
            break;
        default:
            break;
    }
    
    [self updateSelectedButton:bt.tag-20001];
    [self.mainscrollView setContentOffset:CGPointMake((bt.tag-20001) * UIScreen.mainScreen.bounds.size.width, 0) animated:YES];
//    [UIView animateWithDuration:0.3 animations:^{
//            self.sliderLabel.transform = CGAffineTransformMakeTranslation(index * (UIScreen.mainScreen.bounds.size.width / self.buttons.count), 0);
//        }];
}

#pragma mark  Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger cellcount = 0;
    if(tableView.tag==333){
        cellcount = self.teamProformentsArray.count;
    }
    else if(tableView.tag==444){
        NSArray *array =  [self.playerTopDict objectForKey:self.playerTopType];
        cellcount = array.count;
       // cellcount = self.playerTopArray.count;
    }
    else {
        NSArray *array =  [self.sendplayerTopDict objectForKey:self.sendplayerTopType];
        cellcount = array.count;
        //cellcount = self.sendplayerTopArray.count;
    }
    return cellcount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (80);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView.tag==333)
    {
        NSDictionary *dic = [self.teamProformentsArray objectAtIndex:indexPath.row];
        
        EGTeamperformanceCell *cell= [EGTeamperformanceCell cellWithUITableView:tableView];
        cell.backgroundColor = rgba(245, 245, 245, 1);
        [cell setupWithInfo:dic];
       return cell;
    }
    else if(tableView.tag==444)
    {
        
        NSArray *array =  [self.playerTopDict objectForKey:self.playerTopType];
        NSDictionary *dic = [array objectAtIndex:indexPath.row];
        
        EGPlayerTopCell *cell= [EGPlayerTopCell cellWithUITableView:tableView];
        cell.backgroundColor = rgba(245, 245, 245, 1);
        [cell setupWithInfo:dic];
       return cell;
    }
    else if(tableView.tag==555)
    {
        
        NSArray *array =  [self.sendplayerTopDict objectForKey:self.sendplayerTopType];
        NSDictionary *dic = [array objectAtIndex:indexPath.row];
        
        EGsendPlayerTopCell *cell= [EGsendPlayerTopCell cellWithUITableView:tableView];
        cell.backgroundColor = rgba(245, 245, 245, 1);
        [cell setupWithInfo:dic];
       return cell;
    }
    else
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"Cell222"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return cell;
        }
    
        
}

#pragma mark - CustomSegmentedControlDelegate
- (void)didSelectSegmentWithIndex:(NSInteger)index ControlTAG:(NSInteger)control_tag{
    if(control_tag==101)
    {
        switch (index) {
            case 0:
            {
                NSLog(@"打击率");
               //[self initplayerTopInfo:@"Avg"];
                self.playerTopType = @"Avg";
            }
                break;
            case 1:
            {
                NSLog(@"安打");
              //  [self initplayerTopInfo:@"TotalHittingCnt"];
                self.playerTopType = @"TotalHittingCnt";
            }
                break;
            case 2:
            {
                NSLog(@"打点");
              //  [self initplayerTopInfo:@"RunBattedINCnt"];
                self.playerTopType = @"RunBattedINCnt";
            }
                break;
            case 3:
            {
                NSLog(@"盗垒");
               // [self initplayerTopInfo:@"StealBaseOKCnt"];
                self.playerTopType = @"StealBaseOKCnt";
            }
                break;
            case 4:
            {
                NSLog(@"全垒打");
                //[self initplayerTopInfo:@"TotalHomeRunCnt"];
                self.playerTopType = @"TotalHomeRunCnt";
            }
                break;
        }
        [self.MtablePlayerTopView reloadData];
//        [self.MtablePlayerTopView.mj_header beginRefreshing];
    }
    else
    {
        switch (index) {
            case 0:
                NSLog(@"防御率");
               // [self initsendplayerTopInfo:@"Era"];
                self.sendplayerTopType = @"Era";
                break;
            case 1:
                NSLog(@"胜投");
                //[self initsendplayerTopInfo:@"TotalWins"];
                self.sendplayerTopType = @"TotalWins";
                break;
            case 2:
                NSLog(@"三振");
               // [self initsendplayerTopInfo:@"StrikeOutCnt"];
                self.sendplayerTopType = @"StrikeOutCnt";
                break;
            case 3:
                NSLog(@"中继");
               // [self initsendplayerTopInfo:@"TotalRelief"];
                self.sendplayerTopType = @"TotalRelief";
                break;
            case 4:
                NSLog(@"救援");
               // [self initsendplayerTopInfo:@"TotalSaveOk"];
                self.sendplayerTopType = @"TotalSaveOk";
                break;
                
        }
        [self.MtableSendTopView reloadData];
//        [self.MtableSendTopView.mj_header beginRefreshing];
    }
    
}

#pragma mark 选择年度action
-(void)prioritySeleteButton:(UIButton *)sender
{
    UIAlertController *con = [UIAlertController alertControllerWithTitle:@"選擇年度" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    //修改title
      NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:@"選擇年度"];
      [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 4)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FontSize(16)] range:NSMakeRange(0, 4)];
      [con setValue:alertControllerStr forKey:@"attributedTitle"];
    
    
    UIAlertAction *allyear = [UIAlertAction actionWithTitle:@"全年度" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"全年度");
        self.halfInfo =  @"";
        [self.MtableView.mj_header beginRefreshing];
        [sender setTitle:@"全年度" forState:UIControlStateNormal];
        [sender layoutButtonWithEdgeInsetsStyle:(ZYButtonEdgeInsetsStyleRight) imageTitleSpace:100];
    }];
    
    UIAlertAction *preyear = [UIAlertAction actionWithTitle:@"上半年" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"上半年");
        self.halfInfo = @"_h1";
        [self.MtableView.mj_header beginRefreshing];
        //[self initteamhalfInfo:@"h1"];
        [sender setTitle:@"上半年" forState:UIControlStateNormal];
        [sender layoutButtonWithEdgeInsetsStyle:(ZYButtonEdgeInsetsStyleRight) imageTitleSpace:100];
    }];
    
    
    UIAlertAction *lastyear = [UIAlertAction actionWithTitle:@"下半年" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"下半年");
        self.halfInfo = @"_h2";
        [self.MtableView.mj_header beginRefreshing];
       // [self initteamhalfInfo:@"h2"];
        [sender setTitle:@"下半年" forState:UIControlStateNormal];
        [sender layoutButtonWithEdgeInsetsStyle:(ZYButtonEdgeInsetsStyleRight) imageTitleSpace:100];
    }];
    
    UIAlertAction *canel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

    if (![canel valueForKey:@"titleTextColor"]) {
        [canel setValue:[UIColor blackColor] forKey:@"titleTextColor"];
      }
    //修改按钮
    if (![allyear valueForKey:@"titleTextColor"]) {
        [allyear setValue:[UIColor blackColor] forKey:@"titleTextColor"];
      }
    //修改按钮
    if (![preyear valueForKey:@"titleTextColor"]) {
        [preyear setValue:[UIColor blackColor] forKey:@"titleTextColor"];
      }
    //修改按钮
    if (![lastyear valueForKey:@"titleTextColor"]) {
        [lastyear setValue:[UIColor blackColor] forKey:@"titleTextColor"];
      }
    
    [con addAction:allyear];
    [con addAction:preyear];
    [con addAction:lastyear];
    [con addAction:canel];
    [self presentViewController:con animated:YES completion:nil];
    
}

#pragma mark scroller delegate
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if ([scrollView isKindOfClass:[UITableView class]])
    {
        return;
    }
    if (self.isUserScrolling) {  // 只在用户滑动时更新
    NSInteger index = scrollView.contentOffset.x / UIScreen.mainScreen.bounds.size.width;
    
    [self setscrollerView:index + 20001];
    [self updateSelectedButton:index];
            //[self updateSelectedButton:index];
        }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isUserScrolling = YES;  // 标记为用户滑动
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.isUserScrolling) return;  // 非用户滑动时不更新滑块位置
    if ([scrollView isKindOfClass:[UITableView class]])
    {
        return;
    }
    
    CGFloat pageWidth = scrollView.frame.size.width;
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat progress = offsetX / pageWidth;
    
    // 更新滑块位置
    CGFloat buttonWidth = UIScreen.mainScreen.bounds.size.width / 3;
    self.bustatuslable.transform = CGAffineTransformMakeTranslation(progress * buttonWidth, 0);
    
    if (offsetX <= 0) {
        // 当滚动到最左侧时，启用系统返回手势
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//        [self.navigationController popViewControllerAnimated:YES];
    } else {
        // 当在滚动过程中，禁用系统返回手势
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

@end
