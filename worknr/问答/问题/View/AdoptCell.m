//
//  AdoptCell.m
//  问答
//
//  Created by xwbb on 16/2/19.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "AdoptCell.h"
#import "QDetailViewController.h"
#import "BaseNavigationController.h"
#import "AllQuestionsModel.h"
#import "Common.h"

@implementation AdoptCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _bgView.layer.borderWidth = 1.0;
    
    _adoptBtn.layer.cornerRadius = 8.0;
    _adoptBtn.clipsToBounds = YES;
    _adoptBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _adoptBtn.layer.borderWidth = 1.0;
    
    _refuseBtn.layer.cornerRadius = 8.0;
    _refuseBtn.clipsToBounds = YES;
    _refuseBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _refuseBtn.layer.borderWidth = 1.0;
    
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

#pragma mark - Action
- (IBAction)adoptBtnAction:(UIButton *)sender {

    [self pushWithType:QDetailVCShowTypeAccept];
}

- (IBAction)refuseBtnAction:(UIButton *)sender {

    [self pushWithType:QDetailVCShowTypeRefuse];
}

- (void)pushWithType:(QDetailVCShowType)type {
    UINavigationController *nav = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers[1];
    QDetailViewController *qDetailVC = [[QDetailViewController alloc] initWithShowType:type];
    qDetailVC.qid = _model.qid;
    [nav pushViewController:qDetailVC animated:YES];
}

@end
