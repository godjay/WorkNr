//
//  ChangePassViewController.m
//  问答
//
//  Created by lirenjie on 16/2/21.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "ChangePassViewController.h"
#import <ProgressHUD.h>
@interface ChangePassViewController ()
@property (nonatomic,weak)UITextField *text1;
@property (nonatomic,weak)UITextField *text2;

@end

@implementation ChangePassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:236 / 255.0 green:237 /255.0 blue:239 /255.0 alpha:1];

    [self setupNav];
    [self setupView];

}

- (void)setupView{
    UILabel *bgLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 74, kScreenWidth, 40)];
    bgLabel1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    bgLabel1.layer.borderWidth = 0.8;
    bgLabel1.userInteractionEnabled = YES;
    [self.view addSubview:bgLabel1];
    
    UILabel *tLable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 70, 20)];
    tLable1.text = @"密码";
    tLable1.font = [UIFont systemFontOfSize:14];
    tLable1.textAlignment = 2;
    [bgLabel1 addSubview:tLable1];
    
    UITextField *text1 = [[UITextField alloc] initWithFrame:CGRectMake(tLable1.right+10, 10, kScreenWidth - tLable1.width, 20)];
//    text1.borderStyle = 0;
    text1.placeholder = @"请设置新密码";
    text1.font = [UIFont systemFontOfSize:15];
    text1.secureTextEntry = YES;
    self.text1 = text1;
    [bgLabel1 addSubview:text1];
    
    UILabel *bgLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, bgLabel1.bottom- 0.8, kScreenWidth, 40)];
    bgLabel2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    bgLabel2.layer.borderWidth = 0.8;
    bgLabel2.userInteractionEnabled = YES;
    [self.view addSubview:bgLabel2];
    
    UILabel *tLable2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 70, 20)];
    tLable2.text = @"确认密码";
    tLable2.font = [UIFont systemFontOfSize:14];
    tLable2.textAlignment = 2;
    [bgLabel2 addSubview:tLable2];
    UITextField *text2 = [[UITextField alloc] initWithFrame:CGRectMake(tLable2.right+10, 10, kScreenWidth - tLable2.width, 20)];
    //    text1.borderStyle = 0;
    text2.placeholder = @"请再次输入";
    text2.font = [UIFont systemFontOfSize:15];
    text2.secureTextEntry = YES;
    self.text2 = text2;
    [bgLabel2 addSubview:text2];
    
}

- (void)setupNav{
    UIButton *leftA = [UIButton buttonWithType:UIButtonTypeCustom];
    leftA.frame = CGRectMake(0, 0, 40, 30);
    [leftA setTitle:@"取消" forState:UIControlStateNormal];
    leftA.titleLabel.font = [UIFont systemFontOfSize:16];
    [leftA addTarget:self action:@selector(leftAAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftA];
    
    UIButton *rightB = [UIButton buttonWithType:UIButtonTypeCustom];
    rightB.frame = CGRectMake(0, 0, 40, 30);
    [rightB setTitle:@"完成" forState:UIControlStateNormal];
    rightB.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightB addTarget:self action:@selector(rightBAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightB];
}

- (void)leftAAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBAction{
    if ([self.text1.text isEqualToString:self.text2.text]) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //json解析所有格式
        manager.responseSerializer = [AFJSONResponseSerializer
                                     serializerWithReadingOptions:NSJSONReadingAllowFragments];

        NSString *urlStr = [NSString stringWithFormat:@"%@user/modify",apiBaseURL];
        NSDictionary *params = @{
                                 @"password" : self.text2.text
                                 };
        [manager POST:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }else{
        [ProgressHUD showError:@"密码不一致！"];
    }
}
@end
