//
//  ScrollYearCollectionViewCell.m
//  ScrollYearViewDemo
//
//  Created by Felix Yin on 2020/5/18.
//  Copyright © 2020 Felix Yin. All rights reserved.
//

#import "ScrollYearCollectionViewCell.h"
#import "ScrollYearRuleViewConfig.h"
#import "CALayer+Add.h"
#import "UIView+Add.h"

@interface ScrollYearCollectionViewCell ()

@property(nonatomic,strong) CALayer *scaleLayer;
@property (nonatomic, strong) CATextLayer *textLayer;

@end

@implementation ScrollYearCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView.layer addSublayer:self.scaleLayer];
        [self.contentView.layer addSublayer:self.textLayer];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //重新布局
//    NSLog(@"left ==%f top: == %f",self.left,self.top);
    CGFloat scaleStartX = 20;
    if(self.index%(self.config.perScaleCount) == 0){
        self.scaleLayer.size = CGSizeMake(self.config.longScaleSize, self.config.scaleWeigth);
        self.scaleLayer.left = scaleStartX;
        self.scaleLayer.top = 0;
        self.scaleLayer.backgroundColor = self.config.scaleColor.CGColor;
        self.scaleLayer.cornerRadius = self.config.scaleWeigth*0.5;
        
        NSInteger showIndex = (self.index/self.config.perScaleCount + self.config.min);
        NSString *text = [@"" stringByAppendingFormat:@"%zd",showIndex];
        CGSize size = [text boundingRectWithSize:CGSizeMake(self.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.config.textFont} context:nil].size;
        self.textLayer.size = size;
        self.textLayer.right = self.width - 30;
        self.textLayer.centerY = self.height*0.5;
        self.textLayer.string = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: self.config.textFont, NSForegroundColorAttributeName:self.config.textColor}];
        self.textLayer.actions = @{@"contents": [NSNull null]};
    }else{
        self.textLayer.size = CGSizeZero;
        self.textLayer.string = nil;
        self.scaleLayer.size = CGSizeMake(self.config.shortScaleSize, self.config.scaleWeigth);
        self.scaleLayer.left = (self.config.longScaleSize - self.config.shortScaleSize)+scaleStartX;
        self.scaleLayer.top = 0;
        self.scaleLayer.backgroundColor = self.config.scaleColor.CGColor;
        self.scaleLayer.cornerRadius = self.config.scaleWeigth*0.5;
    }
    [self contain2];
//    [self scaleX];
}

- (void) contain2{
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:CGPointMake(0, self.collectionView.height*0.5+self.collectionView.contentOffset.y)];
    if (indexPath!=nil) {
        NSInteger middle = indexPath.item;
        NSInteger min = middle - self.config.perScaleCount;
        NSInteger max = middle + self.config.perScaleCount;
        NSInteger total = [self.collectionView numberOfItemsInSection:0];
        if (indexPath.item%self.config.perScaleCount == 0) {
            NSInteger showIndex = self.index/self.config.perScaleCount + self.config.min;
            NSLog(@"center == %@",@(showIndex));
        }
        
        NSArray *cells = self.collectionView.visibleCells;
        ScrollYearCollectionViewCell *cell = (ScrollYearCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        [cell updateCircleIndicator:0];
        NSMutableArray *minusArray = [[NSMutableArray alloc] initWithCapacity:50];
        [minusArray addObject:cell];
        if (min >= 0) {
            for (NSInteger i = min; i < middle ; i++) {
                NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
                ScrollYearCollectionViewCell *cel = (ScrollYearCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:index];
                [cel updateCircleIndicator:0];
                [minusArray addObject:cel];
            }
        }
        
        if (total >= max) {
            for (NSInteger i = middle; i < max ; i++) {
                NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
                ScrollYearCollectionViewCell *cel = (ScrollYearCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:index];
                [cel updateCircleIndicator:0];
                [minusArray addObject:cel];
            }
        }
        
        NSPredicate *preDicate = [NSPredicate predicateWithFormat:@"NOT SELF IN %@",minusArray];
        NSArray *fArray = [cells filteredArrayUsingPredicate:preDicate];
        [fArray enumerateObjectsUsingBlock:^(ScrollYearCollectionViewCell *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj updateNormalIndicator];
        }];
    }

    
}

//[viewB convertRect:viewC.frame toView:viewA];  作用是计算 C在B上frame 转换到A上的frame
//- (void) contain{
//    CGPoint point1 = CGPointMake(self.left, self.top);
//    CGPoint point2 = CGPointMake(0, self.collectionView.height*0.5);
//    CGPoint convert1 = [self.collectionView convertPoint:point1 toView:self.collectionView.superview];
//    CGPoint convert2 = [self.collectionView convertPoint:point2 toView:self.collectionView.superview];
//
//    NSLog(@"index == %zd point1 == %@ convert 1 == %@  point2 == %@  convert2 == %@",self.index+self.config.min,NSStringFromCGPoint(point1),NSStringFromCGPoint(convert1),NSStringFromCGPoint(point2),NSStringFromCGPoint(convert2));
//}



/*
 
 //获取cell在当前collection的位置
 CGRect cellInCollection = [_collectionView convertRect:item.frame toView:_collectionView];
 UICollectionViewCell * item = [_collectionView cellForItemAtIndexPath:indexPath]];
 
 
 //获取cell在当前屏幕的位置
 CGRect cellInSuperview = [_collectionView convertRect:item.frame toView:[_collectionView superview]];
 NSLog(@"获取cell在当前collection的位置: %@ /n 获取cell在当前屏幕的位置：%@", NSStringFromCGRect(cellInCollection), NSStringFromCGRect(cellInSuperview));
 
 */
- (BOOL) contain{
    CGFloat midY = self.collectionView.height*0.5;
    CGFloat space = (self.config.scaleSpace+self.config.scaleWeigth)*self.config.perScaleCount;
    CGFloat minY = midY-space;
    CGFloat maxY = midY+space;
    CGRect notConvertRect = CGRectMake(0, minY, self.width, maxY-minY);
    CGRect rect = [self.collectionView convertRect:notConvertRect toView:self.collectionView.superview];
    
    CGRect convertRect = [self.collectionView convertRect:self.frame toView:self.collectionView];
    BOOL contain = CGRectContainsRect(rect, convertRect);
    
    NSInteger showIndex = self.index%self.config.perScaleCount == 0 ? (self.index/self.config.perScaleCount + self.config.min) : 0;
    
    NSLog(@"notConvertRect == %@  🐶🐶🐶 == %@",NSStringFromCGRect(self.frame),@(showIndex));
    NSLog(@"rect == %@  🐶🐶🐶 == %@",NSStringFromCGRect(convertRect),@(showIndex));
    
//    NSLog(@"notConvertRect == %@ rect == %@  🐶🐶🐶 == %@",NSStringFromCGRect(notConvertRect),NSStringFromCGRect(rect),@(showIndex));
//    if (contain) {
//        NSLog(@"offset == %@ contain rect = %@ contain index = %td",@(self.collectionView.contentOffset.y),NSStringFromCGRect(self.frame),(showIndex));
//    }else{
//        NSLog(@"offset == %@ not contain rect = %@ index = %td",@(self.collectionView.contentOffset.y),NSStringFromCGRect(self.frame),(showIndex));
////        NSLog(@"not contain  index = %td",(showIndex));
//    }
    return contain;
//    (850+196) - 600
}

- (CGFloat) scaleX{
    CGFloat centerY = self.collectionView.height*0.5;
    CGPoint centerPoint = CGPointMake(0, centerY);
    NSIndexPath *index = [self.collectionView indexPathForItemAtPoint:centerPoint];
    NSIndexPath *indexx = [self.collectionView indexPathForItemAtPoint:CGPointMake(self.left, self.top)];
    if (index) {
     NSLog(@"index == %td",(index.item+self.config.min));
    }else{
     NSInteger i = indexx.item+self.config.min;
     NSLog(@"indexx == %td",(i));
    }
    return 0;
}

- (void)makeCellSelected{
    NSInteger showIndex = (self.index/self.config.perScaleCount + self.config.min);
    NSString *text = [@"" stringByAppendingFormat:@"%zd",showIndex];
    CGSize size = [text boundingRectWithSize:CGSizeMake(self.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.config.textMaxFont} context:nil].size;
    self.textLayer.size = size;
    self.textLayer.right = self.width - 30;
    self.textLayer.centerY = self.height*0.5;
    self.textLayer.string = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: self.config.textMaxFont, NSForegroundColorAttributeName:self.config.textColor}];
    self.textLayer.actions = @{@"contents": [NSNull null]};
}

- (void)makeCellUnSelected{
    if(self.index%(self.config.perScaleCount) == 0){
        NSInteger showIndex = (self.index/self.config.perScaleCount + self.config.min);
        NSString *text = [@"" stringByAppendingFormat:@"%zd",showIndex];
        CGSize size = [text boundingRectWithSize:CGSizeMake(self.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.config.textFont} context:nil].size;
        self.textLayer.size = size;
        self.textLayer.right = self.width - 30;
        self.textLayer.centerY = self.height*0.5;
        self.textLayer.string = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: self.config.textFont, NSForegroundColorAttributeName:self.config.textColor}];
        self.textLayer.actions = @{@"contents": [NSNull null]};
    }
}

- (void)updateCircleIndicator:(CGFloat)offset{
    _scaleLayer.left = offset;
}

- (void)updateNormalIndicator{
    CGFloat scaleStartX = 20;
    if(self.index%(self.config.perScaleCount) == 0){
        _scaleLayer.left = scaleStartX;
    }else{
        _scaleLayer.left = (self.config.longScaleSize - self.config.shortScaleSize)+scaleStartX;
    }
}

//- (void)updateCircleIndicator:(NSInteger)index{
//    CGFloat scaleStartX = 20;
//    CGFloat offSet = 10;
//    if(self.index%(self.config.perScaleCount) == 0){
//        _scaleLayer.left = scaleStartX - offSet;
//    }else{
//        _scaleLayer.left = (self.config.longScaleSize - self.config.shortScaleSize)+scaleStartX - offSet;
//    }
////    self.backgroundColor = [UIColor redColor];
//}
//
//- (void)updateNormalIndicator:(NSInteger)index{
//    CGFloat scaleStartX = 20;
//    if(self.index%(self.config.perScaleCount) == 0){
//        _scaleLayer.left = scaleStartX;
//    }else{
//        _scaleLayer.left = (self.config.longScaleSize - self.config.shortScaleSize)+scaleStartX;
//    }
////    self.backgroundColor = [UIColor clearColor];
//}

//    MARK: lazy loading

- (CALayer *)scaleLayer{
    if (!_scaleLayer) {
        _scaleLayer = [[CALayer alloc] init];
    }
    return _scaleLayer;
}

- (CATextLayer *)textLayer {
    if (!_textLayer) {
        _textLayer = [CATextLayer layer];
        _textLayer.contentsScale = [UIScreen mainScreen].scale;
        _textLayer.alignmentMode = @"center";
    }
    return _textLayer;
}

@end
