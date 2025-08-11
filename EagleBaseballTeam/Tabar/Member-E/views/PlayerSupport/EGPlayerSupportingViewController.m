//
//  ViewController.m
//  music
//
//  Created by Dragon_Zheng on 2/5/25.
//

#import "EGPlayerSupportingViewController.h"
#import "LXYHyperlinksButton.h"
#import "EGPlayerMemberCollectionViewCell.h"
#import "EGPlayerDetailViewController.h"
@interface EGPlayerSupportingViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) UIView *baseview;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *playerbackView;
@property (nonatomic, strong) UIView *bushoubackView;
@property (nonatomic, strong) UIView *neiyeshoubackView;
@property (nonatomic, strong) UIView *waiyeshoubackView;
@property (nonatomic, strong) UIView *coachbackView;
@property (nonatomic, strong) UIScrollView *mainscrollView;
@property (nonatomic, strong) UIView *bustatuslable;
@property (nonatomic, assign) NSInteger currentIndex;


@property (nonatomic, strong) LXYHyperlinksButton *toushou_bt;
@property (nonatomic, strong) LXYHyperlinksButton *bushou_bt;
@property (nonatomic, strong) LXYHyperlinksButton *neiyeshou_bt;
@property (nonatomic, strong) LXYHyperlinksButton *waiyeshou_bt;
@property (nonatomic, strong) LXYHyperlinksButton *jiaoliantuan_bt;

@property (nonatomic,retain)NSMutableArray *coachArray;

@property (nonatomic, strong)UICollectionView *playerView;
@property (nonatomic, strong) UICollectionView *bushouView;
@property (nonatomic, strong) UICollectionView *neiyeshouView;
@property (nonatomic, strong) UICollectionView *waiyeshouView;
@property (nonatomic, strong) UICollectionView *coachView;

@property (nonatomic, assign) BOOL isUserScrolling;  // 添加标记区分用户滑动和按钮点击
@end

@implementation EGPlayerSupportingViewController
- (NSMutableArray *)coachArray{
    if (!_coachArray) {
        _coachArray = [NSMutableArray array];
    }
    return _coachArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"球隊成員";
    
    [self setupUI];
//    self.playerType = 0;
//    [self initgirlInfo]; //ẩn dữ liệu đội
    
    // 让 ScrollView 的滑动手势在返回手势失败后触发 右滑可返回
    UIGestureRecognizer *popGesture = self.navigationController.interactivePopGestureRecognizer;
    [self.mainscrollView.panGestureRecognizer requireGestureRecognizerToFail:popGesture];
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.backgroundColor = rgba(16, 38, 73, 1);
}

-(void)initgirlInfo
{
    //DefendStation
    //投手(1)  捕手(2) 內野(3-6)    外野(7-9)
//    [self getMemberlist];
    
//    [self.playerView.mj_header beginRefreshing];
//    [self.playerView reloadData];
    // ẩn data 教練團
    
    
//    [self getcoachlist];
    
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
    
    
    NSInteger width = Device_Width/5;
    LXYHyperlinksButton *bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(0, 0, 100, 36)];
//    bt.backgroundColor = UIColor.redColor;
    bt.tag = 70001;
    bt.titleLabel.font = [UIFont systemFontOfSize:FontSize(15)];
    [bt setTitle:@"投手" forState:UIControlStateNormal];
    bt.titleLabel.textAlignment = NSTextAlignmentCenter;
    [bt setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateSelected];
    [bt setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
    [bt setSelected:YES];
    bt.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];

    [bt addTarget:self action:@selector(buttonclick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.topView addSubview:bt];
    [bt setColor:/*rgba(0, 122, 96, 1)*/UIColor.clearColor];
    self.toushou_bt = bt;
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ScaleW(0));
            make.top.mas_equalTo(ScaleW(5));
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(ScaleW(50));
        }];
    
    bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(0, 0, 100, 36)];
//    bt.backgroundColor = UIColor.yellowColor;
    bt.tag = 70002;
    bt.titleLabel.font = [UIFont systemFontOfSize:FontSize(15)];
    [bt setTitle:@"捕手" forState:UIControlStateNormal];
    bt.titleLabel.textAlignment = NSTextAlignmentCenter;
    [bt addTarget:self action:@selector(buttonclick:) forControlEvents:(UIControlEventTouchUpInside)];
    [bt setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateSelected];
    [bt setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
    [bt setSelected:NO];
    bt.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    [self.topView addSubview:bt];
    [bt setColor:/*rgba(0, 122, 96, 1)*/UIColor.clearColor];
    self.bushou_bt = bt;
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.toushou_bt.mas_right).offset(0);
            make.top.mas_equalTo(ScaleW(5));
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(ScaleW(50));
        }];
    
    bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(0, 0, 100, 36)];
//    bt.backgroundColor = UIColor.purpleColor;
    bt.tag = 70003;
    bt.titleLabel.font = [UIFont systemFontOfSize:FontSize(15)];
    [bt setTitle:@"內野手" forState:UIControlStateNormal];
    bt.titleLabel.textAlignment = NSTextAlignmentCenter;
    [bt addTarget:self action:@selector(buttonclick:) forControlEvents:(UIControlEventTouchUpInside)];
    [bt setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateSelected];
    [bt setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
    [bt setSelected:NO];
    bt.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    [self.topView addSubview:bt];
    [bt setColor:/*rgba(0, 122, 96, 1)*/UIColor.clearColor];
    self.neiyeshou_bt = bt;
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bushou_bt.mas_right).offset(0);
            make.top.mas_equalTo(ScaleW(5));
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(ScaleW(50));
        }];
    
    bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(0, 0, 100, 36)];
//    bt.backgroundColor = UIColor.greenColor;
    bt.tag = 70004;
    bt.titleLabel.font = [UIFont systemFontOfSize:FontSize(15)];
    [bt setTitle:@"外野手" forState:UIControlStateNormal];
    bt.titleLabel.textAlignment = NSTextAlignmentCenter;
    [bt addTarget:self action:@selector(buttonclick:) forControlEvents:(UIControlEventTouchUpInside)];
    [bt setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateSelected];
    [bt setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
    [bt setSelected:NO];
    bt.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    [self.topView addSubview:bt];
    [bt setColor:/*rgba(0, 122, 96, 1)*/UIColor.clearColor];
    self.waiyeshou_bt = bt;
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.neiyeshou_bt.mas_right).offset(0);
            make.top.mas_equalTo(ScaleW(5));
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(ScaleW(50));
        }];
    
    bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(0, 0, 100, 36)];
//    bt.backgroundColor = UIColor.systemPinkColor;
    bt.tag = 70005;
    bt.titleLabel.font = [UIFont systemFontOfSize:FontSize(15)];
    [bt setTitle:@"教練團" forState:UIControlStateNormal];
    bt.titleLabel.textAlignment = NSTextAlignmentCenter;
    [bt addTarget:self action:@selector(buttonclick:) forControlEvents:(UIControlEventTouchUpInside)];
    [bt setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateSelected];
    [bt setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
    [bt setSelected:NO];
    bt.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    [self.topView addSubview:bt];
    [bt setColor:/*rgba(0, 122, 96, 1)*/UIColor.clearColor];
    self.jiaoliantuan_bt = bt;
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.waiyeshou_bt.mas_right).offset(0);
            make.top.mas_equalTo(ScaleW(5));
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(ScaleW(50));
        }];
    
    [self.bushou_bt setColor:[UIColor clearColor]]; 
    [self.neiyeshou_bt setColor:[UIColor clearColor]];
    [self.waiyeshou_bt setColor:[UIColor clearColor]];
    [self.jiaoliantuan_bt setColor:[UIColor clearColor]];
    
    

    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bushou_bt).offset(0);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(1.5);
    }];
    
    // 滑块指示器
    self.bustatuslable = [[UIView alloc] init];
        self.bustatuslable.backgroundColor = rgba(0, 78, 162, 1); //rgba(0, 122, 96, 1)
    [self.topView addSubview:self.bustatuslable];
        
    [self.bustatuslable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lineView);
            make.width.mas_equalTo(width);
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
    self.mainscrollView.contentSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width * 5, 0);
    self.mainscrollView.bounces = YES;
    
    
    
    //投手 页面
    self.playerbackView = [[UIView alloc] initWithFrame:CGRectMake(0*Device_Width, 0, Device_Width, Device_Height-[UIDevice de_navigationFullHeight]-self.topView.frame.size.height)];
    self.playerbackView.backgroundColor= rgba(245, 245, 245, 1);
    [self.mainscrollView addSubview:self.playerbackView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;//竖直滚动
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor= rgba(245, 245, 245, 1);
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.playerbackView addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(0));
        make.left.mas_equalTo(ScaleW(20));
        make.right.mas_equalTo(-ScaleW(20));
        make.bottom.mas_equalTo(0);
    }];
    [collectionView registerClass:[EGPlayerMemberCollectionViewCell class] forCellWithReuseIdentifier:@"EGPlayerMemberCollectionViewCell"];
    
    self.playerView = collectionView;
    self.playerView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if(self.playerType==4)
            [self getcoachlist];
        else
            [self getMemberlist];
    }];
    
    //捕手 页面
    self.bushoubackView = [[UIView alloc] initWithFrame:CGRectMake(1*Device_Width, 0, Device_Width, Device_Height-[UIDevice de_navigationFullHeight]-self.topView.frame.size.height)];
    self.bushoubackView.backgroundColor= rgba(245, 245, 245, 1);
    [self.mainscrollView addSubview:self.bushoubackView];
    
    layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;//竖直滚动
    collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor= rgba(245, 245, 245, 1);
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.bushoubackView addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(0));
        make.left.mas_equalTo(ScaleW(20));
        make.right.mas_equalTo(-ScaleW(20));
        make.bottom.mas_equalTo(0);
    }];
    [collectionView registerClass:[EGPlayerMemberCollectionViewCell class] forCellWithReuseIdentifier:@"EGPlayerMemberCollectionViewCell"];
    
    self.bushouView = collectionView;
    self.bushouView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if(self.playerType==4)
            [self getcoachlist];
        else
            [self getMemberlist];
    }];
    
    //内野手 页面
    self.neiyeshoubackView = [[UIView alloc] initWithFrame:CGRectMake(2*Device_Width, 0, Device_Width, Device_Height-[UIDevice de_navigationFullHeight]-self.topView.frame.size.height)];
    self.neiyeshoubackView.backgroundColor= rgba(245, 245, 245, 1);
    [self.mainscrollView addSubview:self.neiyeshoubackView];
    
    layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;//竖直滚动
    collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor= rgba(245, 245, 245, 1);
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.neiyeshoubackView addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(0));
        make.left.mas_equalTo(ScaleW(20));
        make.right.mas_equalTo(-ScaleW(20));
        make.bottom.mas_equalTo(0);
    }];
    [collectionView registerClass:[EGPlayerMemberCollectionViewCell class] forCellWithReuseIdentifier:@"EGPlayerMemberCollectionViewCell"];
    
    self.neiyeshouView = collectionView;
    self.neiyeshouView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if(self.playerType==4)
            [self getcoachlist];
        else
            [self getMemberlist];
    }];
 
    
    //外野手 页面
    self.waiyeshoubackView = [[UIView alloc] initWithFrame:CGRectMake(3*Device_Width, 0, Device_Width, Device_Height-[UIDevice de_navigationFullHeight]-self.topView.frame.size.height)];
    self.waiyeshoubackView.backgroundColor= rgba(245, 245, 245, 1);
    [self.mainscrollView addSubview:self.waiyeshoubackView];
    
    layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;//竖直滚动
    collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor= rgba(245, 245, 245, 1);
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.waiyeshoubackView addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(0));
        make.left.mas_equalTo(ScaleW(20));
        make.right.mas_equalTo(-ScaleW(20));
        make.bottom.mas_equalTo(0);
    }];
    [collectionView registerClass:[EGPlayerMemberCollectionViewCell class] forCellWithReuseIdentifier:@"EGPlayerMemberCollectionViewCell"];
    
    self.waiyeshouView = collectionView;
    self.waiyeshouView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if(self.playerType==4)
            [self getcoachlist];
        else
            [self getMemberlist];
    }];
    
    //外野手 页面
    self.coachbackView = [[UIView alloc] initWithFrame:CGRectMake(4*Device_Width, 0, Device_Width, Device_Height-[UIDevice de_navigationFullHeight]-self.topView.frame.size.height)];
    self.coachbackView.backgroundColor= rgba(245, 245, 245, 1);
    [self.mainscrollView addSubview:self.coachbackView];
    
    layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;//竖直滚动
    collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor= rgba(245, 245, 245, 1);
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.coachbackView addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(0));
        make.left.mas_equalTo(ScaleW(20));
        make.right.mas_equalTo(-ScaleW(20));
        make.bottom.mas_equalTo(0);
    }];
    [collectionView registerClass:[EGPlayerMemberCollectionViewCell class] forCellWithReuseIdentifier:@"EGPlayerMemberCollectionViewCell"];
    
    self.coachView = collectionView;
    self.coachView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if(self.playerType==4)
            [self getcoachlist];
        else
            [self getMemberlist];
    }];
    
    
    
}

- (void)updateSelectedButton:(NSInteger)index {
    self.currentIndex = index;
   
    NSInteger with = Device_Width/5;
    [UIView animateWithDuration:0.3 animations:^{
        self.bustatuslable.transform = CGAffineTransformMakeTranslation(index *with , 0);
    }];
    
   
}

-(void)setscrollerView:(NSInteger)bt_index
{
    [self.toushou_bt setColor:[UIColor clearColor]];
    [self.bushou_bt setColor:[UIColor clearColor]];
    [self.neiyeshou_bt setColor:[UIColor clearColor]];
    [self.waiyeshou_bt setColor:[UIColor clearColor]];
    [self.jiaoliantuan_bt setColor:[UIColor clearColor]];
    
    // 重置所有按钮状态
    [self.toushou_bt setSelected:NO];
    [self.bushou_bt setSelected:NO];
    [self.neiyeshou_bt setSelected:NO];
    [self.waiyeshou_bt setSelected:NO];
    [self.jiaoliantuan_bt setSelected:NO];
    
    
    self.playerbackView.hidden = NO;
    self.bushoubackView.hidden = NO;
    self.neiyeshoubackView.hidden = NO;
    self.waiyeshoubackView.hidden = NO;
    self.coachbackView.hidden = NO;
    
    
    switch (bt_index) {
        case 70001:
        {
            self.playerbackView.hidden = NO;
            [self.toushou_bt setSelected:YES];
            self.playerType = 0;
            [self gettoushou];
            [self.toushou_bt setColor:/*rgba(0, 122, 96, 1)*/UIColor.clearColor];
            [self.playerView reloadData];
        }
            break;
        case 70002:
        {
            self.bushoubackView.hidden = NO;
            [self.bushou_bt setSelected:YES];
            self.playerType = 1;
            [self getbushou];
            [self.bushou_bt setColor:/*rgba(0, 122, 96, 1)*/UIColor.clearColor];
            [self.bushouView reloadData];
        }
            break;
        case 70003:
        {
            self.neiyeshoubackView.hidden = NO;
            [self.neiyeshou_bt setSelected:YES];
            self.playerType = 2;
            [self getneiyeshou];
            [self.neiyeshou_bt setColor:/*rgba(0, 122, 96, 1)*/UIColor.clearColor];
            [self.neiyeshouView reloadData];
        }
            break;
        case 70004:
        {
            self.waiyeshoubackView.hidden = NO;
            [self.waiyeshou_bt setSelected:YES];
            self.playerType = 3;
            [self getwaiyeshou];
            [self.waiyeshou_bt setColor:/*rgba(0, 122, 96, 1)*/UIColor.clearColor];
            [self.waiyeshouView reloadData];
        }
            break;
        case 70005:
        {
            self.coachbackView.hidden = NO;
            [self.jiaoliantuan_bt setSelected:YES];
            self.playerType = 4;
            if (self.coachArray.count>0) {
                [self.coachView reloadData];
            }else{
                [self.coachView.mj_header beginRefreshing];
                [self getcoachlist];
            }
            [self.jiaoliantuan_bt setColor:/*rgba(0, 122, 96, 1)*/UIColor.clearColor];
            
            //[self.coachView reloadData];
        }
            break;
    }
    
//    [self.playerView reloadData];
}



-(void)buttonclick:(UIButton*)bt
{
    self.isUserScrolling = NO;  // 标记为按钮点击
    [self.toushou_bt setColor:[UIColor clearColor]];
    [self.bushou_bt setColor:[UIColor clearColor]];
    [self.neiyeshou_bt setColor:[UIColor clearColor]];
    [self.waiyeshou_bt setColor:[UIColor clearColor]];
    [self.jiaoliantuan_bt setColor:[UIColor clearColor]];
    
    // 重置所有按钮状态
    [self.toushou_bt setSelected:NO];
    [self.bushou_bt setSelected:NO];
    [self.neiyeshou_bt setSelected:NO];
    [self.waiyeshou_bt setSelected:NO];
    [self.jiaoliantuan_bt setSelected:NO];
    
    
//    self.playerbackView.hidden = YES;
//    self.bushoubackView.hidden = YES;
//    self.neiyeshoubackView.hidden = YES;
//    self.waiyeshoubackView.hidden = YES;
//    self.coachbackView.hidden = YES;
    
    
    switch (bt.tag) {
        case 70001:
        {
            self.playerbackView.hidden = NO;
            [self.toushou_bt setSelected:YES];
            self.playerType = 0;
            [self gettoushou];
            [self.toushou_bt setColor:/*rgba(0, 122, 96, 1)*/UIColor.clearColor];
            [self.playerView reloadData];
        }
            break;
        case 70002:
        {
            
            self.bushoubackView.hidden = NO;
            [self.bushou_bt setSelected:YES];
            self.playerType = 1;
            [self getbushou];
            [self.bushou_bt setColor:/*rgba(0, 122, 96, 1)*/UIColor.clearColor];
            [self.bushouView reloadData];
        }
            break;
        case 70003:
        {
            self.neiyeshoubackView.hidden = NO;
            [self.neiyeshou_bt setSelected:YES];
            self.playerType = 2;
            [self getneiyeshou];
            [self.neiyeshou_bt setColor:/*rgba(0, 122, 96, 1)*/UIColor.clearColor];
            [self.neiyeshouView reloadData];
        }
            break;
        case 70004:
        {
            self.waiyeshoubackView.hidden = NO;
            [self.waiyeshou_bt setSelected:YES];
            self.playerType = 3;
            [self getwaiyeshou];
            [self.waiyeshou_bt setColor:/*rgba(0, 122, 96, 1)*/UIColor.clearColor];
            [self.waiyeshouView reloadData];
        }
            break;
        case 70005:
        {
            self.coachbackView.hidden = NO;
            [self.jiaoliantuan_bt setSelected:YES];
            self.playerType = 4;
            if (self.coachArray.count>0) {
                [self.coachView reloadData];
            }else{
                [self.coachView.mj_header beginRefreshing];
                [self getcoachlist];
                //[self.coachView reloadData];
            }
            [self.jiaoliantuan_bt setColor:/*rgba(0, 122, 96, 1)*/UIColor.clearColor];
        }
            break;
    }
    
    [self updateSelectedButton:bt.tag-70001];
    [self.mainscrollView setContentOffset:CGPointMake((bt.tag-70001) * Device_Width, 0) animated:YES];

    
//    [self.playerView reloadData];
}


#pragma mark 获取球员list or coach list,  0 is player, 1 is coach
-(NSArray*)inorderArray:(NSInteger)type
{
    NSArray *sortedArray;
    if(type == 0){
        return sortedArray = [self.All_playerArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSInteger valueA = [a[@"UniformNo"] integerValue];
            NSInteger valueB = [b[@"UniformNo"] integerValue];
            return valueA > valueB;
        }];
    }
    else
    {
        return sortedArray = [self.playerArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSInteger valueA = [a[@"UniformNo"] integerValue];
            NSInteger valueB = [b[@"UniformNo"] integerValue];
            return valueA > valueB;
        }];
    }
    
}
-(void)getMemberlist
{
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentDate];
    NSInteger currentMonth = [components year];
    NSString *currentMonthstringValue = [NSString stringWithFormat:@"%ld", (long)currentMonth];
    
    NSString *authString = [NSString stringWithFormat:@"%@:%@", [[EGCredentialManager sharedManager] getUsername], [[EGCredentialManager sharedManager] getPassword]];
    // Base64 编码
    NSData *authData = [authString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64AuthString = [authData base64EncodedStringWithOptions:0];
    // 添加 Basic Auth 请求头
    NSString *authHeader = [NSString stringWithFormat:@"Basic %@", base64AuthString];
 
    NSDictionary *dict_header = @{@"Authorization":authHeader};
    //[MBProgressHUD showMessage:@"數據獲取中...."];
    NSString *url = [EGServerAPI getTeamMembers:currentMonthstringValue];
    [[WAFNWHTTPSTool sharedManager] getWithURL:url parameters:@{} headers:@{} success:^(id  _Nonnull response) {
        
        self.All_playerArray = response[@"ResponseDto"];
        if(self.All_playerArray.count>0)
        {
            
            self.All_playerArray = [self inorderArray:0];
            
            switch (self.playerType) {
                case 0:{
                    [self gettoushou];
                    [self.playerView.mj_header endRefreshing];}
                    break;
                case 1:{
                    [self getbushou];
                    [self.bushouView.mj_header endRefreshing];}
                    break;
                case 2:{
                    [self getneiyeshou];
                    [self.neiyeshouView.mj_header endRefreshing];}
                    break;
                case 3:
                    [self getwaiyeshou];
                    [self.waiyeshouView.mj_header endRefreshing];
                    break;
            }
        }
        else
        {
            [self getMemberlistforPreyear];
        }
//        [self.playerView reloadData];
        
        //[MBProgressHUD hideHUD];
       
        
    } failure:^(NSError * _Nonnull error) {
        switch (self.playerType) {
            case 0:{
                [self.playerView.mj_header endRefreshing];}
                break;
            case 1:{
                [self.bushouView.mj_header endRefreshing];}
                break;
            case 2:{
                [self.neiyeshouView.mj_header endRefreshing];}
                break;
            case 3:
                [self.waiyeshouView.mj_header endRefreshing];
                break;
        }
       // [MBProgressHUD hideHUD];
    }];
    
}

-(void)getcoachlist
{
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentDate];
    NSInteger currentMonth = [components year];
    NSString *currentMonthstringValue = [NSString stringWithFormat:@"%ld", (long)currentMonth];
    
    NSString *authString = [NSString stringWithFormat:@"%@:%@", [[EGCredentialManager sharedManager] getUsername], [[EGCredentialManager sharedManager] getPassword]];
    // Base64 编码
    NSData *authData = [authString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64AuthString = [authData base64EncodedStringWithOptions:0];
    // 添加 Basic Auth 请求头
    NSString *authHeader = [NSString stringWithFormat:@"Basic %@", base64AuthString];
 
    NSDictionary *dict_header = @{@"Authorization":authHeader};
    //[MBProgressHUD showMessage:@"數據獲取中...."];
    NSString *url = [EGServerAPI getCoachMembers:currentMonthstringValue];
    [[WAFNWHTTPSTool sharedManager] getWithURL:url parameters:@{} headers:@{} success:^(id  _Nonnull response) {
        NSArray *array = response[@"ResponseDto"];
        if([array isKindOfClass:[NSArray class]])
        {
            self.coachArray = (NSMutableArray *)[array sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                NSInteger valueA = [a[@"UniformNo"] integerValue];
                NSInteger valueB = [b[@"UniformNo"] integerValue];
                return valueA > valueB;
            }];
            //        self.playerArray = response[@"ResponseDto"];
            //        self.playerArray = [self inorderArray:1];
            
            [self.coachView reloadData];
            [self.coachView.mj_header endRefreshing];
            //[MBProgressHUD hideHUD];
        }
        else
        {
            [self getcoachlistforPreyear];
        }
    } failure:^(NSError * _Nonnull error) {
        //[MBProgressHUD hideHUD];
        [self.coachView.mj_header endRefreshing];
    }];
}

-(void)getcoachlistforPreyear
{
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentDate];
    NSInteger currentMonth = [components year]-1;
    NSString *currentMonthstringValue = [NSString stringWithFormat:@"%ld", (long)currentMonth];
    
    NSString *authString = [NSString stringWithFormat:@"%@:%@", [[EGCredentialManager sharedManager] getUsername], [[EGCredentialManager sharedManager] getPassword]];    // Base64 编码
    NSData *authData = [authString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64AuthString = [authData base64EncodedStringWithOptions:0];
    // 添加 Basic Auth 请求头
    NSString *authHeader = [NSString stringWithFormat:@"Basic %@", base64AuthString];
 
    NSDictionary *dict_header = @{@"Authorization":authHeader};
    //[MBProgressHUD showMessage:@"數據獲取中...."];
    NSString *url = [EGServerAPI getCoachMembers:currentMonthstringValue];
    [[WAFNWHTTPSTool sharedManager] getWithURL:url parameters:@{} headers:@{} success:^(id  _Nonnull response) {
        NSArray *array = response[@"ResponseDto"];
        self.coachArray = (NSMutableArray *)[array sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSInteger valueA = [a[@"UniformNo"] integerValue];
            NSInteger valueB = [b[@"UniformNo"] integerValue];
            return valueA > valueB;
        }];
        //        self.playerArray = response[@"ResponseDto"];
        //        self.playerArray = [self inorderArray:1];
        
        [self.coachView reloadData];
        [self.coachView.mj_header endRefreshing];
        //[MBProgressHUD hideHUD];
    } failure:^(NSError * _Nonnull error) {
        //[MBProgressHUD hideHUD];
        [self.coachView.mj_header endRefreshing];
    }];
}

-(void)getMemberlistforPreyear
{
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentDate];
    NSInteger currentMonth = [components year]-1;
    NSString *currentMonthstringValue = [NSString stringWithFormat:@"%ld", (long)currentMonth];

    NSString *authString = [NSString stringWithFormat:@"%@:%@", [[EGCredentialManager sharedManager] getUsername], [[EGCredentialManager sharedManager] getPassword]];    // Base64 编码
    NSData *authData = [authString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64AuthString = [authData base64EncodedStringWithOptions:0];
    // 添加 Basic Auth 请求头
    NSString *authHeader = [NSString stringWithFormat:@"Basic %@", base64AuthString];
 
    NSDictionary *dict_header = @{@"Authorization":authHeader};
    //[MBProgressHUD showMessage:@"數據獲取中...."];
    NSString *url = [EGServerAPI getTeamMembers:currentMonthstringValue];
    [[WAFNWHTTPSTool sharedManager] getWithURL:url parameters:@{} headers:@{} success:^(id  _Nonnull response) {
        self.All_playerArray = response[@"ResponseDto"];
        self.All_playerArray = [self inorderArray:0];
        
        switch (self.playerType) {
            case 0:{
                [self gettoushou];
                [self.playerView.mj_header endRefreshing];}
                break;
            case 1:{
                [self getbushou];
                [self.bushouView.mj_header endRefreshing];}
                break;
            case 2:{
                [self getneiyeshou];
                [self.neiyeshouView.mj_header endRefreshing];}
                break;
            case 3:
                [self getwaiyeshou];
                [self.waiyeshouView.mj_header endRefreshing];
                break;
        }
//        [self.playerView reloadData];
        
        //[MBProgressHUD hideHUD];
       
        
    } failure:^(NSError * _Nonnull error) {
        switch (self.playerType) {
            case 0:{
                [self.playerView.mj_header endRefreshing];}
                break;
            case 1:{
                [self.bushouView.mj_header endRefreshing];}
                break;
            case 2:{
                [self.neiyeshouView.mj_header endRefreshing];}
                break;
            case 3:
                [self.waiyeshouView.mj_header endRefreshing];
                break;
        }
       // [MBProgressHUD hideHUD];
    }];
    
}



-(void)getMemberDetailInfo:(NSString*)ACNT playerInfo:(NSDictionary*)dic
{
    EGPlayerDetailViewController *vc = [EGPlayerDetailViewController new];
    vc.mem_id = ACNT;
    vc.girlDetailinfo = dic;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 投手 内野 外野 捕手
-(void)gettoushou
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"DefendStation = %@",@"1"];
    self.playerArray = [self.All_playerArray filteredArrayUsingPredicate:predicate];
    [self.playerView reloadData];
    
}

-(void)getbushou
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"DefendStation = %@",@"2"];
    self.playerArray = [self.All_playerArray filteredArrayUsingPredicate:predicate];
    [self.playerView reloadData];
}

-(void)getneiyeshou
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"DefendStation >= %@ && DefendStation <= %@",@"3",@"6"];
    self.playerArray = [self.All_playerArray filteredArrayUsingPredicate:predicate];
    [self.playerView reloadData];
}

-(void)getwaiyeshou
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"DefendStation >= %@ && DefendStation <= %@",@"7",@"9"];
    self.playerArray = [self.All_playerArray filteredArrayUsingPredicate:predicate];
    [self.playerView reloadData];
}



#pragma  mark collection View for 队员 delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   
    if (self.playerType == 4) {
//        return self.coachArray.count;
        return 0; // Ẩn dữ liệu trong tab 教練團

    }else{
        return self.playerArray.count;
    }
}

// 4. 设置 footer 大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(collectionView.frame.size.width, [UIDevice de_safeDistanceBottom]); // 设置高度为50
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EGPlayerMemberCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EGPlayerMemberCollectionViewCell" forIndexPath:indexPath];
        
    if (self.playerType == 4) {
        if(self.coachArray.count>indexPath.item)
        {
            //        if(self.coachArray)
//            self.playerldic = [self.coachArray objectAtIndex:indexPath.item];

            [cell setInfo:[self.coachArray objectAtIndex:indexPath.item]];
            
        }
    }else{
        //if(self.playerArray)
        if(self.playerArray.count>indexPath.item)
        {
//            self.playerldic = [self.playerArray objectAtIndex:indexPath.item];
            [cell setInfo:[self.playerArray objectAtIndex:indexPath.item]];
        }
    }
           
    return cell;
}
//选中 collectionView
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.playerType == 4){
        //教练没有详细信息
//        NSDictionary *dic = [self.coachArray objectAtIndex:indexPath.item];
//        NSString* acnt = [dic objectForKey:@"Acnt"];
//        [self getMemberDetailInfo:acnt];
         return;
    }
    
    NSDictionary *dic = [self.playerArray objectAtIndex:indexPath.item];
    NSString* acnt = [dic objectForKey:@"Acnt"];
    [self getMemberDetailInfo:acnt playerInfo:dic];
}
// 设置cell大小 itemSize：可以给每一个cell指定不同的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat width =ScaleW(159);
    CGFloat height =ScaleW(198)+ScaleW(24)+ScaleW(12)+ScaleW(20);
    return CGSizeMake(width, /*ScaleW(282)*/height);
}
// 设置UIcollectionView整体的内边距（这样item不贴边显示）
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // 上 左 下 右
    return UIEdgeInsetsMake(0,0,0,0);
}
// 设置minimumLineSpacing：cell上下之间最小的距离(一行左右间距)
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
// 设置minimumInteritemSpacing：cell左右之间最小的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


#pragma mark scroller delegate
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if([scrollView isKindOfClass:[UICollectionView class]])
        return;
    
    if (self.isUserScrolling) {  // 只在用户滑动时更新
        NSInteger index = scrollView.contentOffset.x / UIScreen.mainScreen.bounds.size.width;
        
        [self setscrollerView:index + 70001];
        [self updateSelectedButton:index];
    }

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isUserScrolling = YES;  // 标记为用户滑动
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.isUserScrolling) return;  // 非用户滑动时不更新滑块位置

    if([scrollView isKindOfClass:[UICollectionView class]])
        return;
    
    CGFloat pageWidth = scrollView.frame.size.width;
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat progress = offsetX / pageWidth;
    
    // 更新滑块位置
    NSInteger buttonWidth = Device_Width/5;
    self.bustatuslable.transform = CGAffineTransformMakeTranslation(progress * buttonWidth, 0);
}

@end
