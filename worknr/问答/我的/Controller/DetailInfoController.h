//
//  DetailInfoController.h
//  问答
//
//  Created by lirenjie on 16/2/21.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RJFans.h"
typedef NS_ENUM(NSUInteger, DetailInfoShowType) {
    /**默认*/
    DetailInfoShowTypeDefault,
    /**已关注*/
    DetailInfoShowTypeA,
};


@interface DetailInfoController : UITableViewController
@property (nonatomic,strong)RJFans *fan;
@property (copy, nonatomic) NSString *commentStr;

- (instancetype)initWithShowType:(DetailInfoShowType)showType;

@end
