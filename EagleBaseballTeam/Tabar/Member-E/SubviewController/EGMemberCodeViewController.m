//
//  EGMemberCodeViewController.m
//  EagleBaseballTeam
//

#import "EGMemberCodeViewController.h"
#import <CoreImage/CoreImage.h>
#import "EGMemberInfoViewController.h"
#import "ZXingObjC.h"

@interface EGMemberCodeViewController ()

//@property (nonatomic, strong) UIImageView *barcodeImageView;
//@property (nonatomic, strong) UIImageView *qrcodeImageView;

@property (nonatomic, strong) UIImageView *barcodeImageView;
@property (nonatomic, strong) UIImageView *qrCodeImageView;

@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *hintLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *cardTitleLabel;
@property (nonatomic, weak) UIView *cardView;
@property (nonatomic, weak) UIView *codeBackgroundView;

@property (nonatomic, strong) UILabel *memberCodeLabel;
@property (nonatomic, strong) UIView *barcodeContainerView;

@property (nonatomic, assign) BOOL isQRCodeExpanded;
@property (nonatomic, assign) CGFloat initialTouchY;
@end

@implementation EGMemberCodeViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getQRCode];
    [self getDataForUser];
}

-(void)getQRCode{
//    {
//      "Mobile": "0912345678"
//    }
    UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
    if (!model) {
        return;;
    }
    MemberInfomationModel *infoModel = [EGLoginUserManager getMemberInfomation];
    if (!infoModel) {
        return;
    }
    [MBProgressHUD showMessage:@""];
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
    NSDictionary *dict_header = @{@"Authorization":tokenString};
    NSDictionary *dict_body = @{@"Mobile":infoModel.Phone};
    [[WAFNWHTTPSTool sharedManager] postWithURL:[EGServerAPI basicMemberGenqrcode:model.ID] parameters:dict_body headers:dict_header success:^(NSDictionary * _Nonnull response) {
     
 
        if (![response isKindOfClass:[NSDictionary class]]) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showDelayHidenMessage:@"數據格式錯誤"];
            self.qrCodeImageView.image = [self generateQRCodeFromString:@""];
//            self.barcodeImageView.image = [self generateBarcodeFromString:@""];
        
            return;
        }
        NSDictionary *data = [response objectOrNilForKey:@"data"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showDelayHidenMessage:@"數據格式錯誤"];
            self.qrCodeImageView.image = [self generateQRCodeFromString:@""];
//            self.barcodeImageView.image = [self generateBarcodeFromString:@""];
      
            return;
        }
        
        NSString *qrCode =  [data objectOrNilForKey:@"MEMQRCODE"];
        
        if (!qrCode || ![qrCode isKindOfClass:[NSString class]]) {
            self.qrCodeImageView.image = [self generateQRCodeFromString:@""];
//            self.barcodeImageView.image = [self generateBarcodeFromString:@""];
            [MBProgressHUD hideHUD];
            [MBProgressHUD showDelayHidenMessage:@"數據格式錯誤"];
         
            return;
        }
        [MBProgressHUD hideHUD];
        [MBProgressHUD hideHUD];
        self.memberCode = qrCode;
        self.qrCodeImageView.image = [self generateQRCodeFromString:self.memberCode];
//        self.barcodeImageView.image = [self generateBarcodeFromString:self.memberCode];
       
    } failure:^(NSError * _Nonnull error) {
        self.qrCodeImageView.image = [self generateQRCodeFromString:@""];
        self.barcodeImageView.image = [self generateBarcodeFromString:@""];
        [MBProgressHUD hideHUD];
        if ([error.localizedDescription containsString:@"offline"] || error.code == -1009) {
            [MBProgressHUD showDelayHidenMessage:@"請檢查您的網路連線，確保裝置已連接至網路後再重試。"];
        }else{
            [MBProgressHUD showDelayHidenMessage:error.localizedDescription];
        }
    }];
}

-(void)getDataForUser
{
    WS(weakSelf);
    UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
    NSDictionary *dict_header = @{@"Authorization":tokenString};
    [[WAFNWHTTPSTool sharedManager] getWithURL:[EGServerAPI basicMemberContact_api:model.ID] parameters:@{} headers:dict_header success:^(NSDictionary * _Nonnull response) {
        
        NSDictionary *dataDict = response[@"data"];
        NSDictionary *dict = [dataDict objectOrNilForKey:@"ExtraData"];
        
        NSString *invoice_number = [dict objectOrNilForKey:@"invoice_number"];
//        invoice_number =@"";
        weakSelf.barcodeImageView.image = [self generateBarcodeFromString:invoice_number];
        self.memberCodeLabel.text = invoice_number;
        
        } failure:^(NSError * _Nonnull error) {
            weakSelf.barcodeImageView.image = [self generateBarcodeFromString:@""];
            self.memberCodeLabel.text = @"";
        }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:panGesture];
    
    // 设置标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"會員條碼";
    self.titleLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightMedium];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLabel];
    
    
    // 设置关闭按钮
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setTitle:@"✕" forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeButton];
    
    // 创建白色背景卡片
    UIView *cardView = [[UIView alloc] init];
    cardView.backgroundColor = [UIColor whiteColor];
    cardView.layer.cornerRadius = ScaleW(28);
    [self.view addSubview:cardView];
    self.cardView = cardView;
    
    // 添加标题标签
    UILabel *cardTitleLabel = [[UILabel alloc] init];
    cardTitleLabel.text = @"台鋼天鷹會員條碼";
    cardTitleLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightMedium];
    cardTitleLabel.textColor = [UIColor blackColor];
    cardTitleLabel.textAlignment = NSTextAlignmentCenter;
    [cardView addSubview:cardTitleLabel];
    self.cardTitleLabel = cardTitleLabel;

    // 添加灰色背景视图
    UIView *codeBackgroundView = [[UIView alloc] init];
    codeBackgroundView.backgroundColor = rgba(245, 245, 245, 1);
    codeBackgroundView.layer.cornerRadius = 22;
    [cardView addSubview:codeBackgroundView];
    self.codeBackgroundView = codeBackgroundView;
    
    // 创建条形码容器视图
    self.barcodeContainerView = [[UIView alloc] init];
    self.barcodeContainerView.backgroundColor = [UIColor whiteColor];
    self.barcodeContainerView.layer.cornerRadius = ScaleW(20);
    [self.codeBackgroundView addSubview:self.barcodeContainerView];
//    [self.barcodeContainerView setHidden:YES];
    
    // 设置条形码
    self.barcodeImageView = [[UIImageView alloc] init];
    self.barcodeImageView.image = [self generateBarcodeFromString:self.memberCode];
    [self.barcodeContainerView addSubview:self.barcodeImageView];
    
    // 设置会员码标签
    self.memberCodeLabel = [[UILabel alloc] init];
    self.memberCodeLabel.text = @"";
    self.memberCodeLabel.textAlignment = NSTextAlignmentCenter;
    self.memberCodeLabel.textColor = [UIColor blackColor];
    self.memberCodeLabel.font = [UIFont systemFontOfSize:FontSize(14)];
    [self.barcodeContainerView addSubview:self.memberCodeLabel];
    
    // 设置二维码
    self.qrCodeImageView = [[UIImageView alloc] init];
    self.qrCodeImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.qrCodeImageView.image = [self generateQRCodeFromString:self.memberCode];
    self.qrCodeImageView.layer.cornerRadius = ScaleW(20);
    self.qrCodeImageView.clipsToBounds = YES;
    self.qrCodeImageView.backgroundColor = [UIColor whiteColor];
    
    [_codeBackgroundView addSubview:self.qrCodeImageView];
    
    // 设置提示文本
    self.hintLabel = [[UILabel alloc] init];
    self.hintLabel.text = @"點擊放大條碼，掃描更方便！";
    self.hintLabel.textAlignment = NSTextAlignmentCenter;
    self.hintLabel.textColor = rgba(115, 115, 115, 1);
    self.hintLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightMedium];
    [cardView addSubview:self.hintLabel];
    
    // 设置约束（使用frame或Auto Layout）
    [self setupConstraints];
}

- (void)setupConstraints {
    // 标题约束
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    // 关闭按钮约束
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
        make.right.equalTo(self.view).offset(-20);
        make.width.height.mas_equalTo(44);
    }];
    
    // 白色卡片视图约束
//    UIView *cardView = self.qrCodeImageView.superview;
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
//        make.left.equalTo(self.view).offset(ScaleW(20));
//        make.right.equalTo(self.view).offset(-ScaleW(20));
//        make.height.mas_equalTo(_cardView.mas_width).multipliedBy(1.3);
        make.height.mas_equalTo(ScaleW(494));
        make.width.mas_equalTo(ScaleW(319));
    }];
    
    // 卡片标题约束
//    UILabel *cardTitleLabel = [cardView.subviews firstObject];
    [self.cardTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cardView).offset(ScaleW(24));
        make.centerX.equalTo(_cardView);
//        make.height.mas_equalTo(ScaleW(22));
    }];
    
    // 灰色背景视图约束
    [_codeBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardTitleLabel.mas_bottom).offset(ScaleW(20));
        make.left.equalTo(_cardView).offset(ScaleW(16));
        make.right.equalTo(_cardView).offset(-ScaleW(16));
        make.bottom.equalTo(self.hintLabel.mas_top).offset(-ScaleW(20));
    }];
    
    // 二维码约束
    [self.qrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_codeBackgroundView).offset(ScaleW(30));
//        make.top.equalTo(self.barcodeContainerView.mas_bottom).offset(ScaleW(30));
        make.centerX.equalTo(_codeBackgroundView);
        make.width.height.mas_equalTo(ScaleW(160));
//        make.bottom.equalTo(_codeBackgroundView).offset(-ScaleW(30));
    }];
    
    // 条形码容器约束
    [self.barcodeContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_qrCodeImageView.mas_bottom).offset(ScaleW(30));
        make.centerX.equalTo(self->_codeBackgroundView);
        make.left.mas_equalTo(ScaleW(12));
        make.right.mas_equalTo(-ScaleW(12));
        make.height.mas_equalTo(ScaleW(118));
    }];
    
    // 条形码约束
    [self.barcodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.barcodeContainerView).offset(ScaleW(16));
        make.centerX.equalTo(self.barcodeContainerView);
        make.left.mas_equalTo(ScaleW(16));
        make.right.mas_equalTo(-ScaleW(16));
    }];
    
    // 会员码标签约束
    [self.memberCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.barcodeImageView.mas_bottom).offset(ScaleW(4));
        make.centerX.equalTo(self.barcodeContainerView);
        make.bottom.equalTo(self.barcodeContainerView).offset(-ScaleW(12));
        make.left.mas_equalTo(ScaleW(16));
        make.right.mas_equalTo(-ScaleW(16));
        make.height.mas_equalTo(ScaleW(12));
    }];
    

//    
    // 提示文本约束
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_cardView).offset(-ScaleW(20));
        make.centerX.equalTo(_cardView);
        make.left.right.equalTo(_cardView);
        make.height.mas_equalTo(ScaleW(20));
    }];
    
    // 添加点击手势
    UITapGestureRecognizer *barcodeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(codeImageViewTapped:)];
    [self.barcodeImageView addGestureRecognizer:barcodeTap];
    self.barcodeImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *qrcodeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(codeImageViewTapped:)];
    [self.qrCodeImageView addGestureRecognizer:qrcodeTap];
    self.qrCodeImageView.userInteractionEnabled = YES;
}

- (void)closeButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIView *)viewforNilBarcode{
    UIView *view = [UIView new];
    return view;
}

- (UIImage *)generateBarcodeFromString:(NSString *)string {
    // 如果字符串为空，返回缺省图
    if (!string || [string isEqualToString:@""]) {
        // 创建一个带背景的图
        CGFloat width = ScaleW(300);
        CGFloat height = ScaleW(100);
        // 使用3倍分辨率来渲染
        CGFloat scale =  [UIScreen mainScreen].scale;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, scale);
        
//        CGContextRef context = UIGraphicsGetCurrentContext();
//            CGContextScaleCTM(context, scale, scale);
        
        // 绘制白色背景
        [[UIColor whiteColor] setFill];
        UIRectFill(CGRectMake(0, 0, width, height));
        
        // 添加图片
        UIImage *centerImage = [UIImage imageNamed:@"plus-circle"];
        CGFloat imageSize = ScaleW(50);
        CGFloat imageX = (width - imageSize) / 2;
        CGFloat imageY = ScaleW(12);
        [centerImage drawInRect:CGRectMake(imageX, imageY, imageSize, imageSize)];
        
        // 添加提示文本
        NSString *hintText = @"前往會員資料，新增手機條碼載具";
        UIFont *font = [UIFont systemFontOfSize:FontSize(18)];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
        NSDictionary *attributes = @{
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: rgba(163, 163, 163, 1),
            NSParagraphStyleAttributeName: paragraphStyle
        };
        
        CGSize textSize = [hintText sizeWithAttributes:attributes];
   
        // 使用 drawAtPoint 替代 drawInRect 以获得更准确的字体大小
        CGPoint textPoint = CGPointMake((width - textSize.width) / 2,
                                        imageY + imageSize + ScaleW(15));
        [hintText drawAtPoint:textPoint withAttributes:attributes];
        
        UIImage *defaultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return defaultImage;
    }
    
    // 生成条形码
    // 使用 ZXing 生成 Code 39 条形码
    ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
    ZXBitMatrix *result = [writer encode:string
                                format:kBarcodeFormatCode39
                                 width:300
                                height:100
                                error:nil];
    
    if (result) {
        ZXImage *image = [ZXImage imageWithMatrix:result];
        return [UIImage imageWithCGImage:image.cgimage];
    }
    return nil;
    
    
//    CIFilter *filter = [CIFilter filterWithName:@"CICode39BarcodeGenerator"];
//    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
//    [filter setValue:data forKey:@"inputMessage"];
//    [filter setValue:@(0.0) forKey:@"inputQuietSpace"];
//    
//    CIImage *ciImage = filter.outputImage;
//    CGFloat scaleX = 300.0 / ciImage.extent.size.width;
//    CGFloat scaleY = 100.0 / ciImage.extent.size.height;
//    
//    ciImage = [ciImage imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
//    
//    return [UIImage imageWithCIImage:ciImage];
}

- (UIImage *)generateQRCodeFromString:(NSString *)string {
    
    // 如果字符串为空，返回缺省图
    if (!string || [string isEqualToString:@""]) {
        // 创建一个带边框的灰色背景图
        CGFloat size = ScaleW(240);
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(size, size), NO, [UIScreen mainScreen].scale);
        
        // 绘制白色背景
        [[UIColor whiteColor] setFill];
        UIRectFill(CGRectMake(0, 0, size, size));
        
        // 绘制虚线边框
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
        CGContextSetLineWidth(context, 1.0);
        CGFloat dashPattern[] = {5, 5};
        CGContextSetLineDash(context, 0, dashPattern, 2);
        CGContextStrokeRect(context, CGRectMake(ScaleW(20), ScaleW(20), size - ScaleW(40), size - ScaleW(40)));
        
        // 添加提示文本
        NSString *hintText =@"";// @"請先登入會員";
        UIFont *font = [UIFont systemFontOfSize:FontSize(16)];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
        NSDictionary *attributes = @{
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: [UIColor lightGrayColor],
            NSParagraphStyleAttributeName: paragraphStyle
        };
        
        CGSize textSize = [hintText sizeWithAttributes:attributes];
        CGRect textRect = CGRectMake((size - textSize.width) / 2,
                                     (size - textSize.height) / 2,
                                     textSize.width,
                                     textSize.height);
        
        [hintText drawInRect:textRect withAttributes:attributes];
        
        UIImage *defaultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return defaultImage;
    }
        
    
    // 生成二维码
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    CIImage *ciImage = filter.outputImage;
//    CGFloat scale =  200.0 / ciImage.extent.size.width;
//    
//    ciImage = [ciImage imageByApplyingTransform:CGAffineTransformMakeScale(scale, scale)];
//    
//    return [UIImage imageWithCIImage:ciImage];
    
//    CIImage *ciImage = filter.outputImage;
    // 调整二维码尺寸，考虑内边距
    CGFloat contentSize = ScaleW(200); // 160 - 40(内边距)
    CGFloat scale = contentSize / ciImage.extent.size.width;
    
    // 放大二维码
     ciImage = [ciImage imageByApplyingTransform:CGAffineTransformMakeScale(scale, scale)];
    
    
    // 创建带内边距的图片
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(ScaleW(240),ScaleW(240)), NO, [UIScreen mainScreen].scale);
    [[UIImage imageWithCIImage:ciImage] drawInRect:CGRectMake(ScaleW(20), ScaleW(20), contentSize, contentSize)];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalImage;
}

//- (void)setupUI {

//}
//
- (void)codeImageViewTapped:(UITapGestureRecognizer *)gesture {
    

    UIImageView *imageView = (UIImageView *)gesture.view;
    
    if (imageView == self.barcodeImageView) {
        
        if ([self.memberCodeLabel.text isEqualToString:@""]) {
            [self memberInfomationVC];
            return;
        }
        
        self.isQRCodeExpanded = !self.isQRCodeExpanded;
        self.hintLabel.text = self.isQRCodeExpanded ? @"點擊縮小" : @"點擊放大條碼，掃描更方便！";
 
        [UIView animateWithDuration:0.3 animations:^{
            if (self.isQRCodeExpanded) {
                self.cardTitleLabel.text =@"手機條碼載具";
                // 展开状态
                [self.cardView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.view);
                    make.left.right.equalTo(self.view);
                    make.height.mas_equalTo(ScaleW(600));
                }];
                
                [self.barcodeContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(self.codeBackgroundView);
                    make.height.mas_equalTo(ScaleW(182));
                    make.width.mas_equalTo(ScaleW(449));
                }];
                
                // 旋转条形码容器
                self.barcodeContainerView.transform = CGAffineTransformMakeRotation(M_PI_2);
                
                // 隐藏二维码
                self.qrCodeImageView.alpha = 0;
                
            } else {
                self.cardTitleLabel.text =@"台鋼天鷹會員條碼";
                // 恢复原始状态
                [self.cardView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(self.view);
                    make.height.mas_equalTo(ScaleW(494));
                    make.width.mas_equalTo(ScaleW(319));
                }];
                
                // 条形码容器约束
                [self.barcodeContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self->_qrCodeImageView.mas_bottom).offset(ScaleW(30));
                    make.centerX.equalTo(self->_codeBackgroundView);
                    make.left.mas_equalTo(ScaleW(12));
                    make.right.mas_equalTo(-ScaleW(12));
                    make.height.mas_equalTo(ScaleW(118));
                }];
                
                // 恢复条形码容器方向
                self.barcodeContainerView.transform = CGAffineTransformIdentity;
                
                // 显示二维码
                self.qrCodeImageView.alpha = 1;
            }
            
            [self.view layoutIfNeeded];
        }];
        
    }else if (imageView == self.qrCodeImageView) {
        self.isQRCodeExpanded = !self.isQRCodeExpanded;
        self.cardTitleLabel.text =@"台鋼天鷹會員條碼";
        // 更新提示文本
        self.hintLabel.text = self.isQRCodeExpanded ? @"點擊縮小" : @"點擊放大條碼，掃描更方便！";
        
        [UIView animateWithDuration:0.3 animations:^{
            if (self.isQRCodeExpanded) {
                // 展开状态
                [self.cardView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.view);
                    make.left.right.equalTo(self.view);
                    make.height.mas_equalTo(ScaleW(600));
                }];
                
                [self.qrCodeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(self.codeBackgroundView);
                    make.width.height.mas_equalTo(ScaleW(319));
                }];
                
                self.barcodeContainerView.alpha = 0;
                
            } else {
                // 恢复原始状态
                [self.cardView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(self.view);
                    make.height.mas_equalTo(ScaleW(494));
                    make.width.mas_equalTo(ScaleW(319));
                }];
                
                [self.qrCodeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self->_codeBackgroundView).offset(ScaleW(30));
                    make.centerX.equalTo(self.codeBackgroundView);
                    make.width.height.mas_equalTo(ScaleW(160));
                }];
                
                // 显示条形码容器
                self.barcodeContainerView.alpha = 1;
            }
            
            [self.view layoutIfNeeded];
        }];
    }
}

// 添加手势处理方法
- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.view];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            self.initialTouchY = translation.y;
            break;
            
        case UIGestureRecognizerStateChanged: {
            CGFloat offsetY = translation.y - self.initialTouchY;
            if (offsetY > 0) {
                self.view.transform = CGAffineTransformMakeTranslation(0, offsetY);
            }
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            CGFloat offsetY = translation.y - self.initialTouchY;
            if (offsetY > 100) {
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [UIView animateWithDuration:0.3 animations:^{
                    self.view.transform = CGAffineTransformIdentity;
                }];
            }
            break;
        }
            
        default:
            break;
    }
}

#pragma mark --- barcode
-(void)memberInfomationVC
{
    WS(weakSelf);
    EGMemberInfoViewController *memberInfo = [EGMemberInfoViewController new];
    memberInfo.infomationBlock = ^(NSString * _Nonnull invoice_number) {
        weakSelf.barcodeImageView.image = [self generateBarcodeFromString:invoice_number];
        self.memberCodeLabel.text = invoice_number;
    };
//    [self.navigationController pushViewController:memberInfo animated:true];
    memberInfo.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:memberInfo animated:YES completion:nil];
    
}
@end
