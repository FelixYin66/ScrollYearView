//
//  ScrollYearRuleView.m
//  ScrollYearViewDemo
//
//  Created by Felix Yin on 2020/5/18.
//  Copyright © 2020 Felix Yin. All rights reserved.
//

#import "ScrollYearRuleView.h"
#import "UIView+Add.h"
#import "ScrollYearRuleCollectionViewLayout.h"

@interface ScrollYearRuleView ()

@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) ScrollYearRuleCollectionViewLayout *collectionViewLayout;

@end

@implementation ScrollYearRuleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
    }
    return self;
}


//    MARK: Lazy Loading

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewLayout];
    }
    return _collectionView;
}

- (ScrollYearRuleCollectionViewLayout *)collectionViewLayout{
    if (!_collectionViewLayout) {
        _collectionViewLayout = [[ScrollYearRuleCollectionViewLayout alloc] init];
    }
    return _collectionViewLayout;
}

@end
