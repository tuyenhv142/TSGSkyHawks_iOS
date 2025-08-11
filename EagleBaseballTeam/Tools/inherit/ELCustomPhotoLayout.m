//
//  ELCustomPhotoLayout.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/6/16.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "ELCustomPhotoLayout.h"

@interface ELCustomPhotoLayout()
@property (nonatomic, strong) NSMutableArray *layoutAttributes;
@property (nonatomic, assign) CGFloat contentHeight;
@end

@implementation ELCustomPhotoLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    self.layoutAttributes = [NSMutableArray array];
    self.contentHeight = 0;
    
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    CGFloat width = self.collectionView.bounds.size.width;
    
    // 设置第一个大图的布局
    if (itemCount > 0) {
        UICollectionViewLayoutAttributes *firstAttr = [UICollectionViewLayoutAttributes
            layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        
        // 第一张图片占据2/3宽度和相应高度
        CGFloat bigItemWidth = (width - self.itemSpacing) * 2/3;
        firstAttr.frame = CGRectMake(0, 0, bigItemWidth, bigItemWidth);
        [self.layoutAttributes addObject:firstAttr];
        
        // 计算小图的尺寸
        CGFloat smallItemWidth = (width - bigItemWidth - self.itemSpacing * 2) / 1;
        CGFloat currentY = 0;
        
        // 布局右侧的小图
        for (NSInteger i = 1; i < MIN(itemCount, 3); i++) {
            UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes
                layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            
            CGFloat x = bigItemWidth + self.itemSpacing;
            CGFloat y = currentY;
            
            attr.frame = CGRectMake(x, y, smallItemWidth, smallItemWidth);
            [self.layoutAttributes addObject:attr];
            
            currentY += smallItemWidth + self.lineSpacing;
        }
        
        // 布局剩余的图片
        CGFloat normalItemWidth = (width - self.itemSpacing * 2) / 3;
        NSInteger currentRow = 1;
        NSInteger itemsInCurrentRow = 0;
        
        for (NSInteger i = 3; i < itemCount; i++) {
            UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes
                layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            
            CGFloat x = (normalItemWidth + self.itemSpacing) * itemsInCurrentRow;
            CGFloat y = bigItemWidth + self.lineSpacing +
                       (currentRow - 1) * (normalItemWidth + self.lineSpacing);
            
            attr.frame = CGRectMake(x, y, normalItemWidth, normalItemWidth);
            [self.layoutAttributes addObject:attr];
            
            itemsInCurrentRow++;
            if (itemsInCurrentRow == 3) {
                itemsInCurrentRow = 0;
                currentRow++;
            }
        }
        
        // 更新内容高度
        self.contentHeight = MAX(bigItemWidth, currentY);
        if (itemCount > 3) {
            self.contentHeight = bigItemWidth + self.lineSpacing +
                               currentRow * (normalItemWidth + self.lineSpacing);
        }
    }
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.bounds.size.width, self.contentHeight);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.layoutAttributes[indexPath.item];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
