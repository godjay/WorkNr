//
//  changeNumController.m
//  问答
//
//  Created by lirenjie on 16/3/9.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "changeNumController.h"

@interface changeNumController () <UITextFieldDelegate>
@property (weak,nonatomic)UIButton *rightBtn;
@property (strong,nonatomic)UITextField *numField;
@end

@implementation changeNumController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手机号";
    [self setupItemView];
    [self setupFiled];
}

- (void)setupFiled{
    _numField = [[UITextField alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 50)];
    _numField.backgroundColor = [UIColor whiteColor];
    _numField.delegate = self;
    _numField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_numField];
}

- (void)setupItemView{
    //创建导航栏左边按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 50, 50);
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(cancleBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //创建导航栏右边按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 50, 50);
    rightBtn.userInteractionEnabled = NO;
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

    self.rightBtn = rightBtn;
    [rightBtn addTarget:self action:@selector(tureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.rightBtn.userInteractionEnabled = YES;
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.numField.text.length == 0) {
        self.rightBtn.userInteractionEnabled = NO;
        [self.rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

- (void)tureBtnAction{
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    //json解析所有格式
    manger.responseSerializer = [AFJSONResponseSerializer
                                 serializerWithReadingOptions:NSJSONReadingAllowFragments];
    NSString *urlString = [NSString stringWithFormat:@"%@users/%@",apiBaseURL,USER];
    NSDictionary *params = @{
                             @"username" : self.numField.text
                             };
    [manger PATCH:urlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}


//返回
- (void)cancleBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
