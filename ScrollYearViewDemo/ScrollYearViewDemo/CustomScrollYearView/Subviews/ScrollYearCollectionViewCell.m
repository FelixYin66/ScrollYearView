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

@interface ScrollYearCollectionViewCell ()

@property(nonatomic,strong) CALayer *scaleLayer;

@end

@implementation ScrollYearCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView.layer addSublayer:self.scaleLayer];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //重新布局
}


//    MARK: lazy loading

- (CALayer *)scaleLayer{
    if (!_scaleLayer) {
        _scaleLayer = [[CALayer alloc] init];
        //106 105 199
        _scaleLayer.backgroundColor = self.config.scaleColor.CGColor;
        _scaleLayer.size = CGSizeMake(self.config.shortScaleSize, self.config.scaleWeigth);
    }
    return _scaleLayer;
}

@end
