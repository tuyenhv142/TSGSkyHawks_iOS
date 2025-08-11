//
//  EGPolicyViewController.m
//  EagleBaseballTeam
//
//  Created by rick on 3/5/25.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGServiceViewController.h"

// 1. 添加常量定义
static NSString *const kImageCellID = @"imagecell";
static NSString *const kContentCellID = @"contentcell";
static NSString *const kItemCellID = @"itemcell2";


@interface EGServiceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *itemArray;
@property (nonatomic,weak) UITableView *tableView;

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation EGServiceViewController

- (UITableView *)tableView
{
    if (_tableView == nil) {
        
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = rgba(245, 245, 245, 1);
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kImageCellID];
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kContentCellID];
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kItemCellID];
//        tableView.rowHeight = UITableViewAutomaticDimension;
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
    self.titleLabel.text = @"使用者服務條款";
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
        make.top.equalTo(topView).offset(ScaleW(5));
        make.right.equalTo(topView).offset(-ScaleW(5));
        make.width.height.mas_equalTo(ScaleW(40));
    }];
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"policy" ofType:@"json"];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    NSDictionary *json_data = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
//    
//    self.dataArray = [NSMutableArray arrayWithArray:[json_data objectOrNilForKey:@"policy_data"]];
    self.dataArray = [NSMutableArray array];
    [self.dataArray addObject:@""];
    [self.dataArray addObject:@"歡迎您來到台鋼天鷹APP（以下簡稱本APP），當您使用本APP時，即表示您已閱讀、瞭解並同意接受本APP之所有服務聲明之內容（包括但不限於服務聲明內容有任何修改或變更）。若您無法確實遵守服務聲明內容或對於服務聲明內容之全部或部份不同意時，請您立即停止使用本APP。若您未滿十八歲或無完全行為能力者，須經由您的法定代理人（監護人）閱讀、瞭解並同意服務聲明內容後，方得使用本APP所提供的服務；當您開始使用本APP所提供之服務時，則視為您的法定代理人（監護人）亦已閱讀、瞭解並同意服務聲明內容（包括但不限於服務聲明內容有任何修改或變更）。 "];
    [self.dataArray addObject:@"本APP之廣告內容、文字、圖片說明、展示樣品或其他資訊等，均係各廣告商、產品與服務之供應商所提供，您應自行斟酌與判斷該廣告之可信度與真實性。 "];
    [self.dataArray addObject:@"本APP服務可能因故發生中斷或故障等現象，或許將造成您使用上的不便、資料喪失、錯誤、遭人篡改或其他包括但不限於經濟上之損失等情形，故您於使用本APP時應自行採取防護措施，且發生前述情事時，不論發生原因為何，本APP不負任何責任。 "];
    [self.dataArray addObject:@"本APP將依一般合理之技術及方式，維持本APP及服務之正常運作。若因相關之軟硬體設備需進行搬遷、更新、升級、保養或維修或依據法律、政府機關法令或主管機關要求，以及因天災或其他不可抗力事件、不可預期因素，導致本系統或設備有損壞、停止或中斷之情形，或因應公司組織變更或業務調整所需導致之系統停止或中斷，您明白並同意本APP得以暫停或終止APP之全部或部分，且本APP無須負任何責任。 "];
    [self.dataArray addObject:@"您在使用本系統之各項服務均受服務條款之規範，且必須保證絕不為任何非法目的或以任何非法方式瀏覽使用本APP服務，並不得利用本APP侵害他人權益或違法行為（包括但不限於公開張貼任何誹謗、侮辱、具威脅性、攻擊性、不雅、猥褻、不實、違反公共秩序或善良風俗或其他不法之文字、圖片等），違反者除應自負法律責任外，本APP有權依其單獨裁量逕行拒絕或移除任何您涉及違反服務聲明內容或法令規定之言論及圖文內容。 "];
    [self.dataArray addObject:@"除服務聲明內容已有之其他規範外，本APP服務及使用之風險是由您個人負擔，亦不對以下事項作出任何擔保或賠償。"];
    
    self.itemArray = [NSMutableArray array];
    [self.itemArray addObject:@"本APP之內容因有涉於不實、人身攻擊、毀謗，或引起任何爭議所造成之任何侵權、賠償。"];
    [self.itemArray addObject:@"本APP或連結第三方之內容、資訊、產品、服務、軟體未符合您的需求。"];
    [self.itemArray addObject:@"任何經由本APP或連結之第三方網站所購買或取得之任何商品及服務，未符合您的期望、毫無錯誤瑕疵、安全可靠。"];
    [self.itemArray addObject:@"任何因瀏覽使用本APP所引發之以下情事，包括但不限於因下載行為而感染電腦病毒、誹謗、毀損、版權或侵犯智慧財產權所造成的任何損失。 "];
    [self.itemArray addObject:@"本系統發生中斷或故障等現象。"];

    [self.dataArray addObject:@"本APP所使用之軟體程式及本APP上所有內容，包括但不限於文字、圖片、檔案、資訊、網站架構、報導、專欄、照片、插圖、影像、錄音、畫面的安排、網頁設計等，均由台鋼天鷹排球隊股份有限公司（以下簡稱本公司）或其他權利人依法擁有其所有權與智慧財產權（包括但不限於商標權、專利權、著作權、營業秘密、及技術等），任何人與您不得逕自使用、修改、重製、公開播送、公開傳輸、公開演出、改作、散布、發行、公開發表、進行還原工程、解編、反向組譯或為任何違反法令之行為。 "];
    [self.dataArray addObject:@"若您欲引用或轉載前述軟體、程式或網站內容，除明確為法律所許可者外，必須依法取得台鋼天鷹排球隊股份有限公司或其他權利人的事前書面同意。尊重智慧財產權及法令規定是您應盡的義務，如有違反，您應對本公司或第三人負起民刑事法律責任。本APP為行銷宣傳服務內容，就服務內容相關之商品或服務名稱、圖樣等，依其註冊或使用之狀態，享有智慧財產權及相關法令規定之保護，在未經本公司事前書面許可或其他權利人授權之前，您同意不以任何方式使用。本系統上所刊載內容之圖片浮水印、商標或其他聲明，嚴禁更改或移除。 "];
    [self.dataArray addObject:@"您聲明及保證就本APP之使用及所有內容，僅限於供您個人、非商業用途之合理使用，否則您應另與本APP洽談授權合作事宜，且您保證使用、修改、重製、公開播送、改作、散布、發行、公開發表、公開傳輸、公開上映、翻譯、轉授權本系統之資料，不致侵害任何第三人之智慧財產權或任何權利。您違反任何服務聲明內容，致本APP受有任何損害時，您應對本APP負損害賠償責任（包括但不限於訴訟費用、鑑定費用、律師費用、本APP與第三人之和解金、賠償金等）。 "];
    [self.dataArray addObject:@"若任何一服務條款無效，不影響其他條款之效力。您與本APP所引起之疑義、爭執或糾紛，雙方同意依中華民國法令解釋及規章為依據，以誠信原則解決之。 "];
    
    self.tableView.delegate =self;
    self.tableView.dataSource =self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = rgba(245, 245, 245, 1);
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)closeButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 3. 添加工具方法
- (NSAttributedString *)attributedStringWithText:(NSString *)text {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    
    return [[NSAttributedString alloc] initWithString:text ?: @""
                                         attributes:@{
        NSParagraphStyleAttributeName: paragraphStyle,
        NSFontAttributeName: [UIFont systemFontOfSize:FontSize(14)],
        NSForegroundColorAttributeName: rgba(38, 38, 38, 1)
    }];
}

- (UITableViewCell *)configureContentCell:(UITableView *)tableView content:(NSString *)content {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kContentCellID];
    cell.textLabel.attributedText = [self attributedStringWithText:content];
    
    if (![cell.contentView viewWithTag:1002]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.numberOfLines = 0;
        cell.backgroundColor = [UIColor clearColor];
        
        [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView).offset(ScaleW(10));
            make.left.equalTo(cell.contentView).offset(ScaleW(20));
            make.right.equalTo(cell.contentView).offset(-ScaleW(20));
            make.bottom.equalTo(cell.contentView);
        }];
    }
    return cell;
}

- (UITableViewCell *)configureItemCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kItemCellID];
    
    // 配置基本属性
    if (![cell.contentView viewWithTag:1003]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.numberOfLines = 0;
        cell.backgroundColor = [UIColor clearColor];
        
        UILabel *numberLabel = [[UILabel alloc] init];
        numberLabel.tag = 1003;
        numberLabel.font = [UIFont systemFontOfSize:FontSize(14)];
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
//            make.bottom.equalTo(cell.contentView);
        }];
    }
    
    // 更新内容
    UILabel *numberLabel = [cell.contentView viewWithTag:1003];
    numberLabel.text = [NSString stringWithFormat:@"%ld.", (long)indexPath.section-1];
    cell.textLabel.attributedText = [self attributedStringWithText:self.dataArray[indexPath.section]];
    
    // 当 section 为 5 时，添加子项目
       if (indexPath.section == 5) {
           UIView *lastView = cell.textLabel;
           
           // 移除之前创建的子项目（如果有）
           for (UIView *subview in cell.contentView.subviews) {
               if (subview.tag >= 2000) {
                   [subview removeFromSuperview];
               }
           }
           
           // 添加子项目
           for (NSInteger i = 0; i < self.itemArray.count; i++) {
               UIView *itemView = [self createItemViewWithNumber:i text:self.itemArray[i]];
               itemView.tag = 2000 + i; // 使用2000以上的tag标识子项目
               [cell.contentView addSubview:itemView];
               
               [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                   make.top.equalTo(lastView.mas_bottom).offset(ScaleW(10));
                   make.left.equalTo(cell.contentView).offset(ScaleW(43));
                   make.right.equalTo(cell.contentView).offset(-ScaleW(20));
                   if (i == self.itemArray.count - 1) {
                       make.bottom.equalTo(cell.contentView).offset(-ScaleW(10));
                   }
               }];
               
               lastView = itemView;
           }
       } else {
           // 非第5个section时，确保cell.textLabel的bottom约束正确
           [cell.textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
               make.bottom.equalTo(cell.contentView).offset(-ScaleW(10));
           }];
       }
    
    return cell;
}

// 生成单个条目的视图
- (UIView *)createItemViewWithNumber:(NSInteger)number text:(NSString *)text {
    UIView *containerView = [[UIView alloc] init];
    
    // 序号标签
    UILabel *numberLabel = [[UILabel alloc] init];
    // 使用 ASCII 码生成序号（A的ASCII码是65 a:97）
    numberLabel.text = [NSString stringWithFormat:@"%c.", (char)(97 + number)];
    numberLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
    numberLabel.textColor = rgba(38, 38, 38, 1);
    [containerView addSubview:numberLabel];
    
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(containerView);
        make.width.mas_equalTo(ScaleW(13));
    }];
    
//    UIView *lastView = numberLabel;
    // 内容标签
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = text;
    contentLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
    contentLabel.textColor = rgba(38, 38, 38, 1);
    contentLabel.numberOfLines = 0;
    [containerView addSubview:contentLabel];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(containerView);
        make.left.equalTo(numberLabel.mas_right).offset(ScaleW(2));
        make.right.bottom.equalTo(containerView);
    }];
    
    return containerView;
}

// 4. 优化 cell 配置方法
- (UITableViewCell *)configureImageCell:(UITableView *)tableView {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kImageCellID];
    if (![cell.contentView viewWithTag:1001]) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = 1001;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = [UIImage imageNamed:@"policyback"];
        [cell.contentView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
            make.height.mas_equalTo(ScaleW(166));
        }];
    }
    return cell;
}


#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section == 0) return 1;
//    
//    id sectionData = self.dataArray[section];
//    ELog(@"sectionData:%@",sectionData);
//    if ([sectionData isKindOfClass:[NSDictionary class]]) {
//        NSArray *itemContentArray = [sectionData objectForKey:@"itemContent"];
//        if (itemContentArray && itemContentArray.count > 0) {
//            NSString *content = [sectionData objectForKey:@"content"];
//            if ([content isEqualToString:@""]) {
//                return  itemContentArray.count;
//            }
//            return itemContentArray.count + 1;
//        }
//    }
    return 1;
 
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [self configureImageCell:tableView];
    }else if( indexPath.section == 1){
        return  [self configureContentCell:tableView content:self.dataArray[indexPath.section]];
    }else{
        return  [self configureItemCell:tableView indexPath:indexPath];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return 0;
//    }
//    return UITableViewAutomaticDimension;
    return 0;
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
