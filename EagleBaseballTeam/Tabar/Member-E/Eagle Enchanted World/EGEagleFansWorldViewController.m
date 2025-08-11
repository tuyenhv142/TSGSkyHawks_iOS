//
//  EGEagleFansWorldViewController.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/6/16.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGEagleFansWorldViewController.h"

#import "EGPhotoCollectionViewCell.h"
#import "EGPhotoGraphViewController.h"

#import "EGEagleFansBigImageViewController.h"

@interface EGEagleFansWorldViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) EGTopButtonsView *topBtnView;

@property (nonatomic, strong) UIScrollView *mainscrollView;
@property (nonatomic, strong) UICollectionView *leftCollectionView;
@property (nonatomic, strong) UICollectionView *rightCollectionView;
@property (nonatomic, assign) BOOL isRight;
@property (nonatomic, assign) BOOL isUserScrolling;

@property (nonatomic, strong) NSMutableArray <NSString *> *publics;
@property (nonatomic, strong) NSMutableArray <UIImage *>*privates;
@end

@implementation EGEagleFansWorldViewController

- (UIScrollView *)mainscrollView
{
    if (!_mainscrollView) {
        _mainscrollView = [[UIScrollView alloc] init];
        _mainscrollView.backgroundColor = [UIColor colorWithRed:0.962 green:0.962 blue:0.962 alpha:1.0];
        _mainscrollView.delegate = self;
        _mainscrollView.pagingEnabled = YES;
        _mainscrollView.scrollEnabled = YES;
        _mainscrollView.bounces = YES;
        _mainscrollView.showsHorizontalScrollIndicator = false;
    }
    return _mainscrollView;
}

- (UICollectionView *)leftCollectionView
{
    if (!_leftCollectionView) {
        
        ELCustomPhotoLayout *layout = [[ELCustomPhotoLayout alloc] init];
        layout.itemSpacing = 1.0;
        layout.lineSpacing = 1.0;
        _leftCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                collectionViewLayout:layout];
        _leftCollectionView.backgroundColor = [UIColor whiteColor];
        _leftCollectionView.delegate = self;
        _leftCollectionView.dataSource = self;
        _leftCollectionView.showsVerticalScrollIndicator = false;
        [_leftCollectionView registerClass:[EGPhotoCollectionViewCell class]
                forCellWithReuseIdentifier:@"EGPhotoCollectionViewCell"];
    }
    return _leftCollectionView;
}
- (UICollectionView *)rightCollectionView
{
    if (!_rightCollectionView) {
        
        ELCustomPhotoLayout *layout = [[ELCustomPhotoLayout alloc] init];
        layout.itemSpacing = 1.0;
        layout.lineSpacing = 1.0;
        _rightCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                collectionViewLayout:layout];
        _rightCollectionView.backgroundColor = [UIColor whiteColor];
        _rightCollectionView.delegate = self;
        _rightCollectionView.dataSource = self;
        _rightCollectionView.showsVerticalScrollIndicator = false;
        [_rightCollectionView registerClass:[EGPhotoCollectionViewCell class]
                forCellWithReuseIdentifier:@"EGPhotoCollectionViewCell"];
    }
    return _rightCollectionView;
}

- (NSMutableArray *)privates{
    if (!_privates) {
        _privates = [NSMutableArray array];
    }
    return _privates;
}
- (NSMutableArray<NSString *> *)publics
{
    if (!_publics) {
        _publics = [NSMutableArray array];
    }
    return _publics;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"鷹迷天地";
    
    WS(weakSelf);
    CGRect rectTop = CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, ScaleW(52));
    self.topBtnView = [[EGTopButtonsView alloc] initWithFrame:rectTop];
    [self.topBtnView setupUIForArray:@[@"鷹迷",@"個人"]];
    self.topBtnView.clickBtnBlock = ^(NSInteger index) {
        weakSelf.isRight = index;
        if (weakSelf.isRight) {
            [weakSelf.rightCollectionView reloadData];
        }else{
            [weakSelf.leftCollectionView reloadData];
        }
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf.mainscrollView setContentOffset:CGPointMake(index * Device_Width, 0)];
        }];
    };
    [self.view addSubview:self.topBtnView];
    
    
    [self setupCollectionView];

    
    NSArray <PHAsset *> *assets = [ELAlbumManager fetchAllAssetsInAppAlbum];
    // 2. 遍历图片资源
    for (PHAsset *asset in assets) {
        NSLog(@"图片ID: %@", asset.localIdentifier);
        NSLog(@"创建时间: %@", asset.creationDate);
        // 如果需要获取图片本身
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        [[PHImageManager defaultManager] requestImageForAsset:asset
                                                  targetSize:CGSizeMake(1024, 1024) // 缩略图尺寸
                                                 contentMode:PHImageContentModeAspectFill
                                                     options:options
                                               resultHandler:^(UIImage *image, NSDictionary *info) {
            [self.privates addObject:image];
        }];
    }
    
}
- (void)setupCollectionView
{
    CGFloat scrtop = [UIDevice de_navigationFullHeight] + ScaleW(52);
    CGRect rectScro = CGRectMake(0, scrtop, Device_Width, Device_Height - scrtop);
    self.mainscrollView.frame = rectScro;
    [self.view addSubview:self.mainscrollView];
    self.mainscrollView.contentSize = CGSizeMake(Device_Width * 2, 0);
    
    CGRect contentRect = CGRectMake(0, 0, Device_Width*2, Device_Height-scrtop);
    UIView *contentview = [UIView new];
    contentview.backgroundColor = UIColor.clearColor;
    contentview.frame = contentRect;
    [self.mainscrollView addSubview:contentview];
    
    [contentview addSubview:self.leftCollectionView];
    [self.leftCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(Device_Width);
        make.bottom.mas_equalTo(0);
    }];
    
    [contentview addSubview:self.rightCollectionView];
    [self.rightCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(Device_Width);
        make.width.mas_equalTo(Device_Width);
        make.bottom.mas_equalTo(0);
    }];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if ([scrollView isKindOfClass:[UICollectionView class]])
    {
        return;
    }
    if (self.isUserScrolling) {
        NSInteger index = scrollView.contentOffset.x / UIScreen.mainScreen.bounds.size.width;
        [self.topBtnView setStatusLableForIndex:index];
    }
    if (self.isRight) {
        [self.rightCollectionView reloadData];
    }else{
        [self.leftCollectionView reloadData];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isUserScrolling = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.isUserScrolling)
        return;
    
    if ([scrollView isKindOfClass:[UICollectionView class]])
    {
        return;
    }
    NSInteger index = scrollView.contentOffset.x / UIScreen.mainScreen.bounds.size.width;
    [self.topBtnView setStatusLableForIndex:index];
    
    self.isRight = index;
}

//-(void)albumSelectionOfImages
//{
//    EGPhotoGraphViewController *camer = [EGPhotoGraphViewController new];
//    [self.navigationController pushViewController:camer animated:true];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


// CollectionView数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.leftCollectionView) {
        return self.publics.count;
    }
    return self.privates.count; // 根据实际照片数量调整
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    EGPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EGPhotoCollectionViewCell"
                                                                                forIndexPath:indexPath];
    if (collectionView == self.leftCollectionView) {
        
    }else{
        cell.imageView.image = self.privates[indexPath.item];
    }
    return cell;
}


//- (CGSize)collectionView:(UICollectionView *)collectionView
//                  layout:(UICollectionViewFlowLayout *)collectionViewLayout
//  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    // 根据图片显示，第一个cell占据两个普通cell的空间
//    if (indexPath.item == 0 || indexPath.item == 6) {
//        // 大cell的宽度为屏幕宽度的2/3
//        CGFloat bigCellWidth = (self.view.frame.size.width - 2) * 2/3;
//        return CGSizeMake(bigCellWidth, bigCellWidth);
//    } else {
//        // 普通cell的宽度为屏幕宽度的1/3
//        CGFloat normalCellWidth = (self.view.frame.size.width - 2) / 3;
//        return CGSizeMake(normalCellWidth-3, normalCellWidth);
//    }
//}
//
//// 设置每个section的边距
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
//                        layout:(UICollectionViewFlowLayout *)collectionViewLayout
//        insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(1, 0, 1, 0);
//}
//
//// 设置每行之间的最小间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView
//                   layout:(UICollectionViewFlowLayout *)collectionViewLayout
// minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 1;
//}
//
//// 设置每列之间的最小间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView
//                   layout:(UICollectionViewFlowLayout *)collectionViewLayout
// minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 1;
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EGEagleFansBigImageViewController *bigImage = [EGEagleFansBigImageViewController new];
    bigImage.selectIndexPath = indexPath;
    bigImage.publics = self.publics;
    bigImage.privates = self.privates;
    if (collectionView == self.leftCollectionView) {
        bigImage.isFans = true;
    }else{
        bigImage.isFans = false;
    }
    
    [self.navigationController pushViewController:bigImage animated:true];
}
@end
