//
//  EGEagleFansBigImageViewController.m
//  EagleBaseballTeam
//
//  Created by Elvin on 2025/6/19.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGEagleFansBigImageViewController.h"

#import "EGPhotoCollectionViewCell.h"
#import <AVFoundation/AVFoundation.h>

@interface EGEagleFansBigImageViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) EGTopButtonsView *topBtnView;

@property (nonatomic, strong) UIScrollView *mainscrollView;
@property (nonatomic, strong) UICollectionView *leftCollectionView;
@property (nonatomic, strong) UICollectionView *rightCollectionView;
@property (nonatomic, assign) BOOL isRight;
@property (nonatomic, assign) BOOL isUserScrolling;

@property (nonatomic,strong) NSIndexPath *playIndexPath;
@property (nonatomic, strong) NSArray<NSString *> *videoURLs;


@end

@implementation EGEagleFansBigImageViewController

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
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0.0;
        layout.minimumLineSpacing = 0.0;
        layout.itemSize = CGSizeMake(Device_Width, Device_Width + ScaleW(50));
        _leftCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                collectionViewLayout:layout];
        _leftCollectionView.backgroundColor = [UIColor whiteColor];
        _leftCollectionView.delegate = self;
        _leftCollectionView.dataSource = self;
        _leftCollectionView.showsVerticalScrollIndicator = false;
        [_leftCollectionView registerClass:[PhotoLabelCollectionViewCell class]
                forCellWithReuseIdentifier:@"PhotoLabelCollectionViewCell"];
    }
    return _leftCollectionView;
}
- (UICollectionView *)rightCollectionView
{
    if (!_rightCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0.0;
        layout.minimumLineSpacing = 0.0;
        layout.itemSize = CGSizeMake(Device_Width, Device_Width + ScaleW(50));
        _rightCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                collectionViewLayout:layout];
        _rightCollectionView.backgroundColor = [UIColor whiteColor];
        _rightCollectionView.delegate = self;
        _rightCollectionView.dataSource = self;
        _rightCollectionView.showsVerticalScrollIndicator = false;
        [_rightCollectionView registerClass:[PhotoLabelCollectionViewCell class]
                forCellWithReuseIdentifier:@"PhotoLabelCollectionViewCell"];
    }
    return _rightCollectionView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"鹰迷天地";
    
    WS(weakSelf);
    CGRect rectTop = CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, ScaleW(52));
    self.topBtnView = [[EGTopButtonsView alloc] initWithFrame:rectTop];
    [self.topBtnView setupUIForArray:@[@"鹰迷",@"个人"]];
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
    
    
    if (self.isFans == true) {
        
        self.isRight = false;
        [self.topBtnView setStatusLableForIndex:0];
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf.mainscrollView setContentOffset:CGPointMake(0, 0)];
        }];
        [self.leftCollectionView reloadData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.leftCollectionView scrollToItemAtIndexPath:self.selectIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:true];
        });
        
    }else{
        
        self.isRight = true;
        [self.topBtnView setStatusLableForIndex:1];
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf.mainscrollView setContentOffset:CGPointMake(Device_Width, 0)];
        }];
        [self.rightCollectionView reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.rightCollectionView scrollToItemAtIndexPath:self.selectIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:true];
        });
    }
    
}


- (void)setupCollectionView {
    
    // 配置AVAudioSession，使音频可以在静音模式下播放
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
//    self.videoURLs = @[
//            [NSURL URLWithString:@"https://www.apple.com/105/media/cn/researchkit/2016/a63aa7d4_e6fd_483f_a59d_d962016c8093/films/carekit/researchkit-carekit-cn-20160321_848x480.mp4"],
//            [NSURL URLWithString:@"https://www.bilibili.com/video/BV1bw9iYdEYe/"],
//            [NSURL URLWithString:@"https://www.apple.com/105/media/cn/researchkit/2016/a63aa7d4_e6fd_483f_a59d_d962016c8093/films/carekit/researchkit-carekit-cn-20160321_848x480.mp4"],
//            [NSURL URLWithString:@"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4"]
//            // 添加更多视频URL...
//        ];
    
    self.videoURLs = @[@"https://www.apple.com/105/media/cn/researchkit/2016/a63aa7d4_e6fd_483f_a59d_d962016c8093/films/carekit/researchkit-carekit-cn-20160321_848x480.mp4",
                       @"https://www.apple.com/105/media/cn/researchkit/2016/a63aa7d4_e6fd_483f_a59d_d962016c8093/films/carekit/researchkit-carekit-cn-20160321_848x480.mp4",
                       @"https://www.apple.com/105/media/cn/researchkit/2016/a63aa7d4_e6fd_483f_a59d_d962016c8093/films/carekit/researchkit-carekit-cn-20160321_848x480.mp4",
                       @"https://www.apple.com/105/media/cn/researchkit/2016/a63aa7d4_e6fd_483f_a59d_d962016c8093/films/carekit/researchkit-carekit-cn-20160321_848x480.mp4"];
    
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
    
    PhotoLabelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoLabelCollectionViewCell"
                                                                                   forIndexPath:indexPath];
    
    if (collectionView == self.leftCollectionView) {
//        NSURL *videoURL = [NSURL URLWithString:self.videoURLs[indexPath.item]];
//        [cell configureWithURL:videoURL];
//        // 如果这个cell就是当前正在播放的cell，则让它继续播放
//        // 这可以处理cell滑出屏幕再滑回来时的状态保持
//        if ([self.playIndexPath isEqual:indexPath]) {
//            [cell play];
//        }
        [cell.imageView_private sd_setImageWithURL:[NSURL URLWithString:self.publics[indexPath.item]] placeholderImage:nil];

    }else{
        
        cell.imageView_private.image = self.privates[indexPath.item];
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
    if (collectionView == self.leftCollectionView) {
        
        // 如果点击的是同一个cell，可以根据需求选择暂停或不处理
        if ([self.playIndexPath isEqual:indexPath]) {
            // 例如，点击同一个cell就暂停
            PhotoLabelCollectionViewCell *currentCell = (PhotoLabelCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            if (currentCell.player.rate > 0) {
                 [currentCell pauseTmp]; // 或者 [currentCell.player pause];
        //                     self.playIndexPath = nil;
            } else {
                 [currentCell playTmp];
            }
            return;
        }
        // 1. 停止上一个正在播放的视频
        if (self.playIndexPath) {
            PhotoLabelCollectionViewCell *previousCell = (PhotoLabelCollectionViewCell *)[collectionView cellForItemAtIndexPath:self.playIndexPath];
            // previousCell可能因为滑出屏幕而为nil，所以需要判断
            if (previousCell) {
                [previousCell stop];
            }
        }else{
            // 2. 播放新点击的视频
            PhotoLabelCollectionViewCell *newCell = (PhotoLabelCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            if (newCell) {
                [newCell play];
            }
            // 3. 更新当前播放的IndexPath
            self.playIndexPath = indexPath;
        }
        
        
    }else{
        
    }
}

/**
 * 当一个cell完全从屏幕上消失时，此代理方法会被调用。
 * 这是停止播放视频的最佳位置。
 */
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 1. 检查这个消失的cell是不是当前正在播放的那个cell
    if (self.playIndexPath && [self.playIndexPath isEqual:indexPath]) {
        
        // 2. 如果是，就停止播放并清理资源
        PhotoLabelCollectionViewCell *videoCell = (PhotoLabelCollectionViewCell *)cell;
        [videoCell stop];
        // 3. 将当前播放的indexPath置为nil，因为已经没有视频在播放了
        self.playIndexPath = nil;
    }
}
@end
