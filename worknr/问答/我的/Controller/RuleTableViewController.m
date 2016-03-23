//
//  RuleTableViewController.m
//  问答
//
//  Created by lirenjie on 16/2/20.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "RuleTableViewController.h"
#import "YCSettingGroup.h"
#import "YCSettingItem.h"
#import "RJSCell.h"
@interface RuleTableViewController ()
@property (nonatomic,strong)UITableView *settingView;
@property (nonatomic,strong)NSMutableArray *ruleArray;

@end

@implementation RuleTableViewController

- (NSMutableArray *)ruleArray{
    if (_ruleArray == nil) {
        _ruleArray = [[NSMutableArray alloc] init];
    }
    return _ruleArray;
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
    
    self.title = @"问答规则";
    self.tableView.scrollEnabled = NO;
    [self setupGroup];
}

- (void)setupGroup{
    YCSettingGroup *group = [[YCSettingGroup alloc] init];
    YCSettingItem *new = [YCSettingItem itemWithIcon:nil title:@"新手入门"];
    YCSettingItem *answer = [YCSettingItem itemWithIcon:nil title:@"答题技巧"];
    YCSettingItem *credit = [YCSettingItem itemWithIcon:nil title:@"信用体系"];
    YCSettingItem *moneyout = [YCSettingItem itemWithIcon:nil title:@"账户提现"];
    YCSettingItem *violation = [YCSettingItem itemWithIcon:nil title:@"违规处罚"];
    YCSettingItem *notice = [YCSettingItem itemWithIcon:nil title:@"公告&通知"];
    group.items = @[new,answer,credit,moneyout,violation,notice];
    [self.ruleArray addObject:group];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.ruleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YCSettingGroup *group = self.ruleArray[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"RU";
    RJSCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    YCSettingGroup *group = self.ruleArray[indexPath.section];
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
