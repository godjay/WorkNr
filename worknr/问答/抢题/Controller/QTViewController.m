//
//  QTViewController.m
//  问答
//
//  Created by xwbb on 16/2/19.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "QTViewController.h"
#import "AnswerViewController.h"

#import "Common.h"
#import "UIImageView+AFNetworking.h"

@interface QTViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    UIControl *_maskView;
    UITableView *_tableView;
    NSArray *_dataArray; //举报原因
    NSMutableArray *_data; //获取的所有符合类型问题
    
    NSInteger _qid; //抢到的问题id
    NSInteger _uid; //抢到的问题的用户id
    NSString *_reason; //举报的原因
    
    NSTimer *_timer;
    int index;
    
}

@end

@implementation QTViewController

//push 进来时隐藏 TabBar
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

#pragma mark - View Life
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [ProgressHUD dismiss];
    
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"抢题";
    _dataArray = @[@"举报原因",@"题目与工作无关",@"题目不清晰",@"题目过多"];
    _data = [NSMutableArray array];
    
    //加载数据
    [self loadData];
    //修改视图边框
    [self correctSomeViews];
    //遮罩视图
    [self _createMaskView];
}

#pragma mark - 加载数据
//加载数据
- (void)loadData
{
    [ProgressHUD show:@"加载中..."];
    NSMutableArray *mArray = [NSMutableArray array];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    NSString *urlStr = [NSString stringWithFormat:@"%@questions",apiBaseURL];
    
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"questions :%@",responseObject);
        
        NSArray *arr = [NSArray arrayWithArray:responseObject];
        for (NSDictionary *dic in arr) {

            if ([dic[@"status"] integerValue] == 0) {
                [mArray addObject:dic];
            }
        }
        //再次获取数据
        [self again_loadData:mArray];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"questions :error = %@",error);
        //当数据加载失败是弹出提示框
        [self popAlertView];
    }];
}

//获取用户的抢题设置
- (void)again_loadData:(NSMutableArray *)mArray
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"%@set_questions/%d",apiBaseURL,[USER intValue]];
    
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"set_questions :%@",responseObject);
        //筛选数据
        [self filtrateData:mArray withDic:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"set_questions :error = %@",error);
        //当数据加载失败是弹出提示框
        [self popAlertView];
    }];
}

//筛选数据
- (void)filtrateData:(NSMutableArray *)mArray withDic:(id)dic
{
    NSArray *moneys = @[@"1",@"2",@"5"];
    //解析数据
    NSString *cate = dic[@"cate"];
    NSInteger nd = [dic[@"nd"] integerValue];
//    NSInteger bad = [dic[@"bad"] integerValue];
    NSInteger niuDou = [moneys[nd] integerValue];
    NSArray *cates = [cate componentsSeparatedByString:@","];
    
    //根据 givend 进行升序排列
    NSSortDescriptor *_sorter2 = [[NSSortDescriptor alloc] initWithKey:@"givend"
                                                             ascending:NO];
    NSArray *arr = [mArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:_sorter2, nil]];
    
    for (NSDictionary *dictionary in arr) {
//        NSLog(@"----%@",dictionary);
        if ([dictionary[@"cid"] integerValue] == [cates[0] integerValue] || [dictionary[@"cid"] integerValue] == [cates[1] integerValue] || [dictionary[@"cid"] integerValue] == [cates[2] integerValue]) {
//            NSLog(@"====%@",dictionary);
            if ([dictionary[@"givend"] integerValue] >= niuDou) {
                [_data addObject:dictionary];
            }
        }
    }
    
    if (_data.count <= 0) {
        [ProgressHUD dismiss];
        
        //Alert 提示框
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"没有适合您的题型,您可以修改抢题设置试试哦!" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertC animated:YES completion:nil];
        //确定按钮
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        [alertC addAction:action1];
        //取消按钮
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertC addAction:action2];
    } else
    {
        NSDictionary *dic = [_data firstObject];
        //获取该问题的用户信息
        [self get_UserInfo:dic];
    }
}

//获取该问题的用户信息
- (void)get_UserInfo:(NSDictionary *)dic
{
    _qid = [dic[@"id"] integerValue];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    NSString *urlStr = [NSString stringWithFormat:@"%@question/first",apiBaseURL];

    NSDictionary *parameters = @{@"qid":[NSNumber numberWithInteger:_qid]};
    [manager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"question/first :%@",responseObject);
        
        _uid = [responseObject[@"uid"] intValue];
        [ProgressHUD dismiss];
        //控件赋值
        [self set_subviewDatas:responseObject];
        //修改已被抢到问题的 status
        [self update_status:_qid];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"question/xinxi :error = %@",error);
        //当数据加载失败是弹出提示框
        [self popAlertView];
    }];
    
}

//控件赋值
- (void)set_subviewDatas:(NSDictionary *)u1Dic
{

     NSString *nameStr = u1Dic[@"nickname"];
    _messageL.text = u1Dic[@"content"];
    _givenL.text = [NSString stringWithFormat:@"%@牛豆",u1Dic[@"givend"]];
    
    NSString *str = u1Dic[@"pic"];

    if ([str isKindOfClass:[NSNull class]]) {
        return;
    }
    NSURL *url = [NSURL URLWithString:str];
    [_iconImageV setImageWithURL:url];
    
    if ([nameStr isKindOfClass:[NSNull class]]) {
        return;
    }
    _nickNameL.text = nameStr;
}

//更改已被抢到问题的 status
- (void)update_status:(NSInteger)qid
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    NSString *urlStr = [NSString stringWithFormat:@"%@questions/%ld",apiBaseURL,qid];
    NSDictionary *parameters = @{@"status":[NSNumber numberWithInteger:1]};
    [manager PATCH:urlStr parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
    
        //开启6S倒计时定时器
        if (!_timer) {
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeGoneAction:) userInfo:nil repeats:YES];
            index = 6;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"questions/status :error = %@",error);
        //当数据加载失败是弹出提示框
        [self popAlertView];
    }];
}

//当数据加载失败是弹出提示框
- (void)popAlertView
{
    [ProgressHUD dismiss];
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"数据加载失败!" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertC animated:YES completion:nil];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [alertC addAction:action];
}

#pragma mark -
//修改视图边框
- (void)correctSomeViews
{
    //创建导航栏左边按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"箭头.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //背景
    self.messageBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.messageBgView.layer.borderWidth = 1.0;
    //信息
    CGSize size = CGSizeMake(kScreenWidth - 20, self.messageBgView.height);
    NSDictionary *dic = @{
                          NSFontAttributeName :[UIFont systemFontOfSize:15]
                          };
    CGRect rect = [self.messageL.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    self.messageL.frame = rect;
    //举报按钮
    self.reportBtn.layer.cornerRadius = 35.0;
    self.reportBtn.clipsToBounds = YES;
    self.reportBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.reportBtn.layer.borderWidth = 1.0;
    self.reportBtn.enabled = NO;
    //跳过按钮
    self.nextStepBtn.layer.cornerRadius = 35.0;
    self.nextStepBtn.clipsToBounds = YES;
    self.nextStepBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.nextStepBtn.layer.borderWidth = 1.0;
    self.nextStepBtn.enabled = NO;
    //计时按钮
    self.timeBtn.layer.cornerRadius = 50.0;
    self.timeBtn.clipsToBounds = YES;
    self.timeBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.timeBtn.layer.borderWidth = 1.0;
    self.timeBtn.enabled = NO;
    
}

- (void)_createMaskView
{
    _maskView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    //设置背景颜色
    _maskView.backgroundColor = [UIColor colorWithWhite:.8 alpha:.5];
    //隐藏遮罩视图
    _maskView.hidden = YES;
    [self.tabBarController.view addSubview:_maskView];
    
    //
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(30, 0, kScreenWidth - 60, 120) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.center = CGPointMake(_maskView.center.x, _maskView.center.y - 20);
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_maskView addSubview:_tableView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(_tableView.left, _tableView.bottom + 20, _tableView.width, 30);
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"消息框.png"] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelReportAction) forControlEvents:UIControlEventTouchUpInside];
    [_maskView addSubview:cancelBtn];
}

#pragma mark - DataSource
//组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"same_cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, _tableView.height / 4)];
    titleL.text = _dataArray[indexPath.row];
    titleL.textAlignment = 1;
    titleL.layer.borderColor = [UIColor lightGrayColor].CGColor;
    titleL.layer.borderWidth = .3;
    if (indexPath.row == 0) {
        titleL.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"02.png"]];
        titleL.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else
    {
        titleL.textColor = [UIColor blackColor];
    }
    [cell.contentView addSubview:titleL];
    
    return cell;
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30; 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        
        //上传举报原因
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer
                                      serializerWithReadingOptions:NSJSONReadingAllowFragments];
        NSString *urlStr = [NSString stringWithFormat:@"%@report/create",apiBaseURL];
        NSDictionary *parameters = @{@"qid":[NSNumber numberWithInteger:_qid],@"uid":USER,@"reason":_dataArray[indexPath.row],@"status":[NSNumber numberWithInteger:1]};
        
        [manager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"report :%@",responseObject);
            _maskView.hidden = YES;
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"report :error = %@",error);
        }];
    }
}

#pragma mark - NSTimer
- (void)timeGoneAction:(NSTimer *)timer
{
    index --;
    [self.timeBtn setTitle:[NSString stringWithFormat:@"%d",index] forState:UIControlStateNormal];
    if (index <= 0) {
        self.timeBtn.enabled = YES;
        [self.timeBtn setTitle:@"抢题 10" forState:0];
        self.timeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        self.nextStepBtn.enabled = YES;
        self.reportBtn.enabled = YES;
        
        //终止定时器
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - Action
//返回
- (void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

//举报
- (IBAction)reportBtnAction:(UIButton *)sender {
    _maskView.hidden = NO;
}

//抢题
- (IBAction)timeBtnAction:(UIButton *)sender {
    AnswerViewController *answerVC = [[AnswerViewController alloc] init];
    answerVC.qid = _qid;
    answerVC.uid = [USER integerValue];
    [self.navigationController pushViewController:answerVC animated:YES];
}

//跳过
- (IBAction)nextStepBtnAvtion:(UIButton *)sender {
    NSLog(@"tiaoguo");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//举报原因 取消
- (void)cancelReportAction
{
    _maskView.hidden = YES;
}

@end
