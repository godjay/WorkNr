//
//  QTViewController.h
//  问答
//
//  Created by xwbb on 16/2/19.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "BaseViewController.h"

@interface QTViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIView *messageBgView; //内容背景
@property (weak, nonatomic) IBOutlet UILabel *messageL; //问题内容
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV; //头像
@property (weak, nonatomic) IBOutlet UILabel *nickNameL; //昵称
@property (weak, nonatomic) IBOutlet UILabel *givenL; //牛豆数
@property (weak, nonatomic) IBOutlet UILabel *noAdoptL; //差评数

@property (weak, nonatomic) IBOutlet UIButton *reportBtn; //举报
@property (weak, nonatomic) IBOutlet UIButton *timeBtn; //计时
@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn; //跳过

@end
