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
//    CGFloat right = self.collectionView.width*0.5 - self.config.scaleSpace;
    NSInteger section = self.item/self.config.perSectionTotalCount;
//    BOOL isLength = self.index%(self.config.perScaleCount) == 0;
    NSInteger index = self.item;//section > 0 ? (self.index+1) : self.index;
//    if (section > 0 && (section+1) < self.config.sectionCount) {
//        index = self.index == 0 ? (self.index+1) : 0;
//    }
    [self scale:index];
}

- (NSInteger) showYear:(NSInteger) index{
    NSInteger section = self.item/self.config.perSectionTotalCount;
    NSInteger showYearNum = (self.index/self.config.perScaleCount + self.config.min);
    NSInteger showIndex = section > 0 ? (showYearNum - 1) : showYearNum;
    
    return showIndex;
}

- (void) scale:(NSInteger) index{
    CGFloat right = self.collectionView.width*0.5 - self.config.scaleSpace;
    BOOL isLength = index%(self.config.perScaleCount) == 0;
    NSInteger section = self.item/self.config.perSectionTotalCount;
    if(isLength){
        self.scaleLayer.size = CGSizeMake(self.config.longScaleSize, self.config.scaleWeigth);
        self.scaleLayer.right = right;
        self.scaleLayer.top = 0;
        self.scaleLayer.backgroundColor = self.config.scaleColor.CGColor;
        self.scaleLayer.cornerRadius = self.config.scaleWeigth*0.5;
        
        NSInteger showYearNum = self.item/self.config.perScaleCount; //(self.index/self.config.perScaleCount + self.config.min);
        NSInteger showIndex = showYearNum;//section > 0 ? (showYearNum - 1) : showYearNum;
        NSString *text = [@"" stringByAppendingFormat:@"%zd",showIndex];
        NSLog(@"Section == %zd Text == %@",section,text);
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
        self.scaleLayer.right = right;//(self.config.longScaleSize - self.config.shortScaleSize)+scaleStartX;
        self.scaleLayer.top = 0;
        self.scaleLayer.backgroundColor = self.config.scaleColor.CGColor;
        self.scaleLayer.cornerRadius = self.config.scaleWeigth*0.5;
    }
}

- (void)makeCellSelected{
    return;
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
    return;
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

- (void)updateCircleIndicator:(NSInteger)index{
    CGFloat right = self.collectionView.width*0.5 - self.config.scaleSpace;
    CGFloat cornerRadius = self.config.cornerRadius;
    double ind = (double) index;
    CGFloat lineX = (ind/self.config.perScaleCount)*cornerRadius;
    CGFloat x2 = powf(lineX, 2);
    CGFloat r2 = powf(cornerRadius, 2);
    CGFloat lineY = sqrtf(r2 - x2);
    CGFloat offset = (cornerRadius - lineY);
//    __weak typeof(self) weakSelf = self;
    _scaleLayer.right = right - offset;
//    [UIView animateWithDuration:0.5 animations:^{
//
//    }];
}

- (void)updateNormalIndicator{
    CGFloat right = self.collectionView.width*0.5 - self.config.scaleSpace;
    _scaleLayer.right = right;
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
