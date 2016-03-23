//
//  MyQuestionCell.h
//  问答
//
//  Created by xwbb on 16/2/20.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class AllQuestionsModel;
@interface MyQuestionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *alertBtn;

@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UIImageView *isAdoptImageV;
@property (weak, nonatomic) IBOutlet UILabel *content;

@property (assign,nonatomic) int rid;

@property (nonatomic , strong) AllQuestionsModel *model;

@end
