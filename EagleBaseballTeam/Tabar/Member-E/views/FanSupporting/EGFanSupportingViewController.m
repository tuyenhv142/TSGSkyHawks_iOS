//
//  ViewController.m
//  music
//
//  Created by Dragon_Zheng on 2/5/25.
//

#import "EGFanSupportingViewController.h"
#import "LXYHyperlinksButton.h"
#import "EGFanMemberInfoCell.h"
#import "EGShowMusicTextView.h"
#import "EGirlCollectionViewCell.h"
#import "EGFanDetailViewController.h"
#import "EGSocialLinksCell2.h"
#import "EGYingyuantuanDetailViewController.h"
#import "EGirlClassCollectionViewCell.h"
#import "EGClassDateCollectionViewCell.h"


@interface EGFanSupportingViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) UIView *baseview;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *fansClassView;//班表页面base view
@property (nonatomic, strong) UIView *fansmusicView;//应援歌曲base view
@property (nonatomic, strong) UIView *wingstarsView;//wing stars base view
@property (nonatomic, strong) UIView *fansquanView;//应援团base view
//@property (nonatomic, strong)UIView * jixiangwuView;


@property (nonatomic, strong) UIScrollView *mainscrollView;
@property (nonatomic, assign) BOOL isUserScrolling;  // 添加标记区分用户滑动和按钮点击
@property (nonatomic, strong) UIView *bustatuslable;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) LXYHyperlinksButton *fansclass_bt;//班表button
@property (nonatomic, strong) LXYHyperlinksButton *fansmusic_bt;//应援歌曲 button
@property (nonatomic, strong) LXYHyperlinksButton *wingstars_bt;//wing stars button
@property (nonatomic, strong) LXYHyperlinksButton *fansquan_bt;////应援团button
//@property (nonatomic, strong) LXYHyperlinksButton *jixiangwu_bt;
@property (nonatomic, weak) UITableView* MtableView;//应援歌曲 tableview
@property (nonatomic, strong)UICollectionView *fansView;//wing stars collection view , tag = 600
@property (nonatomic, strong)UICollectionView *yingyuantuanView;//应援团 collection view , tag = 601


//班表界面所有控件定义
@property (nonatomic, strong) UIView *fansClass_topbaseView;//班表页面日期base view
@property (nonatomic, strong) UIView *fansClass_topdateView;//班表页面显示日期view
@property (nonatomic,strong)UIButton *fansClass_predate_bt;
@property (nonatomic,strong)UIButton *fansClass_nextdate_bt;
@property (nonatomic,strong)UILabel *fansClass_datelabel;//班表页面显示日期label

@property (nonatomic, strong)UICollectionView *fansClassCollectiongView;//wing stars 班表 collection view , tag = 602
@property (nonatomic, strong)UICollectionView *fansClassDateCollectiongView;//wing stars date collection view , tag = 603
@property (nonatomic, strong)NSMutableArray *fansclassArray;
@property (nonatomic, strong)NSMutableArray *fansclassDateArray;
@property (nonatomic, strong)NSArray *classAllArray;
@property (nonatomic, strong)NSArray *tempdateArray;
@property (nonatomic, strong)NSArray *tempgirlclassArray;
@property (nonatomic,strong)NSDate *currentDate;
@property (nonatomic, assign) NSInteger current_year;
@property (nonatomic, assign) NSInteger current_month;


@property (nonatomic, strong)NSDictionary *wingstarsscheduledic;
@property (nonatomic, strong)NSArray *class_girlandAllarray; //这个Array 包含了应援和应援团所有人的信息的练，只给班表点击每个cell用。
@property (nonatomic, strong)NSArray *class_yingyuantuanAllarray;//这个Array 包含了应援和应援团所有人的信息的练，只给班表点击每个cell用。


@property (nonatomic,strong)UILabel *Nodata_datelabel;//没有数据 日期显示
@property (nonatomic,strong)UILabel *Nodata_classlabel;//没有数据 班表显示
@end

@implementation EGFanSupportingViewController
@synthesize Mainarray;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"鷹援資訊";
    
    self.currentDate = [NSDate date];
    // Do any additional setup after loading the view.
    self.sections = [NSMutableArray array];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"music" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    Mainarray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
    for(int i=0;i<Mainarray.count-1;i++)
    {
        [self.sections addObject:[Mainarray objectAtIndex:i]];
    }
    
    [self setupUI];
    
    //[self iniclassInfo];
    [self.fansClassCollectiongView.mj_header beginRefreshing];
    
    
    // 让 ScrollView 的滑动手势在返回手势失败后触发 右滑可返回
    UIGestureRecognizer *popGesture = self.navigationController.interactivePopGestureRecognizer;
    [self.mainscrollView.panGestureRecognizer requireGestureRecognizerToFail:popGesture];
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.backgroundColor = rgba(0, 71, 56, 1);
}

#pragma mark -------------整理应援班表数据-------------
-(void)iniclassInfo
{
    //获取应援，应援团每个人
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"girl" ofType:@"json"];
    NSData *data1 = [NSData dataWithContentsOfFile:path1];
    self.class_girlandAllarray = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingFragmentsAllowed error:nil];
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"yingyuantuan" ofType:@"json"];
    NSData *data2 = [NSData dataWithContentsOfFile:path2];
    self.class_yingyuantuanAllarray = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingFragmentsAllowed error:nil];
    
    
    //获取应援班表从中继
    self.fansclassDateArray = [NSMutableArray new];
    self.fansclassArray = [NSMutableArray new];
    EGRelayTokenModel *tokenModel = [EGLoginUserManager getRelayToken];
        NSDictionary *headerDict;
        if (tokenModel) {
            headerDict = @{@"Authorization":tokenModel.token ? tokenModel.token:@"",
                           @"Accept": @"application/json",  // 添加 Accept 头
                           @"Content-Type": @"application/json"  // 添加 Content-Type 头
            };
        }
    
    [[WAFNWHTTPSTool sharedManager] getWithURL:[EGServerAPI get_FansClass] parameters:@{} headers:headerDict success:^(NSDictionary *  _Nonnull response) {
            
        self.wingstarsscheduledic = response;
        self.classAllArray = self.wingstarsscheduledic[@"ws_schedule_data"];
        
        //组织日期数据
        //获取当前月份的数据中 应援出席的日期
        [self getCurrentMothArray:self.classAllArray];
        
        if(self.tempdateArray&&self.tempdateArray.count>0)
        {
            self.Nodata_datelabel.hidden = YES;
            self.fansClassCollectiongView.hidden = NO;
            self.fansClassDateCollectiongView.hidden = NO ;
            [self convertDateArray:self.tempdateArray];
            
            
            //组织应援班表数据
            //获取当月当日的应援班表数据，包括界数，应援信息
            
            NSString *sdate = [self.fansclassDateArray objectAtIndex:0][@"datestring"];
            [self getgirlMothDayArray:self.tempdateArray currentDate:sdate];
            [self convertwingstartArray:self.tempgirlclassArray];
            
            [self.fansClassCollectiongView reloadData];
            [self.fansClassDateCollectiongView reloadData] ;
        }
        else
        {
            self.Nodata_datelabel.hidden = NO;
            self.fansClassCollectiongView.hidden = YES;
            self.fansClassDateCollectiongView.hidden = YES ;
        }
        
        [self.fansClassCollectiongView.mj_header endRefreshing];
            
        } failure:^(NSError * _Nonnull error) {
          
            [self.fansClassCollectiongView.mj_header endRefreshing];
            self.Nodata_datelabel.hidden = NO;
            self.fansClassCollectiongView.hidden = YES;
            self.fansClassDateCollectiongView.hidden = YES ;
        }];
    
    
    
    
    
    
    
    
    
    //获取班表Array
    
}
-(void)convertwingstartArray:(NSArray*)array
{
    //获取到某一天的 wingstart 的信息
    //count 表示 界数
    [self.fansclassArray removeAllObjects];
    for(int i=0;i<array.count;i++)
    {
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:[array objectAtIndex:i][@"ws_type"] forKey:@"classtype"];
        [dic setObject:[NSNumber numberWithBool:YES] forKey:@"classstatus"];
        [dic setObject:[array objectAtIndex:i][@"ws_type_data"] forKey:@"classlist"];
        NSString *total = [array objectAtIndex:i][@"ws_type_total"];
        NSArray *array = [total componentsSeparatedByString:@"/"];
        [dic setObject:[array objectAtIndex:1] forKey:@"classtotalcount"];
        [self.fansclassArray addObject:dic];
    }
    
}

-(void)convertDateArray:(NSArray*)array
{
    for(int i=0;i<array.count;i++)
    {
        NSMutableDictionary *dic = [NSMutableDictionary new];
        if(i==0)
          [dic setObject:[NSNumber numberWithBool:YES] forKey:@"datestatus"];
        else
          [dic setObject:[NSNumber numberWithBool:NO] forKey:@"datestatus"];
        
        //获取当天的日期
        NSDate *current = [NSDate date];
        NSDateFormatter *formatter22 = [[NSDateFormatter alloc] init];
        [formatter22 setDateFormat:@"yyyy/MM/dd"]; // 设置格式为年-月
        NSString *dateString = [formatter22 stringFromDate:current];
        if([dateString isEqualToString:[array objectAtIndex:i][@"ws_day"]])
        {
            [dic setObject:[NSNumber numberWithBool:YES] forKey:@"current_datestatus"];//设置当天的stutus
        }
        else
            [dic setObject:[NSNumber numberWithBool:NO] forKey:@"current_datestatus"];
        
        
        [dic setObject:[array objectAtIndex:i][@"ws_day"] forKey:@"datestring"];
        [self.fansclassDateArray addObject:dic];
    }
    
}


//设置班表页面
-(void)updateClassView
{
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, Device_Height)];
    bView.layer.cornerRadius = ScaleW(10);
    bView.backgroundColor = UIColor.whiteColor;
    [self.fansClassView addSubview:bView];
    [bView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleW(10));
            make.centerX.mas_equalTo(self.fansClassView.mas_centerX);
            make.height.mas_equalTo(ScaleW(150));
            make.width.mas_equalTo(ScaleW(335));
    }];
    self.fansClass_topbaseView = bView;
    
    bView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, Device_Height)];
        bView.layer.cornerRadius = ScaleW(15);
    bView.backgroundColor = UIColor.whiteColor;//ColorRGB(0xF3F4F6);
        [self.fansClass_topbaseView addSubview:bView];
        [bView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleW(15));
            make.centerX.mas_equalTo(self.fansClass_topbaseView.mas_centerX);
            make.height.mas_equalTo(ScaleW(30));
            make.width.mas_equalTo(ScaleW(300));
        }];
    self.fansClass_topdateView = bView;
        
        
        UIButton *rememberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rememberBtn.tag = 101;
        rememberBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-5, -5, -5, -50);
        [rememberBtn setImage:[UIImage imageNamed:@"chevron-left"] forState:UIControlStateNormal];
        [rememberBtn setImage:[UIImage imageNamed:@"chevron-left"] forState:UIControlStateSelected];//gouXuanC
        [rememberBtn addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventTouchUpInside];
        [self.fansClass_topdateView addSubview:rememberBtn];
        [rememberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.fansClass_topdateView.mas_centerY);
            make.left.mas_equalTo(ScaleW(5));
            make.height.width.mas_equalTo(ScaleW(25));
        }];
        
        
        rememberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rememberBtn.tag = 102;
        rememberBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-5, -5, -5, -50);
        [rememberBtn setImage:[UIImage imageNamed:@"chevron-right-2"] forState:UIControlStateNormal];
        [rememberBtn setImage:[UIImage imageNamed:@"chevron-right-2"] forState:UIControlStateSelected];//gouXuanC
        [rememberBtn addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventTouchUpInside];
        [self.fansClass_topdateView addSubview:rememberBtn];
        [rememberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.fansClass_topdateView.mas_centerY);
            make.right.mas_equalTo(-ScaleW(5));
            make.height.width.mas_equalTo(ScaleW(25));
        }];
        
        
        UILabel *labelinimage = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], 40, 67)];
        labelinimage.text = @"2025/04";
        labelinimage.textColor = UIColor.blackColor;
        labelinimage.font = [UIFont boldSystemFontOfSize:FontSize(18)];
        [self.fansClass_topdateView addSubview:labelinimage];
        [labelinimage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.fansClass_topdateView.mas_centerY);
            make.centerX.mas_equalTo(self.fansClass_topdateView.mas_centerX);
            make.height.mas_equalTo(ScaleW(24));
            make.width.mas_equalTo(ScaleW(80));
        }];
    self.fansClass_datelabel = labelinimage;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    self.currentDate = [NSDate date];
    self.current_year = [calendar component:NSCalendarUnitYear fromDate:self.currentDate];
    self.current_month = [calendar component:NSCalendarUnitMonth fromDate:self.currentDate];
    NSLog(@"year = %ld, month = %ld",self.current_year,self.current_month);
    [self.fansClass_datelabel setText:[self dateFromYEARandMonth:self.current_year M:self.current_month]];
    
    
    //date collection view in 班表界面
    UICollectionViewFlowLayout *Datelayout = [[UICollectionViewFlowLayout alloc] init];
    Datelayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//横向滚动
    UICollectionView *DatecollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:Datelayout];
    DatecollectionView.tag = 603;
    DatecollectionView.backgroundColor= UIColor.whiteColor;//[UIColor colorWithRed:0 green:71.0/255.0 blue:56.0/255 alpha:1.0];
    DatecollectionView.delegate = self;
    DatecollectionView.dataSource = self;
    DatecollectionView.showsHorizontalScrollIndicator = NO;
    DatecollectionView.showsVerticalScrollIndicator = NO;
    [self.fansClass_topbaseView addSubview:DatecollectionView];
    [DatecollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.fansClass_datelabel.mas_centerX);
        make.top.mas_equalTo(self.fansClass_datelabel.mas_bottom).offset(ScaleW(20));
            make.right.mas_equalTo(-ScaleW(20));
            make.height.mas_equalTo(ScaleW(60));
        }];
        [DatecollectionView registerClass:[EGClassDateCollectionViewCell class] forCellWithReuseIdentifier:@"EGClassDateCollectionViewCell"];
        
        self.fansClassDateCollectiongView = DatecollectionView;
    
    
    self.Nodata_datelabel = [UILabel new];
    self.Nodata_datelabel.text = @"暫無數據";
    self.Nodata_datelabel.textColor = UIColor.grayColor;
    self.Nodata_datelabel.font = [UIFont systemFontOfSize:FontSize(14)];
    [self.fansClass_topbaseView addSubview:self.Nodata_datelabel];
    [self.Nodata_datelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.fansClass_datelabel.mas_bottom).offset(ScaleW(30));
        make.centerX.mas_equalTo(self.fansClass_topbaseView.mas_centerX);
        make.width.mas_equalTo(ScaleW(80));
        make.height.mas_equalTo(ScaleW(25));
    }];
    self.Nodata_datelabel.hidden = YES;
    
    
    //player collection view in 班表界面
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;//竖直滚动
    layout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
    layout.minimumLineSpacing = 10;
//    layout.itemSize = 10;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.tag = 602;
    collectionView.backgroundColor=rgba(245, 245, 245, 1);
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator =NO;
    [self.fansClassView addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.fansClass_topbaseView.mas_bottom).offset(ScaleW(10));
        make.left.mas_equalTo(ScaleW(20));
        make.right.mas_equalTo(-ScaleW(20));
        make.bottom.mas_equalTo(0);
    }];
    [collectionView registerClass:[EGirlClassCollectionViewCell class] forCellWithReuseIdentifier:@"EGirlClassCollectionViewCell"];
    
    // 注册header类
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerIdentifier"];
    
    self.fansClassCollectiongView = collectionView;
    self.fansClassCollectiongView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self iniclassInfo];
    }];
}

-(void)changeDate:(UIButton*)bt
{
    switch (bt.tag) {
        case 101://前一个月
            [self beforeDate];
            break;
            
            
        case 102://后一个月
            [self nextDate];
            break;
        
    }
}

-(void)getCurrentMothArray:(NSArray*)array
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth /*| NSCalendarUnitDay*/) fromDate:self.currentDate];

    // 设置日期组件为当前月份的第一天
    components.day = 1;
    NSDate *firstDayOfMonth = [calendar dateFromComponents:components];
    NSDateFormatter *formatter22 = [[NSDateFormatter alloc] init];
    [formatter22 setDateFormat:@"yyyy/MM"]; // 设置格式为年-月
    NSString *dateString = [formatter22 stringFromDate:firstDayOfMonth];
    
    NSPredicate *predicate1 = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSString *dateV = (NSString *)evaluatedObject[@"ws_month"];
        return ([dateV isEqualToString:dateString]);
    }];
    
    
    NSArray* dateinfo  = [array filteredArrayUsingPredicate:predicate1];
    if(dateinfo.count>0)
    self.tempdateArray = [dateinfo objectAtIndex:0][@"ws_month_data"];
    

}

-(void)getgirlMothDayArray:(NSArray*)array currentDate:(NSString*)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.currentDate];

    // 设置日期组件为当前月份的第一天
    components.day = 1;
    NSDate *firstDayOfMonth = [calendar dateFromComponents:components];
    NSDateFormatter *formatter22 = [[NSDateFormatter alloc] init];
    [formatter22 setDateFormat:@"yyyy/MM/dd"]; // 设置格式为年-月
    NSString *dateString = [formatter22 stringFromDate:firstDayOfMonth];
    
    NSPredicate *predicate1 = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSString *dateV = (NSString *)evaluatedObject[@"ws_day"];
        return ([dateV isEqualToString:date]);
    }];
    
    
    NSArray* dateinfo  = [array filteredArrayUsingPredicate:predicate1];
    if(dateinfo.count>0)
      self.tempgirlclassArray = [dateinfo objectAtIndex:0][@"ws_day_data"];
}



-(void)beforeDate
{
    [self.fansclassDateArray removeAllObjects];
    [self.fansclassArray removeAllObjects];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth /*| NSCalendarUnitDay*/ fromDate:self.currentDate];
    
    // 获取当前月份
    NSInteger currentMonth = [components month];
    // 减去一个月
    components.month = currentMonth - 1;
    self.currentDate = [calendar dateFromComponents:components];
    
    self.current_year = [calendar component:NSCalendarUnitYear fromDate:self.currentDate];
    self.current_month = [calendar component:NSCalendarUnitMonth fromDate:self.currentDate];
//    NSLog(@"year = %ld, month = %ld",self.current_year,self.current_month);
    
    [self.fansClass_datelabel setText:[self dateFromYEARandMonth:self.current_year M:self.current_month]];
    
    // 设置日期组件为当前月份的第一天
    components.day = 1;
    NSDate *firstDayOfMonth = [calendar dateFromComponents:components];
    NSDateFormatter *formatter22 = [[NSDateFormatter alloc] init];
    [formatter22 setDateFormat:@"yyyy/MM"]; // 设置格式为年-月
    NSString *dateString = [formatter22 stringFromDate:firstDayOfMonth];
        
    NSPredicate *predicate1 = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            NSString *dateV = (NSString *)evaluatedObject[@"ws_month"];
            return ([dateV isEqualToString:dateString]);
    }];
        
        
    NSArray* dateinfo  = [self.classAllArray filteredArrayUsingPredicate:predicate1];
    if(dateinfo.count>0){
        
        _Nodata_datelabel.hidden = YES;
        self.fansClassCollectiongView.hidden = NO;
        self.fansClassDateCollectiongView.hidden = NO ;
        
        self.tempdateArray = [dateinfo objectAtIndex:0][@"ws_month_data"];
        
        //组织日期数据
        //获取当前月份的数据中 应援出席的日期
        [self convertDateArray:self.tempdateArray];
        
        //组织应援班表数据
        //获取当月当日的应援班表数据，包括界数，应援信息
        NSString *sdate = [self.fansclassDateArray objectAtIndex:0][@"datestring"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd"]; // 设置日期格式，例如 "年-月-日 时:分:秒"
        self.currentDate = [formatter dateFromString:sdate];
        
        [self getgirlMothDayArray:self.tempdateArray currentDate:sdate];
        [self convertwingstartArray:self.tempgirlclassArray];
        
        [self.fansClassCollectiongView reloadData];
        [self.fansClassDateCollectiongView reloadData];
    }
    else
    {
        self.Nodata_datelabel.hidden = NO;
        self.fansClassCollectiongView.hidden = YES;
        self.fansClassDateCollectiongView.hidden = YES ;
    }
}



-(void)nextDate
{
    [self.fansclassDateArray removeAllObjects];
    [self.fansclassArray removeAllObjects];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.currentDate];
     
    //NSDate *start_date = self.currentDate;
    
    // 获取当前月份
    NSInteger currentMonth = [components month];
     
    // 加上一个月
    components.month = currentMonth + 1;
    self.currentDate = [calendar dateFromComponents:components];
    self.current_year = [calendar component:NSCalendarUnitYear fromDate:self.currentDate];
    self.current_month = [calendar component:NSCalendarUnitMonth fromDate:self.currentDate];
    [self.fansClass_datelabel setText:[self dateFromYEARandMonth:self.current_year M:self.current_month]];
    
    // 设置日期组件为当前月份的第一天
    components.day = 1;
    NSDate *firstDayOfMonth = [calendar dateFromComponents:components];
    NSDateFormatter *formatter22 = [[NSDateFormatter alloc] init];
    [formatter22 setDateFormat:@"yyyy/MM"]; // 设置格式为年-月
    NSString *dateString = [formatter22 stringFromDate:firstDayOfMonth];
        
    NSPredicate *predicate1 = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            NSString *dateV = (NSString *)evaluatedObject[@"ws_month"];
            return ([dateV isEqualToString:dateString]);
    }];
        
        
    NSArray* dateinfo  = [self.classAllArray filteredArrayUsingPredicate:predicate1];
    if(dateinfo.count>0){
        
        _Nodata_datelabel.hidden = YES;
        self.fansClassCollectiongView.hidden = NO;
        self.fansClassDateCollectiongView.hidden = NO ;
        self.tempdateArray = [dateinfo objectAtIndex:0][@"ws_month_data"];
        
        //组织日期数据
        //获取当前月份的数据中 应援出席的日期
        [self convertDateArray:self.tempdateArray];
        
        //组织应援班表数据
        //获取当月当日的应援班表数据，包括界数，应援信息
        NSString *sdate = [self.fansclassDateArray objectAtIndex:0][@"datestring"];
                
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd"]; // 设置日期格式，例如 "年-月-日 时:分:秒"
        self.currentDate = [formatter dateFromString:sdate];
        
        [self getgirlMothDayArray:self.tempdateArray currentDate:sdate];
        [self convertwingstartArray:self.tempgirlclassArray];
        
        [self.fansClassCollectiongView reloadData];
        [self.fansClassDateCollectiongView reloadData];
    }
    else
    {
        self.Nodata_datelabel.hidden = NO;
        self.fansClassCollectiongView.hidden = YES;
        self.fansClassDateCollectiongView.hidden = YES ;
    }
     
}

-(NSString*)dateFromYEARandMonth:(NSInteger)year M:(NSInteger)month
{
    NSString *string = [NSString new];
    if(month<10)
      string = [string stringByAppendingFormat:@"%ld/0%ld",year,month];
    else
        string = [string stringByAppendingFormat:@"%ld/%ld",year,month];
    return string;
}

-(NSDate*)getfirstday:(NSInteger)year M:(NSInteger)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];

    // 获取该月的第一天
    NSDate *firstDayOfMonth = nil;
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:1]; // 设置第一天为该月的第一天
    firstDayOfMonth = [calendar dateFromComponents:components]; // 使用这个日期对象来获取这个月的信息
    return firstDayOfMonth;
}

-(NSDate*)getlastday:(NSInteger)year M:(NSInteger)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];

    // 获取该月的第一天
    NSDate *firstDayOfMonth = nil;
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:1]; // 设置第一天为该月的第一天
    firstDayOfMonth = [calendar dateFromComponents:components]; // 使用这个日期对象来获取这个月的信息
    
    
    
    components.month += 1;
    components.day = 1;
    NSDate *nextMonthFirstDay = [calendar dateFromComponents:components];
     
    // 减去一天得到当前月份的最后一天
    NSDate *lastDayOfMonth = [calendar dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:nextMonthFirstDay options:0];

    return lastDayOfMonth;
}


-(NSDictionary*)getgirlInfobyNo:(NSInteger)No_String
{
    NSDictionary *result = nil;
    for(int i=0;i<self.class_girlandAllarray.count;i++)
    {
        NSDictionary *dic = [self.class_girlandAllarray objectAtIndex:i];
        if(No_String == [[dic objectForKey:@"girlNO"] intValue])
        {
            result = dic;//找到对应号码的gril
            break;
        }
    }
    
    return result;
}

-(NSDictionary*)getyingyuantuanInfobyNo:(NSString*)nick_String
{
    NSDictionary *result = nil;
    for(int i=0;i<self.class_yingyuantuanAllarray.count;i++)
    {
        NSDictionary *dic = [self.class_yingyuantuanAllarray objectAtIndex:i];
        if([nick_String isEqualToString: [dic objectForKey:@"girlnickName"]])
        {
            result = dic;//找到对应号码的gril
            break;
        }
    }
    
    return result;
}

#pragma mark --------------------应援歌曲, 应援团, 应援界面---------------
-(void)initgirlInfo
{
    
    if(self.fansType==0){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"girl" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        self.girlArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
        self.girlArray = [self inorderArray];
        [self.fansView reloadData];
        [self.fansView.mj_header endRefreshing];
    }
    else
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"yingyuantuan" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        self.girlArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
        [self.yingyuantuanView reloadData];
        [self.yingyuantuanView.mj_header endRefreshing];
    }
    
   
}

- (UITableView *)settableView
{
   if (self.MtableView == nil) {
    
       if (@available(iOS 13.0, *)) {
           UITableView *tableView2 = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
           tableView2.delegate = self;
           tableView2.dataSource = self;
           tableView2.backgroundColor = rgba(245, 245, 245, 1);
           
           tableView2.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
           tableView2.showsVerticalScrollIndicator = NO;
           tableView2.estimatedRowHeight = 100;
           self.MtableView = tableView2;
           [self.fansmusicView addSubview:self.MtableView];
       } else {
           // Fallback on earlier versions
       }
   
    
}
return self.MtableView;
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
    bt.tag = 50000;
    [bt setTitle:@"鷹援班表" forState:UIControlStateNormal];
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
            make.width.mas_equalTo((ScaleW(80)));
            make.height.mas_equalTo(ScaleW(50));
        }];
    [self.fansclass_bt setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateSelected];
    [self.fansclass_bt setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
    [self.fansclass_bt setColor:[UIColor clearColor]];
    
    
    bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(0, 0, 100, 36)];
    bt.tag = 50001;
    [bt setTitle:@"鷹援歌曲" forState:UIControlStateNormal];
    [bt setTitleColor:rgba(212, 212, 212, 1) forState:UIControlStateSelected];
    [bt setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateNormal];
    bt.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    [bt addTarget:self action:@selector(buttonclick:) forControlEvents:(UIControlEventTouchUpInside)];

    [self.topView addSubview:bt];
    [bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
    self.fansmusic_bt = bt;
    [self.fansmusic_bt setSelected:NO];
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.fansclass_bt.mas_right).offset(0);
            make.top.mas_equalTo(ScaleW(5));
            make.width.mas_equalTo((ScaleW(80)));
            make.height.mas_equalTo(ScaleW(50));
        }];
    
    [self.fansmusic_bt setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateSelected];
    [self.fansmusic_bt setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
    [self.fansquan_bt setColor:[UIColor clearColor]];
    
    bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(0, 0, 100, 36)];
    bt.tag = 50002;
    [bt setTitle:@"Wing Stars" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(buttonclick:) forControlEvents:(UIControlEventTouchUpInside)];
    bt.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    [self.topView addSubview:bt];
    [bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
    [self.wingstars_bt setSelected:NO];
    self.wingstars_bt = bt;
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.fansmusic_bt.mas_right).offset(0);
            make.top.mas_equalTo(ScaleW(5));
            make.width.mas_equalTo((ScaleW(80)));
            make.height.mas_equalTo(ScaleW(50));
        }];
    
    [self.wingstars_bt setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateSelected];
    [self.wingstars_bt setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
    [self.wingstars_bt setColor:[UIColor clearColor]];
    //团长 button
    bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(0, 0, 100, 36)];
    bt.tag = 50003;
    [bt setTitle:@"應援團" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(buttonclick:) forControlEvents:(UIControlEventTouchUpInside)];
    bt.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    [self.topView addSubview:bt];
    [bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
    self.fansquan_bt = bt;
  
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.wingstars_bt.mas_right).offset(0);
            make.top.mas_equalTo(ScaleW(5));
            make.width.mas_equalTo((ScaleW(80)));
            make.height.mas_equalTo(ScaleW(50));
        }];
    [self.fansquan_bt setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateSelected];
    [self.fansquan_bt setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
    [self.fansquan_bt setColor:[UIColor clearColor]];
    
    //吉祥物button
//    bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(0, 0, 100, 36)];
//    bt.tag = 50004;
//    [bt setTitle:@"吉祥物" forState:UIControlStateNormal];
//    [bt addTarget:self action:@selector(buttonclick:) forControlEvents:(UIControlEventTouchUpInside)];
//    bt.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
//    [self.topView addSubview:bt];
//    [bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
//    self.jixiangwu_bt = bt;
//
//    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.fansquan_bt.mas_right).offset(0);
//            make.top.mas_equalTo(ScaleW(5));
//            make.width.mas_equalTo((ScaleW(80)));
//            make.height.mas_equalTo(ScaleW(50));
//        }];
//    [self.jixiangwu_bt setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateSelected];
//    [self.jixiangwu_bt setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.wingstars_bt).offset(0);
//        make.bottom.equalTo(self.topView).offset(0);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(1.5);
    }];
    
    // 滑块指示器
    self.bustatuslable = [[UIView alloc] init];
        self.bustatuslable.backgroundColor = rgba(0, 122, 96, 1); //rgba(0, 122, 96, 1)
    [self.topView addSubview:self.bustatuslable];
        
    [self.bustatuslable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.topView);
        make.bottom.equalTo(lineView);
        make.width.mas_equalTo(ScaleW(80));
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
//            make.top.equalTo(self.topView.mas_bottom);
            make.top.equalTo(lineView.mas_bottom);
            
            make.left.right.bottom.equalTo(self.baseview);
        }];
    self.mainscrollView.contentSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width * 4, 0);
    self.mainscrollView.bounces = YES;
    
    
    
    self.fansClassView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, Device_Height-[UIDevice de_navigationFullHeight]-self.topView.frame.size.height)];
    [self.mainscrollView addSubview:self.fansClassView];

    [self updateClassView];
    
    
    self.fansmusicView = [[UIView alloc] initWithFrame:CGRectMake(Device_Width, 0, Device_Width, Device_Height-[UIDevice de_navigationFullHeight]-self.topView.frame.size.height)];
    [self.mainscrollView addSubview:self.fansmusicView];

    //应援歌曲页面只有table View
    //set 影院歌曲table view
    [self.settableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    [self.MtableView reloadData];
    
//    self.fansquanView.backgroundColor=rgba(245, 245, 245, 1);
    //WingStart 页面
    self.wingstarsView = [[UIView alloc] initWithFrame:CGRectMake(Device_Width*2,0, Device_Width, Device_Height-[UIDevice de_navigationFullHeight]-self.topView.frame.size.height)];
    self.wingstarsView.backgroundColor=rgba(245, 245, 245, 1);
    [self.mainscrollView addSubview:self.wingstarsView];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;//竖直滚动
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.tag = 600;
    collectionView.backgroundColor=rgba(245, 245, 245, 1);
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator =NO;
    [self.wingstarsView addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(0));
        make.left.mas_equalTo(ScaleW(20));
        make.right.mas_equalTo(-ScaleW(20));
        make.bottom.mas_equalTo(-ScaleW(20));
    }];
    [collectionView registerClass:[EGirlCollectionViewCell class] forCellWithReuseIdentifier:@"EGirlCollectionViewCell"];
    
    self.fansView = collectionView;
//    self.fansView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        self.isUserScrolling = NO;
//        self.fansType = 0;
//        [self initgirlInfo];
//       
//    }];
    
    
    //团长界面
    self.fansquanView = [[UIView alloc] initWithFrame:CGRectMake(3*Device_Width,0, Device_Width, Device_Height-[UIDevice de_navigationFullHeight]-self.topView.frame.size.height)];
    //self.fansquanView.backgroundColor = [UIColor yellowColor];
    [self.mainscrollView addSubview:self.fansquanView];
    
    
    layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;//竖直滚动
    collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.tag = 601;
    collectionView.backgroundColor=rgba(245, 245, 245, 1);
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator =NO;
    [self.fansquanView addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(0));
        make.left.mas_equalTo(ScaleW(20));
        make.right.mas_equalTo(-ScaleW(20));
        make.bottom.mas_equalTo(-ScaleW(20));
    }];
    [collectionView registerClass:[EGirlCollectionViewCell class] forCellWithReuseIdentifier:@"EGirlCollectionViewCell"];
    self.yingyuantuanView = collectionView;
//    self.yingyuantuanView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        self.isUserScrolling = NO;
//        self.fansType = 1;
//        [self initgirlInfo];
//        
//    }];
//    //吉祥物界面
//    self.jixiangwuView = [[UIView alloc] initWithFrame:CGRectMake(3*Device_Width, 0, Device_Width, Device_Height-[UIDevice de_navigationFullHeight]-self.topView.frame.size.height)];
//    self.jixiangwuView.backgroundColor = [UIColor redColor];
//    [self.mainscrollView addSubview:self.jixiangwuView];
    
}

-(void)playeryoutubeVideo:(NSString*)vURL
{
    //截取video id frow https://www.youtube.com/watch?v=RdB5dtrhzSU, 其中https://www.youtube.com/watch?v=为固定长度
    
//    NSString *base = @"https://www.youtube.com/watch?v=";
//
//
//    NSString *originalString = vURL;
//    NSString *videoId = [originalString substringFromIndex:base.length];
//    NSLog(@"%@", videoId); // 输出: World
    
    // 尝试打开 YouTube App
    NSString *youtubeAppUrl = vURL;//[NSString stringWithFormat:@"youtube://watch?v=%@", videoId];
    NSURL *appURL = [NSURL URLWithString:youtubeAppUrl];
    
    // 如果无法打开 App，则使用 Safari 打开网页版
    //NSString *webUrl = [NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@", videoId];
    NSURL *webURL = [NSURL URLWithString:vURL];
    
    if ([[UIApplication sharedApplication] canOpenURL:appURL]) {
        [[UIApplication sharedApplication] openURL:appURL options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:webURL options:@{} completionHandler:nil];
    }
}

-(void)playeryoutubeAudio:(NSString*)vURL
{
    
    NSArray *components = [vURL componentsSeparatedByString:@"v="];
    NSURL *webURL = [NSURL URLWithString:vURL];
    if (components.count > 1) {
        NSString *afterV = components[1];
        NSArray *idComponents = [afterV componentsSeparatedByString:@"&"];
        NSString *videoID = idComponents[0];
        NSLog(@"Video ID: %@", videoID); // 输出: HG_Kt-hjAw8
        
        // 尝试打开 YouTube App
        NSString *youtubeAppUrl = [NSString stringWithFormat:@"youtube://watch?v=%@", videoID];
        NSURL *appURL = [NSURL URLWithString:youtubeAppUrl];
        // 如果无法打开 App，则使用 Safari 打开网页版

        if ([[UIApplication sharedApplication] canOpenURL:appURL]) {
            [[UIApplication sharedApplication] openURL:appURL options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:webURL options:@{} completionHandler:nil];
        }
    }else{
        [[UIApplication sharedApplication] openURL:webURL options:@{} completionHandler:nil];
    }

//    // 如果无法打开 App，则使用 Safari 打开网页版
//    NSURL *webURL = [NSURL URLWithString:vURL];
//    [[UIApplication sharedApplication] openURL:webURL options:@{} completionHandler:nil];
}

-(void)setscrollerView:(NSInteger)bt_index
{
    [self.fansquan_bt setColor:[UIColor clearColor]];
    [self.fansmusic_bt setColor:[UIColor clearColor]];
    [self.wingstars_bt setColor:[UIColor clearColor]];
    [self.fansclass_bt setColor:[UIColor clearColor]];
    
    
    // 重置所有按钮状态
    [self.fansquan_bt setSelected:NO];
    [self.fansmusic_bt setSelected:NO];
    [self.wingstars_bt setSelected:NO];
    [self.fansclass_bt setSelected:NO];
    
    self.fansquanView.hidden = NO;
    self.fansmusicView.hidden = NO;
    self.wingstarsView.hidden = NO;
    self.fansClassView.hidden = NO;
    
    self.fansType = 0;
    switch (bt_index) {
        case 50000:
        {
            [self.fansclass_bt setSelected:YES];
            
            [self.fansclass_bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
            self.fansClassView.hidden = NO;
        }
            break;
        case 50001:
        {
            //self.fansType = 0;
            //[self initgirlInfo];
            //[self.MtableView reloadData];
            [self.fansmusic_bt setSelected:YES];
            
            [self.fansmusic_bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
            self.fansmusicView.hidden = NO;
        }
            break;
        case 50002:
        {
            self.fansType = 0;
            [self initgirlInfo];
            [self.fansView reloadData];
            [self.wingstars_bt setSelected:YES];
            [self.wingstars_bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
            self.wingstarsView.hidden = NO;
        }
            break;
        case 50003:
        {
            [self.fansquan_bt setSelected:YES];
            self.fansType = 1;
            [self initgirlInfo];
            [self.fansquan_bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
            self.fansquanView.hidden = NO;
            [self.yingyuantuanView reloadData];
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
        self.bustatuslable.transform = CGAffineTransformMakeTranslation(index * ScaleW(80), 0);
    }];
    
   
}





-(void)buttonclick:(UIButton*)bt
{
    self.isUserScrolling = NO;  // 标记为按钮点击
    [self.fansquan_bt setColor:[UIColor clearColor]];
    [self.fansmusic_bt setColor:[UIColor clearColor]];
    [self.wingstars_bt setColor:[UIColor clearColor]];
    [self.fansclass_bt setColor:[UIColor clearColor]];
    
    // 重置所有按钮状态
    [self.fansquan_bt setSelected:NO];
    [self.fansmusic_bt setSelected:NO];
    [self.wingstars_bt setSelected:NO];
    [self.fansclass_bt setSelected:NO];
    
    self.fansquanView.hidden = NO;
    self.fansmusicView.hidden = NO;
    self.wingstarsView.hidden = NO;
    self.fansClassView.hidden = NO;
    
    self.fansType = 0;
    
    switch (bt.tag) {
        case 50000:
        {
            [self.fansclass_bt setSelected:YES];
            [self.fansclass_bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
            self.fansClassView.hidden = NO;
        }
            break;
        case 50001:
        {
//            self.fansType = 0;
            [self.fansmusic_bt setSelected:YES];
            [self.fansmusic_bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
            self.fansmusicView.hidden = NO;
        }
            break;
        case 50002:
        {
            self.fansType = 0;
            [self initgirlInfo];
            [self.fansView reloadData];
            [self.wingstars_bt setSelected:YES];
            [self.wingstars_bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
            self.wingstarsView.hidden = NO;
        }
            break;
        case 50003:
        {
            [self.fansquan_bt setSelected:YES];
            self.fansType = 1;
            [self initgirlInfo];
            [self.fansquan_bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
            self.fansquanView.hidden = NO;
            [self.yingyuantuanView reloadData];
        }
            break;
//        case 50004:
//        {
//            [self.jixiangwu_bt setColor:rgba(0, 122, 96, 1)];
//            self.jixiangwu_bt.hidden = NO;
//        }
//            break;
        default:
            break;
    }
    
        [self updateSelectedButton:bt.tag-50000];
        [self.mainscrollView setContentOffset:CGPointMake((bt.tag-50000) * UIScreen.mainScreen.bounds.size.width, 0) animated:YES];

}


-(void)showorhideAction:(UIButton*)bt
{
        bt.selected = !bt.selected;
    
        NSNumber *extraParam = objc_getAssociatedObject(bt, "extraParamKey");
        NSInteger clickindex = [extraParam integerValue];
    
        NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:[self.fansclassArray objectAtIndex:clickindex]];
        bool currentstatus = [[dic objectForKey:@"classstatus"] boolValue];
        [dic setObject:[NSNumber numberWithBool:!currentstatus] forKey:@"classstatus"];
    
        [self.fansclassArray replaceObjectAtIndex:clickindex withObject:dic];
    
//        [self.fansClassCollectiongView reloadData];
    
    [self.fansClassCollectiongView reloadSections:[NSIndexSet indexSetWithIndex:clickindex]];
}

#pragma mark  Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 4){
        return 1;
    }
    return [self.sections[section][@"member"] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 4){
        return 0;
    }
    return self.sections[section][@"category"];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 4){
        return [UIView new];
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
    headerView.backgroundColor = [UIColor colorWithRed:0.962 green:0.962 blue:0.962 alpha:1.0];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ScaleW(30), 200, ScaleW(14))];
    titleLabel.text = self.sections[section][@"category"];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return ScaleW(55);;
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {


    if (indexPath.section == 4){
        // 功能按钮单元格
        EGSocialLinksCell2 *cell = [EGSocialLinksCell2 cellWithUITableView:tableView];

               cell.selectionStyle = UITableViewCellSelectionStyleNone;
               return cell;
    }else{
        
        NSDictionary *section = self.sections[indexPath.section];
        NSDictionary *item = section[@"member"][indexPath.row];
        EGFanMemberInfoCell *cell= [EGFanMemberInfoCell cellWithUITableView:tableView];
        cell.fansInfoBlock = ^(NSMutableDictionary* dic,NSInteger type){
            if(type==60003){
                EGShowMusicTextView *picker = [[EGShowMusicTextView alloc] init];
                [picker setMusicText:dic];
                [picker popPickerView];
            }
            else if(type==60001)
            {
                //vedio link
                [self playeryoutubeVideo:[item objectForKey:@"memberVideolink"]];
            }
            else{
                //music link
                [self playeryoutubeAudio:[item objectForKey:@"memberMusiclink"]];
            }
        } ;
        [cell setupWithInfo:item];
       
        return cell;
    }
    
}


#pragma  mark collection View for girl
#pragma mark delegate
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if(collectionView.tag==602)
    {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerIdentifier" forIndexPath:indexPath];
            
            // 移除之前的所有子视图，避免复用问题, 否则会不停地add subview
            [headerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            
            if(indexPath.section!=0){
                UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 1, headerView.frame.size.width, 1)];
                lineview.backgroundColor = ColorRGB(0xD4D4D4);
                [headerView addSubview:lineview];
            }
            
            // 添加一个UILabel到headerView
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:/*headerView.bounds*/CGRectMake(0, 0, ScaleW(80), headerView.bounds.size.height)];
            titleLabel.text = [self.fansclassArray objectAtIndex:indexPath.section][@"classtype"];
            titleLabel.font = [UIFont boldSystemFontOfSize:FontSize(14)];
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.textColor = [UIColor blackColor];
            [headerView addSubview:titleLabel];
                        
            NSArray* array = [self.fansclassArray objectAtIndex:indexPath.section][@"classlist"];
            
            NSString *totalstring = [self.fansclassArray objectAtIndex:indexPath.section][@"classtotalcount"];
            
            
            NSString *realstring = [NSString stringWithFormat:@"%d/%d",(int)array.count,(int)totalstring.intValue];
            
            NSNumber *expend = [self.fansclassArray objectAtIndex:indexPath.section][@"classstatus"];
            BOOL is_hide = expend.boolValue;
            UIButton *countLabel = [[UIButton alloc] initWithFrame:/*headerView.bounds*/CGRectMake(headerView.bounds.size.width-ScaleW(100), 0, ScaleW(120), headerView.bounds.size.height)];
            UIButtonConfiguration* btnConfig = [UIButtonConfiguration plainButtonConfiguration];
            countLabel.configurationUpdateHandler = ^(UIButton *b) {
            if (/*b.state == UIControlStateSelected*/!is_hide) {
                btnConfig.attributedTitle = [[NSAttributedString alloc] initWithString:realstring attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:FontSize(14)]}];
                    btnConfig.baseBackgroundColor = UIColor.clearColor;
                            btnConfig.image = [UIImage imageNamed:@"chevron-up"];
                            btnConfig.imagePlacement = NSDirectionalRectEdgeTrailing;
                            btnConfig.imagePadding = 10;
                            ///这个赋值操作必须写，不然不生效
                            b.configuration = btnConfig;
                        }else {
                            btnConfig.attributedTitle = [[NSAttributedString alloc] initWithString:realstring attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:FontSize(14)]}];
                            btnConfig.baseBackgroundColor = UIColor.clearColor;
                            btnConfig.image = [UIImage imageNamed:@"chevron-down"];
                            btnConfig.imagePlacement = NSDirectionalRectEdgeTrailing;
                            btnConfig.imagePadding = 10;
                            ///这个赋值操作必须写，不然不生效
                            b.configuration = btnConfig;
                        }
                    };
            
            
            
            [countLabel addTarget:self action:@selector(showorhideAction:) forControlEvents:UIControlEventTouchUpInside];
//            // 使用 block 作为目标方法
            objc_setAssociatedObject(countLabel, "extraParamKey", [NSNumber numberWithInteger:indexPath.section], OBJC_ASSOCIATION_RETAIN_NONATOMIC);//传递当前的section index
            
            
            [headerView addSubview:countLabel];
            
            return headerView;
        }
    }

    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if(collectionView.tag==602){
        return self.fansclassArray.count;
    }
    else if(collectionView.tag==603)
        return 1;
    else
        return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView.tag==602)
    {
        NSNumber *status = [self.fansclassArray objectAtIndex:section][@"classstatus"];
        BOOL showorhide = status.boolValue;
        NSArray *array = [self.fansclassArray objectAtIndex:section][@"classlist"];
        if(showorhide)
          return array.count;
        else
            return 0;
    }
    else if(collectionView.tag==603)
    {
        return self.fansclassDateArray.count;
    }
        else
        return self.girlArray.count;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if(collectionView.tag==602)
        return CGSizeMake(collectionView.frame.size.width, /*[UIDevice de_safeDistanceBottom]*/ScaleW(60)); // 设置高度为50
    else if(collectionView.tag==603)
        {
            return CGSizeMake(0,0);
        }
    else
            return CGSizeMake(0,0);
}



- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag==602){
        EGirlClassCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EGirlClassCollectionViewCell" forIndexPath:indexPath];
        
        if(self.fansclassArray.count>indexPath.section)
        {
            NSArray *array = [self.fansclassArray objectAtIndex:indexPath.section][@"classlist"];
            NSDictionary *dic = [array objectAtIndex:indexPath.row];
            cell.titleLB.text = [dic objectForKey:@"ws_number"];
            cell.titleLA.text = [dic objectForKey:@"ws_nickname"];
            cell.imageView.image = [UIImage imageNamed:[dic objectForKey:@"ws_image"]];
        }
        return cell;
    }
    else if(collectionView.tag==603)
    {
        EGClassDateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EGClassDateCollectionViewCell" forIndexPath:indexPath];
        if(self.fansclassDateArray.count>indexPath.row)
        {
            NSString *datestring = [self.fansclassDateArray objectAtIndex:indexPath.row][@"datestring"];
            
            if([[[self.fansclassDateArray objectAtIndex:indexPath.row] objectForKey:@"datestatus"] boolValue]==1){
                cell.titleLB.textColor = UIColor.whiteColor;
                cell.titleLB.backgroundColor = ColorRGB(0xD9AE35);
            }
            else{
                cell.titleLB.backgroundColor = UIColor.whiteColor;
                cell.titleLB.textColor = UIColor.blackColor;
            }
            
            [cell setInfo:datestring iscurrentdate:[[[self.fansclassDateArray objectAtIndex:indexPath.row] objectForKey:@"current_datestatus"] boolValue]];
        }
        return cell;
    }
    else
    {
        EGirlCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EGirlCollectionViewCell" forIndexPath:indexPath];
        
        if(self.girlArray.count>indexPath.item)
        {
            self.girldic = [self.girlArray objectAtIndex:indexPath.item];
            cell.titleLB.text = [self.girldic objectForKey:@"girlName"];
            if(self.fansType==0)
                cell.titleLA.text = [self.girldic objectForKey:@"girlNO"];
            else
                cell.titleLA.hidden = YES;
            
            cell.imageView.image = [UIImage imageNamed:[self.girldic objectForKey:@"girImage"]];
        }
        
        return cell;
    }
    
}
//选中 collectionView
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag==602){
        
        NSArray *array = [self.fansclassArray objectAtIndex:indexPath.section][@"classlist"];
        NSDictionary *dic = [array objectAtIndex:indexPath.row];
        
        if(indexPath.section==self.fansclassArray.count-1)
        {
            //弹出应援团的界面
            //if(![[dic objectForKey:@"ws_name"] isEqualToString:@"TAKAME"])
            {
                EGYingyuantuanDetailViewController *vc = [EGYingyuantuanDetailViewController new];
                vc.girlDetailinfo = [self getyingyuantuanInfobyNo:[dic objectForKey:@"ws_name"]];
                vc.currentDate = self.currentDate;
                vc.from = 1;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        else{
            EGFanDetailViewController *vc = [EGFanDetailViewController new];
            vc.girlDetailinfo = [self getgirlInfobyNo:[[dic objectForKey:@"ws_number"] intValue]];
            vc.currentDate = self.currentDate;
            vc.from = 1;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
    else if(collectionView.tag==603)
    {
        [self.fansclassDateArray removeAllObjects];
        for(int i=0;i<self.tempdateArray.count;i++)
        {
            NSMutableDictionary *dic  = [NSMutableDictionary new];
            [dic setObject:[self.tempdateArray objectAtIndex:i][@"ws_day"] forKey:@"datestring"];
            [dic setObject:[NSNumber numberWithBool:NO] forKey:@"datestatus"];
            
            //获取当天的日期
            NSDate *current = [NSDate date];
            NSDateFormatter *formatter22 = [[NSDateFormatter alloc] init];
            [formatter22 setDateFormat:@"yyyy/MM/dd"]; // 设置格式为年-月
            NSString *dateString = [formatter22 stringFromDate:current];
            if([dateString isEqualToString:[self.tempdateArray objectAtIndex:i][@"ws_day"]])
                {
                    [dic setObject:[NSNumber numberWithBool:YES] forKey:@"current_datestatus"];//设置当天的stutus
                }
            else
                [dic setObject:[NSNumber numberWithBool:NO] forKey:@"current_datestatus"];
            
            [self.fansclassDateArray addObject:dic];
        }
        
        if(indexPath.item<self.tempdateArray.count)
        {
            NSMutableDictionary *info = [NSMutableDictionary new];
            [info setObject:[self.tempdateArray objectAtIndex:indexPath.item][@"ws_day"] forKey:@"datestring"];
            [info setObject:[NSNumber numberWithBool:YES] forKey:@"datestatus"];
            [self.fansclassDateArray replaceObjectAtIndex:indexPath.item withObject:info];
            [self.fansClassDateCollectiongView reloadData];
        }
        
        NSString *date = [self.fansclassDateArray objectAtIndex:indexPath.item][@"datestring"];
        [self getgirlMothDayArray:self.tempdateArray currentDate:date];
        [self convertwingstartArray:self.tempgirlclassArray];
        [self.fansClassCollectiongView reloadData];
    }
    else
    {
        if(self.fansType==0){
            EGFanDetailViewController *vc = [EGFanDetailViewController new];
            vc.girlDetailinfo = [self.girlArray objectAtIndex:indexPath.item];
            vc.from = 0;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            //if(indexPath.item!=5) 放开TAKAMEI进入详细信息
            {
                EGYingyuantuanDetailViewController *vc = [EGYingyuantuanDetailViewController new];
                vc.girlDetailinfo = [self.girlArray objectAtIndex:indexPath.item];
                vc.from = 0;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}
// 设置cell大小 itemSize：可以给每一个cell指定不同的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat width =ScaleW(159);
    CGFloat height =ScaleW(198)+ScaleW(24)+ScaleW(12)+ScaleW(20);
    
    if(collectionView.tag==602){
         width =ScaleW(75);
         height =ScaleW(129);
    }
    else if(collectionView.tag==603)
    {
        width =ScaleW(35);
        height =ScaleW(130);
    }
    else
    {
         width =ScaleW(159);
         height =ScaleW(198)+ScaleW(24)+ScaleW(12)+ScaleW(20);
    }
    
    return CGSizeMake(width, /*ScaleW(282)*/height);
    
}
// 设置UIcollectionView整体的内边距（这样item不贴边显示）
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // 上 左 下 右
    if(collectionView.tag==602)
        return UIEdgeInsetsMake(10,0,10,0);
    else if(collectionView.tag==603)
    {
        return UIEdgeInsetsMake(0,10,0,0);
    }
    else
        return UIEdgeInsetsMake(0,0,0,0);
}
// 设置minimumLineSpacing：cell上下之间最小的距离(一行左右间距)
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if(collectionView.tag==602)
        return ScaleW(25);
    else if(collectionView.tag==603)
    {
        return ScaleW(25);
    }
    else
        return 0;
}
// 设置minimumInteritemSpacing：cell左右之间最小的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark scroller delegate
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
    CGFloat buttonWidth = ScaleW(80);
    self.bustatuslable.transform = CGAffineTransformMakeTranslation(progress * buttonWidth, 0);
}

@end
