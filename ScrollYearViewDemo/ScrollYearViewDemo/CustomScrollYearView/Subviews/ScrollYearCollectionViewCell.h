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

@property(nonatomic,weak) UICollectionView *collectionView;
@property(nonatomic,weak) ScrollYearRuleViewConfig *config;
@property(nonatomic,assign) NSInteger index;

- (void) makeCellUnSelected;

- (void) makeCellSelected;

//- (void) updateCircleIndicator:(NSInteger) index;
//
//- (void) updateNormalIndicator:(NSInteger) index;

- (void) updateCircleIndicator:(CGFloat) offset;

- (void) updateNormalIndicator;

@end

NS_ASSUME_NONNULL_END
