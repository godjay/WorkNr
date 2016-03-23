//
//  AdoptTableView.m
//  问答
//
//  Created by xwbb on 16/2/19.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "AdoptTableView.h"
#import "AdoptCell.h"

#import "CommunicationViewController.h"
#import "BaseNavigationController.h"
#import "QDetailViewController.h"
#import "AllQuestionsModel.h"
#import "Common.h"

static NSString *identifier = @"Adopt_Cell";


@implementation AdoptTableView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _dataArray = [NSMutableArray array];
        
        [self monitor_Comment];
        
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"AdoptCell" bundle:nil] forCellReuseIdentifier:identifier];
    }
    return self;
}

//监测提问者是否评价
- (void)monitor_Comment
{
    if (!_timer) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(loadData) userInfo:nil repeats:YES];
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
    NSString *urlStr = [NSString stringWithFormat:@"%@question/allwen",apiBaseURL];
    [manager POST:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"AdoptTableView :%@",responseObject);
        [_dataArray removeAllObjects];
        for (NSDictionary *dic in responseObject) {
            if ([dic[@"status"] integerValue] == 1) {
                
                AllQuestionsModel *model = [AllQuestionsModel mj_objectWithKeyValues:dic];
                
                [_dataArray addObject:model];
            }
        }
        [self reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"AdoptTableView :error = %@",error);
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

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AdoptCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
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
    NSInteger qid = model.qid;
    CommunicationViewController *communicationVC = [[CommunicationViewController alloc] initWithShowType:CommunicationShow questionId:qid];
    for (UIView* next = self.superview; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[BaseNavigationController class]]) {
            UINavigationController *navC = (BaseNavigationController *)nextResponder;
            [navC pushViewController:communicationVC animated:YES];
        }
    }
}

@end
