//
//  ComplainCell.m
//  问答
//
//  Created by xwbb on 16/2/20.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "ComplainCell.h"
#import "AllQuestionsModel.h"
#import "Common.h"

@implementation ComplainCell

- (void)awakeFromNib {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _bgView.layer.borderWidth = 1.0;
    
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

@end
