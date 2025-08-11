//
//  EGPointsRecordViewController.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/8.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGPointsRecordViewController.h"
#import "EGPointsModel.h"
#import "EGPointsRuleViewController.h"

@interface PointsRecordTBVCell ()

@property (nonatomic,strong) UIButton *titleBtn;
@property (nonatomic,strong) UILabel *pointsLb;

@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *timeLb;

@end

@implementation PointsRecordTBVCell

- (UIButton *)titleBtn
{
    if (!_titleBtn) {
        _titleBtn = [[UIButton alloc] init];
//        [_titleBtn setTitle:@"雄鷹點數" forState:UIControlStateNormal];
//        _titleBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:(UIFontWeightMedium)];
//        [_titleBtn setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
//        _titleBtn.backgroundColor = rgba(0, 122, 96, 1);
//        _titleBtn.layer.cornerRadius = ScaleW(12);
//        _titleBtn.layer.masksToBounds = true;
//        [_titleBtn setBackgroundImage:[UIImage imageNamed:@"Ellipse"] forState:UIControlStateNormal];
        [_titleBtn setImage:[UIImage imageNamed:@"TSG_Dark"] forState:UIControlStateNormal];
//        [self addSubview:_titleBtn];
    }
    return _titleBtn;
}
- (UILabel *)pointsLb
{
    if (!_pointsLb) {
        _pointsLb = [UILabel new];
        _pointsLb.textAlignment = NSTextAlignmentLeft;
        _pointsLb.text = @"+5點";
        _pointsLb.textColor = UIColor.blackColor;
        _pointsLb.font = [UIFont systemFontOfSize:FontSize(18) weight:UIFontWeightMedium];
//        [self addSubview:_titleLb];
    }
    return _pointsLb;
}
+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"PointsRecordTBVCell";
    PointsRecordTBVCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
          cell = [[PointsRecordTBVCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//cell选中无色
    //  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//箭头
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.backgroundColor = [UIColor whiteColor];
        
        UIView *baseView = self.contentView;

        
        UILabel *titleLb = [UILabel new];
        titleLb.text = @"當月生日禮";
        titleLb.textColor = rgba(0, 122, 96, 1);
        titleLb.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
        titleLb.numberOfLines = 0;
        [baseView addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleW(16));
            make.left.mas_equalTo(ScaleW(20));
            make.right.mas_equalTo(-ScaleW(120));
        }];
        self.titleLb = titleLb;
        
        UILabel *timeLb = [UILabel new];
        timeLb.text = @"2025/01/01";
        timeLb.textAlignment = NSTextAlignmentLeft;
        timeLb.textColor = rgba(115, 115, 115, 1);
        timeLb.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
        timeLb.backgroundColor = [UIColor whiteColor];
        [baseView addSubview:timeLb];
        [timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLb.mas_bottom).offset(ScaleW(8));
            make.left.mas_equalTo(ScaleW(20));
            make.right.mas_equalTo(-ScaleW(120));
            make.bottom.mas_equalTo(-ScaleW(16));
        }];
        self.timeLb = timeLb;
        
        
        [baseView addSubview:self.pointsLb];
        [self.pointsLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-ScaleW(20));
        }];
        [baseView addSubview:self.titleBtn];
        [self.titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.pointsLb.mas_left).offset(-ScaleW(5));
            make.width.height.mas_equalTo(ScaleW(24));
            make.centerY.mas_equalTo(0);
        }];
        
    }
    return self;
}
@end

@interface EGPointsRecordViewController ()

@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;

@property (nonatomic, strong) NSMutableArray *leftList;  // 获得记录
@property (nonatomic, strong) NSMutableArray *rightList; // 使用记录

@property (nonatomic, weak)  UILabel * pointCount;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation EGPointsRecordViewController

- (NSMutableArray *)leftList {
    if (!_leftList) {
        _leftList = [NSMutableArray array];
    }
    return _leftList;
}

- (NSMutableArray *)rightList {
    if (!_rightList) {
        _rightList = [NSMutableArray array];
    }
    return _rightList;
}

- (NSMutableArray *)pointList{
    if (!_pointList) {
        _pointList = [NSMutableArray array];
    }
    return _pointList;
}

// 在设置 pointList 时调用数据分类
- (void)setpointList:(NSMutableArray *)pointList {
    _pointList = pointList;
    [self setupPointsData];
    [self.tableView reloadData];
}

- (void)setupPointsData {
    self.leftList = [NSMutableArray array];
    self.rightList = [NSMutableArray array];
    self.totalpoint = 0;
    for (EGPointsModel *model in self.pointList) {
       
        if ([model.Type isEqualToString:@"earned"]) {
            [self.leftList addObject:model];
        } else {
            [self.rightList addObject:model];
        }
        self.totalpoint += model.Points;
    }
    [self.pointCount setText:[NSString stringWithFormat:@"%ld",self.totalpoint]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.pointCount setText:[NSString stringWithFormat:@"%ld",self.totalpoint]];
}

// 实现跳转方法
-(void)rightNavigationButton
{
//  點數辦法
    EGPointsRuleViewController *ruleVC = [[EGPointsRuleViewController alloc] init];
    [self.navigationController pushViewController:ruleVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"天鷹點數";
    self.view.backgroundColor = rgba(243, 243, 243, 1);
//    [self setupPointsData];
    
    UIButton *rightBtn_navi = [[UIButton alloc]initWithFrame:CGRectZero];
    [rightBtn_navi setTitle:NSLocalizedString(@"點數辦法", nil) forState:(UIControlStateNormal)];
    [rightBtn_navi setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [rightBtn_navi addTarget:self action:@selector(rightNavigationButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn_navi];
    
    UIView *header = [UIView new];
    header.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:header];
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([UIDevice de_navigationFullHeight]);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(ScaleW(150));
    }];
    UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, ScaleW(100))];
    [header addSubview:greenView];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.frame = greenView.bounds;
    gradientLayer.colors = @[(id)rgba(0, 78, 162, 1).CGColor,(id)rgba(0, 121, 192, 1).CGColor];
    [greenView.layer insertSublayer:gradientLayer atIndex:0];
    
    

    UILabel *pointCount = [UILabel new];
    pointCount.text = [NSString stringWithFormat:@"%ld",self.totalpoint];
    pointCount.textColor = UIColor.whiteColor;
    pointCount.font = [UIFont systemFontOfSize:FontSize(32) weight:UIFontWeightSemibold];
    [greenView addSubview:pointCount];
    self.pointCount = pointCount;
    [pointCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0).offset(ScaleW(24)/2);
        make.top.mas_equalTo(ScaleW(20));
    }];
    
    UIButton *pointBtn = [[UIButton alloc] init];
//    [pointBtn setBackgroundImage:[UIImage imageNamed:@"Ellipse"] forState:UIControlStateNormal];
    [pointBtn setImage:[UIImage imageNamed:@"TSG_LIGHT"] forState:UIControlStateNormal];
    [greenView addSubview:pointBtn];
    [pointBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(ScaleW(20)); make.right.mas_equalTo(greenView.mas_centerX).offset(-ScaleW(5));
        make.width.height.mas_equalTo(ScaleW(24));
        make.centerY.equalTo(pointCount);
        make.right.mas_equalTo(pointCount.mas_left).offset(-ScaleW(5));
    }];
    
    
    UILabel *noteLb = [UILabel new];
    noteLb.text = @"點數自獲得日起有效期限為 365 天，逾期未使用將自動清除";
    noteLb.textAlignment = NSTextAlignmentCenter;
    noteLb.textColor = UIColor.whiteColor;
    noteLb.font = [UIFont systemFontOfSize:FontSize(12) weight:UIFontWeightRegular];
    [greenView addSubview:noteLb];
    [noteLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(20));
        make.right.mas_equalTo(-ScaleW(20));
        make.bottom.mas_equalTo(-ScaleW(16));
    }];
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.tag = 22;
    [leftBtn setTitle:@"獲得紀錄" forState:UIControlStateNormal];
    [leftBtn setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
    [leftBtn setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateSelected];
    leftBtn.selected = true;
    [leftBtn addTarget:self action:@selector(twoRecordButton:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(Device_Width / 2);
        make.height.mas_equalTo(ScaleW(45));
        make.bottom.mas_equalTo(-ScaleW(5));
    }];
    self.leftBtn = leftBtn;
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.tag = 23;
    [rightBtn setTitle:@"使用紀錄" forState:UIControlStateNormal];
    [rightBtn setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
    [rightBtn setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateSelected];
    [rightBtn addTarget:self action:@selector(twoRecordButton:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(Device_Width / 2);
        make.height.mas_equalTo(ScaleW(45));
        make.bottom.mas_equalTo(-ScaleW(5));
    }];
    self.rightBtn = rightBtn;
   
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [header addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(header).offset(0);
        make.left.right.equalTo(header);
        make.height.mas_equalTo(1.5);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = rgba(0, 78, 162, 1);
    [header addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(Device_Width / 2);
        make.height.mas_equalTo(ScaleW(4));
        make.bottom.mas_equalTo(0);
    }];
    self.line = line;
    
    [self.view addSubview:self.tableView];
//    self.tableView.separatorStyle = 1;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.backgroundColor = rgba(243, 243, 243, 1);

    EGCircleRefreshHeader *tableheader = [EGCircleRefreshHeader headerWithRefreshingBlock:^{
        // 进行刷新操作
        [self getdata];
//        [self.tableView.mj_header endRefreshing];
    }];
    tableheader.activityIndicator.color = [UIColor systemGrayColor];
    
    self.tableView.mj_header = tableheader;
    
    // 配置上拉加载
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    footer.hidden = YES;  // 隐藏footer
    self.tableView.mj_footer = footer;
    
    if (!( self.pointList.count > 0)) {
        [self.tableView.mj_header beginRefreshing];
    }
    [self.tableView reloadData];
//    self.tableView.backgroundColor = [UIColor whiteColor];
//    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header.mas_bottom).offset(ScaleW(20));//ScaleW(20)
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-[UIDevice de_safeDistanceBottom]);
    }];
}

-(void)getdata{
    if (self.isLoading) {
        [self.tableView.mj_header endRefreshing];
        return;
    }
    
    self.isLoading = YES;
    
    // 下拉刷新时重置页码
    if (self.tableView.mj_header.isRefreshing) {
        self.currentPage = 1;
    }
    
    UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
    if (!model) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.isLoading = NO;
        return;
    }
    
    NSString *url = [EGServerAPI pointHistoryBy:model.ID Page:self.currentPage andSize:500];
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
    NSDictionary *dict_header = @{@"Authorization":tokenString};
    
    [[WAFNWHTTPSTool sharedManager] getWithURL:url parameters:@{} headers:dict_header success:^(NSDictionary * _Nonnull response) {
        ELog(@"response:%@",response);
        NSDictionary *data = [response objectForKey:@"data"];
        NSArray *journals = [EGPointsModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"Journals"]];
        self.totalPage = [[data objectForKey:@"TotalPage"] integerValue];
        
        if (self.currentPage == 1) {
            [self.pointList removeAllObjects];
            [self.leftList removeAllObjects];
            [self.rightList removeAllObjects];
        }
        
        [self.pointList addObjectsFromArray:journals];
        [self setupPointsData];
        [self.tableView reloadData];
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        // 判断是否还有更多数据
        if (self.currentPage >= self.totalPage) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        self.isLoading = NO;
        
    } failure:^(NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([error.localizedDescription containsString:@"offline"] || error.code == -1009) {
            [MBProgressHUD showDelayHidenMessage:@"請檢查您的網路連線，確保裝置已連接至網路後再重試。"];
        }else{
            [MBProgressHUD showDelayHidenMessage:error.localizedDescription];
        }
        self.isLoading = NO;
    }];
}

// 添加加载更多数据的方法
-(void)loadMoreData {
    if (self.currentPage >= self.totalPage) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    self.currentPage++;
    [self getdata];
}

// 修改 scrollViewDidScroll 方法来实现无感刷新
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.isLoading && scrollView.contentOffset.y > 0) {  // 上滑
        CGFloat currentOffsetY = scrollView.contentOffset.y;
        CGFloat contentHeight = scrollView.contentSize.height;
        CGFloat screenHeight = scrollView.frame.size.height;
        
        if ((currentOffsetY + screenHeight) > (contentHeight - 100)) {  // 距离底部100点时触发加载
            [self loadMoreData];
        }
    }
}

-(void)twoRecordButton:(UIButton *)sender
{
    if (sender.tag == 22) {
        self.leftBtn.selected = true;
        self.rightBtn.selected = false;
        [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
        }];
    }else{
        self.leftBtn.selected = false;
        self.rightBtn.selected = true;
        [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Device_Width / 2);
        }];
    }
    
    [self.tableView reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSString *)xy_noDataViewMessage {
    return @"尚無紀錄";
}

- (UIImage *)xy_noDataViewImage {
    return [UIImage imageNamed:@"nodata"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if (self.leftBtn.selected) {
        return self.leftList.count;
    } else {
        return self.rightList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PointsRecordTBVCell *cell = [PointsRecordTBVCell cellWithUITableView:tableView];
    
    EGPointsModel *model = self.leftBtn.selected ? self.leftList[indexPath.row] : self.rightList[indexPath.row];
    
    cell.titleLb.text = [model.Description isEqualToString:@""]? @"Description":model.Description;
    
    
    // 转换日期格式
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSSSZZZZZ"];
    NSDate *date = [inputFormatter dateFromString:model.CreditedAt];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [outputFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *formattedDate = [outputFormatter stringFromDate:date];
    
    cell.timeLb.text = formattedDate;
   
    if (self.leftBtn.selected) {
        cell.pointsLb.textColor = rgba(64, 64, 64, 1);
        cell.pointsLb.text = [NSString stringWithFormat:@"+%ld", model.Points];
    }else{
        cell.pointsLb.textColor = rgba(220, 38, 38, 1);
        cell.pointsLb.text = [NSString stringWithFormat:@"%ld", model.Points];
    }
    return cell;

}

@end



