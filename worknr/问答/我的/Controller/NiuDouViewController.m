//
//  NiuDouViewController.m
//  问答
//
//  Created by xwbb on 16/2/21.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "NiuDouViewController.h"
#import "RechargeViewController.h"
#import "Common.h"

@interface NiuDouViewController ()

@end

@implementation NiuDouViewController

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
    self.titleLabel.text = @"我的牛豆";
    
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

- (void)_createSubviews
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
    bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    bgView.layer.borderWidth = 1.0;
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UILabel *niuDouNumL = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 30)];
    niuDouNumL.text = @"5.00 牛豆";
    niuDouNumL.textAlignment = 1;
    niuDouNumL.font = [UIFont boldSystemFontOfSize:17];
    [bgView addSubview:niuDouNumL];
    
    //充值
    UIButton *czBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    czBtn.frame = CGRectMake(50, niuDouNumL.bottom + 10, 80, 30);
    [czBtn setTitle:@"充值" forState:UIControlStateNormal];
    [czBtn setBackgroundImage:[UIImage imageNamed:@"发送.png"] forState:UIControlStateNormal];
    czBtn.layer.cornerRadius = 5.0;
    czBtn.clipsToBounds = YES;
    [czBtn addTarget:self action:@selector(chongzhiAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:czBtn];
    
    //提现
    UIButton *txBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    txBtn.frame = CGRectMake( kScreenWidth - 50 - 80, niuDouNumL.bottom + 10, 80, 30);
    [txBtn setTitle:@"提现" forState:UIControlStateNormal];
    [txBtn setBackgroundImage:[UIImage imageNamed:@"发送.png"] forState:UIControlStateNormal];
    txBtn.layer.cornerRadius = 5.0;
    txBtn.clipsToBounds = YES;
    [txBtn addTarget:self action:@selector(tixianAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:txBtn];
}


#pragma mark - Action
//返回
- (void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)chongzhiAction
{
    RechargeViewController *rechargeVC = [[RechargeViewController alloc] init];
    [self.navigationController pushViewController:rechargeVC animated:YES];
}

- (void)tixianAction
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"您还没有绑定支付宝, 现在绑定吗?" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertC animated:YES completion:nil];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"确定");
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [alertC addAction:action1];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:action2];
}

@end
