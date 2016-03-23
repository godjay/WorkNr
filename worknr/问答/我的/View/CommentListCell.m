//
//  CommentListCell.m
//  问答
//
//  Created by xwbb on 16/2/21.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "CommentListCell.h"
#import "RJCommentFrame.h"
#import "RJComment.h"
#import "RJUser.h"
#import <UIImageView+WebCache.h>
@interface CommentListCell ()
@property (weak,nonatomic)UIImageView *iconView;
@property (weak,nonatomic)UILabel *nickName;
@property (weak,nonatomic)UILabel *contenLabel;
@property (weak,nonatomic)UILabel *timeLabel;
@property (weak,nonatomic)UIView *sepView;

@end

@implementation CommentListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        UILabel *nickName = [[UILabel alloc] init];
        [self.contentView addSubview:nickName];
        self.nickName = nickName;
        
        UILabel *contenLabel = [[UILabel alloc] init];
        [self.contentView addSubview:contenLabel];
        self.contenLabel = contenLabel;
        
        UILabel *timeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        [self.contentView addSubview:timeLabel];
        
        UIView *sepView = [[UIView alloc] init];
        sepView.backgroundColor = [UIColor lightGrayColor];
        sepView.alpha = 0.5;
        [self.contentView addSubview:sepView];
        self.sepView = sepView;
    }
    return self;
}

- (void)setCommentFrame:(RJCommentFrame *)commentFrame{
    _commentFrame = commentFrame;
    [self setupData];
    [self setupFrame];
}

- (void)setupData{
    RJUser *user = self.commentFrame.comment.user;
    RJComment *comment = self.commentFrame.comment;
    [self.iconView sd_setImageWithURL:user.pic placeholderImage:[UIImage imageNamed:@"Q Q"]];
    self.nickName.text = user.nickname;
    self.contenLabel.text = comment.content;
    self.timeLabel.text = comment.time;
}

- (void)setupFrame{
    self.iconView.frame = self.commentFrame.iconViewF;
    self.nickName.frame = self.commentFrame.nickNameF;
    self.contenLabel.frame = self.commentFrame.contenLabelF;
    self.timeLabel.frame = self.commentFrame.timeLabelF;
    self.sepView.frame = self.commentFrame.sepViewF;
}

@end
