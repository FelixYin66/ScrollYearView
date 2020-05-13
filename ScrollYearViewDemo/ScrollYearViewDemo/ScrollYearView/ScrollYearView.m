//
//  ScrollYearView.m
//  ScrollYearViewDemo
//
//  Created by Felix Yin on 2020/5/13.
//  Copyright © 2020 Felix Yin. All rights reserved.
//

#import "ScrollYearView.h"

@interface UIView (ScrollAdd)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize  size;

@end

@interface ScrollYearView ()<UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView *tableView;


@end

@implementation ScrollYearView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableView];
        [self drawLine];
    }
    return self;
}


//    MARK: UITableView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
}


- (void) drawLine{
    
    CGColorRef color = [UIColor whiteColor].CGColor;
    CGFloat cornerRadius = 50;
    CGFloat lineWidth = 5;
    CGFloat startX = self.tableView.width - lineWidth;
    CGFloat lineH = (self.tableView.height - cornerRadius*2 - lineWidth*2)*0.5;
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.lineWidth = lineWidth;
    lineLayer.strokeColor = color;
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    linePath.lineCapStyle = kCGLineCapRound;
    linePath.lineJoinStyle = kCGLineJoinRound;
    [linePath moveToPoint:CGPointMake(startX, 0)];
    [linePath addLineToPoint:CGPointMake(startX, lineH)];
    
    UIBezierPath *halfCirclePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(startX+lineWidth*0.5, lineH+cornerRadius) radius:cornerRadius startAngle:M_PI*1.5 endAngle:M_PI*0.5 clockwise:NO];
    [linePath appendPath:halfCirclePath];
    
    UIBezierPath *linePath2 = [UIBezierPath bezierPath];
    linePath2.lineCapStyle = kCGLineCapRound;
    linePath2.lineJoinStyle = kCGLineJoinRound;
    CGFloat linePathY = lineH+cornerRadius*2;
    [linePath2 moveToPoint:CGPointMake(startX, linePathY)];
    [linePath2 addLineToPoint:CGPointMake(startX, lineH+linePathY)];
    [linePath appendPath:linePath2];
    
    lineLayer.path = linePath.CGPath;
    
//    lineLayer.contents = (__bridge id _Nullable)[UIImage imageNamed:@"scale_text"].CGImage;
    UIImage *stretchableImage = (id)[UIImage imageNamed:@"scale_text"];
    self.tableView.layer.contents = (id)stretchableImage.CGImage;
    self.tableView.layer.contentsScale = [UIScreen mainScreen].scale;
    self.tableView.layer.contentsCenter = CGRectMake(15.0/stretchableImage.size.width,0.0/stretchableImage.size.height,1.0/stretchableImage.size.width,0.0/stretchableImage.size.height);
    [self.tableView.layer addSublayer:lineLayer];
}


//    MARK: Lazy Loading

- (UIScrollView *)tableView{
    if (!_tableView) {
        _tableView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _tableView.width = 300;
        _tableView.height = self.height;
        _tableView.contentSize = CGSizeMake(_tableView.width, 10000);
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor grayColor];
        
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//        view.backgroundColor = [UIColor redColor];
//        _tableView.maskView = view;
        
    }
    return _tableView;
}

@end

@implementation UIView(ScrollAdd)

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


@end
