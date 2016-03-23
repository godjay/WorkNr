//
//  RJDetailCell.m
//  问答
//
//  Created by lirenjie on 16/2/21.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "RJDetailCell.h"

@interface RJDetailCell()


@end


@implementation RJDetailCell


- (void)awakeFromNib {
    _tagL.layer.borderWidth = 1.0;
    _tagL.layer.borderColor = [UIColor grayColor].CGColor;
    _tagL.layer.cornerRadius = 10.0;
    _tagL.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
