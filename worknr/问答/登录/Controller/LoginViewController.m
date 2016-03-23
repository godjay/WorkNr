//
//  LoginViewController.m
//  问答
//
//  Created by xwbb on 16/2/16.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "LoginViewController.h"
#import "MainTabBarController.h"
#import "UIViewExt.h"
#import "UMSocial.h"
#import <ProgressHUD.h>
#import "RJUser.h"
@interface LoginViewController () <IChatManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation LoginViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [self registerNotifications];
}

-(void)registerNotifications
{
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"登录";
    //修改界面
    self.login.layer.cornerRadius = 5.0;
    self.login.clipsToBounds = YES;
    self.signin.layer.cornerRadius = 5.0;
    self.signin.clipsToBounds = YES;
    self.loginLabel.frame = CGRectMake(self.login.left, self.login.bottom + 50, 100, 21);
    self.wxLogin.layer.cornerRadius = 5.0;
    self.wxLogin.clipsToBounds = YES;
    self.wxLogin.frame = CGRectMake(80, self.loginLabel.bottom + 30, 50, 50);
    self.qqLogin.layer.cornerRadius = 5.0;
    self.qqLogin.clipsToBounds = YES;
    self.qqLogin.frame = CGRectMake(180, self.wxLogin.top, 50, 50);
    self.wbLogin.layer.cornerRadius = 5.0;
    self.wbLogin.clipsToBounds = YES;
    self.wbLogin.frame = CGRectMake(280, self.wxLogin.top, 50, 50);
    
    
}

-(void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)dealloc
{
    [self unregisterNotifications];
}

#pragma mark - Action
//登录
- (IBAction)loginAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (self.username.text.length != 0 && self.password.text.length != 0) {
        [ProgressHUD show:@"正在登录"];
        self.view.userInteractionEnabled = NO;
        AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
        
        //json解析所有格式
        manger.responseSerializer = [AFJSONResponseSerializer
                                     serializerWithReadingOptions:NSJSONReadingAllowFragments];
        NSString *urlString = [NSString stringWithFormat:@"%@user/login",apiBaseURL];
        NSDictionary *params = @{
                                 @"username" : self.username.text,
                                 @"password" : self.password.text
                                 };
        [defaults setObject:self.username.text forKey:@"username"];
        [defaults setObject:self.password.text forKey:@"password"];
        [manger POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [ProgressHUD dismiss];
            NSLog(@".....%@",responseObject);
            
            if (responseObject == nil) {
                [ProgressHUD showError:@"用户名或密码不正确！"];
                self.view.userInteractionEnabled = YES;
            }else{
                self.view.userInteractionEnabled = YES;
                
                RJUser *user = [RJUser mj_objectWithKeyValues:responseObject];
                NSNumber *usernum = [NSNumber numberWithInt:user.ID];
                
                [defaults setObject:usernum forKey:@"userid"];
                NSString *picstr = [NSString stringWithFormat:@"%@",user.pic];
                [defaults setObject:picstr forKey:@"userpic"];
                [defaults setObject:user.nickname forKey:@"usernick"];
                [defaults setObject:user.phone forKey:@"phone"];
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
                [ProgressHUD showSuccess:@"牛人请开始工作吧~"];

                self.view.userInteractionEnabled = YES;
                MainTabBarController *mainTC = [[MainTabBarController alloc] init];
                self.view.window.rootViewController = mainTC;

            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"错误 %@",error);
        }];
    }else{
        [ProgressHUD showError:@"手机或密码不能为空!"];
    }
    
}

//微信
- (IBAction)wxLoginAction:(UIButton *)sender {
    NSLog(@"微信");
}

//QQ
- (IBAction)qqLoginAction:(UIButton *)sender {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            [ProgressHUD show:@"跳转中"];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
            NSString *Str = [NSString stringWithFormat:@"%@user/thirdlogin",apiBaseURL];
            NSDictionary *params = @{
                                     @"nickname" : snsAccount.userName,
                                     @"role" : snsAccount.usid,
                                     @"pic" : snsAccount.iconURL
                                     };
            [manager POST:Str parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@" 3Q  %@",responseObject);
                
                RJUser *user = [RJUser mj_objectWithKeyValues:responseObject];
                NSNumber *usernum = [NSNumber numberWithInt:user.ID];
                [defaults setObject:usernum forKey:@"userid"];
                NSString *picstr = [NSString stringWithFormat:@"%@",user.pic];
                [defaults setObject:picstr forKey:@"userpic"];
                [defaults setObject:user.nickname forKey:@"usernick"];
                [defaults setObject:user.phone forKey:@"phone"];

                //存储环信帐号
                [defaults setObject:user.username forKey:@"Huserid"];
                [defaults synchronize];
                
                NSLog(@"登录成功! %@",responseObject);
                //环信注册
                [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:user.username password:user.username withCompletion:^(NSString *username, NSString *password, EMError *error) {
                    if (!error) {
                        NSLog(@"注册成功");
                        //环信登录
                        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:user.username password:user.username completion:^(NSDictionary *loginInfo, EMError *error) {
                            if (!error && loginInfo) {
                                NSLog(@"登录成功");
                                //获取数据库中数据
                                [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
                                
                                [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                            }
                        } onQueue:nil];
                    }
                } onQueue:nil];

                //环信登录
                [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:user.username password:user.username completion:^(NSDictionary *loginInfo, EMError *error) {
                    if (!error && loginInfo) {
                        NSLog(@"登录成功");
                        //获取数据库中数据
                        [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
                        
                        [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                    }
                } onQueue:nil];
                [ProgressHUD showSuccess:@"牛人请开始工作吧~"];
                
                self.view.userInteractionEnabled = YES;

                //跳转界面
                MainTabBarController *mainTC = [[MainTabBarController alloc] init];
                self.view.window.rootViewController = mainTC;
                [ProgressHUD dismiss];

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
                [ProgressHUD dismiss];
                [ProgressHUD showError:@"连接不上服务器"];
            }];
            
        }});
}

//微博
- (IBAction)wbLoginAction:(UIButton *)sender {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            //跳转界面
            MainTabBarController *mainTC = [[MainTabBarController alloc] init];
            self.view.window.rootViewController = mainTC;
        }});
}

@end
