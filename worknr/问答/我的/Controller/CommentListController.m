//
//  CommentListController.m
//  问答
//
//  Created by lirenjie on 16/3/18.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "CommentListController.h"
#import "RJComment.h"
#import "RJCommentFrame.h"
#import "CommentListCell.h"
#import <ProgressHUD.h>
@interface CommentListController ()
@property (strong,nonatomic)NSMutableArray *array;
@property (strong,nonatomic)NSArray *commentArray;
@end

@implementation CommentListController

- (NSArray *)commentArray{
    if (_commentArray == nil) {
        _commentArray = [NSArray array];
    }
    return _commentArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论";
    [self requestComment];
    [ProgressHUD show:@"正在加载"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor colorWithRed:236 / 255.0 green:237 /255.0 blue:239 /255.0 alpha:1];

    //创建导航栏左边按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"箭头.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}
- (void)requestComment{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //json解析所有格式
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    NSString *urlStr = [NSString stringWithFormat:@"%@score/assessment",apiBaseURL];
    NSDictionary *idparams = @{
                               @"rid" : [NSNumber numberWithInt:self.fan.ID]
                               };
    [manager POST:urlStr parameters:idparams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _array = [RJComment mj_objectArrayWithKeyValuesArray:responseObject];
        
        NSMutableArray *muA = [NSMutableArray array];
        for (RJComment *comment in _array) {
            RJCommentFrame *commentF = [[RJCommentFrame alloc] init];
            NSLog(@"2222%@",commentF);
            commentF.comment = comment;
            [muA addObject:commentF];
            NSLog(@"333333%@",muA);
        }
        _commentArray = muA;
        NSLog(@"啊啊啊  %@",responseObject);
        [self.tableView reloadData];
        [ProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [ProgressHUD dismiss];
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"CommentList";
    CommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CommentListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.commentFrame = self.commentArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    RJCommentFrame *commentF = self.commentArray[indexPath.row];
    return commentF.cellHight;
}

//返回
- (void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
