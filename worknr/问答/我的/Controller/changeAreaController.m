//
//  changeAreaController.m
//  问答
//
//  Created by lirenjie on 16/3/14.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "changeAreaController.h"
#import <CoreLocation/CoreLocation.h>
#import <ProgressHUD.h>
@interface changeAreaController () <CLLocationManagerDelegate>
@property (strong,nonatomic)CLLocationManager *locationmanager;
@property (copy,nonatomic)NSString *city;
@end

@implementation changeAreaController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地区";
    self.view.backgroundColor = [UIColor colorWithRed:236 / 255.0 green:237 /255.0 blue:239 /255.0 alpha:1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    //创建导航栏左边按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"箭头.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self startlocation];
}

- (void)startlocation{
    _locationmanager = [[CLLocationManager alloc] init];
    _locationmanager.delegate = self;
    _locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationmanager.distanceFilter = 10;
    [_locationmanager requestAlwaysAuthorization];//这句话ios8以上版本使用。
    [_locationmanager requestWhenInUseAuthorization];
    [_locationmanager startUpdatingLocation];
    [ProgressHUD show:@"正在拼命定位"];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *currentLoc = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLoc completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0)
        {
            CLPlacemark *placemark = [array objectAtIndex:0];
            //NSLog(@%@,placemark.name);//具体位置
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            NSLog(@"定位完成:%@",city);
            _city = city;
            [self.tableView reloadData];
            //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
            [manager stopUpdatingLocation];
            
            [ProgressHUD dismiss];
            
            //上传位置
            AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
            //json解析所有格式
            manger.responseSerializer = [AFJSONResponseSerializer
                                         serializerWithReadingOptions:NSJSONReadingAllowFragments];
            NSString *urlString = [NSString stringWithFormat:@"%@users/%@",apiBaseURL,USER];
            NSDictionary *params = @{
                                     @"area" : city
                                     };
            [manger PATCH:urlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"%@",responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
            }];
            
        }else if (error == nil && [array count] == 0){
            [ProgressHUD dismiss];

        }else if (error != nil){
            [ProgressHUD dismiss];

        }
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *area = @"area";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:area];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:area];
    }
    cell.textLabel.text = _city;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *head = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 50, 40)];
    head.font = [UIFont boldSystemFontOfSize:16];
    head.text = @"定位到的位置";
    head.textColor = [UIColor lightGrayColor];
//    self.tableView.tableHeaderView = head;
    return head;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

//返回
- (void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
