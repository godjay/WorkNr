//
//  AnswerCell.m
//  问答
//
//  Created by xwbb on 16/3/18.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "AnswerCell.h"
#import "ChatModel.h"
#import "WTUserInfoController.h"
#import "UIButton+EMWebCache.h"

@implementation AnswerCell

- (void)awakeFromNib {
    
    _iconBtn.layer.cornerRadius = 35 / 2;
    _iconBtn.clipsToBounds = YES;
    
}

- (void)setModel:(ChatModel *)model
{
    _model = model;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_model.givend != 0) {
        
        _niuDouL.text = [NSString stringWithFormat:@"%.1f牛豆",_model.givend];
        
    } else
    {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"MM-dd HH:MM"];
        NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:[_model.ctime intValue]];
        NSString *dateString = [formatter stringFromDate:date1];
        _niuDouL.text = dateString;
    }
    _nameL.text = _model.nickname;
    _contentL.text = _model.content;
    NSURL *url = [NSURL URLWithString:_model.pic];
    [_iconBtn sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Q Q"]];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    UIImage *image = [UIImage imageWithData:data];
//    [_iconBtn setImage:image forState:UIControlStateNormal];
    
}

- (IBAction)iconBtnClick:(UIButton *)sender {
    UINavigationController *nav = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers[1];
    WTUserInfoController *wtUser = [[WTUserInfoController alloc] initWithShowType:DetailInfoShowTypeDefault];
    wtUser.model = self.model;
    [nav pushViewController:wtUser animated:YES];
}

@end
