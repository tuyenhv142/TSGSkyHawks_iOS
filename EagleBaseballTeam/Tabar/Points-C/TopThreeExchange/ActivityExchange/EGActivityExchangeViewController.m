//
//  EGActivityExchangeViewController.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/4/27.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGActivityExchangeViewController.h"
#import "EGSortView.h"
#import "EGActivityExchangeTBViewCell.h"

#import "EGActivityDetailViewController.h"

@interface EGActivityExchangeViewController ()<UISearchBarDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSArray* activty_array;
@property (nonatomic, strong) NSMutableArray* activty_filter_array;
@property (nonatomic, strong) UIButton* point_bt;
@end

@implementation EGActivityExchangeViewController

- (NSString *)xy_noDataViewMessage {
    return @"尚無活動兌換";
}

- (UIImage *)xy_noDataViewImage {
    return [UIImage imageNamed:@"nodata"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self getDataList];
    self.points = [EGLoginUserManager getMemberInfoPoints].Points;
    [self.point_bt setTitle:[NSString stringWithFormat:@"%ld",self.points] forState:UIControlStateNormal];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"活動兌換";
    self.view.backgroundColor = rgba(243, 243, 243, 1);
    
    
    self.sort_type = 0;
    [self createUI];
    //[self getDataList];
    
    
}

- (NSMutableArray *)activty_filter_array
{
    if(!_activty_filter_array)
        _activty_filter_array = [NSMutableArray array];
    
    return _activty_filter_array;
}

-(void)getDataList
{
    //[self.tableView.mj_header beginRefreshing];
    UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
    NSDictionary *dict_header = @{@"Authorization":tokenString};
    [[WAFNWHTTPSTool sharedManager] getWithURL:[EGServerAPI couponsList_api:model.ID getType:2] parameters:@{} headers:dict_header success:^(NSDictionary * _Nonnull response) {
        self.activty_array = response[@"data"];
        //[self sortByDate:NO];
        [self sortbytype:self.sort_type];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError * _Nonnull error) {
            
        }];
}

-(void)sortbytype:(NSInteger)sorttype
{
        switch (sorttype) {
            case 0:
                [self sortByDate:NO];
                break;
                
            case 1:
                [self sortByDate:YES];
                break;
                
            case 2:
                [self sortByPoint:NO];
                break;
            case 3:
                [self sortByPoint:YES];
                break;
        }
        
        [self.tableView reloadData];
       
}

-(void)sort:(UIButton*)bt
{
    EGSortView *picker = [[EGSortView alloc] init];
    [picker setinfo:self.sort_type];
    
    picker.gBlock = ^(NSInteger index){
        
        self.sort_type = index;
        
        switch (index) {
            case 0:
                [self sortByDate:NO];
                break;
                
            case 1:
                [self sortByDate:YES];
                break;
                
            case 2:
                [self sortByPoint:NO];
                break;
            case 3:
                [self sortByPoint:YES];
                break;
        }
        
        [self.tableView reloadData];
        } ;
    [picker popPickerView];
    
}

#pragma  mark -----按日期排序-----
-(void)sortByDate:(BOOL)ascending
{
    //NO is 降序排列，日期最新排在最前头
    //YES is 升序排列，日期最新拍在做后头
    [self.activty_filter_array removeAllObjects];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"redeemStartAt" ascending:ascending];
    NSArray *sortedArray = [self.activty_array sortedArrayUsingDescriptors:@[sortDescriptor]];
    self.activty_filter_array = [NSMutableArray arrayWithArray:sortedArray];
}


#pragma mark ------按点数排序-----
-(void)sortByPoint:(BOOL)ascending
{
    //NO is 降序排列，日期最新排在最前头
    //YES is 升序排列，日期最新拍在做后头
    [self.activty_filter_array removeAllObjects];
    NSArray *sortedArray = [self.activty_array sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSInteger valueA = [a[@"pointCost"] integerValue];
        NSInteger valueB = [b[@"pointCost"] integerValue];
        if(ascending)
          return valueA > valueB;
        else
            return valueA < valueB;
    }];
    self.activty_filter_array = [NSMutableArray arrayWithArray:sortedArray];
}


-(void)createUI
{
    UIView *topView = [UIView new];
    topView.backgroundColor = rgba(16, 38, 73, 1);
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ScaleW(47));
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo([UIDevice de_navigationFullHeight]);
    }];
    UILabel *titleLb = [UILabel new];
    titleLb.text = @"我的點數";
    titleLb.textColor = rgba(255, 255, 255, 1);
    titleLb.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightMedium];
    [topView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(ScaleW(20));
    }];
    UIButton *_pointsBtn = [[UIButton alloc] init];
    [_pointsBtn setTitle:[NSString stringWithFormat:@"%ld",self.points] forState:UIControlStateNormal];
    _pointsBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(20) weight:(UIFontWeightSemibold)];
    [_pointsBtn setImage:[UIImage imageNamed:@"TSG_LIGHT"] forState:UIControlStateNormal];
    [_pointsBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
//    [_pointsBtn addTarget:self action:@selector(pointsGoodsCollectExchangee:) forControlEvents:UIControlEventTouchUpInside];
    [_pointsBtn layoutButtonWithEdgeInsetsStyle:ZYButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    _pointsBtn.userInteractionEnabled = false;
    [topView addSubview:_pointsBtn];
    _pointsBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-20, -30, -20, -20);
    [_pointsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-ScaleW(20));
    }];
    self.point_bt = _pointsBtn;
    
    // 搜索栏
    self.searchBar = [[UISearchBar alloc] init];
    // 设置搜索栏背景色为透明
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.backgroundImage = [UIImage new];
    self.searchBar.placeholder = @"輸入兌換名稱";
    self.searchBar.delegate = self;
    self.searchBar.searchTextField.delegate = self;
    // 自定义搜索框样式
    if (@available(iOS 13.0, *)) {
        self.searchBar.searchTextField.backgroundColor = [UIColor whiteColor];
        self.searchBar.searchTextField.layer.cornerRadius = ScaleW(8);
        self.searchBar.searchTextField.clipsToBounds = YES;
        self.searchBar.searchTextField.layer.borderColor = rgba(212, 212, 212, 1).CGColor;
        self.searchBar.searchTextField.layer.borderWidth = 0.5;
    }
    [self.view addSubview:self.searchBar];
    CGFloat topM = [UIDevice de_navigationFullHeight] + ScaleW(47) + ScaleW(15);
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(topM);
        make.left.right.equalTo(self.view).inset(ScaleW(20));
        make.height.mas_equalTo(ScaleW(45));
    }];
    
    //Search bar 右侧增加button
    // 创建一个按钮
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScaleW(25), ScaleW(25))];//[UIButton buttonWithType:UIButtonTypeSystem];
    [button setImage:[UIImage imageNamed:@"sort"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sort:) forControlEvents:UIControlEventTouchUpInside];
    //[button sizeToFit];
     
    // 创建一个 UIView 用于覆盖 search bar 的右侧
    UIView *overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScaleW(25), ScaleW(25))];
    overlayView.backgroundColor = [UIColor clearColor];
    [overlayView addSubview:button];
    
    // 将 overlayView 添加到 search bar 的 subview 中
    // 注意调整 overlayView 的 frame 以确保它位于 search bar 的右侧
    CGRect overlayFrame = overlayView.frame;
    overlayFrame.origin.x = self.searchBar.frame.size.width - overlayFrame.size.width; // 确保它在右侧
    overlayView.frame = overlayFrame;
    [self.searchBar addSubview:overlayView];
    [overlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(10));
        make.right.mas_equalTo(-ScaleW(10));
        make.width.mas_equalTo(ScaleW(25));
        make.height.mas_equalTo(ScaleW(25));
    }];
    
    
//    // 调整搜索框内部 TextField 的布局
//    if (@available(iOS 13.0, *)) {
//        [self.searchBar.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.searchBar);
//        }];
//    }
    
    self.tableView.backgroundColor = UIColor.clearColor;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([UIDevice de_navigationFullHeight] + ScaleW(47) + ScaleW(65));
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [self getDataList];
            }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.activty_filter_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EGActivityExchangeTBViewCell *cell = [EGActivityExchangeTBViewCell cellWithUITableView:tableView];
    cell.info = [self.activty_filter_array objectAtIndex:indexPath.row];
    [cell updateUI];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EGActivityDetailViewController *detailVC = [[EGActivityDetailViewController alloc] init];
    detailVC.activty_id = @"";
    detailVC.from_type = 0;
    detailVC.points = self.points;
    
    if(indexPath.row<self.activty_filter_array.count){
        detailVC.info = [self.activty_filter_array objectAtIndex:indexPath.row];
        //[detailVC updateUI];
    }
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark -
#pragma mark - UISearchBardelegete
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    NSLog(@"任务编辑文本");
    return YES;
}
// return NO to not become first responder
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    NSLog(@"开始");
}
// called when text starts editing
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    
    return YES;
}
// return NO to not resign first responder
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
    NSLog(@"编辑完成");
    
}
// called when text ends editing
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //清空数组
    [self.activty_filter_array removeAllObjects];
    
    if(![searchText isEqualToString:@""]){
        //谓词搜索
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@", searchText];
        NSMutableArray *names = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in self.activty_array)
        {
            [names addObject:[dic objectForKey:@"couponName"]];
        }
        //筛选出来的名称
        NSArray *filterNames =  [[NSArray alloc] initWithArray:[names filteredArrayUsingPredicate:predicate]];
        for (NSDictionary *dic in self.activty_array)
        {
            for (NSString *name in filterNames)
            {
                if ([name isEqualToString:[dic objectForKey:@"couponName"]])
                {
                    [self.activty_filter_array addObject:dic];
                }
            }
        }
    }
    else
        self.activty_filter_array = [NSMutableArray arrayWithArray:self.activty_array];
        
    [self.tableView reloadData];
}
 
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    //    [searchDisplayController setActive:NO animated:YES];
    NSLog(@"点击完成");
}
// called when keyboard search button pressed
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"ddd");
}

@end
