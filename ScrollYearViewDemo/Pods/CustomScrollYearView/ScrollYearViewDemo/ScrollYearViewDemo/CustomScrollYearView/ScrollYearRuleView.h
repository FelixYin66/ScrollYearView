//
//  ScrollYearRuleView.h
//  ScrollYearViewDemo
//
//  Created by Felix Yin on 2020/5/18.
//  Copyright © 2020 Felix Yin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollYearRuleViewConfig.h"

NS_ASSUME_NONNULL_BEGIN

@class ScrollYearRuleView;
@protocol ScrollYearRuleViewDelegate <NSObject>

@optional
- (void) scrollYearRuleView:(ScrollYearRuleView *) view selectedYear:(NSString *) year selectedIndex:(NSInteger) index;

@end

@interface ScrollYearRuleView : UIView

@property(nonatomic,weak) id<ScrollYearRuleViewDelegate> delegate;
@property(nonatomic,strong) ScrollYearRuleViewConfig *config;

- (instancetype) initWithFrame:(CGRect)frame config:(ScrollYearRuleViewConfig *) config;

- (void) refreshData;

@end

NS_ASSUME_NONNULL_END
