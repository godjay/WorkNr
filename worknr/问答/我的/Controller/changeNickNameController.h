//
//  changeNickNameController.h
//  问答
//
//  Created by lirenjie on 16/3/9.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "BaseViewController.h"

@protocol changeNickNameControllerDelegate <NSObject>
@optional
- (void)nickNameHadChangeBe:(UITextField *)field;
@end

@interface changeNickNameController : BaseViewController
@property (weak,nonatomic) id <changeNickNameControllerDelegate> delegate;
@end
