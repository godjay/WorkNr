//
//  changeNumController.h
//  问答
//
//  Created by lirenjie on 16/3/9.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "BaseViewController.h"
@protocol changeNumControllerDelegate <NSObject>
@optional
- (void)numHadChangeBe:(UITextField *)field;
@end
@interface changeNumController : BaseViewController
@property (weak,nonatomic) id <changeNumControllerDelegate> delegate;

@end
