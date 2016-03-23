//
//  FansViewController.m
//  问答
//
//  Created by xwbb on 16/2/21.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "FansViewController.h"
#import "FansListCell.h"
#import "RJFans.h"
#import "DetailInfoController.h"
#import <UIImageView+WebCache.h>
#import <ProgressHUD.h>
@interface FansViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@property (nonatomic,strong)NSMutableArray *fanArray;

@end

@implementation FansViewController

- (NSMutableArray *)fanArray{
    if (_fanArray == nil) {
        _fanArray = [NSMutableArray array];
    }
    return _fanArray;
}

- (void)viewWillDisappear:(BOOL)animated{
    [ProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ProgressHUD show:@"正在加载"];
    self.titleLabel.text = @"我的粉丝";
    //创建导航栏左边按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"箭头.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self _createSubviews];
    
    [self text];
}

- (void)text{
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    //json解析所有格式
    manger.responseSerializer = [AFJSONResponseSerializer
                                 serializerWithReadingOptions:NSJSONReadingAllowFragments];
    NSString *urlString = [NSString stringWithFormat:@"%@fan/get",apiBaseURL];
    [manger POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //字典转模型
        _fanArray = [RJFans mj_objectArrayWithKeyValuesArray:responseObject];
        [_tableView reloadData];
        [ProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)_createSubviews
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}

#pragma mark - DataSource
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _fanArray.count;
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RJFans *fan = _fanArray[indexPath.row];
    static NSString *identifier = @"FansList_Cell";
    FansListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FansListCell" owner:self options:nil] lastObject];
    }
    [cell.iconImageV sd_setImageWithURL:fan.pic placeholderImage:[UIImage imageNamed:@"Q Q"]];
    cell.nameLL.text = fan.nickname;
    cell.adeptL.text = fan.identity;
    return cell;
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    RJFans *fan = _fanArray[indexPath.row];
    DetailInfoController *detailInfo = [[DetailInfoController alloc] initWithShowType:DetailInfoShowTypeA];
    detailInfo.fan = fan;
    [ProgressHUD show:@"加载中"];
    [self.navigationController pushViewController:detailInfo animated:YES];
}

#pragma mark - Action
//返回
- (void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
