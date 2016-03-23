//
//  RJSwitchCell.m
//  问答
//
//  Created by lirenjie on 16/2/21.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "RJSwitchCell.h"
#import "Common.h"

@implementation RJSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UISwitch *Rswitch = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenWidth - 70, 10, 30, 30)];
        _Rswitch = Rswitch;
        [self.contentView addSubview:Rswitch];
        
        UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(10, self.frame.size.height - 0.5, kScreenWidth, 0.5)];
        sepView.backgroundColor = [UIColor lightGrayColor];
        sepView.alpha = 0.5;
        [self.contentView addSubview:sepView];
    }
    return self;
}
@end
