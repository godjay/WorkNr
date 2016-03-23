//
//  MyQuestionCell.m
//  问答
//
//  Created by xwbb on 16/2/20.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "MyQuestionCell.h"
#import "AllQuestionsModel.h"
#import "MyAnswerTableView.h"
#import "MyQuestionTableView.h"
#import "Common.h"

@implementation MyQuestionCell

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
    _content.text = _model.content;
    switch (_model.status) {
        case 2:
            _isAdoptImageV.image = [UIImage imageNamed:@"weicaina.png"];
            break;
        case 3:
            _isAdoptImageV.image = [UIImage imageNamed:@"已采纳.png"];
            break;
        default:
            _isAdoptImageV.image = nil;
            break;
    }
    
    if ([self.superview isKindOfClass:[MyQuestionTableView class]]) {
        NSString *alertBtnT = [NSString string];
        switch (_model.status) {
            case 1:
                alertBtnT = @"对方回答了您的问题";
                break;
            case 2:
                alertBtnT = @"未采纳";
                break;
            case 4:
                alertBtnT = @"您采纳了该问题";
                break;
                
            default:
                break;
        }
        [_alertBtn setTitle:alertBtnT forState:UIControlStateNormal];
    } else if ([self.superview isKindOfClass:[MyAnswerTableView class]])
    {
        NSString *alertBtnT = [NSString string];
        switch (_model.status) {
            case 1:
                alertBtnT = @"对方追问了您的答案";
                break;
            case 2:
                alertBtnT = @"未采纳";
                break;
            case 4:
                alertBtnT = [NSString stringWithFormat:@"得到%ld牛豆",_model.givend];
                break;
                
            default:
                break;
        }
        [_alertBtn setTitle:alertBtnT forState:UIControlStateNormal];
    }
    
}

@end
