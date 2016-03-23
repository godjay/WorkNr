//
//  RJCommentFrame.h
//  问答
//
//  Created by lirenjie on 16/3/18.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RJComment;
@interface RJCommentFrame : NSObject
@property (nonatomic, assign) CGRect iconViewF;
@property (nonatomic, assign) CGRect nickNameF;
@property (nonatomic, assign) CGRect contenLabelF;
@property (nonatomic, assign) CGRect timeLabelF;
@property (nonatomic, assign) CGRect sepViewF;

@property (nonatomic, assign) CGFloat cellHight;

@property (strong,nonatomic)RJComment *comment;

@end
