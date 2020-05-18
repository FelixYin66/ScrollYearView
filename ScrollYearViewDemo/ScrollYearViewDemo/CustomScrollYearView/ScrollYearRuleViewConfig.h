//
//  ScrollYearRuleViewConfig.h
//  ScrollYearViewDemo
//
//  Created by Felix Yin on 2020/5/18.
//  Copyright © 2020 Felix Yin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScrollYearRuleViewConfig : NSObject

@property(nonatomic,assign) NSInteger min;
@property(nonatomic,assign) NSInteger max;
@property(nonatomic,strong) UIColor *scaleColor;
@property(nonatomic,assign) CGFloat shortScaleSize;
@property(nonatomic,assign) CGFloat longScaleSize;
@property(nonatomic,assign) CGFloat scaleWeigth;
@property(nonatomic,assign) CGFloat scaleSpace;

@end

NS_ASSUME_NONNULL_END
