//
//  WTViewController.h
//  问答
//
//  Created by xwbb on 16/2/19.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "BaseViewController.h"
#import "AdoptTableView.h"
#import "CommentTableView.h"
#import "ComplainTableView.h"
#import "MyQuestionTableView.h"
#import "MyAnswerTableView.h"

@interface WTViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentLevelOne;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentLevelTwo1;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentLevelTwo2;

@property (weak, nonatomic) IBOutlet AdoptTableView *adoptTableView;
@property (weak, nonatomic) IBOutlet CommentTableView *commentTableView;
@property (weak, nonatomic) IBOutlet ComplainTableView *complainTableView;
@property (weak, nonatomic) IBOutlet MyQuestionTableView *myQuestionTableView;
@property (weak, nonatomic) IBOutlet MyAnswerTableView *myAnswerTableView;


@end
