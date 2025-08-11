//
//  ViewController.m
//  music
//
//  Created by Dragon_Zheng on 2/5/25.
//

#import "EGCustomerServiceOKController.h"
#import "EGPickerView.h"
@interface EGCustomerServiceOKController ()


@property (nonatomic,strong)UIView *baseView;
@property (nonatomic,strong)UIImageView *imageview;
@property (nonatomic,strong)UILabel *Ttitle;
@property (nonatomic,strong)UILabel *notetextview;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)UIButton *sendbt;
@end

@implementation EGCustomerServiceOKController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"聯絡客服";
    [self setupUI];
}

-(void)setupUI
{
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, Device_Height)];
    bView.backgroundColor = rgba(245, 245, 245, 1);
    [self.view addSubview:bView];
    self.baseView = bView;

    self.imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], 160, 160)];
    self.imageview.contentMode = UIViewContentModeScaleAspectFit;
    self.imageview.image = [UIImage imageNamed:@"sendok"];
    [self.baseView addSubview:self.imageview];
    [self.imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(100));
        make.left.mas_equalTo(self.baseView.mas_centerX).offset(-120);
        make.height.mas_equalTo(ScaleW(160));
        make.width.mas_equalTo(Device_Width-ScaleW(160));
    }];
    
    self.Ttitle = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, 32)];
    self.Ttitle.textAlignment = NSTextAlignmentCenter;
    self.Ttitle.font = [UIFont boldSystemFontOfSize:FontSize(18)];
    self.Ttitle.text = @"感謝您的回饋";
    [self.baseView addSubview:self.Ttitle];
    [self.Ttitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageview.mas_bottom);
        make.left.mas_equalTo(self.baseView.mas_centerX).offset(-120);
        make.height.mas_equalTo(ScaleW(45));
        make.width.mas_equalTo(Device_Width-ScaleW(160));
    }];
    
    
    self.notetextview = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width-ScaleW(48), ScaleW(40))];
    self.notetextview.numberOfLines=0;
    self.notetextview.textAlignment = NSTextAlignmentCenter;
    self.notetextview.text = @"您的訊息已成功送出，我們將盡快處理並回覆您。請留意您的 E-mail 信箱，感謝您的耐心等候！";
    self.notetextview.font = [UIFont systemFontOfSize:FontSize(14)];
    [self.baseView addSubview:self.notetextview];
    [self.notetextview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.Ttitle.mas_bottom);
        make.left.mas_equalTo(ScaleW(24));
        make.height.mas_equalTo(ScaleW(40));
        make.width.mas_equalTo(Device_Width-ScaleW(48));
    }];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width, ScaleW(40))];
    [bottomView setBackgroundColor:rgba(0, 122, 96, 1.0)];//
    [self.baseView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        //make.top.mas_equalTo(self.notetextview.mas_bottom).offset(52);
        make.top.mas_equalTo(self.baseView.mas_bottom).offset(ScaleW(-164));
        make.width.mas_equalTo(ScaleW(Device_Width));
        make.height.mas_equalTo(ScaleW(82));
    }];
    self.bottomView = bottomView;
    
    UIButton *sureBtn = [[UIButton alloc] init];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(15) weight:UIFontWeightBold];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:UIColor.clearColor];
    [sureBtn setTitle:@"確定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(OK) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.layer.cornerRadius = ScaleW(32)/2;
    sureBtn.clipsToBounds = YES;
    [self.baseView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.baseView).offset(ScaleW(-120));;
        make.width.mas_equalTo(ScaleW(50));
        make.height.mas_equalTo(ScaleW(32));
        make.centerX.mas_equalTo(self.baseView);
    }];
    self.sendbt = sureBtn;
    
//    self.bottomView.backgroundColor = rgba(229, 229, 229, 1);
//    self.sendbt.enabled=NO;
    
    
    
}

- (void)openURL:(NSString *)appURL fallback:(NSString *)webURL {
    NSURL *appSchemeURL = [NSURL URLWithString:appURL];
    NSURL *webFallbackURL = [NSURL URLWithString:webURL];
    
    [[UIApplication sharedApplication] openURL:appSchemeURL
                                     options:@{}
                           completionHandler:^(BOOL success) {
        if (!success) {
            [[UIApplication sharedApplication] openURL:webFallbackURL
                                            options:@{}
                                  completionHandler:nil];
        }
    }];
}

#pragma mark 选择问题类别action
-(void)prioritySeleteButton:(UIButton *)sender
{
    EGPickerView *picker = [[EGPickerView alloc] initWithChooseTypeNSArray:@[@"會員",@"賽事",@"點數",@"商品",@"郵寄服務",@"其他"]];
    picker.seleteBackResultBlock = ^(id  _Nullable result, NSInteger index){
        
        [sender setTitle:result forState:UIControlStateNormal];
        [sender layoutButtonWithEdgeInsetsStyle:(ZYButtonEdgeInsetsStyleRight) imageTitleSpace:Device_Width-ScaleW(115)];
        
    };
    [picker popPickerView];
    
    
}

-(void)OK
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
