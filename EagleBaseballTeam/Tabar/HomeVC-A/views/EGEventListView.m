//
//  EGEventListView.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/2/5.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGEventListView.h"

#import "EGListCollectionViewCell.h"
#import "EGScheduleModel.h"

@interface  EGEventListView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *mainCollectionView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) NSMutableArray *dataMArray;
@property (nonatomic,strong) NSArray *teamCodeArr;

@end

@implementation EGEventListView

- (NSMutableArray *)dataMArray
{
    if (!_dataMArray) {
        _dataMArray = [NSMutableArray arrayWithObjects:@[],@[],@[],@[],@[], nil];
    }
    return _dataMArray;
}

- (UILabel *)titleLb
{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.textAlignment = NSTextAlignmentLeft;
        _titleLb.text = @"近期賽事";
        _titleLb.textColor = rgba(38, 38, 38, 1);
        _titleLb.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightSemibold];
        [self addSubview:_titleLb];
    }
    return _titleLb;
}

- (UICollectionView *)mainCollectionView
{
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _mainCollectionView.backgroundColor = [UIColor clearColor];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        [_mainCollectionView registerClass:[EGListCollectionViewCell class] forCellWithReuseIdentifier:@"EGListCollectionViewCell"];
        [self addSubview:_mainCollectionView];
    }
    return _mainCollectionView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleW(24));
            make.left.mas_equalTo(ScaleW(20));
            make.right.mas_equalTo(-ScaleW(20));
        }];
        
        [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ScaleW(64));
            make.left.mas_equalTo(ScaleW(20));
            make.right.mas_equalTo(-ScaleW(20));
            make.height.mas_equalTo(ScaleW(224));
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
    return CGSizeMake(ScaleW(292), ScaleW(224));
}
- (CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) { // 假设我们想要为第一个分区设置不同的间距
        return 10.0; // 设置间距为10.0
    } else {
        return 0; // 对于其他分区使用默认值或父类的实现
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EGListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EGListCollectionViewCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = UIColor.whiteColor;
    [cell setDataArray:self.dataMArray[indexPath.item]];
    [cell setTeamCode:self.teamCodeArr[indexPath.item]];
    return cell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.teamCodeArr.count;
}

- (void)setDatas:(NSArray *)datas
{
    _datas = datas;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSArray *akpArray = [datas filteredArrayUsingPredicate:
        [NSPredicate predicateWithBlock:^BOOL(EGScheduleModel *dateModel, NSDictionary *bindings) {
        NSString *dateTime = dateModel.GameDateTimeS;
        NSString *dateTime1 = [dateTime stringByReplacingCharactersInRange:NSMakeRange(11,2) withString:@"23"];
        NSDate *itemDate = [formatter dateFromString:dateTime1];
        return [itemDate compare:[NSDate date]] != NSOrderedAscending;
    }]];
    
//    NSMutableArray *teamCodeArr = [NSMutableArray arrayWithCapacity:0];
//    NSInteger total = akpArray.count;
//    if (total > 9) {
//        total = 10;
//    }
//    for (int idx = 0; idx < total; idx++) {
//        EGScheduleModel *model = akpArray[idx];
//        
////    for (EGScheduleModel *model in akpArray) {
////        if (teamCodeArr.count >= 5) {
////            break;
////        }
//        
//        if ([model.HomeTeamName isEqualToString:@"台鋼天鷹"] ) {
//            if (![teamCodeArr containsObject:model.VisitingTeamName]) {
//                [teamCodeArr addObject:model.VisitingTeamName];
//            }
//        }else{
//            if (![teamCodeArr containsObject:model.HomeTeamName]) {
//                [teamCodeArr addObject:model.VisitingTeamName];
//            }
//        }
//    }
    NSMutableArray *teamCodeArr = [NSMutableArray array];
    NSInteger total = MIN(akpArray.count, 10);
    for (int idx = 0; idx < total; idx++) {
        EGScheduleModel *model = akpArray[idx];
        NSString *teamName = [model.HomeTeamName isEqualToString:@"台鋼天鷹"] ? model.VisitingTeamName : model.HomeTeamName;
        if (![teamCodeArr containsObject:teamName]) {
            [teamCodeArr addObject:teamName];
        }
    }
    
    if (teamCodeArr.count > 0) {
//        self.teamCodeArr = teamCodeArr;
        self.teamCodeArr = [teamCodeArr subarrayWithRange:NSMakeRange(0, MIN(3, teamCodeArr.count))];
    }else{
//        self.teamCodeArr = @[@"AJL011",@"AAA011",@"ADD011",@"ACN011",@"AEO011"];
        self.teamCodeArr = @[@"臺中連莊",@"桃園雲豹",@"臺北伊斯特"];
    }
    NSArray *teamCodes = teamCodeArr;
    ELog(@"%@", teamCodes)
    
//    [self.dataMArray removeAllObjects];
//    for (NSString *teamCode in teamCodes) {
//        NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:0];
//        for (EGScheduleModel *model in akpArray) {
//            if ([model.HomeTeamCode isEqualToString:teamCode] || [model.VisitingTeamCode isEqualToString:teamCode]) {
//                if (arrayM.count >= 2) {
//                    break;
//                }
//                [arrayM addObject:model];
//            }
//        }
//        [self.dataMArray addObject:arrayM];
//    }
    
    self.dataMArray = [NSMutableArray array];
        for (int i = 0; i < self.teamCodeArr.count; i++) {
            [self.dataMArray addObject:[NSMutableArray array]];
        }

        // Phân loại trận đấu vào dataMArray
    for (EGScheduleModel *model in akpArray) {
        for (int j = 0; j < self.teamCodeArr.count; j++) {
            NSString *teamCode = self.teamCodeArr[j];
            if ([model.HomeTeamName isEqualToString:teamCode] || [model.VisitingTeamName isEqualToString:teamCode]) {
                NSMutableArray *arr = self.dataMArray[j];
                [arr addObject:model];
                break;
            }
        }
    }
    
//    [self.dataMArray removeAllObjects];
//    [self.dataMArray addObjectsFromArray:@[@[],@[],@[],@[],@[]]];
//    NSInteger xount = akpArray.count;
//    if (xount > 9) {
//        xount = 10;
//    }
//    for (int idx = 0; idx < xount; idx++) {
//        EGScheduleModel *model = akpArray[idx];
//        NSInteger index = 0;
//        for (int j = 0; j < teamCodes.count; j++) {
//            NSString *teamCode = teamCodes[j];
//            if ([model.HomeTeamName isEqualToString:teamCode] || [model.VisitingTeamName isEqualToString:teamCode]) {
//                index = j;
//            }
//        }
//        NSMutableArray *arrayMqqq = [NSMutableArray arrayWithArray:self.dataMArray[index]];
//        [arrayMqqq addObject:model];
//        [self.dataMArray replaceObjectAtIndex:index withObject:arrayMqqq];
//    }
    
    [self.mainCollectionView reloadData];
}


@end
