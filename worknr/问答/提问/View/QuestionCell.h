//
//  QuestionCell.h
//  问答
//
//  Created by xwbb on 16/2/17.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class ChatModel;
@interface QuestionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *niuDouL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;

@property (nonatomic , strong) ChatModel *model;

@end
