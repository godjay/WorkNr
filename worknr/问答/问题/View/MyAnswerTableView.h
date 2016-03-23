//
//  MyAskTableView.h
//  问答
//
//  Created by xwbb on 16/2/20.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAnswerTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic , strong) NSMutableArray *dataArray; //存放数据
@property (nonatomic , strong) NSTimer *timer;

@end
