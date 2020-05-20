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
@property(nonatomic,assign) NSInteger perScaleCount;
@property(nonatomic,strong) UIColor *textColor;
@property(nonatomic,assign) CGFloat textSize;
@property(nonatomic,assign) CGFloat textMaxSize;
@property(nonatomic,strong) UIFont  *textFont;
@property(nonatomic,strong) UIFont  *textMaxFont;

@end

NS_ASSUME_NONNULL_END
