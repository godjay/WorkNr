//
//  LoginViewController.h
//  问答
//
//  Created by xwbb on 16/2/16.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface LoginViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UIButton *signin;

@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UIButton *wxLogin;
@property (weak, nonatomic) IBOutlet UIButton *qqLogin;
@property (weak, nonatomic) IBOutlet UIButton *wbLogin;


@end
