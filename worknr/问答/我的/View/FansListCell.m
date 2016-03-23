//
//  FansListCell.m
//  问答
//
//  Created by xwbb on 16/2/21.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "FansListCell.h"

@implementation FansListCell

- (void)awakeFromNib {
    
//    _iconImageV.layer.cornerRadius = 25;
//    _iconImageV.clipsToBounds = YES;
//    _iconImageV.contentMode = UIViewContentModeScaleToFill;
    
    _adeptL.layer.cornerRadius = 10.0;
    _adeptL.clipsToBounds = YES;
    _adeptL.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _adeptL.layer.borderWidth = 1.0;
    CGRect rect = [_adeptL.text boundingRectWithSize:CGSizeMake(300, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    _nameLL.width = rect.size.width;
    
}


@end
