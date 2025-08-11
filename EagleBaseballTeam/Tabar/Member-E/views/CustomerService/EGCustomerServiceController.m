//
//  ViewController.m
//  music
//
//  Created by Dragon_Zheng on 2/5/25.
//

#import "EGCustomerServiceController.h"
#import "EGPickerView.h"
#import "EGCustomerServiceOKController.h"
@interface EGCustomerServiceController ()


@property (nonatomic,strong)UIView *baseView;
@property (nonatomic,strong)UILabel *showtitlecontentView;

@property (nonatomic,strong)UILabel *namelabel;
@property (nonatomic,strong)UITextField*nametextfield;

@property (nonatomic,strong)UILabel *emaillabel;
@property (nonatomic,strong)UITextField *emailtextfield;

@property (nonatomic,strong)UILabel *problemlabel;
@property (nonatomic,strong)UIButton *problembt;

@property (nonatomic,strong)UILabel *notelael;
@property (nonatomic,strong)UITextView *notetextview;

@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)UIButton *sendbt;
@end

@implementation EGCustomerServiceController
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

    UILabel *labe = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width-ScaleW(48), ScaleW(40))];
    labe.numberOfLines=0;
    labe.text = @"請留下您的建議或問題，我們將盡快為您服務。請勿在留言內容中提供敏感資訊(如帳號資訊).";
    labe.font = [UIFont systemFontOfSize:FontSize(14)];
    [self.baseView addSubview:labe];
    [labe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(ScaleW(24));
        make.height.mas_equalTo(ScaleW(67));
        make.width.mas_equalTo(Device_Width-ScaleW(48));
    }];
    self.showtitlecontentView = labe;
    
     
    self.namelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width-ScaleW(48), ScaleW(40))];
    self.namelabel.text = @"姓名";
    self.namelabel.font = [UIFont systemFontOfSize:FontSize(14)];
    [self.baseView addSubview:self.namelabel];
    [self.namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.showtitlecontentView.mas_bottom).offset(ScaleW(20));
        make.left.mas_equalTo(self.showtitlecontentView.mas_left);
        make.height.mas_equalTo(ScaleW(40));
        make.width.mas_equalTo(ScaleW(40));
    }];
    
    self.nametextfield = [[UITextField alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width-ScaleW(48), ScaleW(40))];;
    self.nametextfield.borderStyle = UITextBorderStyleRoundedRect;
    self.nametextfield.layer.borderWidth = 0.5;
    self.nametextfield.layer.cornerRadius = 5;
    self.nametextfield.placeholder = @"請輸入姓名";
    self.nametextfield.font = [UIFont systemFontOfSize:FontSize(14)];
    [self.baseView addSubview:self.nametextfield];
    [self.nametextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.namelabel.mas_bottom);
        make.left.mas_equalTo(self.showtitlecontentView.mas_left);
        make.height.mas_equalTo(ScaleW(40));
        make.width.mas_equalTo(Device_Width-ScaleW(48));
    }];
    
    
    self.emaillabel = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width-ScaleW(48), ScaleW(40))];
    self.emaillabel.text = @"E-mail";
    self.emaillabel.font = [UIFont systemFontOfSize:FontSize(14)];
    [self.baseView addSubview:self.emaillabel];
    [self.emaillabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nametextfield.mas_bottom).offset(ScaleW(20));
        make.left.mas_equalTo(self.showtitlecontentView.mas_left);
        make.height.mas_equalTo(ScaleW(40));
        make.width.mas_equalTo(ScaleW(100));
    }];
    
    self.emailtextfield = [[UITextField alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width-ScaleW(48), ScaleW(40))];;
    self.emailtextfield.borderStyle = UITextBorderStyleRoundedRect;
    self.emailtextfield.layer.borderWidth = 0.5;
    self.emailtextfield.layer.cornerRadius = 5;
    self.emailtextfield.placeholder = @"請輸入 E-mail";
    self.emailtextfield.font = [UIFont systemFontOfSize:FontSize(14)];
    [self.baseView addSubview:self.emailtextfield];
    [self.emailtextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.emaillabel.mas_bottom);
        make.left.mas_equalTo(self.showtitlecontentView.mas_left);
        make.height.mas_equalTo(ScaleW(40));
        make.width.mas_equalTo(Device_Width-ScaleW(48));
    }];
    
    
    self.problemlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width-ScaleW(48), ScaleW(40))];
    self.problemlabel.text = @"問題類別";
    self.problemlabel.font = [UIFont systemFontOfSize:FontSize(14)];
    [self.baseView addSubview:self.problemlabel];
    [self.problemlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.emailtextfield.mas_bottom).offset(ScaleW(20));
        make.left.mas_equalTo(self.showtitlecontentView.mas_left);
        make.height.mas_equalTo(ScaleW(40));
        make.width.mas_equalTo(ScaleW(100));
    }];
    
    self.problembt = [UIButton ZYButtonNoFrameWithTitle:NSLocalizedString(@"會員",nil) titleFont:[UIFont systemFontOfSize:FontSize(14) weight:(UIFontWeightRegular)] Image:[UIImage imageNamed:@"chevron-down"] backgroundImage:nil backgroundColor:rgba(255, 255, 255, 1) titleColor:rgba(23, 43, 77, 1)];
    self.problembt.layer.cornerRadius = 5;
    self.problembt.layer.borderColor = rgba(187, 206, 228, 1).CGColor;
    self.problembt.layer.borderWidth = 1;
    [self.problembt addTarget:self action:@selector(prioritySeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseView addSubview:self.problembt];
    [self.problembt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.problemlabel.mas_bottom);
        make.left.mas_equalTo(self.showtitlecontentView.mas_left);
        make.height.mas_equalTo(ScaleH(33));
        make.width.mas_equalTo(Device_Width-ScaleW(48));
    }];
    [self.problembt layoutButtonWithEdgeInsetsStyle:(ZYButtonEdgeInsetsStyleRight) imageTitleSpace:Device_Width-ScaleW(115)];
    
    
    self.notelael = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width-ScaleW(48), ScaleW(40))];
    self.notelael.text = @"其他";
    self.notelael.font = [UIFont systemFontOfSize:FontSize(14)];
    [self.baseView addSubview:self.notelael];
    [self.notelael mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.problembt.mas_bottom).offset(ScaleW(20));
        make.left.mas_equalTo(self.showtitlecontentView.mas_left);
        make.height.mas_equalTo(ScaleW(40));
        make.width.mas_equalTo(ScaleW(100));
    }];
    
    self.notetextview = [[UITextView alloc] initWithFrame:CGRectMake(0, [UIDevice de_navigationFullHeight], Device_Width-ScaleW(48), ScaleW(40))];
    self.notetextview.layer.borderWidth = 0.5;
    self.notetextview.layer.cornerRadius = 5;
    //self.notetextview.placeholder = @"請填寫內容";
    self.notetextview.text = @"請填寫內容";
    self.notetextview.font = [UIFont systemFontOfSize:FontSize(14)];
    [self.baseView addSubview:self.notetextview];
    [self.notetextview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.notelael.mas_bottom);
        make.left.mas_equalTo(self.showtitlecontentView.mas_left);
        make.height.mas_equalTo(ScaleW(130));
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
    [sureBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
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

-(void)send
{
    EGCustomerServiceOKController *vc = [EGCustomerServiceOKController new];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
