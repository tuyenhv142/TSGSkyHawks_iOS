//
//  EGrouPhotoViewController.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/3/31.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGrouPhotoViewController.h"

#import <Photos/Photos.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <PhotosUI/PhotosUI.h>
#import "EGImagePreViewController.h"

@interface EGrouPhotoViewController ()<AVCapturePhotoCaptureDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout ,PHPickerViewControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,assign) NSInteger itemsIndex;
@property (nonatomic,strong) NSArray *bigImages;
@property (nonatomic,strong) NSArray *iconImages;

@property (nonatomic, strong) UIView *previewContainerView;
@property (nonatomic, strong) dispatch_queue_t sessionQueue;
@property (nonatomic, strong) UIImageView *markImageView;


@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCapturePhotoOutput *photoOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureDevice *backCamera;

@property (nonatomic, strong) UIButton *captureButton;
@property (nonatomic, strong) UIButton *switchCameraButton;
@property (nonatomic, strong) UIButton *lightingButton;
@property (nonatomic, strong) UIButton *filterButton;


@end

@implementation EGrouPhotoViewController

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[ModelCollectionViewCell class] forCellWithReuseIdentifier:@"ModelCollectionViewCell"];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0,ScaleW(0),ScaleW(0),ScaleW(0));
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return ScaleW(16);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return ScaleW(10);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(ScaleW(50), ScaleW(50));
}
- (CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) { // 假设我们想要为第一个分区设置不同的间距
        return 10.0; // 设置间距为10.0
    } else {
        return 0; // 对于其他分区使用默认值或父类的实现
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.markImageView.image = [UIImage imageNamed:self.bigImages[indexPath.item]];
    self.itemsIndex = indexPath.item;
    [self.collectionView reloadData];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ModelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ModelCollectionViewCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = UIColor.whiteColor;
    [cell setImageName:self.iconImages[indexPath.item]];
    cell.contentView.layer.borderWidth = ScaleW(5);
    if (self.itemsIndex == indexPath.item) {
        cell.contentView.layer.borderColor = rgba(217, 174, 53, 1).CGColor;
    }else{
        cell.contentView.layer.borderColor = UIColor.whiteColor.CGColor;
    }
    return cell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.iconImages.count;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"球迷互動";
    self.view.backgroundColor = UIColor.blackColor;
    
    self.itemsIndex = 0;
    self.iconImages = @[@"ballMemberIcon0",@"ballMemberIcon1",@"ballMemberIcon2"];
    self.bigImages = @[@"ballMember0",@"ballMember1",@"ballMember2"];
    
    [self setupPreviewContainerView];
    [self setupUI];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.previewContainerView.mas_bottom).offset(ScaleW(30));
        make.left.mas_equalTo(ScaleW(20));
        make.right.mas_equalTo(-ScaleW(20));
        make.height.mas_equalTo(ScaleW(50));
    }];
    [self.collectionView reloadData];
    
    [self checkCameraPermissionWithCompletion:^(BOOL granted) {
            if (granted) {
                // 有权限，打开相机
                [self setupCamera];
                
            } else {
                // 无权限，显示提示
                NSString *message = [NSString stringWithFormat:@"相機權限未打開,請前往設置"];
                [ELAlertController alertControllerWithTitleName:@"相機權限" andMessage:message cancelButtonTitle:@"取消" confirmButtonTitle:@"去設置" showViewController:self addCancelClickBlock:^(UIAlertAction * _Nonnull cancelAction) {
                    [self.navigationController popViewControllerAnimated:true];
                } addConfirmClickBlock:^(UIAlertAction * _Nonnull SureAction) {
                    [self openAppSettings];
                }];
            }
        }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_sessionQueue) {
        dispatch_async(_sessionQueue, ^{
            [self.captureSession startRunning];
        });
    }
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (_sessionQueue) {
        dispatch_async(_sessionQueue, ^{
            if ([self.captureSession isRunning]) {
                [self.captureSession stopRunning];
            }
        });
    }
}


- (void)checkCameraPermissionWithCompletion:(void(^)(BOOL granted))completion {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    switch (status) {
        case AVAuthorizationStatusAuthorized: {
            // 用户已授权访问相机
            if (completion) {
                completion(YES);
            }
            break;
        }
        case AVAuthorizationStatusNotDetermined: {
            // 用户尚未做出选择，请求权限
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(granted);
                    }
                });
            }];
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted: {
            // 用户已拒绝或设备限制
            if (completion) {
                completion(NO);
            }
            break;
        }
    }
}
// 跳转到应用的设置页面
- (void)openAppSettings {
    NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    
    if ([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:settingsURL options:@{} completionHandler:^(BOOL success) {
                if (!success) {
                    ELog(@"无法打开设置页面");
                }
            }];
        } else {
            // iOS 10 以下版本
            [[UIApplication sharedApplication] openURL:settingsURL options:@{} completionHandler:nil];
        }
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
// 新增设置预览容器view的方法
- (void)setupPreviewContainerView {
    
    self.previewContainerView = [[UIView alloc] init];
    CGFloat width = Device_Width;
    CGFloat height = Device_Width;
    CGFloat x = 0;
    CGFloat y = [UIDevice de_navigationFullHeight] * 2;
    self.previewContainerView.frame = CGRectMake(x, y, width, height);
    self.previewContainerView.backgroundColor = [UIColor blackColor];
    self.previewContainerView.layer.cornerRadius = 0;
    self.previewContainerView.clipsToBounds = YES;
    [self.view addSubview:self.previewContainerView];
    
    self.markImageView = [UIImageView new];
    self.markImageView.image = [UIImage imageNamed:[self.bigImages firstObject]];
    self.markImageView.frame = CGRectMake(x, y, width , height);
    self.markImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.markImageView];
    [self.markImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.previewContainerView.mas_left);
        make.bottom.equalTo(self.previewContainerView.mas_bottom);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    
    [self setupCamera];
}

- (void)setupCamera {
    
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
    
    AVCaptureDevicePosition position = AVCaptureDevicePositionFront ;
    AVCaptureDevice *frontCamera = [self cameraWithPosition:position];
//    AVCaptureDevice *backCamera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.backCamera = frontCamera;
    NSError *error;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
    
    if (!error) {
        self.photoOutput = [[AVCapturePhotoOutput alloc] init];
        if ([self.captureSession canAddInput:input] && [self.captureSession canAddOutput:self.photoOutput]) {
            [self.captureSession addInput:input];
            [self.captureSession addOutput:self.photoOutput];
            [self setupPreviewLayer];
        }
    }
}

- (void)setupPreviewLayer {
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.frame = self.previewContainerView.bounds;
    [self.previewContainerView.layer addSublayer:self.previewLayer];
    
    self.sessionQueue = dispatch_queue_create("com.yourapp.captureSessionQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(self.sessionQueue, ^{
            if (![self.captureSession isRunning]) {
                [self.captureSession startRunning];
            }
        });
}
- (void)dealloc
{
    if ([self.captureSession isRunning]) {
        [self.captureSession stopRunning];
    }
}


- (void)setupUI {
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [rightBtn setTitle:NSLocalizedString(@"相簿", nil) forState:(UIControlStateNormal)];
    [rightBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(albumSelectionOfImages) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    // 拍照按钮
    self.captureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.captureButton.layer.masksToBounds = true;
    self.captureButton.layer.cornerRadius = ScaleW(35);
    self.captureButton.layer.borderColor = rgba(0, 122, 96, 1).CGColor;
    self.captureButton.layer.borderWidth = 5;
    [self.lightingButton setImage:[UIImage imageWithColor:rgba(243, 243, 243, 2)] forState:UIControlStateNormal];
    self.captureButton.backgroundColor = UIColor.whiteColor;
    [self.captureButton addTarget:self action:@selector(capturePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.captureButton];
    [self.captureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-(ScaleW(21)+[UIDevice de_safeDistanceBottom]));
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(ScaleW(70));
        make.height.mas_equalTo(ScaleW(70));
    }];
    
    //闪光灯
    self.lightingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.lightingButton.layer.masksToBounds = true;
    self.lightingButton.layer.cornerRadius = ScaleW(21);
    [self.lightingButton setImage:[UIImage imageNamed:@"bolt-slash"] forState:UIControlStateNormal];
    [self.lightingButton setImage:[UIImage imageNamed:@"bolt"] forState:UIControlStateSelected];
    self.lightingButton.backgroundColor = rgba(0, 122, 96, 1);
    [self.lightingButton addTarget:self action:@selector(switchLighting:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.lightingButton];
    [self.lightingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScaleW(24));
        make.centerY.equalTo(self.captureButton);
        make.width.mas_equalTo(ScaleW(42));
        make.height.mas_equalTo(ScaleW(42));
    }];
    
    // 切换摄像头按钮
    self.switchCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.switchCameraButton.layer.masksToBounds = true;
    self.switchCameraButton.layer.cornerRadius = ScaleW(21);
    [self.switchCameraButton setImage:[UIImage imageNamed:@"arrow-path"] forState:UIControlStateNormal];
    self.switchCameraButton.backgroundColor = rgba(0, 122, 96, 1);
    [self.switchCameraButton addTarget:self action:@selector(switchCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.switchCameraButton];
    [self.switchCameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-ScaleW(24));
        make.centerY.equalTo(self.captureButton);
        make.width.mas_equalTo(ScaleW(42));
        make.height.mas_equalTo(ScaleW(42));
    }];
}

-(void)switchLighting:(UIButton *)sender
{
    sender.selected = !sender.selected;
}
- (void)capturePhoto {
    AVCapturePhotoSettings *settings = [AVCapturePhotoSettings photoSettings];
    if (self.lightingButton.selected) {
        settings.flashMode = AVCaptureFlashModeOn;
    }else{
        settings.flashMode = AVCaptureFlashModeOff;
    }
    [self.photoOutput capturePhotoWithSettings:settings delegate:self];
}

- (void)switchCamera {
    
    AVCaptureDevicePosition currentPosition = ((AVCaptureDeviceInput*)self.captureSession.inputs.firstObject).device.position;
    AVCaptureDevicePosition newPosition = currentPosition == AVCaptureDevicePositionBack ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
    
    AVCaptureDevice *newCamera = [self cameraWithPosition:newPosition];
    AVCaptureDeviceInput *newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
    
    [self.captureSession beginConfiguration];
    [self.captureSession removeInput:self.captureSession.inputs.firstObject];
    [self.captureSession addInput:newInput];
    [self.captureSession commitConfiguration];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
//    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceDiscoverySession *videoDeviceDiscoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera, AVCaptureDeviceTypeBuiltInTelephotoCamera, AVCaptureDeviceTypeBuiltInDualCamera] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionUnspecified];
    NSArray<AVCaptureDevice *> *devices = videoDeviceDiscoverySession.devices;
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

#pragma mark - AVCapturePhotoCaptureDelegate

- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(nullable NSError *)error {
    if (!error) {
        
//        UIImage *showimage = [self squareImageFromGraphicsImageContext:photo];//压缩了
//        UIImage *squareImage = [self squareImageFromImage:photo];//底部盖不全
        
//        UIImage *cropImage = [self cropImageToSquare001:photo];//ok
//        UIImage *result = [self combineImage:cropImage topImage:self.markImageView.image atPosition:CGPointMake(0, 0)];
//        PHAuthorizationStatus photoStatus = [PHPhotoLibrary authorizationStatus];
//        if (photoStatus != PHAuthorizationStatusAuthorized) {
//            [MBProgressHUD showDelayHidenMessage:NSLocalizedString(@"無法存入相冊，請在設置中啟用", nil)];
//            return;
//        }else{
//            UIImageWriteToSavedPhotosAlbum(result, nil, nil, NULL);
//            [MBProgressHUD showDelayHidenMessage:@"保存成功"];
//        }
        
        NSData *data = [photo fileDataRepresentation];
        UIImage *image = [UIImage imageWithData:data];
        
        AVCaptureDevicePosition currentPosition = ((AVCaptureDeviceInput*)self.captureSession.inputs.firstObject).device.position;
        if (currentPosition == AVCaptureDevicePositionFront) {
            image = [UIImage imageWithCGImage:image.CGImage
                                               scale:image.scale
                                         orientation:UIImageOrientationLeftMirrored];
            // 或者使用 `UIImageOrientationUpMirrored` 取决于你的需求
        }
        
        EGImagePreViewController *preView = [EGImagePreViewController new];
        preView.bottomImage = image;
        preView.topImage = self.markImageView.image;
        [self.navigationController pushViewController:preView animated:true];
    }
}


- (UIImage *)combineImage:(UIImage *)bottomImage topImage:(UIImage *)topImage atPosition:(CGPoint)position {
    // 1. 获取底图尺寸
    CGSize bottomSize = bottomImage.size;
    
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

// 将图片裁剪为正方形
- (UIImage *)squareImageFromImage:(AVCapturePhoto *)photo {
    
    // 将 AVCapturePhoto 转换为 UIImage
    NSData *imageData = [photo fileDataRepresentation];
    UIImage *image = [UIImage imageWithData:imageData];
    
    CGFloat originalWidth = image.size.width * image.scale;
    CGFloat originalHeight = image.size.height * image.scale;
    
    CGFloat newSize = MIN(originalWidth, originalHeight);
    CGFloat x = (originalWidth - newSize) / 2.0;
    CGFloat y = (originalHeight - newSize) / 2.0;
    
    CGRect cropRect = CGRectMake(x, y, newSize, newSize);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    
    return croppedImage;
}
// 将图片裁剪为正方形002
- (UIImage *)squareImageFromGraphicsImageContext:(AVCapturePhoto *)photo {
    
    CGImageRef ref = [photo CGImageRepresentation];
    NSData *data = [photo fileDataRepresentation];
    CIImage *c_image = [CIImage imageWithCGImage:ref];
    CIImage *enhancedImage = [CIImage imageWithData:data];
//        CGFloat height = c_image.extent.size.width;
//        CGFloat width = c_image.extent.size.height;
    CGFloat originalWidth = c_image.extent.size.height;
    CGFloat originalHeight = c_image.extent.size.width;
    CGFloat newSize = MIN(originalWidth, originalHeight);
    CGFloat x = (originalHeight - newSize) / 2.0;
    CGFloat y = (originalWidth - newSize) / 2.0;
    CGRect cropRect = CGRectMake(0, y, newSize, newSize - x);
    
    UIGraphicsBeginImageContext(CGSizeMake(newSize, newSize));
    [[UIImage imageWithCIImage:enhancedImage scale:1.0 orientation:UIImageOrientationRight] drawInRect:cropRect];
    UIImage *showimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return showimage;
}

- (UIImage *)cropImageToSquare001:(AVCapturePhoto *)photo {
    
    NSData *data = [photo fileDataRepresentation];
    UIImage *image = [UIImage imageWithData:data];
    
    CGFloat shortSide = MIN(image.size.width, image.size.height);
    CGFloat x = (image.size.width - shortSide) / 2;
    CGFloat y = (image.size.height - shortSide) / 2;
    CGRect cropRect = CGRectMake(x, y, shortSide, shortSide);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(shortSide, shortSide), NO, image.scale);
    [image drawAtPoint:CGPointMake(-x, -y)];
    UIImage *squareImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return squareImage;
}

-(void)albumSelectionOfImages
{
//    if (@available(iOS 14, *)) {
//        PHPickerConfiguration *configuration = [[PHPickerConfiguration alloc] init];
//        configuration.filter = [PHPickerFilter imagesFilter]; // 只显示图片
//        configuration.selectionLimit = 1; // 限制选择1张图片
//        PHPickerViewController *picker = [[PHPickerViewController alloc] initWithConfiguration:configuration];
//        picker.delegate = self;
//        [self presentViewController:picker animated:YES completion:nil];
//    } else {
//        // Fallback on earlier versions
//    }
    [self requestPhotoLibraryAuthorization];
}

- (void)requestPhotoLibraryAuthorization {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusAuthorized) {
                //ELog(@"用户已授权相册访问");
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                picker.delegate = self;
                [self presentViewController:picker animated:YES completion:nil];
            } else {
                //ELog(@"用户拒绝相册访问");
                [MBProgressHUD showDelayHidenMessage:NSLocalizedString(@"相冊未授權，請在設置中啟用", nil)];
            }
        });
    }];
}

- (void)openSystemSettings
{
    NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
        [[UIApplication sharedApplication] openURL:settingsURL options:@{} completionHandler:nil];
    }
}

#pragma mark - PHPickerViewControllerDelegate

- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results  API_AVAILABLE(ios(14)){
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (results.count == 0) {
        return; // 用户取消了选择
    }
    PHPickerResult *result = results.firstObject;
    if ([result.itemProvider canLoadObjectOfClass:[UIImage class]]) {
        [result.itemProvider loadObjectOfClass:[UIImage class] completionHandler:^(__kindof id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error) {
            if ([object isKindOfClass:[UIImage class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *selectedImage = (UIImage *)object;
                    EGImagePreViewController *preView = [EGImagePreViewController new];
                    preView.bottomImage = selectedImage;
                    preView.topImage = self.markImageView.image;
                    [self.navigationController pushViewController:preView animated:true];
                });
            }
        }];
    }
}

#pragma mark --- UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    WS(weakSelf);
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    [picker dismissViewControllerAnimated:YES completion:^{
        //        [self.navigationController popViewControllerAnimated:YES];
        if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
            
            NSData *data = UIImageJPEGRepresentation(image, 0.00001);
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            dispatch_async(mainQueue,^{
                
            });
            
            
            EGImagePreViewController *preView = [EGImagePreViewController new];
            preView.bottomImage = [UIImage imageWithData:data];;
            preView.topImage = weakSelf.markImageView.image;
            [weakSelf.navigationController pushViewController:preView animated:true];
            
        }
    }];
}


@end





@interface ModelCollectionViewCell ()

@property (nonatomic,strong) UIImageView *modeImageView;

@end

@implementation ModelCollectionViewCell


- (UIImageView *)modeImageView
{
    if (!_modeImageView) {
        _modeImageView = [UIImageView new];
        _modeImageView.image = [UIImage imageNamed:@"3x_Matt"];
        [self.contentView addSubview:_modeImageView];
    }
    return _modeImageView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.backgroundColor = UIColor.whiteColor;
        self.contentView.layer.cornerRadius = 10;
        self.contentView.layer.masksToBounds = true;
        
        [self.modeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleW(6));
            make.right.mas_equalTo(-ScaleW(6));
            make.left.mas_equalTo(ScaleW(6));
            make.bottom.mas_equalTo(-ScaleW(6));
        }];
    }
    return self;
}

- (void)setImageName:(NSString *)imageName
{
    self.modeImageView.image = [UIImage imageNamed:imageName];
}
@end
