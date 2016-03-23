//
//  PrersonalTableViewController.m
//  问答
//
//  Created by lirenjie on 16/2/20.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "PrersonalTableViewController.h"
#import "RJPersonalDetialCell.h"
#import "RJPersonalPicTableViewCell.h"
#import "RJUser.h"
#import "changeNickNameController.h"
#import "changeSexController.h"
#import "changeNumController.h"
#import "changeEmailController.h"
#import <UIImageView+WebCache.h>
#import "chooseIconViewController.h"
#import "changeAreaController.h"
@interface PrersonalTableViewController () <changeNickNameControllerDelegate,changeSexControllerDelegate,changeNumControllerDelegate,changeEmailControllerDelegate>
@property (weak,nonatomic)UIImageView *imageView;
@property (nonatomic,strong)RJUser *user;

@end

@implementation PrersonalTableViewController

- (NSMutableArray *)titleArray{
    if (_titleArray == nil) {
        _titleArray = [[NSMutableArray alloc] init];
    }
    return _titleArray;
}

- (NSMutableArray *)lastArray{
    if (_lastArray == nil) {
        _lastArray = [[NSMutableArray alloc] init];
    }
    return _lastArray;
}


- (void)viewWillAppear:(BOOL)animated{
    [self requestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];
    
    self.view.backgroundColor = [UIColor colorWithRed:236 / 255.0 green:237 /255.0 blue:239 /255.0 alpha:1];
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //创建导航栏左边按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"箭头.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;

    _titleArray = [NSMutableArray arrayWithObjects:@"昵称",@"性别",@"地区",@"手机号",@"邮箱地址", nil];

}

- (void)requestData{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    //json解析所有格式
    manger.responseSerializer = [AFJSONResponseSerializer
                                 serializerWithReadingOptions:NSJSONReadingAllowFragments];
    NSString *urlString = [NSString stringWithFormat:@"%@users/%@",apiBaseURL,USER];
    [manger GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"666%@",responseObject);

        _user = [RJUser mj_objectWithKeyValues:responseObject];
        if ([_user.phone isEqualToString:@"99999999999"]) {
            _lastArray = [NSMutableArray arrayWithObjects:_user.nickname,_user.sex,_user.area,@"空",_user.email, nil];
        }else{
        _lastArray = [NSMutableArray arrayWithObjects:_user.nickname,_user.sex,_user.area,_user.phone,_user.email, nil];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titleArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (indexPath.row == 0) {
        static NSString *ID = @"DEP";
        RJPersonalPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[RJPersonalPicTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        cell.titleL.text = @"头像";
        [cell.lastP sd_setImageWithURL:_user.pic placeholderImage:[UIImage imageNamed:@"Q Q"]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else{
        
        static NSString *ID = @"DE";
        RJPersonalDetialCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[RJPersonalDetialCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        cell.titleL.text = _titleArray[indexPath.row - 1];
//        if (_lastArray[indexPath.row - 1] != nil) {
            cell.lastL.text = _lastArray[indexPath.row - 1];
//        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    if (indexPath.row == 1) {
        changeNickNameController *changeNick = [[changeNickNameController alloc] init];
        changeNick.delegate = self;
        [self.navigationController pushViewController:changeNick animated:YES];
    }else if(indexPath.row == 2){
        changeSexController *changeSex = [[changeSexController alloc] init];
        changeSex.delegate = self;
        [self.navigationController pushViewController:changeSex animated:YES];
    }else if(indexPath.row == 3){
        changeAreaController *changeArea = [[changeAreaController alloc] init];
        [self.navigationController pushViewController:changeArea animated:YES];
    }else if(indexPath.row == 4){
        changeNumController *changeNum = [[changeNumController alloc] init];
        changeNum.delegate = self;
        [self.navigationController pushViewController:changeNum animated:YES];
    }else if(indexPath.row == 5){
        changeEmailController *changeEmail = [[changeEmailController alloc] init];
        changeEmail.delegate = self;
        [self.navigationController pushViewController:changeEmail animated:YES];
    }else if (indexPath.row == 0){
        chooseIconViewController *chooseIcon = [[chooseIconViewController alloc] init];
        chooseIcon.imageView = self.imageView;
        [self.navigationController pushViewController:chooseIcon animated:YES];
    }
}

//.....
- (void)nickNameHadChangeBe:(UITextField *)field{
//    RJUser *user = self.userArray[0];
//    _lastArray = [NSMutableArray arrayWithObjects:field.text,user.sex == sex0 ? @"男" :@"女",user.area,user.username,user.email, nil];
    [self.tableView reloadData];
}

#pragma mark - Action
//返回
- (void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
