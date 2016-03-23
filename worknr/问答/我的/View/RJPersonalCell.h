//
//  RJPersonalCell.h
//  问答
//
//  Created by lirenjie on 16/2/20.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RJPersonalCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *niuCount;
@property (weak, nonatomic) IBOutlet UIImageView *zuan1;
@property (weak, nonatomic) IBOutlet UIImageView *zuan2;
@property (weak, nonatomic) IBOutlet UIImageView *zuan3;
@property (weak, nonatomic) IBOutlet UIImageView *zuan4;
@end
