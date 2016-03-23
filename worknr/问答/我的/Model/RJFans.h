//
//  RJFans.h
//  问答
//
//  Created by lirenjie on 16/3/16.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RJFans : NSObject
@property (copy, nonatomic) NSURL *pic;//用户头像
@property (copy, nonatomic) NSString *nickname;//用户昵称
@property (copy, nonatomic) NSString *identity;//用户身份
@property (copy, nonatomic) NSString *username;//用户id
@property (assign,nonatomic) int ID;//用户id
@property (copy, nonatomic) NSString *introduce;
@property (copy, nonatomic) NSString *label;

@end
/*
 alipay = "\U7ea2\U5305";
 area = "\U90d1\U5dde\U5e02";
 "auth_key" = 1;
 "created_at" = 0;
 "display_name" = afa;
 email = "62352478@we.com";
 hxname = "<null>";
 hxpassword = "<null>";
 nd = 0;
 "password_hash" = 111111;
 "password_reset_token" = "<null>";
 phone = 18037759803;
 role = 0;
 sex = "\U5973";
 status = 0;
 thirdname = "\U5fae\U4fe1";
 thirdpassword = fsdfsd;
 "updated_at" = 0;
 username = 18037759803;
*/