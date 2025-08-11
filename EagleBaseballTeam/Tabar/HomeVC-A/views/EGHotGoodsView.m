//
//  EGHotGoodsView.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/5.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGHotGoodsView.h"

#import "EGImgLbCollectionViewCell.h"

@interface  EGHotGoodsView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *mainCollectionView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UIButton *moreBtn;
@property (nonatomic,strong) NSArray *dataArray;
@end


@implementation EGHotGoodsView


- (UILabel *)titleLb
{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.textAlignment = NSTextAlignmentLeft;
        _titleLb.text = @"熱銷商品";
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
        [_moreBtn setTitle:@"前往商城" forState:UIControlStateNormal];
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
    if ([self.delegate respondsToSelector:@selector(clickHotGoodsForItem:)]) {
        [self.delegate clickHotGoodsForItem:@"more"];
    }
}

- (UICollectionView *)mainCollectionView
{
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _mainCollectionView.backgroundColor = [UIColor clearColor];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        _mainCollectionView.scrollEnabled = false;
        [_mainCollectionView registerClass:[EGImgLbCollectionViewCell class] forCellWithReuseIdentifier:@"EGImgLbCollectionViewCell"];
//        [self addSubview:_mainCollectionView];
    }
    return _mainCollectionView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.titleLb];
        
        [self addSubview:self.moreBtn];
        
        [self addSubview:self.mainCollectionView];
        
        [self getHotGoodsData];
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
        make.height.mas_equalTo(ScaleW(454));
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(24));
        make.right.mas_equalTo(-ScaleW(20));
    }];
    [self.moreBtn layoutButtonWithEdgeInsetsStyle:ZYButtonEdgeInsetsStyleRight imageTitleSpace:1];
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0,ScaleW(0),ScaleW(0),ScaleW(0));
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return ScaleW(16);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return ScaleW(0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemW = Device_Width - ScaleW(56);
    return CGSizeMake(itemW / 2, ScaleW(220));
}
- (CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) { // 假设我们想要为第一个分区设置不同的间距
        return 10.0; // 设置间距为10.0
    } else {
        return 0; // 对于其他分区使用默认值或父类的实现
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EGImgLbCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EGImgLbCollectionViewCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = rgba(243, 243, 243, 1);
    
    NSDictionary *dataDict  = self.dataArray[indexPath.row];

    
    cell.titleLb.text = [dataDict objectForKey:@"name"];
    
    cell.priceLb.text = [NSString stringWithFormat:@"$%@",[dataDict objectForKey:@"price"]];;
    
    NSDictionary *yoast_head_json = [dataDict objectForKey:@"yoast_head_json"];
    NSArray *array = [yoast_head_json objectForKey:@"og_image"];
    NSDictionary *og_image = [array firstObject];
    NSURL *imageURL =  [og_image objectForKey:@"url"];
    [cell.iconImageView sd_setImageWithURL:imageURL];
    
    return cell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dataDict  = self.dataArray[indexPath.row];

//    NSString *name = [dataDict objectForKey:@"name"];
    
    NSDictionary *yoast_head_json = [dataDict objectForKey:@"yoast_head_json"];
    NSString *og_url = [yoast_head_json objectForKey:@"canonical"];//canonical  og_url
    
    if ([self.delegate respondsToSelector:@selector(clickHotGoodsForItem:)]) {
        [self.delegate clickHotGoodsForItem:og_url];
    }
}

-(void)getHotGoodsData
{
    WS(weakSelf);
    NSString *username = @"newsoftapp";
    NSString *password = @"Y21P 5Zsd EtAK dohZ 4WQo XA5L";
    NSString *url = @"https://www.tsghawks.com/wp-json/wc/v3/products?per_page=4&order=desc&status=publish";
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
