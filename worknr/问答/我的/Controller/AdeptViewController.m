//
//  AdeptViewController.m
//  问答
//
//  Created by xwbb on 16/2/21.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "AdeptViewController.h"
#import "RJUser.h"
#import "TLTagsControl.h"

@interface AdeptViewController () <TLTagsControlDelegate>
@property (weak, nonatomic) IBOutlet UITextField *identityField;
@property (weak, nonatomic) IBOutlet UITextView *introduceField;
@property (nonatomic,strong)NSMutableArray *userArray;
@property (strong, nonatomic) IBOutlet TLTagsControl *LableCreat;
@property (strong,nonatomic) NSMutableArray *tags;
@property (weak, nonatomic) IBOutlet TLTagsControl *tagsScroll;
@end

@implementation AdeptViewController 

- (NSMutableArray *)userArray{
    if (_userArray == nil) {
        _userArray = [NSMutableArray array];
    }
    return _userArray;
}

- (NSMutableArray *)tags{
    if (_tags == nil) {
        _tags = [NSMutableArray array];
    }
    return _tags;
}

#pragma mark - View Life
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"我的擅长";
    [self setupBtn];
}

#pragma mark - TLTagsControlDelegate
- (void)tagsControl:(TLTagsControl *)tagsControl tappedAtIndex:(NSInteger)index {
    NSLog(@"Tag \"%@\" was tapped", tagsControl.tags[index]);
}

- (void)requestData{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    //json解析所有格式
    manger.responseSerializer = [AFJSONResponseSerializer
                                 serializerWithReadingOptions:NSJSONReadingAllowFragments];
    NSString *urlString = [NSString stringWithFormat:@"%@users/%@",apiBaseURL,USER];
    [manger GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //字典转模型
        self.userArray = responseObject[@"items"];
        RJUser *user = [RJUser mj_objectWithKeyValues:responseObject];
        
        self.identityField.text = user.identity;
        self.introduceField.text = user.introduce;
        
        NSLog(@"user.label    %@",user.label);
        NSRange range = [user.label rangeOfString:@","];
        if (range.length != 0){
            NSArray *tagss = [user.label componentsSeparatedByString:@","];
            _tags = [NSMutableArray arrayWithArray:tagss];
        }else if(user.label.length == 0){
            _tags = [NSMutableArray arrayWithObject:[NSString stringWithFormat:@"请添加标签"]];
        }else{
            _tags = [NSMutableArray arrayWithObject:user.label];
        }
        _LableCreat.tags = [_tags mutableCopy];
        _LableCreat.tagsBackgroundColor = [UIColor whiteColor];
        _LableCreat.tagsTextColor = [UIColor greenColor];
        _LableCreat.tagPlaceholder = @"请输入标签";
        [_LableCreat reloadTagSubviews];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)setupBtn{
    //创建导航栏左边按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"箭头.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //创建导航栏右边按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 50, 30);
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;

}

#pragma mark - Action
//返回
- (void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnAction
{
    [_LableCreat reloadTagSubviewsWithTags:_tags];
//    RJUser *user = self.userArray[0];
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    //json解析所有格式
    manger.responseSerializer = [AFJSONResponseSerializer
                                 serializerWithReadingOptions:NSJSONReadingAllowFragments];
    NSString *urlString = [NSString stringWithFormat:@"%@users/%@",apiBaseURL,USER];
    NSDictionary *params = @{
                             @"identity" : self.identityField.text,
                             @"introduce" : self.introduceField.text,
                             };
    [manger PATCH:urlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

//监听通知实现的方法
- (void)showKeyBoard:(NSNotification *)notification {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, -kScreenHeight / 6);
        _introduceField.transform = CGAffineTransformMakeTranslation(0, -kScreenHeight / 6);
    }];
}



@end
