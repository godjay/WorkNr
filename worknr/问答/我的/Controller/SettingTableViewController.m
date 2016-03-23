//
//  SettingTableViewController.m
//  问答
//
//  Created by lirenjie on 16/2/20.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "SettingTableViewController.h"
#import "YCSettingGroup.h"
#import "YCSettingItem.h"
#import "ChangePassViewController.h"
#import "MessageNotViewController.h"
#import "AutoCommentViewController.h"
#import "AboutViewController.h"
#import "ViewController.h"
@interface SettingTableViewController ()
@property (nonatomic,strong)UITableView *settingView;
@property (nonatomic,strong)NSMutableArray *setArray;
@end

@implementation SettingTableViewController

- (NSMutableArray *)setArray{
    if (_setArray == nil) {
        _setArray = [[NSMutableArray alloc] init];
    }
    return _setArray;
}

- (instancetype)init{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:236 / 255.0 green:237 /255.0 blue:239 /255.0 alpha:1];
    //创建导航栏左边按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"箭头.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;

    self.tableView.scrollEnabled = NO;
    
    [self setupGroup0];
    [self setupGroup1];
    
    UIButton *outBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [outBtn setBackgroundImage:[UIImage imageNamed:@"消息框"] forState:UIControlStateNormal];
    [outBtn setTitle:@"退出账户" forState:UIControlStateNormal];
    outBtn.frame = CGRectMake(0, 0, self.view.frame.size.width - 20, 30);
    outBtn.center = self.view.center;
    [outBtn addTarget:self action:@selector(outLogin) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:outBtn];
    
}
- (void)outLogin{
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSString *appDomain = [[NSBundle mainBundle]bundleIdentifier];
    //    [defaults removePersistentDomainForName:appDomain];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    NSString *urlStr = [NSString stringWithFormat:@"%@user/logout",apiBaseURL];
    [manager POST:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
            NSLog(@"退出成功");
        } onQueue:nil];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"userid"];
        [defaults removeObjectForKey:@"phone"];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewController *viewC = (ViewController *)[storyboard instantiateInitialViewController];
        [self presentViewController:viewC animated:NO completion:nil];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}

- (void)setupGroup0{
    YCSettingGroup *group0 = [[YCSettingGroup alloc] init];
    YCSettingItem *changepass = [YCSettingItem itemWithIcon:nil title:@"修改密码" destVcClass:[ChangePassViewController class]];
    YCSettingItem *massageNot = [YCSettingItem itemWithIcon:nil title:@"消息通知" destVcClass:[MessageNotViewController class]];
    YCSettingItem *autoComment = [YCSettingItem itemWithIcon:nil title:@"自动评价" destVcClass:[AutoCommentViewController class]];
    
    group0.items = @[changepass,massageNot,autoComment];
    [self.setArray addObject:group0];
}

- (void)setupGroup1{
    YCSettingGroup *group1 = [[YCSettingGroup alloc] init];
    YCSettingItem *contactUs = [YCSettingItem itemWithIcon:nil title:@"联系客服" destVcClass:nil];
    YCSettingItem *about = [YCSettingItem itemWithIcon:nil title:@"关于" destVcClass:[AboutViewController class]];
    
    group1.items = @[contactUs,about];
    [self.setArray addObject:group1];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.setArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YCSettingGroup *group = self.setArray[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"HELP";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    YCSettingGroup *group = self.setArray[indexPath.section];
    YCSettingItem *item = group.items[indexPath.row];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.text = item.title;
    cell.imageView.image = [UIImage imageNamed:item.icon];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    YCSettingGroup *group = self.setArray[indexPath.section];
    YCSettingItem *item = group.items[indexPath.row];
    if (indexPath.section == 1 && indexPath.row == 0) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"您确定要拨打18037759803?" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertC animated:YES completion:nil];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"确定");
            NSString *str = [NSString stringWithFormat:@"tel:%@",@"18037759803"];
            
            UIWebView *callWebView = [[UIWebView alloc]init];
            
            [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebView];
        }];
        [alertC addAction:action1];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertC addAction:action2];
    }else if (item.destVcClass != nil){
        UIViewController *vc = [[item.destVcClass alloc] init];
        vc.title = item.title;
        [self.navigationController pushViewController:vc animated:YES];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

#pragma mark - Action
//返回
- (void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
