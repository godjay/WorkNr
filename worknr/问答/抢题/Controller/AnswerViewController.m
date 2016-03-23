//
//  AnswerViewController.m
//  问答
//
//  Created by xwbb on 16/2/19.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "AnswerViewController.h"
#import "CommunicationViewController.h"

#import "QuestionCell.h"
#import "ChatModel.h"
#import "Common.h"

@interface AnswerViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    UITableView *_tableView;
    UIView *_bgView;
    UIView *_bottomView2;
    
    NSMutableArray *_dataArray; //数据源
    
    NSString *_content; //回复内容;
}

@end

@implementation AnswerViewController

#pragma mark - View Life
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [ProgressHUD dismiss];
//    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"问题详情";
    //创建导航栏左边按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"箭头.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //加载数据
    [self loadData];
    //创建子视图
    [self _createSubviews];
    
    //监听将要键盘弹出时发送的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    //监听将要键盘弹出时发送的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hiddenKeyBoard) name:UIKeyboardWillHideNotification object:nil];
}

- (void)loadData
{
    _dataArray = [NSMutableArray array];
    [ProgressHUD show:@"加载中..."];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    NSString *urlStr = [NSString stringWithFormat:@"%@question/first",apiBaseURL];
    
    NSDictionary *parameters = @{@"qid":[NSNumber numberWithInteger:_qid]};
    [manager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"question/first :%@",responseObject);
        
        [ProgressHUD dismiss];
        [_dataArray removeAllObjects];
        ChatModel *model = [ChatModel mj_objectWithKeyValues:responseObject];
        [_dataArray addObject:model];
        
        [_tableView reloadData];
        //显示提示图
        _bgView.hidden = NO;
        //开启定时器
        [self startTime];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"question/xinxi :error = %@",error);
        [ProgressHUD showError:@"加载失败!"];
    }];
}

//更改已被抢到问题的 status
- (void)update_status:(NSInteger)status
{
    [ProgressHUD show:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    NSString *urlStr = [NSString stringWithFormat:@"%@questions/%ld",apiBaseURL,_qid];
    NSDictionary *parameters = @{@"status":[NSNumber numberWithInteger:status]};
    [manager PATCH:urlStr parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        NSLog(@"%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"questions/status :error = %@",error);
        [ProgressHUD showError:@"加载失败!"];
    }];
}

#pragma mark - 开启倒计时定时器
-(void)startTime{
    __block int timeout=600; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer1 = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer1,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer1, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer1);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //修改已被抢到问题的 status
                [self update_status:1];
            });
        }else{
            
            int m = timeout/60;
            int s = timeout%60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                UILabel *label = (UILabel *)[_bgView viewWithTag:294];
                label.text = [NSString stringWithFormat:@"抢题后, %02d:%02d分钟内未解答, 将扣除1分",m,s];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer1);
}

#pragma mark - Creat Subviews
- (void)_createSubviews
{
    //表视图
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    //提示视图
    [self set_upAlertView];
    
    ////底部背景图2
    _bottomView2 = [[UIView alloc] initWithFrame:CGRectMake(0, (kScreenHeight - 30), kScreenWidth, 30)];
    [self.view addSubview:_bottomView2];
    
    //输入框
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, _bottomView2.width, _bottomView2.height)];
    textField.font = [UIFont systemFontOfSize:15];
    textField.layer.cornerRadius = 5.0;
    textField.clipsToBounds = YES;
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.layer.borderWidth = 1.0;
    textField.delegate = self;
    textField.tag = 595;
    [_bottomView2 addSubview:textField];
    
    UIButton *sendBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(0, 0, 65, textField.height);
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"橙色.png"] forState:UIControlStateNormal];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sendBtn.layer.cornerRadius = 5.0;
    sendBtn.clipsToBounds = YES;
    sendBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    sendBtn.layer.borderWidth = 1.0;
    [sendBtn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    textField.rightView = sendBtn;
    textField.rightViewMode = UITextFieldViewModeAlways;
}

//提示视图
- (void)set_upAlertView
{
    //提示图--背景图
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 90, kScreenWidth, 100)];
    _bgView.backgroundColor = [UIColor clearColor];
    _bgView.hidden = YES;
    [_tableView addSubview:_bgView];
    
    //倒计时提示文字
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 30)];
    titleL.text = @"抢题后, 09:59分钟内未解答, 将扣除1分";
    titleL.font = [UIFont systemFontOfSize:15];
    titleL.textAlignment = 1;
    titleL.backgroundColor = [UIColor clearColor];
    titleL.tag = 294;
    [_bgView addSubview:titleL];
    
    //加速悬赏背景图
    UIButton *give_upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    give_upBtn.frame = CGRectMake(0, 0, 100, 30);
    give_upBtn.center = CGPointMake(titleL.center.x, titleL.center.y + 40);
    give_upBtn.layer.cornerRadius = 8.0;
    give_upBtn.clipsToBounds = YES;
    [give_upBtn setTitle:@"丢弃该题" forState:UIControlStateNormal];
    give_upBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [give_upBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [give_upBtn setBackgroundImage:[UIImage imageNamed:@"消息框.png"] forState:UIControlStateNormal];
    [give_upBtn addTarget:self action:@selector(give_upBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:give_upBtn];
}

#pragma mark - TableView DataSource
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
    
    NSString *identifier = @"QuestionCell";
    
    QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"QuestionCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.model = _dataArray[indexPath.section];
    
    return cell;
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        
        _bottomView2.transform = CGAffineTransformIdentity;
        
    }];
}

#pragma mark - TextField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _content = textField.text;
}

#pragma mark - Action
//返回
- (void)leftBtnAction
{
    [self give_upBtnAction];
}

//丢弃该题
- (void)give_upBtnAction
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"丢弃该题将扣除1分, 确定吗?" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertC animated:YES completion:nil];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"确定");
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer
                                      serializerWithReadingOptions:NSJSONReadingAllowFragments];
        NSString *urlStr = [NSString stringWithFormat:@"%@questions/%ld",apiBaseURL,_qid];
        NSDictionary *parameters = @{@"status":[NSNumber numberWithInteger:0]};
        [manager PATCH:urlStr parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
            NSLog(@"%@",responseObject);
            
            [self update_status:0];
            //返回主界面
            [self.navigationController popToRootViewControllerAnimated:YES];
    
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"questions/status :error = %@",error);
        }];
    }];
    [alertC addAction:action1];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:action2];
    
}

//发送
- (void)sendAction
{
//    NSLog(@"发送");
    //结束编辑
    [self.view endEditing:YES];
    UITextField *textField = (UITextField *)[_bottomView2 viewWithTag:595];
    textField.text = nil;
    
    [ProgressHUD show:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    NSString *urlStr = [NSString stringWithFormat:@"%@answer/add",apiBaseURL];
    
    NSDictionary *parameters = @{@"uid":USER,@"qid":[NSNumber numberWithInteger:_qid],@"content":_content,@"status":[NSNumber numberWithInteger:1]};
    
    [manager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"answers :%@",responseObject);
        
        [ProgressHUD dismiss];
        
        CommunicationViewController *communicationVC = [[CommunicationViewController alloc] init];
        communicationVC.qid = _qid;
        communicationVC.uid = [USER integerValue];
        [self.navigationController pushViewController:communicationVC animated:YES];
        _bgView.hidden = YES;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"answers :error = %@",error);
        [ProgressHUD dismiss];
        [ProgressHUD showError:@"发送失败!"];
    }];  
    
}


#pragma mark - TextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    return YES;
}

#pragma mark - Notification Action
//监听通知实现的方法
- (void)showKeyBoard:(NSNotification *)notification {
    
    // 目的：让inputView和tableview上移键盘的高度
    
    //打印通知中传递的内容
    NSLog(@"%@",notification.userInfo);
    
    //拿到通知中传过来的字典中key对应的值
    NSValue *value = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    //解包
    CGRect rect = [value CGRectValue];
    CGFloat height = rect.size.height;
    
    //
    [UIView animateWithDuration:0.3 animations:^{
//        _bottomView2.transform = CGAffineTransformMakeTranslation(0, -height);
        _bottomView2.transform = CGAffineTransformMakeTranslation(0, -height);
    }];
}

- (void)hiddenKeyBoard
{
    [UIView animateWithDuration:0.3 animations:^{
        
        _bottomView2.transform = CGAffineTransformIdentity;
        
    }];
}

@end
