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
#import "UIView+FYAdd.h"

@interface ViewController ()<ScrollYearRuleViewDelegate>

@property(nonatomic,strong) ScrollYearView *yearView;
@property(nonatomic,strong) ScrollYearRuleView *yearView2;


@property(nonatomic,strong) UIView *view1;
@property(nonatomic,strong) UIView *view2;
@property(nonatomic,strong) UIView *view3;

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
//    [self.view addSubview:self.view1];
//    [self.view addSubview:self.view2];
//    [self.view addSubview:self.view3];
}




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self testConverCoordinate];
    self.yearView2.config.min = 1900;
    self.yearView2.config.max = 2017;
    self.yearView2.config.defaultSelectedYear = 1900;
    [self.yearView2 refreshData];
}


- (void) testConverCoordinate{
    //坐标转换
    /*
     以view1作为参考点  转换view2,view3的坐标(前提view2,view3的参考点时self.view 所以是调用self.view convert进行转化)
     */
    CGPoint originalPoint22 = CGPointMake(self.view2.left, self.view2.top);
    CGPoint originalPoint33 = CGPointMake(self.view3.left, self.view3.top);
    CGPoint point22 = [self.view convertPoint:originalPoint22 toView:self.view1];
    CGPoint point33 = [self.view convertPoint:originalPoint33 toView:self.view1];
    NSLog(@"originalPoint22 == %@ originalPoint33 == %@",NSStringFromCGPoint(originalPoint22),NSStringFromCGPoint(originalPoint33));
    NSLog(@"point22 == %@ point33 == %@",NSStringFromCGPoint(point22),NSStringFromCGPoint(point33));
    
    
    /*
     另一种测试：最终以view1作为参考点
     将view2中的点originalPoint2 转换到view1中的点
     将view3中的点originalPoint3 转换到view1中的点
     */
    CGPoint originalPoint2 = CGPointMake(self.view2.left, self.view2.top);
    CGPoint originalPoint3 = CGPointMake(self.view3.left, self.view3.top);
    CGPoint point2 = [self.view2 convertPoint:originalPoint2 toView:self.view1];
    CGPoint point3 = [self.view3 convertPoint:originalPoint3 toView:self.view1];
    NSLog(@"originalPoint2 == %@ originalPoint3 == %@",NSStringFromCGPoint(originalPoint2),NSStringFromCGPoint(originalPoint3));
    NSLog(@"point2 == %@ point3 == %@",NSStringFromCGPoint(point2),NSStringFromCGPoint(point3));
}

//    MARK: ScrollYearViewDelegate

- (void)scrollYearRuleView:(ScrollYearRuleView *)view selectedYear:(NSString *)year selectedIndex:(NSInteger)index{
    NSLog(@"Year == %@ Index == %zd",year,index);
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
        _yearView2.delegate = self;
    }
    return _yearView2;
}

- (UIView *)view1{
    if (!_view1) {
        _view1 = [[UIView alloc] init];
        _view1.backgroundColor = [UIColor blueColor];
        _view1.size = CGSizeMake(100, 100);
        _view1.top = 100;
        _view1.left = 100;
    }
    return _view1;
}

- (UIView *)view2{
    if (!_view2) {
        _view2 = [[UIView alloc] init];
        _view2.backgroundColor = [UIColor redColor];
        _view2.size = CGSizeMake(100, 100);
        _view2.top = 150;
        _view2.left = 120;
    }
    return _view2;
}

- (UIView *)view3{
    if (!_view3) {
        _view3 = [[UIView alloc] init];
        _view3.backgroundColor = [UIColor yellowColor];
        _view3.size = CGSizeMake(100, 100);
        _view3.top = 180;
        _view3.left = 220;
    }
    return _view3;
}


@end
