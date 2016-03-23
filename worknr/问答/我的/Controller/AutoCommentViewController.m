//
//  AutoCommentViewController.m
//  问答
//
//  Created by lirenjie on 16/2/21.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "AutoCommentViewController.h"
#import "RJSwitchCell.h"
@interface AutoCommentViewController ()

@end

@implementation AutoCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:236 / 255.0 green:237 /255.0 blue:239 /255.0 alpha:1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;

    //创建导航栏左边按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"箭头.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"AUTO";
    RJSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[RJSwitchCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.text = @"对方给我好评，我自动给对方好评";
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RJSwitchCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
}

//返回
- (void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
