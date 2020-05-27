//
//  ScrollYearRuleCollectionViewLayout.h
//  ScrollYearViewDemo
//
//  Created by Felix Yin on 2020/5/18.
//  Copyright © 2020 Felix Yin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ScrollYearRuleViewConfig;
@interface ScrollYearRuleCollectionViewLayout : UICollectionViewLayout

@property(nonatomic,weak) ScrollYearRuleViewConfig *config;
@property(nonatomic,assign) UICollectionViewScrollDirection scrollDirection;
@property(nonatomic,assign) CGSize itemSize;
@property(nonatomic,assign) NSInteger actualLength;

@end

NS_ASSUME_NONNULL_END
