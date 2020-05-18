//
//  ScrollYearCollectionViewCell.h
//  ScrollYearViewDemo
//
//  Created by Felix Yin on 2020/5/18.
//  Copyright © 2020 Felix Yin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ScrollYearRuleViewConfig;
@interface ScrollYearCollectionViewCell : UICollectionViewCell

@property(nonatomic,weak) ScrollYearRuleViewConfig *config;
@property(nonatomic,assign) NSInteger index;

@end

NS_ASSUME_NONNULL_END
