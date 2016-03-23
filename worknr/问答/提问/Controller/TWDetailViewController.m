//
//  TWDetailViewController.m
//  问答
//
//  Created by xwbb on 16/2/17.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "TWDetailViewController.h"
#import "QDetailViewController.h"

#import "Common.h"

@interface TWDetailViewController ()<UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

{
    UIButton *_checkBtn; //分类按钮
    UIPickerView *_pickerView; //类别选择器
    
    NSInteger _cid;
    float _givend;
    NSString *_content;
    
    NSArray *_dataArray;
    NSArray *_moneys;
}

@end

@implementation TWDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
    [self.view endEditing:YES];
}

//push 进来时隐藏 TabBar
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提问";
    _cid = 1;
    _givend = 0.1;

    //创建导航栏左边按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"箭头.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //创建导航栏右边按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 50, 50);
    [rightBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn addTarget:self action:@selector(nextStepAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self loadData];
    [self _createSubViews];
    
}

//加载数据
- (void)loadData
{
    _moneys = @[@"0.1牛豆",@"0.5牛豆",@"1牛豆",@"2牛豆"];
    

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"%@categories",apiBaseURL];
    
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        NSMutableArray *array = [NSMutableArray array];
        NSArray *items = responseObject[@"items"];
        for (NSDictionary *dic in items) {
            NSString *str = dic[@"cname"];
            [array addObject:str];
        }
        _dataArray = [NSArray arrayWithArray:array];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
}

//创建子视图
- (void)_createSubViews
{
    //文本框
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight * .25)];
    textView.delegate = self;
    textView.font = [UIFont systemFontOfSize:19];
    textView.layer.cornerRadius = 10.0;
    textView.layer.borderColor = [UIColor grayColor].CGColor;
    textView.layer.borderWidth = 1.0;
    [self.view addSubview:textView];
    
    //提示文
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 150, 20)];
    label.text = @"在此描述你的问题";
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:17];
    label.tag = 10;
    [textView addSubview:label];
    
    //计数
    UILabel *numLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(textView.right - 110, textView.bottom - 20, 100, 10)];
    numLabel1.text = [NSString stringWithFormat:@"%@/100",@"0"];
    numLabel1.textColor = [UIColor lightGrayColor];
    numLabel1.font = [UIFont systemFontOfSize:15];
    numLabel1.textAlignment = NSTextAlignmentRight;
    numLabel1.tag = 11;
    [self.view addSubview:numLabel1];
    
    //悬赏 label
    UILabel *xsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, numLabel1.bottom + 50, 50, 20)];
    xsLabel.text = @"悬赏";
    [self.view addSubview:xsLabel];
    
    //牛豆
    float x = xsLabel.center.x;
    float y = xsLabel.center.y;
    for (int i = 1; i <= 4; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 30, 30);
        button.tag = 100 + i;
        button.center = CGPointMake(x + i * 50, y);
        [button setBackgroundImage:[UIImage imageNamed:@"豆子"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"豆子深色.png"] forState:UIControlStateSelected];
        if (i == 1) {
            button.selected = YES;
            _givend = 0.1;
        }
        [button addTarget:self action:@selector(checkNiuDouAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        label.center = CGPointMake(button.center.x, button.center.y + 30);
        label.text = _moneys[i-1];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        [self.view addSubview:label];
    }
    
    //问题分类
    UILabel *bgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, xsLabel.bottom + 100, kScreenWidth, 40)];
    bgLabel.layer.borderColor = [UIColor grayColor].CGColor;
    bgLabel.layer.borderWidth = 1.0;
    bgLabel.userInteractionEnabled = YES;
    [self.view addSubview:bgLabel];
    
    UILabel *fLabel = [[UILabel alloc] initWithFrame:CGRectMake(xsLabel.left, (bgLabel.height - 20) / 2, 70, 20)];
    fLabel.text = @"问题分类";
//    fLabel.font = [UIFont systemFontOfSize:15];
    [bgLabel addSubview:fLabel];
    
    _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _checkBtn.frame = CGRectMake(fLabel.right + 20, fLabel.top, 80, 20);
    [_checkBtn setTitle:@"销售部" forState:UIControlStateNormal];
    [_checkBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    _checkBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [_checkBtn addTarget:self action:@selector(checkAction) forControlEvents:UIControlEventTouchUpInside];
    [bgLabel addSubview:_checkBtn];
}

#pragma mark - Action
//返回
- (void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)checkNiuDouAction:(UIButton *)butt
{
    [self.view endEditing:YES];
    
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:101];
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:102];
    UIButton *btn3 = (UIButton *)[self.view viewWithTag:103];
    UIButton *btn4 = (UIButton *)[self.view viewWithTag:104];
    if (butt.tag == 101) {
        btn1.selected = YES;
        btn2.selected = NO;
        btn3.selected = NO;
        btn4.selected = NO;
        _givend = 0.1;
    } else if (butt.tag == 102)
    {
        btn1.selected = NO;
        btn2.selected = YES;
        btn3.selected = NO;
        btn4.selected = NO;
        _givend = 0.5;
    } else if (butt.tag == 103)
    {
        btn1.selected = NO;
        btn2.selected = NO;
        btn3.selected = YES;
        btn4.selected = NO;
        _givend = 1;
    } else if (butt.tag == 104)
    {
        btn1.selected = NO;
        btn2.selected = NO;
        btn3.selected = NO;
        btn4.selected = YES;
        _givend = 2;
    }
}

- (void)checkAction
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
    bgView.center = self.view.center;
    bgView.backgroundColor = [UIColor colorWithRed:236 / 255.0 green:237 /255.0 blue:239 /255.0 alpha:1];
    bgView.tag = 12;
    [self.view addSubview:bgView];
    
    //选择器
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,0, bgView.width, 250)];
    //设置代理
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    [bgView addSubview:_pickerView];
    
    //确定按钮
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(5,_pickerView.bottom + 10, bgView.width - 10, 30);
    sureBtn.layer.cornerRadius = 10.0;
    sureBtn.clipsToBounds = YES;
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sureBtn.backgroundColor = [UIColor greenColor];
    [sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:sureBtn];
}

- (void)sureBtnAction
{
    [self.view endEditing:YES];
    
    UIView *bgView = [self.view viewWithTag:12];
    [bgView removeFromSuperview];
}

- (void)nextStepAction
{
    [self.view endEditing:YES];
    if (_content.length <= 0) {
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:nil message:@"请输入你要提问的问题!" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        return;
    }
    
    [ProgressHUD show:@"正在加载..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    NSString *urlStr = [NSString stringWithFormat:@"%@question/create",apiBaseURL];
    NSNumber *cid = [NSNumber numberWithInteger:_cid];
    NSNumber *givend = [NSNumber numberWithFloat:_givend];
    NSNumber *status = [NSNumber numberWithInt:0];
    NSDictionary *dic = @{@"cid":cid,@"givend":givend,@"status":status,@"content":_content};
    
    [manager POST: urlStr parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"question/create :%@",responseObject);
        NSLog(@"qid :%d",[responseObject[@"id"] intValue]);
        NSLog(@"cid :%d",[responseObject[@"cid"] intValue]);
        //取消提示
        [ProgressHUD dismiss];
        //跳转界面
        QDetailViewController *qdVC = [[QDetailViewController alloc] init];
        qdVC.qid = [responseObject[@"id"] intValue];
        qdVC.cid = [responseObject[@"cid"] intValue];
        [self.navigationController pushViewController:qdVC animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error=%@",error);
    }];
    
    
}

#pragma mark - TextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    UILabel *label = (UILabel *)[self.view viewWithTag:10];
    [label removeFromSuperview];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    UILabel *label = (UILabel *)[self.view viewWithTag:11];
    label.text = [NSString stringWithFormat:@"%ld/100",textView.text.length];
    if (textView.text.length >= 100) {
        NSLog(@"%ld",textView.text.length);
        textView.editable = NO;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    _content = textView.text;
}

#pragma mark - UIPickView DataSoucre
//返回列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//返回行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _dataArray.count;
}

#pragma mark - UIPickView Delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%@",_dataArray[row]];
}

///设置row的高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

//选择某个row时,调用此方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _cid = [pickerView selectedRowInComponent:component] + 1;
    NSString *title = [NSString stringWithFormat:@"%@",_dataArray[[pickerView selectedRowInComponent:component]]];
    [_checkBtn setTitle:title forState:UIControlStateNormal];
}

@end
