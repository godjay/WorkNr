//
//  RefuseView.m
//  问答
//
//  Created by xwbb on 16/2/19.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "RefuseView.h"

@implementation RefuseView

- (void)awakeFromNib
{
    _errorBtn1.layer.cornerRadius = 10.0;
    _errorBtn1.clipsToBounds = YES;
    _errorBtn1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _errorBtn1.layer.borderWidth = 1.0;
    
    _errorBtn2.layer.cornerRadius = 10.0;
    _errorBtn2.clipsToBounds = YES;
    _errorBtn2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _errorBtn2.layer.borderWidth = 1.0;
    
    _errorBtn3.layer.cornerRadius = 10.0;
    _errorBtn3.clipsToBounds = YES;
    _errorBtn3.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _errorBtn3.layer.borderWidth = 1.0;
    
    _errorBtn4.layer.cornerRadius = 10.0;
    _errorBtn4.clipsToBounds = YES;
    _errorBtn4.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _errorBtn4.layer.borderWidth = 1.0;
    
    _textView.layer.cornerRadius = 10.0;
    _textView.clipsToBounds = YES;
    _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textView.layer.borderWidth = 1.0;
    
    _rightBtn.layer.cornerRadius = 10.0;
    _rightBtn.clipsToBounds = YES;
    _rightBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _rightBtn.layer.borderWidth = 1.0;
    
    _reason = [NSString string];
}

//确定按钮
- (IBAction)overOkAction:(UIButton *)sender {
    
    [_textView endEditing:YES];
    NSDictionary *dic = @{@"reason":_reason,@"content":_textView.text};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Hidden-MaskView" object:self userInfo:dic];
}

- (IBAction)chooseBttonAction:(UIButton *)sender {
    if (sender.tag == 400) {
        _errorBtn1.selected = YES;
        _errorBtn2.selected = NO;
        _errorBtn3.selected = NO;
        _errorBtn4.selected = NO;
        _reason = @"回答不正确";
    } else if (sender.tag == 401)
    {
        _errorBtn1.selected = NO;
        _errorBtn2.selected = YES;
        _errorBtn3.selected = NO;
        _errorBtn4.selected = NO;
        _reason = @"长时间未作答";
    } else if (sender.tag == 402)
    {
        _errorBtn1.selected = NO;
        _errorBtn2.selected = NO;
        _errorBtn3.selected = YES;
        _errorBtn4.selected = NO;
        _reason = @"回答不详细";
    } else if (sender.tag == 403)
    {
        _errorBtn1.selected = NO;
        _errorBtn2.selected = NO;
        _errorBtn3.selected = NO;
        _errorBtn4.selected = YES;
        _reason = @"回答与问题无关";
    }
}


@end
