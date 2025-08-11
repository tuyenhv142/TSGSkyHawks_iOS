//
//  EGPhotoGraphViewController.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/6/17.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGPhotoGraphViewController.h"

#import <Photos/Photos.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <PhotosUI/PhotosUI.h>
#import "EGPhotoEditViewController.h"

@interface EGPhotoGraphViewController ()<AVCapturePhotoCaptureDelegate,AVCaptureFileOutputRecordingDelegate>
//{
//    dispatch_queue_t _videoProcessingQueue;
//    dispatch_queue_t _sessionSetupQueue;
//}
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCapturePhotoOutput *photoOutput;
@property (nonatomic, strong) AVCaptureMovieFileOutput *movieFileOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) UIView *previewContainerView;
@property (nonatomic, strong) dispatch_queue_t sessionSetupQueue;
@property (nonatomic, strong) dispatch_queue_t videoProcessingQueue;

@property (nonatomic, strong) UIButton *captureButton;
@property (nonatomic, strong) UIButton *switchCameraButton;
@property (nonatomic, strong) UIButton *lightingButton;

@property (nonatomic, strong) NSTimer *recordingTimer;
@property (nonatomic, assign) NSInteger recordingSeconds;

@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *promptLabel;
@end

@implementation EGPhotoGraphViewController

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.textColor = UIColor.whiteColor;
        [self.view addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-(ScaleW(110)+[UIDevice de_safeDistanceBottom]));
            make.centerX.mas_equalTo(0);
        }];
    }
    return _timeLabel;
}

- (UILabel *)promptLabel
{
    if (!_promptLabel) {
        _promptLabel = [UILabel new];
        _promptLabel.textColor = UIColor.whiteColor;
        _promptLabel.numberOfLines = 0;
        _promptLabel.text = @"照片 5MB ";//；影片 25MB(約可上傳 1080p 30秒內影片）
        [self.view addSubview:_promptLabel];
    }
    return _promptLabel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"趣味互動";
    self.view.backgroundColor = UIColor.blackColor;
    
    _videoProcessingQueue = dispatch_queue_create("com.youapp.videoprocessing", DISPATCH_QUEUE_SERIAL);
    _sessionSetupQueue = dispatch_queue_create("com.youapp.sessionsetup", DISPATCH_QUEUE_SERIAL);
    
    
    [self checkCameraPermissionWithCompletion:^(BOOL granted) {
        if (granted) {
            // 有权限，打开相机
            [self setupPreviewContainerView];
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
    
    [self setupUI];
    
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
    
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.previewContainerView.mas_bottom).offset(ScaleW(15));
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
    }];
    
    [self setupCaptureSession];
    
   
    
}
- (void)setupCaptureSession {
    
    dispatch_async(_sessionSetupQueue, ^{
        
        self.captureSession = [[AVCaptureSession alloc] init];
        self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
        
        [self.captureSession beginConfiguration];
        
        NSError *errorVideo;
        AVCaptureDevice *backCamera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *vodeoInput = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&errorVideo];
        if (!errorVideo) {
            if ([self.captureSession canAddInput:vodeoInput]) {
                [self.captureSession addInput:vodeoInput];
            }
        }
        
//        NSError *errorAudio;
//        AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
//        AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&errorAudio];
//        if (!errorAudio) {
//            if ([self.captureSession canAddInput:audioInput]) {
//                [self.captureSession addInput:audioInput];
//            }
//        }
        
        
        self.photoOutput = [[AVCapturePhotoOutput alloc] init];
        if ([self.captureSession canAddOutput:self.photoOutput]) {
            [self.captureSession addOutput:self.photoOutput];
            
        }
        
        self.movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
        if ([self.captureSession canAddOutput:self.movieFileOutput]) {
            [self.captureSession addOutput:self.movieFileOutput];
        }
        
        [self.captureSession commitConfiguration];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupPreviewLayer];
        });
        
    });
}

- (void)setupPreviewLayer {
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.frame = self.previewContainerView.bounds;
    [self.previewContainerView.layer addSublayer:self.previewLayer];
    dispatch_async(_videoProcessingQueue, ^{
        [self.captureSession startRunning];
    });
    
    
}
- (void)dealloc
{
    if ([self.captureSession isRunning]) {
        [self.captureSession stopRunning];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    dispatch_async(_videoProcessingQueue, ^{
        [self.captureSession startRunning];
    });
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    dispatch_async(_videoProcessingQueue, ^{
        if ([self.captureSession isRunning]) {
            [self.captureSession stopRunning];
        }
    });
    
}

- (void)setupUI {
    
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
//    // 添加长按事件 - 录制视频
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
//    longPress.minimumPressDuration = 0.3; // 长按最短时间
//    [self.captureButton addGestureRecognizer:longPress];
    
    
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
    
//    // 获取当前视频方向
//    AVCaptureConnection *connection = [self.photoOutput connectionWithMediaType:AVMediaTypeVideo];
//    connection.videoOrientation = self.previewLayer.connection.videoOrientation;
//    // 创建照片设置
//    AVCapturePhotoSettings *settings = [AVCapturePhotoSettings photoSettings];
//    if (self.lightingButton.selected) {
//        settings.flashMode = AVCaptureFlashModeOn;
//    }else{
//        settings.flashMode = AVCaptureFlashModeOff;
//    }
//    // 设置1:1裁剪
//    CGFloat squareLength = MIN(self.view.bounds.size.width, self.view.bounds.size.height);
//    CGRect squareRect = CGRectMake(0, 0, squareLength, squareLength);
//    // 转换为设备坐标
//    CGRect previewRect = [self.previewLayer metadataOutputRectOfInterestForRect:squareRect];
//    // 设置裁剪矩形
//    settings.previewPhotoFormat = @{
//        (NSString *)kCVPixelBufferPixelFormatTypeKey: settings.availablePreviewPhotoPixelFormatTypes.firstObject,
//        (NSString *)kCVPixelBufferWidthKey: @(squareLength),
//        (NSString *)kCVPixelBufferHeightKey: @(squareLength),
////        (NSString *)kCVPixelBufferCropRectKey: [NSValue valueWithCGRect:previewRect]
//    };
//    [self.photoOutput capturePhotoWithSettings:settings delegate:self];
    
}

- (void)switchCamera {
    
    AVCaptureSession *session = self.captureSession;
    
    AVCaptureDevicePosition currentPosition = ((AVCaptureDeviceInput*)session.inputs.firstObject).device.position;
    AVCaptureDevicePosition newPosition = currentPosition == AVCaptureDevicePositionBack ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
    
    AVCaptureDevice *newCamera = [self cameraWithPosition:newPosition];
    AVCaptureDeviceInput *newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
    
    [session beginConfiguration];
    [session removeInput:session.inputs.firstObject];
    
    if ([session canAddInput:newInput]) {
        [session addInput:newInput];
    }
    
    AVCaptureMovieFileOutput *movieFileOutput = self.movieFileOutput;
    AVCaptureConnection *connection = [movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    if (connection.isVideoMirroringSupported) {
        connection.videoMirrored = YES;
    }
//    [session removeOutput:session.outputs.lastObject];
    if ([session canAddOutput:movieFileOutput]) {
        [session addOutput:movieFileOutput];
    }
    
    [session commitConfiguration];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    
    AVCaptureDeviceDiscoverySession *videoDeviceDiscoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera, AVCaptureDeviceTypeBuiltInTelephotoCamera, AVCaptureDeviceTypeBuiltInDualCamera] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionUnspecified];
    NSArray<AVCaptureDevice *> *devices = videoDeviceDiscoverySession.devices;
//    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
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
        
        NSData *data = [photo fileDataRepresentation];
        UIImage *image = [UIImage imageWithData:data];
        
        
        AVCaptureDevicePosition currentPosition = ((AVCaptureDeviceInput*)self.captureSession.inputs.firstObject).device.position;
        ELog(@"----%ld",currentPosition);
        if (currentPosition != AVCaptureDevicePositionBack)
        {
            image = [UIImage imageWithCGImage:image.CGImage
                                               scale:image.scale
                                         orientation:UIImageOrientationLeftMirrored];
        }
        EGPhotoEditViewController *editVC = [EGPhotoEditViewController new];
        editVC.image = image;
        [self.navigationController pushViewController:editVC animated:true];
    }
}


- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self startRecording];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            [self stopRecording];
            break;
        default:
            break;
    }
}
- (void)startRecording {
    
    if (self.movieFileOutput.isRecording) {
        return;
    }
    
    // 按钮放大动画 按钮动画效果
    [UIView animateWithDuration:0.3 animations:^{
        self.captureButton.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.captureButton.backgroundColor = [UIColor redColor];
    }];
    
//  1. 设置输出文件路径
    NSString *outputPath = [[ELTmpFileManager shareTmpFile] generateTmpPathWithName:@"movie.mov"];
    NSURL *outputURL = [NSURL fileURLWithPath:outputPath];
    
    // 2. 开始录制
    [self.movieFileOutput startRecordingToOutputFileURL:outputURL recordingDelegate:self];
    
    // 3. 设置30秒计时器
    self.recordingSeconds = 30;
    self.recordingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self
                                                        selector:@selector(updateRecordingTime)
                                                        userInfo:nil
                                                         repeats:YES];
    
    
}

- (void)updateRecordingTime {
    self.recordingSeconds--;
    self.timeLabel.text = [NSString stringWithFormat:@"%lds",(long)self.recordingSeconds];
    if (self.recordingSeconds <= 0) {
        [self stopRecording];
    }
}
- (void)stopRecording {
    
    self.timeLabel.text = @"";
    
    if (self.movieFileOutput.isRecording) {
        
        [self.movieFileOutput stopRecording];
        [self.recordingTimer invalidate];
        self.recordingTimer = nil;
        
        // 恢复按钮状态
        [UIView animateWithDuration:0.3 animations:^{
            self.captureButton.transform = CGAffineTransformIdentity;
            self.captureButton.backgroundColor = [UIColor whiteColor];
        }];
    }
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections
                error:(NSError *)error {
    if (error) {
        NSLog(@"录制失败: %@", error.localizedDescription);
    } else {
        NSLog(@"视频已保存到: %@", outputFileURL);
        
        EGPhotoEditViewController *editVC = [EGPhotoEditViewController new];
        editVC.fileUrl = outputFileURL;
        [self.navigationController pushViewController:editVC animated:true];
        
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
