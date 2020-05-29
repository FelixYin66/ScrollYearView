//
//  ScrollYearCollectionViewCell.m
//  ScrollYearViewDemo
//
//  Created by Felix Yin on 2020/5/18.
//  Copyright © 2020 Felix Yin. All rights reserved.
//

#import "ScrollYearCollectionViewCell.h"
#import "ScrollYearRuleViewConfig.h"
#import "CALayer+FYAdd.h"
#import "UIView+FYAdd.h"

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
//    CGFloat right = self.collectionView.width*0.5 - self.config.scaleSpace;
    NSInteger year = [self showYear:self.item];
    CGFloat left = year > 0 ? 0 : (self.config.longScaleSize - self.config.shortScaleSize);//self.collectionView.width*0.5 - self.config.scaleSpace;
    if(year > 0){
        self.scaleLayer.size = CGSizeMake(self.config.longScaleSize, self.config.scaleWeigth);
        self.scaleLayer.left = left;
        self.scaleLayer.top = 0;
        self.scaleLayer.backgroundColor = self.config.scaleColor.CGColor;
        self.scaleLayer.cornerRadius = self.config.scaleWeigth*0.5;
        NSString *text = [@"" stringByAppendingFormat:@"%zd",year];
        UIFont *font = self.isSetup ? self.config.textMaxFont : self.config.textFont;
        CGSize size = [text boundingRectWithSize:CGSizeMake(self.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
        CGFloat width = self.width - self.config.longScaleSize - self.config.circleLineWeight - self.config.circleLineToScaleSpace;
        self.textLayer.size = CGSizeMake(width, size.height);//size;
        self.textLayer.left = self.width - width;
        self.textLayer.centerY = self.height*0.5;
        self.textLayer.string = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName:self.config.textColor}];
        self.textLayer.actions = @{@"contents": [NSNull null]};
    }else{
        NSString *text = [@"" stringByAppendingFormat:@"%zd",self.config.max];
        CGSize size = [text boundingRectWithSize:CGSizeMake(self.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.config.textMaxFont} context:nil].size;
        CGFloat width = self.width - self.config.longScaleSize - self.config.circleLineWeight - self.config.circleLineToScaleSpace;
        self.textLayer.size = CGSizeMake(width, size.height);
        self.textLayer.left = self.width - width;
        self.textLayer.string = nil;
        self.scaleLayer.size = CGSizeMake(self.config.shortScaleSize, self.config.scaleWeigth);
        self.scaleLayer.left = left;
        self.scaleLayer.top = 0;
        self.scaleLayer.backgroundColor = self.config.scaleColor.CGColor;
        self.scaleLayer.cornerRadius = self.config.scaleWeigth*0.5;
    }

}

- (NSInteger) showYear:(NSInteger) index{
    BOOL isLength = index%(self.config.perScaleCount) == 0;
    if (isLength) {
        NSInteger i = index/self.config.perScaleCount;
        NSInteger showYearNum = i%(self.config.max - self.config.min + 1) + self.config.min;
        NSInteger showIndex = showYearNum;
        return showIndex;
    }else{
        return 0;
    }
}

- (void)makeCellSelected{
    NSInteger showIndex = [self showYear:self.item];
    NSString *text = [@"" stringByAppendingFormat:@"%zd",showIndex];
    CGSize size = [text boundingRectWithSize:CGSizeMake(self.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.config.textMaxFont} context:nil].size;
    CGFloat width = self.width - self.config.longScaleSize - self.config.circleLineWeight - self.config.circleLineToScaleSpace;
    self.textLayer.size = CGSizeMake(width, size.height);
    self.textLayer.left = self.width - width;
    self.textLayer.centerY = self.height*0.5;
    self.textLayer.string = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: self.config.textMaxFont, NSForegroundColorAttributeName:self.config.textColor}];
    self.textLayer.actions = @{@"contents": [NSNull null]};
}

- (void)makeCellUnSelected{
    NSInteger showIndex = [self showYear:self.item];
    if(showIndex > 0){
        NSString *text = [@"" stringByAppendingFormat:@"%zd",showIndex];
        CGSize size = [text boundingRectWithSize:CGSizeMake(self.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.config.textFont} context:nil].size;
        CGFloat width = self.width - self.config.longScaleSize - self.config.circleLineWeight - self.config.circleLineToScaleSpace;
        self.textLayer.size = CGSizeMake(width, size.height);
        self.textLayer.left = self.width - width;
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
    _scaleLayer.right = right - offset;
}

- (void)updateNormalIndicator{
    CGFloat left = [self showYear:self.item] ? 0 : (self.config.longScaleSize - self.config.shortScaleSize);
    _scaleLayer.left = left;
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
