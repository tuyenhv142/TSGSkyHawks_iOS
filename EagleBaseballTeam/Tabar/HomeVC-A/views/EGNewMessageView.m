//
//  EGNewMessageView.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/6.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGNewMessageView.h"


#import "hawksCollectionViewCell.h"

@interface EGNewMessageView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic,strong) NSArray *dataArray;

@end
@implementation EGNewMessageView

- (UILabel *)titleLb
{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.textAlignment = NSTextAlignmentLeft;
        _titleLb.text = @"最新消息";
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
        [_moreBtn setTitle:@"前往官網" forState:UIControlStateNormal];
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
    if ([self.delegate respondsToSelector:@selector(clickNewMessageForItem:)]) {
        [self.delegate clickNewMessageForItem:@"more"];
    }
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
        
        [self getDataForTsghawks];
    }
    return self;
}

-(void)layoutSubviews
{
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


#pragma  mark  UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    hawksCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hawksCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *videoInfo  = self.dataArray[indexPath.row];

    NSDictionary *title_Dict = [videoInfo objectForKey:@"title"];
    cell.titleLB.text = [title_Dict objectForKey:@"rendered"];
    
    NSString *dateStr = [videoInfo objectForKey:@"date"];
    cell.dateLB.text = [dateStr substringToIndex:10];
    
    NSDictionary *yoast_head_json = [videoInfo objectForKey:@"yoast_head_json"];
    NSArray *array = [yoast_head_json objectForKey:@"og_image"];
    NSDictionary *og_image = [array firstObject];
    NSURL *imageURL =  [og_image objectForKey:@"url"];
    [cell.imageView sd_setImageWithURL:imageURL];

    return cell;
}

//定义每个UICollectionViewCell 的大小
- (CGSize) collectionView: (UICollectionView *)collectionView layout: (UICollectionViewLayout*) collectionViewLayout sizeForItemAtIndexPath: (NSIndexPath*)indexPath

{
    return CGSizeMake(ScaleW(292),self.mainCollectionView.frame.size.height/* ScaleW(238)*/);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *videoInfo  = self.dataArray[indexPath.row];
    NSString *linkStr = [videoInfo objectForKey:@"link"];
    
    if ([self.delegate respondsToSelector:@selector(clickNewMessageForItem:)]) {
        [self.delegate clickNewMessageForItem:linkStr];
    }
}


-(void)getDataForTsghawks
{
    WS(weakSelf);
    NSString *username = @"newsoftapp";
    NSString *password = @"Y21P 5Zsd EtAK dohZ 4WQo XA5L";
    NSString *url = @"https://www.tsghawks.com/wp-json/wp/v2/posts?per_page=4&order=desc&status=publish";
    NSString *loginString = [NSString stringWithFormat:@"%@:%@", username, password];
    NSData *loginData = [loginString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64LoginString = [loginData base64EncodedStringWithOptions:0];
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Basic %@", base64LoginString];
     
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
    [manager GET:url parameters:nil headers:@{} progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *array = responseObject;
            weakSelf.dataArray = array;
            [weakSelf.mainCollectionView reloadData];
//            NSLog(@"-----%@",responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];

}
@end
