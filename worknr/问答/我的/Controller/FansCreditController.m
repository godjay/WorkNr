//
//  FansCreditController.m
//  问答
//
//  Created by lirenjie on 16/3/17.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "FansCreditController.h"
//#import <ProgressHUD.h>
@interface FansCreditController ()

@end

@implementation FansCreditController

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
    self.titleLabel.text = @"牛人信誉";
    //创建导航栏左边按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"箭头.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //修改外观
    _bgView1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _bgView1.layer.borderWidth = 1.0;
    
    [self setupView];

}

- (void)setupView{
    self.dahao.text = [NSString stringWithFormat:@"%.0f%@",(_credit.da * 100),@"%"];
    if (0 <= _credit.da && _credit.da <= 0.25) {
        self.zuan1.hidden = NO;
    }else if (0.25 < _credit.da && _credit.da <= 0.5){
        self.zuan1.hidden = NO;
        self.zuan2.hidden = NO;
    }else if (0.5 < _credit.da && _credit.da <= 0.75){
        self.zuan1.hidden = NO;
        self.zuan2.hidden = NO;
        self.zuan3.hidden = NO;
    }else{
        self.zuan1.hidden = NO;
        self.zuan2.hidden = NO;
        self.zuan3.hidden = NO;
        self.zuan4.hidden = NO;
    }
    self.tihao.text = [NSString stringWithFormat:@"%.0f%@",(_credit.ti * 100),@"%"];
    if (0 <= _credit.ti && _credit.ti <= 0.25) {
        self.zuan5.hidden = NO;
    }else if (0.25 < _credit.ti && _credit.ti <= 0.5){
        self.zuan5.hidden = NO;
        self.zuan6.hidden = NO;
    }else if (0.5 < _credit.ti && _credit.ti <= 0.75){
        self.zuan5.hidden = NO;
        self.zuan6.hidden = NO;
        self.zuan7.hidden = NO;
    }else{
        self.zuan5.hidden = NO;
        self.zuan6.hidden = NO;
        self.zuan7.hidden = NO;
        self.zuan8.hidden = NO;
    }
    NSArray *array1 = [_credit.one componentsSeparatedByString:@","];
    self.one1.text = [NSString stringWithFormat:@"%@分",array1[0]];
    self.one2.text = [NSString stringWithFormat:@"%@分",array1[1]];
    self.one3.text = [NSString stringWithFormat:@"%@分",array1[2]];
    NSArray *array2 = [_credit.all componentsSeparatedByString:@","];
    self.all1.text = [NSString stringWithFormat:@"%.0f%@",([array2[0] doubleValue] * 100),@"%"];
    self.all2.text = [NSString stringWithFormat:@"%.0f%@",([array2[1] doubleValue] * 100),@"%"];
    self.all3.text = [NSString stringWithFormat:@"%.0f%@",([array2[2] doubleValue] * 100),@"%"];
    NSArray *array3 = [_credit.tinumber componentsSeparatedByString:@","];
    self.ti1.text = [NSString stringWithFormat:@"%@",array3[0]];
    self.ti2.text = [NSString stringWithFormat:@"%@",array3[1]];
    self.ti3.text = [NSString stringWithFormat:@"%@",array3[2]];
    NSArray *array4 = [_credit.danumber componentsSeparatedByString:@","];
    self.da1.text = [NSString stringWithFormat:@"%@",array4[0]];
    self.da2.text = [NSString stringWithFormat:@"%@",array4[1]];
    self.da3.text = [NSString stringWithFormat:@"%@",array4[2]];
    
}

#pragma mark - Action
//返回
- (void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
