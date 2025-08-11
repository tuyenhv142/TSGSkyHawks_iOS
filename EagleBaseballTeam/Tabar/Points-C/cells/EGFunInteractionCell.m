//
//  EGFunInteractionCell.m
//  EagleBaseballTeam
//
//  Created by Elvin on 2025/6/24.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGFunInteractionCell.h"

#import "EGTaskCollectionViewCell.h"

@interface EGFunInteractionCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *interactionCollectionView;

@property (nonatomic, strong) NSArray *datas;
;
@end

@implementation EGFunInteractionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellWithUITableView:(UITableView *)tableView{
    
    static NSString *ID = @"EGFunInteractionCell";
    EGFunInteractionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[EGFunInteractionCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];//class
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//cell选中无色
    //  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//箭头
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = rgba(243, 243, 243, 1);
        UILabel *titleLb = [UILabel new];
        titleLb.text = @"趣味互動";
        titleLb.textColor = rgba(38, 38, 38, 1);
        titleLb.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightMedium];
        [self.contentView addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleW(30));
            make.left.mas_equalTo(ScaleW(20));
            make.height.mas_equalTo(ScaleW(24));
        }];
        
        UICollectionViewFlowLayout *limitedLayout = [[UICollectionViewFlowLayout alloc] init];
        limitedLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        limitedLayout.itemSize = CGSizeMake(ScaleW(219), ScaleW(223));
//        limitedLayout.minimumLineSpacing = ScaleW(12);
//        limitedLayout.sectionInset =  UIEdgeInsetsMake(0, 0, 0, 0);
        
        // 限時任務 Collection View
        self.interactionCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:limitedLayout];
        self.interactionCollectionView.delegate = self;
        self.interactionCollectionView.dataSource = self;
        self.interactionCollectionView.backgroundColor = [UIColor clearColor];
        self.interactionCollectionView.showsHorizontalScrollIndicator = NO;
        [self.interactionCollectionView registerClass:[EGTaskCollectionViewCell class] forCellWithReuseIdentifier:@"TaskCell"];
        [self.contentView addSubview:self.interactionCollectionView];
        [self.interactionCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLb.mas_bottom).offset(ScaleW(20));
            make.right.mas_equalTo(-ScaleW(15));
            make.left.mas_equalTo(ScaleW(15));
            make.height.mas_equalTo(ScaleW(223));
            make.bottom.mas_equalTo(0);
        }];
        
    }
    return self;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0,ScaleW(0),ScaleW(0),ScaleW(0));
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return ScaleW(16);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return ScaleW(10);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(ScaleW(219), ScaleW(223));
}
- (CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) { // 假设我们想要为第一个分区设置不同的间距
        return 10.0; // 设置间距为10.0
    } else {
        return 0; // 对于其他分区使用默认值或父类的实现
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.clickItemBlock) {
        self.clickItemBlock(@"");
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EGTaskCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TaskCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = UIColor.whiteColor;
    return cell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;//self.datas.count;
}

@end
