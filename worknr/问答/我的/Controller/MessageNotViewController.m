//
//  MessageNotViewController.m
//  问答
//
//  Created by lirenjie on 16/2/21.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "MessageNotViewController.h"
#import "YCSettingGroup.h"
#import "YCSettingItem.h"
#import "RJSwitchCell.h"
@interface MessageNotViewController ()
@property (nonatomic,strong)NSMutableArray *notArray;

@end

@implementation MessageNotViewController

- (NSMutableArray *)notArray{
    if (_notArray == nil) {
        _notArray = [[NSMutableArray alloc] init];
    }
    return _notArray;
}

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

    
    [self setupGroup];
}

- (void)setupGroup{
    YCSettingGroup *group = [[YCSettingGroup alloc] init];
    YCSettingItem *saveNew = [YCSettingItem itemWithIcon:nil title:@"接收新消息通知" destVcClass:nil];
    YCSettingItem *voice = [YCSettingItem itemWithIcon:nil title:@"声音" destVcClass:nil];
    YCSettingItem *shake = [YCSettingItem itemWithIcon:nil title:@"震动" destVcClass:nil];

    group.items = @[saveNew,voice,shake];
    [self.notArray addObject:group];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YCSettingGroup *group = self.notArray[section];
    return group.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"NOT";
    RJSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    YCSettingGroup *group = self.notArray[indexPath.section];
    YCSettingItem *item = group.items[indexPath.row];
    if (cell == nil) {
        cell = [[RJSwitchCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = item.title;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
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
