//
//  CommentCell.m
//  问答
//
//  Created by xwbb on 16/2/20.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "CommentCell.h"
#import "AllQuestionsModel.h"
#import "Common.h"
#import "CommunicationViewController.h"

@implementation CommentCell

- (void)awakeFromNib {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _bgView.layer.borderWidth = 1.0;
    
    _adoptBtn.layer.cornerRadius = 8.0;
    _adoptBtn.clipsToBounds = YES;
    _adoptBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _adoptBtn.layer.borderWidth = 1.0;
    
    _alertBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _alertBtn.layer.borderWidth = 1.0;
}

- (void)setModel:(AllQuestionsModel *)model
{
    _model = model;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM-dd HH:MM"];
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:[_model.ctime intValue]];
    NSString *dateString = [formatter stringFromDate:date1];
    _timeL.text = dateString;
    _contentL.text = _model.content;
}

- (IBAction)adoptBtnAction:(UIButton *)sender {
    NSLog(@"采纳");
    UINavigationController *nav = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers[1];
    CommunicationViewController *commVC = [[CommunicationViewController alloc] initWithShowType:CommunicationShowA questionId:_model.qid];
    commVC.uid = _model.uid;
    [nav pushViewController:commVC animated:YES];
}

@end
