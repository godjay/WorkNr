//
//  RJPersonalDetialCell.m
//  问答
//
//  Created by lirenjie on 16/2/20.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "RJPersonalDetialCell.h"
#import "Common.h"
@implementation RJPersonalDetialCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
        titleL.font = [UIFont systemFontOfSize:16];
        _titleL = titleL;
        [self.contentView addSubview:titleL];
        
        UILabel *lastL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 200, 10, 170, 20)];
        lastL.font = [UIFont systemFontOfSize:15];
        lastL.textAlignment = 2;
        _lastL = lastL;
        [self.contentView addSubview:lastL];
        
        UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(10, self.frame.size.height - 0.5, kScreenWidth, 0.5)];
        sepView.backgroundColor = [UIColor lightGrayColor];
        sepView.alpha = 0.5;
        [self.contentView addSubview:sepView];
    }
    return self;
}

@end
