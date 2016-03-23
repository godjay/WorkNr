//
//  MainTabBarController.m
//  WXMovie
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 Mr.Y. All rights reserved.
//

#import "MainTabBarController.h"
#import "BaseNavigationController.h"
#import "TWViewController.h"
#import "WTViewController.h"
#import "WDViewController.h"

#import "Common.h"
#import "BaseButton.h"

#import "ViewController.h"
@interface MainTabBarController ()

{
    
    UIImageView *imageView;
}

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //创建子视图控制器
    [self _createNavigationC];
    
    //自定义TabBar
    [self _createTabBar];
    
    
}

//创建子视图控制器
- (void)_createNavigationC
{
    //创建第三级视图控制器
    TWViewController *tiwenVC = [[TWViewController alloc] init];
    WTViewController *wentiVC = [[WTViewController alloc] init];
    WDViewController *wodeVC = [[WDViewController alloc] init];
    
    NSArray *viewCs = @[tiwenVC,wentiVC,wodeVC];
    
    NSMutableArray *navis = [[NSMutableArray alloc] initWithCapacity:viewCs.count];
    
    //遍历视图控制器，给每一个视图控制器都添加一个导航控制器
    for (UIViewController *viewC in viewCs) {
        
        //创建第二级视图控制器
        BaseNavigationController *navigationC = [[BaseNavigationController alloc] initWithRootViewController:viewC];
        
        [navis addObject:navigationC];
    }
    
    self.viewControllers = navis;

}


- (void)_createTabBar {
    //设置TabBar为半透明
    self.tabBar.translucent = YES;
    //存放标题和图片名称
    NSArray *images = @[@"消息灰色.png",
                        @"问题灰色.png",
                        @"我的灰色.png"];
    NSArray *selectImages = @[@"消息绿色.png",
                              @"问题绿色.png",
                              @"我的绿色.png"];
    
    //TabBar上的button的宽度
    CGFloat tWidth = kScreenWidth / self.viewControllers.count;

    //打印TabBar上的子视图
//    NSLog(@"%@",self.tabBar.subviews);
    
    //1、移除TabBar上系统带的子视图
    for (UIView *view in self.tabBar.subviews) {
        
        [view removeFromSuperview];
    }
    
    
    //2、创建TabBar上的button
    for ( int i = 0; i < self.viewControllers.count; i ++) {
        //拿出图片名字
        NSString *imageName = images[i];
        NSString *selectImageN = selectImages[i];
        
        //子类化创建Button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * tWidth + (tWidth - 30) / 2, 5, 30, kTabBarHeight - 10);
        [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:selectImageN] forState:UIControlStateSelected];
        button.tag = i + 100;
        if (i == 0) {
            button.selected = YES;
        }
        [button addTarget:self
                   action:@selector(buttonAction:)
         forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.tabBar addSubview:button];
        
    }

}


#pragma mark - Action

- (void)buttonAction:(UIButton *)butt {
    
    if (USER != nil) {
        
        UIButton *btn1 = (UIButton *)[self.tabBar viewWithTag:100];
        UIButton *btn2 = (UIButton *)[self.tabBar viewWithTag:101];
        UIButton *btn3 = (UIButton *)[self.tabBar viewWithTag:102];
        if (butt.tag == 100) {
            btn1.selected = YES;
            btn2.selected = NO;
            btn3.selected = NO;
            self.selectedIndex = 0;

        } else if (butt.tag == 101)
        {
            btn1.selected = NO;
            btn2.selected = YES;
            btn3.selected = NO;
            self.selectedIndex = 1;

        } else if (butt.tag == 102)
        {
            btn1.selected = NO;
            btn2.selected = NO;
            btn3.selected = YES;
            self.selectedIndex = 2;

        }
        
        
        //调转到选中的视图控制器
        
    }else{
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"登录后开始问答哦~" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertC animated:YES completion:nil];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction * _Nonnull action) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ViewController *viewC = (ViewController *)[storyboard instantiateInitialViewController];
            [self presentViewController:viewC animated:NO completion:nil];
        }];
        [alertC addAction:action1];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertC addAction:action2];
    }

}


@end
