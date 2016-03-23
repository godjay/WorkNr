//
//  UIUtils.h
//  WXWeibo
//
//  Created by Qingwu Zheng on 12-7-22.
//  Copyright (c) 2012年 www.iphonetrain.com 无限互联ios开发培训中心 All rights
//  reserved.
//

#import <Foundation/Foundation.h>
//#import "CONSTS.h"

@interface UIUtils : NSObject

//获取documents下的文件路径
+ (NSString *)getDocumentsPath:(NSString *)fileName;

//将原始日期字符串转换为固定格式的字符串
+ (NSString *)fomateString:(NSString *)datestring;

//
+ (NSString *)dateAgo:(NSString *)dateString;

//
+ (NSString *)subSoucreText:(NSString *)soucreText;

@end
