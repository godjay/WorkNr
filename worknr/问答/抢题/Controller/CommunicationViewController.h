//
//  CommunicationViewController.h
//  问答
//
//  Created by xwbb on 16/2/24.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSUInteger, CommunicationShowType) {
    /**默认*/
    CommunicationShow,
    /**已申诉*/
    CommunicationShowA,
};
@interface CommunicationViewController : BaseViewController

@property (nonatomic , assign) NSInteger qid;
@property (nonatomic , assign) NSInteger uid;

- (instancetype)initWithShowType:(CommunicationShowType)showType questionId:(NSInteger)qid;
@end
