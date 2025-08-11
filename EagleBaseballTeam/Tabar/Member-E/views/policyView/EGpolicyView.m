//
//  OASearchFilterView.m
//  NewsoftOA24
//
//  Created by rick on 7/31/24.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import "EGpolicyView.h"
#import "LXYHyperlinksButton.h"


@interface EGpolicyView ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
{

}

@property (nonatomic,weak) UIView * baseView;
@property (nonatomic,strong) UIView * topView;
@property (nonatomic,weak) UIButton *cancelBtn; // X button
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;


@end


@implementation EGpolicyView

-(instancetype)initWithFrame:(CGRect)frame{
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    self = [super initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];

    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    
    UIView *bView = [[UIView alloc] initWithFrame:self.bounds];
    [bView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:bView];
    
    // 添加点击手势识别器 点击背景退出
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    // 要识别手势的点击次数
    tapGestureRecognizer.numberOfTapsRequired = 1;
    // 添加到主视图
    [bView addGestureRecognizer:tapGestureRecognizer];
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, Device_Height)];
    baseView.backgroundColor = [UIColor colorWithRed:0 green:71.0/255.0 blue:56.0/255 alpha:1.0];
    baseView.layer.cornerRadius = 15;
    baseView.layer.masksToBounds = YES;
    self.baseView = baseView;
    [self addSubview:self.baseView];

    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, 42)];
//    self.topView.backgroundColor = UIColor.yellowColor;
    self.topView.layer.masksToBounds = YES;
    [self.baseView addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.baseView.mas_centerX);
        make.top.mas_equalTo(ScaleW(0));
        make.width.mas_equalTo(Device_Width-ScaleW(40));
        make.height.mas_equalTo(ScaleW(42));
    }];
    
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 64, 24)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = UIColor.whiteColor;
    lable.font = [UIFont systemFontOfSize:FontSize(16)];
    lable.text =@"隱私條款";
    [self.topView addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.topView.mas_centerX);
        make.centerY.mas_equalTo(self.topView.mas_centerY);
        make.width.mas_equalTo(ScaleW(120));
        make.height.mas_equalTo(ScaleW(24));
    }];
    self.title = lable;
    
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"SettingClose"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeSettingView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.topView addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.title.mas_right).offset(ScaleW(80));
        make.centerY.mas_equalTo(self.topView.mas_centerY);
        make.width.mas_equalTo(ScaleW(32));
        make.height.mas_equalTo(ScaleW(32));
    }];
    
    if (@available(iOS 13.0, *)) {
        self.tableView = [[UITableView alloc] initWithFrame:self.baseView.bounds style:UITableViewStyleGrouped];
    } else {
        // Fallback on earlier versions
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 85;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor=rgba(246, 246, 246, 1);
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.baseView addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    //[self.tableView reloadData];
    
}


//弹出pickerView
- (void)popPickerView
{
    self.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:0];
    [[[[UIApplication sharedApplication]windows] firstObject] addSubview:self];

    self.frame = CGRectMake(0, 0, Device_Width, Device_Height);
    self.baseView.alpha = 0.0;
    [UIView animateWithDuration:0.25
                     animations:^{
        self.baseView.alpha = 1.0;
        [self.baseView setFrame:CGRectMake(0,  ScaleH(50), Device_Width, Device_Height-ScaleH(50))];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    }];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self removeFromSuperview];
        if(self.gBlock)
        {
            self.gBlock(self.settingDic);
        }
    }
}

-(void)closeSettingView
{
    [self removeFromSuperview];
    if(self.gBlock)
    {
        self.gBlock(self.settingDic);
    }
}

-(void)setInfo:(NSInteger)type
{
    switch (type) {
        case 0:
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"policy" ofType:@"json"];
            NSData *data = [NSData dataWithContentsOfFile:path];
            NSDictionary *json_data = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
            
            self.title.text = @"隐私条款";
            self.dataArray = [json_data objectOrNilForKey:@"policy_data"];
            [self.tableView reloadData];
        }
            break;
        case 1:
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"TermsofService" ofType:@"json"];
            NSData *data = [NSData dataWithContentsOfFile:path];
            NSDictionary *json_data = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
            
            self.title.text = @"使用者服务条款";
            self.dataArray = [json_data objectOrNilForKey:@"policy_data"];
            [self.tableView reloadData];
        }
            break;
        case 2:
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"registerpolicy" ofType:@"json"];
            NSData *data = [NSData dataWithContentsOfFile:path];
            NSDictionary *json_data = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
            
            self.title.text = @"會員服務條款";
            self.dataArray = [json_data objectOrNilForKey:@"policy_data"];
            [self.tableView reloadData];
        }
            break;
        default:
            break;
    }
     
    
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"policycell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"policycell"];
//        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      //  cell.imageView.image = [UIImage imageNamed:@"addressMy"];
        
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:FontSize(15) weight:UIFontWeightRegular];
        cell.textLabel.textColor = rgba(23, 43, 77, 1);
        
    }
        NSString* dddd = [self.dataArray[indexPath.section] valueForKey:@"content"];
        // 设置行距
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 11; // 设置行距为10
        
        NSDictionary *attributes = @{
            NSParagraphStyleAttributeName: paragraphStyle,
            NSFontAttributeName: [UIFont systemFontOfSize:FontSize(14)],
            NSForegroundColorAttributeName:ColorRGB(0x737373),
            
        };
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:dddd attributes:attributes];
        cell.textLabel.attributedText = str;
    
    return  cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return UITableViewAutomaticDimension;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
   // UITableViewHeaderFooterView *view = [[UITableViewHeaderFooterView  alloc]init];
    
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headercell2"] ;
   
    //UITableViewHeaderFooterView contentConfiguration
       if (view == nil) {
           view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"headercell2"];
            view.textLabel.font = [UIFont systemFontOfSize:FontSize(25) weight:UIFontWeightRegular];
//            view.contentView.backgroundColor= rgba(246, 246, 246, 1);
            view.textLabel.textColor = rgba(32, 128, 33, 1);
            view.textLabel.text = NSLocalizedString(@"序言",nil);
            view.textLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightBold];
        }
    
    if (@available(iOS 14.0, *)) {
        UIListContentConfiguration *Configuration = [UIListContentConfiguration cellConfiguration];
        Configuration.text = [self.dataArray[section] objectOrNilForKey:@"title"];
        Configuration.textProperties.font =  [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
        Configuration.textProperties.color = ColorRGB(0x262626);
        Configuration.textProperties.numberOfLines = 0;
        view.contentConfiguration = Configuration;
    }
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
        NSString * preferredLang = [allLanguages objectAtIndex:0];
    BOOL contains = [preferredLang rangeOfString:@"Han"].location != NSNotFound;
    
    if(contains)
      return UITableViewAutomaticDimension/*ScaleW(38)*/;
    else
        return UITableViewAutomaticDimension/*ScaleW(45)*/;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}



@end
