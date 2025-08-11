//
//  OAPickerView.m
//  NewsoftOA24
//
//  Created by dragon_zheng on 2024/6/27.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import "EGPickerView.h"

@interface EGPickerView () <UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSInteger selectRow;
}
/**
 * 参数 数组
 */
@property (retain, nonatomic) NSArray *arrPickerData;

@property (retain, nonatomic) UIPickerView *pickerView;
@property (nonatomic,weak) UIView * baseView;

@end

@implementation EGPickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(EGPickerView *)initWithChooseTypeNSArray2:(NSArray *)array{
    
    static EGPickerView *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[self alloc] initWithFrame:CGRectMake(0, 0, Device_Width, Device_Height)];
        [client addSubviewUIpickerViewChooseArray:array];
        
    });

    return client;
    
}


-(instancetype)initWithChooseTypeNSArray:(NSArray *)array{
    
    self = [super initWithFrame:CGRectMake(0, 0, Device_Width, Device_Height)];
//    self.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.2];
    if (self) {
        [self addSubviewUIpickerViewChooseArray:array];
    }
    return self;
}

//-(instancetype)initWithChooseTypeNSArray:(NSArray *)array{
//
//    self = [super initWithFrame:CGRectMake(0, 0, Device_Width, Device_Height)];
////    self.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.2];
//    if (self) {
//        [self addSubviewUIpickerViewChooseArray:array];
//    }
//    return self;
//}
-(void)addSubviewUIpickerViewChooseArray:(NSArray *)pickerDataArray{
    UIView *bView = [[UIView alloc] initWithFrame:self.bounds];
    [bView setBackgroundColor:rgba(0, 0, 0, 0.0)];
    [self addSubview:bView];
    
    // 添加点击手势识别器 点击背景退出
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    // 要识别手势的点击次数
    tapGestureRecognizer.numberOfTapsRequired = 1;
    // 添加到主视图
    [bView addGestureRecognizer:tapGestureRecognizer];
    
    
    // 背景view
    UIView *baseView = [[UIView alloc] init];
    baseView.backgroundColor = [UIColor whiteColor];
    baseView.layer.cornerRadius = 15;
    baseView.layer.masksToBounds = YES;
    [baseView setFrame:CGRectMake(0, Device_Height, Device_Width, ScaleW(256))];
    [self addSubview:baseView];
    self.baseView = baseView;


    
    UIButton *btnOK = [[UIButton alloc] init];
    [btnOK setTitle:NSLocalizedString(@"完成",nil) forState:UIControlStateNormal];
    [btnOK setTitleColor:rgba(0, 114, 198, 1) forState:UIControlStateNormal];
     btnOK.titleLabel.font = [UIFont systemFontOfSize:FontSize(18) weight:(UIFontWeightBold)];
    btnOK.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btnOK addTarget:self action:@selector(pickerViewBtnOK:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:btnOK];
    [btnOK mas_makeConstraints:^(MASConstraintMaker *make) {
       // make.top.equalTo(baseView).offset(ScaleW(10));;
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
//        make.left.mas_equalTo(0);
        make.width.mas_equalTo(ScaleW(120));
    }];
    btnOK.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -20, -20, -10);
    
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    
    pickerView.backgroundColor = [UIColor whiteColor];
    [baseView addSubview:pickerView];
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(baseView).insets(UIEdgeInsetsMake(ScaleW(35), 0, ScaleW(5), 0));
    }];
    _pickerView = pickerView;
    _arrPickerData = pickerDataArray;
}

#pragma mark - UIPickerViewDataSource
//返回多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

//每列对应多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _arrPickerData.count;
}
//每行显示的数据
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return _arrPickerData[row];
}
#pragma mark - UIPickerViewDelegate
//选中pickerView的某一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectRow = row;
}
//行高
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return ScaleW(44);
}
#pragma mark - Private Menthods

//弹出pickerView
- (void)popPickerView
{
    self.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:0];
    [[[[UIApplication sharedApplication]windows] firstObject] addSubview:self];
    
    self.frame = CGRectMake(0, 0, Device_Width, Device_Height);
    self.baseView.alpha = 0.0;
    [UIView animateWithDuration:0.25
                     animations:^{
        self.baseView.alpha = 1.0;
        [self.baseView setFrame:CGRectMake(0, Device_Height-ScaleW(256), Device_Width, ScaleW(256))];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    }];
}

//确定
- (void)pickerViewBtnOK:(id)sender{
    
    if (self.seleteBackResultBlock) {
        if (_arrPickerData.count == 0) {
            return;
        }
        self.seleteBackResultBlock(_arrPickerData[selectRow],selectRow);
    }
    [self removeFromSuperview];
}

//取消
- (void)pickerViewBtnCancel
{
    [self removeFromSuperview];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self removeFromSuperview];
    }
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self removeFromSuperview];
//}
@end
