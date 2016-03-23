//
//  RJCommentFrame.m
//  问答
//
//  Created by lirenjie on 16/3/18.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "RJCommentFrame.h"
#import "RJComment.h"

@implementation RJCommentFrame

- (void)setComment:(RJComment *)comment{
    _comment = comment;
    CGFloat padding = 10;
    
    CGFloat iconViewX = padding;
    CGFloat iconViewY = padding;
    CGFloat iconViewW = 50;
    CGFloat iconViewH = 50;
    self.iconViewF = CGRectMake(iconViewX,iconViewY,iconViewW,iconViewH);
    
    CGFloat nickNameX = CGRectGetMaxX(self.iconViewF) + padding;
    // 计算文字的宽高
    CGRect nameSize = [self sizeWithString:_comment.user.nickname font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    CGFloat nickNameH = nameSize.size.height;
    CGFloat nickNameW = nameSize.size.width + 10;
    CGFloat nickNameY = iconViewY + (iconViewH - nickNameH) * 0.25;
    self.nickNameF = CGRectMake(nickNameX,nickNameY,nickNameW,nickNameH);
    
    CGFloat contenLabelX = nickNameX;
    CGFloat contenLabelY = CGRectGetMaxY(self.nickNameF) + padding;
    CGRect textSize =  [self sizeWithString:_comment.content font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(kScreenWidth - contenLabelX, MAXFLOAT)];
    CGFloat contenLabelW = textSize.size.width + 10;
    CGFloat contenLabelH = textSize.size.height;
    self.contenLabelF = CGRectMake(contenLabelX,contenLabelY,contenLabelW,contenLabelH);
    
    CGFloat timeLabelX = nickNameX;
    CGRect timeSize = [self sizeWithString:_comment.time font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat timeLabelH = timeSize.size.height;
    CGFloat timeLabelW = timeSize.size.width + 10;
    CGFloat timeLabelY = CGRectGetMaxY(self.contenLabelF) + padding;
    self.timeLabelF = CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH);
    
    CGFloat sepViewX = padding;
    CGFloat sepViewY = CGRectGetMaxY(self.timeLabelF) + padding - 0.5;
    CGFloat sepViewW = kScreenWidth - sepViewX;
    CGFloat sepViewH = 0.5;
    self.sepViewF = CGRectMake(sepViewX,sepViewY,sepViewW,sepViewH);
    
    self.cellHight = CGRectGetMaxY(self.timeLabelF) + padding;
}

- (CGRect)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGRect size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return size;
}
@end
