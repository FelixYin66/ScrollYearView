//
//  ViewController.m
//  ScrollYearViewDemo
//
//  Created by Felix Yin on 2020/5/13.
//  Copyright © 2020 Felix Yin. All rights reserved.
//

#import "ViewController.h"
#import "ScrollYearView.h"

@interface ViewController ()

@property(nonatomic,strong) ScrollYearView *yearView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.view addSubview:self.yearView];
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


@end
