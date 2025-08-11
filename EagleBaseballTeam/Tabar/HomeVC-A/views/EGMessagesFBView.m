//
//  EGMessagesFBView.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/5/30.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGMessagesFBView.h"


#import "hawksCollectionViewCell.h"

@interface EGMessagesFBView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) NSArray *dataArray;

@end



@implementation EGMessagesFBView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (UILabel *)titleLb
{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.textAlignment = NSTextAlignmentLeft;
        _titleLb.text = @"";
        _titleLb.textColor = rgba(38, 38, 38, 1);
        _titleLb.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightSemibold];
//        [self addSubview:_titleLb];
    }
    return _titleLb;
}
- (UIButton *)moreBtn
{
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] init];
        [_moreBtn setTitle:@"前往臉書" forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:(UIFontWeightMedium)];
        [_moreBtn setImage:[UIImage imageNamed:@"chevron-right"] forState:UIControlStateNormal];
        [_moreBtn setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(lookMoredata) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_moreBtn];
    }
    return _moreBtn;
}

-(void)lookMoredata
{
//    if ([self.delegate respondsToSelector:@selector(clickNewMessageForItem:)]) {
//        [self.delegate clickNewMessageForItem:@"more"];
//    }
}
- (UICollectionView *)mainCollectionView
{
    if (!_mainCollectionView) {
        
        CGRect rect = CGRectMake(0, 88, Device_Width, ScaleW(213));
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _mainCollectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
        _mainCollectionView.backgroundColor = [UIColor clearColor];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        _mainCollectionView.scrollEnabled = true;
        [_mainCollectionView registerClass:[hawksCollectionViewCell class] forCellWithReuseIdentifier:@"hawksCollectionViewCell"];
//        [self addSubview:_mainCollectionView];
    }
    return _mainCollectionView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = rgba(243, 243, 243, 1);
        [self addSubview:self.titleLb];
        
        [self addSubview:self.moreBtn];
        
        [self addSubview:self.mainCollectionView];
        
        [self getDataForFaceBook];
        
        [self fetchAppAccessToken];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(24));
        make.left.mas_equalTo(ScaleW(20));
        make.right.mas_equalTo(-ScaleW(20));
    }];

    [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(64));
        make.left.mas_equalTo(ScaleW(20));
        make.right.mas_equalTo(-ScaleW(20));
//        make.height.mas_equalTo(ScaleW(238));
        make.bottom.mas_equalTo(ScaleW(0));
    }];

    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(24));
        make.right.mas_equalTo(-ScaleW(20));
    }];
    [self.moreBtn layoutButtonWithEdgeInsetsStyle:ZYButtonEdgeInsetsStyleRight imageTitleSpace:1];
}
#pragma mark --- 获取数据
- (void)getDataForFaceBook
{
    
}

#pragma  mark  UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
//    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    hawksCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hawksCollectionViewCell" forIndexPath:indexPath];
//    NSDictionary *videoInfo  = self.dataArray[indexPath.row];
//
//    NSDictionary *title_Dict = [videoInfo objectForKey:@"title"];
//    cell.titleLB.text = [title_Dict objectForKey:@"rendered"];
//    
//    NSString *dateStr = [videoInfo objectForKey:@"date"];
    cell.dateLB.text = @"32456";//[dateStr substringToIndex:10];
//
//    NSDictionary *yoast_head_json = [videoInfo objectForKey:@"yoast_head_json"];
//    NSArray *array = [yoast_head_json objectForKey:@"og_image"];
//    NSDictionary *og_image = [array firstObject];
//    NSURL *imageURL =  [og_image objectForKey:@"url"];
//    [cell.imageView sd_setImageWithURL:imageURL];

    return cell;
}

//定义每个UICollectionViewCell 的大小
- (CGSize) collectionView: (UICollectionView *)collectionView layout: (UICollectionViewLayout*) collectionViewLayout sizeForItemAtIndexPath: (NSIndexPath*)indexPath

{
    return CGSizeMake(ScaleW(292),self.mainCollectionView.frame.size.height/* ScaleW(238)*/);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary *videoInfo  = self.dataArray[indexPath.row];
//    NSString *linkStr = [videoInfo objectForKey:@"link"];
    
//    if ([self.delegate respondsToSelector:@selector(clickNewMessageForItem:)]) {
//        [self.delegate clickNewMessageForItem:linkStr];
//    }
//    https://www.facebook.com/events/246152148576962
//    NSString *youtubeAppUrl = [NSString stringWithFormat:@"youtube://watch?v=%@", videoId];
//    NSURL *appURL = [NSURL URLWithString:youtubeAppUrl];
//    // 如果无法打开 App，则使用 Safari 打开网页版
//    NSString *webUrl = [NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@", videoId];
    
    
//    NSDictionary *video = self.lives[indexPath.row];
    NSString *videoId = @"597204295597827";//video[@"videoId"];
    // 尝试打开  App
    NSURL *facebookAppURL = [NSURL URLWithString:[NSString stringWithFormat:@"facebook://events/%@",videoId]];
    // 如果无法打开 App，则使用 Safari 打开网页版 https://www.facebook.com
    NSURL *facebookWebURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.facebook.com/events/%@",videoId]];

    if ([[UIApplication sharedApplication] canOpenURL:facebookAppURL]) {
      [[UIApplication sharedApplication] openURL:facebookAppURL options:@{} completionHandler:nil];
    } else {
      [[UIApplication sharedApplication] openURL:facebookWebURL options:@{} completionHandler:nil];
    }
}



- (void)fetchAppAccessToken
{
    NSString *appID = @"1142986014259968";
    NSString *appSecret = @"8485b645ab87b98facc4f80629371e45";
    NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/oauth/access_token?client_id=%@&client_secret=%@&grant_type=client_credentials", appID, appSecret];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"获取App Access Token错误: %@", error);
            return;
        }
        
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError) {
            NSLog(@"JSON解析错误: %@", jsonError);
            return;
        }
        
        NSString *appAccessToken = json[@"access_token"];
        NSLog(@"获取到的App Access Token: %@", appAccessToken);
        // 存储或使用这个token
        [self fetchPublicPageActivities:@"" accessToken:appAccessToken];
    }];
    
    [task resume];
}
- (void)fetchPublicPageActivities:(NSString *)pageID accessToken:(NSString *)accessToken1 {
    NSString *accessToken = accessToken1; // 从Facebook开发者后台获取 1142986014259968 8485b645ab87b98facc4f80629371e45
    NSString *graphPath = [NSString stringWithFormat:@"/%@/events", pageID];
    NSDictionary *params = @{
        @"fields": @"id,name,description,place,start_time,end_time",
        @"access_token": accessToken,
        @"limit": @"50"
    };

//    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
//                                 initWithGraphPath:graphPath
//                                 parameters:params
//                                 HTTPMethod:@"GET"];
//    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//        if (!error) {
//            NSArray *events = result[@"data"];
//            NSLog(@"获取到 %lu 个公开事件", (unsigned long)events.count);
//            [self processEventsData:events];
//        } else {
//            NSLog(@"获取公开事件错误: %@", error.localizedDescription);
//        }
//    }];
}
@end
