//
//  BaseNavigationController.m
//  WXMovie
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 Mr.Y. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏背景图片(导航栏变为不透明)
    self.navigationBar.barTintColor = [UIColor colorWithRed:78 / 255.0 green:106 /255.0 blue:120 / 255.0 alpha:1];
    
    self.title = @"登录";
    //设置导航栏为半透明
//    self.navigationBar.translucent = YES;
    
    //设置导航栏字体颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
}

/*
 iOS7.0复写方法，设置状态栏的风格
 多级控制器时，应该在导航控制器中管理状态栏的风格
 */

//覆写状态栏风格方法
- (UIStatusBarStyle)preferredStatusBarStyle {

    return UIStatusBarStyleLightContent;
}

@end
