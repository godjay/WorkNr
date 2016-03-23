//
//  changeSexController.h
//  问答
//
//  Created by lirenjie on 16/3/9.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol changeSexControllerDelegate <NSObject>
@optional
- (void)sexHadChangeBe:(UITableViewCell *)cell;
@end
@interface changeSexController : UITableViewController
@property (weak,nonatomic) id <changeSexControllerDelegate> delegate;
@end
