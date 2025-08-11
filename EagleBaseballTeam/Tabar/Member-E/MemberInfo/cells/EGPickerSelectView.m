//
//  EGPickerSelectView.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/18.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGPickerSelectView.h"

@interface EGPickerSelectView () <UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) NSString *selectString;
@property (nonatomic,assign) NSInteger selectRow;
@property (strong, nonatomic) NSMutableArray *indexArray;

@property (strong, nonatomic) UIView *baseView;
@end

@implementation EGPickerSelectView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}
#pragma mark --- create UI
/**
 *自定义方法1 按钮在上面
 */
-(instancetype)initWithChooseTitleNSArray:(NSArray *)array{

    self = [super initWithFrame:CGRectMake(0, 0, Device_Width, Device_Height)];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    if (self) {
        [self addSubviewUIpickerViewAndButtonChooseArray:array];
    }
    return self;
}
-(void)addSubviewUIpickerViewAndButtonChooseArray:(NSArray *)pickerDataArray
{
    // 背景view
    UIView *baseView = [[UIView alloc] init];
    baseView.layer.cornerRadius = 0;
    baseView.clipsToBounds = YES;
    baseView.backgroundColor = [UIColor whiteColor];
    [self addSubview:baseView];
    [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-[UIDevice de_safeDistanceBottom]);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(ScaleH(243));
    }];
    self.baseView = baseView;
    
    UIView *bView = [[UIView alloc] init];
    bView.backgroundColor = rgba(243, 243, 243, 1);
    [baseView addSubview:bView];
    [bView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(ScaleW(44));
        make.right.mas_equalTo(0);
    }];
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"完成" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightBold];
    [sureBtn setTitleColor:rgba(16, 94, 254, 1) forState:UIControlStateNormal];
    sureBtn.backgroundColor = rgba(243, 243, 243, 1);
    [sureBtn addTarget:self action:@selector(pickerViewBtnOK:) forControlEvents:UIControlEventTouchUpInside];
    [bView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(ScaleW(44));
        make.right.mas_equalTo(-ScaleW(24));
    }];
    //选择内容 @【】；
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.backgroundColor = [UIColor whiteColor];
    [baseView addSubview:pickerView];
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(44));
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    self.pickerView = pickerView;
    
    // 数据源数组
    self.arrPickerData = pickerDataArray;
    
}

-(void)setPickerDefaultValue:(NSString *)default1 Value:(NSString *)default2
{
    if (default2 && default1) {
        for (int i = 0; i < self.arrPickerData.count; i++) {
            NSDictionary *dict = self.arrPickerData[i];
            if ([dict[@"city"] isEqualToString:default1]) {
                
                NSArray *areaArr = dict[@"area"];
                for (int j = 0; j < areaArr.count; j++) {
                    NSDictionary *dict2 = areaArr[j];
                    if ([dict2[@"name"] isEqualToString:default2]) {
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.pickerView selectRow:i inComponent:0 animated:true];
                            [self.pickerView reloadComponent:0];
                            self.selectRow = i;
                            [self.pickerView selectRow:j inComponent:1 animated:true];
                            [self.pickerView reloadComponent:1];
                        });
                        
                        break;
                    }
                }
            }
        }
    }else{
        for (int i = 0; i < self.arrPickerData.count; i++) {
            NSString *city = self.arrPickerData[i];
            if ([city isEqualToString:default1]) {
                
                [self.pickerView selectRow:i inComponent:0 animated:true];
                self.selectRow = i;
                break;
            }
        }
    }
    
    
}

#pragma mark - UIPickerView DataSource
//返回多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.componentNumber > 1) {
        return self.componentNumber;
    }else{
        return 1;
    }
}
//每列对应多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        
        return self.arrPickerData.count;
        
    }else /*if (component == 1)*/{
        
//        NSInteger selectIndex = [pickerView selectedRowInComponent:0];
//        NSDictionary *dict = self.arrPickerData[selectIndex];
//        NSArray *areaArr = dict[@"area"];
//        return areaArr.count;
        
//        NSInteger selectIndex = [pickerView selectedRowInComponent:0];
//        if (selectIndex >= 0 && selectIndex < self.arrPickerData.count) {
//            NSDictionary *dict = self.arrPickerData[selectIndex];
//            NSArray *areaArr = dict[@"area"];
//            return areaArr.count;
//        }else{
//            return 0;
//        }
        
        NSInteger selectedIndex = [pickerView selectedRowInComponent:0];
        if (selectedIndex < 0 || selectedIndex >= self.arrPickerData.count) {
            return 0;
        }
        NSDictionary *dict = self.arrPickerData[selectedIndex];
        NSArray *houseInfoVo = dict[@"area"];
        if (![houseInfoVo isKindOfClass:[NSArray class]]) {
            return 0;
        }
        return houseInfoVo.count;
    }
    
}
//每行显示的数据
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    
    if (self.componentNumber > 1) {
        
        if (component == 0) {
            
            NSDictionary *dict = self.arrPickerData[row];
            return dict[@"city"];
            
        }else {

            // 获取第一列当前选中的行
            NSInteger selectedIndex = [pickerView selectedRowInComponent:0];
            // 防止 selectedIndex 越界
            if (selectedIndex < 0 || selectedIndex >= self.arrPickerData.count) {
                return @"";
            }
            NSDictionary *dict = self.arrPickerData[selectedIndex];
            NSArray *houseInfoVo = dict[@"area"];
            // 防止 houseInfoVo 不是数组或为空
            if (![houseInfoVo isKindOfClass:[NSArray class]] || houseInfoVo.count == 0) {
                return @"";
            }
            // 确保 row 不越界
            NSInteger safeRow = MIN(row, houseInfoVo.count - 1);
            NSDictionary *dict1 = houseInfoVo[safeRow];
            return dict1[@"name"];
            
        }
        
    }else{
        
        return self.arrPickerData[row];
    }
}
#pragma mark - UIPickerView Delegate
//选中pickerView的某一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (self.componentNumber > 1) {
        if (component == 0) {
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
        }
    }else{
        
        self.selectString = self.arrPickerData[row];
    }
    self.selectRow = row;
    
}
//行高
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return ScaleH(44);
}

#pragma mark - Private Button Menthods
//弹出pickerView
- (void)popPickerView
{
    NSSet *set = [UIApplication sharedApplication].connectedScenes;
    UIWindowScene *windowScene = [set anyObject];
    UIWindow *keyWindow = windowScene.windows.firstObject;
    [keyWindow addSubview:self];
    
    self.baseView.frame = CGRectMake(0, Device_Height, Device_Width, Device_Height);
    [UIView animateWithDuration:0.5 animations:^{
        self.baseView.frame = CGRectMake(0, 0, Device_Width - ScaleH(243), ScaleH(243));
        
    }];
    
}
//确定
- (void)pickerViewBtnOK:(id)sender{
    
    NSArray *store_address;
    if (self.componentNumber > 1) {
        NSString *selectString = @"";
        
        NSInteger floor = [self.pickerView selectedRowInComponent:0];
        NSDictionary *dict = _arrPickerData[floor];
        NSString *floorString = dict[@"city"];
//        selectString = [selectString stringByAppendingString:floorString];
        
        NSInteger nuit = [self.pickerView selectedRowInComponent:1];
        NSArray *areas = dict[@"area"];
        if (nuit >= areas.count) {
            return;
        }
        NSDictionary *dict1 = areas[nuit];
        NSString *nuitString = dict1[@"name"];
//        selectString = [selectString stringByAppendingString:nuitString];
    
        store_address = dict1[@"store_address"];
        
        selectString = [NSString stringWithFormat:@"%@/%@",floorString,nuitString];
        
        self.selectString = selectString;
        
    }else{
        
        store_address = @[];
        self.selectString = self.arrPickerData[self.selectRow];
    }
    
    if (self.selectBlock) {
        if (_arrPickerData.count == 0) {
            return;
        }
        self.selectBlock(self.selectString,self.selectRow,store_address);
    }
    [self removeFromSuperview];
}

@end
