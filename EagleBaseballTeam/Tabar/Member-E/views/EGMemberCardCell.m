//
//  EGMemberCardCell.m
//  EagleBaseballTeam
//
//  Created by rick on 1/24/25.
//  Copyright © 2025 NewSoft. All rights reserved.
//
#import "EGPaddingLabel.h"
#import "EGMemberCardCell.h"
@interface EGMemberCardCell()<UIScrollViewDelegate>
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) EGPaddingLabel *typeLabel;
@property (nonatomic, strong) UILabel *durationLabel;

@property (nonatomic, strong) UILabel *consumptionLabel;
@property (nonatomic, strong) UILabel *consumptionTitle;
@property (nonatomic, strong) UIImageView *consumptionImage;
@property (nonatomic, strong) UIProgressView *consumptionProgress;


//@property (nonatomic, strong) UIImageView *cardScrollView; //原来的topImageVie
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, assign) NSInteger memberLevel;


@property (nonatomic, strong) NSMutableArray *containMember; //标记包含哪种会员

@property (nonatomic, strong) NSMutableArray *memberCards; // 存储用户的所有会员卡信息
@property (nonatomic, assign) NSInteger currentCardIndex; // 当前显示的卡片索引

@property (nonatomic, strong) UIScrollView *cardScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation EGMemberCardCell
+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"EGMemberCardCell";
    EGMemberCardCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
          cell = [[EGMemberCardCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//cell选中无色

    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithRed:0.962 green:0.962 blue:0.962 alpha:1.0];
    
    // 替换原来的 cardScrollView，改用 scrollView
    self.cardScrollView = [[UIScrollView alloc] init];
    self.cardScrollView.pagingEnabled = YES;
    self.cardScrollView.showsHorizontalScrollIndicator = NO;
    self.cardScrollView.delegate = self;
    [self.contentView addSubview:self.cardScrollView];
    UITapGestureRecognizer *tapTop = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTopImageTap)];
    [self.cardScrollView addGestureRecognizer:tapTop];
    
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.currentPageIndicatorTintColor =rgba(0, 122, 96, 1);
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.pageControl];
    
    [self.cardScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(20));
        make.centerX.mas_equalTo(0);
        make.left.mas_equalTo(ScaleW(30));
        make.right.mas_equalTo(ScaleW(-30));
        make.height.mas_equalTo(ScaleW(175));
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.cardScrollView);
        make.bottom.equalTo(self.cardScrollView).offset(ScaleW(20));
        make.height.mas_equalTo(ScaleW(10));
    }];
    
    // 在 setupUI 方法中，baseView 初始化后添加：
    self.baseView = [[UIView alloc] init];
    self.baseView.backgroundColor = [UIColor whiteColor];
    self.baseView.layer.cornerRadius = 10;
    self.baseView.layer.masksToBounds = YES;
    self.baseView.userInteractionEnabled = YES;  // 确保可以接收点击事件
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(baseViewTapped)];
    [self.baseView addGestureRecognizer:tap];
    [self.contentView addSubview:self.baseView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.numberOfLines = 1;
    self.nameLabel.textColor = rgba(23, 23, 23, 1);
    self.nameLabel.text =@"访客";
    self.nameLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightSemibold];
    [self.baseView addSubview:self.nameLabel];
    
    self.typeLabel = [[EGPaddingLabel alloc] init];
    self.typeLabel.textColor = rgba(0, 71, 56, 1);
    self.typeLabel.textAlignment= NSTextAlignmentCenter;
    self.typeLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightMedium];
    self.typeLabel.layer.cornerRadius = ScaleW(12);
    self.typeLabel.layer.backgroundColor = [UIColor colorWithRed:0.82 green:0.90 blue:0.98 alpha:1.0].CGColor;

    self.typeLabel.contentInsets = UIEdgeInsetsMake(0, ScaleW(5), 0, ScaleW(5));
    [self.baseView addSubview:self.typeLabel];
    
    self.durationLabel = [[UILabel alloc] init];
    self.durationLabel.textColor = rgba(163, 163, 163, 1);
    self.durationLabel.font = [UIFont systemFontOfSize:FontSize(14)];
    [self.baseView addSubview:self.durationLabel];
    
    self.consumptionTitle = [[UILabel alloc] init];
    self.consumptionTitle.text = NSLocalizedString(@"累積消費", nil);
    self.consumptionTitle.textColor = rgba(64, 64, 64, 1);
    self.consumptionTitle.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightMedium];
    [self.baseView addSubview:self.consumptionTitle];
    
    self.consumptionLabel = [[UILabel alloc] init];
    self.consumptionLabel.textColor = rgba(64, 64, 64, 1);
    self.consumptionLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightSemibold];
    [self.baseView addSubview:self.consumptionLabel];
    
    self.consumptionImage = [[UIImageView alloc] initWithImage:  [UIImage imageNamed: @"chevron-right"]];
    [self.consumptionImage setContentMode:UIViewContentModeScaleAspectFit];
    [self.baseView addSubview:self.consumptionImage];
    
    self.consumptionProgress = [UIProgressView new];
    self.consumptionProgress.trackTintColor = rgba(229, 229, 229, 1);
    self.consumptionProgress.progressTintColor = rgba(0, 122, 96, 1);
    self.consumptionProgress.progress = 0.2;
    //    [self.consumptionProgress setProgressViewStyle: UIProgressViewStyleBar];
    [self.baseView  addSubview:self.consumptionProgress];
    
    
    
    // ... 添加约束代码 ...
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_cardScrollView.mas_bottom).offset(ScaleW(30));
        make.centerX.mas_equalTo(0);
        make.left.mas_equalTo(ScaleW(0));
        make.right.mas_equalTo(ScaleW(-0));
        //        make.width.mas_equalTo(ScaleW(335));
        make.height.mas_equalTo(ScaleW(96)); //118
        make.bottom.mas_equalTo(0);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(16));
        make.left.mas_equalTo(ScaleW(20));
        make.right.mas_equalTo(self.baseView.mas_centerX).offset(-ScaleW(15));
        //        make.width.mas_equalTo(ScaleW(335));
//        make.height.mas_equalTo(ScaleW(24));
    }];
    
    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.nameLabel);
        make.top.mas_equalTo(ScaleW(16));
        make.right.mas_equalTo(-ScaleW(20));
        make.height.mas_equalTo(ScaleW(16));
//        make.width.mas_equalTo(ScaleW(56));
    }];
    
    // 添加左右内边距
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.durationLabel);
        make.right.mas_equalTo(self.durationLabel.mas_left).offset(-8);
        make.height.mas_equalTo(ScaleW(24));
//        make.width.mas_equalTo(ScaleW(62));
    }];
    
    [self.consumptionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(60));
        make.left.mas_equalTo(ScaleW(20));
        make.height.mas_equalTo(ScaleW(16));
        
    }];
    
    [self.consumptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.consumptionTitle);
        make.right.mas_equalTo(-ScaleW(44));
        make.height.mas_equalTo(ScaleW(24));
        //        make.width.mas_equalTo(ScaleW(64));
    }];
    
    [self.consumptionImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.consumptionTitle);
        make.right.mas_equalTo(-ScaleW(20));
        make.height.mas_equalTo(ScaleW(20));
        make.width.mas_equalTo(ScaleW(20));
    }];
    
    [self.consumptionProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleW(96));
        make.right.mas_equalTo(-ScaleW(20));
        make.left.mas_equalTo(ScaleW(20));
        make.height.mas_equalTo(ScaleW(0));
        make.bottom.mas_equalTo(-ScaleW(0));
    }];
    [self.consumptionProgress setHidden:YES];
    
    // 添加条形码按钮
    UIButton *barcodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [barcodeButton setImage:[UIImage imageNamed:@"barcode_icon"] forState:UIControlStateNormal];
    barcodeButton.backgroundColor = rgba(0.09, 0.09, 0.09, 0.5);
    //  barcodeButton.layer.shadowColor = [UIColor blackColor].CGColor;
    barcodeButton.layer.cornerRadius = ScaleW(25);
    //    barcodeButton.layer.shadowOffset = CGSizeMake(0, 2);
    //    barcodeButton.layer.shadowOpacity = 0.2;
    barcodeButton.userInteractionEnabled = YES;  // 确保按钮可以交互
    
    [barcodeButton addTarget:self action:@selector(barcodeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:barcodeButton];
    self.barcodeButton = barcodeButton;
    [barcodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.cardScrollView);
        make.width.height.mas_equalTo(ScaleW(50));
    }];
    
}

- (void)setupWithInfo:(NSDictionary *)info {
    
    // 清除旧的卡片视图
    for (UIView *view in self.cardScrollView.subviews) {
        [view removeFromSuperview];
    }
    NSArray *array = [info valueForKey:@"type"];
    NSMutableArray *memberCards;
    if (array && [array isKindOfClass:[NSArray class]]) {
        memberCards = [NSMutableArray arrayWithArray: array];
    }

// = [NSMutableArray arrayWithArray: array];
    CGFloat scrollWidth = self.cardScrollView.frame.size.width;
    CGFloat scrollHeight = self.cardScrollView.frame.size.height;
    
    if (memberCards && [memberCards isKindOfClass:[NSArray class]] && memberCards.count > 0) {
//        [memberCards removeObjectAtIndex:0];
//        [memberCards removeObjectAtIndex:0];
//        [memberCards removeObjectAtIndex:0];
//        [memberCards removeObjectAtIndex:0];
        NSMutableArray *cardInfos = [NSMutableArray array];
        
        // 收集所有卡片信息
        for (NSDictionary *dict in memberCards) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                NSString *memberTypeId = [dict objectOrNilForKey:@"MemberTypeId"];
                NSDictionary *cardInfo = [self getCardInfoForMemberType:memberTypeId];
                if (cardInfo) {
                    [cardInfos addObject:cardInfo];
                }
            }
        }
        
        if (cardInfos.count > 0) {
            // 按等级排序
            [cardInfos sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
                return [obj2[@"level"] compare:obj1[@"level"]];
            }];
            
            // 创建卡片视图
            [cardInfos enumerateObjectsUsingBlock:^(NSDictionary *cardInfo, NSUInteger idx, BOOL *stop) {
                UIImageView *cardView = [[UIImageView alloc] init];
                cardView.contentMode = UIViewContentModeScaleAspectFill;
                cardView.clipsToBounds = YES;
                cardView.layer.cornerRadius = ScaleW(8);
                cardView.image = [UIImage imageNamed:cardInfo[@"image"]];
                [self.cardScrollView addSubview:cardView];
                
                [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(self.cardScrollView);
                    make.width.equalTo(@(scrollWidth));
                    make.height.equalTo(@(scrollHeight));
                    make.left.equalTo(self.cardScrollView).offset(idx * scrollWidth);
                }];
            }];
            
            // 设置 scrollView 内容大小和页面控制器
            self.cardScrollView.contentSize = CGSizeMake(scrollWidth * cardInfos.count, scrollHeight);
            self.pageControl.numberOfPages = cardInfos.count;
            self.pageControl.currentPage = self.currentCardIndex;
            self.memberCards = cardInfos;
            
            // 确保显示第一页
//            [self.cardScrollView setContentOffset:CGPointZero animated:NO];
            
            // 更新其他 UI
            //ELog(@"currentCardIndex:%ld",self.currentCardIndex);
            if (self.currentCardIndex >= cardInfos.count) {
                self.currentCardIndex = 0;
            }
            self.cardScrollView.contentOffset = CGPointMake(scrollWidth * self.currentCardIndex, 0);
            NSDictionary *firstCard = cardInfos[self.currentCardIndex];
            self.typeLabel.text = firstCard[@"label"];
            [self.typeLabel setHidden:NO];
            self.memberLevel = [firstCard[@"level"] integerValue];
            self.durationLabel.text = @"一年期限";
            self.pageControl.hidden = NO;
        } else {
            [self setupDefaultMemberUI];
        }
        self.nameLabel.text = info[@"name"];
    } else {
        if ([EGLoginUserManager isLogIn]) {
            self.nameLabel.text = info[@"name"];
            [self setupDefaultMemberUI];
        }else{
            [self setupGuestUI];
        }
    }
    self.consumptionLabel.text = [NSString stringWithFormat:@"NT $%@", info[@"consumption"]];
}


// 添加访客状态UI设置方法
- (void)setupGuestUI {
    self.cardScrollView.contentSize = CGSizeMake(self.cardScrollView.frame.size.width, self.cardScrollView.frame.size.height);
       self.pageControl.hidden = YES;
       
       UIImageView *cardView = [[UIImageView alloc] init];
       cardView.contentMode = UIViewContentModeScaleAspectFit;
       cardView.clipsToBounds = YES;
       cardView.layer.cornerRadius = ScaleW(8);
       cardView.image = [UIImage imageNamed:@"jiaru"];
       [self.cardScrollView addSubview:cardView];
       
       [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.size.equalTo(self.cardScrollView);
           make.center.equalTo(self.cardScrollView);
       }];
       
       self.durationLabel.text = @"";
       self.memberLevel = 0;
       [self.typeLabel setHidden:YES];
       self.nameLabel.text = @"訪客";
}

// 添加一般会员UI设置方法
- (void)setupDefaultMemberUI {
    UIImageView *defaultCard = [[UIImageView alloc] init];
    defaultCard.contentMode = UIViewContentModeScaleAspectFill;
    defaultCard.clipsToBounds = YES;
    defaultCard.layer.cornerRadius = ScaleW(8);
    defaultCard.image = [UIImage imageNamed:@"jiaru"];
    [self.cardScrollView addSubview:defaultCard];
    
    
    [defaultCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.cardScrollView);
        make.center.equalTo(self.cardScrollView);
    }];
    
//    self.cardScrollView.contentSize = CGSizeMake(self.cardScrollView.frame.size.width, self.cardScrollView.frame.size.height);
//    self.pageControl.numberOfPages = 1;
//    self.pageControl.currentPage = 0;
    self.pageControl.hidden = YES;
    self.durationLabel.text = @"";
    self.memberLevel = 1;
    if ([self.nameLabel.text isEqualToString:@"訪客"]) {
        self.typeLabel.text = @"";
        [self.typeLabel setHidden:true];
    }else{
        self.typeLabel.text = @"一般會員";
        [self.typeLabel setHidden:NO];
    }
    
}

//- (void)updateUIWithCardIndex:(NSInteger)index {
//    if (index < 0 || index >= self.memberCards.count) return;
//    
//    NSDictionary *card = self.memberCards[index];
//    self.currentCardIndex = index;
//    self.memberLevel = [card[@"level"] integerValue];
//    
//    self.cardScrollView.image = [UIImage imageNamed:card[@"image"]];
//    self.typeLabel.text = card[@"label"];
//    [self.typeLabel setHidden:NO];
//    
//    if ([card[@"level"] integerValue] == 1) {
//        self.durationLabel.text = @"";
//    } else {
//        self.durationLabel.text =@"一年期限";
//    }
//}


// 新增辅助方法 會員
- (NSDictionary *)getCardInfoForMemberType:(NSString *)typeId {
    NSDictionary *cardInfoMap = @{
        @"A001": @{
            @"image": @"RoyalCard",
            @"label": @"鷹國皇家",
            @"level": @5
        },
        @"A002": @{
            @"image": @"HonorCard",
            @"label": @"鷹國尊爵",
            @"level": @4
        },
        @"A003": @{
            @"image": @"FamilyCard2",
            @"label": @"Takao 親子",
            @"level": @3
        },
        @"A004": @{
            @"image": @"PeopleCard",
            @"label": @"鷹國人",
            @"level": @2
        }
    };
    return cardInfoMap[typeId];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = currentPage;
    self.currentCardIndex = currentPage;
    // 更新会员类型标签
    if (self.memberCards && currentPage < self.memberCards.count) {
        NSDictionary *currentCard = self.memberCards[currentPage];
        self.typeLabel.text = currentCard[@"label"];
        self.memberLevel = [currentCard[@"level"] integerValue];
    }
}


//MARK: -- 添加点击事件处理方法
- (void)barcodeButtonTapped {
    if (self.showBarcodeBlock) {
        self.showBarcodeBlock();
    }
}


- (void)baseViewTapped {
    if ([self.delegate respondsToSelector:@selector(didTapConsumptionRecord)]) {
        [self.delegate didTapConsumptionRecord];
    }
}

- (void)handleTopImageTap {
    if (self.memberLevel == 1 || self.memberLevel == 0) {
        if ([self.delegate respondsToSelector:@selector(didTapMembershipCard)]) {
            [self.delegate didTapMembershipCard];
        }
    }
}


@end
