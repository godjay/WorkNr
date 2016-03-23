//
//  CommentCell.h
//  问答
//
//  Created by xwbb on 16/2/20.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AllQuestionsModel;
@interface CommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *adoptBtn;
@property (weak, nonatomic) IBOutlet UIButton *alertBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;


@property (nonatomic , strong) AllQuestionsModel *model;

@end
