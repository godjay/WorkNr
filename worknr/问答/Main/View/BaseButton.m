//
//  TabBarButton.m
//  WXMovie
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 Mr.Y. All rights reserved.
//

#import "BaseButton.h"

@implementation BaseButton

- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title withImageName:(NSString *)imageName {

    self = [super initWithFrame:frame];
    
    if ( self ) {
        
        //创建图片视图
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 20) / 2, 8, 20, 20)];
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        imageV.image = [UIImage imageNamed:imageName];
        
        [self addSubview:imageV];
        
        //创建Label
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageV.frame) + 2, self.frame.size.width, 15)];
        titleL.text = title;
        titleL.textColor = [UIColor blackColor];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.font = [UIFont systemFontOfSize:11];
        
        [self addSubview:titleL];
        
    }

    return self;
}

@end
