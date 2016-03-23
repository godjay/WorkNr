//
//  TWUserInfoController.h
//  问答
//
//  Created by lirenjie on 16/3/21.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatModel.h"
typedef NS_ENUM(NSUInteger, DetailInfoShowType) {
    /**默认*/
    DetailInfoShowTypeDefault,
    /**已关注*/
    DetailInfoShowTypeA,
};

@interface TWUserInfoController : UITableViewController
@property (copy, nonatomic) NSString *commentStr;
@property (nonatomic , strong) ChatModel *model;

- (instancetype)initWithShowType:(DetailInfoShowType)showType;

@end
