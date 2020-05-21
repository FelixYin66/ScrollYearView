//
//  ScrollYearRuleView.m
//  ScrollYearViewDemo
//
//  Created by Felix Yin on 2020/5/18.
//  Copyright © 2020 Felix Yin. All rights reserved.
//

#import "ScrollYearRuleView.h"
#import "UIView+Add.h"
#import "CALayer+Add.h"
#import "ScrollYearRuleCollectionViewLayout.h"
#import "ScrollYearCollectionViewCell.h"

@interface ScrollYearRuleView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) ScrollYearRuleCollectionViewLayout *collectionViewLayout;
@property(nonatomic,strong) NSMutableArray *indexArray;
@property(nonatomic,strong) CALayer *indicatorLayer;
@property(nonatomic,assign) NSInteger selectIndex;

@end

@implementation ScrollYearRuleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
        [self.layer addSublayer:self.indicatorLayer];
    }
    return self;
}

//设置选中Cell
- (void)selectCell {
    NSInteger indexOfCell = self.selectIndex;
    ScrollYearCollectionViewCell *cell = (ScrollYearCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:indexOfCell inSection:0]];
    [cell makeCellSelected];
}

//    MARK: Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.y + _collectionView.contentInset.top;
//    NSLog(@"=== %f",offset);
    NSInteger index = roundl(offset / (_config.scaleWeigth + _config.scaleSpace));
    NSInteger c = index%_config.perScaleCount;
    if (c > 0) {
        if (c < _config.perScaleCount*0.5) {
            index = index - c;
        }else{
            index = (index - c) + _config.perScaleCount;
        }
    }
    self.selectIndex = index;
//    NSLog(@"222");
}

- (void) updateCells{
    NSArray *array = [self.collectionView.indexPathsForVisibleItems sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath  *obj1, NSIndexPath *obj2) {
        if (obj1.item > obj2.item) {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];
    
    if (array.count > 0) {
        NSInteger count = array.count%2;
        NSInteger location = 0;
        if (count == 0) {
            location = array.count/2;
        }else{
            location = array.count/2 + 1;
        }
        NSInteger length = self.config.perScaleCount*2 - 1;
        NSArray *midleArray = [array subarrayWithRange:NSMakeRange(location, length)];
        [midleArray enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger showIndex = (obj.item/self.config.perScaleCount + self.config.min);
            NSLog(@"circle == %@",@(showIndex));
//            ScrollYearCollectionViewCell *cell = (ScrollYearCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:obj];
//            [cell updateCircleIndicator:idx];
        }];
        
        NSArray *startArray = [array subarrayWithRange:NSMakeRange(0, location)];
        [startArray enumerateObjectsUsingBlock:^(NSIndexPath   *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger showIndex = (obj.item/self.config.perScaleCount + self.config.min);
            NSLog(@"normal == %@",@(showIndex));
//            ScrollYearCollectionViewCell *cell = (ScrollYearCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:obj];
//            [cell updateNormalIndicator:idx];
        }];
        
        NSArray *endArray = [array subarrayWithRange:NSMakeRange(length, array.count-midleArray.count-startArray.count)];
        [endArray enumerateObjectsUsingBlock:^(NSIndexPath   *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger showIndex = (obj.item/self.config.perScaleCount + self.config.min);
            NSLog(@"normal == %@",@(showIndex));
//            ScrollYearCollectionViewCell *cell = (ScrollYearCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:obj];
//            [cell updateNormalIndicator:idx];
        }];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {
        [self scrollViewToCenter];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        BOOL dragToDragStop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
        if (dragToDragStop) {
         [self scrollViewToCenter];
        }else{
            CGFloat maxOffset = _collectionViewLayout.actualLength * (_config.scaleWeigth + _config.scaleSpace);
            CGFloat offset = scrollView.contentOffset.y + _collectionView.contentInset.top;
            if (offset >= maxOffset) {
             [self scrollViewToCenter];
            }
        }
    }
}

- (void) scrollViewToCenter{
    NSInteger indexOfLocation = self.selectIndex;
    ScrollYearCollectionViewCell *selectedCell = (ScrollYearCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:indexOfLocation inSection:0]];
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:indexOfLocation inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    [_collectionView.visibleCells enumerateObjectsUsingBlock:^(__kindof ScrollYearCollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj != selectedCell) {
            [obj makeCellUnSelected];
        }
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self selectCell];
    });
}

//    MARK: DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.indexArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ScrollYearCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSInteger index = [self.indexArray[indexPath.row] integerValue];
    cell.index = index;
    cell.config = self.config;
    cell.collectionView = self.collectionView;
    [cell setNeedsLayout];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
//    [self updateCells];
}

//    MARK: InitialData

- (void)initialData {
    if (self.config.max == 0 || self.config.min >= self.config.max) {
        return;
    } else {
        [self.indexArray removeAllObjects];
        NSInteger items = self.config.max - self.config.min;
        NSInteger totalCount = 0;
        NSInteger perScaleCount = self.config.perScaleCount;
        if (perScaleCount > 0) {
            //如果是一位小数类型，则数据扩大perScaleCount倍
            totalCount = items * perScaleCount + 1;
        } else {
            totalCount = items + 1;
        }
        
        self.collectionViewLayout.actualLength = totalCount;
        for (NSInteger i=0; i<totalCount; i++) {
            [self.indexArray addObject:@(i%totalCount)];
        }
        //默认没有指定选中值时
        CGFloat offY = - (self.config.scaleWeigth*0.5 + self.collectionView.contentInset.top);
        self.collectionView.contentOffset = CGPointMake(0, offY);
    }
}


//    MARK: Lazy Loading

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.collectionViewLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
//        CGFloat top = self.height*0.5 + self.config.scaleWeigth*0.5;
//        CGFloat bottom = self.height*0.5 + self.config.scaleWeigth*0.5;
        CGFloat top = self.height*0.5;
        CGFloat bottom = self.height*0.5;
        UIEdgeInsets inset = UIEdgeInsetsMake(top,0,bottom,0);
        _collectionView.contentInset = inset;
        [_collectionView registerClass:[ScrollYearCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [self initialData];
    }
    return _collectionView;
}

- (CALayer *)indicatorLayer{
    if (!_indicatorLayer) {
        _indicatorLayer = [[CALayer alloc] init];
        _indicatorLayer.backgroundColor = [UIColor redColor].CGColor;
        _indicatorLayer.height = 2;
        _indicatorLayer.width = self.width;
        _indicatorLayer.centerY = self.height*0.5;
        _indicatorLayer.left = 0;
    }
    return _indicatorLayer;
}

- (ScrollYearRuleCollectionViewLayout *)collectionViewLayout{
    if (!_collectionViewLayout) {
        _collectionViewLayout = [[ScrollYearRuleCollectionViewLayout alloc] init];
        _collectionViewLayout.config = self.config;
        _collectionViewLayout.itemSize = CGSizeMake(self.width, _config.scaleWeigth);
    }
    return _collectionViewLayout;
}

- (ScrollYearRuleViewConfig *)config{
    if (!_config) {
        _config = [[ScrollYearRuleViewConfig alloc] init];
    }
    return _config;
}

- (NSMutableArray *)indexArray{
    if (!_indexArray) {
        _indexArray = [[NSMutableArray alloc] init];
    }
    return _indexArray;
}

@end
