//
//  EGBarQRCodeView.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/4/27.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGBarQRCodeView.h"

#import "ZXMultiFormatWriter.h"
#import "ZXingObjC.h"

@interface EGBarQRCodeView ()

@property (nonatomic,strong) UIImageView *barCode;
@property (nonatomic,strong) UILabel *barCodeLb;
@property (nonatomic,strong) UIImageView *qrCode;
@property (nonatomic, strong) NSString *giftId;
@property (nonatomic,strong) UILabel *titile;

@property (nonatomic,strong) NSTimer *search_timer;
@end

@implementation EGBarQRCodeView

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
        self.frame = CGRectMake(0, 0, Device_Width, Device_Height);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];// [kəmˈpoʊnənt]
        
        UIView *baseView = [UIView new];
        baseView.userInteractionEnabled = NO;
        baseView.layer.masksToBounds = true;
        baseView.layer.cornerRadius = ScaleW(10);
        baseView.backgroundColor = [UIColor whiteColor];
        [self addSubview:baseView];
        [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(ScaleW(380));
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(ScaleW(10));
        }];
        UIView *lineV = [UIView new];
        lineV.layer.masksToBounds = true;
        lineV.layer.cornerRadius = ScaleW(2);
        lineV.backgroundColor = rgba(163, 163, 163, 1);
        [baseView addSubview:lineV];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(ScaleW(69));
            make.top.mas_equalTo(ScaleW(10));
            make.centerX.mas_equalTo(0);
            make.height.mas_equalTo(ScaleW(4));
        }];
        
        UILabel *title = [UILabel new];
        title.text = @"條碼兌換";
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = rgba(23, 23, 23, 1);
        title.font = [UIFont systemFontOfSize:FontSize(14) weight:(UIFontWeightSemibold)];
        [baseView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.mas_equalTo(ScaleW(30));
            make.width.mas_equalTo(ScaleW(100));
            make.height.mas_equalTo(ScaleW(20));
        }];
        self.titile = title;
        
        self.barCode = [UIImageView new];
        self.barCode.image = [UIImage imageNamed:@"FamilyCard2"];
        self.barCode.layer.masksToBounds = true;
        self.barCode.layer.cornerRadius = ScaleW(0);
        self.barCode.backgroundColor = [UIColor whiteColor];
        [baseView addSubview:self.barCode];
        [self.barCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(ScaleW(319));
            make.top.mas_equalTo(ScaleW(58));
            make.centerX.mas_equalTo(0);
            make.height.mas_equalTo(ScaleW(70));
        }];
        self.barCode.image = [self createBarcodeFromString:@"1RR50R416"];
        self.barCode.hidden = YES;
        
        
        self.barCodeLb = [UILabel new];
        self.barCodeLb.text = @"1RR50R416";
        self.barCodeLb.textAlignment = NSTextAlignmentCenter;
        self.barCodeLb.textColor = rgba(64, 64, 64, 1);
        self.barCodeLb.font = [UIFont systemFontOfSize:FontSize(18) weight:(UIFontWeightMedium)];
        [baseView addSubview:self.barCodeLb];
        [self.barCodeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.barCode.mas_bottom).offset(ScaleW(5));
            make.width.mas_equalTo(ScaleW(300));
            make.height.mas_equalTo(ScaleW(24));
        }];
        self.barCodeLb.hidden = YES;
        
        
        self.qrCode = [UIImageView new];
        self.qrCode.image = [UIImage imageNamed:@"FamilyCard2"];
        self.qrCode.contentMode = UIViewContentModeScaleAspectFill;
        self.qrCode.layer.masksToBounds = true;
        self.qrCode.layer.cornerRadius = ScaleW(0);
        self.qrCode.backgroundColor = [UIColor whiteColor];
        [baseView addSubview:self.qrCode];
        [self.qrCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titile.mas_bottom);
            make.centerX.mas_equalTo(self.titile.mas_centerX).offset(ScaleW(15));
            make.width.mas_equalTo(ScaleW(230));
            make.height.mas_equalTo(ScaleW(230));
        }];
        self.qrCode.image = NULL;
        
        UILabel *description = [UILabel new];
        description.text = @"請勿以翻拍或截圖方式傳輸本券，以免影響條碼辨識，造成無法使用。";
        description.numberOfLines = 0;
        description.textAlignment = NSTextAlignmentCenter;
        description.textColor = rgba(115, 115, 115, 1);
        description.font = [UIFont systemFontOfSize:FontSize(14) weight:(UIFontWeightRegular)];
        [baseView addSubview:description];
        [description mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.qrCode.mas_bottom).offset(ScaleW(15));
            make.left.mas_equalTo(ScaleW(15));
            make.right.mas_equalTo(-ScaleW(15));
        }];
    }
    return self;
}

-(void)setgoodsID:(NSString*)goodsid
{
    self.giftId = goodsid;
}

-(void)showBarQRCodeView:(NSString*)g_id
{
    self.search_timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(has_recode:) userInfo:self.giftId repeats:YES];
    
    //get bar code string
    UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
    NSDictionary *dict_header = @{@"Authorization":tokenString};
    
    NSDictionary *body = @{@"couponCode":g_id};
    
    [[WAFNWHTTPSTool sharedManager] postWithURL:[EGServerAPI getGiftQRCode:model.ID] parameters:body headers:dict_header success:^(NSDictionary * _Nonnull response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *qrstring = response[@"data"][@"qrcode"];
            self.qrCode.image = [self createQRCodeFromString:qrstring];
            [UIView animateWithDuration:0.5 animations:^{
                self.frame = CGRectMake(0, 0, Device_Width, Device_Height);
                [[UIApplication sharedApplication].keyWindow addSubview:self];
            }];
        });
    } failure:^(NSError * _Nonnull error) {
        [self.search_timer invalidate];
        self.search_timer = nil;
        [MBProgressHUD showDelayHidenMessage:error.localizedDescription];
        }];
    
   
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.search_timer invalidate];
    self.search_timer = nil;
    [self removeFromSuperview];
}

- (UIImage *)createBarcodeFromString:(NSString *)string {
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
}
- (UIImage *)createQRCodeFromString:(NSString *)string {
    if (!string) {
        
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
    CGFloat contentSize = ScaleW(166); // 160 - 40(内边距)
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

-(void)has_recode: (NSTimer *)timer {
     NSString *msg = (NSString *)[timer userInfo];
    [self getusedListby:msg];
}

-(void)getusedListby:(NSString*)goods_id
{
    //goods_id = @"e3261585-0263-4768-88b9-7ee91fa62ef3";
    
    UserInfomationModel *model = [EGLoginUserManager getUserInfomation];
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@",model.accessToken];
    NSDictionary *dict_header = @{@"Authorization":tokenString};
    
    //0. 未使用 1. 已鎖定 2. 已使用 3.已過期
    NSInteger status = 2;
    [[WAFNWHTTPSTool sharedManager] getWithURL:[EGServerAPI couponsList_api:model.ID getStuatus:status] parameters:@{} headers:dict_header success:^(NSDictionary * _Nonnull response) {
        NSArray *used_array = response[@"data"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"couponId == %@", goods_id];
        NSArray *filteredArray = [used_array filteredArrayUsingPredicate:predicate];
        if (filteredArray.count > 0) {
            NSLog(@"已经找到已使用的此记录");
            [self.search_timer invalidate];
            self.search_timer = nil;
            [self removeFromSuperview];
            
            //使用block
            if (self.closeBlock) {
                self.closeBlock();
                [self removeFromSuperview];
            }
            
//           BKPopReminderView *popView = [[BKPopReminderView alloc] initWithTitle:@"您的贈品已完成兌換，請留意兌換狀況。" buttons:@[@"確定"]];
//                [popView showPopView];
//                popView.closeBlock = ^(NSInteger btnTag) {
//                    NSLog(@"点击確定");
//                };
        }
        
    } failure:^(NSError * _Nonnull error) {
            
        }];
    
}

@end
