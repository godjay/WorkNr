//
//  RJPersonalPicTableViewCell.m
//  问答
//
//  Created by lirenjie on 16/2/20.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "RJPersonalPicTableViewCell.h"
#import "Common.h"
@implementation RJPersonalPicTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
        titleL.font = [UIFont systemFontOfSize:16];
        _titleL = titleL;
        [self.contentView addSubview:titleL];
        
        UIImageView *lastP = [[UIImageView alloc] init];
        lastP.frame = CGRectMake(kScreenWidth - 70, 10, 30, 30);
        _lastP = lastP;
        [self.contentView addSubview:lastP];
        
        UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(10, self.frame.size.height - 0.5, kScreenWidth, 0.5)];
        sepView.backgroundColor = [UIColor lightGrayColor];
        sepView.alpha = 0.5;
        [self.contentView addSubview:sepView];
    }
    return self;
}
@end
