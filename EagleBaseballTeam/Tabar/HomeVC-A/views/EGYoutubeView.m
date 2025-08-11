//
//  EGYoutubeView.m
//  QuickstartApp
//
//  Created by rick on 1/24/25.
//

#import "EGYoutubeView.h"


#import "hawksCollectionViewCell.h"

@interface EGYoutubeView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UICollectionView *mainCollectionView;

@end

@implementation EGYoutubeView

- (UILabel *)titleLb
{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.textAlignment = NSTextAlignmentLeft;
        _titleLb.text = @"官方影片";
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
        [_moreBtn setTitle:@"前往Youtube" forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:(UIFontWeightMedium)];
        [_moreBtn setImage:[UIImage imageNamed:@"chevron-right"] forState:UIControlStateNormal];
        [_moreBtn setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(openChannel) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_moreBtn];
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
        
        // Initialize the service object.
        self.service = [[GTLRYouTubeService alloc] init];
//        self.service.APIKey = YouTubeAPIKey; // @"AIzaSyCce10Jdj3umtEeixlv9kKhhTFGfq8Dx9w";
        NSString *ddd = [[EGCredentialManager sharedManager] getYouTubeAPIkey];
//        NSLog(@"YouTubeAPIKey:%@",ddd);
        self.service.APIKey = ddd; //
        [self fetchYouTubeVideos];
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



- (NSMutableArray *)videos{
    if (_videos == nil ) {
        _videos =  [NSMutableArray array];
    }
    return _videos;;
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
    return self.videos.count;
//    return 6;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    hawksCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hawksCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *videoInfo  = self.videos[indexPath.row];

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
    
    NSDictionary *video = self.videos[indexPath.row];
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
    // 尝试打开 YouTube App
    NSString *youtubeAppUrl = [NSString stringWithFormat:@"youtube://www.youtube.com/channel/%@", channelId];
    NSURL *appURL = [NSURL URLWithString:youtubeAppUrl];
    
    // 网页版 URL
    NSString *webUrl = [NSString stringWithFormat:@"https://www.youtube.com/channel/%@", channelId];
    NSURL *webURL = [NSURL URLWithString:webUrl];
    
    if ([[UIApplication sharedApplication] canOpenURL:appURL]) {
        [[UIApplication sharedApplication] openURL:appURL options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:webURL options:@{} completionHandler:nil];
    }
}

#pragma  mark google Query
- (NSString *)formatGTLRDateTime:(GTLRDateTime *)dateTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:dateTime.date];
}

//获取前10个视频基本的title ，id 和 thumbnail
- (void)fetchYouTubeVideos
{
    EGRelayTokenModel *tokenModel = [EGLoginUserManager getRelayToken];
    NSDictionary *headerDict;
    if (tokenModel) {
        headerDict = @{@"Authorization":tokenModel.token ? tokenModel.token:@"",
                       @"Accept": @"application/json",  // 添加 Accept 头
                       @"Content-Type": @"application/json"  // 添加 Content-Type 头
        };
    }
    
    [[WAFNWHTTPSTool sharedManager] getWithURL:[EGServerAPI get_YouTubeInfo] parameters:@{} headers:headerDict success:^(NSDictionary * _Nonnull response){
    
        NSArray *array = [response objectOrNilForKey:@"items"];
        if (array.count > 0) {
            [self.videos removeAllObjects];
            for (NSDictionary *item in array) {
                NSDictionary *snippet = [item objectOrNilForKey:@"snippet"];
                NSDictionary *thumbnails = [snippet objectOrNilForKey:@"thumbnails"];
                NSDictionary *medium = [thumbnails objectOrNilForKey:@"medium"];
                
//                ELog(@"title:%@", [snippet objectOrNilForKey:@"title"]);
//                ELog(@"thumbnails:%@",thumbnails);
//                ELog(@"medium:%@",medium);
                NSString *dateString = [snippet objectOrNilForKey:@"publishedAt"] ?: @"";
                // 转换日期格式
                NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
                [inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
                [inputFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
                
                NSDate *date = [inputFormatter dateFromString:dateString];
                
                NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
                [outputFormatter setDateFormat:@"yyyy-MM-dd"];
                dateString = date ? [outputFormatter stringFromDate:date] : @"";
                
                NSDictionary *videoInfo = @{
                    @"title": [snippet objectOrNilForKey:@"title"] ?: @"",
                    @"videoId": [[item objectOrNilForKey:@"id"] objectForKey:@"videoId"] ?: @"",
                    @"thumbnailUrl": [medium objectOrNilForKey:@"url"] ?: @"",
                    @"publishTime":dateString
                };
//                ELog(@"videoInfo:%@",videoInfo);
                [self.videos addObject:videoInfo];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mainCollectionView reloadData];
            });
        }
//        GTLRYouTube_SearchListResponse *response2 = response;
//        for (GTLRYouTube_SearchResult *item in response2.items) {
//            if ([item.identifier.kind isEqualToString:@"youtube#video"]) {
//                
//                GTLRDateTime *publishedAt = item.snippet.publishedAt ;
//                NSString *dateString = [self formatGTLRDateTime:publishedAt];
//                
//                NSDictionary *videoInfo = @{
//                    @"title": item.snippet.title ?: @"",
//                    @"videoId": item.identifier.videoId ?: @"",
//                    @"thumbnailUrl": item.snippet.thumbnails.medium.url ?: @"",
//                    @"publishTime": dateString
//                };
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    [self.videos addObject:videoInfo];
//                    [self.mainCollectionView reloadData];
//                });
//            }
//        }
    } failure:^(NSError * _Nonnull error) {
//        if ([error.localizedDescription containsString:@"offline"] || error.code == -1009) {
//            [MBProgressHUD showDelayHidenMessage:@"請檢查您的網路連線，確保裝置已連接至網路後再重試。"];
//        }else{
////            [MBProgressHUD showDelayHidenMessage:error.localizedDescription];
//        }
        
    }];
    
//    GTLRYouTubeQuery_SearchList *query = [GTLRYouTubeQuery_SearchList queryWithPart:@"snippet"];
//    query.channelId = @"UCVBlrH9PZRWtgrfcrjmXZMA";
//    query.maxResults = 4;
//    query.order = kGTLRYouTubeOrderDate;
//    
//    [self.service executeQuery:query
//                  completionHandler:^(GTLRServiceTicket *ticket,
//                                    GTLRYouTube_SearchListResponse *response,
//                                    NSError *error) {
//        if (error) {
//            NSLog(@"Error: %@", error);
//            return;
//        }
//        [self.videos removeAllObjects];
//        for (GTLRYouTube_SearchResult *item in response.items) {
//            if ([item.identifier.kind isEqualToString:@"youtube#video"]) {
//                
//                GTLRDateTime *publishedAt = item.snippet.publishedAt ;
//                NSString *dateString = [self formatGTLRDateTime:publishedAt];
//                
//                NSDictionary *videoInfo = @{
//                    @"title": item.snippet.title ?: @"",
//                    @"videoId": item.identifier.videoId ?: @"",
//                    @"thumbnailUrl": item.snippet.thumbnails.medium.url ?: @"",
//                    @"publishTime": dateString
//                };
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    [self.videos addObject:videoInfo];
//                    [self.mainCollectionView reloadData];
//                });
//            }
//        }
//        
//        // 获取视频详细信息（包括时长）
////        [self fetchVideoDetails:videoIds searchResults:response.items];
//    }];
}

- (void)fetchVideoDetails:(NSArray *)videoIds searchResults:(NSArray *)searchResults
{
    GTLRYouTubeQuery_VideosList *query = [GTLRYouTubeQuery_VideosList queryWithPart:@"contentDetails"];
    query.identifier = [videoIds componentsJoinedByString:@","];
    
    [self.service executeQuery:query
                  completionHandler:^(GTLRServiceTicket *ticket,
                                    GTLRYouTube_VideoListResponse *response,
                                    NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            return;
        }
        
        NSMutableDictionary *durationDict = [NSMutableDictionary dictionary];
        for (GTLRYouTube_Video *video in response.items) {
            durationDict[video.identifier] = video.contentDetails.duration;
        }
        
        // 合并搜索结果和时长信息
        for (GTLRYouTube_SearchResult *searchResult in searchResults) {
            if ([searchResult.identifier.kind isEqualToString:@"youtube#video"]) {
                NSString *duration = [self formatDuration:durationDict[searchResult.identifier.videoId]];
                NSDictionary *videoInfo = @{
                    @"title": searchResult.snippet.title,
                    @"videoId": searchResult.identifier.videoId,
                    @"thumbnailUrl": searchResult.snippet.thumbnails.medium.url,
                    @"duration": duration ?: @""
                };
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.videos addObject:videoInfo];
                
                });
            }
        }
    }];
   
    
}

- (NSString *)formatDuration:(NSString *)isoDuration {
    NSScanner *scanner = [NSScanner scannerWithString:isoDuration];
    [scanner scanString:@"PT" intoString:nil];
    
    NSInteger hours = 0;
    NSInteger minutes = 0;
    NSInteger seconds = 0;
    
    NSInteger value = 0;
    while (![scanner isAtEnd]) {
        [scanner scanInteger:&value];
        if ([scanner scanString:@"H" intoString:nil]) {
            hours = value;
        } else if ([scanner scanString:@"M" intoString:nil]) {
            minutes = value;
        } else if ([scanner scanString:@"S" intoString:nil]) {
            seconds = value;
        }
    }
    
    if (hours > 0) {
        return [NSString stringWithFormat:@"%ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
    } else {
        return [NSString stringWithFormat:@"%ld:%02ld", (long)minutes, (long)seconds];
    }
}

@end
