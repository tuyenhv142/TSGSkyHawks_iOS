//
//  EGYoutubeLiveView.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/5/29.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGYoutubeLiveView.h"

#import "hawksCollectionViewCell.h"

#import <GoogleAPIClientForREST/GTLRYouTube.h>
#import <GoogleAPIClientForREST/GTLRYouTubeQuery.h>
//#import <GoogleAPIClientForREST/GTMAppAuth.h>


@interface EGYoutubeLiveView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) GTLRYouTubeService *service;
@property (nonatomic, strong) NSMutableArray *lives;

@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) UIButton *moreBtn;

@end


@implementation EGYoutubeLiveView

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
        _titleLb.text = @"Live直播轉播";
        _titleLb.textColor = rgba(38, 38, 38, 1);
        _titleLb.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightSemibold];
    }
    return _titleLb;
}
- (UIButton *)moreBtn
{
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] init];
        [_moreBtn setTitle:@"前往頻道" forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:(UIFontWeightMedium)];
        [_moreBtn setImage:[UIImage imageNamed:@"chevron-right"] forState:UIControlStateNormal];
        [_moreBtn setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(openChannel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
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
    }
    return _mainCollectionView;
}

- (NSMutableArray *)lives{
    if (_lives == nil ) {
        _lives =  [NSMutableArray array];
    }
    return _lives;;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = rgba(243, 243, 243, 1);
        
        [self addSubview:self.titleLb];
        
        [self addSubview:self.moreBtn];
        
        [self addSubview:self.mainCollectionView];
        
        [self setupYouTubeService];
        
        [self fetchYouTubeLives];
    }
    return self;
}


-(void)layoutSubviews
{
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(24));
        make.left.mas_equalTo(ScaleW(20));
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

- (void)setupYouTubeService
{
    NSString *APIkey = [[EGCredentialManager sharedManager] getYouTubeAPIkey];
    self.service = [[GTLRYouTubeService alloc] init];
    self.service.APIKey = APIkey;
}

-(void)fetchYouTubeLives
{
//www.googleapis.com/youtube/v3/search?part=snippet,id&channelId=UCVBlrH9PZRWtgrfcrjmXZMA&maxResults=4&type=video&key=AIzaSyAHtPSyko-zk2nz7iofQAzCz-KlA8enQ3c&order=date&eventType=completed
    WS(weakSelf);
//    GTLRYouTubeQuery_SearchList *query = [GTLRYouTubeQuery_SearchList queryWithPart:@"snippet"];
//    query.channelId = @"UCVBlrH9PZRWtgrfcrjmXZMA";
//    query.maxResults = 4;
//    query.type = @"video";
//    query.order = @"date";
////    query.q = @"live video";
//    query.eventType = kGTLRYouTubeEventTypeCompleted;//completed  live
//    [self.service executeQuery:query
//                  completionHandler:^(GTLRServiceTicket *ticket,
//                                    GTLRYouTube_SearchListResponse *response,
//                                    NSError *error) {
//        if (error) {
//            NSLog(@"Error: %@", error);
//            return;
//        }
//        [self.lives removeAllObjects];
//        for (GTLRYouTube_SearchResult *item in response.items) {
//                    
//            if ([item.kind isEqualToString:@"youtube#searchResult"]) {
//                GTLRDateTime *publishedAt = item.snippet.publishedAt ;
//                NSString *dateString = [self formatGTLRDateTime:publishedAt];
//                NSDictionary *videoInfo = @{
//                    @"title": item.snippet.title ?: @"",
//                    @"videoId": item.identifier.videoId ?: @"",
//                    @"thumbnailUrl": item.snippet.thumbnails.medium.url ?: @"",
//                    @"publishTime": dateString
//                };
//                [weakSelf.lives addObject:videoInfo];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [weakSelf.mainCollectionView reloadData];
//                });
//            }
//        }
//    }];
    
    [self getLivesDataForType:@"upcoming" completionHandler:^(BOOL success) {
        if (success && weakSelf.lives.count < 4) {
            [self getLivesDataForType:@"live" completionHandler:^(BOOL success) {
                if (success && weakSelf.lives.count < 4) {
                    [self getLivesDataForType:@"completed" completionHandler:^(BOOL success) {
                        if (success) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [weakSelf.mainCollectionView reloadData];
                            });
                        }
                    }];
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.mainCollectionView reloadData];
                    });
                }
            }];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.mainCollectionView reloadData];
            });
        }
    }];
}
    
-(void)getLivesDataForType:(NSString *)type completionHandler:(void (^)(BOOL success))completion;
{
    WS(weakSelf);
//    GTLRYouTubeQuery_SearchList *query = [GTLRYouTubeQuery_SearchList queryWithPart:@"snippet"];
//    query.channelId = @"UCVBlrH9PZRWtgrfcrjmXZMA";
//    query.maxResults = 4;
//    query.type = @"video";
//    query.order = @"date";
////    query.q = @"live video";
//    query.eventType = type;//completed  live  upcoming
//    [self.service executeQuery:query
//                  completionHandler:^(GTLRServiceTicket *ticket,
//                                    GTLRYouTube_SearchListResponse *response,
//                                    NSError *error) {
//        if (error) {
//            NSLog(@"Error: %@", error);
//            completion(false);
//            return;
//        }
//        if ([type isEqualToString:@"upcoming"]) {
//            [self.lives removeAllObjects];
//        }
//        for (GTLRYouTube_SearchResult *item in response.items) {
//                    
//            if ([item.kind isEqualToString:@"youtube#searchResult"]) {
//                GTLRDateTime *publishedAt = item.snippet.publishedAt ;
//                NSString *dateString = [self formatGTLRDateTime:publishedAt];
//                NSDictionary *videoInfo = @{
//                    @"title": item.snippet.title ?: @"",
//                    @"videoId": item.identifier.videoId ?: @"",
//                    @"thumbnailUrl": item.snippet.thumbnails.medium.url ?: @"",
//                    @"publishTime": dateString
//                };
//                if (weakSelf.lives.count >= 4) {
//                    break;
//                }
//                [weakSelf.lives addObject:videoInfo];
//            }
//        }
//        completion(true);
//    }];
    
    EGRelayTokenModel *tokenModel = [EGLoginUserManager getRelayToken];
    NSDictionary *headerDict;
    if (tokenModel) {
        headerDict = @{@"Authorization":tokenModel.token ? tokenModel.token:@"",
                       @"Accept": @"application/json",  // 添加 Accept 头
                       @"Content-Type": @"application/json"  // 添加 Content-Type 头
        };
    }
    [[WAFNWHTTPSTool sharedManager] getWithURL:[EGServerAPI get_YouTubeLive:type] parameters:@{} headers:headerDict success:^(NSDictionary * _Nonnull response){
    
        NSArray *array = [response objectOrNilForKey:@"items"];
        
        if ([type isEqualToString:@"upcoming"]) {
            [self.lives removeAllObjects];
        }
        for (NSDictionary *item in array) {

            if ([item[@"kind"] isEqualToString:@"youtube#searchResult"]) {
                
                NSString *publishedAt = item[@"snippet"][@"publishedAt"];
                NSString *dateString = [self formatGTLRDateTime:publishedAt];
                
                NSDictionary *videoInfo = @{
                    @"title": item[@"snippet"][@"title"] ?: @"",
                    @"videoId": item[@"id"][@"videoId"] ?: @"",
                    @"thumbnailUrl": item[@"snippet"][@"thumbnails"][@"medium"][@"url"] ?: @"",
                    @"publishTime": dateString
                };
                if (weakSelf.lives.count >= 4) {
                    break;
                }
                [weakSelf.lives addObject:videoInfo];
            }
        }
        completion(true);
    } failure:^(NSError * _Nonnull error) {
        completion(false);
    }];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma  mark  UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.lives.count > 4 ? 4 : self.lives.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    hawksCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hawksCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *videoInfo  = self.lives[indexPath.row];
    cell.titleLB.text = [videoInfo objectForKey:@"title"];
    cell.dateLB.text = [videoInfo objectForKey:@"publishTime"];
    NSURL *imageURL =  [videoInfo objectForKey:@"thumbnailUrl"];
    [cell.imageView sd_setImageWithURL:imageURL];

    return cell;
}

//定义每个UICollectionViewCell 的大小
- (CGSize) collectionView: (UICollectionView *)collectionView layout: (UICollectionViewLayout*) collectionViewLayout sizeForItemAtIndexPath: (NSIndexPath*)indexPath
{
    return CGSizeMake(ScaleW(292), self.mainCollectionView.frame.size.height/*ScaleW(238)*/);
}


#pragma  mark 跳转
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *video = self.lives[indexPath.row];
    NSString *videoId = video[@"videoId"];
    // 尝试打开 YouTube App
    NSString *youtubeAppUrl = [NSString stringWithFormat:@"youtube://watch?v=%@", videoId];
    NSURL *appURL = [NSURL URLWithString:youtubeAppUrl];

    // 如果无法打开 App，则使用 Safari 打开网页版
    NSString *webUrl = [NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@", videoId];
    NSURL *webURL = [NSURL URLWithString:webUrl];

    if ([[UIApplication sharedApplication] canOpenURL:appURL]) {
      [[UIApplication sharedApplication] openURL:appURL options:@{} completionHandler:nil];
    } else {
      [[UIApplication sharedApplication] openURL:webURL options:@{} completionHandler:nil];
    }
}

- (void)openChannel
{
    [self openYouTubeChannel:@"UCVBlrH9PZRWtgrfcrjmXZMA"];
}

- (void)openYouTubeChannel:(NSString *)channelId
{
//    https://www.youtube.com/@tsghawks/streams
    // 尝试打开 YouTube App
    NSString *youtubeAppUrl = [NSString stringWithFormat:@"youtube://www.youtube.com/channel/%@/streams", channelId];
    NSURL *appURL = [NSURL URLWithString:youtubeAppUrl];
    // 网页版 URL
    NSString *webUrl = [NSString stringWithFormat:@"https://www.youtube.com/channel/%@/streams", channelId];
    NSURL *webURL = [NSURL URLWithString:webUrl];
    
    if ([[UIApplication sharedApplication] canOpenURL:appURL]) {
        [[UIApplication sharedApplication] openURL:appURL options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:webURL options:@{} completionHandler:nil];
    }
}

#pragma  mark google Query
- (NSString *)formatGTLRDateTime:(NSString *)dateTime
{
    NSString *dateString = dateTime ?: @"";
    // 转换日期格式
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    [inputFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    NSDate *date = [inputFormatter dateFromString:dateString];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    dateString = date ? [outputFormatter stringFromDate:date] : @"";
    return dateString;
}




//zan shi wu yong
- (void)fetchLiveStreamsForChannelWithID:(NSString *)channelID
                             completion:(void (^)(NSArray<GTLRYouTube_LiveBroadcast *> *streams, NSError *error))completion
{
    
    // 1. 创建查询获取直播列表
    GTLRYouTubeQuery_LiveBroadcastsList *liveQuery = [GTLRYouTubeQuery_LiveBroadcastsList queryWithPart:@"snippet,contentDetails,status"];
    // 2. 设置筛选条件
    liveQuery.broadcastStatus = kGTLRYouTubeBroadcastStatusActive; // 获取活跃直播
    liveQuery.broadcastType = kGTLRYouTubeBroadcastTypeAll; // 获取所有类型
    liveQuery.maxResults = 4;
    // 3. 执行查询
    [self.service executeQuery:liveQuery
                    completionHandler:^(GTLRServiceTicket * _Nonnull callbackTicket,
                                      GTLRYouTube_LiveBroadcastListResponse * _Nullable response,
                                      NSError * _Nullable callbackError) {
        
        if (callbackError) {
            NSLog(@"Error fetching live streams: %@", callbackError.localizedDescription);
            completion(nil, callbackError);
            return;
        }
        // 4. 筛选属于指定频道的直播
        NSMutableArray *filteredStreams = [NSMutableArray array];
        for (GTLRYouTube_LiveBroadcast *broadcast in response.items) {
            
            NSLog(@"Title: %@", broadcast.snippet.title);
            NSLog(@"Description: %@", broadcast.snippet.descriptionProperty);
            NSLog(@"Scheduled Start Time: %@", broadcast.snippet.scheduledStartTime);
            NSLog(@"Status: %@", broadcast.status.lifeCycleStatus);
            NSLog(@"---");
            
            if ([broadcast.snippet.channelId isEqualToString:channelID]) {
                [filteredStreams addObject:broadcast];
            }
        }
        completion(filteredStreams, nil);
    }];
}
@end
