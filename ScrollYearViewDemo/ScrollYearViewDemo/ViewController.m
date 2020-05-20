//
//  ViewController.m
//  ScrollYearViewDemo
//
//  Created by Felix Yin on 2020/5/13.
//  Copyright © 2020 Felix Yin. All rights reserved.
//

#import "ViewController.h"
#import "ScrollYearView.h"
#import "ScrollYearRuleView.h"

@interface ViewController ()

@property(nonatomic,strong) ScrollYearView *yearView;
@property(nonatomic,strong) ScrollYearRuleView *yearView2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
//    [self.view addSubview:self.yearView];
    [self.view addSubview:self.yearView2];
}


//    MARK: Lazy Loading

- (ScrollYearView *)yearView{
    if (!_yearView) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        _yearView = [[ScrollYearView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    }
    return _yearView;
}

- (ScrollYearRuleView *)yearView2{
    if (!_yearView2) {
        _yearView2 = [[ScrollYearRuleView alloc] initWithFrame:CGRectMake(84, 84, 200, 600)];
        _yearView2.backgroundColor = [UIColor blueColor];
    }
    return _yearView2;
}


@end
