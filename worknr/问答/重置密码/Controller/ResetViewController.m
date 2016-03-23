//
//  ResetViewController.m
//  问答
//
//  Created by xwbb on 16/2/17.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "ResetViewController.h"
#import <ProgressHUD.h>
#import "ResetPasswordController.h"
#import "BaseNavigationController.h"
@interface ResetViewController ()

{
    NSTimer *_timer;
    int index;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (assign,nonatomic) NSString *yanzhengstring;
@property (weak, nonatomic) IBOutlet UITextField *yanzhengma;

@end

@implementation ResetViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"重置密码";

    [self.getButton setTitle:@"60 s" forState:UIControlStateDisabled];
    self.getButton.layer.borderWidth = 1.0;
    self.getButton.layer.borderColor = [UIColor grayColor].CGColor;
    self.getButton.layer.cornerRadius = 10.0;
    self.getButton.clipsToBounds = YES;
    
    self.loginButton.layer.cornerRadius = 10.0;
    self.loginButton.layer.borderWidth = 1.0;
    self.loginButton.layer.borderColor = [UIColor grayColor].CGColor;
    self.loginButton.clipsToBounds = YES;
    
    
}

#pragma mark - Action
//重置密码登录
- (IBAction)resetLoginAction:(UIButton *)sender {
    
    if ([_yanzhengma.text isEqualToString:_yanzhengstring]) {
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"登录成功" message:@"请进入[设置]项,及时修改密码" preferredStyle:UIAlertControllerStyleAlert];
        //弹出提示框
        [self presentViewController:alertCtrl animated:YES completion:nil];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ResetPasswordController *changeP = [[ResetPasswordController alloc] init];
            changeP.phoneNum = self.phoneNum;
            BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:changeP];
            self.view.window.rootViewController = nav;
        }];
        [alertCtrl addAction:action1];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertCtrl addAction:action2];
    }else{
        [ProgressHUD showError:@"请输入正确的验证码！"];
    }
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

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
