//
//  RefuseView.h
//  问答
//
//  Created by xwbb on 16/2/19.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefuseView : UIView

@property (weak, nonatomic) IBOutlet UIButton *errorBtn1;
@property (weak, nonatomic) IBOutlet UIButton *errorBtn2;
@property (weak, nonatomic) IBOutlet UIButton *errorBtn3;
@property (weak, nonatomic) IBOutlet UIButton *errorBtn4;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (nonatomic , copy) NSString *reason; //不采纳理由

@end
