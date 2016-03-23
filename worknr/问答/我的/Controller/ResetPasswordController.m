//
//  ResetPasswordController.m
//  问答
//
//  Created by lirenjie on 16/3/17.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "ResetPasswordController.h"
#import <ProgressHUD.h>
#import "MainTabBarController.h"
#import "RJUser.h"
@interface ResetPasswordController ()
@property (nonatomic,weak)UITextField *text1;
@property (nonatomic,weak)UITextField *text2;
@end

@implementation ResetPasswordController

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
    UIButton *rightB = [UIButton buttonWithType:UIButtonTypeCustom];
    rightB.frame = CGRectMake(0, 0, 40, 30);
    [rightB setTitle:@"完成" forState:UIControlStateNormal];
    rightB.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightB addTarget:self action:@selector(rightBAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightB];
}


- (void)rightBAction{
    if (self.text1.text.length == 0 && self.text2.text.length == 0){
        [ProgressHUD showError:@"请输入密码！"];
    }else{
        if ([self.text1.text isEqualToString:self.text2.text]) {
            [ProgressHUD show:@"请稍等"];
            self.view.userInteractionEnabled = NO;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            //json解析所有格式
            manager.responseSerializer = [AFJSONResponseSerializer
                                          serializerWithReadingOptions:NSJSONReadingAllowFragments];
            
            NSString *urlstr = [NSString stringWithFormat:@"%@user/reset",apiBaseURL];
            NSDictionary *pa = @{
                                 @"phone" : self.phoneNum.text,
                                 @"password_hash" : self.text2.text
                                 };
            [manager POST:urlstr parameters:pa progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [ProgressHUD dismiss];
                if (responseObject == nil) {
                    [ProgressHUD showError:@"用户名尚未注册！"];
                    self.view.userInteractionEnabled = YES;
                }else{
                    NSString *urlString = [NSString stringWithFormat:@"%@user/login",apiBaseURL];
                    NSDictionary *params = @{
                                             @"username" : self.phoneNum.text,
                                             @"password" : self.text2.text
                                             };
                    [defaults setObject:self.phoneNum.text forKey:@"username"];
                    [defaults setObject:self.text2.text forKey:@"password"];
                    [manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        [ProgressHUD dismiss];
                        if (responseObject == nil) {
                            [ProgressHUD showError:@"用户名或密码不正确！"];
                            self.view.userInteractionEnabled = YES;
                        }else{
                            RJUser *user = [RJUser mj_objectWithKeyValues:responseObject];
                            NSNumber *usernum = [NSNumber numberWithInt:user.ID];
                            
                            [defaults setObject:usernum forKey:@"userid"];
                            //存储环信帐号
                            [defaults setObject:user.username forKey:@"Huserid"];
                            [defaults synchronize];
                            
                            NSLog(@"登录成功! %@",responseObject);
                            
                            //环信登录
                            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:user.username password:user.username completion:^(NSDictionary *loginInfo, EMError *error) {
                                if (!error && loginInfo) {
                                    NSLog(@"登录成功");
                                    //获取数据库中数据
                                    [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
                                    
                                    [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                                }
                            } onQueue:nil];
                            
                            self.view.userInteractionEnabled = YES;
                            MainTabBarController *mainTC = [[MainTabBarController alloc] init];
                            self.view.window.rootViewController = mainTC;
                            [ProgressHUD showSuccess:@"开始您的问答吧~"];
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"错误 %@",error);
                        [ProgressHUD dismiss];
                    }];
                    
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }else{
            [ProgressHUD showError:@"密码不一致！"];
        }
    }
}


@end
