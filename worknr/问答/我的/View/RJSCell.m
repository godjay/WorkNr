//
//  RJSCell.m
//  问答
//
//  Created by lirenjie on 16/3/11.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "RJSCell.h"

@implementation RJSCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(10, self.frame.size.height - 0.5, kScreenWidth, 0.5)];
        sepView.backgroundColor = [UIColor lightGrayColor];
        sepView.alpha = 0.5;
        [self.contentView addSubview:sepView];
    }
    return self;
}

@end
