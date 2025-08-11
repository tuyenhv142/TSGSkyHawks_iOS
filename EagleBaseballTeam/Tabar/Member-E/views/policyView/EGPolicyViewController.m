//
//  EGPolicyViewController.m
//  EagleBaseballTeam
//
//  Created by rick on 3/5/25.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGPolicyViewController.h"
// 添加cell标识符常量
static NSString *const kImageCellID = @"imagecell";
static NSString *const kPolicyCellID = @"policycell";
static NSString *const kItemCellID = @"itemcell";

@interface EGPolicyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation EGPolicyViewController

- (UITableView *)tableView
{
    if (_tableView == nil) {
        
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        // tableView.backgroundColor = rgba(245, 245, 245, 1);
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.estimatedRowHeight = 100;
        self.tableView = tableView;
        [self.view addSubview:self.tableView];
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = rgba(245, 245, 245, 1);
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, ScaleW(45))];
    topView.backgroundColor =  rgba(0, 71, 56, 1);
    [self.view addSubview:topView];
    
    // 设置标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightMedium];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:self.titleLabel];
    
    // 设置关闭按钮
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setTitle:@"✕" forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:self.closeButton];
    
    // 标题约束
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView).offset(0);
        make.centerX.equalTo(topView);
        make.height.mas_equalTo(ScaleW(40));
    }];
    
    // 关闭按钮约束
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView).offset(ScaleW(5));
        make.right.equalTo(topView).offset(-ScaleW(5));
        make.width.height.mas_equalTo(ScaleW(40));
    }];
    
    self.tableView.delegate =self;
    self.tableView.dataSource =self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = rgba(245, 245, 245, 1);
    [self.view addSubview:self.tableView];
    
    
    
    NSString *path;
    if (self.type == 0 || self.type == 2) {
        self.titleLabel.text = @"會員帳號移轉作業";
        path = [[NSBundle mainBundle] pathForResource:@"accountTransfer" ofType:@"json"];
        
        if (self.type == 0) {
            UIButton *sureBtn = [[UIButton alloc] init];
            sureBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
            [sureBtn setTitle:@"同意" forState:UIControlStateNormal];
            [sureBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            sureBtn.backgroundColor = rgba(0, 122, 96, 1);
            [sureBtn addTarget:self action:@selector(bottomAgreeButtonAction) forControlEvents:UIControlEventTouchUpInside];
            sureBtn.titleEdgeInsets = UIEdgeInsetsMake(-ScaleW(25), 0, 0, 0); // 文字往上偏移 10 點
            [sureBtn sizeToFit];
            [self.view addSubview:sureBtn];
            [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(0);
                make.height.mas_equalTo(ScaleW(48)+[UIDevice de_safeDistanceBottom]);
                make.right.mas_equalTo(0);
                make.left.mas_equalTo(0);
            }];
            [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(topView.mas_bottom);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.bottom.mas_equalTo(-[UIDevice de_tabBarFullHeight]);
            }];
        }else{
            [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(topView.mas_bottom);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
            }];
        }
        
        
    }else{
        self.titleLabel.text = @"隱私條款";
        path = [[NSBundle mainBundle] pathForResource:@"policy" ofType:@"json"];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topView.mas_bottom);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *json_data = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
    
    self.dataArray = [NSMutableArray arrayWithArray:[json_data objectOrNilForKey:@"policy_data"]];
  
    [self.dataArray insertObject:@"" atIndex:0];
    
    
}

- (void)closeButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)bottomAgreeButtonAction
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.agreeBlock) {
            self.agreeBlock();
        }
    }];
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) return 1;
    
    id sectionData = self.dataArray[section];
    ELog(@"sectionData:%@",sectionData);
    if ([sectionData isKindOfClass:[NSDictionary class]]) {
        NSArray *itemContentArray = [sectionData objectForKey:@"itemContent"];
        if (itemContentArray && itemContentArray.count > 0) {
            NSString *content = [sectionData objectForKey:@"content"];
            if ([content isEqualToString:@""]) {
                return  itemContentArray.count;
            }
            return itemContentArray.count + 1;
        }
    }
    return 1;
 
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 第一个section显示图片
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kImageCellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kImageCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            // 将 imageView 创建和约束移到这里，避免重复创建
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.tag = 1001;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [cell.contentView addSubview:imageView];
            
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(cell.contentView);
                make.height.mas_equalTo(ScaleW(166));
            }];
        }
        
        UIImageView *imageView = [cell.contentView viewWithTag:1001];
        imageView.image = [UIImage imageNamed:@"policyback"];
        return cell;
    }
    
    // 内容展示
    if (indexPath.row == 0) {
        NSString *content = [self.dataArray[indexPath.section] valueForKey:@"content"];
        if (![content isEqualToString:@""]) {
            return [self configureContentCell:tableView indexPath:indexPath];
        }
    }
    
    // 列表项展示
    return [self configureItemCell:tableView indexPath:indexPath];
}


// 3. 抽取cell配置方法
- (UITableViewCell *)configureContentCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPolicyCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kPolicyCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.textColor = rgba(38, 38, 38, 1);
        [cell.textLabel setFont: [UIFont systemFontOfSize:FontSize(14)]];
        cell.backgroundColor = [UIColor clearColor];
        
        // 添加约束
        [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView).offset(ScaleW(10));
            make.left.equalTo(cell.contentView).offset(ScaleW(20));
            make.right.equalTo(cell.contentView).offset(-ScaleW(20));
            make.bottom.equalTo(cell.contentView);
        }];
    }
    
    NSString* content = [self.dataArray[indexPath.section] valueForKey:@"content"];
    cell.textLabel.attributedText = [self attributedStringWithText:content];
    return cell;
}

- (UITableViewCell *)configureItemCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kItemCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kItemCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.textColor = rgba(38, 38, 38, 1);
        [cell.textLabel setFont: [UIFont systemFontOfSize:FontSize(14)]];
        cell.backgroundColor = [UIColor clearColor];
        
        // 创建序号标签
        UILabel *numberLabel = [[UILabel alloc] init];
        numberLabel.tag = 1002;
        numberLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
        numberLabel.textColor = rgba(38, 38, 38, 1);
        [cell.contentView addSubview:numberLabel];
        
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView).offset(ScaleW(10));
            make.left.equalTo(cell.contentView).offset(ScaleW(23));
            make.width.mas_equalTo(ScaleW(15));
        }];
        
        [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(numberLabel);
            make.left.equalTo(numberLabel.mas_right);
            make.right.equalTo(cell.contentView).offset(-ScaleW(20));
            make.bottom.equalTo(cell.contentView);
        }];
    }
    
    // 更新序号和内容
    NSInteger index = [self calculateIndexForIndexPath:indexPath];
    UILabel *numberLabel = [cell.contentView viewWithTag:1002];
    numberLabel.text = [NSString stringWithFormat:@"%ld.", (long)index + 1];
    
    NSArray *itemContentArray = [self.dataArray[indexPath.section] objectForKey:@"itemContent"];
    NSString *itemContent = itemContentArray[[self calculateItemIndexForIndexPath:indexPath]];
    cell.textLabel.attributedText = [self attributedStringWithText:itemContent];
    
    return cell;
}

// 4. 添加工具方法
- (NSAttributedString *)attributedStringWithText:(NSString *)text {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    
    return [[NSAttributedString alloc] initWithString:text
                                          attributes:@{
        NSParagraphStyleAttributeName: paragraphStyle,
        NSFontAttributeName: [UIFont systemFontOfSize:FontSize(14)]
    }];
}

- (NSInteger)calculateIndexForIndexPath:(NSIndexPath *)indexPath {
    NSString *content = [self.dataArray[indexPath.section] valueForKey:@"content"];
    return [content isEqualToString:@""] ? indexPath.row : indexPath.row - 1;
}

- (NSInteger)calculateItemIndexForIndexPath:(NSIndexPath *)indexPath {
    NSString *content = [self.dataArray[indexPath.section] valueForKey:@"content"];
    return [content isEqualToString:@""] ? indexPath.row : indexPath.row - 1;
}


// 生成单个条目的视图
- (UIView *)createItemViewWithNumber:(NSInteger)number text:(NSString *)text {
    UIView *containerView = [[UIView alloc] init];
    
    // 序号标签
    UILabel *numberLabel = [[UILabel alloc] init];
    numberLabel.text = [NSString stringWithFormat:@"%ld.", (long)number];
    numberLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
    numberLabel.textColor = rgba(115, 115, 115, 1);
    [containerView addSubview:numberLabel];
    
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(containerView);
        make.width.mas_equalTo(ScaleW(15));
    }];
    
//    UIView *lastView = numberLabel;
    // 内容标签
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = text;
    contentLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
    contentLabel.textColor =  rgba(115, 115, 115, 1);
    contentLabel.numberOfLines = 0;
    [containerView addSubview:contentLabel];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(containerView);
        make.left.equalTo(numberLabel.mas_right).offset(ScaleW(4));
        make.right.bottom.equalTo(containerView);
    }];
    
    return containerView;
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return [UIView new];
    }
    UIView *headerView = [[UIView alloc] init];
  
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightSemibold];
    contentLabel.textColor = rgba(23, 23, 23, 1);
    contentLabel.text = [self.dataArray[section] objectOrNilForKey:@"title"];

    [headerView addSubview:contentLabel];

    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(headerView).offset(ScaleW(20));
        //        make.centerY.equalTo(headerView);
        make.top.equalTo(headerView).inset(ScaleW(10));
        make.bottom.equalTo(headerView);
    }];

    return headerView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return  0.000001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
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
