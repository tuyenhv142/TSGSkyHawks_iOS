//
//  EGSchedulesViewController.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/6.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGSchedulesViewController.h"

#import "FSCalendar.h"
#import "CustomCalendarCell.h"
#import "EGScheduleInfoView.h"
#import <SafariServices/SFSafariViewController.h>
#import "EGScheduleModel.h"
#import "ScheduleViewModel.h"
#import "EGEagleFansWorldViewController.h"//鷹迷天地

@interface EGSchedulesViewController ()<FSCalendarDataSource,FSCalendarDelegate,EGScheduleInfoViewDelegate,SFSafariViewControllerDelegate>

@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) FSCalendar *calendarView;
@property (nonatomic,strong) NSCalendar *gregorian;
@property (nonatomic,strong) EGScheduleInfoView *botommView;
@property (nonatomic,strong) NSArray *responseDto;
@property (nonatomic,  copy) NSString *yearString;
@property (nonatomic,strong) UILabel *alterLb;

@property (nonatomic,strong) ScheduleViewModel *viewModel;
@property (nonatomic,strong) UILabel *dateLB;

@property (nonatomic,strong) UIScrollView *scrollview;
@end

@implementation EGSchedulesViewController

- (UIScrollView *)scrollview
{
    if (!_scrollview) {
        _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, Device_Height - ([UIDevice de_navigationFullHeight] + [UIDevice de_tabBarFullHeight]))];
        _scrollview.showsVerticalScrollIndicator = false;
        _scrollview.backgroundColor = UIColor.whiteColor;
        [self.view addSubview:_scrollview];
    }
    return _scrollview;
}
- (UILabel *)alterLb
{
    if (!_alterLb) {
        _alterLb = [UILabel new];
        _alterLb.text = @"今日無賽事";
        _alterLb.textAlignment = NSTextAlignmentCenter;
        _alterLb.textColor = rgba(38, 38, 38, 1);
        _alterLb.font = [UIFont systemFontOfSize:FontSize(16) weight:(UIFontWeightBold)];
    }
    return _alterLb;
}
- (EGScheduleInfoView *)botommView
{
    if (!_botommView) {
        CGFloat height = ScaleH(219);//ScaleH(188)
        _botommView = [[EGScheduleInfoView alloc] initWithFrame:CGRectMake(0, Device_Height - (height + [UIDevice de_tabBarFullHeight]), Device_Width, height)];
        _botommView.delegate = self;
    }
    return _botommView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([EGLoginUserManager isLogIn]) {
        self.leftBtn.enabled = false;
    }else{
        self.leftBtn.enabled = true;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setSelfView];
    
    [self createCalendar];
    
    [self createButton];
    
    _viewModel = [[ScheduleViewModel alloc] init];
    
    
    [self getCurrentYearData];
    
}

- (void)openLocationInMapsUsingURLScheme:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude {
    NSString *urlString = [NSString stringWithFormat:@"http://maps.apple.com/?ll=%f,%f", latitude, longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

-(void)getCurrentYearData
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *year = [formatter stringFromDate:[NSDate date]];
    self.yearString = year;
    [self getScheduleData:year];
}

-(void)getScheduleData:(NSString *)year
{
    WS(weakSelf);
    [_viewModel getScheduleCalendarDataTest:year Completion:^(NSError * _Nonnull error, NSArray * _Nonnull array) {
        if (!error) {
            weakSelf.calendarView.today = [NSDate date];
            weakSelf.responseDto = array;
            [weakSelf.calendarView reloadData];
            ELog(@"%@", weakSelf.responseDto)
        }else{
            ELog(@"%@", error)
        }
    }];
}

-(void)setSelfView
{
    self.view.backgroundColor = rgba(243, 243, 243, 1);
    self.navigationItem.title = @"";
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [leftBtn setTitle:NSLocalizedString(@"賽程", nil) forState:UIControlStateDisabled];
    [leftBtn setTitle:NSLocalizedString(@"登入", nil) forState:UIControlStateNormal];
    [leftBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [leftBtn setTitleColor:UIColor.whiteColor forState:UIControlStateDisabled];
    [leftBtn addTarget:self action:@selector(leftNavigationButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.leftBtn = leftBtn;
}

-(void)leftNavigationButton:(UIButton *)sender
{
    if (![EGLoginUserManager isLogIn]) {
        EGNavigationController *nav = [[EGNavigationController alloc] initWithRootViewController:[EGLogInViewController new]];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        nav.navigationBar.backgroundColor = rgba(16, 38, 73, 1);
        [self presentViewController:nav animated:true completion:^{
        }];
    }
}

-(void)createButton
{
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(ScaleW(10), ScaleW(20)/*[UIDevice de_navigationFullHeight]*/, Device_Width - ScaleW(20), ScaleH(37))];
    baseView.layer.masksToBounds = true;
    baseView.layer.cornerRadius = ScaleW(20);
    baseView.backgroundColor = rgba(243, 243, 243, 1);
    [self.scrollview addSubview:baseView];
    
    UIButton *nextBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    nextBtn.backgroundColor = UIColor.whiteColor;
    nextBtn.layer.masksToBounds = true;
    nextBtn.layer.cornerRadius = ScaleW(13);
    [nextBtn setImage:[UIImage imageNamed:@"chevron-right-2"] forState:(UIControlStateNormal)];
    [nextBtn addTarget:self action:@selector(nextClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [baseView addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-ScaleW(20));
        make.width.height.mas_equalTo(ScaleW(26));
    }];
    nextBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-20, -20, -20, -40);
    
    UIButton *upBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    upBtn.backgroundColor = UIColor.whiteColor;
    upBtn.layer.masksToBounds = true;
    upBtn.layer.cornerRadius = ScaleW(13);
    [upBtn setImage:[UIImage imageNamed:@"chevron-left"] forState:(UIControlStateNormal)];
    [upBtn addTarget:self action:@selector(previousClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [baseView addSubview:upBtn];
    [upBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(ScaleW(20));
        make.width.height.mas_equalTo(ScaleW(26));
    }];
    upBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-20, -40, -20, -20);
    
    UILabel *dateLB = [UILabel new];
//    dateLB.text = @"2025/03";
    dateLB.textAlignment = NSTextAlignmentCenter;
    dateLB.textColor = rgba(38, 38, 38, 1);
    dateLB.font = [UIFont systemFontOfSize:FontSize(16) weight:(UIFontWeightBold)];
    [baseView addSubview:dateLB];
    [dateLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
    }];
    self.dateLB = dateLB;
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM"];
    NSString *dateStr = [formatter1 stringFromDate:[NSDate date]];
    self.dateLB.text = [dateStr stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    
    UIButton *todayBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    todayBtn.backgroundColor = UIColor.whiteColor;
    todayBtn.frame = CGRectMake(0, 0, ScaleW(50), ScaleW(24));
    [todayBtn setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateNormal];
    [todayBtn setTitle:@"今日" forState:UIControlStateNormal];
    todayBtn.titleLabel.font = [UIFont boldSystemFontOfSize:FontSize(14)];
    todayBtn.layer.cornerRadius = ScaleW(15);
    todayBtn.layer.masksToBounds = true;
    [todayBtn addTarget:self action:@selector(goBackToday) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:todayBtn];
}
-(void)createCalendar
{
    WS(weakSelf);
    self.scrollview.contentSize = CGSizeMake(Device_Width, Device_Height);
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, Device_Height)];
    baseView.backgroundColor = UIColor.whiteColor;
    [self.scrollview addSubview:baseView];
    
    EGCircleRefreshHeader *header = [EGCircleRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf getCurrentYearData];
        [weakSelf.scrollview.mj_header endRefreshing];
    }];
    self.scrollview.mj_header = header;
    
    FSCalendar *calendarView = [[FSCalendar alloc] init];
//    calendarView.layer.masksToBounds = true;
//    calendarView.layer.cornerRadius = ScaleW(10);
//    calendarView.layer.borderColor = UIColor.lightGrayColor.CGColor;
//    calendarView.layer.borderWidth = 1;
    calendarView.translatesAutoresizingMaskIntoConstraints = NO;
    calendarView.backgroundColor = UIColor.whiteColor;
    calendarView.dataSource = self;
    calendarView.delegate = self;
    [baseView addSubview:calendarView];
//    [calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(ScaleW(77));
//        make.left.mas_equalTo(20);
//        make.right.mas_equalTo(-20);
//        make.height.mas_equalTo(Device_Width+ScaleW(150));
//    }];
    [NSLayoutConstraint activateConstraints:@[
        [calendarView.topAnchor constraintEqualToAnchor:baseView.topAnchor constant:ScaleW(77)],
        [calendarView.leadingAnchor constraintEqualToAnchor:baseView.leadingAnchor constant:20],
        [calendarView.trailingAnchor constraintEqualToAnchor:baseView.trailingAnchor constant:-20],
        [calendarView.heightAnchor constraintEqualToConstant:Device_Width+ScaleW(150)]
    ]];
    
    calendarView.scope = FSCalendarScopeMonth;
    calendarView.scrollEnabled = true;
    calendarView.scrollDirection = FSCalendarScrollDirectionHorizontal;
    calendarView.pagingEnabled = YES;
    calendarView.adjustsBoundingRectWhenChangingMonths = YES;
    
    calendarView.calendarHeaderView.hidden = NO;
    calendarView.calendarHeaderView.backgroundColor = rgba(243, 243, 243, 1);
    calendarView.headerHeight = ScaleH(0);
    
    calendarView.appearance.headerDateFormat = @"yyyy/MM";
    calendarView.appearance.headerTitleFont = [UIFont boldSystemFontOfSize:FontSize(16)];//顶部 年月字体大小
    calendarView.appearance.headerTitleColor = UIColor.clearColor;//rgba(38, 38, 38, 1);
    calendarView.appearance.headerMinimumDissolvedAlpha = 0; //head左右两个label上月下月的透明度
    
    calendarView.weekdayHeight = ScaleH(30);
    calendarView.locale = [NSLocale localeWithLocaleIdentifier:@"zh-Hant"];//星期 EN ZH
    calendarView.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;//日 一 二 三   ：周日 周 一 周二 周三
    calendarView.appearance.weekdayTextColor = rgba(38, 38, 38, 1);
    calendarView.calendarWeekdayView.backgroundColor = UIColor.whiteColor;
    
    
    for (UILabel *weekdayLabel in calendarView.calendarWeekdayView.weekdayLabels) {
        weekdayLabel.layer.borderWidth = 1.0;
        weekdayLabel.layer.borderColor =rgba(222, 222, 222, 1).CGColor;;
    }
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0, 0, Device_Width, 1.5);
    topBorder.backgroundColor = rgba(23, 23, 23, 1).CGColor;
//    topBorder.zPosition = 999;
    [calendarView.calendarWeekdayView.layer addSublayer:topBorder];

    calendarView.appearance.separators = FSCalendarSeparatorNone;//每一行分割线
    calendarView.placeholderType = FSCalendarPlaceholderTypeFillHeadTail;// FSCalendarPlaceholderTypeNone;//下一月除几天 和 上一月末几天 显示模式
    
    calendarView.appearance.todayColor = rgba(16, 38, 73, 1);//今天背景色
    calendarView.appearance.titleFont = [UIFont boldSystemFontOfSize:FontSize(12)];
    calendarView.appearance.titleTodayColor = UIColor.whiteColor;//今天文字颜色
    calendarView.appearance.subtitleTodayColor = rgba(115, 115, 115, 1);//今天子标题颜色
    calendarView.appearance.subtitleFont = [UIFont boldSystemFontOfSize:FontSize(12)];
    
    calendarView.appearance.selectionColor = rgba(28, 172, 173, 0.8);//选中哪天日期背景色
//    calendarView.appearance.selectionColor = rgba(27, 174, 110, 1);//选中哪天日期背景色
    calendarView.appearance.titleSelectionColor = UIColor.whiteColor;//选中哪天日期颜色
    calendarView.appearance.subtitleSelectionColor = rgba(115, 115, 115, 1);
    
//    calendarView.appearance.borderDefaultColor = UIColor.redColor;
//    calendarView.appearance.borderSelectionColor = UIColor.redColor;
    
    [calendarView registerClass:[CustomCalendarCell class] forCellReuseIdentifier:@"CustomCalendarCell"];
    
    calendarView.today = [NSDate date];
//    calendarView.appearance.subtitleDefaultColor = rgba(115, 115, 115, 1);
    
    self.calendarView = calendarView;
    
    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [self.view addSubview:self.alterLb];
    [self.alterLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(20));
        make.right.mas_equalTo(-ScaleW(20));
        make.bottom.mas_equalTo(-([UIDevice de_tabBarFullHeight]+ScaleH(30)));
    }];
    self.alterLb.hidden = true;
}

-(void)goBackToday
{
    self.alterLb.hidden = true;
    [self.botommView removeFromSuperview];
    
//    NSCalendarUnit scopeUnit = NSCalendarUnitMonth;
//    if (self.calendarView.scope == FSCalendarScopeWeek) {
//        scopeUnit = NSCalendarUnitWeekOfMonth;
//    }else{
//        scopeUnit = NSCalendarUnitMonth;
//    }
    
    //    日历数据更新
    NSDate *currentMonth = [NSDate date];
    [self.calendarView setCurrentPage:currentMonth animated:YES];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *year = [formatter stringFromDate:currentMonth];
    if ([self.yearString isEqualToString:year]) {
        [self.calendarView reloadData];
    }else{
        self.yearString = year;
        [self getScheduleData:year];
    }
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM"];
    NSString *dateStr = [formatter1 stringFromDate:currentMonth];
    self.dateLB.text = [dateStr stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
}

//上一月
- (void)previousClicked:(UIButton *)sender
{
    self.alterLb.hidden = true;
    [self.botommView removeFromSuperview];
    
    NSCalendarUnit scopeUnit = NSCalendarUnitMonth;
//    if (self.calendarView.scope == FSCalendarScopeWeek) {
//        scopeUnit = NSCalendarUnitWeekOfMonth;
//    }else{
//        scopeUnit = NSCalendarUnitMonth;
//    }
    
    //    日历数据更新
    NSDate *currentMonth = self.calendarView.currentPage;
    NSDate *previousMonth = [self.gregorian dateByAddingUnit:scopeUnit value:-1 toDate:currentMonth options:0];
    [self.calendarView setCurrentPage:previousMonth animated:YES];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *year = [formatter stringFromDate:previousMonth];
    if ([self.yearString isEqualToString:year]) {
        [self.calendarView reloadData];
    }else{
        self.yearString = year;
        [self getScheduleData:year];
    }
    
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM"];
    NSString *dateStr = [formatter1 stringFromDate:previousMonth];
    self.dateLB.text = [dateStr stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
}

//下一月
- (void)nextClicked:(UIButton *)sender
{
    self.alterLb.hidden = true;
    [self.botommView removeFromSuperview];
    
    NSCalendarUnit scopeUnit;
    if (self.calendarView.scope == FSCalendarScopeWeek) {
        scopeUnit = NSCalendarUnitWeekOfMonth;
    }else{
        scopeUnit = NSCalendarUnitMonth;
    }
    //    日历数据更新
    NSDate *currentMonth = self.calendarView.currentPage;
    NSDate *nextMonth = [self.gregorian dateByAddingUnit:scopeUnit value:1 toDate:currentMonth options:0];
    [self.calendarView setCurrentPage:nextMonth animated:YES];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *year = [formatter stringFromDate:nextMonth];
    if ([self.yearString isEqualToString:year]) {
        [self.calendarView reloadData];
    }else{
        self.yearString = year;
        [self getScheduleData:year];
    }
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM"];
    NSString *dateStr = [formatter1 stringFromDate:nextMonth];
    self.dateLB.text = [dateStr stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - FSCalendarDelegate
//- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated {
//    _calendarHeightConstraint.constant = CGRectGetHeight(bounds);
//    [UIView animateWithDuration:0.3 animations:^{
//        [self.view layoutIfNeeded];
//    }];
//}
// 当前页面变化时调用
- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSDate *currentPage = calendar.currentPage;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    
//    self.alterLb.hidden = true;
//    [self.botommView removeFromSuperview];
    
    NSString *year = [formatter stringFromDate:currentPage];
    if (![self.yearString isEqualToString:year]) {
        self.yearString = year;
        [self getScheduleData:year];
    }
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM"];
    NSString *dateStr = [formatter1 stringFromDate:currentPage];
    self.dateLB.text = [dateStr stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    
    BOOL isSameMonth1 = [self isSameMonthWithDate1:currentPage date2:[NSDate date]];
    if (isSameMonth1 == NO) {
        self.alterLb.hidden = true;
        [self.botommView removeFromSuperview];
    }
}
- (void)scrollEnd:(FSCalendar *)calendar
{
    
    NSDate *currentPage = calendar.currentPage;
    BOOL isSameMonth1 = [self isSameMonthWithDate1:currentPage date2:[NSDate date]];
    if (!isSameMonth1) {
        [self.botommView removeFromSuperview];
    }else{
        [self.calendarView reloadData];
    }
}
- (BOOL)isSameMonthWithDate1:(NSDate *)date1 date2:(NSDate *)date2 {
    if (!date1 || !date2) {
        return NO;
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 提取两个日期的年月组件
    NSDateComponents *components1 = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth)
                                              fromDate:date1];
    NSDateComponents *components2 = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth)
                                              fromDate:date2];
    // 比较年份和月份
    return (components1.year == components2.year) && (components1.month == components2.month);
}

- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position
{
    CustomCalendarCell *cell = [calendar dequeueReusableCellWithIdentifier:@"CustomCalendarCell" forDate:date atMonthPosition:position];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    [cell setCanlenderData:@"HomeTeam-NO"];
//    for (EGScheduleModel *model in self.responseDto) {
//        NSDate *dataDate = [formatter dateFromString:[model.GameDate substringToIndex:10]];
//        if ([date isEqualToDate:dataDate]) {
//            if ([model.HomeTeamCode isEqualToString:@"AKP011"]) {
//                [cell setCanlenderData:@"HomeTeam"];
//            }else{
//                [cell setCanlenderData:@"HomeTeam-NO"];
//            }
//        }
//    }
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSArray *arrayOfDictionaries = self.responseDto;
    NSString *targetTimeString = [formatter stringFromDate:date];   // 你要查找的时间字符串 2025-02-12T00:00:00
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"GameDate == %@", targetTimeString];// 假设字典中的时间键是"time"
    NSArray *filteredArray = [arrayOfDictionaries filteredArrayUsingPredicate:predicate];
    if (filteredArray.count > 0) {
        EGScheduleModel *model = filteredArray.firstObject;
        // 使用找到的字典
        if ([model.HomeTeamName isEqualToString:@"台鋼天鷹"]) {
            [cell setCanlenderData:@"HomeTeam"];
        }else{
            [cell setCanlenderData:@"HomeTeam-NO"];
        }
    } else {
        // 没有找到匹配的字典
        [cell setCanlenderData:@"HomeTeam-NO"];
    }
    
    return cell;
}
- (UIImage *)calendar:(FSCalendar *)calendar imageForDate:(NSDate *)date
{
    
    BOOL isSameMonth1 = [self isSameMonthWithDate1:calendar.currentPage date2:[NSDate date]];// 滑动上月未遂
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSArray *arrayOfDictionaries = self.responseDto;
    NSString *targetTimeString = [formatter stringFromDate:date];   // 你要查找的时间字符串 2025-02-12T00:00:00
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"GameDate == %@", targetTimeString];// 假设字典中的时间键是"time"
    NSArray *filteredArray = [arrayOfDictionaries filteredArrayUsingPredicate:predicate];
    if (filteredArray.count > 0) {
        EGScheduleModel *model = filteredArray.firstObject;
        // 使用找到的字典
        BOOL isSameDay = [self isSameDayWithDate1:[NSDate date] date2:[formatter dateFromString:model.GameDate] date3:date];
        if (isSameDay && isSameMonth1) {
            self.alterLb.hidden = true;
            [self.view addSubview:self.botommView];
            [self.botommView setSchedulesInformation:model];
        }
        if ([model.HomeTeamName isEqualToString:@"台鋼天鷹"]) {
            return [UIImage imageNamed:retureHomeTeamIconImgName(model.VisitingTeamName)];
        }else{
            return [UIImage imageNamed:retureHomeTeamIconImgName(model.HomeTeamName)];
        }
    } else {
        // 没有找到匹配的字典
        if ([self isSameDayWithDate1:date date2:[NSDate date] inTimeZone:[NSTimeZone systemTimeZone]]) {
            self.alterLb.hidden = false;
        }
        return nil;
    }
    
//    for (EGScheduleModel *model in self.responseDto) {
//        
//        NSDate *dataDate = [formatter dateFromString:[model.GameDate substringToIndex:10]];
//        if ([date isEqualToDate:dataDate]) {
//            
//            BOOL isSameDay = [self isSameDayWithDate1:[NSDate date] date2:dataDate date3:date];
//            if (isSameDay && isSameMonth1) {
//                self.alterLb.hidden = true;
//                [self.view addSubview:self.botommView];
//                [self.botommView setSchedulesInformation:model];
//            }
//            
//            if ([model.HomeTeamCode isEqualToString:@"AKP011"]) {
//                return [UIImage imageNamed:retureHomeTeamIconImgName(model.VisitingTeamCode)];
//            }else{
//                return [UIImage imageNamed:retureHomeTeamIconImgName(model.HomeTeamCode)];
//            }
//        }
//    }
//    if ([self isSameDayWithDate1:date date2:[NSDate date] inTimeZone:[NSTimeZone systemTimeZone]]) {
//        self.alterLb.hidden = false;
//    }
//    return nil;
}

- (BOOL)isSameDayWithDate1:(NSDate *)date1 date2:(NSDate *)date2 inTimeZone:(NSTimeZone *)timeZone {
    if (!date1 || !date2) return NO;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    if (timeZone) {
        [calendar setTimeZone:timeZone];
    }
    
    NSDateComponents *comp1 = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date1];
    NSDateComponents *comp2 = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date2];
    
    return (comp1.year == comp2.year) && (comp1.month == comp2.month) && (comp1.day == comp2.day);
}
- (BOOL)isSameDayWithDate1:(NSDate *)date1 date2:(NSDate *)date2 date3:(NSDate *)date3 {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components1 = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date1];
    NSDateComponents *components2 = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date2];
    NSDateComponents *components3 = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date3];
    
    return (components1.year == components2.year &&
            components1.month == components2.month &&
            components1.day == components2.day &&
            components1.year == components3.year &&
            components1.month == components3.month &&
            components1.day == components3.day);
}

NSString *retureHomeTeamIconImgName(NSString *homeTeamCode)
{
    if ([homeTeamCode containsString:@"桃園雲豹"]) {
        return @"桃園雲豹";
    }else if ([homeTeamCode containsString:@"臺北伊斯特"]){
        return @"臺北伊斯特";
    }else if ([homeTeamCode containsString:@"臺中連莊"]){
        return @"臺中連莊";
    }else if ([homeTeamCode containsString:@"台鋼天鷹"]){
        return @"台鋼雄鷹3x_L";
    }else{
        return @" ";
    }
}

- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
//    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSArray *arrayOfDictionaries = self.responseDto;
    NSString *targetTimeString = [formatter stringFromDate:date];   // 你要查找的时间字符串 2025-02-12T00:00:00
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"GameDate == %@", targetTimeString];// 假设字典中的时间键是"time"
    NSArray *filteredArray = [arrayOfDictionaries filteredArrayUsingPredicate:predicate];
    if (filteredArray.count > 0) {
        EGScheduleModel *model = filteredArray.firstObject;
        // 使用找到的字典
        if (model.PresentStatus == 0) {
            if ([model.HomeTeamName isEqualToString:@"台鋼天鷹"]) {
                if (model.HomeSetsWon > model.VisitingSetsWon) {
                    return [NSString stringWithFormat:@"W%ld:%ld",model.VisitingSetsWon,model.HomeSetsWon];
                }else{
                    return [NSString stringWithFormat:@"L%ld:%ld",model.VisitingSetsWon,model.HomeSetsWon];
                }
            }else{
                if (model.HomeSetsWon > model.VisitingSetsWon) {
                    return [NSString stringWithFormat:@"L%ld:%ld",model.VisitingSetsWon,model.HomeSetsWon];
                }else{
                    return [NSString stringWithFormat:@"W%ld:%ld",model.VisitingSetsWon,model.HomeSetsWon];
                }
            }
        }else if (model.PresentStatus == 1) {
                return @"延賽";
        }else if (model.PresentStatus == 2) {
            return @"保留";
        }else{
            return @"";
        }
    } else {
        // 没有找到匹配的字典
        return @"";
    }
    
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    for (EGScheduleModel *model in self.responseDto) {
//        
//        NSString *dateTime = model.GameDateTimeS;
//        dateTime = [dateTime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
//        NSDate *dataDate = [formatter dateFromString:[dateTime substringToIndex:10]];
//        
//        if ([date isEqualToDate:dataDate]) {
//            
//            if ([model.GameResult isEqualToString:@"0"]) {
//                if ([model.HomeTeamCode isEqualToString:@"AKP011"]) {
//                    if (model.HomeScore > model.VisitingScore) {
//                        return [NSString stringWithFormat:@"W%ld:%ld",model.VisitingScore,model.HomeScore];
//                    }else{
//                        return [NSString stringWithFormat:@"L%ld:%ld",model.VisitingScore,model.HomeScore];
//                    }
//                }else{
//                    if (model.HomeScore > model.VisitingScore) {
//                        return [NSString stringWithFormat:@"L%ld:%ld",model.VisitingScore,model.HomeScore];
//                    }else{
//                        return [NSString stringWithFormat:@"W%ld:%ld",model.VisitingScore,model.HomeScore];
//                    }
//                }
//            }else if ([model.GameResult isEqualToString:@"1"]) {
//                    return @"延賽";
//            }else if ([model.GameResult isEqualToString:@"2"]) {
//                return @"保留";
//            }else{
//                return @"";
//            }
//        }
//    }
//    return @"";
}
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance subtitleDefaultColorForDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
//    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSArray *arrayOfDictionaries = self.responseDto;
    NSString *targetTimeString = [formatter stringFromDate:date];   // 你要查找的时间字符串 2025-02-12T00:00:00
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"GameDate == %@", targetTimeString];// 假设字典中的时间键是"time"
    NSArray *filteredArray = [arrayOfDictionaries filteredArrayUsingPredicate:predicate];
    if (filteredArray.count > 0) {
        EGScheduleModel *model = filteredArray.firstObject;
        // 使用找到的字典
        if (model.PresentStatus == 0) {
            if ([model.HomeTeamName isEqualToString:@"台鋼天鷹"]) {
                if (model.HomeSetsWon > model.VisitingSetsWon) {
                    return rgba(0, 78, 162, 1);//W
                }else{
                    return rgba(115, 115, 115, 1);//L
                }
            }else{
                if (model.HomeSetsWon > model.VisitingSetsWon) {
                    return rgba(115, 115, 115, 1);//L
                }else{
                    return rgba(0, 78, 162, 1);//W
                }
            }
        }else{
            return rgba(115, 115, 115, 1);//L
        }
    } else {
        // 没有找到匹配的字典
        return rgba(115, 115, 115, 1);//L
    }
    
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    for (EGScheduleModel *model in self.responseDto) {
//        NSString *dateTime = model.GameDateTimeS;
//        dateTime = [dateTime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
//        NSDate *dataDate = [formatter dateFromString:[dateTime substringToIndex:10]];
//        if ([date isEqualToDate:dataDate]) {
//            if ([model.GameResult isEqualToString:@"0"]) {
//                if ([model.HomeTeamCode isEqualToString:@"AKP011"]) {
//                    if (model.HomeScore > model.VisitingScore) {
//                        return rgba(0, 122, 96, 1);//W
//                    }else{
//                        return rgba(115, 115, 115, 1);//L
//                    }
//                }else{
//                    if (model.HomeScore > model.VisitingScore) {
//                        return rgba(115, 115, 115, 1);//L
//                    }else{
//                        return rgba(0, 122, 96, 1);//W
//                    }
//                }
//            }else{
//                return rgba(115, 115, 115, 1);//L
//            }
//        }
//    }
//    return rgba(115, 115, 115, 1);//L
}
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance subtitleSelectionColorForDate:(nonnull NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
//    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSArray *arrayOfDictionaries = self.responseDto;
    NSString *targetTimeString = [formatter stringFromDate:date];   // 你要查找的时间字符串 2025-02-12T00:00:00
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"GameDate == %@", targetTimeString];// 假设字典中的时间键是"time"
    NSArray *filteredArray = [arrayOfDictionaries filteredArrayUsingPredicate:predicate];
    if (filteredArray.count > 0) {
        EGScheduleModel *model = filteredArray.firstObject;
        // 使用找到的字典
        if (model.PresentStatus == 0) {
            if ([model.HomeTeamName isEqualToString:@"台鋼天鷹"]) {
                if (model.HomeSetsWon > model.HomeSetsWon) {
                    return rgba(0, 78, 162, 1);//W
                }else{
                    return rgba(115, 115, 115, 1);//L
                }
            }else{
                if (model.HomeSetsWon > model.HomeSetsWon) {
                    return rgba(115, 115, 115, 1);//L
                }else{
                    return rgba(0, 78, 162, 1);//W
                }
            }
        }else{
            return rgba(115, 115, 115, 1);//L
        }
    } else {
        // 没有找到匹配的字典
        return rgba(115, 115, 115, 1);//L
    }
    
    
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    for (EGScheduleModel *model in self.responseDto) {
//        NSString *dateTime = model.GameDateTimeS;
//        dateTime = [dateTime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
//        NSDate *dataDate = [formatter dateFromString:[dateTime substringToIndex:10]];
//        if ([date isEqualToDate:dataDate]) {
//            if ([model.GameResult isEqualToString:@"0"]) {
//                if ([model.HomeTeamCode isEqualToString:@"AKP011"]) {
//                    if (model.HomeScore > model.VisitingScore) {
//                        return rgba(0, 122, 96, 1);//W
//                    }else{
//                        return rgba(115, 115, 115, 1);//L
//                    }
//                }else{
//                    if (model.HomeScore > model.VisitingScore) {
//                        return rgba(115, 115, 115, 1);//L
//                    }else{
//                        return rgba(0, 122, 96, 1);//W
//                    }
//                }
//            }else{
//                return rgba(115, 115, 115, 1);//L
//            }
//        }
//    }
//    return rgba(115, 115, 115, 1);//L
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    BOOL isHidden = false;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    for (EGScheduleModel *model in self.responseDto) {
        
        NSDate *dataDate = [formatter dateFromString:[model.GameDate substringToIndex:10]];
        if ([date isEqualToDate:dataDate]) {
            isHidden = true;
            [self.view addSubview:self.botommView];
            [self.botommView setSchedulesInformation:model];
        }
    }
    
    if (!isHidden) {
        [self.botommView removeFromSuperview];
        
    }
    self.alterLb.hidden = isHidden;
}

#pragma mark --- EGScheduleInfoViewDelegate

// 添加新方法
- (void)showCalendarDeniedAlert {
    NSString *message = @"請至 設定 > 隱私權與安全性 > 行事曆 開啟權限，以便接收賽事通知";
    [ELAlertController alertControllerWithTitleName:@"無法存取行事曆"
                                        andMessage:message
                                cancelButtonTitle:@"取消"
                               confirmButtonTitle:@"前往設定"
                               showViewController:self
                              addCancelClickBlock:^(UIAlertAction * _Nonnull cancelAction) {
        
    } addConfirmClickBlock:^(UIAlertAction * _Nonnull SureAction) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]
                                         options:@{}
                               completionHandler:nil];
    }];
}


- (void)botomButtonEvent:(NSInteger)tag dataModel:(EGScheduleModel *)model
{

    if (tag == 11) {//加入行事历
        if (model) {
            EKEventStore *eventStore = [[EKEventStore alloc] init];
            EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];

            if (status == EKAuthorizationStatusNotDetermined) {
                [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (granted) {
                            [[EGEventStoreTool shareEvent] addEventToCalender:model];
                        } else {
                            [self showCalendarDeniedAlert];
                        }
                    });
                }];
            } else if (status == EKAuthorizationStatusAuthorized) {
                [[EGEventStoreTool shareEvent] addEventToCalender:model];
            } else {
                [self showCalendarDeniedAlert];
            }
//                        NSString *message = @"是否同意存取您的行事曆，以便輕鬆掌握比賽通知及賽程安排";
//                        [ELAlertController alertControllerWithTitleName:@"賽程訂閱" andMessage:message cancelButtonTitle:@"取消" confirmButtonTitle:@"繼續" showViewController:self addCancelClickBlock:^(UIAlertAction * _Nonnull cancelAction) {
//            
//                            } addConfirmClickBlock:^(UIAlertAction * _Nonnull SureAction) {
//                                [[EGEventStoreTool shareEvent] addEventToCalender:model];
//                            }];
            

        }
        
    }else if (tag == 12) {//购票
        
        EGPublicWebViewController *webVc = [[EGPublicWebViewController alloc] init];
        webVc.navigationItem.title = @"票區";
            webVc.webUrl = @"https://ticket.tsgskyhawks.com/";
        [self.navigationController pushViewController:webVc animated:true];
        
    }else if (tag == 13) {
        
//        NSString *shopUrl = [NSString stringWithFormat:@"https://www.cpbl.com.tw/box?year=%@&kindCode=%@&gameSno=%ld",self.yearString,model.KindCode,model.GameSno];
//        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:shopUrl]];
//        safariVC.delegate = self;
//        [self presentViewController:safariVC animated:YES completion:nil];
        
    }else if (tag == 14) {
        
        EGEagleFansWorldViewController *photoVC = [[EGEagleFansWorldViewController alloc] init];
        
        [self.navigationController pushViewController:photoVC animated:true];
        
    }

    
}
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    //当用户添加事件成功后，关闭safariVC
    [controller dismissViewControllerAnimated:YES completion:nil];
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
@end
