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
//        [self.layer addSublayer:[self drawLine]];
//        [self.layer addSublayer:self.indicatorLayer];
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
    
    //绘制弧线 由于效果不佳，暂且不用
//    [self circle];
}


- (void) circle{
    dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:CGPointMake(0, self.collectionView.height*0.5+self.collectionView.contentOffset.y)];
            if (indexPath!=nil) {
                NSInteger middle = indexPath.item;
                NSInteger min = middle - self.config.perScaleCount;
                NSInteger max = middle + self.config.perScaleCount;
                NSInteger total = [self.collectionView numberOfItemsInSection:0];
                NSArray *cells = self.collectionView.visibleCells;
                ScrollYearCollectionViewCell *cell = (ScrollYearCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                [cell updateCircleIndicator:self.config.perScaleCount];
                NSMutableArray *minusArray = [[NSMutableArray alloc] initWithCapacity:cells.count];
                [minusArray addObject:cell];
                
                if (min >= 0) {
                    int count = 0;
                    for (NSInteger i = min; i < middle ; i++) {
                        NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
                        ScrollYearCollectionViewCell *cel = (ScrollYearCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:index];
                           [cel updateCircleIndicator:count];
                        [minusArray addObject:cel];
                        count++;
                    }
//                    NSLog(@"min == %@",@(minusArray.count));
                }
                
                if (total >= max) {
                    int count = 0;
                    for (NSInteger i = max; i >= middle ; i--) {
                        NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
                        ScrollYearCollectionViewCell *cel = (ScrollYearCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:index];
                           [cel updateCircleIndicator:count];
                        [minusArray addObject:cel];
                        count++;
                    }
//                    NSLog(@"max == %@",@(count));
                }
                
                NSPredicate *preDicate = [NSPredicate predicateWithFormat:@"NOT SELF IN %@",minusArray];
                NSArray *fArray = [cells filteredArrayUsingPredicate:preDicate];
                [fArray enumerateObjectsUsingBlock:^(ScrollYearCollectionViewCell *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj updateNormalIndicator];
                }];
            }
    });
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
//    return self.indexArray.count;
    return self.collectionViewLayout.actualLength;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ScrollYearCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSInteger index = [self.indexArray[indexPath.row] integerValue];
    cell.index = index;
    cell.item = indexPath.item;
    cell.config = self.config;
    cell.collectionView = self.collectionView;
    [cell setNeedsLayout];
    return cell;
}

//    MARK: InitialData

- (void)initialData {
    if (self.config.max == 0 || self.config.min >= self.config.max) {
        return;
    } else {
        [self.indexArray removeAllObjects];
        NSInteger items = self.config.max - self.config.min;
        NSInteger perSectionTotalCount = 0;
        NSInteger perScaleCount = self.config.perScaleCount;
        //重复5组数据
        NSInteger section = self.config.sectionCount;
        if (section > 0) {
            //如果是一位小数类型，则数据扩大perScaleCount倍
            perSectionTotalCount = items * perScaleCount + 1;
        } else {
            perSectionTotalCount = items + 1;
        }
        
        NSInteger totalCount = section*perSectionTotalCount;
        self.collectionViewLayout.actualLength = totalCount;
        self.config.perSectionTotalCount = perSectionTotalCount;
        
        NSInteger lastIndex = 0;
        for (NSInteger i=0; i<totalCount; i++) {
            lastIndex++;
            NSInteger index = i%perSectionTotalCount;
            NSInteger sectionIndex = i/perSectionTotalCount;
            
//            if (sectionIndex > 0 && sectionIndex != section && index == 0) {
//                continue;
//            }else{
//                [self.indexArray addObject:@(index)];
////                if (section > 0 && index==perSectionTotalCount-1) {
////                    [self.indexArray addObject:@(index+1)];
////                }
//            }
            
//            if (sectionIndex > 0 && sectionIndex != section-1) {
//
//            }else{
//                [self.indexArray addObject:@(index)];
//            }
            
            [self.indexArray addObject:@(index)];
        }
        
//        for (NSInteger i = lastIndex; i < (self.config.perScaleCount+lastIndex); i++) {
//            NSInteger index = i%perSectionTotalCount;
//            [self.indexArray addObject:@(index)];
//        }
        
        //默认没有指定选中值时
        CGFloat offY = - (self.config.scaleWeigth*0.5 + self.collectionView.contentInset.top);
        self.collectionView.contentOffset = CGPointMake(0, offY);
    }
}

- (CALayer *) drawLine{
    
    CGColorRef color = self.config.scaleColor.CGColor;
    CGFloat cornerRadius = self.config.cornerRadius;
    CGFloat lineWidth = self.config.circleLineWeight;
    CGFloat height = self.height;
    CGFloat lineH = (height - cornerRadius*2 - lineWidth*2)*0.5;
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.lineWidth = lineWidth;
    lineLayer.strokeColor = color;
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    lineLayer.left = self.width*0.5;
    lineLayer.width = cornerRadius;
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(0, lineH)];
    [path addQuadCurveToPoint:CGPointMake(0, lineH+cornerRadius*2) controlPoint:CGPointMake(-cornerRadius, height*0.5)];
    [path addLineToPoint:CGPointMake(0, self.height)];
    lineLayer.path = path.CGPath;
    return lineLayer;
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
        _collectionView.decelerationRate = 0.0;
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
