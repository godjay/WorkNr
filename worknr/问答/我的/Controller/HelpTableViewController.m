//
//  HelpTableViewController.m
//  问答
//
//  Created by lirenjie on 16/2/20.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "HelpTableViewController.h"
#import "YCSettingGroup.h"
#import "YCSettingItem.h"
#import "RJSCell.h"

@interface HelpTableViewController ()
@property (nonatomic,strong)UITableView *settingView;
@property (nonatomic,strong)NSMutableArray *helpArray;
@end

@implementation HelpTableViewController

- (NSMutableArray *)helpArray{
    if (_helpArray == nil) {
        _helpArray = [[NSMutableArray alloc] init];
    }
    return _helpArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:236 / 255.0 green:237 /255.0 blue:239 /255.0 alpha:1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //创建导航栏左边按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"箭头.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;

    self.title = @"使用帮助";
    self.tableView.scrollEnabled = NO;
    [self setupGroup];
}

- (void)setupGroup{
    YCSettingGroup *group = [[YCSettingGroup alloc] init];
    YCSettingItem *question = [YCSettingItem itemWithIcon:nil title:@"如何提问"];
    YCSettingItem *autoanswer = [YCSettingItem itemWithIcon:nil title:@"如何设置自动抢题"];
    YCSettingItem *howtocomment = [YCSettingItem itemWithIcon:nil title:@"如何评价"];
    
    group.items = @[question,autoanswer,howtocomment];
    [self.helpArray addObject:group];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.helpArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YCSettingGroup *group = self.helpArray[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"HELP";
    RJSCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    YCSettingGroup *group = self.helpArray[indexPath.section];
    YCSettingItem *item = group.items[indexPath.row];
    if (cell == nil) {
        cell = [[RJSCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.text = item.title;
//    cell.imageView.image = [UIImage imageNamed:item.icon];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
}

#pragma mark - Action
//返回
- (void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
