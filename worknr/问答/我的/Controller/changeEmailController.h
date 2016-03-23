//
//  changeEmailController.h
//  问答
//
//  Created by lirenjie on 16/3/9.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "BaseViewController.h"
@protocol changeEmailControllerDelegate <NSObject>
@optional
- (void)emailHadChangeBe:(UITextField *)field;
@end
@interface changeEmailController : BaseViewController
@property (weak,nonatomic) id <changeEmailControllerDelegate> delegate;
@end
