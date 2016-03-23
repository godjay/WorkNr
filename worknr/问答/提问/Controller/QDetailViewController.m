//
//  QDetailViewController.m
//  问答
//
//  Created by xwbb on 16/2/17.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "QDetailViewController.h"
#import "RefuseView.h"
#import "QuestionCell.h"
#import "ChatModel.h"
#import "Common.h"

@interface QDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>

{
    UITableView *_tableView;
    UIView *_bgView;
    UIView *_bottomView1; //按钮背景图
    UIView *_bottomView2; //聊天背景图
    UIImageView *_bgImageView; //满意背景图
    UIControl *_maskView1;
    UIControl *_maskView2;
    RefuseView *_refuseV;
    UIView *_ratingBgView; //评分背景图
    NSArray *_moneys; //
    NSMutableArray *_dataArray; //数据源
    
    int _colligate; //综合评分
    float _addnd; //打赏牛豆数
    float _addReward; //增加悬赏
    NSString *_adoptContent; //采纳评价
    
//    NSTimer *_timer;
//    int index;
//    int time;
    
}

@property (assign, nonatomic) QDetailVCShowType showType;

@end

@implementation QDetailViewController
//push 进来时隐藏 TabBar
- (instancetype)initWithShowType:(QDetailVCShowType)showType
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.showType = showType;
    }
    return self;
}

- (void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Hidden-MaskView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"No_Hidden_RatingView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"No_Hidden_MaskView" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //结束编辑
    [self.view endEditing:YES];
    [ProgressHUD dismiss];
    
//    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"问题详情";
    _colligate = 3;
    _addnd = 0.0;
    _addReward = 0;
    _adoptContent = [NSString string];
    _dataArray = [NSMutableArray array];
    
    //创建导航栏左边按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"箭头.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    //获取答案数据
    [self get_answerData];
    //加载部分数据
    [self loadPartData];
    //开启定时器
    [self startTime];
    //创建子视图控件
    [self _createSubviews];
    //评分视图
    [self set_upRatingView];
    
    switch (self.showType) {
        case QDetailVCShowTypeAccept:
            
            _maskView2.hidden = NO;
//            _ratingBgView.hidden = NO;
            
            break;
        case QDetailVCShowTypeRefuse:
            [self _createMaskView];
            _maskView1.hidden = NO;
            
            break;
        default:
            
            break;
    }

    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifitionAction:) name:@"Hidden-MaskView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(no_Hidden_RatingView) name:@"No_Hidden_RatingView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(no_Hidden_MaskView) name:@"No_Hidden_MaskView" object:nil];
    
    //监听将要键盘弹出时发送的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hiddenKeyBoard) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -
//加载部分数据
- (void)loadPartData
{
    [ProgressHUD show:@"加载中..."];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    NSString *urlStr = [NSString stringWithFormat:@"%@questions/%d",apiBaseURL,_qid];
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"questions :%@",responseObject);
        
        _bgView.hidden = NO;
        _bottomView1.hidden = NO;
        [ProgressHUD dismiss];
        
        [_dataArray removeAllObjects];
        ChatModel *model = [[ChatModel alloc] init];
        model.nickname = USERNICK;
        model.pic = USERPIC;
        NSLog(@"%@",model.pic);
        model.givend = [responseObject[@"givend"] floatValue];
        model.content = responseObject[@"content"];
        [_dataArray addObject:model];
        
        [_tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error :%@",error);
    }];
}

//加载全部数据
- (void)loadAllData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    NSString *urlStr = [NSString stringWithFormat:@"%@question/xinxi",apiBaseURL];

    NSDictionary *dic = @{@"qid":[NSNumber numberWithInt:_qid]};
    [manager POST:urlStr parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"question/xinxi :%@",responseObject);
        
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
    [_tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}

//获取回答的数据
- (void)get_answerData
{
//    __block NSMutableArray *arr = [NSMutableArray array];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        //请求数据
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer
                                      serializerWithReadingOptions:NSJSONReadingAllowFragments];
        NSString *urlStr = [NSString stringWithFormat:@"%@answer/one",apiBaseURL];
        NSDictionary *dic = @{@"qid":[NSNumber numberWithInt:_qid]};
        [manager POST:urlStr parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (responseObject != NULL) {
                NSLog(@"answer/one :%@",responseObject);
                
                //数据请求成功后
                dispatch_source_cancel(timer); //关闭
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    _bgView.hidden = YES;
                    _bottomView1.hidden = YES;
                    _bottomView2.hidden = NO;
                    _bgImageView.hidden = NO;

                    _rid = [responseObject[@"rid"] intValue];
                    [ProgressHUD show:@"正在加载..."];
                    //加载所有数据
                    [self loadAllData];
                    
                    [self _createRightItem];
                });
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"answer/one :error = %@",error);
        }];
    });
    dispatch_resume(timer);
}

#pragma mark - 开启倒计时定时器
-(void)startTime{
    __block int timeout=600; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                UILabel *label = (UILabel *)[_bgView viewWithTag:94];
                label.text = @"24小时后问题关闭";
            });
        }else{
            //            int minutes = timeout / 60;
            int m = timeout/60;
            int s = timeout%60;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                UILabel *label = (UILabel *)[_bgView viewWithTag:94];
                label.text = [NSString stringWithFormat:@"问题已经发送给牛人,预计%02d:%02d分钟内回复",m,s];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark -
- (void)_createRightItem
{
    //创建导航栏右边按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 25, 5);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"点.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

//创建子视图
- (void)_createSubviews
{
    NSArray *moneys =@[@"0.1牛豆",@"0.5牛豆",@"1牛豆",@"2牛豆"];
    //表视图
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    //提示图--背景图
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 90, kScreenWidth, 150)];
    _bgView.backgroundColor = [UIColor clearColor];
    _bgView.hidden = YES;
    [_tableView addSubview:_bgView];
    
    //倒计时提示文字
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    titleL.text = @"问题已经发送给牛人,预计09:59分钟内回复";
    titleL.font = [UIFont systemFontOfSize:15];
    titleL.textAlignment = 1;
    titleL.tag = 94;
    titleL.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:titleL];
    
    //加速悬赏背景图
    UIView *subBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 100)];
    subBgView.backgroundColor = [UIColor whiteColor];
    subBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    subBgView.layer.borderWidth = 1.0;
    [_bgView addSubview:subBgView];
    
    //加速悬赏提示文字
    UILabel *speedL = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth , 30)];
    speedL.textAlignment = 1;
    speedL.text = @"您也可以增加悬赏, 加速获得答案!";
    speedL.backgroundColor = [UIColor clearColor];
    [subBgView addSubview:speedL];
    
    //加速悬赏牛豆按钮
    for (int i = 1; i <= moneys.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(20 + ((kScreenWidth - 100) / 4 + 20) * (i - 1), 50, (kScreenWidth - 100) / 4, 30);
        [button setTitle:moneys[i - 1] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"发送.png"] forState:UIControlStateHighlighted];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.layer.cornerRadius = 10.0;
        button.clipsToBounds = YES;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 1.0;
        button.tag = 100 + i;
        [button addTarget:self action:@selector(addMoneyAction:) forControlEvents:UIControlEventTouchUpInside];
        [subBgView addSubview:button];
    }
    
    //底部背景图1
    _bottomView1 = [[UIView alloc] initWithFrame:CGRectMake(0, (kScreenHeight - 30), kScreenWidth, 30)];
    _bottomView1.hidden = YES;
    [self.view addSubview:_bottomView1];
    
    //底部按钮
    //重新发送按钮
    UIButton *resendBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    resendBtn.frame = CGRectMake(0, 0, kScreenWidth / 2, _bottomView1.height);
    [resendBtn setBackgroundImage:[UIImage imageNamed:@"02.png"] forState:UIControlStateNormal];
    [resendBtn setTitle: @"重新提问" forState:UIControlStateNormal];
    [resendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [resendBtn addTarget:self action:@selector(reSendAction) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView1 addSubview:resendBtn];
    
    //取消提问按钮
    UIButton *canaelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    canaelBtn.frame = CGRectMake(kScreenWidth / 2, 0, kScreenWidth / 2, _bottomView1.height);
    [canaelBtn setBackgroundImage:[UIImage imageNamed:@"02.png"] forState:UIControlStateNormal];
    [canaelBtn setTitle: @"取消提问" forState:UIControlStateNormal];
    [canaelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [canaelBtn addTarget:self action:@selector(cancelQuestion) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView1 addSubview:canaelBtn];
    
    ////底部背景图2
    _bottomView2 = [[UIView alloc] initWithFrame:CGRectMake(0, (kScreenHeight - 30), kScreenWidth, 30)];
    _bottomView2.hidden = YES;
    [self.view addSubview:_bottomView2];
    
//    //语音按钮
//    UIButton *yyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    yyBtn.frame = CGRectMake(5, 0, 25, _bottomView2.height);
//    [yyBtn setBackgroundImage:[UIImage imageNamed:@"语音.png"] forState:UIControlStateNormal];
//    [yyBtn addTarget:self action:@selector(yyAction) forControlEvents:UIControlEventTouchUpInside];
//    [_bottomView2 addSubview:yyBtn];
    
    //输入框
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, _bottomView2.width, _bottomView2.height)];
    textField.placeholder = @"   请问还有别的吗?";
    textField.font = [UIFont systemFontOfSize:15];
    textField.layer.cornerRadius = 5.0;
    textField.clipsToBounds = YES;
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.layer.borderWidth = 1.0;
    textField.delegate = self;
    textField.tag = 395;
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
    
    //答案满意背景图
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 150) / 2, kScreenHeight / 2 + 50 - kNavBarHeight, 150, 150)];
    _bgImageView.hidden = YES;
    _bgImageView.image = [UIImage imageNamed:@"01.png"];
    _bgImageView.userInteractionEnabled = YES;
    [self.view addSubview:_bgImageView];
    
    //答案满意title
    UILabel *adoptL = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, _bgImageView.width, 20)];
    adoptL.text = @"答案满意吗?";
    adoptL.font = [UIFont systemFontOfSize:15];
    adoptL.textAlignment = 1;
    [_bgImageView addSubview:adoptL];
    
    UIButton *adoptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    adoptBtn.frame = CGRectMake((_bgImageView.width - 60) / 2, adoptL.bottom + 10, 60, 30);
    [adoptBtn setTitle:@"满意" forState:UIControlStateNormal];
    [adoptBtn setBackgroundImage:[UIImage imageNamed:@"橙色.png"] forState:UIControlStateNormal];
    adoptBtn.layer.cornerRadius = 5.0;
    adoptBtn.clipsToBounds = YES;
    adoptBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    adoptBtn.layer.borderWidth = 1.0;
    [adoptBtn addTarget:self action:@selector(adoptAction) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:adoptBtn];
}

//遮罩视图
- (void)_createMaskView
{
    _maskView1 = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    //设置背景颜色
    _maskView1.backgroundColor = [UIColor colorWithWhite:.8 alpha:.5];
    //隐藏遮罩视图
//    _maskView1.hidden = YES;
    [self.tabBarController.view addSubview:_maskView1];
    
    _refuseV = [[[NSBundle mainBundle] loadNibNamed:@"RefuseView" owner:self options:nil] lastObject];
    _refuseV.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight / 2);
    _refuseV.center = _maskView1.center;
    [_maskView1 addSubview:_refuseV];
    
    //单击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [_refuseV addGestureRecognizer:tap];
}

//创建评分视图
- (void)set_upRatingView
{
    _maskView2 = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    //设置背景颜色
    _maskView2.backgroundColor = [UIColor colorWithWhite:.8 alpha:.5];
    //隐藏遮罩视图
    _maskView2.hidden = YES;
    [self.tabBarController.view addSubview:_maskView2];
    
    //评分背景图
    _ratingBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight * .7)];
    _ratingBgView.center = _maskView2.center;
    _ratingBgView.backgroundColor = [UIColor whiteColor];
    _ratingBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _ratingBgView.layer.borderWidth = 1.0;
//    _ratingBgView.hidden = YES;
    [_maskView2 addSubview:_ratingBgView];
    
    //单击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [_ratingBgView addGestureRecognizer:tap];
    
    //评分视图以及标题
    NSArray *titles = @[@"牛人服务态度",@"牛人答题速度",@"牛人答题质量"];
    for (int i = 0; i < titles.count; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth * .125, 30 * (i+1), kScreenWidth * .4+15, 20)];
        label.text = titles[i];
        label.textAlignment = 0;
        label.font = [UIFont systemFontOfSize:15];
        //ping分
        RatingBar *bar = [[RatingBar alloc] initWithFrame:CGRectMake(50, 50, kScreenWidth * .5, 30)];
        bar.center = CGPointMake(label.right + 10, label.center.y);
        bar.tag = 600 + i;
        [_ratingBgView addSubview:bar];
        [_ratingBgView addSubview:label];
    }
    
    //选择 花
    NSArray *imageNames = @[@"red.png",@"yellowFlower.png",@"gray.png"];
    for (int j = 0; j < imageNames.count; j ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 15, 15);
        RatingBar *bar = (RatingBar *)[_ratingBgView viewWithTag:602];
        button.center = CGPointMake((kScreenWidth / 4 - 10) * (j + 1), bar.center.y + 40);
        [button setBackgroundImage:[UIImage imageNamed:@"quan.png"] forState:UIControlStateSelected];
        button.tag = 200 + j;
        [button addTarget:self action:@selector(chooseFlower:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 7.5;
        button.clipsToBounds = YES;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 1.0;
        if (j == 0) {
            button.selected = YES;
        }
        [_ratingBgView addSubview:button];
        
        //花
        UIImageView *flowerImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        flowerImageV.center = CGPointMake(button.center.x + 20, button.center.y);
        flowerImageV.tag = 100101 + j;
        flowerImageV.image = [UIImage imageNamed:imageNames[j]];
        [_ratingBgView addSubview:flowerImageV];
    }
    //获取视图
    UIImageView *imageV = (UIImageView *)[_ratingBgView viewWithTag:100101];
    
    //评论输入框
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(25, imageV.center.y + 20 , kScreenWidth - 50, kScreenHeight * .18)];
    textView.delegate = self;
    textView.font = [UIFont systemFontOfSize:15];
    textView.layer.cornerRadius = 10.0;
    textView.layer.borderColor = [UIColor grayColor].CGColor;
    textView.layer.borderWidth = 1.0;
    [_ratingBgView addSubview:textView];
    
    //提示文
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 150, 20)];
    label.text = @"牛人好评!";
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:13];
    label.tag = 10011;
    [textView addSubview:label];
    
    //悬赏 label
    UILabel *xsLabel = [[UILabel alloc] initWithFrame:CGRectMake(textView.left + 10, textView.bottom + 30, 50, 20)];
    xsLabel.text = @"打赏";
    xsLabel.font = [UIFont systemFontOfSize:15];
    [_ratingBgView addSubview:xsLabel];
    
    //牛豆
    float x = xsLabel.center.x - 10;
    float y = xsLabel.center.y - 10;
    _moneys = @[@"0.1牛豆",@"0.5牛豆",@"1牛豆",@"2牛豆"];
    for (int i = 1; i <= 4; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 30, 30);
        button.tag = 300 + i;
        button.center = CGPointMake(x + i * 50, y);
        [button setBackgroundImage:[UIImage imageNamed:@"豆子.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"豆子深色.png"] forState:UIControlStateSelected];
//        if (i == 1) {
//            button.selected = YES;
//        }
        [button addTarget:self action:@selector(chooseMoneyAction:) forControlEvents:UIControlEventTouchUpInside];
        [_ratingBgView addSubview:button];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        label.center = CGPointMake(button.center.x, button.center.y + 30);
        label.text = _moneys[i-1];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        [_ratingBgView addSubview:label];
    }
    
    //提交按钮
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CGRectMake(0, 0, _ratingBgView.width - 80, 30);
    commitBtn.center = CGPointMake(_ratingBgView.center.x, _ratingBgView.height - 35);
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitBtn setBackgroundImage:[UIImage imageNamed:@"消息框.png"] forState:UIControlStateNormal];
    commitBtn.layer.cornerRadius = 10;
    commitBtn.clipsToBounds = YES;
    [commitBtn addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [_ratingBgView addSubview:commitBtn];
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
//单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}


#pragma mark - TextField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    _adoptContent = textField.text;
    _content = textField.text;
}

#pragma mark - Action
//返回
- (void)leftBtnAction
{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    NSString *urlStr = [NSString stringWithFormat:@"%@questions/%d",apiBaseURL,_qid];
    
    [manager DELETE:urlStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"question/delete :%@",responseObject);
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error=%@",error);
    }];
}

//不采纳
- (void)rightBtnAction
{
    NSLog(@"不");
    [self _createMaskView];
//    _maskView1.hidden = NO;
    
}

//增加悬赏
- (void)addMoneyAction:(UIButton *)butt
{
    NSLog(@"增加悬赏");
    switch (butt.tag) {
        case 101:
            _addReward = 0.1;
            break;
        case 102:
            _addReward = 0.5;
            break;
        case 103:
            _addReward = 1;
            break;
        case 104:
            _addReward = 2;
            break;
            
        default:
            break;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    NSString *urlStr = [NSString stringWithFormat:@"%@question/addnd",apiBaseURL];
    
    NSDictionary *dic = @{@"qid":[NSNumber numberWithInt:_qid],@"nd":[NSNumber numberWithInt:_addReward]};
    [manager POST:urlStr parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"question/addnd :%@",responseObject);
        
        //刷新数据
        [self loadPartData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"question/addnd :error = %@",error);
    }];
}

//重新发送
- (void)reSendAction
{
    [self leftBtnAction];
}

//取消提问
- (void)cancelQuestion
{
    NSLog(@"取消提问");
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    NSString *urlStr = [NSString stringWithFormat:@"%@questions/%d",apiBaseURL,_qid];
    
    [manager DELETE:urlStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"question/create :%@",responseObject);
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        NSLog(@"error=%@",error);
    }];
}

//发送
- (void)sendAction
{
    NSLog(@"发送");
    //结束编辑
    [self.view endEditing:YES];
    UITextField *textField = (UITextField *)[_bottomView2 viewWithTag:395];
    textField.text = nil;
    
    //发送请求
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"%@question/zhuiwen",apiBaseURL];
    NSDictionary *pars = @{@"cid":[NSNumber numberWithInt:_cid],@"status":[NSNumber numberWithInt:1],@"content":_content,@"additional":[NSNumber numberWithInt:_rid]};
    [manager POST:urlStr parameters:pars progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"uestion/zhuiwen :%@",responseObject);
        //刷新数据
        [self loadAllData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"uestion/zhuiwen :error = %@",error);
    }];
    
}

- (void)adoptAction
{
//    NSLog(@"满意");
    _bottomView2.hidden = YES;
    _bgImageView.hidden = YES;
    _maskView2.hidden = NO;
}

//选择 花
- (void)chooseFlower:(UIButton *)butt
{
    UIButton *btn1 = (UIButton *)[_ratingBgView viewWithTag:200];
    UIButton *btn2 = (UIButton *)[_ratingBgView viewWithTag:201];
    UIButton *btn3 = (UIButton *)[_ratingBgView viewWithTag:202];
    if (butt.tag == 200) {
        btn1.selected = YES;
        btn2.selected = NO;
        btn3.selected = NO;
        _colligate = 3;
    } else if (butt.tag == 201)
    {
        btn1.selected = NO;
        btn2.selected = YES;
        btn3.selected = NO;
        _colligate = 2;
    } else if (butt.tag == 202)
    {
        btn1.selected = NO;
        btn2.selected = NO;
        btn3.selected = YES;
        _colligate = 1;
    }
}

//打赏
- (void)chooseMoneyAction:(UIButton *)butt
{

    UIButton *btn1 = (UIButton *)[_ratingBgView viewWithTag:301];
    UIButton *btn2 = (UIButton *)[_ratingBgView viewWithTag:302];
    UIButton *btn3 = (UIButton *)[_ratingBgView viewWithTag:303];
    UIButton *btn4 = (UIButton *)[_ratingBgView viewWithTag:304];
    if (butt.tag == 301) {
        btn1.selected = YES;
        btn2.selected = NO;
        btn3.selected = NO;
        btn4.selected = NO;
        _addnd = 0.1;
    } else if (butt.tag == 302)
    {
        btn1.selected = NO;
        btn2.selected = YES;
        btn3.selected = NO;
        btn4.selected = NO;
        _addnd = 0.5;
    } else if (butt.tag == 303)
    {
        btn1.selected = NO;
        btn2.selected = NO;
        btn3.selected = YES;
        btn4.selected = NO;
        _addnd = 1;
    } else if (butt.tag == 304)
    {
        btn1.selected = NO;
        btn2.selected = NO;
        btn3.selected = NO;
        btn4.selected = YES;
        _addnd = 2;
    }
}

- (void)commitAction
{
    [_maskView2 endEditing:YES];
    self.view.userInteractionEnabled = NO;
    
    RatingBar *bar1 = (RatingBar *)[_ratingBgView viewWithTag:600];
//    NSLog(@"%ld",bar1.starNumber);
    RatingBar *bar2 = (RatingBar *)[_ratingBgView viewWithTag:601];
//    NSLog(@"%ld",bar2.starNumber);
    RatingBar *bar3 = (RatingBar *)[_ratingBgView viewWithTag:602];
//    NSLog(@"%ld",bar3.starNumber);
    
    NSString *grade = [NSString stringWithFormat:@"%ld,%ld,%ld",bar1.starNumber,bar2.starNumber,bar3.starNumber];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    NSString *urlStr = [NSString stringWithFormat:@"%@score/add",apiBaseURL];
    NSNumber *colligate = [NSNumber numberWithInt:_colligate];
    NSNumber *addnd = [NSNumber numberWithFloat:_addnd];
    NSNumber *rid = [NSNumber numberWithInt:_rid];
    NSNumber *qid = [NSNumber numberWithInt:_qid];
    NSDictionary *dic = @{@"grade":grade,
                         @"colligate":colligate,
                         @"qid":qid,
                         @"addnd":addnd,
                         @"content":_adoptContent,
                         @"rid":rid};
    [manager POST:urlStr parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"score/create :%@",responseObject);
        //更改已被抢到问题的 status
        [self update_status:4];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"score/create :error = %@",error);
    }];
    
//    NSLog(@"提交");
}

//更改已被抢到的问题的 status
- (void)update_status:(NSInteger)status
{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer
                                      serializerWithReadingOptions:NSJSONReadingAllowFragments];
        NSString *urlStr = [NSString stringWithFormat:@"%@questions/%d",apiBaseURL,_qid];
        NSDictionary *parameters = @{@"status":[NSNumber numberWithInteger:status]};
        [manager PATCH:urlStr parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
            NSLog(@"%@",responseObject);
            switch (status) {
                case 4:
                    //弹出提示框
                    [self popAlertViewAction];
                    break;
                case 2:
                    _maskView1.hidden = YES;
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    break;
                    
                default:
                    break;
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"questions/status :error = %@",error);
        }];
}

//弹出提 示框
- (void)popAlertViewAction
{
    UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 40, 90)];
    alertView.center = CGPointMake(_maskView2.center.x, _maskView2.center.y);
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.layer.borderColor = [UIColor grayColor].CGColor;
    alertView.layer.borderWidth = 1.0;
    alertView.tag = 1001010;
    [_maskView2 addSubview:alertView];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, alertView.width, 30)];
    titleL.text = @"评论完成!";
    titleL.textAlignment = 1;
    [alertView addSubview:titleL];
    
    UILabel *messageL = [[UILabel alloc] initWithFrame:CGRectMake(0, titleL.bottom + 10, alertView.width, 30)];
    messageL.text = @"3秒后返回主界面...";
    messageL.font = [UIFont systemFontOfSize:15];
    messageL.textAlignment = 1;
    messageL.tag = 1001011;
    [alertView addSubview:messageL];
    
    
#pragma mark 开启定时器
    __block int timeout=3; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                _maskView2.hidden = YES;
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                messageL.text = [NSString stringWithFormat:@"%d秒后返回主界面...",timeout];
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

//单击事件
- (void)tapAction
{
    [_maskView1 endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        
        _refuseV.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - 通知
- (void)notifitionAction:(NSNotification *)notifi
{
    [_maskView1 endEditing:YES];
    _maskView1.hidden = YES;
    NSLog(@"qid :%d",_qid);
    NSDictionary *dic = notifi.userInfo;
    [ProgressHUD show:@"正在提交..."];
    NSString *refuseContent = [NSString stringWithFormat:@"%@#%@",dic[@"reason"],dic[@"content"]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    NSString *urlStr = [NSString stringWithFormat:@"%@answer/bian",apiBaseURL];
    NSDictionary *parameters = @{@"qid":[NSNumber numberWithInteger:_qid],@"status":[NSNumber numberWithInteger:1],@"reason":refuseContent};
    [manager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"answer(patch) :%@",responseObject);
        [ProgressHUD dismiss];
        //更改已被抢到问题的 status
        [self update_status:2];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"answer(patch) :error = %@",error);
        [ProgressHUD dismiss];
    }];
}

- (void)no_Hidden_RatingView
{
    _ratingBgView.hidden = NO;
}

- (void)no_Hidden_MaskView
{
    _maskView1.hidden = NO;
}

//监听通知实现的方法
- (void)showKeyBoard:(NSNotification *)notification {

    //拿到通知中传过来的字典中key对应的值
    NSValue *value = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    //解包
    CGRect rect = [value CGRectValue];
    CGFloat height = rect.size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _refuseV.transform = CGAffineTransformMakeTranslation(0, -kScreenHeight / 6);
        _ratingBgView.transform = CGAffineTransformMakeTranslation(0, -kScreenHeight / 6);
        _bottomView2.transform = CGAffineTransformMakeTranslation(0, -height);
    }];
}

- (void)hiddenKeyBoard
{
    [UIView animateWithDuration:0.3 animations:^{
        
        _refuseV.transform = CGAffineTransformIdentity;
        _bottomView2.transform = CGAffineTransformIdentity;
        _ratingBgView.transform = CGAffineTransformIdentity;
    }];
}


#pragma mark - TextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    UILabel *label = (UILabel *)[_ratingBgView viewWithTag:10011];
    [label removeFromSuperview];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    _adoptContent = textView.text;
}

@end
