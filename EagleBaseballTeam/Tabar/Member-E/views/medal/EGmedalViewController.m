//
//  ViewController.m
//  music
//
//  Created by Dragon_Zheng on 2/5/25.
//

#import "EGmedalViewController.h"
#import "LXYHyperlinksButton.h"
#import "EGFanMemberInfoCell.h"
#import "EGShowMusicTextView.h"
#import "EGmedalCollectionViewCell.h"
#import "UICustomSlider.h"
#import "EGmedalDetailView.h"
@interface EGmedalViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) UIView *baseview;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *fansmusicView;
@property (nonatomic, strong) UIView *wingstarsView;
@property (nonatomic, strong) UIView *fansquanView;

@property (nonatomic, strong) LXYHyperlinksButton *fansmusic_bt;
@property (nonatomic, strong) LXYHyperlinksButton *wingstars_bt;
@property (nonatomic, strong) LXYHyperlinksButton *fansquan_bt;
@property (nonatomic, weak) UITableView* MtableView;
@property (nonatomic, strong)UICollectionView *fansView;

@property (nonatomic, assign)NSString* memberQRCode;
@end

@implementation EGmedalViewController
@synthesize Mainarray;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"成就勳章";
    
    self.type = 0;
    
    
    [self setupUI];
    [self initgirlInfo];
    
}

-(NSMutableArray*)girlArray
{
    if (!_girlArray) {
        _girlArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _girlArray;
}

-(void)getEncryptedIdentityString
{
    UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
    if (!model) {
        return;
    }

    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
    NSDictionary *dict_header = @{@"Authorization":tokenString};

    MemberInfomationModel *infoModel = [EGLoginUserManager getMemberInfomation];
        if (!infoModel) {
            return;
        }
    NSDictionary *dict_body = @{@"Mobile":infoModel.Phone};

    [[WAFNWHTTPSTool sharedManager] postWithURL:[EGServerAPI basicMemberGenqrcode:model.ID] parameters:dict_body headers:dict_header success:^(NSDictionary * _Nonnull response) {
        if (![response isKindOfClass:[NSDictionary class]]) {

            [MBProgressHUD showDelayHidenMessage:@"數據格式錯誤"];
            return;
        }
        NSDictionary *data = [response objectOrNilForKey:@"data"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            [MBProgressHUD showDelayHidenMessage:@"數據格式錯誤"];
            return;
        }
        
        NSString *qrCode =  [data objectOrNilForKey:@"MEMQRCODE"];
        if (!qrCode || ![qrCode isKindOfClass:[NSString class]]) {
            [MBProgressHUD showDelayHidenMessage:@"數據格式錯誤"];
            return;
        }
        
        self.memberQRCode = qrCode;
        [self getMedalInfo];
        
        
    } failure:^(NSError * _Nonnull error) {
        if ([error.localizedDescription containsString:@"offline"] || error.code == -1009) {
            [MBProgressHUD showDelayHidenMessage:@"請檢查您的網路連線，確保裝置已連接至網路後再重試。"];
        }else{
            [MBProgressHUD showDelayHidenMessage:error.localizedDescription];
        }
    }];
}

-(void)getMedalInfo
{
    NSString *url2 = [EGServerAPI getMetelInfo:self.memberQRCode];
    
    [[WAFNWHTTPSTool sharedManager] getWithURL:url2 parameters:@{} headers:@{} success:^(NSDictionary * _Nonnull response) {
        [self.girlArray removeAllObjects];
        [self MergeInfo:(NSArray*)response];
        [self.fansView reloadData];
        } failure:^(NSError * _Nonnull error) {
            if (error) {
                NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                if (errorData) {
                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:&error];
                    NSString *message = dictionary[@"message"];
                    [MBProgressHUD showDelayHidenMessage:message];
                }else{
                    [MBProgressHUD showDelayHidenMessage:error.localizedDescription];
                }
            }
        }];
}

//将server数据 Merge到 本地数据结构中
-(void)MergeInfo:(NSArray*)array
{
    for(int i=0;i<array.count;i++)
    {
        NSDictionary *serverinfo = [array objectAtIndex:i];
        
        NSString *ser_type = [serverinfo objectForKey:@"displayMode"];
        NSMutableDictionary *medalInfo = [NSMutableDictionary new];
        [medalInfo setObject:[serverinfo objectForKey:@"name"] forKey:@"metelName"];
        [medalInfo setObject:[serverinfo objectForKey:@"description"] forKey:@"metelReason"];
        
        [medalInfo setObject:[serverinfo objectForKey:@"condition"] forKey:@"metelcondition"];
        [medalInfo setObject:ser_type forKey:@"meteldisplayMode"];
        
        NSString* currentProgress = [serverinfo objectForKey:@"progress"];;
        [medalInfo setObject:currentProgress forKey:@"metelprogress_current"];
        [medalInfo setObject:currentProgress forKey:@"meteltimes"];//获取当前显示次数
        NSArray* total = [serverinfo objectForKey:@"thresholds"];
        [medalInfo setObject:total forKey:@"metelprogress_total"];//取threshold 最后阶段的数值，就是最大值
        
        //是否要显示进度条
        if([ser_type isEqualToString:@"initial"])
        {
            //第一个节点不需要用displayMode判断，直接不用显示进度条
            [medalInfo setObject:@"0" forKey:@"metelprogress"];
        }
        else{
            if([ser_type isEqualToString:@"count"]){
                [medalInfo setObject:@"0" forKey:@"metelprogress"];//count 不需要显示进度条
            }
            else{
                [medalInfo setObject:@"1" forKey:@"metelprogress"];//ratio 显示进度条
            }
            
        }
        
        NSMutableString *imageString = [NSMutableString new];
        if([[serverinfo objectForKey:@"condition"] isEqualToString:@"initial"])
        {
            [imageString appendString:[serverinfo objectForKey:@"code"]];
        }
        else
        {
            if([[serverinfo objectForKey:@"displayMode"] isEqualToString:@"count"])
            {
                NSInteger current = [currentProgress intValue];
                NSArray* tatalA = total;
                NSInteger count = tatalA.count;
                
                NSInteger total = [[tatalA objectAtIndex:count-1] intValue];
                if(current<total)
                {
                    [imageString appendString:[serverinfo objectForKey:@"code"]];
                    [imageString appendString:@"_gray"];
                }
                else
                {
                    [imageString appendString:[serverinfo objectForKey:@"code"]];
                }
            }
            else
            {
                NSRange range = [[serverinfo objectForKey:@"code"] rangeOfString:@"CHECKIN"];
                if (range.location != NSNotFound) {
                    //絕對忠誠, 需要换图，有进度条的情况，需要拿thredhold 来做判断。
                    NSInteger current = [currentProgress intValue];
                    if(current==0){
                        [imageString appendString:[serverinfo objectForKey:@"code"]];
                        [imageString appendString:@"_gray"];
                    }
                    
                    if(current>=1&&current<30)
                    {
                        [imageString appendString:[serverinfo objectForKey:@"code"]];
                        [imageString appendString:@"_0"];
                    }
                    
                    if(current>=30&&current<=49)
                    {
                        [imageString appendString:[serverinfo objectForKey:@"code"]];
                        [imageString appendString:@"_1"];
                    }
                    
                    if(current>=50)
                    {
                        [imageString appendString:[serverinfo objectForKey:@"code"]];
                        [imageString appendString:@"_2"];
                    }
                }
                else
                {
                    NSInteger current = [currentProgress intValue];
                    NSArray* tatalA = total;
                    NSInteger count = tatalA.count;
                    
                    NSInteger total = [[tatalA objectAtIndex:count-1] intValue];
                    if(current<total)
                    {
                        [imageString appendString:[serverinfo objectForKey:@"code"]];
                        [imageString appendString:@"_gray"];
                    }
                    else
                    {
                        [imageString appendString:[serverinfo objectForKey:@"code"]];
                    }
                }
                
            }
        }
        
        
        [medalInfo setObject:imageString forKey:@"metelimage"];
        
        [self.girlArray addObject:medalInfo];
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    self.navigationController.navigationBar.backgroundColor = rgba(0, 71, 56, 1);
}

-(void)initgirlInfo
{
    NSString *path = @"";
    NSData *data = NULL;
    switch (self.type) {
        case 0:{
//            path = [[NSBundle mainBundle] pathForResource:@"metel_lichengbei" ofType:@"json"];
//            data = [NSData dataWithContentsOfFile:path];
//            self.girlArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
//            self.girlArray = [self inorderArray];
        //[self getEncryptedIdentityString];
            [self.fansView.mj_header beginRefreshing];
        }
            break;
            
        case 1:{
            path = [[NSBundle mainBundle] pathForResource:@"metel_mofan" ofType:@"json"];
            data = [NSData dataWithContentsOfFile:path];
            self.girlArray = [NSMutableArray arrayWithArray:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil]];;
        }
            break;
            
        case 2:{
            path = [[NSBundle mainBundle] pathForResource:@"metel_xunzhang" ofType:@"json"];
            data = [NSData dataWithContentsOfFile:path];
            self.girlArray = [NSMutableArray arrayWithArray:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil]];;
        }
            break;
       
            
    }
    
   
}


- (UITableView *)settableView
{
   if (self.MtableView == nil) {
    
       if (@available(iOS 13.0, *)) {
           UITableView *tableView2 = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
           tableView2.delegate = self;
           tableView2.dataSource = self;
           tableView2.backgroundColor = rgba(245, 245, 245, 1);
           
           tableView2.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
           tableView2.showsVerticalScrollIndicator = NO;
           tableView2.estimatedRowHeight = 100;
           self.MtableView = tableView2;
           [self.fansmusicView addSubview:self.MtableView];
       } else {
           // Fallback on earlier versions
       }
   
    
}
return self.MtableView;
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
    
    LXYHyperlinksButton *bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(0, 0, 100, 36)];
    bt.tag = 50001;
    [bt setTitle:@"里程碑" forState:UIControlStateNormal];
    bt.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    [bt setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateSelected];
    [bt setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
    [bt setSelected:YES];
    [bt addTarget:self action:@selector(buttonclick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.topView addSubview:bt];
    [bt setColor:rgba(0, 122, 96, 1)];
    self.fansmusic_bt = bt;
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ScaleW(20));
            make.top.mas_equalTo(ScaleW(5));
            make.width.mas_equalTo((ScaleW(45)));
            make.height.mas_equalTo(ScaleW(50));
        }];
    
    bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(0, 0, 100, 36)];
    bt.tag = 50002;
    [bt setTitle:@"模範生" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(buttonclick:) forControlEvents:(UIControlEventTouchUpInside)];
    bt.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    [bt setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateSelected];
    [bt setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
    [bt setSelected:NO];
    [self.topView addSubview:bt];
    [bt setColor:rgba(0, 122, 96, 1)];
    self.wingstars_bt = bt;
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.fansmusic_bt.mas_right).offset(ScaleW(20));
            make.top.mas_equalTo(ScaleW(5));
            make.width.mas_equalTo((ScaleW(45)));
            make.height.mas_equalTo(ScaleW(50));
        }];
   
    
    
    bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(0, 0, 100, 36)];
    bt.tag = 50003;
    [bt setTitle:@"城市勳章" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(buttonclick:) forControlEvents:(UIControlEventTouchUpInside)];
    bt.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    [bt setTitleColor:rgba(23, 23, 23, 1) forState:UIControlStateSelected];
    [bt setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
    [bt setSelected:NO];
    [self.topView addSubview:bt];
    [bt setColor:rgba(0, 122, 96, 1)];
    self.fansquan_bt = bt;
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.wingstars_bt.mas_right).offset(ScaleW(20));
            make.top.mas_equalTo(ScaleW(5));
            make.width.mas_equalTo((ScaleW(60)));
            make.height.mas_equalTo(ScaleW(50));
        }];
    
    [self.fansquan_bt setColor:[UIColor clearColor]];
    [self.wingstars_bt setColor:[UIColor clearColor]];
    self.wingstars_bt.hidden = YES;
    self.fansquan_bt.hidden = YES;
    self.fansmusic_bt.hidden = YES;
    
    self.topView.hidden = YES;
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.wingstars_bt).offset(0);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(1.5);
    }];
    
    
    //里程碑页面
    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, Device_Height-[UIDevice de_navigationFullHeight])];
    firstView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:firstView];
//    [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(Device_Width);
//        make.height.mas_equalTo(Device_Height-[UIDevice de_navigationFullHeight]);
//        make.left.mas_equalTo(0);
//        //make.top.mas_equalTo(lineView).offset(ScaleW(0));
//        make.top.mas_equalTo(ScaleW(30));
//    }];
    self.fansmusicView = firstView;
    
    //模范生 页面
    firstView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, Device_Height-ScaleW(45))];
    [self.view addSubview:firstView];
    [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(Device_Width);
        make.height.mas_equalTo(Device_Height-[UIDevice de_navigationFullHeight]);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(lineView).offset(ScaleW(0));
    }];
    self.wingstarsView = firstView;
    self.wingstarsView.hidden = YES;
    
    //城市勋章界面
    firstView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, Device_Height-ScaleW(45))];
    
    [self.view addSubview:firstView];
    [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(Device_Width);
        make.height.mas_equalTo(Device_Height-ScaleW(45));
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(lineView).offset(ScaleW(0));
    }];
    self.fansquanView = firstView;
    self.fansquanView.hidden = YES;
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;//竖直滚动
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor=rgba(245, 245, 245, 1);;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [self.fansmusicView addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.top.mas_equalTo(self.topView.mas_bottom).offset(ScaleW(5));
            make.top.mas_equalTo(ScaleW(0));
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        [collectionView registerClass:[EGmedalCollectionViewCell class] forCellWithReuseIdentifier:@"EGmedalCollectionViewCell"];
        self.fansView = collectionView;
        self.fansView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getEncryptedIdentityString];
        [self.fansView.mj_header endRefreshing];
        }];
    
    
}

-(void)buttonclick:(UIButton*)bt
{
    [self.fansquan_bt setColor:[UIColor clearColor]];
    [self.fansmusic_bt setColor:[UIColor clearColor]];
    [self.wingstars_bt setColor:[UIColor clearColor]];
    
    self.fansquanView.hidden = YES;
    self.fansmusicView.hidden = YES;
    self.wingstarsView.hidden = YES;
    
    [self.fansquan_bt setSelected:NO];
    [self.fansmusic_bt setSelected:NO];
    [self.wingstars_bt setSelected:NO];
    
    
    switch (bt.tag) {
        case 50001:
        {
            [self.fansmusic_bt setSelected:YES];
            [self.fansmusic_bt setColor:rgba(0, 122, 96, 1)];
            self.fansmusicView.hidden = NO;
            
            self.type = 0;
            [self initgirlInfo];
        }
            break;
        case 50002:
        {
            [self.wingstars_bt setSelected:YES];
            [self.wingstars_bt setColor:rgba(0, 122, 96, 1)];
            self.wingstarsView.hidden = NO;
            self.type = 1;
            [self initgirlInfo];
        }
            break;
        case 50003:
        {
            [self.fansquan_bt setSelected:YES];
            [self.fansquan_bt setColor:rgba(0, 122, 96, 1)];
            self.fansquanView.hidden = NO;
            self.type = 2;
            [self initgirlInfo];
        }
            break;
       
    }
    [self.fansView reloadData];
    
}

-(NSArray*)inorderArray
{
    NSArray *sortedArray;
        return sortedArray = [self.self.girlArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSInteger valueA = [a[@"girlNO"] integerValue];
            NSInteger valueB = [b[@"girlNO"] integerValue];
            return valueA > valueB;
        }];
}

- (CGFloat)calculateTextViewHeightForText:(NSString *)text textViewWidth:(CGFloat)width {
    // 设置文本属性
    NSDictionary *attributes = @{
        NSFontAttributeName: /*[UIFont systemFontOfSize:15]*/[UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular], // 字体和字号
        NSParagraphStyleAttributeName: [NSParagraphStyle defaultParagraphStyle] // 段落样式，可自定义行间距等
    };
    
    // 计算文本在给定宽度下的高度
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil].size;
    
    // 返回计算出的高度
    return ceilf(size.height); // 使用ceilf函数确保高度为整数
}

-(NSString*)getTypeString:(NSInteger)meteltype
{
    NSString *string = @"";
    if(self.type==0){
        switch (meteltype) {
            case 0:
            {
                string = @"APP簽到1次";
            }
                break;
            case 1:
                string = @"主場觀賽0次";
                break;
            case 2:
                string = @"參加應援0次";
                break;
            case 3:
                string = @"球場簽到0次";
                break;
                
            default:
                break;
        }
    }
    else if(self.type==1)
    {
        string = @"累計簽到%d次";
    }
    else
    {
        string = @"";
    }
        
    return string;
}


#pragma  mark collection View
#pragma mark delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.girlArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    EGmedalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EGmedalCollectionViewCell" forIndexPath:indexPath];
    
    cell.imageView.hidden = YES;
    cell.name_label.hidden = YES;
    cell.status_label.hidden = YES;
    cell.status.hidden = YES;
    cell.percent_label.hidden = YES;
    
    self.girldic = [self.girlArray objectAtIndex:indexPath.item];
    switch (self.type) {
        case 0:
        {
            NSString *string = [self.girldic objectForKey:@"metelprogress"];
            NSInteger isprogress = string.intValue;
            
            if(isprogress==0)
                {
                    cell.percent_label.text = [NSString stringWithFormat:@"%d 次",[[self.girldic objectForKey:@"meteltimes"] intValue]];
                    if (indexPath.item == 0) {
                        cell.percent_label.hidden = true;
                    }else{
                        cell.percent_label.hidden = NO;//第三行
                    }
                }
                else
                {
                    NSRange range = [[self.girldic objectForKey:@"metelimage"] rangeOfString:@"CHECKIN"];
                    if (range.location != NSNotFound) {
                        cell.status.hidden = NO;
                        cell.percent_label.hidden = NO;
                        
                        NSArray* totalArray =  [self.girldic objectForKey:@"metelprogress_total"];
                        float current =  [[self.girldic objectForKey:@"metelprogress_current"] floatValue];
                        NSInteger total = 0;
                        if(current==0){
                            total = [[totalArray objectAtIndex:0] intValue];
                        }
                        
                        if(current>=1&&current<30)
                        {
                            total = [[totalArray objectAtIndex:1] intValue];
                        }
                        
                        if(current>=30&&current<=49)
                        {
                            total = [[totalArray objectAtIndex:2] intValue];
                        }
                        
                        if(current>=50)
                        {
                            current = 50;
                            total = [[totalArray objectAtIndex:2] intValue];
                        }
                        
                        NSString *string = [NSString stringWithFormat:@"%d / %d",(int)current,(int)total];
                        
                        float rate = current / total;
                        cell.rate = rate;
                        
                        [cell setprogress:YES];
                        
                        cell.percent_label.text = string;
                        
                        
                    }
                    else
                    {
                        cell.status.hidden = NO;
                        cell.percent_label.hidden = NO;
                        NSArray* totalA =  [self.girldic objectForKey:@"metelprogress_total"];
                        NSInteger count = totalA.count;
                        
                        float total =  [[totalA objectAtIndex:count-1] intValue];
                        float cur =  [[self.girldic objectForKey:@"metelprogress_current"] floatValue];
                        
                        if(cur>=total)
                            cur = total;
                        
                        NSString *string = [NSString stringWithFormat:@"%d / %d",(int)cur,(int)total];
                        
                        float rate = cur / total;
                        cell.rate = rate;
                        
                        [cell setprogress:YES];
                        
                        cell.percent_label.text = string;
                    }
                }
            
            
            cell.imageView.hidden = NO;
            cell.name_label.hidden = NO;//原因String，第二行
            cell.status_label.hidden = NO;// 第一行
            
            
            cell.name_label.text = [self.girldic objectForKey:@"metelReason"];
            cell.status_label.text = [self.girldic objectForKey:@"metelName"];
            
            cell.imageView.image = [UIImage imageNamed:[self.girldic objectForKey:@"metelimage"]];
            
        }
            break;
        case 1:
        {
            cell.imageView.hidden = NO;
            cell.name_label.hidden = NO;
            cell.status_label.hidden = NO;
            cell.percent_label.hidden = NO;
            
            float total =  [[self.girldic objectForKey:@"metelprogress_total"] floatValue];
            float cur =  [[self.girldic objectForKey:@"metelprogress_current"] floatValue];
            
            NSString *string = [NSString stringWithFormat:@"%d / %d",(int)cur,(int)total];
            
            float rate = cur / total;
            cell.rate = rate;
            cell.status.hidden = NO;
            
            [cell setprogress:YES];
            

            NSString *string_ = [NSString stringWithFormat:[self getTypeString:[[self.girldic objectForKey:@"meteltype"] intValue]],(int)cur];
            cell.name_label.text = string_;
            cell.status_label.text = [self.girldic objectForKey:@"metelName"];
            cell.percent_label.text = string;
            
            NSString* indext = [NSString stringWithFormat:@"%d_%d",(int)self.type+1,(int)indexPath.item+1];
            cell.imageView.image = [UIImage imageNamed:indext];
            
        }
            break;
        case 2:
        {
            cell.imageView.hidden = NO;
            cell.status_label.hidden = NO;
            
            cell.status_label.text = [self.girldic objectForKey:@"metelName"];
            NSString* indext = [NSString stringWithFormat:@"%d_%d",(int)self.type+1,(int)indexPath.item+1];
            cell.imageView.image = [UIImage imageNamed:indext];
        }
            break;
        
    }
    
        
    return cell;
}
//选中 collectionView
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.girlArray objectAtIndex:indexPath.item];
    

    NSMutableDictionary *info = [NSMutableDictionary new];
    NSString* reason = [dic objectForKey:@"metelReason"];
    [info setObject:reason forKey:@"reason"];
    
    NSString *stringWithoutSpaces;
    NSRange range = [[dic objectForKey:@"metelimage"] rangeOfString:@"CHECKIN"];
    if (range.location != NSNotFound)
    {
        stringWithoutSpaces = [dic objectForKey:@"metelimage"];
    }
    else
    {
        stringWithoutSpaces = [[dic objectForKey:@"metelimage"] stringByReplacingOccurrencesOfString:@"_gray" withString:@""];
    }

    [info setObject:[UIImage imageNamed:stringWithoutSpaces] forKey:@"IMG"];
    
#ifdef autoTextHeight
    EGmedalDetailView *picker = [[EGmedalDetailView alloc] initWithObject:[self calculateTextViewHeightForText:reason textViewWidth:ScaleW(350)] + ScaleW(25)];
#else
    EGmedalDetailView *picker = [[EGmedalDetailView alloc] init];
#endif
    
    
    picker.dicinfo = info;
    picker.gBlock = ^(NSMutableDictionary* dic){
        
    } ;
    [picker updateUI];
    [picker popPickerView];
    
    
}
// 设置cell大小 itemSize：可以给每一个cell指定不同的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = /*(collectionView.bounds.size.width)*/Device_Width / 3;
    CGFloat height = width * 1.57;
    return CGSizeMake(width,height);
    
}
// 设置UIcollectionView整体的内边距（这样item不贴边显示）
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    // 上 左 下 右
//    return UIEdgeInsetsMake(ScaleW(20),0,0,0);
//}
// 设置minimumLineSpacing：cell上下之间最小的距离(一行左右间距)
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return ScaleW(10);
    return 0;
}
// 设置minimumInteritemSpacing：cell左右之间最小的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

@end
