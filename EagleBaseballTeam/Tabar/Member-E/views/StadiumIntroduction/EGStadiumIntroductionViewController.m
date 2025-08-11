//
//  ViewController.m
//  music
//
//  Created by Dragon_Zheng on 2/5/25.
//

#import "EGStadiumIntroductionViewController.h"
#import "LXYHyperlinksButton.h"
#import "EGFanMemberInfoCell.h"
#import "EGShowMusicTextView.h"
#import "EGirlCollectionViewCell.h"
#import "EGFanDetailViewController.h"
#import "EGSocialLinksCell2.h"
#import "EGYingyuantuanDetailViewController.h"
#import "EGirlClassCollectionViewCell.h"
#import "EGClassDateCollectionViewCell.h"
#import "EGStadiumViewHeaderFooterView.h"
#import "EGParkViewHeaderFooterView.h"
#import "EGStadiumViewCell.h"
#import "EGSeatImageCell.h"
#import "EGSeatSecondRowCell.h"
#import "EGSeatFirstRowCell.h"
#import "EGSeatThirdRowCell.h"
#import "EGCateringImageCell.h"
#import "EGCateringInfoCell.h"
#import "EGParkTitleCell.h"
#import <WebKit/WebKit.h>
#import <MapKit/MapKit.h>
@interface EGStadiumIntroductionViewController ()<UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate>

@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) UIView *baseview;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *StadiumView;//交通 base view
@property (nonatomic, strong) UIView *ParkView;//交通 base view
@property (nonatomic, strong) UIView *SeatView;//座位 base view
@property (nonatomic, strong) UIView *DeviceView;//设施 base view
@property (nonatomic, strong) UIView *CateringView;//餐饮 base view


@property (nonatomic, strong) UIScrollView *mainscrollView;
@property (nonatomic, assign) BOOL isUserScrolling;  // 添加标记区分用户滑动和按钮点击
@property (nonatomic, strong) UIView *bustatuslable;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) LXYHyperlinksButton *fansclass_bt;//交通button
@property (nonatomic, strong) LXYHyperlinksButton *parkclass_bt;//交通button
@property (nonatomic, strong) LXYHyperlinksButton *fansmusic_bt;//座位 button
@property (nonatomic, strong) LXYHyperlinksButton *wingstars_bt;//设施 button
@property (nonatomic, strong) LXYHyperlinksButton *fansquan_bt;////餐饮button
//@property (nonatomic, strong) LXYHyperlinksButton *jixiangwu_bt;
@property (nonatomic, weak) UITableView* Stadium_MtableView;//交通 tableview
@property (nonatomic, weak) UITableView* Park_MtableView;//交通 tableview
@property (nonatomic, weak) UITableView* Seat_MtableView;//交通 tableview
@property (nonatomic, weak) UITableView* Device_MtableView;//交通 tableview
@property (nonatomic, weak) UITableView* Catering_MtableView;//交通 tableview

@property (nonatomic,assign)NSInteger bt_width;
@property (nonatomic,strong) WKWebView *wkWebView;


//数据区
@property (nonatomic,strong) NSArray *Stadiumarray;
@property (nonatomic,strong) NSMutableArray *Parkarray;//因为要记录cell的 点击 status.所以Parkarray是要修改status
@property (nonatomic,strong) NSArray *Parktemparray;//原始Park Array

@property (nonatomic,strong) NSArray *Seattemparray;//原始Seat Array
@property (nonatomic,strong) NSMutableArray *Seatarray;//因为要记录cell的 点击 status.所以seat是要修改status


@property (nonatomic,strong) NSArray *Cateringarray;//通过 1，2，3获取不同的类型数据
@end

@implementation EGStadiumIntroductionViewController
@synthesize Mainarray;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"球場資訊";
    _latiorlongitude = [NSMutableDictionary new];
    //self.latiorlongitude_array = [NSMutableArray new];
    
    _seattableView_imagecell_clear = NO;
    self.seattableView_imagecell_index = -1;
    self.changdi_type = 101;
    _catering_type = 0;
    self.tableView_Type=Stadium_TableView;
    self.bt_width = Device_Width / 5;
    
    [self setupUI];
    
    
    [self setscrollerView:50001];
    [self updateSelectedButton:1];
    [self.mainscrollView setContentOffset:CGPointMake(1 * UIScreen.mainScreen.bounds.size.width, 0) animated:YES];
    
    [self.Stadium_MtableView reloadData];
    // 让 ScrollView 的滑动手势在返回手势失败后触发 右滑可返回
    UIGestureRecognizer *popGesture = self.navigationController.interactivePopGestureRecognizer;
    [self.mainscrollView.panGestureRecognizer requireGestureRecognizerToFail:popGesture];
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.backgroundColor = rgba(16, 38, 73, 1);
}

#pragma mark -----初始化四个table View------
- (UITableView *)setStadium_MtableView
{
    if (self.Stadium_MtableView == nil) {
        
        if (@available(iOS 13.0, *)) {
            UITableView *tableView2 = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
            tableView2.tag = Stadium_TableView;
            tableView2.delegate = self;
            tableView2.dataSource = self;
            tableView2.backgroundColor = [UIColor colorWithRed:0.962 green:0.962 blue:0.962 alpha:1.0];
            
            tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView2.showsVerticalScrollIndicator = NO;
//            tableView2.estimatedRowHeight = 100;
            self.Stadium_MtableView = tableView2;
            [self.StadiumView addSubview:self.Stadium_MtableView];
        } else {
            // Fallback on earlier versions
        }
    }
//    return self.Stadium_MtableView;
    return 0;
}


- (UITableView *)setPark_MtableView
{
    if (self.Park_MtableView == nil) {
        if (@available(iOS 13.0, *)) {
            UITableView *tableView2 = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
            tableView2.delegate = self;
            tableView2.tag = Stadium_Park_TableView;
            tableView2.dataSource = self;
            tableView2.backgroundColor = rgba(245, 245, 245, 1);
            
            tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView2.showsVerticalScrollIndicator = NO;
            tableView2.estimatedRowHeight = 100;
            self.Park_MtableView = tableView2;
            [self.ParkView addSubview:self.Park_MtableView];
        } else {
            // Fallback on earlier versions
        }
    }
//    return self.Park_MtableView;
    return 0;

}


- (UITableView *)setSeat_MtableView
{
    if (self.Seat_MtableView == nil) {
        
        if (@available(iOS 13.0, *)) {
            UITableView *tableView2 = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
            tableView2.delegate = self;
            tableView2.tag = Seat_TableView;
            tableView2.dataSource = self;
            tableView2.backgroundColor = rgba(245, 245, 245, 1);
            
            tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView2.showsVerticalScrollIndicator = NO;
            tableView2.estimatedRowHeight = 100;
            self.Seat_MtableView = tableView2;
            [self.SeatView addSubview:self.Seat_MtableView];
        } else {
            // Fallback on earlier versions
        }
    }
//    return self.Seat_MtableView;
    return 0;

}

- (UITableView *)setDevice_MtableView
{
    if (self.Device_MtableView == nil) {
        
        if (@available(iOS 13.0, *)) {
            UITableView *tableView2 = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
            tableView2.delegate = self;
            tableView2.tag = Intrueduce_TableView;
            tableView2.dataSource = self;
            tableView2.backgroundColor = rgba(245, 245, 245, 1);
            
            tableView2.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            tableView2.showsVerticalScrollIndicator = NO;
            tableView2.estimatedRowHeight = 100;
            self.Device_MtableView = tableView2;
            [self.DeviceView addSubview:self.Device_MtableView];
        } else {
            // Fallback on earlier versions
        }
    }
//    return self.Device_MtableView;
    return 0;

}

- (UITableView *)setCatering_MtableView
{
    if (self.Catering_MtableView == nil) {
        
        if (@available(iOS 13.0, *)) {
            UITableView *tableView2 = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
            tableView2.delegate = self;
            tableView2.tag = Catering_TableView;
            tableView2.dataSource = self;
            tableView2.backgroundColor = rgba(245, 245, 245, 1);
            
            tableView2.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            tableView2.showsVerticalScrollIndicator = NO;
            tableView2.estimatedRowHeight = 100;
            self.Catering_MtableView = tableView2;
            [self.CateringView addSubview:self.Catering_MtableView];
        } else {
            // Fallback on earlier versions
        }
    }
//    return self.Catering_MtableView;
    return 0;

}

- (WKWebView *)wkWebView
{
    if (!_wkWebView) {
        // Create configuration first
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.selectionGranularity = WKSelectionGranularityDynamic;
        config.allowsInlineMediaPlayback = YES;
        config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        config.allowsPictureInPictureMediaPlayback = YES;
        
        // Initialize WKWebView with configuration
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
        _wkWebView.navigationDelegate = self;
        [self.DeviceView addSubview:_wkWebView];
        [_wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo([UIDevice de_navigationFullHeight]);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
    }
    return _wkWebView;
}

-(void)setupUI
{
    UIView *bsView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, Device_Height)];
    bsView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:bsView];
    self.baseview = bsView;
    
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, ScaleW(50))];
    [self.baseview addSubview:bView];
    self.topView = bView;
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = rgba(212, 212, 212, 1);
    [self.topView addSubview:lineView];
    
    
    LXYHyperlinksButton *bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(0, 0, 100, 36)];
    bt.tag = Stadium_Park_TableView;
    [bt setTitle:@"停車" forState:UIControlStateNormal];
    [bt setTitleColor:rgba(212, 212, 212, 1) forState:UIControlStateSelected];
    [bt setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateNormal];
    bt.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    [bt addTarget:self action:@selector(buttonclick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.topView addSubview:bt];
    [bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
    self.fansclass_bt = bt;
    [self.fansclass_bt setSelected:YES];
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(0));
        make.top.mas_equalTo(ScaleW(5));
        make.width.mas_equalTo(self.bt_width);
        make.height.mas_equalTo(ScaleW(50));
    }];
    [self.fansclass_bt setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateSelected];
    [self.fansclass_bt setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
    [self.fansclass_bt setColor:[UIColor clearColor]];
    
    bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(0, 0, 100, 36)];
    bt.tag = Stadium_TableView;
    [bt setTitle:@"交通" forState:UIControlStateNormal];
    [bt setTitleColor:rgba(212, 212, 212, 1) forState:UIControlStateSelected];
    [bt setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateNormal];
    bt.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    [bt addTarget:self action:@selector(buttonclick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.topView addSubview:bt];
    [bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
    self.parkclass_bt = bt;
    [self.parkclass_bt setSelected:NO];
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.fansclass_bt.mas_right).offset(0);
        make.top.mas_equalTo(ScaleW(5));
        make.width.mas_equalTo(self.bt_width);
        make.height.mas_equalTo(ScaleW(50));
    }];
    
    [self.parkclass_bt setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateSelected];
    [self.parkclass_bt setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
    [self.parkclass_bt setColor:[UIColor clearColor]];
    
    
    bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(0, 0, 100, 36)];
    bt.tag = Seat_TableView;
    [bt setTitle:@"座位" forState:UIControlStateNormal];
    [bt setTitleColor:rgba(212, 212, 212, 1) forState:UIControlStateSelected];
    [bt setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateNormal];
    bt.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    [bt addTarget:self action:@selector(buttonclick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.topView addSubview:bt];
    [bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
    self.fansmusic_bt = bt;
    [self.fansmusic_bt setSelected:NO];
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.parkclass_bt.mas_right).offset(0);
        make.top.mas_equalTo(ScaleW(5));
        make.width.mas_equalTo(self.bt_width);
        make.height.mas_equalTo(ScaleW(50));
    }];
    
    [self.fansmusic_bt setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateSelected];
    [self.fansmusic_bt setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
    [self.fansquan_bt setColor:[UIColor clearColor]];
    
    bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(0, 0, 100, 36)];
    bt.tag = Catering_TableView;
    [bt setTitle:@"餐飲" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(buttonclick:) forControlEvents:(UIControlEventTouchUpInside)];
    bt.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    [self.topView addSubview:bt];
    [bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
    [self.wingstars_bt setSelected:NO];
    self.wingstars_bt = bt;
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.fansmusic_bt.mas_right).offset(0);
        make.top.mas_equalTo(ScaleW(5));
        make.width.mas_equalTo(self.bt_width);
        make.height.mas_equalTo(ScaleW(50));
    }];
    
    [self.wingstars_bt setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateSelected];
    [self.wingstars_bt setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
    [self.wingstars_bt setColor:[UIColor clearColor]];
    //团长 button
    bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(0, 0, 100, 36)];
    bt.tag = Intrueduce_TableView;
    [bt setTitle:@"介紹" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(buttonclick:) forControlEvents:(UIControlEventTouchUpInside)];
    bt.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    [self.topView addSubview:bt];
    [bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
    self.fansquan_bt = bt;
    
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.wingstars_bt.mas_right).offset(0);
        make.top.mas_equalTo(ScaleW(5));
        make.width.mas_equalTo(self.bt_width);
        make.height.mas_equalTo(ScaleW(50));
    }];
    [self.fansquan_bt setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateSelected];
    [self.fansquan_bt setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
    [self.fansquan_bt setColor:[UIColor clearColor]];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.wingstars_bt).offset(0);
        //        make.bottom.equalTo(self.topView).offset(0);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(1.5);
    }];
    
    // 滑块指示器
    self.bustatuslable = [[UIView alloc] init];
    self.bustatuslable.backgroundColor = rgba(0, 121, 192, 1); //rgba(0, 122, 96, 1)
    [self.topView addSubview:self.bustatuslable];
    
    [self.bustatuslable mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.bottom.equalTo(self.topView);
        make.bottom.equalTo(lineView);
        make.width.mas_equalTo(self.bt_width);
        make.height.mas_equalTo(ScaleW(4));
        make.left.mas_equalTo(self.topView.mas_left).offset(ScaleW(0));
    }];
    
    [self updateSelectedButton:0];
    
    
    // 滚动视图
    self.mainscrollView = [[UIScrollView alloc] init];
    self.mainscrollView.backgroundColor = [UIColor colorWithRed:0.962 green:0.962 blue:0.962 alpha:1.0];
    self.mainscrollView.delegate = self;
    self.mainscrollView.pagingEnabled = YES;
    
    self.mainscrollView.scrollEnabled = YES;
    self.mainscrollView.showsHorizontalScrollIndicator = YES;
    [self.baseview addSubview:self.mainscrollView];
    [self.mainscrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.left.right.bottom.equalTo(self.baseview);
    }];
    self.mainscrollView.contentSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width * 5, 0);
    self.mainscrollView.bounces = YES;
    
    self.ParkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, Device_Height-[UIDevice de_navigationFullHeight]-self.topView.frame.size.height)];
    [self.mainscrollView addSubview:self.ParkView];
    
    //set 场地 table view
    [self.setPark_MtableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(ScaleW(20));
    }];
//    [self.Park_MtableView reloadData];
    
    
    self.StadiumView = [[UIView alloc] initWithFrame:CGRectMake(Device_Width, 0, Device_Width, Device_Height-[UIDevice de_navigationFullHeight]-self.topView.frame.size.height)];
    [self.mainscrollView addSubview:self.StadiumView];
    
    //set 场地 table view
    [self.setStadium_MtableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-ScaleW(20));
        make.top.mas_equalTo(0);
    }];
    
    
    self.SeatView = [[UIView alloc] initWithFrame:CGRectMake(Device_Width*2, 0, Device_Width, Device_Height-[UIDevice de_navigationFullHeight]-self.topView.frame.size.height)];
    [self.mainscrollView addSubview:self.SeatView];
    
    //set 座位 table view
    [self.setSeat_MtableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    
    
    //set 餐饮 table view
    self.CateringView = [[UIView alloc] initWithFrame:CGRectMake(3*Device_Width,0, Device_Width, Device_Height-[UIDevice de_navigationFullHeight]-self.topView.frame.size.height)];
//    self.CateringView.backgroundColor = [UIColor yellowColor];
    [self.mainscrollView addSubview:self.CateringView];
    [self.setCatering_MtableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    self.Catering_MtableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
           [self IniCateringData:self.catering_type];
        }];
    
    
    
    
    //设置
    self.DeviceView = [[UIView alloc] initWithFrame:CGRectMake(Device_Width*4,0, Device_Width, Device_Height-[UIDevice de_navigationFullHeight]-self.topView.frame.size.height)];
    self.DeviceView.backgroundColor=rgba(245, 245, 245, 1);
    [self.mainscrollView addSubview:self.DeviceView];
    
    //set 设施 table view
    [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    
    
    
    
    
    
}


-(void)setscrollerView:(NSInteger)bt_index
{
    [self.fansquan_bt setColor:[UIColor clearColor]];
    [self.parkclass_bt setColor:[UIColor clearColor]];
    [self.fansmusic_bt setColor:[UIColor clearColor]];
    [self.wingstars_bt setColor:[UIColor clearColor]];
    [self.fansclass_bt setColor:[UIColor clearColor]];
    
    
    // 重置所有按钮状态
    [self.fansquan_bt setSelected:NO];
    [self.parkclass_bt setSelected:NO];
    [self.fansmusic_bt setSelected:NO];
    [self.wingstars_bt setSelected:NO];
    [self.fansclass_bt setSelected:NO];
    
    self.CateringView.hidden = YES;
    self.ParkView.hidden = YES;
    self.SeatView.hidden = YES;
    self.DeviceView.hidden = YES;
    self.StadiumView.hidden = YES;
    
    self.tableView_Type = bt_index;
    
    switch (bt_index) {
        case 50000:
        {
            [self.fansclass_bt setSelected:YES];
            [self.fansclass_bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
            self.ParkView.hidden = NO;
            [self IniParkData];
            [self.Park_MtableView reloadData];
        }
            break;
            
        case 50001:
        {
            [self.parkclass_bt setSelected:YES];
            [self.parkclass_bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
            self.StadiumView.hidden = NO;
            [self IniStadiumData];
            [self.Stadium_MtableView reloadData];
        }
            break;
        case 50002:
        {
            [self.fansmusic_bt setSelected:YES];
            [self.fansmusic_bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
            self.SeatView.hidden = NO;
            [self IniSeatData:self.changdi_type];
            _seattableView_imagecell_clear = YES;
            _seattableView_imagecell_index = -1;
            [self.Seat_MtableView reloadData];
        }
            break;
        case 50003:
        {
            [self.wingstars_bt setSelected:YES];
            [self.wingstars_bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
            self.CateringView.hidden = NO;
            //[self IniCateringData:_catering_type];
            [self.Catering_MtableView.mj_header beginRefreshing];
            //[self.Catering_MtableView reloadData];
        }
            break;
        case 50004:
        {
            self.DeviceView.hidden = NO;
            [self.fansquan_bt setSelected:YES];
            [self.fansquan_bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
            NSURL *nsurl = [[NSURL alloc] initWithString:@"https://20.189.240.127/fan/chengching-lake-baseball-field/"];
            NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
            [self.wkWebView loadRequest:nsrequest];
        }
            break;
        default:
            break;
    }
    
}

-(NSArray*)inorderArray
{
    NSArray *sortedArray;
    return sortedArray = [self.self.girlArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSInteger valueA = [a[@"girlNO"] integerValue];
        NSInteger valueB = [b[@"girlNO"] integerValue];
        return valueA > valueB;
    }];
}


- (void)updateSelectedButton:(NSInteger)index {
    self.currentIndex = index;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bustatuslable.transform = CGAffineTransformMakeTranslation(index * self.bt_width, 0);
    }];
    
    switch (index) {
        case 0:
            self.navigationItem.title = @"停車資訊";
            break;
            
        case 1:
            self.navigationItem.title = @"球場資訊";
            break;
        case 2:
            self.navigationItem.title = @"球場資訊";
            break;
        case 3:
            self.navigationItem.title = @"球場資訊";
            break;
        case 4:
            self.navigationItem.title = @"球場資訊";
            break;
    }
}

-(void)buttonclick:(UIButton*)bt
{
    self.isUserScrolling = NO;  // 标记为按钮点击
    [self.fansquan_bt setColor:[UIColor clearColor]];
    [self.parkclass_bt setColor:UIColor.clearColor];
    [self.fansmusic_bt setColor:[UIColor clearColor]];
    [self.wingstars_bt setColor:[UIColor clearColor]];
    [self.fansclass_bt setColor:[UIColor clearColor]];
    
    // 重置所有按钮状态
    [self.fansquan_bt setSelected:NO];
    [self.parkclass_bt setSelected:NO];
    [self.fansmusic_bt setSelected:NO];
    [self.wingstars_bt setSelected:NO];
    [self.fansclass_bt setSelected:NO];
    
    self.CateringView.hidden = YES;
    self.ParkView.hidden = YES;
    self.SeatView.hidden = YES;
    self.DeviceView.hidden = YES;
    self.StadiumView.hidden = YES;
    
    self.tableView_Type = bt.tag;
    
    switch (bt.tag) {
        case 50000:
        {
            [self.fansclass_bt setSelected:YES];
            [self.fansclass_bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
            self.ParkView.hidden = NO;
            [self IniParkData];
            [self.Park_MtableView reloadData];
        }
            break;
        case 50001:
        {
            [self.parkclass_bt setSelected:YES];
            [self.parkclass_bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
            self.StadiumView.hidden = NO;
            [self IniStadiumData];
            [self.Stadium_MtableView reloadData];
        }
            break;
            
        case 50002:
        {
            [self.fansmusic_bt setSelected:YES];
            [self.fansmusic_bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
            self.SeatView.hidden = NO;
            [self IniSeatData:self.changdi_type];
            _seattableView_imagecell_clear = YES;
            _seattableView_imagecell_index = -1;
            [self.Seat_MtableView reloadData];
        }
            break;
        case 50003:
        {
            [self.wingstars_bt setSelected:YES];
            [self.wingstars_bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
            self.CateringView.hidden = NO;
//            [self IniCateringData:_catering_type];
//            [self.Catering_MtableView reloadData];
            [self.Catering_MtableView.mj_header beginRefreshing];
        }
            break;
        case 50004:
        {
            self.DeviceView.hidden = NO;
            [self.fansquan_bt setSelected:YES];
            [self.fansquan_bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
            NSURL *nsurl = [[NSURL alloc] initWithString:@"https://20.189.240.127/fan/chengching-lake-baseball-field/"];
            NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
            [_wkWebView loadRequest:nsrequest];
        }
            break;
            
        default:
            break;
    }
    
    [self updateSelectedButton:bt.tag-50000];
    [self.mainscrollView setContentOffset:CGPointMake((bt.tag-50000) * UIScreen.mainScreen.bounds.size.width, 0) animated:YES];
    
}
- (void)webView:(WKWebView *)webView    //cho phép load SSL ko hợp lệ
    didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
    completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        // Chấp nhận chứng chỉ bất kể hợp lệ hay không
        NSURLCredential *credential = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
    } else {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
}

-(void)sendgoogleMap:(NSDictionary*)info
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]])
    {
        double lati = [[info objectForKey:@"section_E"] doubleValue];
        double longti = [[info objectForKey:@"section_N"] doubleValue];
        NSArray* address = [info objectForKey:@"section_content"];
        // Google Maps is installed
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lati, longti); // Example coordinates for Apple HQ
        [self openGoogleMapsAtLocation:coordinate addressName:[address objectAtIndex:0][@"row_content"]];
    }
    else {
        
        double lati = [[info objectForKey:@"section_E"] doubleValue];
                double longti = [[info objectForKey:@"section_N"] doubleValue];
        // 假设你有一个 CLLocationCoordinate2D 类型的变量 location
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lati, longti); // 例如：苹果总部位置
        // 创建一个 MKMapItem 对象
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
        NSArray* address = [info objectForKey:@"section_content"];
        mapItem.name =  [address objectAtIndex:0][@"row_content"];// 可以设置一个名称，这样在地图上会显示这个名称

        // 调用 openInMaps 方法来打开地图应用
        [mapItem openInMapsWithLaunchOptions:nil];
    }
    
    
    
    
}


- (void)openGoogleMapsAtLocation:(CLLocationCoordinate2D)coordinate addressName:name{
    CLLocationDegrees latitude = coordinate.latitude;
    CLLocationDegrees longitude = coordinate.longitude;
    NSString *urlString = [NSString stringWithFormat:@"comgooglemaps://?q=%@,%f,%f&center=%f,%f&zoom=14",name, latitude, longitude, latitude, longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"Google Maps opened successfully");
            } else {
                NSLog(@"Failed to open Google Maps");
            }
        }];
    } else {
        NSLog(@"Could not open Google Maps");
    }
}

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

#pragma mark   ------- 交通页面数据-------
-(void)IniStadiumData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"stadium" ofType:@"plist"];
    self.Stadiumarray = [NSArray arrayWithContentsOfFile:path];
}

#pragma mark   ------- 停车页面数据-------
-(void)IniParkData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"park" ofType:@"plist"];
    self.Parktemparray = [NSArray arrayWithContentsOfFile:path];
    self.Parkarray = [NSMutableArray arrayWithArray:self.Parktemparray];
}

-(void)changeStatusForparkTabelViewFromMapView:(NSInteger)row
{
    [self.Parkarray removeAllObjects];
    for(int i=0;i<self.Parktemparray.count;i++)
    {
        //先将Array 上每个节点的status 置为 NO
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.Parktemparray objectAtIndex:i]];
        [dic setObject:[NSNumber numberWithBool:NO] forKey:@"section_status"];
        [self.Parkarray addObject:dic];
    }
    
    {
        NSMutableDictionary *dic = [self.Parkarray objectAtIndex:row];
        [dic setObject:[NSNumber numberWithBool:YES] forKey:@"section_status"];
        [self.Parkarray replaceObjectAtIndex:row withObject:dic];
        [_latiorlongitude setObject:[dic objectForKey:@"section_E"] forKey:@"latitude"];
        [_latiorlongitude setObject:[dic objectForKey:@"section_N"] forKey:@"longitude"];
        [_latiorlongitude setObject:[NSNumber numberWithBool:NO] forKey:@"selected"];
    }
    
    
}

-(void)changeStatusForparkTabelView:(NSIndexPath *)row
{
    [self.Parkarray removeAllObjects];
    for(int i=0;i<self.Parktemparray.count;i++)
    {
        //先将Array 上每个节点的status 置为 NO
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.Parktemparray objectAtIndex:i]];
        [dic setObject:[NSNumber numberWithBool:NO] forKey:@"section_status"];
        [self.Parkarray addObject:dic];
    }
    
    if(row.section!=0)
    {
        NSMutableDictionary *dic = [self.Parkarray objectAtIndex:row.section-1];
        [dic setObject:[NSNumber numberWithBool:YES] forKey:@"section_status"];
        [self.Parkarray replaceObjectAtIndex:row.section-1 withObject:dic];
        [_latiorlongitude setObject:[dic objectForKey:@"section_E"] forKey:@"latitude"];
        [_latiorlongitude setObject:[dic objectForKey:@"section_N"] forKey:@"longitude"];
        [_latiorlongitude setObject:[NSNumber numberWithBool:NO] forKey:@"selected"];
    }
    
    
}

#pragma mark   ------- 座位页面数据-------
-(void)IniSeatData:(NSInteger)type
{
    NSString *path = @"";
    
    switch (type) {
        case 101:
            path = [[NSBundle mainBundle] pathForResource:@"seat" ofType:@"plist"];
            break;
        case 102:
            path = [[NSBundle mainBundle] pathForResource:@"seatjiayi" ofType:@"plist"];
            break;
    }
    self.Seattemparray = [NSArray arrayWithContentsOfFile:path];
    self.Seatarray = [NSMutableArray arrayWithArray:self.Seattemparray];
}

-(void)changeStatusForseatTabelViewByindex:(NSInteger)rowIndex
{
    [self.Seatarray removeAllObjects];
    for(int i=0;i<self.Seattemparray.count;i++)
    {
        //先将Array 上每个节点的status 置为 NO
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.Seattemparray objectAtIndex:i]];
        [dic setObject:[NSNumber numberWithBool:NO] forKey:@"section_status"];
        [self.Seatarray addObject:dic];
    }
    
    if(rowIndex!=-1)
    {
        NSMutableDictionary *dic = [self.Seatarray objectAtIndex:rowIndex];
        [dic setObject:[NSNumber numberWithBool:YES] forKey:@"section_status"];
        [self.Seatarray replaceObjectAtIndex:rowIndex withObject:dic];
    }
    
}


-(void)changeStatusForseatTabelView:(NSIndexPath *)row
{
    [self.Seatarray removeAllObjects];
    for(int i=0;i<self.Seattemparray.count;i++)
    {
        //先将Array 上每个节点的status 置为 NO
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.Seattemparray objectAtIndex:i]];
        [dic setObject:[NSNumber numberWithBool:NO] forKey:@"section_status"];
        [self.Seatarray addObject:dic];
    }
    
    if(row.section!=0)
    {
        NSMutableDictionary *dic = [self.Seatarray objectAtIndex:row.section-1];
        [dic setObject:[NSNumber numberWithBool:YES] forKey:@"section_status"];
        [self.Seatarray replaceObjectAtIndex:row.section-1 withObject:dic];
    }
    
}

#pragma mark   ------- 餐饮页面数据-------
-(void)IniCateringData:(NSInteger)Catering_type
{
    
    EGRelayTokenModel *tokenModel = [EGLoginUserManager getRelayToken];
            NSDictionary *headerDict;
            if (tokenModel) {
                headerDict = @{@"Authorization":tokenModel.token ? tokenModel.token:@"",
                               @"Accept": @"application/json",  // 添加 Accept 头
                               @"Content-Type": @"application/json"  // 添加 Content-Type 头
                };
            }
    
    
    [[WAFNWHTTPSTool sharedManager] getWithURL:[EGServerAPI get_CateringClass] parameters:@{} headers:headerDict success:^(NSDictionary *  _Nonnull response) {
        [self managerData:Catering_type Alldata:response];
        [self.Catering_MtableView.mj_header endRefreshing];
        [self.Catering_MtableView reloadData];
        
    }failure:^(NSError * _Nonnull error) {
        [self.Catering_MtableView.mj_header endRefreshing];
    }];
    
}

-(void)managerData:(NSInteger)Catering_type Alldata:(NSDictionary*)all_dic
{
    //0 is All, 1 is 美食, 2 is 商品, 3 is 活动
    if(Catering_type==0)
    {
        NSDictionary*cateringdic = all_dic;
        
        
        NSArray*temp = [cateringdic objectForKey:@"catering_data"];
        
        NSPredicate *predicate1 = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            NSString *dateV = (NSString *)evaluatedObject[@"catering_type"];
            return ([dateV intValue] == 1);
        }];
        NSArray* meishitemp  = [temp filteredArrayUsingPredicate:predicate1];
        NSArray* meishi = nil;
        if(meishitemp.count>0)
            meishi = [meishitemp objectAtIndex:0][@"catering_type_data"];
        
        NSMutableArray *tempAllarray = [NSMutableArray arrayWithArray:meishi];

        
        NSPredicate *shangpinpredicate1 = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            NSString *dateV = (NSString *)evaluatedObject[@"catering_type"];
            return ([dateV intValue] == 2);
        }];
        NSArray* shangpintemp  = [temp filteredArrayUsingPredicate:shangpinpredicate1];
        NSArray* shangpin = nil;
        if(shangpintemp.count>0)
            shangpin = [shangpintemp objectAtIndex:0][@"catering_type_data"];
        
        [tempAllarray addObjectsFromArray:shangpin];
        
        
        NSPredicate *huodongpredicate1 = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            NSString *dateV = (NSString *)evaluatedObject[@"catering_type"];
            return ([dateV intValue] == 2);
        }];
        NSArray* huodongtemp  = [temp filteredArrayUsingPredicate:huodongpredicate1];
        NSArray* huodong = nil;
        if(huodongtemp.count>0)
            huodong = [huodongtemp objectAtIndex:0][@"catering_type_data"];
        
        [tempAllarray addObjectsFromArray:huodong];
        
        self.Cateringarray = [NSArray arrayWithArray:tempAllarray];
    }
    else
    {
        NSDictionary*cateringdic = all_dic;
        NSArray*temp = [cateringdic objectForKey:@"catering_data"];
        
        NSPredicate *predicate1 = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            NSString *dateV = (NSString *)evaluatedObject[@"catering_type"];
            return ([dateV intValue] == Catering_type);
        }];
        
        
        NSArray* dateinfo  = [temp filteredArrayUsingPredicate:predicate1];
        if(dateinfo.count>0)
          self.Cateringarray = [dateinfo objectAtIndex:0][@"catering_type_data"];//[dateinfo objectForKey:@"catering_type_data"];
    }
}


#pragma mark  Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if(self.tableView_Type==Stadium_TableView)
    {
        NSInteger count = self.Stadiumarray.count +1;
        return count;
    }
    else if(self.tableView_Type==Stadium_Park_TableView)
    {
        return self.Parkarray.count +1;//section one 只有google view, 其他Section 是标准的
    }
    else if(self.tableView_Type==Seat_TableView)
    {
        return self.Seatarray.count +1; //section one 只有seat image View, 其他Section 是标准的
    }
    else if(self.tableView_Type==Intrueduce_TableView)
    {
        return 1;
    }
    else
    {
        return self.Cateringarray.count + 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.tableView_Type==Stadium_TableView&&tableView.tag==Stadium_TableView)
    {
        if(section==0)
            return 1;
        else
        {
            NSDictionary*dic = [self.Stadiumarray objectAtIndex:section-1];
            NSArray *row = [dic objectForKey:@"section_content"];
            return row.count;
        }
       
    }
    else if(self.tableView_Type==Stadium_Park_TableView&&tableView.tag==Stadium_Park_TableView)
    {
        if(section==0)
            return 1;
        else
            {
                
                NSDictionary*dic = [self.Parkarray objectAtIndex:section-1];
                NSArray *row = [dic objectForKey:@"section_content"];
                if(![[dic objectForKey:@"section_status"] boolValue])
                    return row.count-1;
                else
                    return row.count;//1 代表 最后的button 栏位
            }
    }
    else if(self.tableView_Type==Seat_TableView&&tableView.tag==Seat_TableView)
    {
        if(section==0)
            return 1;
        else{
            NSDictionary*dic = [self.Seatarray objectAtIndex:section-1];
            NSArray *array = [dic allKeys];
            if(![[dic objectForKey:@"section_status"] boolValue])
                return 1;
            else
                return array.count;//1 代表 最后的button 栏位
            
        }
    }
    else if(self.tableView_Type==Intrueduce_TableView&&tableView.tag==Intrueduce_TableView)
    {
        return 18;
    }
    else
    {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
       return @"";
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(self.tableView_Type==Stadium_TableView&&tableView.tag==Stadium_TableView)
    {
        if(section==0)
        {
            return [UIView new];;
        }
        else
        {
            NSDictionary*dic = [self.Stadiumarray objectAtIndex:section-1];
             
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
            headerView.backgroundColor = [UIColor colorWithRed:0.962 green:0.962 blue:0.962 alpha:1.0];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ScaleW(30), 200, ScaleW(14))];
            NSString *sectionTitle = @"";
            sectionTitle = [dic objectForKey:@"section_Header"];
            
            if(![sectionTitle isEqualToString:@""])
            {
                titleLabel.text = sectionTitle;
                titleLabel.textColor = rgba(0, 121, 192, 1);
                titleLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightSemibold];
                [headerView addSubview:titleLabel];
                
                [titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
                    make.left.equalTo(headerView).offset(ScaleW(10));
                    make.height.mas_equalTo(ScaleW(14));
                    make.top.equalTo(headerView).inset(ScaleW(20));
                    make.bottom.equalTo(headerView).inset(ScaleW(16));
                }];
            }
            return headerView;
        }
    }
    else if(self.tableView_Type==Stadium_Park_TableView&&tableView.tag==Stadium_Park_TableView)
    {
            return [UIView new];
    }
    else if(self.tableView_Type==Seat_TableView&&tableView.tag==Seat_TableView)
    {
        return [UIView new];
    }
    else if(self.tableView_Type==Intrueduce_TableView&&tableView.tag==Intrueduce_TableView)
    {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
        headerView.backgroundColor = [UIColor colorWithRed:0.962 green:0.962 blue:0.962 alpha:1.0];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ScaleW(30), 200, ScaleW(14))];
        titleLabel.text = @"餐饮 table View header";
        titleLabel.textColor = rgba(0, 122, 96, 1);
        titleLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightSemibold];
        [headerView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(headerView).offset(0);
            //        make.centerY.equalTo(headerView);
            make.height.mas_equalTo(ScaleW(14));
            make.top.equalTo(headerView).inset(ScaleW(20));
            make.bottom.equalTo(headerView).inset(ScaleW(16));
        }];
        
        return headerView;
    }
    else
    {
        return [UIView new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if(self.tableView_Type==Stadium_TableView)
    {
        if(section==0)
            return 0;
        else
            return UITableViewAutomaticDimension;
    }
    else if(self.tableView_Type==Stadium_Park_TableView)
    {
        if(section==0)
            return 0;
        else
            return UITableViewAutomaticDimension;
    }
    else if(self.tableView_Type==Seat_TableView)
    {
        return UITableViewAutomaticDimension;
    }
    else if(self.tableView_Type==Intrueduce_TableView)
    {
        return UITableViewAutomaticDimension;
    }
    else
    {
        return UITableViewAutomaticDimension;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.tableView_Type==Stadium_TableView&&tableView.tag==Stadium_TableView)
    {
        if(indexPath.section==0)
            return ScaleW(250);
        else{
            NSDictionary*dic = [self.Stadiumarray objectAtIndex:indexPath.section-1];
                NSArray*rowArray = [dic objectForKey:@"section_content"];
                NSDictionary* rowdic = [rowArray objectAtIndex:indexPath.row];
                NSInteger rowHeight =  [[rowdic objectForKey:@"row_height"] intValue];
            return ScaleW(rowHeight);
        }
    }
    else if(self.tableView_Type==Stadium_Park_TableView&&tableView.tag==Stadium_Park_TableView)
    {
        if(indexPath.section==0)
            return ScaleW(210);
        else{
                NSDictionary*dic = [self.Parkarray objectAtIndex:indexPath.section-1];
                NSArray*rowArray = [dic objectForKey:@"section_content"];
                NSInteger rowHeight = 0;
                switch (indexPath.row) {
                case 0:
                case 2:
                //case 3:
                        rowHeight = ScaleW(35);
                    break;
                    
                case 1:
                {
                    if(![[dic objectForKey:@"section_status"] boolValue])
                    {
                        rowHeight = ScaleW(20);
                    }
                    else
                    {
                        NSDictionary* rowdic = [rowArray objectAtIndex:indexPath.row];
                        rowHeight =  [[rowdic objectForKey:@"row_height"] intValue];
                    }
                    
                }
                    break;
                        
                    case 3:
                        rowHeight = ScaleW(40);
                        break;
            }
            
            return rowHeight;
        }
    }
    else if(self.tableView_Type==Seat_TableView&&tableView.tag==Seat_TableView)
    {
        if(indexPath.section==0)
            return ScaleW(330);
        else
        {
            if(indexPath.row==5)
                return  ScaleW(50);
                else
            return UITableViewAutomaticDimension;
        }
    }
    else if(self.tableView_Type==Intrueduce_TableView&&tableView.tag==Intrueduce_TableView)
    {
        return UITableViewAutomaticDimension;
    }
    else
    {
        if(indexPath.section==0)
            return ScaleW(300);
        else
            return ScaleW(80);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.tableView_Type==Stadium_TableView&&tableView.tag==Stadium_TableView)
    {
            if(indexPath.section!=0)
            {
                NSDictionary*dic = [self.Stadiumarray objectAtIndex:indexPath.section-1];
                NSArray *row = [dic objectForKey:@"section_content"];
                NSDictionary *info = [row objectAtIndex:indexPath.row];
                
                EGStadiumViewCell *cell= [EGStadiumViewCell cellWithUITableView:tableView];
                [cell updateUI:info];
                return cell;
            }
            else
            {
                EGStadiumViewHeaderFooterView *cell= [EGStadiumViewHeaderFooterView cellWithUITableView:tableView];
                return cell;
            }
        
    }
    else if(self.tableView_Type==Stadium_Park_TableView&&tableView.tag==Stadium_Park_TableView)
    {
        if(indexPath.section!=0){
            NSDictionary*dic = [self.Parkarray objectAtIndex:indexPath.section-1];
            NSArray *row = [dic objectForKey:@"section_content"];
            if(indexPath.row==0)
                {
                    //header
                    NSDictionary *info = [row objectAtIndex:indexPath.row];
                    EGParkTitleCell *cell= [EGParkTitleCell cellWithUITableView:tableView];
                    [cell updaeUI:info];
                    return cell;
                }
                else if(indexPath.row==1 || indexPath.row==2)
                {
                    NSDictionary *info = [row objectAtIndex:indexPath.row];
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerCellIDheaderCellID_forPark_Two"];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headerCellIDheaderCellID_forPark_Two"];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    
                    if(indexPath.row==1)
                    {
                        cell.textLabel.textColor = ColorRGB(0x737373);
                        cell.textLabel.font = [UIFont systemFontOfSize:FontSize(14)];
                    }
                    else
                    {
                        cell.textLabel.font = [UIFont boldSystemFontOfSize:FontSize(14)];
                        cell.textLabel.textColor = UIColor.blackColor;
                    }
                        
                    cell.textLabel.numberOfLines = 0;
                    cell.textLabel.text = [info objectForKey:@"row_content"];
                    
                    return cell;
                    
                }else{
                    //button View
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerCellIDheaderCellID_forPark_Three"];
                    UILabel *button;
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headerCellIDheaderCellID_forPark_Three"];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        button = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScaleW(250), ScaleW(72))];
                        button.backgroundColor = ColorRGB(0x007A60);
                        button.textAlignment = NSTextAlignmentCenter;
                        button.layer.cornerRadius = 8.0f;
                        button.layer.masksToBounds = YES;
                        button.textColor = UIColor.whiteColor;
                        button.font = [UIFont boldSystemFontOfSize:FontSize(14)];
                        [cell.contentView addSubview:button];
                        [button mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerX.mas_equalTo(cell.contentView.mas_centerX);
                            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
                            make.width.mas_equalTo(ScaleW(250));
                            make.height.mas_equalTo(ScaleW(35));
                        }];
                    }
                    button.text = @"導航至目的地";
                    return cell;
                }
            
        }
        else
        {
            EGParkViewHeaderFooterView *cell= [EGParkViewHeaderFooterView cellWithUITableView:tableView];
            cell.sendTo = ^(NSInteger indext) {
                
                [self changeStatusForparkTabelViewFromMapView:indext];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:indext+1];
                [self.Park_MtableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                
                [self.Park_MtableView reloadData];
            };
            cell.E_N_Info = self.latiorlongitude;
            cell.E_N_Array = self.Parkarray;
            [cell updateGoogeMap];
            return cell;
        }
    }
    else if(self.tableView_Type==Seat_TableView&&tableView.tag==Seat_TableView)
    {
        if(indexPath.section!=0){
            
            NSDictionary*dic = [self.Seatarray objectAtIndex:indexPath.section-1];
            
            if(indexPath.row==0)
            {
                EGSeatFirstRowCell *cell = [EGSeatFirstRowCell cellWithUITableView:tableView];
                [cell updateUI:dic row:indexPath.section-1 type:self.changdi_type];
                return cell;
            }
            else if(indexPath.row==1 || indexPath.row==2)
            {
                EGSeatSecondRowCell *cell = [EGSeatSecondRowCell cellWithUITableView:tableView];
                cell.from_type = indexPath.row;
                [cell updaeUI:dic];
                return cell;
            }
            else if(indexPath.row==3 || indexPath.row==4)
            {
                EGSeatThirdRowCell *cell = [EGSeatThirdRowCell cellWithUITableView:tableView];
                cell.from_type = indexPath.row;
                [cell updaeUI:dic];
                return cell;
            }
            else
            {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerCellIDheaderCellID_forIngrueduce"];
                UILabel *button;
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headerCellIDheaderCellID_forIngrueduce"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    button = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScaleW(250), ScaleW(72))];
                    button.backgroundColor = ColorRGB(0x007A60);
                    button.textAlignment = NSTextAlignmentCenter;
                    button.layer.cornerRadius = 8.0f;
                    button.layer.masksToBounds = YES;
                    button.textColor = UIColor.whiteColor;
                    button.text = @"立即購票";
                    button.font = [UIFont boldSystemFontOfSize:FontSize(14)];
                    [cell.contentView addSubview:button];
                    [button mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.mas_equalTo(cell.contentView.mas_centerX);
                        make.centerY.mas_equalTo(cell.contentView.mas_centerY);
                        make.width.mas_equalTo(ScaleW(250));
                        make.height.mas_equalTo(ScaleW(35));
                    }];
                }
                
                
                
                return cell;
            }
        }
        else
        {
            EGSeatImageCell *cell= [EGSeatImageCell cellWithUITableView:tableView];

            if(_seattableView_imagecell_clear)
                [cell IntalImageView:_seattableView_imagecell_index];
            
            cell.changditypeblock = ^(NSDictionary* type){
                NSInteger changditype = [[type objectForKey:@"changdi_type"] intValue];
                NSInteger click_area = [[type objectForKey:@"click_area"] intValue];
                switch (changditype) {
                    case 101:
                    {
                        //切换澄清胡界面
                        self.changdi_type = 101;
                        [self IniSeatData:101];
                        [self changeStatusForseatTabelViewByindex:[[type objectForKey:@"changdi_area"] intValue]];
                        
                        if(click_area==1)
                        {
                            //表示，在imageView click, 跳转到对应的cell, 如果click_area是0，表示click switch button，不用跳转
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:[[type objectForKey:@"changdi_area"] intValue]+1];
                            [self.Seat_MtableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        }
                    }
                        break;
                    case 102:
                    {
                        //切换嘉怡界面1111
                        self.changdi_type = 102;
                        [self IniSeatData:102];
                        [self changeStatusForseatTabelViewByindex:[[type objectForKey:@"changdi_area"] intValue]];
                        
                        if(click_area==1)
                        {
                            //表示，在imageView click, 跳转到对应的cell, 如果click_area是0，表示click switch button，不用跳转
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:[[type objectForKey:@"changdi_area"] intValue]+1];
                            [self.Seat_MtableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        }
                    }
                        break;
                    
                }
                self.seattableView_imagecell_clear = NO;
                self.seattableView_imagecell_index = -1;
                [self.Seat_MtableView reloadData];
            };
            return cell;
        }
        
    }
    else if(self.tableView_Type==Intrueduce_TableView&&tableView.tag==Intrueduce_TableView)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerCellIDheaderCellID_forIngrueduce"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headerCellIDheaderCellID_forIngrueduce"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:FontSize(14)];
        cell.textLabel.text = @"";
        return cell;
    }
    else if(self.tableView_Type==Catering_TableView&&tableView.tag==Catering_TableView)
    {
        if(indexPath.section==0)
        {
            EGCateringImageCell *cell= [EGCateringImageCell cellWithUITableView:tableView];
            cell.block_catering = ^(NSInteger type) {
                self.catering_type = type;
                //[self IniCateringData:type];
                [self.Catering_MtableView.mj_header beginRefreshing];
                //[self.Catering_MtableView reloadData];
            };
            return  cell;
        }
        else
        {
            EGCateringInfoCell *cell= [EGCateringInfoCell cellWithUITableView:tableView];
            [cell setupWithInfo:[_Cateringarray objectAtIndex:indexPath.section-1]];
            return cell;
        }
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerCellIDheaderCellID_forother"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headerCellIDheaderCellID_forother"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.tableView_Type==Stadium_TableView)
    {
        NSLog(@"click in Stadium_TableView cell");
    }
    else if(self.tableView_Type==Stadium_Park_TableView)
    {
        if(indexPath.row==3)
        {
            NSLog(@"点击去 google map button");
            NSDictionary *dic = [self.Parkarray objectAtIndex:indexPath.section-1];
            [self sendgoogleMap:dic];
        }
        else
        {
            [self changeStatusForparkTabelView:indexPath];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.Park_MtableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
            
            [self.Park_MtableView reloadData];
        }
    }
    else if(self.tableView_Type==Seat_TableView)
    {
        if(indexPath.row==5)
        {
            [self buyTickets];
        }
        else{
            _seattableView_imagecell_clear = YES;
            _seattableView_imagecell_index = indexPath.section-1;
            [self changeStatusForseatTabelView:indexPath];
            [self.Seat_MtableView reloadData];
        }
    }
    else if(self.tableView_Type==Intrueduce_TableView)
    {
        NSLog(@"click in Intrueduce_TableView cell");
    }
    else
    {
        NSLog(@"click in Carrring_TableView cell");
    }
    
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UICollectionView class]])
    {
        return;
    }
    
    if ([scrollView isKindOfClass:[UITableView class]])
    {
        return;
    }
    
    NSInteger index = scrollView.contentOffset.x / UIScreen.mainScreen.bounds.size.width;
    
    [self setscrollerView:index + 50000];
    [self updateSelectedButton:index];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isUserScrolling = YES;  // 标记为用户滑动
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.isUserScrolling) return;  // 非用户滑动时不更新滑块位置
    
    if ([scrollView isKindOfClass:[UICollectionView class]])
    {
        return;
    }
    
    if ([scrollView isKindOfClass:[UITableView class]])
    {
        return;
    }
    
    CGFloat pageWidth = scrollView.frame.size.width;
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat progress = offsetX / pageWidth;
    // 更新滑块位置
    CGFloat buttonWidth = self.bt_width;
    self.bustatuslable.transform = CGAffineTransformMakeTranslation(progress * buttonWidth, 0);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"didFinishNavigation");
        
}
@end
