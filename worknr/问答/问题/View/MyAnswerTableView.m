//
//  MyAskTableView.m
//  问答
//
//  Created by xwbb on 16/2/20.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "MyAnswerTableView.h"
#import "MyQuestionCell.h"
#import "CommunicationViewController.h"
#import "BaseNavigationController.h"

#import "Common.h"
#import "AllQuestionsModel.h"

static NSString *identifier = @"MyQuestion_Cell";
@implementation MyAnswerTableView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {

        
        //加载数据
        [self monitor_Comment];
        
        self.delegate = self;
        self.dataSource = self;
        
        [self registerNib:[UINib nibWithNibName:@"MyQuestionCell" bundle:nil] forCellReuseIdentifier:identifier];
    }
    return self;
}

//监测提问者是否评价
- (void)monitor_Comment
{
    if (!_timer) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(loadData) userInfo:nil repeats:YES];
    }
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)loadData
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    NSString *urlStr = [NSString stringWithFormat:@"%@answer/allti",apiBaseURL];
    [manager POST:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"AllAnswers :%@",responseObject);
        [_dataArray removeAllObjects];
        for (NSDictionary *dic in responseObject) {
            AllQuestionsModel *model = [AllQuestionsModel mj_objectWithKeyValues:dic];
            
            [_dataArray addObject:model];
        }
        [self reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"questions :error = %@",error);
//        [ProgressHUD showError:@"加载失败!"];
    }];
}


#pragma mark - DataSource
//组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _dataArray.count;
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSLog(@"delete");
    }
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.section];
    return cell;
}

#pragma mark - Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 128;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .00001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllQuestionsModel *model = _dataArray[indexPath.section];
    UINavigationController *nav = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers[1];
    [nav pushViewController:[[CommunicationViewController alloc] initWithShowType:CommunicationShowA questionId:model.qid] animated:YES];
}


@end
