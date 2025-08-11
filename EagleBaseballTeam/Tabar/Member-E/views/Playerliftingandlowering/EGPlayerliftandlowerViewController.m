//
//  ViewController.m
//  music
//
//  Created by Dragon_Zheng on 2/5/25.
//

#import "EGPlayerliftandlowerViewController.h"
#import "EGPlayerliftandlowerCell.h"
@interface EGPlayerliftandlowerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *baseview;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *fansmusicView;
@property (nonatomic, strong) UIView *wingstarsView;
@property (nonatomic, strong) UIView *fansquanView;

@property (nonatomic, weak) UITableView* MtableView;

//球队战绩页面控件
@property (nonatomic, strong) UIView *baseteamperformentView;
@property (nonatomic, strong) UIView *topteamperformentView;
@property (nonatomic, strong)UILabel* winLabel;
@property (nonatomic, strong)UILabel* failLabel;
@property (nonatomic, strong)UILabel* sameLabel;
@property (nonatomic, strong)UILabel* winiconLabel;
@property (nonatomic, strong)UILabel* dateLabel;
@property (nonatomic, strong)UIButton* predatebt;
@property (nonatomic, strong)UIButton* nextdatebt;

@property (nonatomic, strong)UILabel* errorLabel;

//打折排行页面控件
@property (nonatomic, strong) UIView *baseplayerView;

@property (nonatomic, assign) NSInteger current_year;
@property (nonatomic, assign) NSInteger current_month;

//投手页面控件
@property (nonatomic, strong) UIView *basesendplayerView;

@end

@implementation EGPlayerliftandlowerViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"球員升降";
    
    UISwipeGestureRecognizer *swipeleftoRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeleftoRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleftoRecognizer];

    UISwipeGestureRecognizer *swiperighttoRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swiperighttoRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperighttoRecognizer];
    
    
    
    [self setupTopView];
    [self setupTeamperformanceUI];
    
    [self initteamPerformentInfo];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.backgroundColor = rgba(0, 71, 56, 1);
}

#pragma mark 初始化数据
-(void)initteamPerformentInfo
{
    //获取当前年份
    NSDate *now = [NSDate date];
    // 创建一个日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 从当前日期中提取年份
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:now];
    NSInteger year = [components year];
    NSString *currentyearstring = @"2024";//[NSString stringWithFormat:@"%ld",year];
    
    NSString *authString = [NSString stringWithFormat:@"%@:%@", [[EGCredentialManager sharedManager] getUsername], [[EGCredentialManager sharedManager] getPassword]];
    // Base64 编码
    NSData *authData = [authString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64AuthString = [authData base64EncodedStringWithOptions:0];
    // 添加 Basic Auth 请求头
    NSString *authHeader = [NSString stringWithFormat:@"Basic %@", base64AuthString];
 
    NSDictionary *dict_header = @{@"Authorization":authHeader};
    [MBProgressHUD showMessage:@""];
    NSString *url = [EGServerAPI getMemberchange:currentyearstring];
    [[WAFNWHTTPSTool sharedManager] getWithURL:url parameters:@{} headers:@{} success:^(id  _Nonnull response) {
        self.teamProformentsMainArray  = response[@"ResponseDto"];
        self.teamProformentsArray = response[@"ResponseDto"];
        
        [self getCurrentMothArray];
        
        [MBProgressHUD hideHUD];
        
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
    }];
        
}

#pragma  mark 初始化table View
//球队战绩 table View
- (UITableView *)settableView
{
   if (self.MtableView == nil) {
       if (@available(iOS 13.0, *)) {
           UITableView *tableView2 = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
           tableView2.delegate = self;
           tableView2.dataSource = self;
           tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
           tableView2.showsVerticalScrollIndicator = NO;
           tableView2.estimatedRowHeight = 100;
           self.MtableView = tableView2;
           self.MtableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
              
               [self initteamPerformentInfo];
               
               [self.MtableView.mj_header endRefreshing];
           }];
           [self.fansmusicView addSubview:self.MtableView];
       } else {
           // Fallback on earlier versions
       }
}
return self.MtableView;
}



#pragma mark 初始化界面
-(void)setupTopView
{
    UIView *bsView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, Device_Height)];
    bsView.backgroundColor = rgba(241, 241, 241, 1);
    [self.view addSubview:bsView];
    self.baseview = bsView;
    
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, ScaleW(55))];
    bView.backgroundColor = rgba(241, 241, 241, 1);;
    [self.baseview addSubview:bView];
    self.topView = bView;
    
    
    
    UIButton *upBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [upBtn setImage:[UIImage imageNamed:@"chevron-left"] forState:(UIControlStateNormal)];
    [upBtn addTarget:self action:@selector(preA:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.topView addSubview:upBtn];
    [upBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(ScaleW(108));
        make.width.height.mas_equalTo(ScaleW(30));
    }];
    self.predatebt = upBtn;
    
    
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.text = @"日期";
    self.dateLabel.textColor = UIColor.blackColor;
    self.dateLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    self.dateLabel.textAlignment = NSTextAlignmentLeft;
    [self.topView addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       // make.left.mas_equalTo(self.predatebt.mas_right).offset(ScaleW(5));
        make.left.mas_equalTo(self.topView.mas_centerX).offset(ScaleW(-30));
        make.centerY.mas_equalTo(self.predatebt);
        make.width.mas_equalTo(ScaleW(100));
        make.height.mas_equalTo(ScaleW(30));
    }];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    self.currentDate = [NSDate date];
    self.current_year = [calendar component:NSCalendarUnitYear fromDate:self.currentDate];
    self.current_month = [calendar component:NSCalendarUnitMonth fromDate:self.currentDate];
    NSLog(@"year = %ld, month = %ld",self.current_year,self.current_month);
    [self.dateLabel setText:[self dateFromYEARandMonth:self.current_year M:self.current_month]];
    
    
    
    UIButton *nextBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [nextBtn setImage:[UIImage imageNamed:@"chevron-right-2"] forState:(UIControlStateNormal)];
    [nextBtn addTarget:self action:@selector(nextA:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.topView addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-ScaleW(108));
        make.width.height.mas_equalTo(ScaleW(30));
    }];
    self.nextdatebt = nextBtn;
    
    
    
}

-(void)setupTeamperformanceUI
{
    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, Device_Height-ScaleW(45))];
    firstView.backgroundColor = rgba(241, 241, 241, 1);
    [self.view addSubview:firstView];
    [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(Device_Width);
        make.height.mas_equalTo(Device_Height-[UIDevice de_navigationFullHeight]-ScaleW(45));
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.topView.mas_bottom).offset(20);
    }];
    self.fansmusicView = firstView;
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, ScaleW(45))];
    view.backgroundColor = rgba(241, 241, 241, 1);
    [self.fansmusicView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(Device_Width);
        make.height.mas_equalTo(ScaleW(45));
        make.top.mas_equalTo(self.topView.mas_bottom).offset(20);
    }];
    self.topteamperformentView = view;
    
    //add 球队 胜  负  和  胜率   胜差
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, ScaleW(45))];
    view.backgroundColor=UIColor.blackColor;
    [self.fansmusicView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.fansmusicView);
        make.width.mas_equalTo(Device_Width - ScaleW(40));
        make.height.mas_equalTo(ScaleW(45));
        make.top.mas_equalTo(self.topView.mas_bottom).offset(20);
    }];
    self.baseteamperformentView = view;
    self.baseteamperformentView.hidden = NO;
    
    
    self.winiconLabel = [[UILabel alloc] init];
    self.winiconLabel.text = @"日期";
    self.winiconLabel.textColor = UIColor.whiteColor;
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
    self.winLabel.text = @"球員";
    self.winLabel.textColor = UIColor.whiteColor;
    self.winLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    self.winLabel.textAlignment = NSTextAlignmentCenter;
    [self.baseteamperformentView addSubview:self.winLabel];
    [self.winLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.winiconLabel.mas_right).offset(100);
        make.centerY.mas_equalTo(self.winiconLabel);
        make.width.mas_equalTo(ScaleW(30));
        make.height.mas_equalTo(ScaleW(30));
    }];
    
    
    self.failLabel = [[UILabel alloc] init];
    self.failLabel.text = @"異動原因";
    self.failLabel.textColor = UIColor.whiteColor;
    self.failLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    self.failLabel.textAlignment = NSTextAlignmentCenter;
    [self.baseteamperformentView addSubview:self.failLabel];
    [self.failLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.winLabel.mas_right).offset(ScaleW(80));
        make.centerY.mas_equalTo(self.winLabel);
        make.width.mas_equalTo(ScaleW(60));
        make.height.mas_equalTo(ScaleW(30));
    }];
    
    self.errorLabel = [[UILabel alloc] init];
    self.errorLabel.text = @"目前沒有資料";
    self.errorLabel.textColor = UIColor.blackColor;
    self.errorLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    self.errorLabel.textAlignment = NSTextAlignmentCenter;
    [self.fansmusicView addSubview:self.errorLabel];
    [self.errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.baseteamperformentView.mas_centerX);
        make.top.mas_equalTo(self.baseteamperformentView.mas_bottom).offset(ScaleW(15));
        make.width.mas_equalTo(ScaleW(120));
        make.height.mas_equalTo(ScaleW(30));
    }];
    
    
    [self.settableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.baseteamperformentView.mas_bottom).offset(ScaleW(5));
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        
    }];
    [self.MtableView reloadData];
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
    cellcount = self.teamProformentsArray.count;
    
    return cellcount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75 +5 ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = [self.teamProformentsArray objectAtIndex:indexPath.row];
    EGPlayerliftandlowerCell *cell= [EGPlayerliftandlowerCell cellWithUITableView:tableView];
    cell.backgroundColor = rgba(245, 245, 245, 1);
    [cell setupWithInfo:dic];
    return cell;
}


#pragma mark button click
-(IBAction)preA:(id)sender
{
    [self beforeDate];
}

-(void)beforeDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth /*| NSCalendarUnitDay*/ fromDate:self.currentDate];
    
    //NSDate *end_date = self.currentDate;//往前一个月，先记录的时间是end date
    // 获取当前月份
    NSInteger currentMonth = [components month];
    // 减去一个月
    components.month = currentMonth - 1;
    self.currentDate = [calendar dateFromComponents:components];
    
    self.current_year = [calendar component:NSCalendarUnitYear fromDate:self.currentDate];
    self.current_month = [calendar component:NSCalendarUnitMonth fromDate:self.currentDate];
    NSLog(@"year = %ld, month = %ld",self.current_year,self.current_month);
    
    [self.dateLabel setText:[self dateFromYEARandMonth:self.current_year M:self.current_month]];
    
    NSDate *end_date = [self getlastday:self.current_year M:self.current_month];
    NSDate *startDate = [self getfirstday:self.current_year M:self.current_month];
    
    //从Array中按照年月过滤数据，如果你想要基于日期的某些特定部分（例如只比较年份和月份），你可以使用NSDateComponents来创建一个比较器：
    NSPredicate *predicate1 = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSString *dateV = (NSString *)evaluatedObject[@"ChgDate"];
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        [inputFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        NSDate *date = [inputFormatter dateFromString:dateV];
        
        return ([date compare:startDate] != NSOrderedAscending) && ([date compare:end_date] != NSOrderedDescending);
    }];
    
    self.teamProformentsArray = [self.teamProformentsMainArray filteredArrayUsingPredicate:predicate1];
    if(self.teamProformentsArray.count>0){
        self.MtableView.hidden = NO;
        [self.MtableView reloadData];
        self.errorLabel.hidden = YES;
    }
    else
    {
        self.MtableView.hidden = YES;
        self.errorLabel.hidden = NO;
    }
}


-(IBAction)nextA:(id)sender
{
    [self nextDate];
}

-(void)nextDate
{
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
    NSLog(@"year = %ld, month = %ld",self.current_year,self.current_month);
    [self.dateLabel setText:[self dateFromYEARandMonth:self.current_year M:self.current_month]];
    
    NSDate *end_date = [self getlastday:self.current_year M:self.current_month];
    NSDate *startDate = [self getfirstday:self.current_year M:self.current_month];
    
    
    
    NSPredicate *predicate1 = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSString *dateV = (NSString *)evaluatedObject[@"ChgDate"];
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        [inputFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        NSDate *date = [inputFormatter dateFromString:dateV];
        
        return ([date compare:startDate] != NSOrderedAscending) && ([date compare:end_date] != NSOrderedDescending);
    }];
    
    self.teamProformentsArray = [self.teamProformentsMainArray filteredArrayUsingPredicate:predicate1];
    if(self.teamProformentsArray.count>0){
        self.MtableView.hidden = NO;
        [self.MtableView reloadData];
        self.errorLabel.hidden = YES;
    }
    else
    {
        self.MtableView.hidden = YES;
        self.errorLabel.hidden = NO;
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

-(void)getCurrentMothArray
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.currentDate];

    // 设置日期组件为当前月份的第一天
    components.day = 1;
    NSDate *firstDayOfMonth = [calendar dateFromComponents:components];
     
    NSLog(@"Current Month's First Day: %@", firstDayOfMonth);
    
    components.month += 1;
    components.day = 1;
    NSDate *nextMonthFirstDay = [calendar dateFromComponents:components];
     
    // 减去一天得到当前月份的最后一天
    NSDate *lastDayOfMonth = [calendar dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:nextMonthFirstDay options:0];
     
    NSLog(@"Current Month's Last Day: %@", lastDayOfMonth);
    
    NSPredicate *predicate1 = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSString *dateV = (NSString *)evaluatedObject[@"ChgDate"];
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        [inputFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        NSDate *date = [inputFormatter dateFromString:dateV];
        
        return ([date compare:firstDayOfMonth] != NSOrderedAscending) && ([date compare:lastDayOfMonth] != NSOrderedDescending);
    }];
    
    self.teamProformentsArray = [self.teamProformentsMainArray filteredArrayUsingPredicate:predicate1];
    if(self.teamProformentsArray.count>0){
        self.MtableView.hidden = NO;
        [self.MtableView reloadData];
        self.errorLabel.hidden = YES;
    }
    else
    {
        self.MtableView.hidden = YES;
        self.errorLabel.hidden = NO;
    }
    

}


- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"Swiped left");
        [self beforeDate];
    } else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"Swiped right");
        [self nextDate];
    }
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


@end
