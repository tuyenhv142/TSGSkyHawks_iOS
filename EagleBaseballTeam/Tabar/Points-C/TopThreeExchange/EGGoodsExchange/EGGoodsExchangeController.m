//
//  ViewController.m
//  music
//
//  Created by Dragon_Zheng on 2/5/25.
//

#import "EGGoodsExchangeController.h"
#import "LXYHyperlinksButton.h"
#import "EGGoodsExchangeViewCell.h"
#import "EGiftDetailController.h"
#import "EGSortView.h"
@interface EGGoodsExchangeController ()<UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) UIView *baseview;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *goodsbackView;
@property (nonatomic, strong) UIButton *point_bt;

@property (nonatomic, strong)UICollectionView *collectionView;
@end

@implementation EGGoodsExchangeController
- (NSString *)xy_noDataViewMessage {
    
        return @"尚無贈品兌換";
    
}

- (UIImage *)xy_noDataViewImage {
    return [UIImage imageNamed:@"nodata"];
}

- (NSMutableArray *)goodsfilterData
{
    if (!_goodsfilterData) {
        _goodsfilterData = [NSMutableArray arrayWithCapacity:0];
    }
    return _goodsfilterData;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self initgirlInfo];
    self.points = [EGLoginUserManager getMemberInfoPoints].Points;
    [self.point_bt setTitle:[NSString stringWithFormat:@"%ld",self.points] forState:UIControlStateNormal];
    [self.collectionView.mj_header beginRefreshing];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = rgba(243, 243, 243, 1);
    self.navigationItem.title = @"贈品兌換";
    
    self.sort_type = 0;
    _is_fav = NO;
    [self setupUI];
    //[self initgirlInfo];
}

-(void)getDataList
{
    //[self.collectionView.mj_header beginRefreshing];
    UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
    NSDictionary *dict_header = @{@"Authorization":tokenString};
    [[WAFNWHTTPSTool sharedManager] getWithURL:[EGServerAPI couponsList_api:model.ID getType:1] parameters:@{} headers:dict_header success:^(NSDictionary * _Nonnull response) {
        self.goodsArray = response[@"data"];
        //[self sortByDate:NO];
        [self sortbytype:self.sort_type];
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        } failure:^(NSError * _Nonnull error) {
            [self.collectionView.mj_header endRefreshing];
        }];
}





- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.backgroundColor = rgba(0, 71, 56, 1);
}

-(void)initgirlInfo
{
    if(self.is_fav)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"goodsfav" ofType:@"plist"];
        self.goodsArray = [NSArray arrayWithContentsOfFile:path];
    }
    else
    {
        [self getDataList];
    }
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
        
        [self.collectionView reloadData];
        } ;
    [picker popPickerView];
    
}

#pragma  mark -----按日期排序-----
-(void)sortByDate:(BOOL)ascending
{
    //NO is 降序排列，日期最新排在最前头
    //YES is 升序排列，日期最新拍在做后头
    [self.goodsfilterData removeAllObjects];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"redeemStartAt" ascending:ascending];
    NSArray *sortedArray = [self.goodsArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    self.goodsfilterData = [NSMutableArray arrayWithArray:sortedArray];
}


#pragma mark ------按点数排序-----
-(void)sortByPoint:(BOOL)ascending
{
    //NO is 降序排列，日期最新排在最前头
    //YES is 升序排列，日期最新拍在做后头
    [self.goodsfilterData removeAllObjects];
    NSArray *sortedArray = [self.goodsArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSInteger valueA = [a[@"pointCost"] integerValue];
        NSInteger valueB = [b[@"pointCost"] integerValue];
        if(ascending)
          return valueA > valueB;
        else
            return valueA < valueB;
    }];
    self.goodsfilterData = [NSMutableArray arrayWithArray:sortedArray];
}


-(void)setupUI
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
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
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
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;//竖直滚动
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor= rgba(245, 245, 245, 1);;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator =NO;
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([UIDevice de_navigationFullHeight] + ScaleW(47) + ScaleW(65));
        make.left.mas_equalTo(ScaleW(10));
        make.right.mas_equalTo(-ScaleW(10));
        make.bottom.mas_equalTo(0);
    }];
    [collectionView registerClass:[EGGoodsExchangeViewCell class] forCellWithReuseIdentifier:@"EGGoodsExchangeViewCell"];
    
    self.collectionView = collectionView;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getDataList];
    }];
}

#pragma  mark collection View for 队员 delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.goodsfilterData.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EGGoodsExchangeViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EGGoodsExchangeViewCell" forIndexPath:indexPath];
        
    self.playerldic = [self.goodsfilterData objectAtIndex:indexPath.item];
    
    //if([[self.playerldic objectForKey:@"couponType"] intValue]==1)//过滤赠品卷
    {
        cell.titleLB.text = [self.playerldic objectForKey:@"couponName"];
        cell.titleLA.text = [[self.playerldic objectForKey:@"pointCost"] stringValue];
        //[cell.imageView sd_setImageWithURL:[NSURL URLWithString:[self.playerldic objectForKey:@"coverImage"]]];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[self.playerldic objectForKey:@"coverImage"]]
                              placeholderImage:[UIImage imageNamed:@"playerbackimage"]
                                       options:0
                                      progress:nil
                                     completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (!image) {
                    //NSLog(@"加载图片失败");
                }
            }];
        
        
        NSString* criter = [self.playerldic objectForKey:@"eligibilityCriteria"];
        if([criter isKindOfClass:[NSString class]])
        {
            if([criter isEqualToString:@"memberCard"])
            {
                cell.yellowcornerimageView.hidden = NO;
                cell.usertypeLB.hidden = NO;
                cell.yellowcornerimageView.image = [UIImage imageNamed:@"Vector 1"];
                NSArray* criter_mem = [self.playerldic objectForKey:@"eligibleMembers"];
                if([criter_mem isKindOfClass:[NSArray class]])
                {
                    if(criter_mem.count>1)
                        cell.usertypeLB.text = @"鷹國會員";
                    
                    if(criter_mem.count==1){
                        NSString* string = [criter_mem objectAtIndex:0];
                        if([string isEqualToString:@"A001"])
                            cell.usertypeLB.text = @"鷹國皇家";
                        if([string isEqualToString:@"A002"])
                            cell.usertypeLB.text = @"鷹國尊爵";
                        if([string isEqualToString:@"A003"])
                            cell.usertypeLB.text = @"Takao 親子卡";
                        if([string isEqualToString:@"A004"])
                            cell.usertypeLB.text = @"鷹國人";
                    }
                }
                else
                {
                    cell.yellowcornerimageView.hidden = YES;
                    cell.usertypeLB.hidden = YES;
                }
                
            }
            else
            {
                cell.yellowcornerimageView.hidden = YES;
                cell.usertypeLB.hidden = YES;
            }
        }
        else
        {
            cell.yellowcornerimageView.hidden = YES;
            cell.usertypeLB.hidden = YES;
        }
    }
    return cell;
}
//选中 collectionView
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EGiftDetailController *giftVc = [EGiftDetailController new];
    giftVc.goods_id = @"";
    giftVc.points = self.points;
    giftVc.from_type = 0;
    if(indexPath.item<self.goodsfilterData.count){
        giftVc.info = [self.goodsfilterData objectAtIndex:indexPath.item];
    }
    [self.navigationController pushViewController:giftVc animated:true];
}
// 设置cell大小 itemSize：可以给每一个cell指定不同的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat w = (Device_Width-ScaleW(30))/2;
    CGFloat height = ScaleH(268);//width * 1.25;
    return CGSizeMake(w, height);
}
//// 设置UIcollectionView整体的内边距（这样item不贴边显示）
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // 上 左 下 右
    return UIEdgeInsetsMake(ScaleW(20),0,0,0);
}
// 设置minimumLineSpacing：cell上下之间最小的距离(一行左右间距)
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return ScaleW(0);
}
// 设置minimumInteritemSpacing：cell左右之间最小的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return ScaleW(0);
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
    [self.goodsfilterData removeAllObjects];
    if(![searchText isEqualToString:@""]){
        //谓词搜索
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@", searchText];
        NSMutableArray *names = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in self.goodsArray)
        {
            [names addObject:[dic objectForKey:@"couponName"]];
        }
        //筛选出来的名称
        NSArray *filterNames =  [[NSArray alloc] initWithArray:[names filteredArrayUsingPredicate:predicate]];
        for (NSDictionary *dic in self.goodsArray)
        {
            for (NSString *name in filterNames)
            {
                if ([name isEqualToString:[dic objectForKey:@"couponName"]])
                {
                    [self.goodsfilterData addObject:dic];
                }
            }
        }
        
    }
    else
        self.goodsfilterData = [NSMutableArray arrayWithArray:self.goodsArray];
    [self.collectionView reloadData];
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
}
@end
