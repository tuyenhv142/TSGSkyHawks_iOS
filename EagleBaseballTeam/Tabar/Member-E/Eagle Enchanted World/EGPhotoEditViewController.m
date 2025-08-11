//
//  EGPhotoEditViewController.m
//  EagleBaseballTeam
//
//  Created by Elvin on 2025/6/18.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGPhotoEditViewController.h"

#import <AVFoundation/AVPlayerItem.h>
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVPlayerLayer.h>
#import <PhotosUI/PhotosUI.h>

@interface EGPhotoEditViewController ()
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *upLoadButton;

@property (nonatomic, strong) UIView *previewContainerView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@end

@implementation EGPhotoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"趣味互動";
    self.view.backgroundColor = UIColor.blackColor;
    
    [self setupButton];
    
    [self setupContentView];
    
}
- (void)setupButton {
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectZero];
//    [rightBtn setTitle:NSLocalizedString(@"share", nil) forState:(UIControlStateNormal)];
//    [rightBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"material-symbols_share"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(shareImageVideo) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    // 儲存
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.saveButton.layer.masksToBounds = true;
//    self.saveButton.layer.cornerRadius = ScaleW(35);
//    self.saveButton.layer.borderColor = rgba(0, 122, 96, 1).CGColor;
//    self.saveButton.layer.borderWidth = 5;
    [self.saveButton setImage:[UIImage imageNamed:@"material-symbols_download-rounded"] forState:UIControlStateNormal];
    [self.saveButton setBackgroundImage:[UIImage imageNamed:@"photoIcon"] forState:UIControlStateNormal];
//    [self.saveButton setTitle:@"儲存" forState:UIControlStateNormal];
//    [self.saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(saveCapturePhotoVoide) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-(ScaleW(21)+[UIDevice de_safeDistanceBottom]));
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(ScaleW(70));
        make.height.mas_equalTo(ScaleW(70));
    }];
    [self.saveButton layoutButtonWithEdgeInsetsStyle:ZYButtonEdgeInsetsStyleTop imageTitleSpace:0];
    
    // 上傳
    self.upLoadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.upLoadButton.layer.cornerRadius = ScaleW(21);
    self.upLoadButton.layer.masksToBounds = true;
    [self.upLoadButton setImage:[UIImage imageNamed:@"material-symbols_download-rounded (1)"] forState:UIControlStateNormal];
//    [self.upLoadButton setTitle:@"上傳" forState:UIControlStateNormal];
//    [self.upLoadButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.upLoadButton setBackgroundImage:[UIImage imageWithColor:rgba(0, 122, 96, 1)] forState:UIControlStateNormal];
    [self.upLoadButton addTarget:self action:@selector(upLoadImageVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.upLoadButton];
    [self.upLoadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-ScaleW(24));
        make.centerY.equalTo(self.saveButton);
        make.width.mas_equalTo(ScaleW(42));
        make.height.mas_equalTo(ScaleW(42));
    }];
    [self.upLoadButton layoutButtonWithEdgeInsetsStyle:ZYButtonEdgeInsetsStyleTop imageTitleSpace:0];
    
}

- (void)setupContentView {
    
    CGFloat width = Device_Width;
    CGFloat height = Device_Width;
    CGFloat x = 0;
    CGFloat y = [UIDevice de_navigationFullHeight] * 2;
    
    self.previewContainerView = [[UIView alloc] init];
    self.previewContainerView.frame = CGRectMake(x, y, width, height);
    self.previewContainerView.backgroundColor = [UIColor blackColor];
    self.previewContainerView.layer.cornerRadius = 0;
    self.previewContainerView.clipsToBounds = YES;
    [self.view addSubview:self.previewContainerView];
    
    if (self.image) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.previewContainerView.bounds];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.image = self.image;
        [self.previewContainerView addSubview:self.imageView];
    }
    
    if (self.fileUrl) {
        
//        NSString *urlString = @"https://www.apple.com/105/media/cn/researchkit/2016/a63aa7d4_e6fd_483f_a59d_d962016c8093/films/carekit/researchkit-carekit-cn-20160321_848x480.mp4";
//        AVPlayerItem *currentItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:urlString]];
        
        self.playerItem = [[AVPlayerItem alloc] initWithURL:self.fileUrl];
        if (self.playerItem) {
            
            
            
            self.player =  [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
            self.playerLayer =  [AVPlayerLayer playerLayerWithPlayer:self.player];
            self.playerLayer.frame = self.previewContainerView.bounds;
            self.playerLayer.backgroundColor = [UIColor blackColor].CGColor;
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            
            [self.previewContainerView.layer addSublayer:self.playerLayer];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.playerItem seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
                    [self.player play];
                }];
            });
        }
    }
    
    
}


//播放结束 执行重复播放
- (void)playerItemDidReachEnd:(NSNotification *)notification {
    // 播放结束后将进度设置为0重新播放
    AVPlayerItem *playerItem = notification.object;
    [playerItem seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        [self.player play];
    }];
}

- (void)dealloc
{
    [self.player pause];
    self.player = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.fileUrl) {
        [[ELTmpFileManager shareTmpFile] deleteTemporaryFileWithName:@"movie.mov"];
    }
    
}



//// 处理KVO通知
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    if (object == self.playerItem && [keyPath isEqualToString:@"status"]) {
//        if (self.playerItem.status == AVPlayerItemStatusReadyToPlay) {
//            // 资源准备就绪，开始播放
//            [self.player play];
//        } else if (self.playerItem.status == AVPlayerItemStatusFailed) {
//            // 加载失败，处理错误
//            NSLog(@"播放失败：%@", self.playerItem.error);
//        }
//    }
//}

-(void)shareImageVideo
{
    
    if (self.image) {
        [self shareImage:self.image fromViewController:self];
    }
    
    if (self.fileUrl) {
        [self shareURL:self.fileUrl fromViewController:self];
    }
}
- (void)shareImage:(UIImage *)image fromViewController:(UIViewController *)viewController {
    NSArray *activityItems = @[image];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        activityVC.popoverPresentationController.sourceView = viewController.view;
        activityVC.popoverPresentationController.sourceRect = CGRectMake(viewController.view.bounds.size.width/2, viewController.view.bounds.size.height/4, 0, 0);
    }
    
    [viewController presentViewController:activityVC animated:YES completion:nil];
}
- (void)shareURL:(NSURL *)url fromViewController:(UIViewController *)viewController {
    NSArray *activityItems = @[url];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        activityVC.popoverPresentationController.sourceView = viewController.view;
        activityVC.popoverPresentationController.sourceRect = CGRectMake(viewController.view.bounds.size.width/2, viewController.view.bounds.size.height/4, 0, 0);
    }
    
    [viewController presentViewController:activityVC animated:YES completion:nil];
}


-(void)saveCapturePhotoVoide
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusAuthorized) {
                [self saveVoideOrImageToLibrary];
            } else {
                //ELog(@"用户拒绝相册访问");
                [MBProgressHUD showDelayHidenMessage:NSLocalizedString(@"相冊未授權，請在設置中啟用", nil)];
            }
        });
    }];
    
}
-(void)saveVoideOrImageToLibrary
{
    
    
    if (self.image) {
        
        // 保存图片到App相簿
        UIImage *imageToSave = self.image;
        [ELAlbumManager createAppAlbumIfNeededWithCompletion:^(PHAssetCollection *album, BOOL success) {
            if (success) {
                [ELAlbumManager saveImage:imageToSave toAlbum:album completion:^(BOOL saveSuccess) {
                    if (saveSuccess) {
                        [MBProgressHUD showDelayHidenMessage:@"保存成功"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.navigationController popViewControllerAnimated:true];
                        });
                    } else {
                        NSLog(@"保存失败，请检查权限");
                    }
                }];
            }
        }];
        
//        PHAuthorizationStatus photoStatus = [PHPhotoLibrary authorizationStatus];
//        if (photoStatus != PHAuthorizationStatusAuthorized) {
//            [MBProgressHUD showDelayHidenMessage:NSLocalizedString(@"無法存入相冊，請在設置中啟用", nil)];
//            return;
//        }else{
//            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, NULL);
//            [MBProgressHUD showDelayHidenMessage:@"儲存成功"];
//        }
    }
    
    if (self.fileUrl) {
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:self.fileUrl];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showDelayHidenMessage:@"儲存成功"];
                });
               
            } else {
                ELog(@"保存到相册失败: %@", error.localizedDescription);
            }
        }];
    }
}

-(void)upLoadImageVideo
{
    if (self.image) {
        
        [MBProgressHUD showDelayHidenMessage:@"上傳成功"];
    }
    
    if (self.fileUrl) {
        
        [MBProgressHUD showDelayHidenMessage:@"上傳成功"];
        
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
