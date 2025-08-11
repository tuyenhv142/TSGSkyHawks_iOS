#import "EGFAQViewController.h"
#import "EGFAQCell.h"
#import "EGFAQTitleCell.h"
@interface EGFAQViewController () <UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *helpView;
@property (nonatomic, strong) UIImageView *helpImageView;
@property (nonatomic, strong) UILabel *helpLabel;

@property (nonatomic, strong) UIButton *taskButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *downloadButton;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *indicatorLabel;
@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic,strong)NSArray* info_All;
@property (nonatomic, strong) NSMutableArray *info_sections;


@property (nonatomic, strong) NSArray *FAQ_event_array;
@property (nonatomic, strong) NSArray *FAQ_login_array;
@property (nonatomic, strong) NSArray *FAQ_download_array;

@property (nonatomic, assign) NSInteger FAQ_event_sctioncount;
@property (nonatomic, assign) NSInteger FAQ_login_sctioncount;
@property (nonatomic, assign) NSInteger FAQ_download_sctioncount;


@property (nonatomic, strong) NSMutableArray *FAQ_event_section_array;
@property (nonatomic, strong) NSMutableArray *FAQ_login_section_array;
@property (nonatomic, strong) NSMutableArray *FAQ_download_section_array;


@property (nonatomic, strong) UITableView *FAQ_event_tableview;
@property (nonatomic, strong) UITableView *FAQ_login_tableview;
@property (nonatomic, strong) UITableView *FAQ_download_tableview;

@property (nonatomic,assign)CGFloat buttonWidth;




@end

@implementation EGFAQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"常見問題";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupHelpView];
    [self getFAQInfo];
}

- (void)setupHelpView {
    self.helpView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 80)];
//    self.helpView.backgroundColor = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:96/255.0 alpha:1.0];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.startPoint = CGPointMake(0.5, 0.5);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    gradientLayer.frame = self.helpView.bounds;
    gradientLayer.colors = @[(id)rgba(0, 71, 56, 1).CGColor,(id)rgba(0, 122, 96, 1).CGColor];
    [self.helpView.layer insertSublayer:gradientLayer atIndex:0];
    [self.view addSubview:self.helpView];
    
    [self.helpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([UIDevice de_navigationFullHeight]);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(80);
    }];
    
    self.helpImageView = [[UIImageView alloc] init];
    self.helpImageView.image = [UIImage imageNamed:@"dialogTAKAO2"];
    [self.helpView addSubview:self.helpImageView];
    
    [self.helpImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.helpView);
        make.left.mas_equalTo(Device_Width/4);
        make.width.height.mas_equalTo(40);
    }];
    
    self.helpLabel = [[UILabel alloc] init];
    self.helpLabel.text = @"需要我們的幫助嗎？";
    self.helpLabel.textColor = [UIColor whiteColor];
    self.helpLabel.font = [UIFont boldSystemFontOfSize:FontSize(18)];
    [self.helpView addSubview:self.helpLabel];
    
    [self.helpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.helpView);
        make.left.equalTo(self.helpImageView.mas_right).offset(12);
    }];
    
    
}

- (void)setupButtons {
    NSMutableArray* Tarray = [NSMutableArray new];
    for(int i=0;i<self.info_All.count;i++)
    {
        NSDictionary *dic = [self.info_All objectAtIndex:i];
        NSString *titlle = [dic objectForKey:@"partName"];
        [Tarray addObject:titlle];
    }
    
    NSArray *titles = Tarray;//@[@"點數任務", @"註冊登入", @"下載安裝"];
    NSInteger count = Tarray.count +1;
    self.buttonWidth = UIScreen.mainScreen.bounds.size.width / count;
    
    for (NSInteger i = 0; i < Tarray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:FontSize(16)];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:/*[UIColor colorWithRed:0/255.0 green:122/255.0 blue:96/255.0 alpha:1.0]*/UIColor.blackColor forState:UIControlStateSelected];
        button.tag = i;
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.helpView.mas_bottom);
            make.left.mas_equalTo(self.buttonWidth * i);
            make.width.mas_equalTo(self.buttonWidth);
            make.height.mas_equalTo(44);
        }];
        
        if (i == 0) self.taskButton = button;
        if (i == 1) self.loginButton = button;
        if (i == 2) self.downloadButton = button;
    }
    
    self.taskButton.selected = YES;
    
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.taskButton.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(2);
    }];
    
    self.indicatorLabel = [[UIView alloc] init];
    self.indicatorLabel.backgroundColor = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:96/255.0 alpha:1.0];
    [self.view addSubview:self.indicatorLabel];
    
    [self.indicatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.lineView);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.buttonWidth);
        make.height.mas_equalTo(2);
    }];
}

- (void)setupScrollView {
    
    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.delegate = self;
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
     self.contentScrollView.alwaysBounceVertical = NO;
     self.contentScrollView.bounces = NO;
    [self.view addSubview:self.contentScrollView];
    
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    // 必须创建一个容器视图才能滚动
    UIView *containerView = [[UIView alloc] init];
    [self.contentScrollView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentScrollView);
            make.height.equalTo(self.contentScrollView).priority(750);
            make.width.equalTo(self.contentScrollView).multipliedBy(3);
        }];
    
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    for (NSInteger i = 0; i < 3; i++) {
        UITableView *contentView = [self settableView:1000+i];
        if(i==0)
            self.FAQ_event_tableview = contentView;
        else if(i==1)
            self.FAQ_login_tableview = contentView;
        else
            self.FAQ_download_tableview = contentView;
        
        [containerView addSubview:contentView];
        
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(containerView);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            make.width.equalTo(@(screenWidth));
            make.left.equalTo(containerView).offset(screenWidth * i);
        }];
    }
}

- (void)buttonTapped:(UIButton *)sender {
    [self updateSelectedButton:sender.tag];
    [self.contentScrollView setContentOffset:CGPointMake(UIScreen.mainScreen.bounds.size.width * sender.tag, 0) animated:YES];
}

- (void)updateSelectedButton:(NSInteger)index {
    self.taskButton.selected = (index == 0);
    self.loginButton.selected = (index == 1);
    self.downloadButton.selected = (index == 2);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.indicatorLabel.transform = CGAffineTransformMakeTranslation(self.buttonWidth * index, 0);
    }];
}

-(void)getFAQInfo
{
    [[WAFNWHTTPSTool sharedManager] getWithURL:[EGServerAPI get_Questions] parameters:@{} headers:@{} success:^(NSDictionary * _Nonnull response) {
        
        self.info_All = [response objectForKey:@"data"];
        if(self.info_All.count>0){
            //[MBProgressHUD showDelayHidenMessage:@"数据获取成功"];
            [self getTableViewinfo];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setupButtons];
                [self setupScrollView];
            });
            
        }
    } failure:^(NSError * _Nonnull error) {
        //[MBProgressHUD showDelayHidenMessage:@"請檢查您的網路連線，確保裝置已連接至網路後再重試."];
            NSString *path = [[NSBundle mainBundle] pathForResource:@"common_questions" ofType:@"json"];
            NSData *data = [NSData dataWithContentsOfFile:path];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
        
            self.info_All = [dic objectForKey:@"data"];
            [self getTableViewinfo];
        
            [self setupButtons];
            [self setupScrollView];
    }];
    

}


-(void)getTableViewinfo
{
    self.FAQ_event_array = [[self.info_All objectAtIndex:0] objectForKey:@"outData"];
    self.FAQ_login_array = [[self.info_All objectAtIndex:1] objectForKey:@"outData"];
    self.FAQ_download_array = [[self.info_All objectAtIndex:2] objectForKey:@"outData"];
    
    
    self.FAQ_event_sctioncount = 0;
    self.FAQ_login_sctioncount = 0;
    self.FAQ_download_sctioncount = 0;
    
    self.FAQ_event_section_array = [NSMutableArray new];
    self.FAQ_login_section_array = [NSMutableArray new];
    self.FAQ_download_section_array = [NSMutableArray new];
    
    for(int i=0;i<self.FAQ_event_array.count;i++)
    {
        NSDictionary*dic = [self.FAQ_event_array objectAtIndex:i];
        NSArray* arrary = [dic objectForKey:@"insideData"];
        self.FAQ_event_sctioncount = self.FAQ_event_sctioncount + arrary.count;
        
        for(int k=0;k<arrary.count;k++)
        {
            NSMutableDictionary*contendic = [NSMutableDictionary new];
            NSDictionary *temp = [arrary objectAtIndex:k];
            if(k==0)
                [contendic setObject:[dic objectForKey:@"topTitle"] forKey:@"section_header"];
            else
                [contendic setObject:@"" forKey:@"section_header"];
                
                [contendic setObject:temp forKey:@"section_dic"];
                [contendic setObject:[NSNumber numberWithBool:NO] forKey:@"section_open"];
            
            [self.FAQ_event_section_array addObject:contendic];
        }
    }
    
    for(int j=0;j<self.FAQ_login_array.count;j++)
    {
        NSDictionary*dic = [self.FAQ_login_array objectAtIndex:j];
        NSArray* arrary = [dic objectForKey:@"insideData"];
        self.FAQ_login_sctioncount = self.FAQ_login_sctioncount + arrary.count;
        
        
        for(int k=0;k<arrary.count;k++)
        {
            NSMutableDictionary*contendic = [NSMutableDictionary new];
            NSDictionary *temp = [arrary objectAtIndex:k];
            if(k==0)
                [contendic setObject:[dic objectForKey:@"topTitle"] forKey:@"section_header"];
            else
                [contendic setObject:@"" forKey:@"section_header"];
                
                [contendic setObject:temp forKey:@"section_dic"];
                [contendic setObject:[NSNumber numberWithBool:NO] forKey:@"section_open"];
            
            [self.FAQ_login_section_array addObject:contendic];
        }
    }
    
    for(int w=0;w<self.FAQ_download_array.count;w++)
    {
        NSDictionary*dic = [self.FAQ_download_array objectAtIndex:w];
        NSArray* arrary = [dic objectForKey:@"insideData"];
        self.FAQ_download_sctioncount = self.FAQ_download_sctioncount + arrary.count;
        
        
        
        for(int k=0;k<arrary.count;k++)
        {
            NSMutableDictionary*contendic = [NSMutableDictionary new];
            NSDictionary *temp = [arrary objectAtIndex:k];
            if(k==0)
                [contendic setObject:[dic objectForKey:@"topTitle"] forKey:@"section_header"];
            else
                [contendic setObject:@"" forKey:@"section_header"];
                
                [contendic setObject:temp forKey:@"section_dic"];
                [contendic setObject:[NSNumber numberWithBool:NO] forKey:@"section_open"];
            
            [self.FAQ_download_section_array addObject:contendic];
        }
    }
    
}
// 在 ViewController.m 中添加手势代理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES; // 允许同时识别
}
- (UITableView *)settableView:(NSInteger)tag
{
        UITableView *tableView2 = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
        tableView2.delegate = self;
        tableView2.dataSource = self;
        tableView2.tag = tag;
        tableView2.backgroundColor = rgba(245, 245, 245, 1);
    tableView2.bounces = false;
        tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView2.showsVerticalScrollIndicator = NO;
        tableView2.estimatedRowHeight = 100;
        return tableView2;
}
-(void)changeSectionopen:(NSDictionary*)dic_T clickType:(BOOL)click_type
{
    NSInteger tabTag = [[dic_T objectForKey:@"tableViewtag"] intValue];
    NSInteger sectionindex = [[dic_T objectForKey:@"sectionindex"] intValue];
    
    NSMutableDictionary *section;
    if(tabTag==1000)
    {
        section = self.FAQ_event_section_array[sectionindex];
        [section setObject:[NSNumber numberWithBool:click_type] forKey:@"section_open"];
        
        [self.FAQ_event_section_array replaceObjectAtIndex:sectionindex withObject:section];
        [self.FAQ_event_tableview reloadData];
    }
    else if(tabTag==1001)
    {
        section = self.FAQ_login_section_array[sectionindex];
        [section setObject:[NSNumber numberWithBool:click_type] forKey:@"section_open"];
        
        [self.FAQ_login_section_array replaceObjectAtIndex:sectionindex withObject:section];
        [self.FAQ_login_tableview reloadData];
    }
    else
    {
        section = self.FAQ_download_section_array[sectionindex];
        [section setObject:[NSNumber numberWithBool:click_type] forKey:@"section_open"];
        
        [self.FAQ_download_section_array replaceObjectAtIndex:sectionindex withObject:section];
        [self.FAQ_download_tableview reloadData];
    }
    
    
    
    
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if ([scrollView isKindOfClass:[UITableView class]])
    {
        return;
    }
    
    NSInteger index = scrollView.contentOffset.x / UIScreen.mainScreen.bounds.size.width;
    [self updateSelectedButton:index];
}

// 添加滑动过程中的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([scrollView isKindOfClass:[UITableView class]])
    {
        return;
    }
    
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    CGFloat progress = offsetX / screenWidth;
    
    // 更新指示器位置
    
    self.indicatorLabel.transform = CGAffineTransformMakeTranslation(self.buttonWidth * progress, 0);
    
    // 计算当前页面索引
    NSInteger currentIndex = (NSInteger)(progress + 0.5);
    if (currentIndex != self.currentIndex) {
        self.currentIndex = currentIndex;
        self.taskButton.selected = (currentIndex == 0);
        self.loginButton.selected = (currentIndex == 1);
        self.downloadButton.selected = (currentIndex == 2);
    }
    
}


#pragma mark  Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger sectionNum = 0;
    if(tableView.tag==1000)
        sectionNum = self.FAQ_event_sctioncount;
    else if(tableView.tag==1001)
        sectionNum = self.FAQ_login_sctioncount;
    else
        sectionNum = self.FAQ_download_sctioncount;
    
    return sectionNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    NSInteger sectionNum = 0;
    if(tableView.tag==1000)
    {
        NSNumber* is_open = self.FAQ_event_section_array[section][@"section_open"];
        if([is_open boolValue])
        sectionNum = [self.FAQ_event_section_array[section][@"section_dic"][@"content"] count]+1 ;
        else
        sectionNum = 1;
    }
    else if(tableView.tag==1001)
    {
        NSNumber* is_open = self.FAQ_login_section_array[section][@"section_open"];
        if([is_open boolValue])
        sectionNum = [self.FAQ_login_section_array[section][@"section_dic"][@"content"] count]+1;
        else
        sectionNum = 1;
    }
    else
    {
        NSNumber* is_open = self.FAQ_download_section_array[section][@"section_open"];
        if([is_open boolValue])
        sectionNum = [self.FAQ_download_section_array[section][@"section_dic"][@"content"] count]+1;
        else
            sectionNum=1;
    }
    
    return sectionNum;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
   
    NSString *sectionTitle = @"";
    
    if(tableView.tag==1000)
        sectionTitle = self.FAQ_event_section_array[section][@"section_header"];
    else if(tableView.tag==1001)
        sectionTitle = self.FAQ_login_section_array[section][@"section_header"];
    else
        sectionTitle = self.FAQ_download_section_array[section][@"section_header"];
    
    return sectionTitle;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
    headerView.backgroundColor = [UIColor colorWithRed:0.962 green:0.962 blue:0.962 alpha:1.0];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ScaleW(30), 200, ScaleW(14))];
    NSString *sectionTitle = @"";
    if(tableView.tag==1000)
        sectionTitle = self.FAQ_event_section_array[section][@"section_header"];
    else if(tableView.tag==1001)
        sectionTitle = self.FAQ_login_section_array[section][@"section_header"];
    else
        sectionTitle = self.FAQ_download_section_array[section][@"section_header"];
    
    if(![sectionTitle isEqualToString:@""])
    {
        titleLabel.text = sectionTitle;//self.sections[section][@"topTitle"];
        titleLabel.textColor = rgba(0, 122, 96, 1);
        titleLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightSemibold];
        [headerView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(headerView).offset(0);
            //        make.centerY.equalTo(headerView);
            make.height.mas_equalTo(ScaleW(14));
            make.top.equalTo(headerView).inset(ScaleW(20));
            make.bottom.equalTo(headerView).inset(ScaleW(16));
        }];
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return ScaleW(55);;
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //return ScaleW(155);
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        NSDictionary *section;
        if(tableView.tag==1000)
            section = self.FAQ_event_section_array[indexPath.section][@"section_dic"];
        else if(tableView.tag==1001)
            section = self.FAQ_login_section_array[indexPath.section][@"section_dic"];
        else
            section = self.FAQ_download_section_array[indexPath.section][@"section_dic"];
        
        NSArray *stringA = [section objectForKey:@"content"];
        BOOL is_showdot = YES;
        if(stringA.count==1)
            is_showdot = NO;
    
        if(indexPath.row==0)
        {
            //显示问题 title lable cell
            EGFAQTitleCell *cell = [EGFAQTitleCell cellWithUITableView:tableView];
            cell.FAQInfoBlock = ^(BOOL type, NSDictionary* dic) {
                [self changeSectionopen:dic clickType:type];
            };
            
            NSMutableDictionary* dict = [NSMutableDictionary new];
            [dict setObject:[NSNumber numberWithInteger:tableView.tag] forKey:@"tableViewtag"];
            [dict setObject:[NSNumber numberWithInteger:indexPath.section] forKey:@"sectionindex"];
            
            
            NSNumber* num = nil;
            if(tableView.tag==1000)
                num = self.FAQ_event_section_array[indexPath.section][@"section_open"];
            else if(tableView.tag==1001)
                num = self.FAQ_login_section_array[indexPath.section][@"section_open"];
            else
                num = self.FAQ_download_section_array[indexPath.section][@"section_open"];
            
            [cell setbtstate:num.boolValue];
            [cell setupWithInfo:section sectioninfo:dict];
            return cell;
        }
        else
        {
            //显示 content label cell
            EGFAQCell *cell= [EGFAQCell cellWithUITableView:tableView];
            [cell setupWithInfo:[stringA objectAtIndex:indexPath.row-1] showdot:is_showdot];
            return cell;
        }
        
    //}

        
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *section;
    if(tableView.tag==1000)
        section = self.FAQ_event_section_array[indexPath.section][@"section_dic"];
    else if(tableView.tag==1001)
        section = self.FAQ_login_section_array[indexPath.section][@"section_dic"];
    else
        section = self.FAQ_download_section_array[indexPath.section][@"section_dic"];
    
    
    NSNumber* num = nil;
    if(tableView.tag==1000)
        num = self.FAQ_event_section_array[indexPath.section][@"section_open"];
    else if(tableView.tag==1001)
        num = self.FAQ_login_section_array[indexPath.section][@"section_open"];
    else
        num = self.FAQ_download_section_array[indexPath.section][@"section_open"];
    
    if(indexPath.row==0)
    {
        NSMutableDictionary* dict = [NSMutableDictionary new];
        [dict setObject:[NSNumber numberWithInteger:tableView.tag] forKey:@"tableViewtag"];
        [dict setObject:[NSNumber numberWithInteger:indexPath.section] forKey:@"sectionindex"];
        
        [self changeSectionopen:dict clickType:!num.boolValue];
        //显示问题 title lable cell
        EGFAQTitleCell *cell = [EGFAQTitleCell cellWithUITableView:tableView];
        [cell setbtstate:num.boolValue];
        [cell setupWithInfo:section sectioninfo:dict];
    }
}


@end
