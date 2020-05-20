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
        self.scaleLayer.left = 20;
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
//    [self contain];
//    [self scaleX];
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

- (BOOL) contain{
    CGFloat midY = self.collectionView.height*0.5;
    CGFloat space = (self.config.scaleSpace+self.config.scaleWeigth)*self.config.perScaleCount;
    CGFloat minY = midY-space;
    CGFloat maxY = midY+space;
    CGRect notConvertRect = CGRectMake(0, minY, self.width, maxY-minY);
    CGRect rect = [self.collectionView convertRect:notConvertRect toView:self.collectionView.superview];
    
//    NSLog(@"notConvertRect == %@ rect == %@",NSStringFromCGRect(notConvertRect),NSStringFromCGRect(rect));
    
    CGRect convertRect = [self.collectionView convertRect:self.frame toView:self.collectionView.superview];
    BOOL contain = CGRectContainsRect(rect, convertRect);
    
//    if (contain) {
//        NSLog(@"contain rect = %@ index = %td",NSStringFromCGRect(rect),(self.config.min+self.index));
//    }else{
//        NSLog(@"not contain rect = %@ index = %td",NSStringFromCGRect(rect),(self.config.min+self.index));
//    }
    return contain;
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

- (void)updateIndicator:(NSInteger)index{
    CGFloat scaleStartX = 20;
    CGFloat offSet = 10;
    if(self.index%(self.config.perScaleCount) == 0){
        _scaleLayer.left = scaleStartX - offSet;
    }else{
        _scaleLayer.left = (self.config.longScaleSize - self.config.shortScaleSize)+scaleStartX - offSet;
    }
}

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
