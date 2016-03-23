//
//  TWUserInfoController.m
//  问答
//
//  Created by lirenjie on 16/3/21.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "TWUserInfoController.h"
#import "RJDetailCell.h"
#import "RJDetailViewCell.h"
#import "YCSettingItem.h"
#import "YCSettingGroup.h"
#import "specialDetailViewController.h"
//#import "CommentViewController.h"
#import "FansCreditController.h"
#import "CommunicationViewController.h"
#import "textViewController.h"
#import <UIImageView+WebCache.h>
#import "EaseMessageViewController.h"
#import "ChatViewController.h"
#import "RJCredit.h"
#import <ProgressHUD.h>
#import "CommentListController.h"
#import "RJComment.h"
#import "RJUser.h"
@interface TWUserInfoController ()
@property (nonatomic,strong)NSMutableArray *detailArray;
@property (nonatomic,strong)NSMutableArray *middLArray;
@property (nonatomic,strong)RJCredit *credit;
@property (nonatomic,assign)int commentCount;
@property (nonatomic,strong)RJUser *user;

@property (assign, nonatomic) DetailInfoShowType showType;
@end

@implementation TWUserInfoController

- (NSMutableArray *)detailArray{
    if (_detailArray == nil) {
        _detailArray = [[NSMutableArray alloc] init];
    }
    return _detailArray;
}

- (instancetype)init{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithShowType:(DetailInfoShowType)showType{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.showType = showType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:236 / 255.0 green:237 /255.0 blue:239 /255.0 alpha:1];
    self.title = @"详细资料";
    self.tableView.scrollEnabled = NO;
    
    //创建导航栏左边按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"箭头.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self requestData];
    [self requestComment];
    
    [self setupGroup0];
    [self setupGroup1];
    
    [self requestXinyu];
    [self setupBtn];
}

- (void)requestData{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    NSString *urlString = [NSString stringWithFormat:@"%@users/%@",apiBaseURL,self.model.uid];
    [manger GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _user = [RJUser mj_objectWithKeyValues:responseObject];
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)requestXinyu{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //json解析所有格式
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@score/xinyu",apiBaseURL];
    NSDictionary *idparams = @{
                               @"rid" : self.model.uid
                               };
    [manager POST:urlStr parameters:idparams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"%@",responseObject);
        _credit = [RJCredit mj_objectWithKeyValues:responseObject];
        [self.tableView reloadData];
        [ProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [ProgressHUD dismiss];
    }];
}

- (void)requestComment{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //json解析所有格式
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@score/assessment",apiBaseURL];
    NSDictionary *idparams = @{
                               @"rid" : self.model.uid
                               };
    [manager POST:urlStr parameters:idparams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"啊啊啊  %@",responseObject);
        NSArray *commentArray = [RJComment mj_objectArrayWithKeyValuesArray:responseObject];
        self.commentCount = (int)commentArray.count;
        _commentStr = [NSString stringWithFormat:@"%d条评价",self.commentCount];
        NSArray *array2 = [_credit.all componentsSeparatedByString:@","];
        NSString *all1 = [NSString stringWithFormat:@"质量：%.1f%@",([array2[0] doubleValue] * 100),@"%"];
        NSString *all2 = [NSString stringWithFormat:@"态度：%.1f%@",([array2[1] doubleValue] * 100),@"%"];
        NSString *all3 = [NSString stringWithFormat:@"速度：%.1f%@",([array2[2] doubleValue] * 100),@"%"];
        NSString *all = [NSString stringWithFormat:@"%@ %@ %@",all1,all2,all3];
        if (self.user.label != nil) {
            _middLArray = [NSMutableArray arrayWithObjects:all,self.user.label,self.commentStr, nil];
        }else{
            _middLArray = [NSMutableArray arrayWithObjects:all,@"对方还未设置标签",self.commentStr, nil];
        }
        [self .tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}

- (void)setupBtn{
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"消息框"] forState:UIControlStateNormal];
    [sendBtn setTitle:@"发消息" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    sendBtn.frame = CGRectMake(0, 0, self.view.frame.size.width - 20, 30);
    sendBtn.center = self.view.center;
    [sendBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
    
    UIButton *focus = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.showType == DetailInfoShowTypeA) {
        [focus setTitle:@"取消关注" forState:UIControlStateNormal];
        [focus setTitle:@"关注" forState:UIControlStateSelected];
        [focus addTarget:self action:@selector(favoriteActionA:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [focus setTitle:@"关注" forState:UIControlStateNormal];
        [focus setTitle:@"取消关注" forState:UIControlStateSelected];
        [focus addTarget:self action:@selector(favoriteAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    [focus setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    focus.titleLabel.font = [UIFont systemFontOfSize:15];
    focus.layer.borderColor = [UIColor grayColor].CGColor;
    focus.layer.borderWidth = 0.8;
    focus.layer.cornerRadius = 5.0;
    focus.clipsToBounds = YES;
    focus.frame = CGRectMake(sendBtn.left, sendBtn.bottom + 10, self.view.frame.size.width - 20, 30);
    [self.view addSubview:focus];
}


- (void)setupGroup0{
    YCSettingItem *lala = [YCSettingItem itemWithIcon:nil title:nil];
    YCSettingGroup *group = [[YCSettingGroup alloc] init];
    group.items = @[lala];
    [self.detailArray addObject:group];
}

- (void)setupGroup1{
    YCSettingGroup *group = [[YCSettingGroup alloc] init];
    YCSettingItem *credit = [YCSettingItem itemWithIcon:nil title:@"信誉" destVcClass:[FansCreditController class]];
    YCSettingItem *special = [YCSettingItem itemWithIcon:nil title:@"擅长" destVcClass:[specialDetailViewController class]];
    YCSettingItem *comment = [YCSettingItem itemWithIcon:nil title:@"评价" destVcClass:[CommentListController class]];
    group.items = @[credit,special,comment];
    [self.detailArray addObject:group];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _detailArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YCSettingGroup *group = _detailArray[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YCSettingGroup *group = self.detailArray[indexPath.section];
    YCSettingItem *item = group.items[indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selected = NO;
    if (indexPath.section == 0) {
        cell.userInteractionEnabled = NO;
        static NSString *identifier = @"RJDetailCell";
        RJDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RJDetailCell" owner:nil options:nil] lastObject];
        }
        [cell.iconView sd_setImageWithURL:self.user.pic placeholderImage:[UIImage imageNamed:@"Q Q"]];
        cell.nickname.text = self.user.nickname;
        if (self.user.identity.length == 0) {
            cell.tagL.text = @"您还没有身份标签哦";
        }else{
            cell.tagL.text = self.user.identity;
        }
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
        return cell;
    }else{
        static NSString *ID = @"DE";
        RJDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[RJDetailViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        cell.textLabel.text = item.title;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.middL.text = _middLArray[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    YCSettingGroup *group = self.detailArray[indexPath.section];
    YCSettingItem *item = group.items[indexPath.row];
    if (indexPath.section == 0) {
    }else if (item.destVcClass != nil){
        UIViewController *vc = [[item.destVcClass alloc] init];
        if ([vc isKindOfClass:[FansCreditController class]]) {
            FansCreditController *fanvc = [[FansCreditController alloc] initWithNibName:@"FansCreditController" bundle:nil];
            fanvc.credit = self.credit;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:fanvc animated:YES];
        }else if([vc isKindOfClass:[CommentListController class]]){
            CommentListController *comvc = [[CommentListController alloc] init];
            comvc.fan.ID = [self.model.uid intValue];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:comvc animated:YES];
        }else{
            specialDetailViewController *spevc = [[specialDetailViewController alloc] init];
            spevc.fan.label = self.user.label;
            spevc.fan.introduce = self.user.introduce;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:spevc animated:YES];
        }
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

#pragma mark - Action
- (void)sendMessage{
    //    textViewController *textVC = [[textViewController alloc] init];
    //    [self.navigationController pushViewController:textVC animated:YES];
    ChatViewController *message = [[ChatViewController alloc] initWithConversationChatter:[NSString stringWithFormat:@"YCWL%@",self.user.username] conversationType:eConversationTypeChat];
    message.title = self.user.nickname;
    [self.navigationController pushViewController:message animated:YES];
}

- (void)favoriteActionA:(UIButton *)butt
{
    butt.selected = !butt.selected;
    if (butt.isSelected == YES) {
        AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
        //json解析所有格式
        manger.responseSerializer = [AFJSONResponseSerializer
                                     serializerWithReadingOptions:NSJSONReadingAllowFragments];
        NSString *urlString = [NSString stringWithFormat:@"%@fan/cancel",apiBaseURL];
        NSDictionary *idparams = @{
                                   @"rid" : self.model.rid
                                   };
        [manger POST:urlString parameters:idparams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            //            butt.selected = YES;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }else{
        //        [butt setTitle:@"取消关注" forState:UIControlStateSelected];
        
        AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
        //json解析所有格式
        manger.responseSerializer = [AFJSONResponseSerializer
                                     serializerWithReadingOptions:NSJSONReadingAllowFragments];
        NSString *urlString = [NSString stringWithFormat:@"%@fan/focus",apiBaseURL];
        
        NSDictionary *idparams = @{
                                   @"rid" : self.model.rid
                                   };
        [manger POST:urlString parameters:idparams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            //            butt.selected = NO;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }
    
}


- (void)favoriteAction:(UIButton *)butt
{
    butt.selected = !butt.selected;
    if (butt.isSelected == YES) {
        //        [butt setTitle:@"取消关注" forState:UIControlStateSelected];
        
        AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
        //json解析所有格式
        manger.responseSerializer = [AFJSONResponseSerializer
                                     serializerWithReadingOptions:NSJSONReadingAllowFragments];
        NSString *urlString = [NSString stringWithFormat:@"%@fan/focus",apiBaseURL];
        
        NSDictionary *idparams = @{
                                   @"rid" : self.model.rid
                                   };
        [manger POST:urlString parameters:idparams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            //            butt.selected = NO;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
        
    }else{
        AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
        //json解析所有格式
        manger.responseSerializer = [AFJSONResponseSerializer
                                     serializerWithReadingOptions:NSJSONReadingAllowFragments];
        NSString *urlString = [NSString stringWithFormat:@"%@fan/cancel",apiBaseURL];
        NSDictionary *idparams = @{
                                   @"rid" : self.model.rid
                                   };
        [manger POST:urlString parameters:idparams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            //            butt.selected = YES;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }
}

//返回
- (void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
