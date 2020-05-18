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
        _shortScaleSize = 20;
        _longScaleSize = 40;
        _scaleWeigth = 2; //粗细
    }
    return self;
}

@end
