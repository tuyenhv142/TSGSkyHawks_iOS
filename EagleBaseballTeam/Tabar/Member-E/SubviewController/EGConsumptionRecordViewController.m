#import "EGConsumptionRecordViewController.h"
#import "EGOrderCell.h"
#import "EGOrderDetailViewController.h"
#import "UITableView+XY.h"
#import "EGUserOrdersModel.h"

#import "EGOrderDetailInfo.h"
#import "EGTopButtonsView.h"

@interface EGConsumptionRecordViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) EGTopButtonsView *topBtnView;
@property (nonatomic, assign) BOOL isUserScrolling;
@property (nonatomic, assign) BOOL isRightView;
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UIScrollView *mainscrollView;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;

@property (nonatomic, strong) NSMutableArray *filteredOrderList;
@property (nonatomic, strong) NSMutableArray *offlineConsumption;//现场消费
@property (nonatomic, strong) NSMutableArray *tmpArray;//search 现场消费

@property (nonatomic, strong) NSMutableArray<EGOrderDetailInfo *> *orderDetails;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation EGConsumptionRecordViewController

- (NSMutableArray *)orderList{
    if (!_orderList) {
        _orderList = [NSMutableArray array];
    }
    return _orderList;
}
- (NSMutableArray *)filteredOrderList
{
    if (!_filteredOrderList) {
        _filteredOrderList = [NSMutableArray arrayWithCapacity:0];
    }
    return _filteredOrderList;
}
- (NSMutableArray *)offlineConsumption
{
    if (!_offlineConsumption) {
        _offlineConsumption = [NSMutableArray arrayWithCapacity:0];
    }
    return _offlineConsumption;
}
- (NSMutableArray *)tmpArray
{
    if (!_tmpArray) {
        _tmpArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _tmpArray;
}
#pragma  mark 初始化table View
- (UITableView *)leftTableView
{
    if (_leftTableView == nil) {
        
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _leftTableView.tag = 555;
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.backgroundColor = [UIColor clearColor];
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.estimatedRowHeight = 100;
        _leftTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getOrderHistoryDataList];
        }];
        
    }
    return _leftTableView;
}
- (UITableView *)rightTableView
{
    if (_rightTableView == nil) {
        _rightTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _rightTableView.tag = 666;
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.backgroundColor = [UIColor clearColor];
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.showsVerticalScrollIndicator = NO;
        _rightTableView.estimatedRowHeight = 100;
        _rightTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getdata];
        }];
    }
    return _rightTableView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if (_userID == nil || [_userID isEqualToString:@""]) {
        [self getUserIDByEmail];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.962 green:0.962 blue:0.962 alpha:1.0];
    self.navigationItem.title = @"累積消費紀錄";
    
    [self setupUI];
    
    if (!(self.orderList.count > 0)) {
        [self.leftTableView.mj_header beginRefreshing];
        
    }else{
        [self.filteredOrderList addObjectsFromArray:self.orderList];
        [self.leftTableView reloadData];
    }
    
    [self getOrderHistoryDataList];
}
//MARK: 获取现场消费
-(void)getOrderHistoryDataList
{
    UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
    NSDictionary *dict_header = @{@"Authorization":tokenString};
    [[WAFNWHTTPSTool sharedManager] getWithURL:[EGServerAPI orderHistory_api:model.ID] parameters:@{@"size":@(100)} headers:dict_header success:^(NSDictionary * _Nonnull response) {
        
        [self.offlineConsumption removeAllObjects];
        [self.tmpArray removeAllObjects];
        
        NSDictionary *dict = response[@"data"];
        NSArray *recordDetail = [dict objectOrNilForKey:@"RecordDetail"];
        NSArray *array = [OrderHistoryModel mj_objectArrayWithKeyValuesArray:recordDetail];
        [self.offlineConsumption addObjectsFromArray:array];
        [self.tmpArray addObjectsFromArray:array];
        [self.leftTableView reloadData];
        
        
        [self.leftTableView.mj_header endRefreshing];
        
        } failure:^(NSError * _Nonnull error) {
            [self.leftTableView.mj_header endRefreshing];
        }];
}

- (void )getUserIDByEmail{
    if (!self.userEmail) {
//        [self.searchBar setHidden:YES];
        return;
    }
    NSString *url = [EGServerAPI getUserInfobyEmail:self.userEmail];
    [[WAFNWHTTPSTool sharedManager] getWithURL:url parameters:@{} headers:@{} success:^(NSDictionary * _Nonnull response) {
        NSString *userID = nil;
        if ([response isKindOfClass:[NSArray class]]) {
            //&& [response objectForKey:@"id"] != nil
            NSArray *array = [NSArray arrayWithArray:(NSArray *)response];
            if (array.count>0) {
                NSDictionary *dict = array[0];
                id idValue = [dict objectForKey:@"id"];
                if ([idValue isKindOfClass:[NSString class]]) {
                    userID = idValue;
                } else if ([idValue isKindOfClass:[NSNumber class]]) {
                    userID = [idValue stringValue];
                }
            }
        }
        if (!userID) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.isRightView) {
                    [self.rightTableView reloadData];
                    [self.rightTableView.mj_header endRefreshing];
                }else{
                    [self.leftTableView reloadData];
                    [self.leftTableView.mj_header endRefreshing];
                }
            });
            return;
        }
        self.userID = userID;
    } failure:^(NSError * _Nonnull error) {
        [self.rightTableView.mj_header endRefreshing];
        [self.leftTableView.mj_header endRefreshing];
    }];
}

-(void)getdata{
    
    if (self.isLoading || _userID == nil || [_userID isEqualToString:@""]) {
        if (self.isRightView) {
            [self.rightTableView reloadData];
            [self.rightTableView.mj_header endRefreshing];
        }else{
            [self.leftTableView reloadData];
            [self.leftTableView.mj_header endRefreshing];
        }
        return;
    }
    self.isLoading = YES;
    // 下拉刷新时重置页码
    if (self.isRightView) {
        if (self.rightTableView.mj_header.isRefreshing) {
            self.currentPage = 1;
        }
    }else{
        if (self.leftTableView.mj_header.isRefreshing) {
            self.currentPage = 1;
        }
    }
    WS(weakSelf)
    [weakSelf getUserOrdersBy:self.userID success:^(id response) {
        if ([response isKindOfClass:[NSArray class]]) {
            
            //成功get order信息。
            NSArray *array = [NSArray arrayWithArray:(NSArray *)response];
            [self.filteredOrderList removeAllObjects];
            [self.orderList removeAllObjects];
            
            NSArray *arrayModel = [EGUserOrdersModel mj_objectArrayWithKeyValuesArray:array];
            
            if (arrayModel.count > 0) {
                [self.searchBar setHidden:NO];
            }
            for (EGUserOrdersModel *model in arrayModel) {
                // 转换时间格式
                NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
                [inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                // 设置固定的 locale，避免受系统设置影响
                [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
                // 设置时区
                NSDate *date = [inputFormatter dateFromString:model.date_created];
                NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
                [outputFormatter setDateFormat:@"yyyy/MM/dd"];
                NSString *formattedDate = [outputFormatter stringFromDate:date];
                
                //订单详情数据 结构
                EGOrderDetailInfo *orderDetail = [EGOrderDetailInfo new];
                orderDetail.orderId = model.ID;
                //获取总计
                orderDetail.totalAmount = model.total;
                orderDetail.products = [NSMutableArray array];
                
                //获取运费
                NSInteger shipping = 0;
                for (NSDictionary *dict in model.shipping_lines){
                    shipping += [[dict objectOrNilForKey:@"total"] intValue];
                }
                orderDetail.shippingFee = [NSString stringWithFormat:@"%ld",(long)shipping];
                //获取小计
                NSInteger total = 0;
                //获取order name
                NSString *name;
                for (int i=0; i< model.line_items.count; i++) {
                    EGLineItemModel *model2 = [EGLineItemModel mj_objectWithKeyValues: model.line_items[i]];
                    total +=[model2.total intValue];
                    if (i==0) {
                        name = model2.name?:@"";
                    }
                    
                    EGOrderProductInfo *product = [EGOrderProductInfo new];
                    product.title = model2.name?:@"";
                    
                    //产品花费（）
                    product.price = model2.price?:@"";
                    
                    product.quantity = model2.quantity?:@"";
                    //产品图片
                    product.imageUrl = model2.image.src?:@"";
                    
                    //获取购买产品详细信息
                    [orderDetail.products addObject:product];
                }
                orderDetail.subtotal = [NSString stringWithFormat:@"%ld",total];
                
                //使用红利点数 meta_data 中的meta_data
                for (NSDictionary *dict in model.meta_data){
                    NSString *key = [dict objectForKey:@"key"];
                    if ([key isEqualToString:@"th_points_get"]) {
                        NSDictionary *value = [dict objectForKey:@"value"];
                        if ([value isKindOfClass:[NSDictionary class]]) {
                            NSNumber *totalPoints = [value objectForKey:@"total_points"];
                            //获得红利点数
                            orderDetail.bonusEarned = [totalPoints stringValue];
                        }
                    } else if ([key isEqualToString:@"th_points_use"]) {
                        id value = [dict objectForKey:@"value"];
                        if ([value isKindOfClass:[NSString class]]) {
                            orderDetail.bonusUsed = value;
                        } else if ([value isKindOfClass:[NSNumber class]]) {
                            orderDetail.bonusUsed = [value stringValue];
                        }
                    }
                }
                orderDetail.bonusUsed = orderDetail.bonusUsed?:@"";
                orderDetail.bonusEarned = orderDetail.bonusEarned?:@"";
                
                
                //orderDetail
                [self.orderList addObject:@{
                    @"orderId": model.ID,
                    @"title": name?name:@"",
                    @"price": model.total?model.total:@"",
                    @"date": formattedDate?formattedDate:@"",
                    @"orderDetail":orderDetail
                }];
            }
        }
        
  
        [self.filteredOrderList addObjectsFromArray:self.orderList];
        if (self.filteredOrderList.count < 1) {
            self.searchBar.hidden =  true;
        }else{
            self.searchBar.hidden =  false;
        }
        // 刷新表格
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.isRightView) {
                [self.rightTableView reloadData];
                [self.rightTableView.mj_header endRefreshing];
            }else{
                [self.leftTableView reloadData];
                [self.leftTableView.mj_header endRefreshing];
            }
            
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.isRightView) {
                [self.rightTableView reloadData];
                [self.rightTableView.mj_header endRefreshing];
            }else{
                [self.leftTableView reloadData];
                [self.leftTableView.mj_header endRefreshing];
            }
            
            if ([error.localizedDescription containsString:@"offline"] || error.code == -1009) {
                [MBProgressHUD showDelayHidenMessage:@"請檢查您的網路連線，確保裝置已連接至網路後再重試。"];
            }else{
                [MBProgressHUD showDelayHidenMessage:error.localizedDescription];
            }
        });
    }];
}

-(void)getUserOrdersBy:(NSString *)userID success:(void (^)(id response)) success failure:(void (^)(NSError *error))failure {

    // 组合用户名和密码
    NSString *authString = [NSString stringWithFormat:@"%@:%@", [[EGCredentialManager sharedManager] getUsername], [[EGCredentialManager sharedManager] getPassword]];
    // Base64 编码
    NSData *authData = [authString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64AuthString = [authData base64EncodedStringWithOptions:0];
    // 添加 Basic Auth 请求头
    NSString *authHeader = [NSString stringWithFormat:@"Basic %@", base64AuthString];
 
    NSDictionary *dict_header = @{@"Authorization":authHeader};
    
    NSString *url = [EGServerAPI getUserOrders:userID  pagesize:@"10"];
    [[WAFNWHTTPSTool sharedManager] getWithURL:url parameters:@{} headers:dict_header success:^(id  _Nonnull response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

- (void)setupUI {
    
    WS(weakSelf);
    CGRect rectTop = CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, ScaleW(52));
    self.topBtnView = [[EGTopButtonsView alloc] initWithFrame:rectTop];
    [self.topBtnView setupUIForArray:@[@"現場消費",@"商城消費"]];
    self.topBtnView.clickBtnBlock = ^(NSInteger index) {
        weakSelf.isUserScrolling = NO;
        weakSelf.isRightView = index;
        if (weakSelf.isRightView) {
            
            [weakSelf.rightTableView reloadData];
        }else{
            [weakSelf.leftTableView reloadData];
        }
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf.mainscrollView setContentOffset:CGPointMake(index * Device_Width, 0)];
        }];
    };
    [self.view addSubview:self.topBtnView];
    
    // 搜索栏
    self.searchBar = [[UISearchBar alloc] init];
    // 设置搜索栏背景色为透明
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.backgroundImage = [UIImage new];
    self.searchBar.placeholder = @"輸入訂單編號貨商品名稱";
    self.searchBar.delegate = self;
    // 自定义搜索框样式
    if (@available(iOS 13.0, *)) {
        self.searchBar.searchTextField.backgroundColor = [UIColor whiteColor];
        self.searchBar.searchTextField.layer.cornerRadius = ScaleW(8);
        self.searchBar.searchTextField.clipsToBounds = YES;
        self.searchBar.searchTextField.layer.borderColor = rgba(212, 212, 212, 1).CGColor;
        self.searchBar.searchTextField.layer.borderWidth = 0.5;
    }
    [self.view addSubview:self.searchBar];
    CGFloat topM = [UIDevice de_navigationFullHeight] + ScaleW(52);
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(topM + ScaleW(20));
        make.left.right.equalTo(self.view).inset(ScaleW(20));
        make.height.mas_equalTo(ScaleW(45));
    }];
    // 调整搜索框内部 TextField 的布局
    if (@available(iOS 13.0, *)) {
        [self.searchBar.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.searchBar);
        }];
    }
    
    // 滚动视图
    CGFloat scrtop = [UIDevice de_navigationFullHeight] + ScaleW(52) + ScaleW(20) + ScaleW(45);
    CGRect rectScro = CGRectMake(0, scrtop, Device_Width, Device_Height-scrtop);
    self.mainscrollView = [[UIScrollView alloc] init];
    self.mainscrollView.frame = rectScro;
    self.mainscrollView.backgroundColor = [UIColor colorWithRed:0.962 green:0.962 blue:0.962 alpha:1.0];
    self.mainscrollView.delegate = self;
    self.mainscrollView.pagingEnabled = YES;
    self.mainscrollView.scrollEnabled = YES;
    self.mainscrollView.bounces = YES;
    self.mainscrollView.showsHorizontalScrollIndicator = false;
    [self.view addSubview:self.mainscrollView];
    self.mainscrollView.contentSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width * 2, 0);
    
    
    CGRect contentRect = CGRectMake(0, ScaleW(20), Device_Width*2, Device_Height-scrtop);
    UIView *contentview = [UIView new];
    contentview.backgroundColor = UIColor.clearColor;
    contentview.frame = contentRect;
    [self.mainscrollView addSubview:contentview];

    [contentview addSubview:self.leftTableView];
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(Device_Width);
        make.bottom.mas_equalTo(0);
    }];
    
    [contentview addSubview:self.rightTableView];
    [self.rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(Device_Width);
        make.width.mas_equalTo(Device_Width);
        make.bottom.mas_equalTo(0);
    }];
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.rightTableView isEqual:tableView]) {
        return self.filteredOrderList.count;
    }else{
        return self.offlineConsumption.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EGOrderCell *cell = [EGOrderCell cellWithUITableView:tableView];
    if ([self.rightTableView isEqual:tableView]) {
        NSDictionary *order = self.filteredOrderList[indexPath.row];
        [cell setupWithOrder:order];
    }else{
        [cell setHistoryModel:self.offlineConsumption[indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.rightTableView isEqual:tableView]) {
        NSDictionary *orderInfo = self.filteredOrderList[indexPath.row];
        EGOrderDetailInfo *orderDetail = [orderInfo objectForKey:@"orderDetail"];
        EGOrderDetailViewController *detailVC = [[EGOrderDetailViewController alloc] init];
        detailVC.orderInfo = orderDetail;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
        
        OrderHistoryModel *orderModelo = self.offlineConsumption[indexPath.row];
        EGOrderDetailViewController *detailVC = [[EGOrderDetailViewController alloc] init];
        detailVC.orderID = orderModelo.OrderId;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    
    if (self.isRightView) {
        if (searchText.length == 0) {
            [self.filteredOrderList removeAllObjects];
            [self.filteredOrderList addObjectsFromArray:self.orderList];
        } else {
            [self.filteredOrderList removeAllObjects];
            for (NSDictionary *order in self.orderList) {
                if ([order[@"orderId"] containsString:searchText] || [order[@"title"] containsString:searchText]) {
                    [self.filteredOrderList addObject:order];
                }
            }
        }
        [self.rightTableView reloadData];
        
    }else{
        if (searchText.length == 0) {
            [self.offlineConsumption removeAllObjects];
            [self.offlineConsumption addObjectsFromArray:self.tmpArray];
        }else{
            [self.offlineConsumption removeAllObjects];
            for (OrderHistoryModel *orderModelo in self.tmpArray) {
                if ([orderModelo.PurchasedItem containsString:searchText] || [orderModelo.OrderId containsString:searchText]) {
                    [self.offlineConsumption addObject:orderModelo];
                }
            }
        }
        [self.leftTableView reloadData];
    }
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark scroller delegate
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if ([scrollView isKindOfClass:[UITableView class]])
    {
        return;
    }
    if (self.isUserScrolling) {
        NSInteger index = scrollView.contentOffset.x / UIScreen.mainScreen.bounds.size.width;
        [self.topBtnView setStatusLableForIndex:index];
    }
    if (self.isRightView) {
        [self.rightTableView reloadData];
    }else{
        [self.leftTableView reloadData];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isUserScrolling = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.isUserScrolling)
        return;
    
    if ([scrollView isKindOfClass:[UITableView class]])
    {
        return;
    }
    NSInteger index = scrollView.contentOffset.x / UIScreen.mainScreen.bounds.size.width;
    [self.topBtnView setStatusLableForIndex:index];
    
    self.isRightView = index;
}

- (UIView *)xy_noDataView{
    UIImage *image = [UIImage imageNamed:@"nodata"];
 
    CGFloat  offset = 0;
    //  计算位置, 垂直居中, 图片默认中心偏上.
    CGFloat sW = self.rightTableView.bounds.size.width;
    CGFloat cX = sW / 2;
    CGFloat cY = self.rightTableView.bounds.size.height * (1 - 0.618) + offset;
    CGFloat iW = image.size.width;
    CGFloat iH = image.size.height;
    
    //  图片
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame        = CGRectMake(cX - iW / 2, cY - iH / 2, iW, iH);
    imgView.image        = image;
    
    //  文字
    UILabel *label       = [[UILabel alloc] init];
    label.font           = [UIFont systemFontOfSize:FontSize(14)weight:UIFontWeightMedium];
    label.textColor      =  rgba(163, 163, 163, 1);
    label.text           = @"尚無紀錄";
    label.textAlignment  = NSTextAlignmentCenter;
    label.frame          = CGRectMake(0, CGRectGetMaxY(imgView.frame) + ScaleW(8), sW, label.font.lineHeight);
    
    //  文字1
    UILabel *label1       = [[UILabel alloc] init];
    label1.font           = [UIFont systemFontOfSize:FontSize(14)weight:UIFontWeightMedium];
    label1.textColor      = rgba(115, 115, 115, 1);
    label1.text           = @"前往商城，開啟消費紀錄！";
    label1.textAlignment  = NSTextAlignmentCenter;
    label1.frame          = CGRectMake(0, CGRectGetMaxY(label.frame) + ScaleW(170), sW, label.font.lineHeight);
    
    //  文字2
    UILabel *label2       = [[UILabel alloc] init];
    label2.font           = [UIFont systemFontOfSize:FontSize(14)weight:UIFontWeightRegular];
    label2.textColor      = rgba(163, 163, 163, 1);
    label2.userInteractionEnabled = YES; // 启用用户交互
    // 创建带下划线的文本
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"前往商城登入後的會員才可以看到訂單紀錄"];
    // 下划线样式
    [attributedString addAttribute:NSUnderlineStyleAttributeName
                             value:@(NSUnderlineStyleSingle)
                             range:NSMakeRange(0, 6)];
    
    // 添加点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openLoginPage)];
    [label2 addGestureRecognizer:tapGesture];
    
    // 基线偏移
    [attributedString addAttribute:NSBaselineOffsetAttributeName
                             value:@(3)
                             range:NSMakeRange(0, attributedString.length)];
    label2.attributedText = attributedString;
    label2.textAlignment  = NSTextAlignmentCenter;
    label2.frame          = CGRectMake(0, CGRectGetMaxY(label1.frame) + 10, sW, label.font.lineHeight);
    
    //  视图
    UIView *view   = [[UIView alloc] init];
//    view.backgroundColor = [UIColor redColor];
    [view addSubview:imgView];
    [view addSubview:label];
    
    if (!self.userEmail || [self.userEmail isEqualToString:@""])
    {
        [view addSubview:label1];
        [view addSubview:label2];
    }
    
//    //  实现跟随 TableView 滚动
//    [view addObserver:self forKeyPath:kXYNoDataViewObserveKeyPath options:NSKeyValueObservingOptionNew context:nil];
    return view;
}

// 添加新方法
- (void)openLoginPage {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.tsghawks.com/member/#/login/phone-login-form"] options:@{} completionHandler:nil];
}
- (UIImage *)xy_noDataViewImage {
    return [UIImage imageNamed:@"nodata"];
}
@end
