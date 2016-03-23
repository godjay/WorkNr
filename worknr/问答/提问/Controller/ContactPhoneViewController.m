//
//  ContactPhoneViewController.m
//  问答
//
//  Created by lirenjie on 16/3/22.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "ContactPhoneViewController.h"

@interface ContactPhoneViewController ()

{
    NSTimer *_timer;
    int index;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *yanzhengma;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (assign,nonatomic) NSString *yanzhengstring;

@end

@implementation ContactPhoneViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [_timer invalidate];
    _timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.getButton setTitle:@"60 s" forState:UIControlStateDisabled];
    self.getButton.layer.borderWidth = 1.0;
    self.getButton.layer.borderColor = [UIColor grayColor].CGColor;
    self.getButton.layer.cornerRadius = 10.0;
    self.getButton.clipsToBounds = YES;
    
    self.sign_In.layer.cornerRadius = 10.0;
    self.sign_In.layer.borderWidth = 1.0;
    self.sign_In.layer.borderColor = [UIColor grayColor].CGColor;
    self.sign_In.clipsToBounds = YES;
    
}

- (IBAction)goBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//获得验证码
- (IBAction)getBtnAction:(UIButton *)sender {
    
    if (self.phoneNum.text.length == 0) {
        [ProgressHUD showError:@"请输入正确的手机号"];
    }else{
        AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
        //json解析所有格式
        manger.responseSerializer = [AFJSONResponseSerializer
                                     serializerWithReadingOptions:NSJSONReadingAllowFragments];
        NSString *urlString = [NSString stringWithFormat:@"%@user/sendcode",apiBaseURL];
        NSDictionary *params = @{
                                 @"mobiles" : self.phoneNum.text
                                 };
        [manger POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            if (responseObject == nil) {
                [ProgressHUD showError:@"手机号格式错误"];
            }else{
                sender.enabled = NO;
                
                if (!_timer) {
                    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerBAction:) userInfo:nil repeats:YES];
                }
                index = 60;
                _yanzhengstring = responseObject;
            }
            NSLog(@"成功  %@",responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            
        }];
    }
}

//绑定
- (IBAction)sign_inBtnAction:(UIButton *)sender {
    
    if ([_yanzhengma.text isEqualToString:_yanzhengstring]) {
        AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
        //json解析所有格式
        manger.responseSerializer = [AFJSONResponseSerializer
                                     serializerWithReadingOptions:NSJSONReadingAllowFragments];
        NSString *urlString = [NSString stringWithFormat:@"%@user/register",apiBaseURL];
        NSDictionary *params = @{
                                 @"username" : self.phoneNum.text,
                                 @"password_hash" : self.password.text
                                 };
        [manger POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            if (responseObject != nil){
                //环信注册
                [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:responseObject[@"username"] password:responseObject[@"username"] withCompletion:^(NSString *username, NSString *password, EMError *error) {
                    if (!error) {
                        NSLog(@"注册成功");
                    }
                } onQueue:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [ProgressHUD showError:@"用户名已存在"];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }else{
        [ProgressHUD showError:@"请输入正确的验证码！"];
    }
    
}

#pragma mark - NSTimer
- (void)timerBAction:(NSTimer *)timer
{
    index --;
    [_getButton setTitle:[NSString stringWithFormat:@"%d s",index] forState:UIControlStateDisabled];
    if (index <= 0) {
        _getButton.enabled = YES;
        
        [_timer invalidate];
        _timer = nil;
    }
}



@end
