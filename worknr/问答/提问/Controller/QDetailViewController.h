//
//  QDetailViewController.h
//  问答
//
//  Created by xwbb on 16/2/17.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, QDetailVCShowType) {
    /**默认*/
    QDetailVCShowTypeDefault,
    /**采纳*/
    QDetailVCShowTypeAccept,
    /**未采纳*/
    QDetailVCShowTypeRefuse,
};

@interface QDetailViewController : BaseViewController

- (instancetype)initWithShowType:(QDetailVCShowType)showType;

@property (nonatomic , assign) int qid;
@property (nonatomic , assign) int rid;
@property (nonatomic , assign) int cid;
@property (nonatomic , copy) NSString *content; //追问内容

@end
