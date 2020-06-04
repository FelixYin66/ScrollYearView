//
//  ScrollYearRuleViewConfig.m
//  ScrollYearViewDemo
//
//  Created by Felix Yin on 2020/5/18.
//  Copyright © 2020 Felix Yin. All rights reserved.
//

#import "ScrollYearRuleViewConfig.h"

@implementation ScrollYearRuleViewConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        _min = 1980;
        _max = 2020;
        _scaleColor = [UIColor colorWithRed:106/255.0 green:105/255.0 blue:199/255.0 alpha:1];
        _scaleBgColor = [UIColor colorWithRed:32/255.0 green:34/255.0 blue:42/255.0 alpha:1];
        _shortScaleSize = 20;
        _longScaleSize = 40;
        _scaleWeigth = 2; //粗细
        _scaleSpace = 15; //每个小刻度间间距
        _perScaleCount = 5; //每5个一个刻度
        _textColor = [UIColor whiteColor];
        _textSize = 18;
        _textMaxSize = 25;
        _textFont = [UIFont systemFontOfSize:_textSize];
        _textMaxFont = [UIFont systemFontOfSize:_textMaxSize];
        _circleLineWeight = 5;
        _circleLineToScaleSpace = 3;
        CGFloat lineLength = _perScaleCount*(_scaleWeigth+_scaleSpace);
        _sectionCount = 5;
        _cornerRadius = lineLength*2/M_PI;
        _defaultSelectedYear = 1999;
        _prepareLoadIndex = 100;
    }
    return self;
}

@end
