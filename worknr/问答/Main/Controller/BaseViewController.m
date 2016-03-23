//
//  BaseViewController.m
//  WXMovie
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 Mr.Y. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        [self _createNaviBar];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithRed:236 / 255.0 green:237 /255.0 blue:239 /255.0 alpha:1];
    
    
    //创建导航栏
    [self _createNaviBar];
    
}

#pragma mark - 创建导航栏

- (void)_createNaviBar
{
    
    //创建标题label
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
//    [_titleLabel sizeToFit];
    //设置为标题
    self.navigationItem.titleView = _titleLabel;
    
}

- (void)setTitle:(NSString *)title
{
    // _title 是一个 @package 修饰的属性 所以不能直接修改
//     _title = title;
    // 所以需要使用父类中的setTitle方法来修改_title
    
    [super setTitle:title];
    
    _titleLabel.text = title;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
