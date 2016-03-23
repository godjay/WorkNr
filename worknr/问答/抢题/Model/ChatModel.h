//
//  ChatModel.h
//  问答
//
//  Created by xwbb on 16/3/14.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatModel : NSObject

@property (nonatomic , assign) NSNumber *uid; //当前用户的id
@property (nonatomic , assign) NSNumber *rid; //回答者的id
@property (nonatomic , copy) NSString *nickname; //昵称
@property (nonatomic , copy) NSString *pic; //头像
@property (nonatomic , assign) float givend; //问题悬赏数
@property (nonatomic , copy) NSString *content; //问题内容

@property (nonatomic , copy) NSNumber *ctime; //回答时间

@end
