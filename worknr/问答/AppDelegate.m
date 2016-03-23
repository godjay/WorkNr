//
//  AppDelegate.m
//  问答
//
//  Created by xwbb on 16/2/16.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"

#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "MainTabBarController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[MainTabBarController alloc] init];
    [self.window makeKeyAndVisible];
    //友盟
    [UMSocialData setAppKey:@"56d4f5ab67e58ee1f8002ef4"];
    //QQ
    [UMSocialQQHandler setQQWithAppId:@"1105216936" appKey:@"RqGLFM7K2aT5Shn3" url:@"http://www.umeng.com/social"];
    //微博
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"4161246841" RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"immern#chatdemo" apnsCertName:nil];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

//申请处理时间
//- (void)applicationWillTerminate:(UIApplication *)application {
//    [[EaseMob sharedInstance] applicationWillTerminate:application];
//}

@end
