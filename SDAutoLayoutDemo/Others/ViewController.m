//
//  ViewController.m
//  SDAutoLayout 测试 Demo
//
//  Created by gsd on 15/10/12.
//  Copyright (c) 2015年 gsd. All rights reserved.
//

/*
 
 *********************************************************************************
 *                                                                                *
 * 在您使用此自动布局库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并  *
 * 帮您解决问题。                                                                    *
 * QQ    : 2689718696(gsdios)                                                      *
 * Email : gsdios@126.com                                                          *
 * GitHub: https://github.com/gsdios                                               *
 * 新浪微博:GSD_iOS                                                                 *
 *                                                                                *
 *********************************************************************************
 
 */

#import "ViewController.h"

#import "UIView+SDAutoLayout.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 与 topSpaceToView(self.view, …) 一致：内容从导航栏下方开始，避免与导航栏重叠
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupDemoViews];
}


- (void)setupDemoViews
{
    UIView *view0 = [UIView new];
    view0.backgroundColor = [UIColor redColor];
    view0.isAccessibilityElement = YES;
    view0.accessibilityIdentifier = @"demo.layout.view0";
    self.view0 = view0;
    
    UIView *view1 = [UIView new];
    view1.backgroundColor = [UIColor grayColor];
    view1.isAccessibilityElement = YES;
    view1.accessibilityIdentifier = @"demo.layout.view1";
    self.view1 = view1;
    
    UIView *view2 = [UIView new];
    view2.backgroundColor = [UIColor brownColor];
    view2.isAccessibilityElement = YES;
    view2.accessibilityIdentifier = @"demo.layout.view2";
    self.view2 = view2;
    
    UIView *view3 = [UIView new];
    view3.backgroundColor = [UIColor orangeColor];
    view3.isAccessibilityElement = YES;
    view3.accessibilityIdentifier = @"demo.layout.view3";
    self.view3 = view3;
    
    UIView *view4 = [UIView new];
    view4.backgroundColor = [UIColor purpleColor];
    view4.isAccessibilityElement = YES;
    view4.accessibilityIdentifier = @"demo.layout.view4";
    self.view4 = view4;
    
    UIView *view5 = [UIView new];
    view5.backgroundColor = [UIColor yellowColor];
    view5.isAccessibilityElement = YES;
    view5.accessibilityIdentifier = @"demo.layout.view5";
    self.view5 = view5;
    
    UIView *view6 = [UIView new];
    view6.backgroundColor = [UIColor cyanColor];
    view6.isAccessibilityElement = YES;
    view6.accessibilityIdentifier = @"demo.layout.view6";
    self.view6 = view6;
    
    UIView *view7 = [UIView new];
    view7.backgroundColor = [UIColor magentaColor];
    view7.isAccessibilityElement = YES;
    view7.accessibilityIdentifier = @"demo.layout.view7";
    self.view7 = view7;
    
    UIView *view8 = [UIView new];
    view8.backgroundColor = [UIColor blackColor];
    view8.isAccessibilityElement = YES;
    view8.accessibilityIdentifier = @"demo.layout.view8";
    self.view8 = view8;
    
    [self.view sd_addSubviews:@[view0, view1, view2, view3, view4, view5, view6, view7, view8]];
}




@end
