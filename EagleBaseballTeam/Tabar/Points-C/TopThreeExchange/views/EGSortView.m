//
//  OASearchFilterView.m
//  NewsoftOA24
//
//  Created by rick on 7/31/24.
//  Copyright © 2024 Elvin. All rights reserved.
//

#import "EGSortView.h"
#import "EGSortCell.h"

@interface EGSortView ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
{

}

@property (nonatomic,weak) UIView * baseView;
@property (nonatomic,weak) UIButton *cancelBtn; // X button
@property (nonatomic,weak) UIImageView *titleImage; // X button
@property (nonatomic,weak) UILabel *title;
@property (nonatomic,weak) UITableView* lantableView;
@property (nonatomic,weak) UILabel *SettingTitleLabel;

@property (nonatomic,strong)NSArray *language;
@property (nonatomic,assign)NSInteger selectedIndexes;
@end


@implementation EGSortView

-(instancetype)initWithFrame:(CGRect)frame{
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    self = [super initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    if (self) {
        
        self.language = @[@{@"title":@"日期新到舊",@"status":[NSNumber numberWithBool:YES]},
                          @{@"title":@"日期舊到新",@"status":[NSNumber numberWithBool:NO]},
                          @{@"title":@"點數高到低",@"status":[NSNumber numberWithBool:NO]},
                          @{@"title":@"點數低到高",@"status":[NSNumber numberWithBool:NO]}
        
        ];
        self.selectedIndexes = 0;
        
        [self createUI];
    }
    return self;
}

- (void)setinfo:(NSInteger)lan
{
    NSMutableArray *arrayM = [NSMutableArray arrayWithArray:self.language];
    
    for (int i = 0; i < self.language.count ;i++) {
        
        NSDictionary *dict = arrayM[i];
        
        NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:dict];
        if (i == lan) {
            [dictM setObject:[NSNumber numberWithBool:YES] forKey:@"status"];
        }else{
            [dictM setObject:[NSNumber numberWithBool:NO] forKey:@"status"];
        }
        
        [arrayM replaceObjectAtIndex:i withObject:dictM];
    }
    self.language = arrayM;
    [self.lantableView reloadData];
}

-(void)createUI{
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight/3)];
    baseView.backgroundColor = UIColor.whiteColor;
    baseView.layer.cornerRadius = 15;
    baseView.layer.masksToBounds = YES;
    self.baseView = baseView;
    [self addSubview:self.baseView];
    
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"modeldialog"];
    [self.baseView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.baseView.mas_centerX);
        make.top.mas_equalTo(ScaleW(20));
        make.width.mas_equalTo(ScaleW(50));
        make.height.mas_equalTo(ScaleW(50));
    }];
    self.titleImage = imageView;
    self.titleImage.hidden = YES;
    
    UILabel *title = [[UILabel alloc] init];
    
    title.text = NSLocalizedString(@"排序方式", nil);
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightBold];
    title.textColor = ColorRGB(0x502314);
    
    [self.baseView addSubview:title];
    self.SettingTitleLabel = title;
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.baseView.mas_centerX);
        make.top.mas_equalTo(self.titleImage.mas_top).offset(ScaleW(5));
        make.width.mas_equalTo((ScaleW(150)));
        make.height.mas_equalTo(ScaleW(30));
    }];
    self.title = title;
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeSettingView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.baseView addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(ScaleW(-15));
        make.centerY.mas_equalTo(self.titleImage.mas_centerY);
        make.width.mas_equalTo(ScaleW(32));
        make.height.mas_equalTo(ScaleW(32));
    }];
    self.cancelBtn = closeButton;
    self.cancelBtn.hidden = YES;
    
    
    UIButton *OK_bt = [UIButton buttonWithType:UIButtonTypeCustom];;
    [OK_bt setTitle:@"確定" forState:UIControlStateNormal];
    [OK_bt addTarget:self action:@selector(sortclick) forControlEvents:UIControlEventTouchUpInside];
    OK_bt.backgroundColor = ColorRGB(0x0D5995);
    [self.baseView addSubview:OK_bt];
    [OK_bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-ScaleW(0));
        make.centerX.mas_equalTo(self.titleImage.mas_centerX);
        make.width.mas_equalTo(self.baseView.frame.size.width);
        make.height.mas_equalTo(ScaleW(84));
    }];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = UIColor.whiteColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.estimatedRowHeight = 100;
    [self.baseView addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.title.mas_bottom);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-ScaleW(80));
    }];
    self.lantableView = tableView;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

/**/
//弹出pickerView
- (void)popPickerView
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    self.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:0];
//    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    
    NSSet *set = [UIApplication sharedApplication].connectedScenes;
    UIWindowScene *windowScene = [set anyObject];
    UIWindow *keyWindow = windowScene.windows.firstObject;
    [keyWindow addSubview:self];

    self.baseView.frame = CGRectMake(0, Device_Height, screenWidth, screenHeight);
    self.baseView.alpha = 0.0;
    [UIView animateWithDuration:0.25
                     animations:^{
        self.baseView.alpha = 1.0;
        [self.baseView setFrame:CGRectMake(0,  ScaleH(360), Device_Width, Device_Height-ScaleH(360))];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    }];
}

-(void)closeSettingView
{
    [self removeFromSuperview];
}

-(void)sortclick
{
    [self removeFromSuperview];
    if(self.gBlock)
    {
        self.gBlock(self.selectedIndexes);
    }
}

#pragma mark ---language tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
       return self.language.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ScaleW(55);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EGSortCell *cell = [EGSortCell cellWithUITableView:tableView];
    [cell setTitle:[self.language objectAtIndex:indexPath.row][@"title"]];
    [cell setCheckstatus:[self.language objectAtIndex:indexPath.row][@"status"]];
    cell.gSwitchBlock = ^(BOOL select){
        
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
        
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexes = indexPath.row;
    
    NSMutableArray *arrayM = [NSMutableArray arrayWithArray:self.language];
    
    for (int i = 0; i < self.language.count ;i++) {
        
        NSDictionary *dict = arrayM[i];
        
        NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:dict];
        if (i == indexPath.row) {
            [dictM setObject:[NSNumber numberWithBool:YES] forKey:@"status"];
        }else{
            [dictM setObject:[NSNumber numberWithBool:NO] forKey:@"status"];
        }
        
        [arrayM replaceObjectAtIndex:i withObject:dictM];
    }
    self.language = arrayM;
    [self.lantableView reloadData];
    
}

@end
