//
//  EGExchangeRecordViewController.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/4/27.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGExchangeRecordViewController.h"

#import "EGExchangeRecordTBViewCell.h"
#import "EGBarQRCodeView.h"
#import "EGActivityDetailViewController.h"
#import "EGiftDetailController.h"

@interface EGExchangeRecordViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) EGTopButtonsView *topBtnView;
@property (nonatomic, strong) UIScrollView *mainscrollView;
@property (nonatomic, strong) UITableView *leftTableView;//未使用
@property (nonatomic, strong) UITableView *rightTableView;//已使用

@property (nonatomic, assign) BOOL isUserScrolling;
@property (nonatomic, assign) BOOL isRightView;

@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) UILabel *warning_title;

@end

@implementation EGExchangeRecordViewController
- (NSString *)xy_noDataViewMessage {
    
    if(self.isRightView)
        return @"尚無已使用兌換券";
    else
        return @"尚無未使用兌換券";
    
}

- (UIImage *)xy_noDataViewImage {
    return [UIImage imageNamed:@"nodata"];
}

- (UIScrollView *)mainscrollView
{
    if (!_mainscrollView) {
        CGFloat scrtop = [UIDevice de_navigationFullHeight] + ScaleW(52);
        CGRect rectScro = CGRectMake(0, scrtop, Device_Width, Device_Height-scrtop);
        _mainscrollView = [[UIScrollView alloc] init];
        _mainscrollView.frame = rectScro;
        _mainscrollView.backgroundColor = [UIColor colorWithRed:0.962 green:0.962 blue:0.962 alpha:1.0];
        _mainscrollView.delegate = self;
        _mainscrollView.pagingEnabled = YES;
        _mainscrollView.scrollEnabled = YES;
        _mainscrollView.bounces = YES;
        _mainscrollView.showsHorizontalScrollIndicator = false;
        [self.view addSubview:_mainscrollView];
    }
    return _mainscrollView;
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
            [self getDataListbyStauts:0];
            //[self.leftTableView reloadData];
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
            [self getDataListbyStauts:2];
            //[self.rightTableView reloadData];
        }];
    }
    return _rightTableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //status = 0. 未使用 1. 已鎖定 2. 已使用 3.已過期
    if(!self.isRightView)
       //[self getDataListbyStauts:0];
        [self.leftTableView.mj_header beginRefreshing];
    else
        //[self getDataListbyStauts:2];
        [self.rightTableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"兌換歷程";
    self.view.backgroundColor = rgba(243, 243, 243, 1);
    
    [self createTopButton];
    
    
    
}


-(void)getDataListbyStauts:(NSInteger)status
{
//    if(status==0)
//    {
//        [self.leftTableView.mj_header beginRefreshing];
//    }
//    else
//    {
//        [self.rightTableView.mj_header beginRefreshing];
//    }
    self.warning_title.hidden = YES;
    UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
    NSDictionary *dict_header = @{@"Authorization":tokenString};
    
    //0. 未使用 1. 已鎖定 2. 已使用 3.已過期
    
    [[WAFNWHTTPSTool sharedManager] getWithURL:[EGServerAPI couponsList_api:model.ID getStuatus:status] parameters:@{} headers:dict_header success:^(NSDictionary * _Nonnull response) {
        self.array = response[@"data"];
        if(status==0)
            [self.leftTableView reloadData];
        else{
            [self.rightTableView reloadData];
            
            
            if(self.array.count==0)
                self.warning_title.hidden = YES;
            else
                self.warning_title.hidden = NO;
        }
        
        if(status==0)
        {
            [self.leftTableView.mj_header endRefreshing];
        }
        else
        {
            [self.rightTableView.mj_header endRefreshing];
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        if(status==0)
        {
            [self.leftTableView.mj_header endRefreshing];
        }
        else
        {
            [self.rightTableView.mj_header endRefreshing];
        }
        }];
    
}

-(void)createTopButton
{
    WS(weakSelf);
    CGRect rectTop = CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, ScaleW(52));
    self.topBtnView = [[EGTopButtonsView alloc] initWithFrame:rectTop];
    [self.topBtnView setupUIForArray:@[@"未使用",@"已使用"]];
    self.topBtnView.clickBtnBlock = ^(NSInteger index) {
        weakSelf.isRightView = index;
        if (weakSelf.isRightView) {
            weakSelf.warning_title.hidden = NO;
            //[weakSelf getDataListbyStauts:2];
            [weakSelf.rightTableView.mj_header beginRefreshing];
            //[weakSelf.rightTableView reloadData];
        }else{
            weakSelf.warning_title.hidden = YES;
            //[weakSelf getDataListbyStauts:0];
            [weakSelf.leftTableView.mj_header beginRefreshing];
            //[weakSelf.leftTableView reloadData];
        }
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf.mainscrollView setContentOffset:CGPointMake(index * Device_Width, 0)];
        }];
    };
    [self.view addSubview:self.topBtnView];
    
    CGFloat scrtop = [UIDevice de_navigationFullHeight] + ScaleW(52);
    self.mainscrollView.contentSize = CGSizeMake(Device_Width * 2, 0);
    CGRect contentRect = CGRectMake(0, 0, Device_Width * 2, Device_Height - scrtop);
    UIView *contentview = [UIView new];
    contentview.backgroundColor = UIColor.clearColor;
    contentview.frame = contentRect;
    [self.mainscrollView addSubview:contentview];
    
    [contentview addSubview:self.leftTableView];
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(Device_Width);
        make.bottom.mas_equalTo(-ScaleW(50));
    }];
    [contentview addSubview:self.rightTableView];
    [self.rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(Device_Width);
        make.width.mas_equalTo(Device_Width);
        make.bottom.mas_equalTo(-ScaleW(50));
    }];
    
    UILabel *titleLb = [UILabel new];
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.text = @"僅顯示近 1 年紀錄";
    titleLb.textColor = ColorRGB(0x737373);
    titleLb.font = [UIFont boldSystemFontOfSize:FontSize(12)];
    [self.view addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-ScaleW(20));
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(Device_Width);
        make.height.mas_equalTo(24);
    }];
    self.warning_title = titleLb;
    self.warning_title.hidden = YES;
}

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
        self.warning_title.hidden = NO;
        //[self getDataListbyStauts:2];
        [self.rightTableView.mj_header beginRefreshing];
        //[self.rightTableView reloadData];
    }else{
        self.warning_title.hidden = YES;
        [self.leftTableView.mj_header beginRefreshing];
        //[self getDataListbyStauts:0];
        //[self.leftTableView reloadData];
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
    
    NSInteger tableRow = self.array.count;
    return tableRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.isRightView) {
        EGExchangeRecordTBViewCell *cell = [EGExchangeRecordTBViewCell cellWithUITableView:tableView];
        if(indexPath.row<self.array.count){
            cell.info = [self.array objectAtIndex:indexPath.row][@"coupon"];
            cell.qrcode_id =[self.array objectAtIndex:indexPath.row][@"couponCode"];
            [cell updateUI];
        }
        cell.openCodeBlock = ^(NSString * _Nonnull codeStr, NSString * _Nonnull goodsid) {
            EGBarQRCodeView *codeView = [EGBarQRCodeView new];
            codeView.closeBlock = ^{
                BKPopReminderView *popView = [[BKPopReminderView alloc] initWithTitle:@"您的贈品已完成兌換，請留意兌換狀況。" buttons:@[@"確定"]];
                        [popView showPopView];
                        popView.closeBlock = ^(NSInteger btnTag) {
                            NSLog(@"点击確定");
                            [self.navigationController popViewControllerAnimated:YES];
                    };
                };
            [codeView setgoodsID:goodsid];
            [codeView showBarQRCodeView:codeStr];
            
        };
        return cell;
    }else{
        UsedAlreadyTBViewCell *cell = [UsedAlreadyTBViewCell cellWithUITableView:tableView];
        if(indexPath.row<self.array.count){
            cell.info = [self.array objectAtIndex:indexPath.row][@"coupon"];
            [cell updateUI];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isRightView) {
        return ScaleW(144);
    }else{
        return ScaleW(198);
    }
//    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *infoA = [self.array objectAtIndex:indexPath.row][@"coupon"];
    NSInteger type = [[infoA objectForKey:@"couponType"] intValue]; //赠品，活动 type
    NSInteger status = [[self.array objectAtIndex:indexPath.row][@"usageStatus"] intValue];//已使用，未使用
    if (self.isRightView) {
        switch (type) {
            case 1://赠品界面
            {
                EGiftDetailController *detailVC = [[EGiftDetailController alloc] init];
                detailVC.goods_id = @"";
                detailVC.qrcode_string = [self.array objectAtIndex:indexPath.row][@"couponCode"];
                detailVC.status = status;
                detailVC.from_type = 1;
                detailVC.info = infoA;
                [self.navigationController pushViewController:detailVC animated:YES];
            }
                break;
            case 2://活动界面
            {
                EGActivityDetailViewController *detailVC = [[EGActivityDetailViewController alloc] init];
                detailVC.activty_id = @"";
                detailVC.qrcode_string = [self.array objectAtIndex:indexPath.row][@"couponCode"];
                detailVC.status = status;
                detailVC.from_type = 1;
                detailVC.info = infoA;
                //[detailVC updateUI];
                [self.navigationController pushViewController:detailVC animated:YES];
            }
                break;
          
        }
        
        
    }else{
        switch (type) {
            case 1://赠品界面
            {
                EGiftDetailController *detailVC = [[EGiftDetailController alloc] init];
                detailVC.goods_id = @"";
                detailVC.qrcode_string = [self.array objectAtIndex:indexPath.row][@"couponCode"];
                detailVC.status = status;
                detailVC.from_type = 1;
                detailVC.info = infoA;
                [self.navigationController pushViewController:detailVC animated:YES];
            }
                break;
            case 2://活动界面
            {
                EGActivityDetailViewController *detailVC = [[EGActivityDetailViewController alloc] init];
                detailVC.activty_id = @"";
                detailVC.qrcode_string = [self.array objectAtIndex:indexPath.row][@"couponCode"];
                detailVC.status = status;
                detailVC.from_type = 1;
                detailVC.info = infoA;
                //[detailVC updateUI];
                [self.navigationController pushViewController:detailVC animated:YES];
            }
                break;
          
        }
    }
}

@end
