//
//  RechargeViewController.m
//  问答
//
//  Created by xwbb on 16/2/21.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "RechargeViewController.h"

#import "Common.h"

@interface RechargeViewController ()

@property (nonatomic , strong) NSArray *moneys;

@end

@implementation RechargeViewController

#pragma mark - View Life
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"充值";
    
    //创建导航栏左边按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"箭头.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //创建子视图
    [self _createSubviews];
}

//懒加载数组
- (NSArray *)moneys
{
    if (_moneys == nil) {
        _moneys = [NSArray array];
    }
    return _moneys;
}

- (void)_createSubviews
{
    UILabel *niuDouNumL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth, 30)];
    niuDouNumL.text = @"请选择充值金额";
    niuDouNumL.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:niuDouNumL];
    
    _moneys = @[@"¥  5.00",@"¥ 15.00",@"¥ 25.00",@"¥ 35.00",@"¥ 45.00"];
    for (int i = 1; i <= _moneys.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(niuDouNumL.left, niuDouNumL.bottom + 40 * (i - 1), kScreenWidth - 20, 40);
        [button setTitle:_moneys[i - 1] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 1.0;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kScreenWidth - 100);
        button.tag = 500 + i;
        if (i == 1) {
            button.selected = YES;
        }
        [button addTarget:self action:@selector(chooseMoney:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    
    UIButton *zfbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    zfbBtn.frame = CGRectMake(0, 0, kScreenWidth - 40, 30);
    zfbBtn.center = self.view.center;
    [zfbBtn setTitle:@"支付宝充值" forState:UIControlStateNormal];
    [zfbBtn setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
    [zfbBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    [zfbBtn setBackgroundImage:[UIImage imageNamed:@"橙色.png"] forState:UIControlStateNormal];
    zfbBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    zfbBtn.layer.cornerRadius = 10.0;
    zfbBtn.clipsToBounds = YES;
    [zfbBtn addTarget:self action:@selector(zfbBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zfbBtn];
    
}

#pragma mark - Action
//返回
- (void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

//选择充值数量
- (void)chooseMoney:(UIButton *)butt
{
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:501];
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:502];
    UIButton *btn3 = (UIButton *)[self.view viewWithTag:503];
    UIButton *btn4 = (UIButton *)[self.view viewWithTag:504];
    UIButton *btn5 = (UIButton *)[self.view viewWithTag:505];
    if (butt.tag == 501) {
        btn1.selected = YES;
        btn2.selected = NO;
        btn3.selected = NO;
        btn4.selected = NO;
        btn5.selected = NO;
    } else if (butt.tag == 502)
    {
        btn1.selected = NO;
        btn2.selected = YES;
        btn3.selected = NO;
        btn4.selected = NO;
        btn5.selected = NO;
    } else if (butt.tag == 503)
    {
        btn1.selected = NO;
        btn2.selected = NO;
        btn3.selected = YES;
        btn4.selected = NO;
        btn5.selected = NO;
    } else if (butt.tag == 504)
    {
        btn1.selected = NO;
        btn2.selected = NO;
        btn3.selected = NO;
        btn4.selected = YES;
        btn5.selected = NO;
    } else if (butt.tag == 505)
    {
        btn1.selected = NO;
        btn2.selected = NO;
        btn3.selected = NO;
        btn4.selected = NO;
        btn5.selected = YES;
    }
}

//支付宝充值
- (void)zfbBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
