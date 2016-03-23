//
//  WDViewController.m
//  问答
//
//  Created by xwbb on 16/2/17.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "WDViewController.h"
#import "YCSettingItem.h"
#import "YCSettingGroup.h"
#import "RJPersonalCell.h"
#import "PrersonalTableViewController.h"
#import "RuleTableViewController.h"
#import "HelpTableViewController.h"
#import "SettingTableViewController.h"
#import "NiuDouViewController.h"
#import "CreditViewController.h"
#import "FansViewController.h"
#import "AdeptViewController.h"
#import "RJUser.h"
#import "RJCredit.h"
#import <UIImageView+WebCache.h>
@interface WDViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *settingView;
@property (nonatomic,strong)NSMutableArray *dataArray;
//@property (nonatomic,strong)NSMutableArray *userArray;
@property (nonatomic,strong)RJUser *user;
@property (nonatomic,strong)RJCredit *credit;

@end

@implementation WDViewController

//懒加载
- (NSArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [self requestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"我";
    
    [self requestData];
    [self requestCredit];
    
    [self setupgroup4];
    [self setupgroup0];
    [self setupgroup1];
    [self setupgroup3];
    
    NSLog(@"555%@",USER);
    _settingView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _settingView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _settingView.scrollEnabled = NO;
    _settingView.delegate = self;
    _settingView.dataSource = self;
    [self.view addSubview:_settingView];
}

- (void)requestCredit{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    NSString *urlStr = [NSString stringWithFormat:@"%@score/xinyu",apiBaseURL];
    [manager POST:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        _credit = [RJCredit mj_objectWithKeyValues:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];

}

- (void)requestData{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    NSString *urlString = [NSString stringWithFormat:@"%@users/%@",apiBaseURL,USER];
    [manger GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _user = [RJUser mj_objectWithKeyValues:responseObject];
//        //字典转模型
//        self.userArray = responseObject[@"items"];
//        NSLog(@"%@",self.userArray);
//        NSMutableArray *array = [NSMutableArray array];
//        for (NSDictionary *dic in self.userArray) {
//            RJUser *user = [RJUser mj_objectWithKeyValues:dic];
//            NSLog(@"-----%@_____%@",user.username,user.display_name);
//            [array addObject:user];
//        }
//        self.userArray = array;
        [self.settingView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)setupgroup4{
    YCSettingItem *lala = [YCSettingItem itemWithIcon:nil title:nil];
    YCSettingGroup *group4 = [[YCSettingGroup alloc] init];
    group4.items = @[lala];
    [self.dataArray addObject:group4];
    
}

- (void)setupgroup0{
    YCSettingGroup *group0 = [[YCSettingGroup alloc] init];
    YCSettingItem *moneyBall = [YCSettingItem itemWithIcon:nil title:@"牛豆" destVcClass:[NiuDouViewController class]];
    YCSettingItem *credit = [YCSettingItem itemWithIcon:nil title:@"信誉" destVcClass:[CreditViewController class]];
    group0.items = @[moneyBall,credit];
    
    [self.dataArray addObject:group0];
    
}

- (void)setupgroup1{
    YCSettingGroup *group1= [[YCSettingGroup alloc] init];
    YCSettingItem *fans = [YCSettingItem itemWithIcon:nil title:@"粉丝" destVcClass:[FansViewController class]];
    YCSettingItem *special = [YCSettingItem itemWithIcon:nil title:@"擅长" destVcClass:[AdeptViewController class]];
    group1.items = @[fans,special];
    
    [self.dataArray addObject:group1];
}

- (void)setupgroup3{
    YCSettingGroup *group3= [[YCSettingGroup alloc] init];
    YCSettingItem *rules = [YCSettingItem itemWithIcon:nil title:@"规则" destVcClass:[RuleTableViewController class]];
    YCSettingItem *help = [YCSettingItem itemWithIcon:nil title:@"帮助" destVcClass:[HelpTableViewController class]];
    YCSettingItem *setting = [YCSettingItem itemWithIcon:nil title:@"设置" destVcClass:[SettingTableViewController class]];
    group3.items = @[rules,help,setting];
    
    [self.dataArray addObject:group3];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YCSettingGroup *group = self.dataArray[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YCSettingGroup *group = self.dataArray[indexPath.section];
    YCSettingItem *item = group.items[indexPath.row];
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (indexPath.section == 0) {
        static NSString *identifier = @"RJPersonalCell";
        RJPersonalCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RJPersonalCell" owner:nil options:nil] lastObject];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (self.user != nil) {
            cell.userName.text = _user.nickname;
            [cell.userIcon sd_setImageWithURL:_user.pic placeholderImage:[UIImage imageNamed:@"Q Q"]];
            cell.niuCount.text = [NSString stringWithFormat:@"牛豆数：%d",_user.nd];
            if (0 <= _credit.da && _credit.da <= 0.25) {
                cell.zuan1.hidden = NO;
            }else if (0.25 < _credit.da && _credit.da <= 0.5){
                cell.zuan1.hidden = NO;
                cell.zuan2.hidden = NO;
            }else if (0.5 < _credit.da && _credit.da <= 0.75){
                cell.zuan1.hidden = NO;
                cell.zuan2.hidden = NO;
                cell.zuan3.hidden = NO;
            }else{
                cell.zuan1.hidden = NO;
                cell.zuan2.hidden = NO;
                cell.zuan3.hidden = NO;
                cell.zuan4.hidden = NO;
            }
        }
        return cell;
    }else{
        static NSString *ID = @"WD";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        cell.textLabel.text = item.title;
        cell.imageView.image = [UIImage imageNamed:item.icon];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    YCSettingGroup *group = self.dataArray[indexPath.section];
    YCSettingItem *item = group.items[indexPath.row];
    if (indexPath.section == 0) {
        PrersonalTableViewController *presonal = [[PrersonalTableViewController alloc] init];
//        presonal.userArray = self.userArray;
        presonal.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:presonal animated:YES];
    }else if (item.destVcClass != nil){
        UIViewController *vc = [[item.destVcClass alloc] init];
        vc.title = item.title;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat i;
    if (indexPath.section == 0) {
        i = 72;
        return i;
    }else{
        i = 35;
        return i;
    }
    return i;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
@end
