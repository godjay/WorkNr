//
//  AllQuestionsModel.h
//  问答
//
//  Created by xwbb on 16/3/10.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllQuestionsModel : NSObject

@property (nonatomic , assign) NSNumber *ctime; //时间
@property (nonatomic , copy) NSString *content; //问题内容
@property (nonatomic , assign) NSInteger status; //状态
@property (nonatomic , assign) NSInteger givend; //悬赏
@property (nonatomic , assign) int qid; //问题Id
@property (nonatomic , assign) int uid; //问题人的Id


@end
