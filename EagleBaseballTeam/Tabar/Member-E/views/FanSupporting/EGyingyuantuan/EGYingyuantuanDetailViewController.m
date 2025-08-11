//
//  ViewController.m
//  music
//
//  Created by Dragon_Zheng on 2/5/25.
//

#import "EGYingyuantuanDetailViewController.h"
#import "EGFanMemberClassInfoCell.h"
@interface EGYingyuantuanDetailViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIImageView *girlView;
@property (nonatomic,strong)UIImageView *showgirlView;
@property (nonatomic,strong)UILabel *girlNameTitle;
@property (nonatomic,strong)UILabel *girlNameContent;
@property (nonatomic,strong)UILabel *girlheightTitle;//身高
@property (nonatomic,strong)UILabel *girlheightContent;//身高
@property (nonatomic,strong)UILabel *girlweightTitle;//身高
@property (nonatomic,strong)UILabel *girlweightContent;//身高
@property (nonatomic,strong)UILabel *girlBirthdayTitle;
@property (nonatomic,strong)UILabel *girlBirthdayContent;
@property (nonatomic,strong)UILabel *girlStarTitle;
@property (nonatomic,strong)UILabel *girlStarContent;
@property (nonatomic,strong)UILabel *girlloveTitle;
@property (nonatomic,strong)UILabel *girlloveContent;

@property (nonatomic,strong)UIImageView *line1View;
@property (nonatomic,strong)UIImageView *line2View;
@property (nonatomic,strong)UIImageView *line3View;
@property (nonatomic,strong)UIImageView *line4View;
@property (nonatomic,strong)UIImageView *line5View;
@property (nonatomic,strong)UIImageView *line6View;
@property (nonatomic,strong)UIButton *facebookbt;
@property (nonatomic,strong)UIButton *twtiterbt;

@property (nonatomic,strong)UILabel *Nolable_inImage;
@property (nonatomic,strong)UILabel *Namelable_inImage;
@property (nonatomic,strong)UILabel *SecondNamelable_inImage;


// 滚动 参数
@property (nonatomic, strong) UIScrollView *mainscrollView;
@property (nonatomic, assign) BOOL isUserScrolling;  // 添加标记区分用户滑动和按钮点击
@property (nonatomic, strong) UIView *bustatuslable;
@property (nonatomic, assign) NSInteger currentIndex;


//班表 参数定义
@property (nonatomic, strong) UIView *girlinfo_view;//个人信息页面base view
@property (nonatomic, strong) UIView *girlclassinfo_view;//班表信息页面base view
@property (nonatomic, strong) LXYHyperlinksButton *girlinfo_bt;
@property (nonatomic, strong) LXYHyperlinksButton *girlclassinfo_bt;


@property (nonatomic, strong) UIView *girlclassinfo_Topview;
@property (nonatomic, strong) UIView *girlclassinfo_dateview;
@property (nonatomic,strong)UIButton *girlclassinfo_predate_bt;
@property (nonatomic,strong)UIButton *girlclassinfo_nextdate_bt;
@property (nonatomic,strong)UILabel *girlclassinfo_datelabel;
@property (nonatomic,strong)UITableView *girlclassinfo_tabelView;

@property (nonatomic,strong)NSMutableArray*girlclassinfo_array;

@property (nonatomic,strong)UIImageView *helpimageView;
@property (nonatomic,strong)UILabel *helplabel;

@property (nonatomic,strong)UIImageView *NoClass_imageView;
@property (nonatomic,strong)UILabel *NoClass_label;

@property (nonatomic, assign) NSInteger current_year;
@property (nonatomic, assign) NSInteger current_month;

@property (nonatomic, strong)NSDictionary* wingstarsscheduledic;
@property (nonatomic, strong)NSArray*wingsclassAllArray;
@end

@implementation EGYingyuantuanDetailViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if(_from==0)
    self.currentDate = [NSDate date];
    
    
    [self setupUI];
    [self setInfo:self.girlDetailinfo];
    
    //[self getclassinfo];
    [self.girlclassinfo_tabelView.mj_header beginRefreshing];
    
    self.navigationItem.title = @"鷹援資訊";
}

-(void)setupUI
{
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, Device_Height)];
    bView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:bView];
    
    
    UIImageView *gView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 20)];
    
    gView.image = [UIImage imageNamed:@"Imageback"];
    [self.view addSubview:gView];
    [gView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([UIDevice de_navigationFullHeight]);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(ScaleW(242));
        make.width.mas_equalTo(Device_Width);
    }];
    self.girlView = gView;
    
    //个人图片上面显示4个信息
    gView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 20)];
    gView.contentMode = UIViewContentModeScaleAspectFill;
    [ self.girlView addSubview:gView];
    [gView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(ScaleW(-20));
        make.height.mas_equalTo(ScaleW(242));
        make.width.mas_equalTo(ScaleW(200));
    }];
    self.showgirlView = gView;
    
    
    UILabel *labelinimage = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], 40, 67)];
    labelinimage.textColor = UIColor.whiteColor;
    labelinimage.font = [UIFont boldSystemFontOfSize:FontSize(40)];
    [self.girlView addSubview:labelinimage];
    [labelinimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(91));
        make.left.mas_equalTo(ScaleW(28));
        make.height.mas_equalTo(ScaleW(67));
        make.width.mas_equalTo(ScaleW(60));
    }];
    self.Nolable_inImage = labelinimage;
    
    
    labelinimage = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], 72, 34)];
    labelinimage.textColor = UIColor.whiteColor;
    labelinimage.font = [UIFont systemFontOfSize:FontSize(20)];
    [self.girlView addSubview:labelinimage];
    [labelinimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(158));
        make.left.mas_equalTo(ScaleW(28));
        make.height.mas_equalTo(ScaleW(34));
        make.width.mas_equalTo(ScaleW(85));
    }];
    self.Namelable_inImage = labelinimage;
    
    
    labelinimage = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], 63, 22)];
    labelinimage.textColor = UIColor.whiteColor;
    labelinimage.font = [UIFont systemFontOfSize:FontSize(16)];
    [self.girlView addSubview:labelinimage];
    [labelinimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.Namelable_inImage.mas_bottom);
        make.left.mas_equalTo(ScaleW(28));
        make.height.mas_equalTo(ScaleW(22));
//        make.width.mas_equalTo(ScaleW(63));
    }];
    self.SecondNamelable_inImage = labelinimage;
    
    
    //tab button
    NSInteger bt_width = Device_Width/2;
        LXYHyperlinksButton *class_bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(0, 0, 100, 36)];
        class_bt.tag = 50000;
        [class_bt setTitle:@"基本資料" forState:UIControlStateNormal];
        [class_bt setTitleColor:rgba(212, 212, 212, 1) forState:UIControlStateSelected];
        [class_bt setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateNormal];
        class_bt.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
        [class_bt addTarget:self action:@selector(buttonclick1:) forControlEvents:(UIControlEventTouchUpInside)];

        [self.view addSubview:class_bt];
        [class_bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
        self.girlinfo_bt = class_bt;
        [self.girlinfo_bt setSelected:YES];
        [class_bt mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(ScaleW(0));
            make.top.mas_equalTo(self.girlView.mas_bottom);
                make.width.mas_equalTo(bt_width);
                make.height.mas_equalTo(ScaleW(50));
            }];
        [self.girlinfo_bt setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateSelected];
        [self.girlinfo_bt setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
        [self.girlinfo_bt setColor:[UIColor clearColor]];
        
        
        class_bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(0, 0, 100, 36)];
        class_bt.tag = 50001;
        [class_bt setTitle:@"個人班表" forState:UIControlStateNormal];
        [class_bt setTitleColor:rgba(212, 212, 212, 1) forState:UIControlStateSelected];
        [class_bt setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateNormal];
        class_bt.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
        [class_bt addTarget:self action:@selector(buttonclick1:) forControlEvents:(UIControlEventTouchUpInside)];

        [self.view addSubview:class_bt];
        [class_bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
        self.girlclassinfo_bt = class_bt;
        [self.girlclassinfo_bt setSelected:NO];
        [class_bt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.girlinfo_bt.mas_right).offset(0);
            make.top.mas_equalTo(self.girlView.mas_bottom);
                make.width.mas_equalTo(bt_width);
                make.height.mas_equalTo(ScaleW(50));
            }];
        
        [self.girlclassinfo_bt setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateSelected];
        [self.girlclassinfo_bt setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
        [self.girlclassinfo_bt setColor:[UIColor clearColor]];
        
        
        // 滑块指示器
        
        
        self.bustatuslable = [[UIView alloc] init];
        self.bustatuslable.backgroundColor = rgba(0, 122, 96, 1); //rgba(0, 122, 96, 1)
        [self.view addSubview:self.bustatuslable];
            
        [self.bustatuslable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.girlclassinfo_bt.mas_bottom);
            //make.bottom.equalTo(self.girlView.frame.size.height + );
            make.width.mas_equalTo(bt_width);
            make.height.mas_equalTo(ScaleW(4));
            make.left.mas_equalTo(self.view.mas_left).offset(ScaleW(0));
        }];
        [self updateSelectedButton:0];
        
        
        //add scroller
        // 滚动视图
        self.mainscrollView = [[UIScrollView alloc] init];
        self.mainscrollView.backgroundColor = [UIColor colorWithRed:0.962 green:0.962 blue:0.962 alpha:1.0];
        self.mainscrollView.delegate = self;
        self.mainscrollView.pagingEnabled = YES;
          
        self.mainscrollView.scrollEnabled = YES;
        self.mainscrollView.showsHorizontalScrollIndicator = YES;
        [self.view addSubview:self.mainscrollView];
            [self.mainscrollView mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.top.equalTo(self.topView.mas_bottom);
                make.top.equalTo(self.girlclassinfo_bt.mas_bottom).offset(ScaleW(4));
                
                make.left.right.bottom.equalTo(self.view);
            }];
        self.mainscrollView.contentSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width * 2, 0);
        self.mainscrollView.bounces = YES;
    
    //add 球员详细界面
        self.girlinfo_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, Device_Height-[UIDevice de_navigationFullHeight]-self.girlView.frame.size.height-self.girlclassinfo_bt.frame.size.height)];
        [self.mainscrollView addSubview:self.girlinfo_view];

        [self setgirlInfoUI];/*设置应援团个人信息页面*/
    
    //add 班表详细信息页面
        self.girlclassinfo_view = [[UIView alloc] initWithFrame:CGRectMake(Device_Width, 0, Device_Width, Device_Height-[UIDevice de_navigationFullHeight]-self.girlView.frame.size.height-self.girlclassinfo_bt.frame.size.height)];
        [self.mainscrollView addSubview:self.girlclassinfo_view];
        
        [self setgirlclassUI];///*设置个人班表页面*/
    
    
}

#pragma mark ------------班表界面和数据，改变日期功能
-(void)has_classData:(BOOL)has_class
{
    if(has_class)//班表有数据
    {
        self.girlclassinfo_tabelView.hidden = NO;
        self.helplabel.hidden = NO;
        self.helpimageView.hidden = NO;
        self.NoClass_imageView.hidden = YES;
        self.NoClass_label.hidden = YES;
    }
    else
    {
        self.girlclassinfo_tabelView.hidden = YES;
        self.helplabel.hidden = YES;
        self.helpimageView.hidden = YES;
        self.NoClass_imageView.hidden = NO;
        self.NoClass_label.hidden = NO;
    }
}


-(void)getclassinfo
{
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
        self.wingsclassAllArray = self.wingstarsscheduledic[@"ws_schedule_data"];
        
        //组织日期数据
        //获取当前月份的数据中 应援出席的日期
        self.girlclassinfo_array = [NSMutableArray new];
        NSArray *array = [self getCurrentMothArray:self.wingsclassAllArray];
        if(array.count>0)
        {
            [self has_classData:YES];
            [self mergeArray:array girlNO:[self.girlDetailinfo objectForKey:@"girlnickName"]];
        }
        else
            [self has_classData:NO];
        
        [self.girlclassinfo_tabelView reloadData];
        [self.girlclassinfo_tabelView.mj_header endRefreshing];
        
    }failure:^(NSError * _Nonnull error) {
        [self.girlclassinfo_tabelView.mj_header endRefreshing];
        [self has_classData:NO];
    }];
    
    
    
    
}

-(void)setgirlclassUI
{
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, Device_Height)];
    bView.layer.cornerRadius = ScaleW(10);
    bView.backgroundColor = UIColor.whiteColor;
    [self.girlclassinfo_view addSubview:bView];
    [bView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(10));
        make.centerX.mas_equalTo(self.girlclassinfo_view.mas_centerX);
        make.height.mas_equalTo(ScaleW(65));
        make.width.mas_equalTo(ScaleW(335));
    }];
    self.girlclassinfo_Topview = bView;
    
    bView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, Device_Height)];
    bView.layer.cornerRadius = ScaleW(15);
    bView.backgroundColor = ColorRGB(0xF3F4F6);
    [self.girlclassinfo_Topview addSubview:bView];
    [bView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.girlclassinfo_Topview.mas_centerY);
        make.centerX.mas_equalTo(self.girlclassinfo_Topview.mas_centerX);
        make.height.mas_equalTo(ScaleW(30));
        make.width.mas_equalTo(ScaleW(300));
    }];
    self.girlclassinfo_dateview = bView;
    
    
    UIButton *rememberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rememberBtn.tag = 101;
    rememberBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-5, -5, -5, -50);
    [rememberBtn setImage:[UIImage imageNamed:@"chevron-left"] forState:UIControlStateNormal];
    [rememberBtn setImage:[UIImage imageNamed:@"chevron-left"] forState:UIControlStateSelected];//gouXuanC
    [rememberBtn addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventTouchUpInside];
    [self.girlclassinfo_dateview addSubview:rememberBtn];
    [rememberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.girlclassinfo_dateview.mas_centerY);
        make.left.mas_equalTo(ScaleW(5));
        make.height.width.mas_equalTo(ScaleW(25));
    }];
    
    
    rememberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rememberBtn.tag = 102;
    rememberBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-5, -5, -5, -50);
    [rememberBtn setImage:[UIImage imageNamed:@"chevron-right-2"] forState:UIControlStateNormal];
    [rememberBtn setImage:[UIImage imageNamed:@"chevron-right-2"] forState:UIControlStateSelected];//gouXuanC
    [rememberBtn addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventTouchUpInside];
    [self.girlclassinfo_dateview addSubview:rememberBtn];
    [rememberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.girlclassinfo_dateview.mas_centerY);
        make.right.mas_equalTo(-ScaleW(5));
        make.height.width.mas_equalTo(ScaleW(25));
    }];
    
    
    UILabel *labelinimage = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], 40, 67)];
    labelinimage.text = @"2025/04";
    labelinimage.textColor = UIColor.blackColor;
    labelinimage.font = [UIFont boldSystemFontOfSize:FontSize(18)];
    [self.girlclassinfo_dateview addSubview:labelinimage];
    [labelinimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.girlclassinfo_dateview.mas_centerY);
        make.centerX.mas_equalTo(self.girlclassinfo_dateview.mas_centerX);
        make.height.mas_equalTo(ScaleW(24));
        make.width.mas_equalTo(ScaleW(80));
    }];
    self.girlclassinfo_datelabel = labelinimage;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //self.currentDate = [NSDate date];
    self.current_year = [calendar component:NSCalendarUnitYear fromDate:self.currentDate];
    self.current_month = [calendar component:NSCalendarUnitMonth fromDate:self.currentDate];
    NSLog(@"year = %ld, month = %ld",self.current_year,self.current_month);
    [self.girlclassinfo_datelabel setText:[self dateFromYEARandMonth:self.current_year M:self.current_month]];
    
    
    //如果没有班表数据 UI
    self.NoClass_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 1)];
    self.NoClass_imageView.backgroundColor = [UIColor colorWithRed:188/255.0 green:188/255.0 blue:202/255.0 alpha:1.0];
    self.NoClass_imageView.layer.cornerRadius = ScaleW(75)/2;
    self.NoClass_imageView.layer.masksToBounds = YES;
    self.NoClass_imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.NoClass_imageView.image = [UIImage imageNamed:@"Ellipse11"];
    [self.girlclassinfo_view addSubview:self.NoClass_imageView];
    [self.NoClass_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.girlclassinfo_dateview.mas_bottom).offset(ScaleW(30));
        make.centerX.mas_equalTo(self.girlclassinfo_view.mas_centerX);
        make.height.mas_equalTo(ScaleW(75));
        make.width.mas_equalTo(ScaleW(75));
    }];
    self.NoClass_imageView.hidden = YES;
    
    
    self.NoClass_label = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], 40, 67)];
    self.NoClass_label.textColor = ColorRGB(0x6B7280);
    self.NoClass_label.text = @"日前班表尚未公布，但我每場都在唷！";
    self.NoClass_label.textColor = UIColor.blackColor;
    self.NoClass_label.font = [UIFont boldSystemFontOfSize:FontSize(14)];
    [self.girlclassinfo_view addSubview:self.NoClass_label];
    [self.NoClass_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.NoClass_imageView.mas_centerX);
        make.top.mas_equalTo(self.NoClass_imageView.mas_bottom).offset(ScaleW(20));
        make.height.mas_equalTo(ScaleW(20));
        make.width.mas_equalTo(ScaleW(250));
    }];
    self.NoClass_label.hidden = YES;
    
    
    NSInteger table_height = ScaleW(300);//Device_Height-[UIDevice de_navigationFullHeight]-self.girlView.frame.size.height-self.girlclassinfo_bt.frame.size.height - ScaleW(65);
    UITableView *tableView2 = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
    tableView2.delegate = self;
    tableView2.dataSource = self;
    tableView2.backgroundColor = rgba(245, 245, 245, 1);
    
    tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView2.showsVerticalScrollIndicator = NO;
    tableView2.estimatedRowHeight = 100;
    self.girlclassinfo_tabelView = tableView2;
    [self.girlclassinfo_view addSubview:self.girlclassinfo_tabelView];
    [self.girlclassinfo_tabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(ScaleW(0));
        make.centerX.mas_equalTo(self.girlclassinfo_view.mas_centerX);
        //make.bottom.mas_equalTo(-ScaleW(20));
        make.height.mas_equalTo(table_height);
        make.top.mas_equalTo(self.girlclassinfo_Topview.mas_bottom).offset(ScaleW(5));
    }];
    self.girlclassinfo_tabelView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getclassinfo];
    }];
    
    
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 1)];
    line.image = [UIImage imageNamed:@"Ellipse11"];
    [self.girlclassinfo_view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.girlclassinfo_tabelView.mas_bottom).offset(ScaleW(15));
        make.left.mas_equalTo(ScaleW(40));
        make.height.mas_equalTo(ScaleW(10));
        make.width.mas_equalTo(ScaleW(10));
    }];
    self.helpimageView = line;
    
    
    UILabel *labelini = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], 40, 67)];
    labelini.textColor = ColorRGB(0x6B7280);
    labelini.text = @"排班日               以上為澄清湖排球場 Wing Stars 班表";
    labelini.textColor = UIColor.blackColor;
    labelini.font = [UIFont systemFontOfSize:FontSize(12)];
    [self.girlclassinfo_view addSubview:labelini];
    [labelini mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.helpimageView.mas_right).offset(ScaleW(5));
        make.centerY.mas_equalTo(self.helpimageView.mas_centerY);
        make.height.mas_equalTo(ScaleW(20));
        make.width.mas_equalTo(ScaleW(300));
    }];
    self.helplabel = labelini;
    
}

-(void)setgirlInfoUI
{
    //Name
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 22)];
        name.text = @"姓名";
        name.font = [UIFont systemFontOfSize:FontSize(16)];
        name.textColor = rgba(113,113,122,1);
        [self.girlinfo_view addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.girlinfo_bt.mas_bottom).offset(40);
            make.left.mas_equalTo(ScaleW(30));
            make.height.mas_equalTo(ScaleW(ScaleW(22)));
            make.width.mas_equalTo(ScaleW(60));
        }];
        self.girlNameTitle = name;
        
        name = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 22)];
        name.font = [UIFont boldSystemFontOfSize:FontSize(16)];
        name.text = @"";
        [self.girlinfo_view addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.girlinfo_bt.mas_bottom).offset(40);
            make.left.mas_equalTo(ScaleW(160));
            make.height.mas_equalTo(ScaleW(22));
    //        make.width.mas_equalTo(ScaleW(120));
        }];
        self.girlNameContent = name;
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 1)];
        line.backgroundColor = rgba(232, 232, 232, 1);
        [self.girlinfo_view addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.self.girlNameTitle.mas_bottom).offset(10);
            make.left.mas_equalTo(ScaleW(20));
            make.height.mas_equalTo(ScaleW(1));
            make.width.mas_equalTo(Device_Width-40);
        }];
        self.line1View = line;
        //End Name
        
        //birthday
       name = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 22)];
        name.text = @"生日";
        name.font = [UIFont systemFontOfSize:FontSize(16)];
        name.textColor = rgba(113,113,122,1);
        [self.girlinfo_view addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.line1View.mas_bottom).offset(10);
            make.left.mas_equalTo(ScaleW(30));
            make.height.mas_equalTo(ScaleW(22));
            make.width.mas_equalTo(ScaleW(60));
        }];
        self.girlBirthdayTitle = name;
        
        name = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 22)];
        name.font = [UIFont boldSystemFontOfSize:FontSize(16)];
        name.text = @"10月03日";
        [self.girlinfo_view addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.line1View.mas_bottom).offset(10);
            make.left.mas_equalTo(ScaleW(160));
            make.height.mas_equalTo(ScaleW(22));
            make.width.mas_equalTo(ScaleW(120));
        }];
        self.girlBirthdayContent = name;
        
        line = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 1)];
        line.backgroundColor = rgba(232, 232, 232, 1);
        [self.girlinfo_view addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.self.girlBirthdayContent.mas_bottom).offset(10);
            make.left.mas_equalTo(ScaleW(20));
            make.height.mas_equalTo(ScaleW(1));
            make.width.mas_equalTo(Device_Width-40);
        }];
        self.line2View = line;
        
        //身高
           name = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 22)];
            name.text = @"身高";
            name.font = [UIFont systemFontOfSize:FontSize(16)];
            name.textColor = rgba(113,113,122,1);
            [self.girlinfo_view addSubview:name];
            [name mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.line2View.mas_bottom).offset(10);
                make.left.mas_equalTo(ScaleW(30));
                make.height.mas_equalTo(ScaleW(22));
                make.width.mas_equalTo(ScaleW(60));
            }];
            self.girlheightTitle = name;
            
            name = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 22)];
            name.font = [UIFont boldSystemFontOfSize:FontSize(16)];
            name.text = @"";
            [self.girlinfo_view addSubview:name];
            [name mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.line2View.mas_bottom).offset(10);
                make.left.mas_equalTo(ScaleW(160));
                make.height.mas_equalTo(ScaleW(22));
                make.width.mas_equalTo(ScaleW(120));
            }];
            self.girlheightContent = name;
        
            line = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 1)];
            line.backgroundColor = rgba(232, 232, 232, 1);
            [self.girlinfo_view addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.self.girlheightContent.mas_bottom).offset(10);
                make.left.mas_equalTo(ScaleW(20));
                make.height.mas_equalTo(ScaleW(1));
                make.width.mas_equalTo(Device_Width-40);
            }];
            self.line3View = line;
            //End 身高
        
        //體重
        name = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 22)];
         name.text = @"體重";
         name.font = [UIFont systemFontOfSize:FontSize(16)];
         name.textColor = rgba(113,113,122,1);
         [self.girlinfo_view addSubview:name];
         [name mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.mas_equalTo(self.line3View.mas_bottom).offset(10);
             make.left.mas_equalTo(ScaleW(30));
             make.height.mas_equalTo(ScaleW(22));
             make.width.mas_equalTo(ScaleW(60));
         }];
         self.girlweightTitle = name;
         
         name = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 22)];
         name.font = [UIFont boldSystemFontOfSize:FontSize(16)];
         name.text = @"";
         [self.girlinfo_view addSubview:name];
         [name mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.mas_equalTo(self.line3View.mas_bottom).offset(10);
             make.left.mas_equalTo(ScaleW(160));
             make.height.mas_equalTo(ScaleW(22));
             make.width.mas_equalTo(ScaleW(120));
         }];
         self.girlweightContent = name;
     
         line = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 1)];
         line.backgroundColor = rgba(232, 232, 232, 1);
         [self.girlinfo_view addSubview:line];
         [line mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.mas_equalTo(self.girlweightContent.mas_bottom).offset(10);
             make.left.mas_equalTo(ScaleW(20));
             make.height.mas_equalTo(ScaleW(1));
             make.width.mas_equalTo(Device_Width-40);
         }];
         self.line4View = line;
        
        //star
        name = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 22)];
         name.text = @"星座";
         name.font = [UIFont systemFontOfSize:FontSize(16)];
        name.textColor = rgba(113,113,122,1);
         [self.girlinfo_view addSubview:name];
         [name mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.mas_equalTo(self.line4View.mas_bottom).offset(10);
             make.left.mas_equalTo(ScaleW(30));
             make.height.mas_equalTo(ScaleW(22));
             make.width.mas_equalTo(ScaleW(60));
         }];
        self.girlStarTitle = name;
         
         name = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 22)];
         name.font = [UIFont boldSystemFontOfSize:FontSize(16)];
         name.text = @"";
         [self.girlinfo_view addSubview:name];
         [name mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.mas_equalTo(self.line4View.mas_bottom).offset(10);
             make.left.mas_equalTo(ScaleW(160));
             make.height.mas_equalTo(ScaleW(22));
             make.width.mas_equalTo(ScaleW(120));
         }];
        self.girlStarContent = name;
         
         line = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 1)];
         line.backgroundColor = rgba(232, 232, 232, 1);
         [self.girlinfo_view addSubview:line];
         [line mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.mas_equalTo(self.self.girlStarContent.mas_bottom).offset(10);
             make.left.mas_equalTo(ScaleW(20));
             make.height.mas_equalTo(ScaleW(1));
             make.width.mas_equalTo(Device_Width-40);
         }];
         self.line5View = line;
        
        //興趣
        name = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 22)];
         name.text = @"興趣";
         name.font = [UIFont systemFontOfSize:FontSize(16)];
        name.textColor = rgba(113,113,122,1);
         [self.girlinfo_view addSubview:name];
         [name mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.mas_equalTo(self.line5View.mas_bottom).offset(10);
             make.left.mas_equalTo(ScaleW(30));
             make.height.mas_equalTo(ScaleW(22));
             make.width.mas_equalTo(ScaleW(60));
         }];
        self.girlloveTitle = name;
         
         name = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 22)];
         name.font = [UIFont boldSystemFontOfSize:FontSize(16)];
         name.text = @"天秤座";
         [self.girlinfo_view addSubview:name];
         [name mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.mas_equalTo(self.line5View.mas_bottom).offset(10);
             make.left.mas_equalTo(ScaleW(160));
             make.height.mas_equalTo(ScaleW(22));
             make.width.mas_equalTo(ScaleW(220));
         }];
        self.girlloveContent = name;
         
         line = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 1)];
         line.backgroundColor = rgba(232, 232, 232, 1);
         [self.girlinfo_view addSubview:line];
         [line mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.mas_equalTo(self.self.girlStarContent.mas_bottom).offset(10);
             make.left.mas_equalTo(ScaleW(20));
             make.height.mas_equalTo(ScaleW(1));
             make.width.mas_equalTo(Device_Width-40);
         }];
         self.line6View = line;
        
        
        
        UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], 46, 46)];
        bt.tag = 10011;
        bt.backgroundColor = [UIColor colorWithRed:0 green:0.478 blue:0.376 alpha:1.0];
        bt.layer.cornerRadius = ScaleW(8);
        [bt setImage:[UIImage imageNamed:@"facebook"] forState:UIControlStateNormal];
        [bt addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
        [self.girlinfo_view addSubview:bt];
        [bt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.self.line6View.mas_bottom).offset(30);
            make.left.mas_equalTo(self.girlNameTitle.mas_left);
            make.height.mas_equalTo(ScaleW(46));
            make.width.mas_equalTo(ScaleW(46));
        }];
        self.facebookbt = bt;
        
        bt = [[UIButton alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], 46, 46)];
        bt.tag = 10012;
        bt.backgroundColor = [UIColor colorWithRed:0 green:0.478 blue:0.376 alpha:1.0];
        bt.layer.cornerRadius = ScaleW(8);
        [bt setImage:[UIImage imageNamed:@"instagram"] forState:UIControlStateNormal];
        [bt addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
        [self.girlinfo_view addSubview:bt];
        [bt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.self.line6View.mas_bottom).offset(30);
            make.left.mas_equalTo(self.facebookbt.mas_right).offset(30);
            make.height.mas_equalTo(ScaleW(46));
            make.width.mas_equalTo(ScaleW(46));
        }];
        self.twtiterbt = bt;
}


-(void)buttonclick:(UIButton*)bt
{
    NSString *facebookstring = [self.girlDetailinfo objectForKey:@"girlfacebookURL"];
    NSString *IGstring = [self.girlDetailinfo objectForKey:@"girligURL"];
    
    switch (bt.tag) {
        case 10011:
            [self openURL:facebookstring fallback:@"https://www.facebook.com/100083409097537"];
            break;
        case 10012:
            [self openURL:IGstring
                        fallback:@"https://www.instagram.com/tsghawks_takao07/"];
            break;
    }
}

- (void)openURL:(NSString *)appURL fallback:(NSString *)webURL {
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

-(void)setInfo:(NSDictionary*)girlDetailinfo
{
    
    if([[girlDetailinfo objectForKey:@"girlnickName"] isEqualToString:@"TAKAMEI"])
    {
        self.girlNameContent.hidden = NO;
        self.girlNameTitle.hidden = NO;
        self.line1View.hidden = NO;
        [self.girlNameContent setText:[girlDetailinfo objectForKey:@"girlnickName"]];
        [self.Namelable_inImage setText:[girlDetailinfo objectForKey:@"girlName"]];
        [self.SecondNamelable_inImage setText:[girlDetailinfo objectForKey:@"girlsecondName"]];
        [self.showgirlView setImage:[UIImage imageNamed:[girlDetailinfo objectForKey:@"girImage"]]];
        [self.showgirlView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.right.mas_equalTo(ScaleW(-20));
                make.height.mas_equalTo(ScaleW(235));
                make.width.mas_equalTo(ScaleW(200));
            }];
        [self.NoClass_imageView setImage:[UIImage imageNamed:@"ws_takao"]];
        
        self.girlBirthdayContent.hidden = YES;
        self.girlBirthdayTitle.hidden = YES;
        
        self.girlStarTitle.hidden = YES;
        self.girlStarContent.hidden = YES;
        
        self.girlweightContent.hidden = YES;
        self.girlweightTitle.hidden = YES;
        
        self.girlheightTitle.hidden = YES;
        self.girlheightContent.hidden = YES;
        
        self.girlloveContent.hidden = YES;
        self.girlloveTitle.hidden = YES;
        
        
        self.line2View.hidden = YES;
        self.line3View.hidden = YES;
        self.line4View.hidden = YES;
        self.line5View.hidden = YES;
        self.line6View.hidden = YES;
        
        self.facebookbt.hidden = YES;
        self.twtiterbt.hidden = YES;
        return;
    }
    
    BOOL isTaKo = NO;
    if([[girlDetailinfo objectForKey:@"girlnickName"] isEqualToString:@"TAKAO"])
        isTaKo = YES;
    
    
    [self.girlNameContent setText:[girlDetailinfo objectForKey:@"girlnickName"]];
    [self.girlBirthdayContent setText:[girlDetailinfo objectForKey:@"girlbrithday"]];
    [self.girlStarContent setText:[girlDetailinfo objectForKey:@"girlstar"]];
    
    if(![[girlDetailinfo objectForKey:@"girlweight"] isEqualToString:@""])
    {
        self.girlweightContent.hidden = NO;
        self.girlweightTitle.hidden = NO;
        [self.girlweightContent setText:[girlDetailinfo objectForKey:@"girlweight"]];
    }
    else
    {
        self.girlweightContent.hidden = YES;
        self.girlweightTitle.hidden = YES;
        self.line4View.hidden = YES;
        //动态改变UI位置
        [self.girlStarTitle mas_updateConstraints:^(MASConstraintMaker *make) {
                 make.top.mas_equalTo(self.line2View.mas_bottom).offset(10);
                 make.left.mas_equalTo(ScaleW(30));
                 make.height.mas_equalTo(ScaleW(22));
                 make.width.mas_equalTo(ScaleW(60));
             }];
        
        
        [self.girlStarContent mas_updateConstraints:^(MASConstraintMaker *make) {
                 make.top.mas_equalTo(self.line2View.mas_bottom).offset(10);
                 make.left.mas_equalTo(ScaleW(160));
                 make.height.mas_equalTo(ScaleW(22));
                 make.width.mas_equalTo(ScaleW(120));
             }];
    }
    
    if(![[girlDetailinfo objectForKey:@"girlheight"] isEqualToString:@""])
    {
        self.girlheightContent.hidden = NO;
        self.girlheightTitle.hidden = NO;
        [self.girlheightContent setText:[girlDetailinfo objectForKey:@"girlheight"]];
    }
    else
    {
        self.girlheightContent.hidden = YES;
        self.girlheightTitle.hidden = YES;
        self.line3View.hidden = YES;
        //动态改变UI位置
        [self.girlStarTitle mas_updateConstraints:^(MASConstraintMaker *make) {
                 make.top.mas_equalTo(self.line2View.mas_bottom).offset(10);
                 make.left.mas_equalTo(ScaleW(30));
                 make.height.mas_equalTo(ScaleW(22));
                 make.width.mas_equalTo(ScaleW(60));
             }];
        
        
        [self.girlStarContent mas_updateConstraints:^(MASConstraintMaker *make) {
                 make.top.mas_equalTo(self.line2View.mas_bottom).offset(10);
                 make.left.mas_equalTo(ScaleW(160));
                 make.height.mas_equalTo(ScaleW(22));
                 make.width.mas_equalTo(ScaleW(120));
             }];
    }
    
    if(![[girlDetailinfo objectForKey:@"girlNO"] isEqualToString:@""]) //girlNO 不为空，代表是应援团
    {
        self.girlloveContent.hidden = NO;
        self.girlloveTitle.hidden = NO;
        [self.girlloveContent setText:[girlDetailinfo objectForKey:@"girlNO"]];
    }
    else
    {
        self.girlloveContent.hidden = YES;
        self.girlloveTitle.hidden = YES;
        
        if(!isTaKo)
            self.line6View.hidden = YES;
        else
            self.line6View.hidden = NO;
        //动态改变UI位置
        [self.girlStarTitle mas_updateConstraints:^(MASConstraintMaker *make) {
                 make.top.mas_equalTo(self.line2View.mas_bottom).offset(10);
                 make.left.mas_equalTo(ScaleW(30));
                 make.height.mas_equalTo(ScaleW(22));
                 make.width.mas_equalTo(ScaleW(60));
             }];
        
        
        [self.girlStarContent mas_updateConstraints:^(MASConstraintMaker *make) {
                 make.top.mas_equalTo(self.line2View.mas_bottom).offset(10);
                 make.left.mas_equalTo(ScaleW(160));
                 make.height.mas_equalTo(ScaleW(22));
                 make.width.mas_equalTo(ScaleW(120));
             }];
    }
    
    //[self.Nolable_inImage setText:[girlDetailinfo objectForKey:@"girlNO"]];
    [self.Namelable_inImage setText:[girlDetailinfo objectForKey:@"girlName"]];
    [self.SecondNamelable_inImage setText:[girlDetailinfo objectForKey:@"girlsecondName"]];
    [self.NoClass_imageView setImage:[UIImage imageNamed:@"ws_takao"]];
    [self.showgirlView setImage:[UIImage imageNamed:[girlDetailinfo objectForKey:@"girImage"]]];
    
    self.facebookbt.hidden = YES;
    if(isTaKo){
        self.twtiterbt.hidden = NO;
        [self.twtiterbt mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.self.line6View.mas_bottom).offset(30);
            make.left.mas_equalTo(self.girlNameTitle.mas_left);
            make.height.mas_equalTo(ScaleW(46));
            make.width.mas_equalTo(ScaleW(46));
        }];
    }
    else{
        self.twtiterbt.hidden = YES;
        
    }
    
    
}


-(void)setscrollerView:(NSInteger)bt_index
{
    self.isUserScrolling = NO;  // 标记为按钮点击
    [self.girlinfo_bt setColor:[UIColor clearColor]];
    [self.girlclassinfo_bt setColor:[UIColor clearColor]];
    
    // 重置所有按钮状态
    [self.girlinfo_bt setSelected:NO];
    [self.girlclassinfo_bt setSelected:NO];
    
    self.girlinfo_view.hidden = NO;
    self.girlclassinfo_view.hidden = NO;
    
    
    switch (bt_index) {
        case 50000:
        {
            [self.girlinfo_bt setSelected:YES];
            [self.girlinfo_bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
            self.girlinfo_view.hidden = NO;
        }
            break;
        case 50001:
        {
            [self.girlclassinfo_bt setSelected:YES];
            [self.girlclassinfo_bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
            self.girlclassinfo_view.hidden = NO;
        }
            break;
     
    }
    
//        [self updateSelectedButton:bt.tag-50000];
//        [self.mainscrollView setContentOffset:CGPointMake((bt.tag-50000) * UIScreen.mainScreen.bounds.size.width, 0) animated:YES];

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

-(void)buttonclick1:(UIButton*)bt
{
    self.isUserScrolling = NO;  // 标记为按钮点击
    [self.girlinfo_bt setColor:[UIColor clearColor]];
    [self.girlclassinfo_bt setColor:[UIColor clearColor]];
    
    // 重置所有按钮状态
    [self.girlinfo_bt setSelected:NO];
    [self.girlclassinfo_bt setSelected:NO];
    
    self.girlinfo_view.hidden = NO;
    self.girlclassinfo_view.hidden = NO;
    
    
    switch (bt.tag) {
        case 50000:
        {
            [self.girlinfo_bt setSelected:YES];
            [self.girlinfo_bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
            self.girlinfo_view.hidden = NO;
        }
            break;
        case 50001:
        {
            [self.girlclassinfo_bt setSelected:YES];
            [self.girlclassinfo_bt setColor:/*rgba(0, 122, 96, 1)*/[UIColor clearColor]];
            self.girlclassinfo_view.hidden = NO;
        }
            break;
     
    }
    
        [self updateSelectedButton:bt.tag-50000];
        [self.mainscrollView setContentOffset:CGPointMake((bt.tag-50000) * UIScreen.mainScreen.bounds.size.width, 0) animated:YES];

}

-(void)changeDate:(UIButton*)bt
{
    [self.girlclassinfo_array removeAllObjects];
    
    switch (bt.tag) {
        case 101://前一个月
            [self beforeDate];
            break;
            
            
        case 102://后一个月
            [self nextDate];
            break;
        
    }
    
    [self.girlclassinfo_tabelView reloadData];
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
//    NSLog(@"year = %ld, month = %ld",self.current_year,self.current_month);
    
    [self.girlclassinfo_datelabel setText:[self dateFromYEARandMonth:self.current_year M:self.current_month]];
    
    NSDate *firstDayOfMonth = [calendar dateFromComponents:components];
    NSDateFormatter *formatter22 = [[NSDateFormatter alloc] init];
    [formatter22 setDateFormat:@"yyyy/MM"]; // 设置格式为年-月
    NSString *dateString = [formatter22 stringFromDate:firstDayOfMonth];
        
    NSPredicate *predicate1 = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
    NSString *dateV = (NSString *)evaluatedObject[@"ws_month"];
        return ([dateV isEqualToString:dateString]);
    }];
        
    NSArray* dateinfo  = [self.wingsclassAllArray filteredArrayUsingPredicate:predicate1];
    if(dateinfo.count>0){
        [self has_classData:YES];
        [self mergeArray:[dateinfo objectAtIndex:0][@"ws_month_data"] girlNO:[self.girlDetailinfo objectForKey:@"girlnickName"]];
    }
    else
        [self has_classData:NO];
}



-(void)nextDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.currentDate];
    // 获取当前月份
    NSInteger currentMonth = [components month];
     
    // 加上一个月
    components.month = currentMonth + 1;
    self.currentDate = [calendar dateFromComponents:components];
    self.current_year = [calendar component:NSCalendarUnitYear fromDate:self.currentDate];
    self.current_month = [calendar component:NSCalendarUnitMonth fromDate:self.currentDate];
//    NSLog(@"year = %ld, month = %ld",self.current_year,self.current_month);
    [self.girlclassinfo_datelabel setText:[self dateFromYEARandMonth:self.current_year M:self.current_month]];
    
    NSDate *firstDayOfMonth = [calendar dateFromComponents:components];
    NSDateFormatter *formatter22 = [[NSDateFormatter alloc] init];
    [formatter22 setDateFormat:@"yyyy/MM"]; // 设置格式为年-月
    NSString *dateString = [formatter22 stringFromDate:firstDayOfMonth];
        
    NSPredicate *predicate1 = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
    NSString *dateV = (NSString *)evaluatedObject[@"ws_month"];
        return ([dateV isEqualToString:dateString]);
    }];
        
    NSArray* dateinfo  = [self.wingsclassAllArray filteredArrayUsingPredicate:predicate1];
    if(dateinfo.count>0){
        [self has_classData:YES];
        [self mergeArray:[dateinfo objectAtIndex:0][@"ws_month_data"] girlNO:[self.girlDetailinfo objectForKey:@"girlnickName"]];
    }
    else
        [self has_classData:NO];
     
}

-(void)mergeArray:(NSArray*)arr girlNO:(NSString*)girl_No
{
    for(int i=0;i<arr.count;i++)
    {
        NSArray* date_girl = [arr objectAtIndex:i][@"ws_day_data"];//拿到某一天对应的所有应援女孩的信息，然后用girl NO 过滤是否有当前女孩, 这个date_girl数据是包含 第一届，第二届。。。的Array。然后从所有届里再看是否有此女孩
        
        for(int y=0;y<date_girl.count;y++)
        {
            NSArray *g_array = [date_girl objectAtIndex:y][@"ws_type_data"];//获取第几届的人员列表
            NSPredicate *predicate1 = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                NSString *dateV = (NSString *)evaluatedObject[@"ws_name"];
                return ([dateV isEqualToString:girl_No]);
            }];
            NSArray* dateinfo  = [g_array filteredArrayUsingPredicate:predicate1];//dateinfo 如果有值，说明有这个女孩的信息
            if(dateinfo.count>0)
            {
                NSMutableDictionary *dic = [NSMutableDictionary new];
                NSString* datestring = [arr objectAtIndex:i][@"ws_day"];
                NSString *lastCharacter = datestring;
                if([datestring length]>0)
                    lastCharacter = [datestring substringFromIndex:5];

                NSString *week = [self getWeek:datestring];
                
                NSString *dateresult = [NSString stringWithFormat:@"%@ (%@)",lastCharacter,week];
                
                [dic setObject:dateresult forKey:@"girIclassdate"];
                [dic setObject:[dateinfo objectAtIndex:0][@"ws_number"] forKey:@"girlNO"];
                [dic setObject:[dateinfo objectAtIndex:0][@"ws_name"] forKey:@"girlName"];
                [dic setObject:[NSNumber numberWithBool:YES] forKey:@"girlclassdatestatus"];
                [self.girlclassinfo_array addObject:dic];
                break;//说明在这一届中有此人
            }
        }
    }
}


- (NSString *)getWeek:(NSString *)dayString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    //NSDate *date = [formatter dateFromString:[dayString substringToIndex:10]];
    NSDate * date =[formatter dateFromString:dayString];
    // 创建日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 获取日期的周几信息
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:date];
    
    // 获取周几的整数值（1: 周日, 2: 周一, ..., 7: 周六）
    NSInteger weekday = [components weekday];
    
    // 将周几的整数值转换为具体的周几名称
    NSString *weekString;
    switch (weekday) {
        case 1:
            weekString = @"日";
            break;
        case 2:
            weekString = @"一";
            break;
        case 3:
            weekString = @"二";
            break;
        case 4:
            weekString = @"三";
            break;
        case 5:
            weekString = @"四";
            break;
        case 6:
            weekString = @"五";
            break;
        case 7:
            weekString = @"六";
            break;
        
    }
    
    return weekString;
}
-(NSArray*)getCurrentMothArray:(NSArray*)array
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
       return [dateinfo objectAtIndex:0][@"ws_month_data"];
    else
        return nil;

}
#pragma mark  Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.girlclassinfo_array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return ScaleW(55);;
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //return UITableViewAutomaticDimension;
    return ScaleW(50);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

        NSDictionary *section = self.girlclassinfo_array[indexPath.row];
        EGFanMemberClassInfoCell *cell= [EGFanMemberClassInfoCell cellWithUITableView:tableView];
        
    if (indexPath.row % 2 == 0)
        cell.backgroundColor = ColorRGB(0xF9FAFB);
    else
        cell.backgroundColor = UIColor.whiteColor;
        [cell setupWithInfo:section];
       
        return cell;
    
}


#pragma mark ------UIScrollViewDelegate
- (void)updateSelectedButton:(NSInteger)index {
    self.currentIndex = index;
   
    NSInteger bt_w = Device_Width/2;
    [UIView animateWithDuration:0.3 animations:^{
        self.bustatuslable.transform = CGAffineTransformMakeTranslation(index * bt_w, 0);
    }];
    
   
}

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
    CGFloat buttonWidth = Device_Width/2;
    self.bustatuslable.transform = CGAffineTransformMakeTranslation(progress * buttonWidth, 0);
}

@end
