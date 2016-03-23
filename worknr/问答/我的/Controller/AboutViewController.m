//
//  AboutViewController.m
//  问答
//
//  Created by lirenjie on 16/2/21.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "AboutViewController.h"
#import "RJSCell.h"
@interface AboutViewController ()
@property (nonatomic,strong)NSMutableArray *aboutArray;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;

    //创建导航栏左边按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"箭头.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.view.backgroundColor = [UIColor colorWithRed:236 / 255.0 green:237 /255.0 blue:239 /255.0 alpha:1];
    _aboutArray = [NSMutableArray arrayWithObjects:@"去评分",@"新版本检测",@"清除聊天记录",@"清除缓存",nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"AB";
    RJSCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[RJSCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = _aboutArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    if (indexPath.row == 1) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"检测到新版本，确定更新吗?" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertC animated:YES completion:nil];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"确定");
        }];
        [alertC addAction:action1];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertC addAction:action2];

    }else if (indexPath.row == 2){
        [ProgressHUD showSuccess:@"聊天记录清除成功！"];
    }else if (indexPath.row == 3){
        [ProgressHUD showSuccess:@"缓存清除成功"];
    }
}

//返回
- (void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
