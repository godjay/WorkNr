//
//  TWViewController.m
//  问答
//
//  Created by xwbb on 16/2/17.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "TWViewController.h"
#import "TWDetailViewController.h"
#import "QTViewController.h"
#import "MaskView.h"
#import "Common.h"
#import "ViewController.h"
#import "ContactPhoneViewController.h"
@interface TWViewController ()

{
    UIControl *_maskView;
}

@end

@implementation TWViewController

- (void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HiddenMaskView" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [ProgressHUD dismiss];
    if (USER != nil) {
        AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
        
        //json解析所有格式
        manger.responseSerializer = [AFJSONResponseSerializer
                                     serializerWithReadingOptions:NSJSONReadingAllowFragments];
        NSString *urlString = [NSString stringWithFormat:@"%@user/login",apiBaseURL];
        NSDictionary *params = @{
                                 @"username" : USERNAME,
                                 @"password" : PASSWORD
                                 };
        [manger POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    if ([PHONE isEqualToString:@"99999999999"]) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"绑定手机" message:@"如果QQ微博无法登录，您可以通过手机登录?" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertC animated:YES completion:nil];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"确定");
            ContactPhoneViewController *con = [[ContactPhoneViewController alloc] initWithNibName:@"ContactPhoneViewController" bundle:nil];
            [self presentViewController:con animated:YES completion:nil];
            
        }];
        [alertC addAction:action1];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"跳过" style:UIAlertActionStyleCancel handler:nil];
        [alertC addAction:action2];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"工作牛人";
    
    [self _createButton];
    [self _createMaskView];
    
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenMaskView) name:@"HiddenMaskView" object:nil];
    
}

- (void)_createButton
{
    //抢题设置按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 25, 5);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"点.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(setupAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //我要提问按钮
    UIButton *twButton = [UIButton buttonWithType:UIButtonTypeCustom];
    twButton.frame = CGRectMake(0, 150, kScreenWidth, 100);
    twButton.backgroundColor = [UIColor whiteColor];
    [twButton setTitle:@"我要提问" forState:UIControlStateNormal];
    [twButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //修改文字在按钮上的位置
    twButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 90);
    twButton.titleLabel.font =[UIFont systemFontOfSize:15];
    twButton.layer.borderWidth = 1.0;
    twButton.layer.borderColor = [UIColor grayColor].CGColor;
    [twButton addTarget:self action:@selector(tiwenAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:twButton];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((twButton.width - 50) / 2 + 20, (twButton.height - 50) / 2, 50, 50)];
    imageView.image = [UIImage imageNamed:@"信息.png"];
    [twButton addSubview:imageView];
    
    //我要抢答按钮
    UIButton *qtButton = [UIButton buttonWithType:UIButtonTypeCustom];
    qtButton.frame = CGRectMake(0, 260, kScreenWidth, 100);
    qtButton.backgroundColor = [UIColor whiteColor];
    [qtButton setTitle:@"我要抢题" forState:UIControlStateNormal];
    [qtButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //修改文字在按钮上的位置
    qtButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 90);
    qtButton.titleLabel.font =[UIFont systemFontOfSize:15];
    qtButton.layer.borderWidth = 1.0;
    qtButton.layer.borderColor = [UIColor grayColor].CGColor;
    [qtButton addTarget:self action:@selector(qiangtiAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qtButton];
    
    //开关
    UISwitch *_switch = [[UISwitch alloc] initWithFrame:CGRectMake((qtButton.width - 50) / 2 + 20, qtButton.height / 2 - 15, 50, 50)];
    [_switch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    _switch.on = YES;
    [qtButton addSubview:_switch];
}

- (void)_createMaskView
{
    _maskView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    //设置背景颜色
    _maskView.backgroundColor = [UIColor colorWithWhite:.8 alpha:.5];
    //隐藏遮罩视图
    _maskView.hidden = YES;
    [self.tabBarController.view addSubview:_maskView];
    
    MaskView *view = [[MaskView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 350)];
    [_maskView addSubview:view];
}

#pragma mark - Action
//提问事件
- (void)tiwenAction
{
    if (USER != nil) {
        TWDetailViewController *detailVC = [[TWDetailViewController alloc] init];
        [self.navigationController pushViewController:detailVC animated:YES];
        
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
//抢题事件
- (void)qiangtiAction
{
    if (USER != nil) {
        QTViewController *qtVC = [[QTViewController alloc] init];
        [self.navigationController pushViewController:qtVC animated:YES];
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
//开关事件
-(void)switchAction:(UISwitch*)sw{
    
    if (sw.on) {
        NSLog(@"开");
    }
}
//设置事件
- (void)setupAction
{
    if (USER != nil) {
        _maskView.hidden = NO;
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

#pragma mark - Notification
- (void)hiddenMaskView
{
    _maskView.hidden = YES;
}

@end
