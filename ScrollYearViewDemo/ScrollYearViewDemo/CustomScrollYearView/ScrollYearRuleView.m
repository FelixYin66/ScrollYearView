//
//  ScrollYearRuleView.m
//  ScrollYearViewDemo
//
//  Created by Felix Yin on 2020/5/18.
//  Copyright © 2020 Felix Yin. All rights reserved.
//

#import "ScrollYearRuleView.h"
#import "UIView+FYAdd.h"
#import "CALayer+FYAdd.h"
#import "ScrollYearRuleCollectionViewLayout.h"
#import "ScrollYearCollectionViewCell.h"

@interface ScrollYearRuleView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) ScrollYearRuleCollectionViewLayout *collectionViewLayout;
//@property(nonatomic,strong) CALayer *indicatorLayer;
@property(nonatomic,strong) CAGradientLayer *topGradientLayer;
@property(nonatomic,strong) CALayer *lineIndicatorLayer;
@property(nonatomic,strong) CAGradientLayer *bottomGradientLayer;
@property(nonatomic,assign) NSInteger selectIndex;
@property(nonatomic,assign) BOOL isSetup;
@property(nonatomic,strong) UIImpactFeedbackGenerator *feedBackGenerator;

@end

@implementation ScrollYearRuleView


- (instancetype)initWithFrame:(CGRect)frame config:(ScrollYearRuleViewConfig *)config{
    self = [super initWithFrame:frame];
        if (self) {
            _config = config;
            [self addSubview:self.collectionView];
            [self.layer addSublayer:self.lineIndicatorLayer];
            [self.layer addSublayer:self.topGradientLayer];
            [self.layer addSublayer:self.bottomGradientLayer];
    //        [self.layer addSublayer:[self drawLine]];
//            [self.layer addSublayer:self.indicatorLayer];
        }
        return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
        [self.layer addSublayer:self.lineIndicatorLayer];
        [self.layer addSublayer:self.topGradientLayer];
        [self.layer addSublayer:self.bottomGradientLayer];
//        [self.layer addSublayer:[self drawLine]];
//        [self.layer addSublayer:self.indicatorLayer];
    }
    return self;
}

- (void)refreshData{
    [_collectionView reloadData];
    [self initialData];
}

//设置选中Cell
- (void)selectCell {
    NSInteger indexOfCell = self.selectIndex;
    ScrollYearCollectionViewCell *cell = (ScrollYearCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:indexOfCell inSection:0]];
    [cell makeCellSelected];
    //添加反馈效果
    [self.feedBackGenerator impactOccurred];
}

//    MARK: Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offset = scrollView.contentOffset.y + _collectionView.height*0.5;//_collectionView.contentInset.top;
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
    
    if ([self.delegate respondsToSelector:@selector(scrollYearRuleView:selectedYear:selectedIndex:)]) {
        NSString *year = @"";
        BOOL isLength = index%(_config.perScaleCount) == 0;
        if (isLength) {
            NSInteger i = index/_config.perScaleCount;
            NSInteger showYearNum = i%(_config.max - _config.min + 1) + _config.min;
            year = [@"" stringByAppendingFormat:@"%zd",showYearNum];
        }
        [self.delegate scrollYearRuleView:self selectedYear:year selectedIndex:index];
    }
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
            CGFloat offset = scrollView.contentOffset.y + _collectionView.height*0.5;
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
    return self.collectionViewLayout.actualLength;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ScrollYearCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.item = indexPath.item;
    cell.config = self.config;
    cell.collectionView = self.collectionView;
    if (self.isSetup && self.selectIndex == indexPath.item) {
        cell.isSetup = self.isSetup;
        self.isSetup = NO;
    }else{
        cell.isSetup = NO;
    }
    [cell setNeedsLayout];
    return cell;
}


/*
 
 实现无限循环：
 1.滚动顶部没数据 （只有能增加新的，没法增加已存在的）
 
 */
//- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//    __weak typeof(self) weakSelf = self;
//    NSInteger totalCount = weakSelf.collectionViewLayout.actualLength;
//    NSInteger startIndex = self.collectionViewLayout.config.prepareLoadIndex;
//    BOOL isStartMin = (indexPath.item+50) == startIndex;
//    if (isStartMin || (totalCount == indexPath.item+startIndex)) {
//        NSInteger perTotalCount = self.collectionViewLayout.config.perSectionTotalCount;
//        NSInteger index = isStartMin ? 0 : totalCount;
//        NSInteger endIndex = isStartMin ? perTotalCount : (totalCount+perTotalCount);
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            NSInteger newTotalCount = totalCount+perTotalCount;
//            NSMutableArray *array = [NSMutableArray arrayWithCapacity:perTotalCount];
//            for (NSInteger i = index; i < endIndex; i++) {
//                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
//                [array addObject:indexPath];
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                weakSelf.collectionViewLayout.actualLength = newTotalCount;
//                [weakSelf.collectionView insertItemsAtIndexPaths:array];
//            });
//        });
//    }
//}



//    MARK: InitialData

- (void)initialData {
    if (self.config.max == 0 || self.config.min >= self.config.max) {
        return;
    } else {
        NSInteger items = self.config.max - self.config.min + 1;
        NSInteger perSectionTotalCount = 0;
        NSInteger perScaleCount = self.config.perScaleCount;
        NSInteger section = self.config.sectionCount;
        if (section > 0) {
            //如果是一位小数类型，则数据扩大perScaleCount倍
            perSectionTotalCount = items * perScaleCount;
        } else {
            perSectionTotalCount = items + 1;
        }
        
        NSInteger totalCount = section*perSectionTotalCount - (self.config.perScaleCount - 1);
        self.collectionViewLayout.actualLength = totalCount;
        self.config.perSectionTotalCount = perSectionTotalCount;
        
        //默认没有指定选中值时
        if (self.config.defaultSelectedYear > 0) {
            self.isSetup = YES;
            CGFloat offYear = self.config.defaultSelectedYear - self.config.min;
            NSInteger middleCount = self.config.sectionCount/2;
            NSInteger offIndex = offYear*self.config.perScaleCount;
            NSInteger index = middleCount*perSectionTotalCount + offIndex;
            self.selectIndex = index;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
        }else{
            self.isSetup = YES;
            NSInteger middleCount = self.config.sectionCount/2;
            NSInteger index = middleCount*perSectionTotalCount;
            self.selectIndex = index;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
        }
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
        _collectionView.backgroundColor = _config.scaleBgColor;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            if (@available(iOS 13.0, *)) {
                _collectionView.automaticallyAdjustsScrollIndicatorInsets = NO;
            } else {
                // Fallback on earlier versions
            }
        }
        
//        CGFloat top = self.height*0.5;
//        CGFloat bottom = self.height*0.5;
//        UIEdgeInsets inset = UIEdgeInsetsMake(top,0,bottom,0);
//        _collectionView.contentInset = inset;
        [_collectionView registerClass:[ScrollYearCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [self initialData];
    }
    return _collectionView;
}

- (CALayer *)lineIndicatorLayer{
    if (!_lineIndicatorLayer) {
        _lineIndicatorLayer = [[CALayer alloc] init];
        _lineIndicatorLayer.backgroundColor = self.config.scaleColor.CGColor;
        _lineIndicatorLayer.height = _collectionView.height;
        _lineIndicatorLayer.width = self.config.circleLineWeight;
        _lineIndicatorLayer.centerY = self.height*0.5;
        _lineIndicatorLayer.left = self.config.longScaleSize + self.config.circleLineToScaleSpace;//_collectionView.width*0.5;
    }
    return _lineIndicatorLayer;
}

- (CAGradientLayer *)topGradientLayer{
    if (!_topGradientLayer) {
        _topGradientLayer = [CAGradientLayer layer];
        _topGradientLayer.size = CGSizeMake(_collectionView.width, 60);
        _topGradientLayer.top = 0;
        _topGradientLayer.left = 0;
        _topGradientLayer.contents = (__bridge id)[self imageNamed:@"mask_text_t" ofBundle:@"CustomScrollYearView"].CGImage;
    }
    return _topGradientLayer;
}

- (CAGradientLayer *)bottomGradientLayer{
    if (!_bottomGradientLayer) {
        _bottomGradientLayer = [CAGradientLayer layer];
        _bottomGradientLayer.size = CGSizeMake(_collectionView.width, 60);
        _bottomGradientLayer.bottom = _collectionView.height;
        _bottomGradientLayer.left = 0;
        _bottomGradientLayer.contents = (__bridge id)[self imageNamed:@"mask_text_u" ofBundle:@"CustomScrollYearView"].CGImage;
    }
    return _bottomGradientLayer;
}

- (UIImage *)imageNamed:(NSString *)name ofBundle:(NSString *)bundleName {
    //ScrollYearRuleView 为打包后framework包中的类
    NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"ScrollYearRuleView")];
    NSString *bundlePath = [bundle pathForResource:bundleName ofType:@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    if (@available(iOS 13.0, *)) {
        UIImage *image = [UIImage imageNamed:name inBundle:resourceBundle withConfiguration:nil];
        return image;
    } else {
        // Fallback on earlier versions
        UIImage *image = [UIImage imageNamed:name inBundle:resourceBundle compatibleWithTraitCollection:nil];
        return image;
    }
}

//- (CALayer *)indicatorLayer{
//    if (!_indicatorLayer) {
//        _indicatorLayer = [[CALayer alloc] init];
//        _indicatorLayer.backgroundColor = [UIColor redColor].CGColor;
//        _indicatorLayer.height = 2;
//        _indicatorLayer.width = self.width;
//        _indicatorLayer.centerY = self.height*0.5;
//        _indicatorLayer.left = 0;
//    }
//    return _indicatorLayer;
//}

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

//
- (UIImpactFeedbackGenerator *)feedBackGenerator{
    if (!_feedBackGenerator) {
        _feedBackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
        [_feedBackGenerator prepare];
    }
    return _feedBackGenerator;
}

//- (NSMutableArray *)indexArray{
//    if (!_indexArray) {
//        _indexArray = [[NSMutableArray alloc] init];
//    }
//    return _indexArray;
//}

@end
