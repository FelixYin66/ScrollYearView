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

@interface CALayer (ScrollAdd)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGPoint center;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGPoint origin;
@property (nonatomic, getter=frameSize, setter=setFrameSize:) CGSize  size;

@end

@interface ScrollYearView ()<UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView *tableView;
@property(nonatomic,strong) UIImageView *imageView;

@end

@implementation ScrollYearView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self addSubview:self.tableView];
        [self addSubview:self.imageView];
        
//        [self drawLine];
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


- (CALayer *) drawLine{
    
//    UIImage *stretchableImage = (id)[UIImage imageNamed:@"scale_text"];
    CGColorRef color = [UIColor whiteColor].CGColor;
    CGFloat cornerRadius = 50;
    CGFloat lineWidth = 5;
    CGFloat startX = 0;
    CGFloat width = self.width;
    CGFloat height = self.height;
    CGFloat lineH = (height - cornerRadius*2 - lineWidth*2)*0.5;
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.lineWidth = lineWidth;
    lineLayer.strokeColor = color;
    lineLayer.fillColor = color;
    lineLayer.left = 100;
    lineLayer.width = cornerRadius;
    
    
    
//    UIImage *stretchableImage = [[UIImage imageNamed:@"scale_text"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeTile];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(0, lineH)];
    [path addQuadCurveToPoint:CGPointMake(0, lineH+cornerRadius*2) controlPoint:CGPointMake(-cornerRadius, height*0.5)];
    [path addLineToPoint:CGPointMake(0, self.height)];
    lineLayer.path = path.CGPath;
    
//    [self.layer addSublayer:lineLayer];
    return lineLayer;
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
        
    }
    return _tableView;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        //UIImageResizingModeTile 按照图片大小平铺
        UIImage *stretchableImage = [[UIImage imageNamed:@"scale_text"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeTile];
        _imageView = [[UIImageView alloc] init];
        _imageView.width = 54;
        _imageView.height = self.height;
        _imageView.centerX = self.width*0.5;
        _imageView.image = stretchableImage;
        CALayer *layer = [self drawLine];
        layer.right = 80;
        layer.top = 0;
        [_imageView.layer addSublayer:layer];
//        _imageView.layer.mask = layer;
    }
    return _imageView;
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


@implementation CALayer (ScrollAdd)

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

- (CGPoint)center {
    return CGPointMake(self.frame.origin.x + self.frame.size.width * 0.5,
                       self.frame.origin.y + self.frame.size.height * 0.5);
}

- (void)setCenter:(CGPoint)center {
    CGRect frame = self.frame;
    frame.origin.x = center.x - frame.size.width * 0.5;
    frame.origin.y = center.y - frame.size.height * 0.5;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.frame.origin.x + self.frame.size.width * 0.5;
}

- (void)setCenterX:(CGFloat)centerX {
    CGRect frame = self.frame;
    frame.origin.x = centerX - frame.size.width * 0.5;
    self.frame = frame;
}

- (CGFloat)centerY {
    return self.frame.origin.y + self.frame.size.height * 0.5;
}

- (void)setCenterY:(CGFloat)centerY {
    CGRect frame = self.frame;
    frame.origin.y = centerY - frame.size.height * 0.5;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)frameSize {
    return self.frame.size;
}

- (void)setFrameSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


@end
