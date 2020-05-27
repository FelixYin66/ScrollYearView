//
//  ScrollYearRuleCollectionViewLayout.m
//  ScrollYearViewDemo
//
//  Created by Felix Yin on 2020/5/18.
//  Copyright © 2020 Felix Yin. All rights reserved.
//

#import "ScrollYearRuleCollectionViewLayout.h"
#import "UIView+FYAdd.h"
#import "ScrollYearRuleViewConfig.h"

@implementation ScrollYearRuleCollectionViewLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake(360, 40);
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return self;
}

//计算内容大小
- (CGSize)collectionViewContentSize{
    CGSize size = CGSizeZero;
    CGFloat count = [self.collectionView numberOfItemsInSection:0];
    CGFloat width = self.collectionView.width;
    CGFloat height = count*self.itemSize.height+count*self.config.scaleSpace;
    size = CGSizeMake(width, height);
    return size;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat x = 0;
    CGFloat y = indexPath.item*(self.itemSize.height+self.config.scaleSpace);
    attribute.frame = CGRectMake(x, y, self.itemSize.width, self.itemSize.height);
    return attribute;
}


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return [self attributesInRect:rect];
}


- (NSArray *)attributesInRect:(CGRect)rect {
    CGFloat scaleWidth = 0;
    NSInteger scrollLoop = 0;
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        scaleWidth = self.itemSize.width;
        CGFloat oneRoundOffset = (scaleWidth + self.config.scaleSpace) * self.actualLength + ((scaleWidth + self.self.config.scaleSpace) * 4 + scaleWidth/2.0);
        scrollLoop = rect.origin.x / oneRoundOffset;
    } else {
        scaleWidth = self.itemSize.height;
        CGFloat oneRoundOffset = (scaleWidth + self.config.scaleSpace) * self.actualLength + ((scaleWidth + self.self.config.scaleSpace) * 4 + scaleWidth/2.0);
        scrollLoop = rect.origin.y / oneRoundOffset;
    }
    CGFloat extra = scrollLoop * ((scaleWidth + self.self.config.scaleSpace) * 4  + scaleWidth/2.0);
    
    NSInteger preIndex = (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) ?
    ((rect.origin.x-extra)/(self.itemSize.width+self.self.config.scaleSpace)) :
    ((rect.origin.y-extra)/(self.itemSize.height+self.self.config.scaleSpace));
    preIndex = ((preIndex < 0) ? 0 : preIndex);                         //防止下标越界
    
    //指定范围内的最后一个cell下标
    NSInteger latIndex = (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) ?
    ((CGRectGetMaxX(rect)-extra)/(self.itemSize.width+self.config.scaleSpace)) :
    ((CGRectGetMaxY(rect)-extra)/(self.itemSize.height+self.config.scaleSpace));
    
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    latIndex = ((latIndex >= itemCount) ? itemCount-1 : latIndex);      //防止下标越界
    
    NSMutableArray *rectAttributes = [NSMutableArray array];
    //将对应下标的attribute存入数组中
    for (NSInteger i=preIndex; i<=latIndex; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:indexPath];
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [rectAttributes addObject:attribute];
        }
    }
    return rectAttributes;
}

@end
