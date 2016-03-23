//
//  RJUser.h
//  问答
//
//  Created by lirenjie on 16/3/5.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    status0 = 0,
    status1 = 1,
}status;

@interface RJUser : NSObject
@property (copy, nonatomic) NSString *display_name;
@property (copy, nonatomic) NSString *username;//用户手机号作为帐号
@property (copy, nonatomic) NSString *phone;//用户手机号
@property (assign,nonatomic) int ID;//用户id
@property (copy, nonatomic) NSString *password_hash;//密码
@property (assign,nonatomic) status *status;//用户状态信息
@property (copy, nonatomic) NSString *nickname;//用户昵称
@property (copy,nonatomic) NSString *sex;//用户性别
@property (copy, nonatomic) NSString *area;//用户所属地区
@property (copy, nonatomic) NSString *email;//用户邮箱
@property (copy, nonatomic) NSString *alipay;//用户的支付宝帐号
@property (copy, nonatomic) NSURL *pic;//用户头像
@property (assign,nonatomic) int nd;//用户牛豆
@property (copy, nonatomic) NSString *identity;//用户身份
@property (copy, nonatomic) NSString *label;//用户标签，擅长，特长
@property (copy, nonatomic) NSString *introduce;//用户介绍
@property (copy, nonatomic) NSString *thirdpassword;//第三方密码
@property (copy, nonatomic) NSString *thirdname;//第三方帐号
@property (assign,nonatomic) int created_at;//创建时间
@property (assign,nonatomic) int updated_at;//更新时间
@property (copy, nonatomic) NSString *hxname;//环信用户名
@property (copy, nonatomic) NSString *hxpassword;//环信密码

@end
