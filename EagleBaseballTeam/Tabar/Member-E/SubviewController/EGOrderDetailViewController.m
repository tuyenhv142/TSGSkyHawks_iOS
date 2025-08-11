#import "EGOrderDetailViewController.h"
#import "EGOrderDetailCell.h"

@interface EGOrderDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *products;
//@property (nonatomic, strong) UILabel *orderIdLabel;
//@property (nonatomic, strong) UILabel *subtotalLabel;
//@property (nonatomic, strong) UILabel *pointsUsedLabel;
//@property (nonatomic, strong) UILabel *pointsEarnedLabel;
//@property (nonatomic, strong) UILabel *shippingLabel;
@property (nonatomic, strong) NSArray *Invoice;
@property (nonatomic, strong) NSArray *Point;
@end

@implementation EGOrderDetailViewController
- ( NSMutableArray *)products{
    if (!_products) {
        _products = [NSMutableArray array];
    }
    return _products;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.962 green:0.962 blue:0.962 alpha:1.0];
    self.navigationItem.title = @"訂單詳情";
    
    [self setupUI];
    
    if (!self.orderInfo && self.orderID) {
        [self getOrderHistoryDataList];
    }else{
        self.products = self.orderInfo.products;
    }
}

- (void)setupUI {

    self.tableView.backgroundColor = [UIColor colorWithRed:0.962 green:0.962 blue:0.962 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset([UIDevice de_navigationFullHeight]+ScaleW(16));
        make.left.right.equalTo(self.view).inset(ScaleW(16));
        make.bottom.equalTo(self.view);
    }];
    
}


//获取现场消费 -详情
-(void)getOrderHistoryDataList
{
    UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
    NSDictionary *dict_header = @{@"Authorization":tokenString};
    [[WAFNWHTTPSTool sharedManager] getWithURL:[EGServerAPI orderHistoryDeatil_api:model.ID orderId:self.orderID] parameters:@{} headers:dict_header success:^(NSDictionary * _Nonnull response) {
        ELog(@"-----%@",response);
        NSDictionary *dict = response[@"data"];
        NSDictionary *OrderDetail = [dict objectOrNilForKey:@"OrderDetail"];
        NSArray *SellItem = [OrderDetail objectOrNilForKey:@"SellItem"];
        [self.products addObjectsFromArray:SellItem];
        
        
        self.Invoice = [OrderDetail objectOrNilForKey:@"Invoice"];
        
        self.Point = [OrderDetail objectOrNilForKey:@"Point"];
        
        [self.tableView reloadData];
        
        } failure:^(NSError * _Nonnull error) {
            
        }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.products.count; // 商品列表数量
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    
    // 订单编号标签
    UILabel *orderIdLabel = [[UILabel alloc] init];
    orderIdLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightMedium];
    orderIdLabel.textColor = rgba(115, 115, 115, 1);
    if (self.orderInfo) {
        orderIdLabel.text = [NSString stringWithFormat:@"訂單編號：%@", self.orderInfo.orderId];
    }else
    {
//        if (self.Invoice) {
//            NSDictionary *dict = [self.Invoice firstObject];
//            orderIdLabel.text = [NSString stringWithFormat:@"訂單編號：%@", [dict objectOrNilForKey:@"InvoiceNo"]];
//        }
        orderIdLabel.text = [NSString stringWithFormat:@"訂單編號：%@", self.orderID];
    }
    [headerView addSubview:orderIdLabel];
    [orderIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(ScaleW(16));
        make.top.equalTo(headerView).offset(ScaleW(16));
        make.bottom.equalTo(headerView).offset(0);
    }];
    headerView.layer.cornerRadius = ScaleW(8);
    headerView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    headerView.clipsToBounds = YES;
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor whiteColor];
    // 添加顶部分隔线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = rgba(229, 229, 229, 1);
    [footerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerView).offset(ScaleW(5));
        make.left.right.equalTo(footerView).inset(ScaleW(16));
        make.height.mas_equalTo(ScaleW(1));
    }];
    NSArray *items;
    if (self.orderInfo) {
        items = @[
            @{@"leftTitle": @"小計", @"rightValue": [self formatterPrice: self.orderInfo.subtotal]},
            @{@"leftTitle": @"使用紅利點數", @"rightValue":[NSString stringWithFormat:@"-%@",self.orderInfo.bonusUsed] , @"isRed": @YES},
            @{@"leftTitle": @"獲得紅利點數", @"rightValue": self.orderInfo.bonusEarned, @"isYellow": @YES},
            @{@"leftTitle": @"運費", @"rightValue": [self formatterPrice: self.orderInfo.shippingFee]},
            @{@"leftTitle": @"總金額", @"rightValue": [self formatterPrice: self.orderInfo.totalAmount]}
        ];
    }else{
        NSInteger totalPoint= 0;
        for (NSDictionary *dict in self.Point) {
            NSInteger point = [[dict objectOrNilForKey:@"TransPoint"] intValue];
            totalPoint = point + totalPoint;
        }
        if (self.Invoice) {
            NSDictionary *dict = [self.Invoice firstObject];
            items = @[
                @{@"leftTitle": @"小計", @"rightValue": [self formatterPrice:[dict objectOrNilForKey:@"TotalAmount"]]},
                @{@"leftTitle": @"獲得天鷹點數", @"rightValue": [NSString stringWithFormat:@"%ld",totalPoint],@"isGreen": @YES},
                @{@"leftTitle": @"總金額", @"rightValue": [self formatterPrice:[dict objectOrNilForKey:@"TotalAmount"]]}
            ];
        }
    }
    
    
    UIView *lastView = nil;
    for (int i = 0; i < items.count; i++) {
        NSDictionary *item = items[i];
        
        // 左侧标签
        UILabel *leftLabel = [[UILabel alloc] init];
        leftLabel.text = item[@"leftTitle"];
        leftLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightMedium];
        leftLabel.textColor = rgba(64, 64, 64, 1);
        [footerView addSubview:leftLabel];
        
        // 右侧标签
        UILabel *rightLabel = [[UILabel alloc] init];
        rightLabel.text = item[@"rightValue"];
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightMedium];
        
        // 设置特殊样式
        if ([item[@"isRed"] boolValue]) {
            rightLabel.textColor = rgba(214, 0, 0, 1);
            leftLabel.textColor = rgba(214, 0, 0, 1);
        } else if ([item[@"isYellow"] boolValue]) {
            rightLabel.textColor = rgba(214, 159, 0, 1);
            leftLabel.textColor =  rgba(214, 159, 0, 1);
        } else if ([item[@"isGreen"] boolValue]) {
            rightLabel.textColor = rgba(0, 122, 96, 1);
            leftLabel.textColor =  rgba(0, 122, 96, 1);
        } else {
            rightLabel.textColor = rgba(64, 64, 64, 1);
            leftLabel.textColor = rgba(64, 64, 64, 1);
        }
        
        [footerView addSubview:rightLabel];
        
        // 布局
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(footerView).offset(ScaleW(16));
            if (i==0) {
                make.top.equalTo(lineView).offset(ScaleW(20));
            } else {
                make.top.equalTo(lastView.mas_bottom).offset(ScaleW(16));
            }
        }];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(footerView).offset(-ScaleW(16));
            make.centerY.equalTo(leftLabel);
            if (i == items.count - 1) {
                make.bottom.equalTo(footerView).offset(-ScaleW(16));
            }
        }];
        lastView = leftLabel;
    }
    footerView.layer.cornerRadius = ScaleW(8);
    footerView.layer.maskedCorners = kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
    footerView.clipsToBounds = YES;
    return footerView;
}

-(NSString *)formatterPrice:(NSString *) price{
    // 格式化价格
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.groupingSeparator = @",";
    formatter.groupingSize = 3;
    NSString *priceString = [price stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSNumber *priceNum = @([priceString doubleValue]);
    NSString *formattedPrice = [NSString stringWithFormat:@"NT $%@", [formatter stringFromNumber:priceNum]];;
    return formattedPrice;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"OrderDetailCell";
    EGOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[EGOrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    if (!self.orderInfo) {
        OrderDetailModel *model = [OrderDetailModel mj_objectWithKeyValues:self.products[indexPath.row]];
        [cell setupWithImage:@"" title:model.ItemName price:[NSString stringWithFormat:@"%ld",model.ItemPrice] andQuantity:[NSString stringWithFormat:@"%ld",model.ItemCount]];
    }else{
        EGOrderProductInfo *productInfo = [EGOrderProductInfo mj_objectWithKeyValues: self.products[indexPath.row]];
        [cell setupWithImage:productInfo.imageUrl title:productInfo.title price:productInfo.price andQuantity:productInfo.quantity];
    }

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

@end
