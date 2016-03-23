//
//  RJComment.h
//  问答
//
//  Created by lirenjie on 16/3/18.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RJUser.h"
@interface RJComment : NSObject
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *time;

@property (strong,nonatomic)RJUser *user;
@end
