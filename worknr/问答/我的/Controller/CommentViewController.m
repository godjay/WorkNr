//
//  CommentViewController.m
//  问答
//
//  Created by xwbb on 16/2/21.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentListCell.h"
#import "Common.h"

@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    UITableView *_tableView;
}

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"评论";
    
    //创建导航栏左边按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"箭头.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //创建子视图
    [self _createSubviews];
}

- (void)_createSubviews
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 185;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
}

#pragma mark - DataSource
//组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"CommentList_Cell";
    
    CommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentListCell" owner:self options:nil] lastObject];
    }
    
    return cell;
}

#pragma mark - Action
//返回
- (void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
