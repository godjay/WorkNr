//
//  textViewController.m
//  问答
//
//  Created by lirenjie on 16/3/15.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "textViewController.h"
//#import "EaseMessageViewController.h"
#import "ChatViewController.h"

@interface textViewController () <IChatManagerDelegate>
- (IBAction)zhuce:(id)sender;
- (IBAction)login:(id)sender;
- (IBAction)chat:(id)sender;
- (IBAction)outLine:(id)sender;
@end

@implementation textViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerNotifications];
}

-(void)registerNotifications
{
//    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)dealloc
{
    [self unregisterNotifications];
}

- (IBAction)zhuce:(id)sender {
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:@"lhl123456" password:@"lhl123456" withCompletion:^(NSString *username, NSString *password, EMError *error) {
        if (!error) {
            NSLog(@"注册成功");
        }
    } onQueue:nil];
}

- (IBAction)login:(id)sender {
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:@"lhl123456" password:@"lhl123456" completion:^(NSDictionary *loginInfo, EMError *error) {
        if (!error && loginInfo) {
            NSLog(@"登录成功");
            //获取数据库中数据
            [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
            
            
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
        }
    } onQueue:nil];
    
}

- (IBAction)chat:(id)sender {
    ChatViewController *message = [[ChatViewController alloc] initWithConversationChatter:@"asdasd56416" conversationType:eConversationTypeChat];
    message.title = @"asdasd56416";
    [self.navigationController pushViewController:message animated:YES];
}

- (IBAction)outLine:(id)sender {
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        NSLog(@"退出成功");
    } onQueue:nil];
    
}


@end
