#import "EGMembershipContentView.h"

// 定义会员卡配置结构
typedef struct {
    NSString *cardImage;
    NSString *title;
    NSString *price;
    NSString *buttonTitle;
    NSString *saleType;
    CGFloat priceFontSize;
    NSString *cardImage2;
    NSString *cardImage3;
    NSString *bottomText1;
    NSString *bottomText2;
} MembershipConfig;

@interface EGMembershipContentView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIScrollView *scrollView;        // 添加滚动视图
@property (nonatomic, strong) UIView *contentView;            // 内容容器视图

@property (nonatomic, strong) UIImageView *cardImageView;      // 会员卡图片
@property (nonatomic, weak) UIView *priceView;              // 价格视图

@property (nonatomic, weak) UIImageView *smImageView;      // 会员卡图片
@property (nonatomic, weak) UIImageView *bottomImageView;      // 会员卡图片

@property (nonatomic, weak)  UIButton *applyButton; // 购买按钮

@property (nonatomic, weak) UILabel * bottomLabel1;
@property (nonatomic, weak) UILabel * bottomLabel2;



@property (nonatomic, strong) UITableView *benefitsTableView;           // 权益说明
@property (nonatomic, strong) NSArray *benefitSections;
@property (nonatomic, strong) NSArray *benefitItems;

@property (nonatomic, weak) UITableView *giftTableView;
@property (nonatomic, strong) NSArray *giftItems;

@property (nonatomic, assign) EGMembershipType memberShipType;

@end

@implementation EGMembershipContentView

- (instancetype)initWithMembershipType:(EGMembershipType)type {
    if (self = [super init]) {
        self.memberShipType = type;
        [self setupUI];
        [self setupWithMembershipType:type];
    }
    return self;
}

- (void)setupUI {
    
    // 添加滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = YES;
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    // 添加内容容器视图
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    // 设置scrollView的contentSize，使其等于contentView的大小
//    self.scrollView.contentSize = self.contentView.bounds.size;
    
    // 创建一个容器视图来处理阴影
    UIView *cardContainer = [[UIView alloc] init];
    cardContainer.backgroundColor = [UIColor clearColor];
    cardContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    cardContainer.layer.shadowOffset = CGSizeMake(0, 2);
    cardContainer.layer.shadowOpacity = 0.8;
    cardContainer.layer.shadowRadius = 4;
    [self.contentView addSubview:cardContainer];
    
    [cardContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(ScaleW(20));
        make.centerX.equalTo(self.contentView);
        make.width.mas_equalTo(ScaleW(171));
        make.height.mas_equalTo(ScaleW(109));
    }];
       
    // 会员卡图片
    self.cardImageView = [[UIImageView alloc] init];
    self.cardImageView.layer.cornerRadius = ScaleW(8);
    self.cardImageView.layer.masksToBounds = YES;  // 开启裁剪以显示圆角
    self.cardImageView.backgroundColor = [UIColor whiteColor];
    [cardContainer addSubview:self.cardImageView];
    
    [self.cardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cardContainer);
    }];
    
    // 价格视图容器
    UIView *priceContainer = [[UIView alloc] init];
    priceContainer.backgroundColor = [UIColor whiteColor];
    priceContainer.layer.cornerRadius = ScaleW(16);
    priceContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    priceContainer.layer.shadowOffset = CGSizeMake(0, 2);
    priceContainer.layer.shadowOpacity = 0.1;
    priceContainer.layer.shadowRadius = 4;
    [self.contentView addSubview:priceContainer];
    
//    [priceContainer mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(cardContainer.mas_bottom).offset(ScaleW(35));
//        make.centerX.equalTo(self);
//        make.left.mas_equalTo(ScaleW(20));
//        make.right.mas_equalTo(-ScaleW(20));
//    }];
    self.priceView = priceContainer;
    
    // 在 setupUI 方法中添加一个最受欢迎的标签，默认隐藏
    UILabel *popularLabel = [[UILabel alloc] init];
    popularLabel.text = @"最受歡迎";
    popularLabel.textAlignment = NSTextAlignmentCenter;
    popularLabel.textColor = [UIColor whiteColor];
    popularLabel.backgroundColor =rgba(217, 174, 53, 1);
    popularLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightMedium];
    popularLabel.tag = 104;
    popularLabel.hidden = YES;
    popularLabel.layer.cornerRadius = ScaleW(14);
    popularLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:popularLabel];

    [popularLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(priceContainer.mas_top).offset(ScaleW(14));
        make.centerX.equalTo(priceContainer);
        make.width.mas_equalTo(ScaleW(92));
        make.height.mas_equalTo(ScaleW(28));
    }];
    
    // 会员类型标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor =rgba(0, 122, 96, 1);
    titleLabel.tag = 100;
    titleLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightMedium];
    [priceContainer addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceContainer).offset(ScaleW(30));
        make.centerX.equalTo(priceContainer);
    }];
    
    // 价格标签
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    priceLabel.tag = 101;
    priceLabel.font = [UIFont systemFontOfSize:FontSize(48) weight:UIFontWeightSemibold];
    [priceContainer addSubview:priceLabel];
    
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(ScaleW(8));
        make.centerX.equalTo(priceContainer);
    }];
    
    // 申办方案按钮
    UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    applyButton.backgroundColor = rgba(0, 122, 96, 1);
    applyButton.layer.cornerRadius = ScaleW(8);
    applyButton.layer.masksToBounds = YES;

    [applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    applyButton.tag = 102;
    applyButton.titleLabel.font =  [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightMedium];
    [applyButton addTarget:self action:@selector(applyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [applyButton setBackgroundImage:[UIImage imageWithColor:rgba(229, 229, 229, 1)] forState:UIControlStateDisabled];
    [applyButton setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateDisabled];
    
    [priceContainer addSubview:applyButton];
    self.applyButton = applyButton;
    
    [applyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceLabel.mas_bottom).offset(ScaleW(16));
        make.left.equalTo(priceContainer).offset(ScaleW(24));
        make.right.equalTo(priceContainer).offset(-ScaleW(24));
        make.height.mas_equalTo(ScaleW(50));
//        make.bottom.equalTo(priceContainer).offset(-ScaleW(16));
    }];
    
    // 价格标签
    UILabel *priceTypeLabel = [[UILabel alloc] init];
    priceTypeLabel.textAlignment = NSTextAlignmentCenter;
    priceTypeLabel.tag = 103;
  
    priceTypeLabel.textColor = rgba(82, 82, 82, 1);
    priceTypeLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightMedium];
    [priceContainer addSubview:priceTypeLabel];
    
    [priceTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(applyButton.mas_bottom).offset(ScaleW(8));
        make.centerX.equalTo(priceContainer);
        make.height.mas_equalTo(20);
//        make.bottom.mas_equalTo(priceContainer).offset(-ScaleW(20));
    }];
    
    // 添加权益列表
    self.benefitsTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.benefitsTableView.delegate = self;
    self.benefitsTableView.dataSource = self;
    self.benefitsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.benefitsTableView.scrollEnabled = NO;
    self.benefitsTableView.backgroundColor = rgba(245, 245, 245, 1);
    self.benefitsTableView.layer.cornerRadius = ScaleW(16);
    self.benefitsTableView.layer.maskedCorners = kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner; // 只设置底部圆角
    self.benefitsTableView.clipsToBounds = YES;
    self.benefitsTableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    [priceContainer addSubview:self.benefitsTableView];

    [self.benefitsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceTypeLabel.mas_bottom).offset(ScaleW(12));
        make.left.right.equalTo(priceContainer);
        make.height.mas_equalTo(ScaleW(500));
        make.bottom.mas_equalTo(priceContainer).offset(0);
    }];
    
    // 修改 priceContainer 的约束
    [priceContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardContainer.mas_bottom).offset(ScaleW(35));
        make.centerX.equalTo(self);
        make.left.mas_equalTo(ScaleW(20));
        make.right.mas_equalTo(-ScaleW(20));
        make.bottom.equalTo(self.benefitsTableView.mas_bottom);  // 添加这行
    }];
    
    
    // 添加底部图片视图
    UIImageView *smImageView = [[UIImageView alloc] init];
    smImageView.layer.cornerRadius = ScaleW(16);
    smImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:smImageView];
    self.smImageView = smImageView;
    [smImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceContainer.mas_bottom).offset(ScaleW(20));
        make.left.equalTo(priceContainer);
        make.right.equalTo(priceContainer);
        make.height.mas_equalTo(ScaleW(320));
    }];
    
    // 在 smImageView 后添加新的容器视图
    UIView *bottomContainer = [[UIView alloc] init];
    bottomContainer.backgroundColor = [UIColor whiteColor];
    bottomContainer.layer.cornerRadius = ScaleW(16);
    bottomContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    bottomContainer.layer.shadowOffset = CGSizeMake(0, 2);
    bottomContainer.layer.shadowOpacity = 0.1;
    bottomContainer.layer.shadowRadius = 4;
    [self.contentView addSubview:bottomContainer];
    
    // 上方图片
    UIImageView *bottomImage = [[UIImageView alloc] init];
//    bottomImage.layer.cornerRadius = ScaleW(16);
//    bottomImage.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
//    bottomImage.clipsToBounds = YES; 
//    bottomImage.contentMode = UIViewContentModeCenter;
    [bottomContainer addSubview:bottomImage];
    self.bottomImageView = bottomImage;
     
    // 下方文本容器
    UITableView *giftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    giftTableView.delegate = self;
    giftTableView.dataSource = self;
    giftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    giftTableView.scrollEnabled = NO;
    giftTableView.backgroundColor = [UIColor whiteColor];
    giftTableView.layer.maskedCorners = kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
    giftTableView.clipsToBounds = YES;
    giftTableView.layer.cornerRadius = ScaleW(16);
    [bottomContainer addSubview:giftTableView];
    self.giftTableView = giftTableView;

    
    // 底部两行标签
    UILabel *bottomLabel1 = [[UILabel alloc] init];
    bottomLabel1.textAlignment = NSTextAlignmentCenter;
    bottomLabel1.font = [UIFont systemFontOfSize:FontSize(20) weight:UIFontWeightSemibold];
    bottomLabel1.textColor = rgba(0, 122, 96, 1);
    [self.contentView addSubview:bottomLabel1];
    self.bottomLabel1 = bottomLabel1;
    
    UILabel *bottomLabel2 = [[UILabel alloc] init];
    bottomLabel2.textAlignment = NSTextAlignmentCenter;
    bottomLabel2.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightRegular];
    bottomLabel2.textColor = rgba(38, 38, 38, 1);
    bottomLabel2.numberOfLines = 0;
    [self.contentView addSubview:bottomLabel2];
    self.bottomLabel2 = bottomLabel2;
    
    // 设置约束
    [bottomContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.smImageView.mas_bottom).offset(ScaleW(24));
        make.left.right.equalTo(self.priceView);
    }];
    
    [bottomImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(bottomContainer);
        make.height.mas_equalTo(ScaleW(196));
    }];
    
    [giftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomImage.mas_bottom).offset(ScaleW(20));
        make.left.right.equalTo(bottomContainer);
//        make.centerX.equalTo(self);
//        make.left.mas_equalTo(ScaleW(20));
//        make.right.mas_equalTo(-ScaleW(20));
        make.height.mas_equalTo(ScaleW(200));
        make.bottom.mas_equalTo(bottomContainer).offset(-ScaleW(20));
    }];
    
    
    [bottomLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomContainer.mas_bottom).offset(ScaleW(20));
        make.left.right.equalTo(bottomContainer);
    }];
    
    [bottomLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomLabel1.mas_bottom).offset(ScaleW(8));
        make.left.right.equalTo(bottomContainer);
        make.bottom.equalTo(self.contentView).offset(-ScaleW(24));
    }];
    

    // 在最后添加底部约束以确保内容高度正确
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomLabel2.mas_bottom).offset(ScaleW(20));
    }];


}

- (MembershipConfig)configForType:(EGMembershipType)type {
    switch (type) {
        case EGMembershipTypeNormal:
            return (MembershipConfig){
                .cardImage = @"PeopleCard",
                .cardImage2 = @"PeopleSMCard",
                .cardImage3 = @"PeopleGFCard",
                .title = @"鷹國人",
                .price = @"$ 999",
                .buttonTitle = @"申辦此方案",
                .saleType = @"無限量販售",
                .bottomText1 = @"最超值入門方案",
                .bottomText2 = @"親民價格好入手，輕鬆無負擔",
                .priceFontSize = 48
               
            };
        case EGMembershipTypeParent:
            return (MembershipConfig){
                .cardImage = @"FamilyCard2",
                .cardImage2 = @"FamilySMCard",
                .cardImage3 = @"FamilyGFCard",
                .title = @"Takao 親子",
                .price = @"$ 3,180",
                .buttonTitle = @"現場實體申辦",
                .saleType = @"限量販售",
                .bottomText1 = @"親子優惠首選",
                .bottomText2 = @"內野票買一送一，贈漢堡王優惠券，打造全家共享的觀賽時光！",
                .priceFontSize = 48
            };
        case EGMembershipTypeVIP:
            return (MembershipConfig){
                .cardImage = @"HonorCard",
                .cardImage2 = @"HonorSMCard",
                .cardImage3 = @"HonorGFCard",
                .title = @"鷹國尊爵",
                .price = @"$ 3,988",
                .buttonTitle = @"已完售",
                .saleType = @"限量販售",
                .bottomText1 = @"限量尊榮體驗",
                .bottomText2 = @"提供最佳看球配備，給熱愛台鋼天鷹的您",
                .priceFontSize = 48
            };
        case EGMembershipTypeRoyal:
            return (MembershipConfig){
                .cardImage = @"RoyalCard",
                .cardImage2 = @"RoyalSMCard",
                .cardImage3 =@"RoyalGFCard",
                .title = @"鷹國皇家",
                .price = @"敬請期待",
                .buttonTitle = @"已完售",
                .saleType = @"限量販售",
                .bottomText1 = @"頂級會員方案",
                .bottomText2 = @"一次擁有48場全年澄清湖主場季票與最高等級會員權益",
                .priceFontSize = 32
            };
    }
}

- (void)setupWithMembershipType:(EGMembershipType)type {
    MembershipConfig config = [self configForType:type];
    
    // 设置会员卡图片
    self.cardImageView.image = [UIImage imageNamed:config.cardImage];
    
    // 设置标题
    UILabel *titleLabel = [self.priceView viewWithTag:100];
    titleLabel.text = config.title;
    
    // 设置价格
    UILabel *priceLabel = [self.priceView viewWithTag:101];
    priceLabel.text = config.price;
    priceLabel.font = [UIFont systemFontOfSize:FontSize(config.priceFontSize) weight:UIFontWeightSemibold];
    
    // 设置按钮
    UIButton *applyButton = [self.priceView viewWithTag:102];
    [applyButton setTitle:config.buttonTitle forState:UIControlStateNormal];
//    applyButton.backgroundColor = rgba(229, 229, 229, 1);
//    [applyButton setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
//    applyButton.backgroundColor = rgba(0, 122, 96, 1);
//    applyButton.backgroundColor = rgba(229, 229, 229, 1);
    [applyButton setTitleColor:rgba(255, 255, 255, 1) forState:UIControlStateNormal];
    [applyButton setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateDisabled];
    [applyButton setBackgroundImage:[UIImage imageWithColor:rgba(0, 122, 96, 1)] forState:UIControlStateNormal];
    [applyButton setBackgroundImage:[UIImage imageWithColor:rgba(229, 229, 229, 1)] forState:UIControlStateDisabled];
    
    
    
    // 设置销售类型
    UILabel *priceTypeLabel = [self.priceView viewWithTag:103];
    priceTypeLabel.text = config.saleType;
    
    self.smImageView.image = [UIImage imageNamed:config.cardImage2];
    self.bottomImageView.image = [UIImage imageNamed:config.cardImage3];
    
    self.bottomLabel1.text = config.bottomText1;
    self.bottomLabel2.text = config.bottomText2;
    
    // 为 Parent 类型设置特殊样式
    if (type == EGMembershipTypeParent) {
        
        titleLabel.textColor = rgba(217, 174, 53, 1); // 金黄色
        self.priceView.layer.borderWidth = 1.5;
        self.priceView.layer.borderColor = rgba(217, 174, 53, 1).CGColor;
        UILabel *popularLabel = [self viewWithTag:104];
        popularLabel.hidden = NO;
        
        self.bottomLabel1.textColor = rgba(217, 174, 53, 1); // 金黄色
    }else{
        titleLabel.textColor = rgba(0, 122, 96, 1); // 恢复默认颜色
        self.priceView.layer.borderWidth = 0;
        UILabel *popularLabel = [self viewWithTag:104];
        popularLabel.hidden = YES;
        
        self.bottomLabel1.textColor = rgba(0, 122, 96, 1);
      
    }
    
    // 为 Parent 类型设置特殊样式
    if (type == EGMembershipTypeParent) {
       
//        applyButton.backgroundColor = rgba(229, 229, 229, 1);
//        [applyButton setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
        applyButton.enabled = NO;
    
        self.benefitSections = @[@"購票優惠", @"主場優先購票權", @"購物優惠", @"其他權益"];
        self.benefitItems = @[
            @[@"2025年主場例行賽內野全票現場購票買一送一，大巨蛋場次不適用(每卡每場限購2張)"],
            @[@"第 3 順位 (每卡每場限購 4 張)"],
            @[@"享實體商店 9 折"],
            @[@"小小鷹援團活動優先報名資格"]
        ];
        self.giftItems = @[@"Takao 外出隨行包",@"Takao 零錢卡包",@"Takao 多功能快乾巾",@"Takao 絨毛尾巴扇坐墊",@"現場商品折價券500元",@"漢堡王折價券價值 500元"];
        
    }else if(type == EGMembershipTypeRoyal){
//        applyButton.backgroundColor = rgba(229, 229, 229, 1);
//        [applyButton setTitleColor:rgba(115, 115, 115, 1) forState:UIControlStateNormal];
        applyButton.enabled = NO;
        self.benefitSections = @[@"專屬票券",@"購票優惠", @"主場優先購票權", @"購物優惠", @"其他權益"];
        self.benefitItems = @[
            @[@"2025 澄清湖主場專屬座位票券"],
            @[@"2025年主場賽事內野門票現場購票全票每張折抵＄50 (每卡每場限購2張)"],
            @[@"第 1 順位 (每卡每場限購 4 張)"],
            @[@"實體商店 85 折"],
            @[@"主場勝場 MVP 抽獎資格",@"會員專屬活動", @"澄清湖主場提早 10 分鐘進場"]
        ];
        
        self.giftItems = @[@"專屬球衣",@"48 場澄清湖專屬座位票券",@"會員生日禮（球員親簽生日賀卡）",@"例行賽內野門票兌換券（平日2張/假日2張）",@"現場商品折價券500元",@"合作夥伴獨享優惠(漢堡王) 500元"];
    }
    else if(type == EGMembershipTypeVIP){
//        applyButton.backgroundColor = rgba(0, 122, 96, 1);
        applyButton.enabled = NO;
        self.benefitSections = @[@"購票優惠", @"主場優先購票權", @"購物優惠", @"其他權益"];
        self.benefitItems = @[
            @[@"2025年主場賽事內野門票現場購票全票每張折抵 $50 (每卡每場限購2張)"],
            @[@"第 2 順位 (每卡每場限購 4 張)"],
            @[@"享實體商店 9 折"],
            @[@"主場勝場 MVP 抽獎資格"]
        ];
        
        self.giftItems = @[@"摺疊沙灘椅",@"旅行袋",@"緹花毛巾",@"雙面兩用帽",@"會員生日禮（球員親簽生日賀卡）",@"例行賽內野門票兌換券（平日2張/假日2張）",@"現場商品折價券500元",@"合作夥伴獨享優惠(漢堡王) 500元"];
    }
    else if(type == EGMembershipTypeNormal){
//        applyButton.backgroundColor = rgba(0, 122, 96, 1);
        applyButton.enabled = YES;
        
        self.benefitSections = @[@"購票優惠", @"主場優先購票權", @"購物優惠"];
        self.benefitItems = @[
            @[@"2025年主場賽事內野門票現場購票全票每張折抵 $50 (每卡每場限購2張)"],
            @[@"第 4 順位 (每卡每場限購 2 張)"],
            @[@"享實體商店 9 折"]
            // @[@"合作夥伴優惠（鷹援店）"]
        ];
        self.giftItems = @[@"專屬紀念球",@"例行賽內野門票兌換券（平日1張/假日1張）",@"現場商品折價券200元"];
    }

    // 计算 tableView 的总高度
    CGFloat totalHeight = 30;
    CGFloat totalHeight2 = 0;
    // 计算所有 section header 的高度
    totalHeight += self.benefitSections.count * ScaleW(32);
    // 计算所有 row 的高度
    for (NSArray *items in self.benefitItems) {
        totalHeight += items.count * ScaleW(42);
    }
    totalHeight +=ScaleW(70-42); //購票優惠 比其他行高
   
    totalHeight2 += self.giftItems.count * ScaleW(42);
    
    
    // 更新 tableView 的高度约束
    [self.benefitsTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(totalHeight);
    }];
    // 更新 tableView 的高度约束
    [self.giftTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(totalHeight2);
    }];
    NSLog(@"totalHeight:%f",totalHeight);
    [self.benefitsTableView reloadData];
    [self.giftTableView reloadData];
    [self layoutSubviews];

}

-(void)setContentInfo:( id ) info {
    if ([info isKindOfClass:[NSNumber class]]) {
        BOOL isHiden = [info boolValue];
        [self.applyButton setEnabled:isHiden];
    }
}

// 添加点击事件处理方法
- (void)applyButtonClicked {
 
    NSURL *webURL = [NSURL URLWithString:@"https://hawkmember.newretail.app/"];
    
    [[UIApplication sharedApplication] openURL:webURL options:@{} completionHandler:nil];
//    
//    if (self.purchaseButtonClickBlock) {
//        self.purchaseButtonClickBlock(self.memberShipType);
//    }
}


#pragma mark - TableView 代理方法
// 添加 TableView 相关方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.benefitsTableView) {
        return self.benefitSections.count;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.benefitsTableView) {
        NSArray *items = self.benefitItems[section];
        return items.count;
    }else{
        return self.giftItems.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.benefitsTableView) {
        static NSString *cellId = @"BenefitCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            // 添加勾选图标
            
            UIImageView *checkmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Check_green"]];
            if (self.memberShipType == EGMembershipTypeParent) {
            
                [checkmark setImage:[UIImage imageNamed:@"Check_yellow"]];
            }else{
                [checkmark setImage:[UIImage imageNamed:@"Check_green"]];
            }
            [cell.contentView addSubview:checkmark];
         
            // 添加文本标签
            UILabel *label = [[UILabel alloc] init];
            label.tag = 1001;
            label.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightMedium];
            label.textColor = rgba(23, 23, 23, 1);
            label.numberOfLines = 0;
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(checkmark.mas_right).offset(ScaleW(8));
                make.right.equalTo(cell.contentView).offset(-ScaleW(24));  // 添加右边距
                make.centerY.equalTo(cell.contentView);
            }];
            
            [checkmark mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView).offset(ScaleW(24));  // 添加左边距
                make.top.equalTo(label);
                make.width.height.mas_equalTo(20);
            }];
        }
        
        NSArray *items = self.benefitItems[indexPath.section];
        UILabel *label = [cell.contentView viewWithTag:1001];
        label.text = items[indexPath.row];
        return cell;
    }else{
        static NSString *cellId = @"TextCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            // 添加序号标签
            UILabel *indexLabel = [[UILabel alloc] init];
            indexLabel.tag = 2001;
            indexLabel.textAlignment = NSTextAlignmentCenter;
            indexLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightSemibold];
            indexLabel.textColor = rgba(16, 185, 129, 1);
            [cell.contentView addSubview:indexLabel];
            
            // 添加内容标签
            UILabel *contentLabel = [[UILabel alloc] init];
            contentLabel.tag = 2002;
            contentLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightMedium];
            contentLabel.textColor = rgba(23, 23, 23, 1);
            contentLabel.numberOfLines = 0;
            [cell.contentView addSubview:contentLabel];
            
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(indexLabel.mas_right).offset(ScaleW(8));
                make.right.equalTo(cell.contentView).offset(-ScaleW(24));
                make.centerY.equalTo(cell.contentView);
            }];
            
            [indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView).offset(ScaleW(24));
                make.top.equalTo(contentLabel);
                make.width.mas_equalTo(ScaleW(24));
            }];
        }
        
        UILabel *indexLabel = [cell.contentView viewWithTag:2001];
        UILabel *contentLabel = [cell.contentView viewWithTag:2002];
        // 使用 ASCII 码生成序号（A的ASCII码是65）
        indexLabel.text = [NSString stringWithFormat:@"%c", (char)(65 + indexPath.row)];
        contentLabel.text = [self.giftItems objectAtIndex:indexPath.row];
        
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (tableView == self.benefitsTableView) {
        UIView *header = [[UIView alloc] init];
        UILabel *label = [[UILabel alloc] init];
        label.text = self.benefitSections[section];
        label.textColor = rgba(115, 115, 115, 1);
        label.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightRegular];
        [header addSubview:label];
        // 判断是否是"主場優先購票權"section
        if ([self.benefitSections[section] isEqualToString:@"主場優先購票權"]) {
            UIImageView *infoIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"information"]];
            [header addSubview:infoIcon];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(header).offset(ScaleW(24));
                make.centerY.equalTo(header);
            }];
            
            [infoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(label.mas_right).offset(ScaleW(4));
                make.centerY.equalTo(label);
                make.width.height.mas_equalTo(ScaleW(16));
            }];
        } else {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(header).offset(ScaleW(24));
                make.centerY.equalTo(header);
                make.right.equalTo(header).offset(-ScaleW(24));
            }];
        }
        return header;
    }else{
        return [UIView new];
    }
    
  //  header.backgroundColor = [UIColor redColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (tableView == self.benefitsTableView) {
        return ScaleW(32);
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.benefitsTableView) {
        NSArray *items = self.benefitItems[indexPath.section];
        NSString *content = items[indexPath.row];
        
        // 如果是购票优惠的内容，通常文字较多，给更多的高度
        if ([self.benefitSections[indexPath.section] isEqualToString:@"購票優惠"]) {
            return ScaleW(70);
        }
        return ScaleW(42);
//        // 其他情况根据内容计算高度
//        UIFont *font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightMedium];
//        CGFloat maxWidth = Device_Width - ScaleW(76); // 24(左边距) + 20(勾选图标) + 8(图标和文字间距) + 24(右边距)
//        
//        CGRect rect = [content boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
//                                            options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
//                                         attributes:@{NSFontAttributeName: font}
//                                            context:nil];
//        
//        return MAX(ScaleW(42), ceil(rect.size.height) + ScaleW(16)); // 16是上下padding
    } else {
        return ScaleW(42);
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;//CGFLOAT_MIN;
}

-(void)addmenu{
    // 添加下拉菜单按钮
        UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [menuButton setTitle:@"選擇" forState:UIControlStateNormal];
        menuButton.backgroundColor = rgba(0, 122, 96, 1);
        menuButton.layer.cornerRadius = ScaleW(8);
        [menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        menuButton.titleLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightMedium];
        [self.contentView addSubview:menuButton];
        
        [menuButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(ScaleW(20));
            make.right.equalTo(self.contentView).offset(-ScaleW(20));
            make.width.mas_equalTo(ScaleW(100));
            make.height.mas_equalTo(ScaleW(40));
        }];
        
        // 创建菜单项
        NSArray *menuTitles = @[@"1", @"2", @"3", @"4"];
        NSMutableArray *actions = [NSMutableArray array];
        
        [menuTitles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
            UIAction *action = [UIAction actionWithTitle:title
                                                image:nil
                                           identifier:nil
                                              handler:^(__kindof UIAction *action) {
//                if (self.menuSelectBlock) {
//                    self.menuSelectBlock(idx);
//                }
            }];
            [actions addObject:action];
        }];
        
        // 创建菜单
        UIMenu *menu = [UIMenu menuWithTitle:@"" children:actions];
        menuButton.menu = menu;
        menuButton.showsMenuAsPrimaryAction = YES;
}

@end
