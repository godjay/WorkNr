//
//  RJDetailViewCell.m
//  问答
//
//  Created by lirenjie on 16/2/21.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "RJDetailViewCell.h"

@implementation RJDetailViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *middL = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 300, 20)];
        middL.font = [UIFont systemFontOfSize:12];
        _middL = middL;
        [self.contentView addSubview:middL];
    }
    return self;
}
@end
