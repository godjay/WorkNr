//
//  UIUtils.m
//  WXWeibo
//
//  Created by Qingwu Zheng on 12-7-22.
//  Copyright (c) 2012年 www.iphonetrain.com 无限互联ios开发培训中心 All rights
//  reserved.
//

#import "UIUtils.h"
#import <CommonCrypto/CommonDigest.h>

#import "NSDate+TimeAgo.h"

@implementation UIUtils

+ (NSString *)getDocumentsPath:(NSString *)fileName {

  //两种获取document路径的方式
  // 1.
  // NSString *documents =
  //    [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];

  // 2.
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                       NSUserDomainMask, YES);

  NSString *documents = [paths objectAtIndex:0];
  NSString *path = [documents stringByAppendingPathComponent:fileName];

  return path;
}

// date 格式化为 string
+ (NSString *)stringFromDate:(NSDate *)date formate:(NSString *)formate {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:formate];
  NSString *str = [formatter stringFromDate:date];
  return str;
}

// string 格式化为 date
+ (NSDate *)dateFromString:(NSString *)datestring formate:(NSString *)formate {
  // 1.设置date对象的格式 E MMM d HH:mm:ss Z yyyy
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:formate];

  // 2.设置时区
  NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
  [formatter setLocale:locale];

  // 3.转换生成date
  NSDate *date = [formatter dateFromString:datestring];
  return date;
}

// 原始：Sat Jan 12 11:50:16 +0800 2013
// 转换：01-12 11:50
+ (NSString *)fomateString:(NSString *)datestring {
  //原字符串 ---> Data
  NSString *formate = @"E MMM d HH:mm:ss Z yyyy";
  NSDate *createDate = [UIUtils dateFromString:datestring formate:formate];

  // Date ---> 新字符串
  NSString *newFormate = @"MM-dd HH:mm";
  NSString *text = [UIUtils stringFromDate:createDate formate:newFormate];

  return text;
}

+ (NSString *)dateAgo:(NSString *)dateString;
{
  //原字符串 ---> Data
  NSString *formate = @"E MMM d HH:mm:ss Z yyyy";
  NSDate *createDate = [UIUtils dateFromString:dateString formate:formate];
  
  return [createDate dateTimeAgo];
}

+ (NSString *)subSoucreText:(NSString *)soucreText;
{
  //soureText 来源字符串
  //"<a href="http://weibo.com" rel="nofollow">新浪微博</a>"
  
  NSInteger startLocation = [soucreText rangeOfString:@">"].location;
  
  //如果来源为空
  if (startLocation == NSNotFound) {
    return nil;
  }
  
  NSInteger endLocation = [soucreText rangeOfString:@"<" options:NSBackwardsSearch].location;
  
  NSInteger strLen = endLocation - (startLocation + 1);
  
  return [soucreText substringWithRange:NSMakeRange(startLocation + 1, strLen)];

}

@end
