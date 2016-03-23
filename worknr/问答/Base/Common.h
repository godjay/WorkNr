//
//  Common.h
//  问答
//
//  Created by xwbb on 16/2/16.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#ifndef Common_h
#define Common_h

//#import "AFNetworking.h"
#import "ProgressHUD.h"

#import "UIViewExt.h"
#import "RatingBar.h"
#import "UIUtils.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kNavBarHeight 64
#define kTabBarHeight 49
#define USER [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]
#define HUSER [[NSUserDefaults standardUserDefaults] objectForKey:@"Huserid"]
#define USERNAME [[NSUserDefaults standardUserDefaults] objectForKey:@"username"]
#define PASSWORD [[NSUserDefaults standardUserDefaults] objectForKey:@"password"]
#define USERPIC [[NSUserDefaults standardUserDefaults] objectForKey:@"userpic"]
#define USERNICK [[NSUserDefaults standardUserDefaults] objectForKey:@"usernick"]
#define PHONE [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"]

#define apiBaseURL @"http://youchuang.com.tunnel.qydev.com/index.php/"

#endif /* Common_h */
