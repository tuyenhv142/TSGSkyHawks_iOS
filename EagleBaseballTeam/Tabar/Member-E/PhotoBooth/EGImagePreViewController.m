//
//  EGImagePreViewController.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/4/8.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGImagePreViewController.h"

#import <PhotosUI/PhotosUI.h>

@interface EGImagePreViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *shareButton;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *bottomImageView; // 底部可操作的图片
@property (nonatomic, strong) UIImageView *topImageView;    // 顶部参考图片
@property (nonatomic, assign) CGRect rectImg;

@property (nonatomic, assign) CGFloat currentRotation;
@end

@implementation EGImagePreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    CGFloat width = Device_Width;
    CGFloat height = Device_Width;
    CGFloat x = 0;
    CGFloat y = [UIDevice de_navigationFullHeight] * 2;
    CGRect rect = CGRectMake(x, y, width, height);
    self.rectImg = rect;
    
    [self setupBottomImageView];
    
    [self addResetButton];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)setupBottomImageView {
    
    // 创建ScrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.rectImg];
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale = 0.5;
    self.scrollView.maximumZoomScale = 3.0;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    
    self.bottomImageView = [[UIImageView alloc] initWithFrame:self.scrollView.bounds];
    self.bottomImageView.image = self.bottomImage;
    self.bottomImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bottomImageView.userInteractionEnabled = YES;
    [self.scrollView addSubview:self.bottomImageView];
    
    // 设置ScrollView内容大小
    self.scrollView.contentSize = self.bottomImageView.frame.size;
    
    // 创建顶部图片视图
    self.topImageView = [[UIImageView alloc] initWithFrame:self.rectImg];
    self.topImageView.image = self.topImage;
    self.topImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.topImageView.alpha = 1; // 设置为半透明以便看到底部图片
    self.topImageView.userInteractionEnabled = NO;
    [self.view addSubview:self.topImageView];
    
//    // 添加双击手势
//    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
//    doubleTap.numberOfTapsRequired = 2;
//    [self.bottomImageView addGestureRecognizer:doubleTap];
//    
    
    // 添加拖动手势
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [self.bottomImageView addGestureRecognizer:panGesture];
        
        // 添加旋转手势
        UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotationGesture:)];
        [self.bottomImageView addGestureRecognizer:rotationGesture];
        
        // 添加缩放手势
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
        [self.bottomImageView addGestureRecognizer:pinchGesture];
        
        // 允许多个手势同时识别
        panGesture.delegate = self;
        rotationGesture.delegate = self;
        pinchGesture.delegate = self;
    
}
#pragma mark ---UIGestureRecognizerDelegate
// 允许同时识别多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
    shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)addResetButton {
    // 儲存
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveButton setImage:[UIImage imageNamed:@"material-symbols_download-rounded"] forState:UIControlStateNormal];
//    [self.saveButton setTitle:@"儲存" forState:UIControlStateNormal];
//    [self.saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.saveButton setBackgroundImage:[UIImage imageNamed:@"photoIcon"] forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(saveImageToAlbumAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-(ScaleW(21)+[UIDevice de_safeDistanceBottom]));
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(ScaleW(70));
        make.height.mas_equalTo(ScaleW(70));
    }];
    [self.saveButton layoutButtonWithEdgeInsetsStyle:ZYButtonEdgeInsetsStyleTop imageTitleSpace:0];
    
    // 上傳
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareButton.layer.cornerRadius = ScaleW(21);
    self.shareButton.layer.masksToBounds = true;
    [self.shareButton setImage:[UIImage imageNamed:@"material-symbols_share"] forState:UIControlStateNormal];
//    [self.shareButton setTitle:@"分享" forState:UIControlStateNormal];
//    [self.shareButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.shareButton setBackgroundImage:[UIImage imageWithColor:rgba(0, 122, 96, 1)] forState:UIControlStateNormal];
    [self.shareButton addTarget:self action:@selector(shareImageVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.shareButton];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-ScaleW(24));
        make.centerY.equalTo(self.saveButton);
        make.width.mas_equalTo(ScaleW(42));
        make.height.mas_equalTo(ScaleW(42));
    }];
    [self.shareButton layoutButtonWithEdgeInsetsStyle:ZYButtonEdgeInsetsStyleTop imageTitleSpace:0];
    
}

#pragma mark --- save image
- (void)saveImageToAlbumAction
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusAuthorized) {
                [self saveImageToAlbum];
            } else {
                //ELog(@"用户拒绝相册访问");
                [MBProgressHUD showDelayHidenMessage:NSLocalizedString(@"相冊未授權，請在設置中啟用", nil)];
            }
        });
    }];
}

- (void)saveImageToAlbum
{
//    UIImage *croppedImage = [self croppedImageFromScrollView];
//    UIImage *result = [self combineImage:croppedImage topImage:self.topImageView.image atPosition:CGPointMake(0, 0)];
    
    UIImage *result = [self combineUsingSnapshot];
    PHAuthorizationStatus photoStatus = [PHPhotoLibrary authorizationStatus];
    if (photoStatus != PHAuthorizationStatusAuthorized) {
        [MBProgressHUD showDelayHidenMessage:NSLocalizedString(@"無法存入相冊，請在設置中啟用", nil)];
        return;
    }else{
        UIImageWriteToSavedPhotosAlbum(result, nil, nil, NULL);
        [MBProgressHUD showDelayHidenMessage:@"保存成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:true];
        });
    }
    
//    // 保存图片到App相簿
//    UIImage *imageToSave = [self combineUsingSnapshot];
//    [ELAlbumManager createAppAlbumIfNeededWithCompletion:^(PHAssetCollection *album, BOOL success) {
//        if (success) {
//            [ELAlbumManager saveImage:imageToSave toAlbum:album completion:^(BOOL saveSuccess) {
//                if (saveSuccess) {
//                    [MBProgressHUD showDelayHidenMessage:@"保存成功"];
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [self.navigationController popViewControllerAnimated:true];
//                    });
//                } else {
//                    NSLog(@"保存失败，请检查权限");
//                }
//            }];
//        }
//    }];
    
    
}


#pragma mark --- share image
-(void)shareImageVideo
{
    UIImage *result = [self combineUsingSnapshot];
    NSArray *activityItems = @[result];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}

#pragma mark - 手势处理方法
// 拖动手势处理
- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture {
    UIView *view = gesture.view;
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:view.superview];
        [view setCenter:CGPointMake(view.center.x + translation.x, view.center.y + translation.y)];
        [gesture setTranslation:CGPointZero inView:view.superview];
    }
}
// 旋转手势处理
- (void)handleRotationGesture:(UIRotationGestureRecognizer *)gesture {
    UIView *view = gesture.view;
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformRotate(view.transform, gesture.rotation);
        gesture.rotation = 0;
    }
}

// 缩放手势处理
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)gesture {
    UIView *view = gesture.view;
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, gesture.scale, gesture.scale);
        gesture.scale = 1;
    }
}

- (UIImage *)combineUsingSnapshot
{
    UIView *containerView = [[UIView alloc] initWithFrame:self.rectImg];
    containerView.backgroundColor = UIColor.blackColor;
    
    UIImageView *bottomCopy = [[UIImageView alloc] initWithFrame:containerView.bounds];
    bottomCopy.contentMode = UIViewContentModeScaleAspectFit;
    bottomCopy.image = self.bottomImageView.image;
    bottomCopy.transform = self.bottomImageView.transform;
    [containerView addSubview:self.bottomImageView];
    UIImageView *topCopy = [[UIImageView alloc] initWithFrame:containerView.bounds];
    topCopy.contentMode = UIViewContentModeScaleAspectFit;
    topCopy.image = self.topImageView.image;
    [containerView addSubview:topCopy];
    
    UIGraphicsBeginImageContextWithOptions(containerView.bounds.size, NO, [UIScreen mainScreen].scale);
    [containerView drawViewHierarchyInRect:containerView.bounds afterScreenUpdates:YES];
    UIImage *combinedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *resultImageView = [[UIImageView alloc] initWithImage:combinedImage];
    resultImageView.frame = self.rectImg;
    [self.view addSubview:resultImageView];
    
    return combinedImage;
}



#pragma mark - UIScrollViewDelegate
//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
//    return self.bottomImageView;
//}
//
//- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
//    // 居中显示图片
//    [self centerImageView];
//}

//#pragma mark - 手势处理
//- (void)handleDoubleTap:(UITapGestureRecognizer *)gesture {
//    if (self.scrollView.zoomScale > self.scrollView.minimumZoomScale) {
//        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
//    } else {
//        CGPoint touchPoint = [gesture locationInView:self.bottomImageView];
//        CGRect zoomRect = [self zoomRectForScale:self.scrollView.maximumZoomScale withCenter:touchPoint];
//        [self.scrollView zoomToRect:zoomRect animated:YES];
//    }
//}
#pragma mark - 辅助方法
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    CGRect zoomRect;
    zoomRect.size.height = self.scrollView.frame.size.height / scale;
    zoomRect.size.width  = self.scrollView.frame.size.width / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}

- (void)centerImageView {
    // 居中显示图片
    CGFloat offsetX = MAX((self.scrollView.bounds.size.width - self.scrollView.contentSize.width) * 0.5, 0.0);
    CGFloat offsetY = MAX((self.scrollView.bounds.size.height - self.scrollView.contentSize.height) * 0.5, 0.0);
    
    self.bottomImageView.center = CGPointMake(self.scrollView.contentSize.width * 0.5 + offsetX,
                                             self.scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)resetImagePosition {
    
    [self.scrollView setZoomScale:1.0 animated:YES];
    self.scrollView.contentOffset = CGPointZero;
    
    self.bottomImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
}


- (UIImage *)croppedImageFromScrollView {
    // 获取当前可见区域相对于 imageView 的 rect
    CGRect visibleRect;
    visibleRect.origin = self.scrollView.contentOffset;
    visibleRect.size = self.scrollView.bounds.size;
    
    // 计算缩放比例
    float scale = 1.0 / self.bottomImageView.transform.a;
    
    // 转换 rect 到图像坐标系
    visibleRect.origin.x *= scale;
    visibleRect.origin.y *= scale;
    visibleRect.size.width *= scale;
    visibleRect.size.height *= scale;
    
    // 确保 rect 不会超出图像边界
    visibleRect.origin.x = MAX(visibleRect.origin.x, 0);
    visibleRect.origin.y = MAX(visibleRect.origin.y, 0);
    visibleRect.size.width = MIN(visibleRect.size.width, self.bottomImageView.image.size.width - visibleRect.origin.x);
    visibleRect.size.height = MIN(visibleRect.size.height, self.bottomImageView.image.size.height - visibleRect.origin.y);
    
    // 创建图像上下文并绘制
    UIGraphicsBeginImageContextWithOptions(visibleRect.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 调整坐标系
    CGContextTranslateCTM(context, -visibleRect.origin.x, -visibleRect.origin.y);
    // 绘制图像
    [self.bottomImageView.layer renderInContext:context];
    
//            // 1. 计算两个视图的实际显示区域（考虑旋转）
//            CGRect totalRect = CGRectUnion(self.topImageView.frame,
//                                             CGRectApplyAffineTransform(self.bottomImageView.bounds,
//                                                                      self.bottomImageView.transform));
//            // 2. 创建足够大的图形上下文
//            UIGraphicsBeginImageContextWithOptions(totalRect.size, NO, 0.0);
//
//            // 3. 调整绘制位置
//            CGContextRef context = UIGraphicsGetCurrentContext();
//            CGContextTranslateCTM(context, -totalRect.origin.x, -totalRect.origin.y);
//            // 4. 绘制底部ImageView（带旋转）
//            CGContextSaveGState(context);
//            CGContextTranslateCTM(context,
//                             self.bottomImageView.center.x - totalRect.origin.x,
//                             self.bottomImageView.center.y - totalRect.origin.y);
//            CGContextConcatCTM(context, self.bottomImageView.transform);
//            CGContextTranslateCTM(context,
//                             -self.bottomImageView.bounds.size.width/2,
//                             -self.bottomImageView.bounds.size.height/2);
//            [self.bottomImageView.image drawInRect:self.bottomImageView.bounds];
//            CGContextRestoreGState(context);
    
    // 获取裁剪后的图像
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return croppedImage;
}

- (UIImage *)combineImage:(UIImage *)bottomImage topImage:(UIImage *)topImage atPosition:(CGPoint)position {
    // 1. 获取底图尺寸
    CGSize bottomSize = self.rectImg.size;//bottomImage.size;
    
    // 2. 开启图形上下文（以底图尺寸为准）
    UIGraphicsBeginImageContextWithOptions(bottomSize, NO, [UIScreen mainScreen].scale);
    
    // 3. 绘制底图
    [bottomImage drawInRect:CGRectMake(0, 0, bottomSize.width, bottomSize.height)];
    
    // 4. 绘制顶图（可自定义位置）
    [topImage drawInRect:CGRectMake(position.x, position.y, bottomSize.width, bottomSize.width)];
    
    // 5. 获取合成图片
    UIImage *combinedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 6. 关闭上下文
    UIGraphicsEndImageContext();
    
    return combinedImage;
}
@end
