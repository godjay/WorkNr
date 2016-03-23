//
//  CommunicationViewController.m
//  问答
//
//  Created by xwbb on 16/2/24.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "CommunicationViewController.h"

#import "AnswerCell.h"
#import "ChatModel.h"
#import "Common.h"

@interface CommunicationViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>

{
    UITableView *_tableView;
//    UIView *_bgView;
    UIView *_bottomView2;
    UIControl *_maskView;
    UIControl *_commentMaskV;
    
    NSString *_content; //交流内容
    NSInteger _qStatus; //记录问题状态
    int _colligate; //综合评分(评论遮罩视图)
    NSString *_commentContent; //评论内容(评论遮罩视图)
    NSString *_appealReason; //申述原因(申述遮罩视图)
    NSString *_appealContent; //评论内容(申述遮罩视图)
    
    NSMutableArray *_dataArray; //数据源
}
@property (assign, nonatomic) CommunicationShowType showType;
@end

@implementation CommunicationViewController
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

- (instancetype)initWithShowType:(CommunicationShowType)showType questionId:(NSInteger)qid
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.showType = showType;
        _qid = qid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"问题详情";
    _dataArray = [NSMutableArray array];
    _commentContent = [NSString string];
    
    //创建导航栏左边按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"箭头.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [ProgressHUD show:@"正在加载..."];
    
    //线程保护
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //监测提问者是否评论
        [self monitor_Comment];
    });
    
    //加载数据
    [self loadData];
    //创建子视图
    [self _createSubviews];
    //遮罩视图
    [self _createMaskView];
    //反评价遮罩视图
    [self _createCommentMask];
    
    //监听将要键盘弹出时发送的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hiddenKeyBoard) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -
- (void)loadData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    NSString *urlStr = [NSString stringWithFormat:@"%@question/xinxi",apiBaseURL];
#warning 待改...
    NSDictionary *dic = @{@"qid":[NSNumber numberWithInteger:_qid]};
    
    [manager POST:urlStr parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"question/xinxi :%@",responseObject);
        
        [ProgressHUD dismiss];
        //最终解析数据
        [self get_dataFinaly:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"question/xinxi :error = %@",error);
    }];
}

//最终解析数据
- (void)get_dataFinaly:(id)responseObject
{
    NSArray *qInfos = [responseObject firstObject];
    NSArray *aInfos = [responseObject lastObject];
    
    NSMutableArray *mArray = [NSMutableArray array];
    for (NSDictionary *dic1 in qInfos) {
        [mArray addObject:dic1];
    }
    for (NSDictionary *dic2 in aInfos) {
        [mArray addObject:dic2];
    }
    
    [_dataArray removeAllObjects];
    //根据 ctime 进行升序排列
    NSSortDescriptor *_sorter2 = [[NSSortDescriptor alloc] initWithKey:@"ctime"
                                                             ascending:YES];
    NSArray *arr = [mArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:_sorter2, nil]];
    
    for (NSDictionary *dic in arr) {
        ChatModel *model = [ChatModel mj_objectWithKeyValues:dic];
        [_dataArray addObject:model];
    }
//    NSLog(@"_data :%@",_dataArray);
    
    //刷新单元格
    [_tableView reloadData];
    
    //滚动到指定的单元格。
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:_dataArray.count-1];
    [_tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

//监测提问者是否评价
- (void)monitor_Comment
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        //请求数据
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer
                                      serializerWithReadingOptions:NSJSONReadingAllowFragments];
        NSString *urlStr = [NSString stringWithFormat:@"%@questions/%ld",apiBaseURL,_qid];
        [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"questions :%@",responseObject);
            //数据请求成功后
            _qStatus = [responseObject[@"status"] integerValue];
            if (_qStatus == 2 || _qStatus == 4) {
            dispatch_source_cancel(timer); //关闭
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                if (_qStatus == 2) {
                    
                    //设置申述按钮
                    [self set_upRightItem];
                }
                [_tableView reloadData];
            });
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"questions :error = %@",error);
        }];
        
    });
    dispatch_resume(timer);
}

//更改已被抢到问题的 status
- (void)update_status:(NSInteger)status
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    NSString *urlStr = [NSString stringWithFormat:@"%@questions/%ld",apiBaseURL,_qid];
    NSDictionary *parameters = @{@"status":[NSNumber numberWithInteger:status]};
    [manager PATCH:urlStr parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"questions/status :error = %@",error);
    }];
}

#pragma mark - Creat Subviews
- (void)_createSubviews
{
    //表视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
    if (self.showType != CommunicationShowA) {
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
        textField.tag = 995;
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
}

//申述遮罩视图
- (void)_createMaskView
{
    _maskView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    //设置背景颜色
    _maskView.backgroundColor = [UIColor colorWithWhite:.8 alpha:.5];
    //隐藏遮罩视图
    _maskView.hidden = YES;
    [self.tabBarController.view addSubview:_maskView];
    
    //子视图
    //背景图
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight / 2)];
    bgView.center = _maskView.center;
    bgView.tag = 450;
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderWidth = 1.0;
    bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_maskView addSubview:bgView];
    
    //单击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [bgView addGestureRecognizer:tap];
    
    //
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(10, 10, 100, 40);
    button1.tag = 451;
    [button1 setTitle:@"恶意不采纳" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    button1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    button1.layer.borderWidth = 1.0;
    [button1 addTarget:self action:@selector(button1Action:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake( button1.right + 1, button1.top, 50, button1.height);
    button2.tag = 452;
    [button2 setTitle:@"其他" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    button2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    button2.layer.borderWidth = 1.0;
    [button2 addTarget:self action:@selector(button1Action:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:button2];
    
    //输入框
    //评论输入框
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(button1.left, button1.bottom + 20, kScreenWidth - 20, bgView.height / 2)];
    textView.tag = 453;
    textView.delegate = self;
    textView.font = [UIFont systemFontOfSize:15];
    textView.layer.cornerRadius = 10.0;
    textView.layer.borderColor = [UIColor grayColor].CGColor;
    textView.layer.borderWidth = 1.0;
    [bgView addSubview:textView];
    
    //提示文
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 150, 20)];
    label.text = @"牛人好评!";
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:13];
    label.tag = 454;
    [textView addSubview:label];
    
    //提交按钮
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CGRectMake(25, bgView.height - 50, bgView.width - 50, 30);
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitBtn setBackgroundImage:[UIImage imageNamed:@"消息框.png"] forState:UIControlStateNormal];
    commitBtn.layer.cornerRadius = 10;
    commitBtn.clipsToBounds = YES;
    [commitBtn addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:commitBtn];
    
}

//反评价遮罩视图
- (void)_createCommentMask
{
    _commentMaskV = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    //设置背景颜色
    _commentMaskV.backgroundColor = [UIColor colorWithWhite:.8 alpha:.5];
    //隐藏遮罩视图
    _commentMaskV.hidden = YES;
    [self.tabBarController.view addSubview:_commentMaskV];
    
    //背景图
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight / 3)];
    bgView.center = _maskView.center;
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderWidth = 1.0;
    bgView.tag = 10086111;
    bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_commentMaskV addSubview:bgView];
    
    //选择 花
    NSArray *imageNames = @[@"red.png",@"yellowFlower.png",@"gray.png"];
    for (int j = 0; j < imageNames.count; j ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 15, 15);
        button.center = CGPointMake((kScreenWidth / 4 - 10) * (j + 1), 20);
        [button setBackgroundImage:[UIImage imageNamed:@"quan.png"] forState:UIControlStateSelected];
        button.tag = 230 + j;
        [button addTarget:self action:@selector(chooseFlower:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 7.5;
        button.clipsToBounds = YES;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 1.0;
        if (j == 0) {
            button.selected = YES;
            _colligate = 3;
        }
        [bgView addSubview:button];
        
        //花
        UIImageView *flowerImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        flowerImageV.center = CGPointMake(button.center.x + 20, button.center.y);
        flowerImageV.tag = 1001010 + j;
        flowerImageV.image = [UIImage imageNamed:imageNames[j]];
        [bgView addSubview:flowerImageV];
    }
    //获取视图
    UIImageView *imageV = (UIImageView *)[bgView viewWithTag:1001010];
    //评论输入框
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(25, imageV.center.y + 20 , kScreenWidth - 50, kScreenHeight * .18)];
    textView.delegate = self;
    textView.font = [UIFont systemFontOfSize:15];
    textView.layer.cornerRadius = 10.0;
    textView.layer.borderColor = [UIColor grayColor].CGColor;
    textView.layer.borderWidth = 1.0;
    textView.tag = 459;
    [bgView addSubview:textView];
    
    //提交按钮
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CGRectMake(0, 0, bgView.width - 80, 30);
    commitBtn.center = CGPointMake(bgView.center.x, bgView.height - 25);
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitBtn setBackgroundImage:[UIImage imageNamed:@"消息框.png"] forState:UIControlStateNormal];
    commitBtn.layer.cornerRadius = 10;
    commitBtn.clipsToBounds = YES;
    [commitBtn addTarget:self action:@selector(comment_commitAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:commitBtn];
    
}

//设置导航按钮
- (void)set_upRightItem
{
    //抢题设置按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 20);
    [rightBtn setTitle:@"申诉" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn addTarget:self action:@selector(complainAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
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
    
    NSString *identifier = @"AnswerCell";
    
    AnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AnswerCell" owner:nil options:nil] lastObject];
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
    if (_qStatus == 4 && section == 0) {
    
        return 50;
    } else
    {
        return 10;
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (_qStatus == 4 && section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        view.backgroundColor = [UIColor clearColor];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, view.height - 20)];
        bgView.backgroundColor = [UIColor clearColor];
        bgView.center = view.center;
        [view addSubview:bgView];
        
        UILabel *alertL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, bgView.height)];
        alertL.text = @"对方给了您好评:";
        alertL.textAlignment = 1;
        alertL.font = [UIFont systemFontOfSize:13];
        [bgView addSubview:alertL];
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imageV.center = CGPointMake(alertL.right + 15, alertL.center.y);
        imageV.image = [UIImage imageNamed:@"red.png"];
        [bgView addSubview:imageV];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(imageV.right + 15, 0, 80, bgView.height);
        [button setTitle:@"评价" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        button.layer.cornerRadius = 5.0;
        button.clipsToBounds = YES;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 1.0;
        [button addTarget:self action:@selector(end_commentAction:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:button];
        
        return view;
    } else
    {
        return nil;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    //遮罩视图
    [UIView animateWithDuration:0.3 animations:^{
        
        _bottomView2.transform = CGAffineTransformIdentity;
        
    }];
}

#pragma mark - TextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    UILabel *label = (UILabel *)[textView viewWithTag:454];
    [label removeFromSuperview];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView;
{
    if (textView.tag == 459) {
        
        _commentContent = textView.text;
    } else if (textView.tag == 453)
    {
        _appealContent = textView.text;
    }
    return YES;
}

#pragma mark - UITextField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _content = textField.text;
}

#pragma mark - Action
//返回
- (void)leftBtnAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)sendAction
{
    NSLog(@"发送");
    //结束编辑
    [self.view endEditing:YES];
    UITextField *textField = (UITextField *)[_bottomView2 viewWithTag:995];
    textField.text = nil;
    
    //发送请求
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"%@answer/huida",apiBaseURL];
    NSDictionary *pars = @{@"qid":[NSNumber numberWithInteger:_qid],@"status":[NSNumber numberWithInt:1],@"content":_content,@"uid":USER};
    [manager POST:urlStr parameters:pars progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"answer/huida :%@",responseObject);
        //刷新数据
        [self loadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"answer/huida :error = %@",error);
    }];
    

}

- (void)button1Action:(UIButton *)butt
{
    UIView *view = [_maskView viewWithTag:450];
    UIButton *button1 = (UIButton *)[view viewWithTag:451];
    UIButton *button2 = (UIButton *)[view viewWithTag:452];
    switch (butt.tag) {
        case 451:
            button1.selected = YES;
            button2.selected = NO;
            _appealReason = @"恶意不采纳";
            break;
        case 452:
            button1.selected = NO;
            button2.selected = YES;
            _appealReason = @"其他";
            break;
            
        default:
            break;
    }
}

//选择 花
- (void)chooseFlower:(UIButton *)butt
{
    UIView *view = [_commentMaskV viewWithTag:10086111];
    UIButton *btn1 = (UIButton *)[view viewWithTag:230];
    UIButton *btn2 = (UIButton *)[view viewWithTag:231];
    UIButton *btn3 = (UIButton *)[view viewWithTag:232];
    if (butt.tag == 230) {
        btn1.selected = YES;
        btn2.selected = NO;
        btn3.selected = NO;
        _colligate = 3;
    } else if (butt.tag == 231)
    {
        btn1.selected = NO;
        btn2.selected = YES;
        btn3.selected = NO;
        _colligate = 2;
    } else if (butt.tag == 232)
    {
        btn1.selected = NO;
        btn2.selected = NO;
        btn3.selected = YES;
        _colligate = 1;
    }
}

//已经被评论..
- (void)end_commentAction:(UIButton *)butt
{
    butt.selected = YES;
    [butt setTitle:@"已评价" forState:UIControlStateSelected];
    [butt setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    butt.enabled = NO;
    
    _commentMaskV.hidden = NO;
}

//申诉
- (void)complainAction
{
    _maskView.hidden = NO;
}

//申诉提交
- (void)commitAction
{
    [_maskView endEditing:YES];
    _maskView.hidden = YES;
    
    [ProgressHUD show:@"正在提交..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    NSString *urlStr = [NSString stringWithFormat:@"%@appeal/complaint",apiBaseURL];
    NSString *content = [NSString stringWithFormat:@"%@#%@",_appealReason,_appealContent];
    NSDictionary *parameters = @{@"uid":USER,@"qid":[NSNumber numberWithInteger:_qid],@"content":content,@"status":[NSNumber numberWithInteger:1]};
    
    [manager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"answers :%@",responseObject);
        
        [ProgressHUD dismiss];
        [self update_status:5];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"answers :error = %@",error);
    }];
}

//反评论提交
- (void)comment_commitAction
{
    [_commentMaskV endEditing:YES];
    _commentMaskV.hidden = YES;
    
    [ProgressHUD show:@"正在提交..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    NSString *urlStr = [NSString stringWithFormat:@"%@reply/revert",apiBaseURL];
    NSDictionary *parameters = @{@"uid":USER,@"qid":[NSNumber numberWithInteger:_qid],@"content":_commentContent,@"colligate":[NSNumber numberWithInteger:_colligate]};
    
    [manager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"reply/revert :%@",responseObject);
        
        [ProgressHUD dismiss];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"reply/revert :error = %@",error);
        [ProgressHUD dismiss];
        [ProgressHUD showError:@"提交失败!"];
    }];
}

//单击事件
- (void)tapAction
{
    [_maskView endEditing:YES];
}

#pragma mark - Notification Action
//监听通知实现的方法
- (void)showKeyBoard:(NSNotification *)notification {
    
    //打印通知中传递的内容
    NSLog(@"%@",notification.userInfo);
    
    //拿到通知中传过来的字典中key对应的值
    NSValue *value = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    //解包
    CGRect rect = [value CGRectValue];
    CGFloat height = rect.size.height;
    
    //
    [UIView animateWithDuration:0.3 animations:^{
        
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
