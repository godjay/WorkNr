//
//  MaskView.m
//  问答
//
//  Created by xwbb on 16/2/17.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "MaskView.h"
#import "Common.h"
#import "PopPickerView.h"

@implementation MaskView

- (void)dealloc
{//移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Send_Value" object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1.0;
        
        [self loadData];
        
        //监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SendValueNotifi:) name:@"Send_Value" object:nil];
    };
    return self;
}

- (void)loadData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"%@categories",apiBaseURL];
    
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        [self loadDataDidFinish:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
    
}

#pragma mark - loadDataDidFinish
- (void)loadDataDidFinish:(id)data
{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *items = data[@"items"];
    for (NSDictionary *dic in items) {
        NSString *str = dic[@"cname"];
        [array addObject:str];
    }
    
    _array2 = [NSArray arrayWithArray:array];
    _array3 = _array2;
    [array removeObjectAtIndex:0];
    _array1 = [NSArray arrayWithArray:array];
    
    //在数据加载完以后才开始布局
    [self _createSubviews];
}

- (void)_createSubviews
{
    NSArray *titles = @[@"抢题范围一",@"抢题范围二",@"抢题范围三",@"牛豆数高于",@"差评数低于"];
//    _array1 = @[@"销售部",@"营销部",@"研发部",@"市场部",@"客服部",@"人事部",@"财务部",@"商务部",@"法律部",@"融资部",@"生产部",@"办公室"];
//    _array2 = @[@"未选",@"销售部",@"营销部",@"研发部",@"市场部",@"客服部",@"人事部",@"财务部",@"商务部",@"法律部",@"融资部",@"生产部",@"办公室"@"未选",@"销售部",@"营销部",@"研发部",@"市场部",@"客服部",@"人事部",@"财务部",@"商务部",@"法律部",@"融资部",@"生产部",@"办公室"@"未选",@"销售部",@"营销部",@"研发部",@"市场部",@"客服部",@"人事部",@"财务部",@"商务部",@"法律部",@"融资部",@"生产部",@"办公室"];
//    _array3 = @[@"未选",@"销售部",@"营销部",@"研发部",@"市场部",@"客服部",@"人事部",@"财务部",@"商务部",@"法律部",@"融资部",@"生产部",@"办公室"];
    _array4 = @[@"1",@"2",@"5"];
    _array5 = @[@"1",@"2",@"3",@"4",@"5"];
    _array = @[_array1,_array2,_array3,_array4,_array5];
    _choice1 = @"1";
    _choice2 = @"0";
    _choice3 = @"0";
    _choice4 = @"0";
    _choice5 = @"0";
    
    //标题
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake((self.width - 100) / 2, 20, 100, 20)];
    titleL.text = @"自动抢题设置";
    titleL.textAlignment = 1;
    titleL.font = [UIFont systemFontOfSize:15];
    [self addSubview:titleL];
    
    //选项以及标题
    for (int i = 0; i < titles.count; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth * .25, titleL.bottom + 40 * (i+1), kScreenWidth * .25, 20)];
        label.text = titles[i];
        label.font = [UIFont systemFontOfSize:15];
        [self addSubview:label];
        
        //选择按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, kScreenWidth * .25, 30);
        button.center = CGPointMake(label.right + 10 + kScreenWidth * .125, label.center.y);
        [button setBackgroundImage:[UIImage imageNamed:@"000.png"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button setTitle:_array[i][0] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.tag = 50 + i;
        [button addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    //确定按钮
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake( 40, self.height - 40, self.width - 80, 30);
    sureBtn.backgroundColor = [UIColor greenColor];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.tag = 258;
    sureBtn.layer.cornerRadius = 10.0;
    sureBtn.clipsToBounds = YES;
    [sureBtn addTarget:self action:@selector(comfirmAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sureBtn];
}

#pragma mark - Action
- (void)chooseAction:(UIButton *)butt
{
    UIButton *button1 = (UIButton *)[self viewWithTag:258];
    button1.enabled = NO;
    
    NSArray *arr = [NSArray array];
    switch (butt.tag) {
        case 50:
            arr = _array1;
            break;
        case 51:
            arr = _array2;
            break;
        case 52:
            arr = _array3;
            break;
        case 53:
            arr = _array4;
            break;
        case 54:
            arr = _array5;
            break;
            
        default:
            break;
    }
    
    _popPickerV = [[PopPickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/2.5) withDataSource:arr withTagNum:butt.tag];
    _popPickerV.center = CGPointMake(self.center.x, self.center.y - kScreenHeight / 5);
    _popPickerV.backgroundColor = [UIColor whiteColor];
    [self addSubview:_popPickerV];

}

- (void)comfirmAction
{
    NSString *choices = [NSString stringWithFormat:@"%@,%@,%@",_choice1,_choice2,_choice3];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    NSString *urlStr = [NSString stringWithFormat:@"%@set_question/genggai",apiBaseURL];
    NSDictionary *header = @{@"cate":choices,@"nd":_choice4,@"bad":_choice5};
    [manager POST:urlStr parameters:header progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"set_question/genggai :%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"set_question/genggai :error = %@",error);
    }];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HiddenMaskView" object:nil];
}

- (void)SendValueNotifi:(NSNotification *)notifi
{
    UIButton *button1 = (UIButton *)[self viewWithTag:258];
    button1.enabled = YES;
    
    NSDictionary *dic = notifi.userInfo;
    NSInteger titleNum = [dic[@"title"] integerValue];
    NSInteger tagNum = [dic[@"tagNum"] integerValue];
    if (tagNum == 50) {
        UIButton *btn = (UIButton *)[self viewWithTag:tagNum];
        [btn setTitle:_array1[titleNum] forState:UIControlStateNormal];
        _choice1 = [NSString stringWithFormat:@"%ld",titleNum+1];
    } else if (tagNum == 51)
    {
        UIButton *btn = (UIButton *)[self viewWithTag:tagNum];
        [btn setTitle:_array2[titleNum] forState:UIControlStateNormal];
        _choice2 = [NSString stringWithFormat:@"%ld",titleNum];
    } else if (tagNum == 52)
    {
        UIButton *btn = (UIButton *)[self viewWithTag:tagNum];
        [btn setTitle:_array3[titleNum] forState:UIControlStateNormal];
        _choice3 = [NSString stringWithFormat:@"%ld",titleNum];
    } else if (tagNum == 53)
    {
        UIButton *btn = (UIButton *)[self viewWithTag:tagNum];
        [btn setTitle:_array4[titleNum] forState:UIControlStateNormal];
        _choice4 = [NSString stringWithFormat:@"%ld",titleNum];
    } else if (tagNum == 54)
    {
        UIButton *btn = (UIButton *)[self viewWithTag:tagNum];
        [btn setTitle:_array5[titleNum] forState:UIControlStateNormal];
        _choice5 = [NSString stringWithFormat:@"%ld",titleNum];
    }
}

@end
