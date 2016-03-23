//
//  QuestionCell.m
//  问答
//
//  Created by xwbb on 16/2/17.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "QuestionCell.h"
#import "WTUserInfoController.h"
#import "ChatModel.h"
#import "UIButton+EMWebCache.h"
@interface QuestionCell ()


@end

@implementation QuestionCell

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
    
    if (_model.givend == 0) {
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"MM-dd HH:MM"];
        NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:[_model.ctime intValue]];
        NSString *dateString = [formatter stringFromDate:date1];
        _niuDouL.text = dateString;
        
    } else
    {
        _niuDouL.text = [NSString stringWithFormat:@"%.1f牛豆",_model.givend];
    }
    _nameL.text = _model.nickname;
    _contentL.text = _model.content;
    NSURL *picurl = [NSURL URLWithString:_model.pic];
    [_iconBtn sd_setImageWithURL:picurl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Q Q"]];
//    NSData *picdata = [NSData dataWithContentsOfURL:picurl];
//    UIImage *image = [UIImage imageWithData:picdata];
//    
//    [_iconBtn setImage:image forState:UIControlStateNormal];
    
}

- (IBAction)iconClick:(id)sender {
    UINavigationController *nav = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers[1];
    WTUserInfoController *wtUser = [[WTUserInfoController alloc] initWithShowType:DetailInfoShowTypeDefault];
    wtUser.model = self.model;
    [nav pushViewController:wtUser animated:YES];
    
}
@end
