//
//  ViewController.m
//  music
//
//  Created by Dragon_Zheng on 2/5/25.
//

#import "EGPlayerDetailViewController.h"
#import <WebKit/WebKit.h>
@interface EGPlayerDetailViewController ()<WKNavigationDelegate>

@property (nonatomic,strong)UIView *baseView;//总界面

//最上面界面
@property (nonatomic,strong)UIImageView *girlView;
@property (nonatomic,strong)UIView *buttonView;
@property (nonatomic,strong)UILabel *Nolable_inImage;
@property (nonatomic,strong)UILabel *Namelable_inImage;
@property (nonatomic,strong)UILabel *SecondNamelable_inImage;



@property (nonatomic,strong)LXYHyperlinksButton* playerinfobt;
@property (nonatomic,strong)LXYHyperlinksButton* playerresultbt;


@property (nonatomic,strong)UIView *baseplayerinfoView;
@property (nonatomic,strong)UIView *baseplayerresultView;
//个人资料界面元素

@property (nonatomic,strong)UIImageView *showgirlView;

@property (nonatomic,strong)UILabel *playerxiguanTitle;
@property (nonatomic,strong)UILabel *playerxiguanContent;
@property (nonatomic,strong)UILabel *playerheightTitle;
@property (nonatomic,strong)UILabel *playerheightContent;
@property (nonatomic,strong)UILabel *playerweightTitle;
@property (nonatomic,strong)UILabel *playerweightContent;
@property (nonatomic,strong)UILabel *girlBirthdayTitle;
@property (nonatomic,strong)UILabel *girlBirthdayContent;
@property (nonatomic,strong)UILabel *playerfirstinTitle;
@property (nonatomic,strong)UILabel *playerfirstinContent;
@property (nonatomic,strong)UILabel *playerstudyTitle;
@property (nonatomic,strong)UILabel *playerstudyContent;

@property (nonatomic,strong)UIImageView *line1View;
@property (nonatomic,strong)UIImageView *line2View;
@property (nonatomic,strong)UIImageView *line3View;
@property (nonatomic,strong)UIImageView *line4View;
@property (nonatomic,strong)UIImageView *line5View;
@property (nonatomic,strong)UIImageView *line6View;


//个人成绩页面元素
@property (nonatomic,strong)UIImageView *playerresultview;
@property (nonatomic,strong)WKWebView* personresultWebView;
@property (nonatomic,strong)NSString *personresultURL;

@property (nonatomic,strong)UIButton *facebookbt;
@property (nonatomic,strong)UIButton *twtiterbt;

@property (nonatomic,strong)NSTimer *closeTimer;
@end

@implementation EGPlayerDetailViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //base view 上面固定的两个界面
    [self setupTopUI];
    [self setbuttonUI];
    
    
    [self setplayerinfoUI];
    [self setplayerresultUI];
    //[self getInfo];
    [self setInfo:self.girlDetailinfo];
    
}

//TopView
-(void)setupTopUI
{
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, Device_Height)];
    bView.backgroundColor = rgba(245, 245, 245, 1);
    [self.view addSubview:bView];
    self.baseView = bView;
    
    UIImageView *gView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 20)];
    
    gView.image = [UIImage imageNamed:@"playerbackimage"];
    [self.baseView addSubview:gView];
    [gView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(ScaleW(242));
        make.width.mas_equalTo(Device_Width);
    }];
    self.girlView = gView;
    
    //个人图片上面显示4个信息
    gView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 20)];
    gView.contentMode = UIViewContentModeScaleAspectFit;
    [ self.girlView addSubview:gView];
    [gView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(0));
        make.right.mas_equalTo(-ScaleW(0));
        make.height.mas_equalTo(ScaleW(242));
        make.width.mas_equalTo(ScaleW(220));
    }];
    self.showgirlView = gView;
    //self.showgirlView.hidden = YES;
    
    UILabel *labelinimage = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], 40, 67)];
    //labelinimage.backgroundColor=UIColor.purpleColor;
    labelinimage.textColor = [UIColor colorWithRed:0 green:0.278 blue:0.22 alpha:1];
    labelinimage.font = [UIFont boldSystemFontOfSize:FontSize(40)];
    [self.girlView addSubview:labelinimage];
    [labelinimage mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.centerX.mas_equalTo(self.girlView.mas_centerX).offset(ScaleW(-70));
        //        make.centerY.mas_equalTo(self.girlView.mas_centerY);
        make.top.mas_equalTo(ScaleW(91));
        make.left.mas_equalTo(ScaleW(28));
        make.height.mas_equalTo(ScaleW(67));
        make.width.mas_equalTo(ScaleW(80));
    }];
    self.Nolable_inImage = labelinimage;
    
    
    labelinimage = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], 72, 34)];
    //labelinimage.backgroundColor=UIColor.yellowColor;
    labelinimage.textColor = [UIColor colorWithRed:0 green:0.278 blue:0.22 alpha:1];
    labelinimage.font = [UIFont systemFontOfSize:FontSize(20)];
    [self.girlView addSubview:labelinimage];
    [labelinimage mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.mas_equalTo(self.Nolable_inImage.mas_top);
        //        make.centerX.mas_equalTo(self.girlView.mas_centerX).offset(ScaleW(40));
        make.top.mas_equalTo(ScaleW(158));
        make.left.mas_equalTo(ScaleW(28));
        make.height.mas_equalTo(ScaleW(34));
        make.width.mas_equalTo(ScaleW(150));
    }];
    self.Namelable_inImage = labelinimage;
    
    labelinimage = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], 63, 22)];
    //labelinimage.backgroundColor=UIColor.redColor;
    labelinimage.textColor = [UIColor colorWithRed:0 green:0.278 blue:0.22 alpha:1];
    labelinimage.font = [UIFont systemFontOfSize:FontSize(16)];
    [self.girlView addSubview:labelinimage];
    [labelinimage mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.mas_equalTo(self.Namelable_inImage.mas_bottom).offset(ScaleW(10));
        //        make.centerX.mas_equalTo(self.girlView.mas_centerX).offset(ScaleW(35));
        make.top.mas_equalTo(self.Namelable_inImage.mas_bottom);
        make.left.mas_equalTo(ScaleW(28));
        make.height.mas_equalTo(ScaleW(22));
        make.width.mas_equalTo(ScaleW(80));
    }];
    self.SecondNamelable_inImage = labelinimage;
}

-(void)setbuttonUI
{
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, 50)];
    bView.backgroundColor = UIColor.whiteColor;
    [self.baseView addSubview:bView];
    [bView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.girlView.mas_bottom);
        make.left.mas_equalTo(ScaleW(0));
        make.height.mas_equalTo(ScaleW(51));
        make.width.mas_equalTo(Device_Width);
    }];
    self.buttonView = bView;
    
    LXYHyperlinksButton *bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(0, 0, 100, 36)];
    bt.tag = 80001;
    [bt setTitle:@"基本資料" forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(buttonclick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.buttonView addSubview:bt];
    [bt setColor:rgba(0, 122, 96, 1)];
    self.playerinfobt = bt;
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(Device_Width/2);
        make.height.mas_equalTo(ScaleW(50));
    }];
    
    
    bt = [[LXYHyperlinksButton alloc] initWithFrame:CGRectMake(0, 0, 100, 36)];
    bt.tag = 80002;
    [bt setTitle:@"個人成績" forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(buttonclick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.buttonView addSubview:bt];
    [bt setColor:rgba(0, 122, 96, 1)];
    self.playerresultbt = bt;
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.playerinfobt.mas_right);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(Device_Width/2);
        make.height.mas_equalTo(ScaleW(50));
    }];
    
    [self.playerresultbt setColor:UIColor.whiteColor];
    
}


-(void)setplayerinfoUI
{
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, Device_Height)];
    bView.backgroundColor = rgba(245, 245, 245, 1);
    [self.view addSubview:bView];
    self.baseplayerinfoView = bView;
    [bView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.playerinfobt.mas_bottom);
        make.left.mas_equalTo(ScaleW(0));
        make.width.mas_equalTo(Device_Width);
        make.height.mas_equalTo(Device_Height - [UIDevice de_navigationFullHeight]-self.girlView.height-self.playerinfobt.height);
    }];
    
    //Name
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 22)];
    name.text = @"投打習慣";
    name.font = [UIFont systemFontOfSize:FontSize(16)];
    name.textColor = rgba(113,113,122,1);
    [self.baseplayerinfoView addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.buttonView.mas_bottom).offset(ScaleW(40));
        make.left.mas_equalTo(ScaleW(60));
        make.height.mas_equalTo(ScaleW(ScaleW(22)));
        make.width.mas_equalTo(ScaleW(160));
    }];
    self.playerxiguanTitle = name;
    
    name = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 22)];
    name.font = [UIFont boldSystemFontOfSize:FontSize(16)];
    name.text = @"";
    [self.baseplayerinfoView addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.buttonView.mas_bottom).offset(ScaleW(40));
        make.left.mas_equalTo(ScaleW(220));
        make.height.mas_equalTo(ScaleW(22));
        make.width.mas_equalTo(ScaleW(120));
    }];
    self.playerxiguanContent = name;
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 1)];
    line.backgroundColor = rgba(232, 232, 232, 1);
    [self.baseplayerinfoView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.self.playerxiguanTitle.mas_bottom).offset(ScaleW(10));
        make.left.mas_equalTo(ScaleW(20));
        make.height.mas_equalTo(ScaleW(1));
        make.width.mas_equalTo(Device_Width-40);
    }];
    self.line1View = line;
    //End Name
    
    //height
    name = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 22)];
    name.text = @"身高";
    name.font = [UIFont systemFontOfSize:FontSize(16)];
    name.textColor = rgba(113,113,122,1);
    [self.baseplayerinfoView addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line1View.mas_bottom).offset(ScaleW(10));
        make.left.mas_equalTo(ScaleW(60));
        make.height.mas_equalTo(ScaleW(22));
        make.width.mas_equalTo(ScaleW(60));
    }];
    self.playerheightTitle = name;
    
    name = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 22)];
    name.font = [UIFont boldSystemFontOfSize:FontSize(16)];
    name.text = @"";
    [self.baseplayerinfoView addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line1View.mas_bottom).offset(ScaleW(10));
        make.left.mas_equalTo(ScaleW(220));
        make.height.mas_equalTo(ScaleW(22));
        make.width.mas_equalTo(ScaleW(120));
    }];
    self.playerheightContent = name;
    
    line = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 1)];
    line.backgroundColor = rgba(232, 232, 232, 1);
    [self.baseplayerinfoView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.self.playerheightContent.mas_bottom).offset(ScaleW(10));
        make.left.mas_equalTo(ScaleW(20));
        make.height.mas_equalTo(ScaleW(1));
        make.width.mas_equalTo(Device_Width-40);
    }];
    self.line2View = line;
    //End SeceondName
    
    //weight
    name = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 22)];
    name.text = @"體重";
    name.font = [UIFont systemFontOfSize:FontSize(16)];
    name.textColor = rgba(113,113,122,1);
    [self.baseplayerinfoView addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line2View.mas_bottom).offset(ScaleW(10));
        make.left.mas_equalTo(ScaleW(60));
        make.height.mas_equalTo(ScaleW(22));
        make.width.mas_equalTo(ScaleW(60));
    }];
    self.playerweightTitle = name;
    
    name = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 22)];
    name.font = [UIFont boldSystemFontOfSize:FontSize(16)];
    name.text = @"";
    [self.baseplayerinfoView addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line2View.mas_bottom).offset(ScaleW(10));
        make.left.mas_equalTo(ScaleW(220));
        make.height.mas_equalTo(ScaleW(22));
        make.width.mas_equalTo(ScaleW(120));
    }];
    self.playerweightContent = name;
    
    line = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 1)];
    line.backgroundColor = rgba(232, 232, 232, 1);
    [self.baseplayerinfoView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.self.playerweightContent.mas_bottom).offset(ScaleW(10));
        make.left.mas_equalTo(ScaleW(20));
        make.height.mas_equalTo(ScaleW(1));
        make.width.mas_equalTo(Device_Width-40);
    }];
    self.line3View = line;
    //End SeceondName
    
    
    //birthday
    name = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 22)];
    name.text = @"生日";
    name.font = [UIFont systemFontOfSize:FontSize(16)];
    name.textColor = rgba(113,113,122,1);
    [self.baseplayerinfoView addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line3View.mas_bottom).offset(ScaleW(10));
        make.left.mas_equalTo(ScaleW(60));
        make.height.mas_equalTo(ScaleW(22));
        make.width.mas_equalTo(ScaleW(60));
    }];
    self.girlBirthdayTitle = name;
    
    name = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 22)];
    name.font = [UIFont boldSystemFontOfSize:FontSize(16)];
    name.text = @"";
    [self.baseplayerinfoView addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line3View.mas_bottom).offset(ScaleW(10));
        make.left.mas_equalTo(ScaleW(220));
        make.height.mas_equalTo(ScaleW(22));
        make.width.mas_equalTo(ScaleW(120));
    }];
    self.girlBirthdayContent = name;
    
    line = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 1)];
    line.backgroundColor = rgba(232, 232, 232, 1);
    [self.baseplayerinfoView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.self.girlBirthdayContent.mas_bottom).offset((10));
        make.left.mas_equalTo(ScaleW(20));
        make.height.mas_equalTo(ScaleW(1));
        make.width.mas_equalTo(Device_Width-40);
    }];
    self.line4View = line;
    
    //初登场
    name = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 22)];
    name.text = @"初登場";
    name.font = [UIFont systemFontOfSize:FontSize(16)];
    name.textColor = rgba(113,113,122,1);
    [self.baseplayerinfoView addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line4View.mas_bottom).offset(ScaleW(10));
        make.left.mas_equalTo(ScaleW(60));
        make.height.mas_equalTo(ScaleW(22));
        make.width.mas_equalTo(ScaleW(60));
    }];
    self.playerfirstinTitle = name;
    
    name = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 22)];
    name.font = [UIFont boldSystemFontOfSize:FontSize(16)];
    name.text = @"";
    [self.baseplayerinfoView addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line4View.mas_bottom).offset(ScaleW(10));
        make.left.mas_equalTo(ScaleW(220));
        make.height.mas_equalTo(ScaleW(22));
        make.width.mas_equalTo(ScaleW(120));
    }];
    self.playerfirstinContent = name;
    
    line = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 1)];
    line.backgroundColor = rgba(232, 232, 232, 1);
    [self.baseplayerinfoView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.self.playerfirstinContent.mas_bottom).offset(ScaleW(10));
        make.left.mas_equalTo(ScaleW(20));
        make.height.mas_equalTo(ScaleW(1));
        make.width.mas_equalTo(Device_Width-40);
    }];
    self.line5View = line;
    
    
    //學歷
    name = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 22)];
    name.text = @"學歷";
    name.font = [UIFont systemFontOfSize:FontSize(16)];
    name.textColor = rgba(113,113,122,1);
    [self.baseplayerinfoView addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line5View.mas_bottom).offset(ScaleW(10));
        make.left.mas_equalTo(ScaleW(60));
        make.height.mas_equalTo(ScaleW(22));
        make.width.mas_equalTo(ScaleW(60));
    }];
    self.playerstudyTitle = name;
    
    name = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 22)];
    name.font = [UIFont boldSystemFontOfSize:FontSize(16)];
    name.text = @"";
    [self.baseplayerinfoView addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line5View.mas_bottom).offset(ScaleW(10));
        make.left.mas_equalTo(ScaleW(220));
        make.height.mas_equalTo(ScaleW(22));
        make.width.mas_equalTo(ScaleW(120));
    }];
    self.playerstudyContent = name;
    
    line = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 1)];
    line.backgroundColor = rgba(232, 232, 232, 1);
    [self.baseplayerinfoView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.self.playerstudyTitle.mas_bottom).offset(ScaleW(10));
        make.left.mas_equalTo(ScaleW(20));
        make.height.mas_equalTo(ScaleW(1));
        make.width.mas_equalTo(Device_Width-40);
    }];
    self.line6View = line;
}


//设置个人成绩界面
-(void)setplayerresultUI
{
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, Device_Height)];
    bView.backgroundColor = UIColor.redColor;//rgba(245, 245, 245, 1);
    [self.view addSubview:bView];
    self.baseplayerresultView = bView;
    [bView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.playerinfobt.mas_bottom);
        make.left.mas_equalTo(ScaleW(0));
        make.width.mas_equalTo(Device_Width);
        make.height.mas_equalTo(Device_Height - [UIDevice de_navigationFullHeight]-self.girlView.height-self.playerinfobt.height);
    }];
    
    self.baseplayerresultView.hidden = YES;
    
    self.personresultWebView = [[WKWebView alloc] initWithFrame:CGRectZero];
    self.personresultWebView.navigationDelegate = self;
    [self.baseplayerresultView addSubview:self.personresultWebView];
    [self.personresultWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(Device_Width);
        make.height.mas_equalTo(Device_Height - [UIDevice de_navigationFullHeight]-self.girlView.height-self.playerinfobt.height);
    }];
    
}


-(void)getInfo
{
    [MBProgressHUD showMessage:@"數據獲取中...."];
    
    NSString *authString = [NSString stringWithFormat:@"%@:%@", [[EGCredentialManager sharedManager] getUsername], [[EGCredentialManager sharedManager] getPassword]];
    // Base64 编码
    NSData *authData = [authString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64AuthString = [authData base64EncodedStringWithOptions:0];
    // 添加 Basic Auth 请求头
    NSString *authHeader = [NSString stringWithFormat:@"Basic %@", base64AuthString];
    
    NSDictionary *dict_header = @{@"Authorization":authHeader};
    
    NSString *url = [EGServerAPI getPersonnelAcnt:self.mem_id];
    [[WAFNWHTTPSTool sharedManager] getWithURL:url parameters:@{} headers:@{} success:^(id  _Nonnull response) {
        [MBProgressHUD hideHUD];
        NSArray *array = response[@"ResponseDto"];
        if ([array isKindOfClass:[NSArray class]]) {
            if (array.count >0 ) {
                self.girlDetailinfo = [response[@"ResponseDto"] objectAtIndex:0];
                [self setInfo:self.girlDetailinfo];
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
    }];
}

-(void)setInfo:(NSDictionary*)girlDetailinfo
{
    self.navigationItem.title =  [girlDetailinfo objectIsNilReturnSteForKey:@"CHName"];
    [self.playerxiguanContent setText:[self playerHabbit:[girlDetailinfo objectForKey:@"PitchingHabbit"] Strike:[girlDetailinfo objectForKey:@"StrikeHabbit"]]];
    [self.playerheightContent setText:[self AppendCM:[[girlDetailinfo objectIsNilReturnSteForKey:@"Height"] stringValue]]];
    [self.playerweightContent setText:[self AppendKG:[[girlDetailinfo objectIsNilReturnSteForKey:@"Weight"] stringValue]]];
    [self.girlBirthdayContent setText:[self convertDate:[girlDetailinfo objectIsNilReturnSteForKey:@"BirthDate"]]];
    [self.playerfirstinContent setText:[self convertDate:[girlDetailinfo objectIsNilReturnSteForKey:@"FirstGameDate"]]];
    [self.playerstudyContent setText:[girlDetailinfo objectIsNilReturnSteForKey:@"SchoolName"]];
    
    
    [self.Nolable_inImage setText:[girlDetailinfo objectIsNilReturnSteForKey:@"UniformNo"]];
    [self.Namelable_inImage setText:[girlDetailinfo objectIsNilReturnSteForKey:@"CHName"]];
    if([[girlDetailinfo objectIsNilReturnSteForKey:@"IsCoach"] boolValue])
        [self.SecondNamelable_inImage setText:@"教練"];
    else
        [self.SecondNamelable_inImage setText:[self playerType:[girlDetailinfo objectIsNilReturnSteForKey:@"DefendStation"]]];
    
    //    [self.showgirlView sd_setImageWithURL:[girlDetailinfo objectIsNilReturnSteForKey:@"PlayerImage"] placeholderImage:[UIImage imageNamed:@"no_player2"]];//第一个参数是图片的URL第二个参数是占位图片加载失败时显示
    [self.showgirlView sd_setImageWithURL:[girlDetailinfo objectForKey:@"PlayerImage"]
                         placeholderImage:[UIImage imageNamed:@"no_player2"]
                                  options:0
                                 progress:nil
                                completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!image) {
            self.showgirlView.contentMode = UIViewContentModeScaleAspectFit;
        }
    }];
    
    //个人成绩页面URL
    NSString *per = @"https://www.cpbl.com.tw/team/person?Acnt=";
    self.personresultURL = [per stringByAppendingString:[girlDetailinfo objectIsNilReturnSteForKey:@"Acnt"]];
    
}

-(void)buttonclick:(UIButton*)bt
{
    [self.playerinfobt setColor:[UIColor whiteColor]];
    [self.playerresultbt setColor:[UIColor whiteColor]];
    self.baseplayerinfoView.hidden = YES;
    self.baseplayerresultView.hidden = YES;
    
    switch (bt.tag) {
        case 80001:
        {
            [self.playerinfobt setColor:rgba(0, 122, 96, 1)];
            self.baseplayerinfoView.hidden = NO;
        }
            break;
        case 80002:
        {
            [self.playerresultbt setColor:rgba(0, 122, 96, 1)];
            self.baseplayerresultView.hidden = NO;
            
            
            [MBProgressHUD showMessage:@""];
            NSString *urlstr = self.personresultURL?self.personresultURL:@"";
            NSURL *nsurl = [[NSURL alloc] initWithString:urlstr];
            NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
            [self.personresultWebView loadRequest:nsrequest];
            
            
           self.closeTimer =  [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(hideprogress) userInfo:nil repeats:NO];
        }
            break;
            
    }
    
}

-(NSString*)convertDate:(NSString*)inDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:inDate];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置日期格式
    [formatter setDateFormat:@"yyyy/MM/dd"];
    // 格式化日期
    NSString *dateString = [formatter stringFromDate:date];
    
    return dateString;
    
}

-(NSString*)AppendKG:(NSString*)weight
{
    
    
    return [weight stringByAppendingString:@" KG"];
}

-(NSString*)AppendCM:(NSString*)height
{
    return [height stringByAppendingString:@" CM"];
}

-(NSString*)playerType:(NSString*)defendStation
{
    NSInteger type = [defendStation integerValue];
    NSString *typeString = @"投手";
    switch (type) {
        case 1:
            typeString = @"投手";
            break;
        case 2:
            typeString = @"捕手";
            break;
        case 3:
        case 4:
        case 5:
        case 6:
            typeString = @"內野手";
            break;
            
        case 7:
        case 8:
        case 9:
            typeString = @"外野手";
            break;
    }
    
    return typeString;
}


-(NSString*)playerHabbit:(NSString*)pitchingHabbit Strike:(NSString*)strikeHabbit
{
    //pitchingHabbit 投手习惯
    //strikeHabbit 打击习惯
    NSString* habbitstring = @"";
    NSString *strike = @"左打";
    NSString *pitch = @"左投";
    
    
    if([strikeHabbit isEqualToString:@"L"])
    {
        strike = @"左打";
    }
    if([strikeHabbit isEqualToString:@"R"])
    {
        strike = @"右打";
    }
    
    if([pitchingHabbit isEqualToString:@"L"])
    {
        pitch = @"左投";
    }
    if([pitchingHabbit isEqualToString:@"R"])
    {
        pitch = @"右投";
    }
    
    habbitstring = [habbitstring stringByAppendingString:pitch];
    habbitstring = [habbitstring stringByAppendingString:strike];
    
    return habbitstring;
}

-(void)hideprogress
{
    [MBProgressHUD hideHUD];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [MBProgressHUD hideHUD];
    
    [self.closeTimer invalidate];
    self.closeTimer = nil;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    [MBProgressHUD hideHUD];
    
    [self.closeTimer invalidate];
    self.closeTimer = nil;
}

@end
