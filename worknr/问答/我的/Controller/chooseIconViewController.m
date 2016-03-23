//
//  chooseIconViewController.m
//  问答
//
//  Created by lirenjie on 16/3/10.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "chooseIconViewController.h"
#import "RJUser.h"
#import <UIImageView+WebCache.h>
#import <ProgressHUD.h>
@interface chooseIconViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong,nonatomic) NSMutableArray *userArray;
//@property (strong, nonatomic) UIActionSheet *actionSheet;
@end

@implementation chooseIconViewController

- (void)viewWillDisappear:(BOOL)animated{
    [ProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    //创建导航栏左边按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"箭头.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    _imageView = [[UIImageView alloc] init];
    _imageView.bounds = CGRectMake(0, 0, kScreenWidth, kScreenWidth);
    _imageView.center = CGPointMake(self.view.center.x, self.view.center.y);
    _imageView.layer.cornerRadius = kScreenWidth/2;
    _imageView.clipsToBounds = YES;
    [self.view addSubview:_imageView];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 25, 5);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"点.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(choosePic) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [ProgressHUD show:@"正在加载"];
    [self requestData];

}

- (void)requestData{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    NSString *urlString = [NSString stringWithFormat:@"%@users/%@",apiBaseURL,USER];
    [manger GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //字典转模型
        RJUser *user = [RJUser mj_objectWithKeyValues:responseObject];
        
        [_imageView sd_setImageWithURL:user.pic];
        [ProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [ProgressHUD dismiss];
    }];
}

- (void)choosePic{
    //选择图片
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择打开方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [self presentViewController:alert animated:YES completion:nil];
    
    UIImagePickerController *photo = [[UIImagePickerController alloc] init];
    photo.delegate = self;
    photo.allowsEditing = YES;
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:0 handler:^(UIAlertAction * _Nonnull action) {
        //相机
        photo.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:photo animated:YES completion:^{
            
        }];
    }];
    [alert addAction:action1];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"从相册选择" style:0 handler:^(UIAlertAction * _Nonnull action) {
        //相册
        photo.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:photo animated:YES completion:^{
            
        }];
    }];
    [alert addAction:action2];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action3];

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *iconImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = iconImage;
    //使相片不压缩
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;

    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
//    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    //json解析所有格式
    manger.responseSerializer = [AFJSONResponseSerializer
                                 serializerWithReadingOptions:NSJSONReadingAllowFragments];
    // 设置超时时间
    [manger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manger.requestSerializer.timeoutInterval = 10.f;
    [manger.requestSerializer didChangeValueForKey:@"timeoutInterval"];

    NSString *urlString = [NSString stringWithFormat:@"%@user/pic",apiBaseURL];
//        NSDictionary *params = @{
//                                 @"data" : imageData
//                                 };
    [manger POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //加盖时间戳
        NSDate *datenow = [NSDate date];
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
        
        NSData* imageData = UIImageJPEGRepresentation(iconImage, 0.5);
        NSLog(@"-----数据%@-------",imageData);
        [formData appendPartWithFileData:imageData name:@"data" fileName:[NSString stringWithFormat:@"%@.jpg",timeSp] mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"chenggong  %@",responseObject);
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"shibai   %@",error);
        
    }];
    
}

/*
 *  上传图片/视频（支持多张上传和单张上传）
 *
 *  @param url     上传地址
 *  @param param   除文件外的后台要求参数
 *  @param file    文件数组（文件流or数据流）
 *  @param fileKey 后台要求的文件字段
 *  @param success 成功回调函数
 *  @param failure 失败回调函数

+ (void)post:(NSString *)url parameters:(id)param imageFile:(NSArray*)file fileKey:(NSArray *)fileKey success:(void (^)(id result))success failure:(void (^)(NSError *error))failure
AFHTTPSessionManager  *manager = [AFHTTPSessionManager manager];

manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//请求时间
// 设置超时时间
[manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
manager.requestSerializer.timeoutInterval = 10.f;
[manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];


[manager POST:requestUrl parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    //添加上传图片
    for(int i=0 ; i<file.count ; i++){
        
        //加盖时间戳
        NSDate *datenow = [NSDate date];
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
        //压缩图片
        NSData * imageData = [GetTool resetSizeOfImageData:file[i] maxSize:100];
        
        
        //fileKey image1 image2  image3
        [formData appendPartWithFileData:imageData name:fileKey[i] fileName:[NSString stringWithFormat:@"%@.png",timeSp] mimeType:@"image/jpeg"];
        
    }
    
} progress:^(NSProgress * _Nonnull uploadProgress) {
    
} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {        success([NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]);
    
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
    
    
    failure(error);
}];
 */


//返回
- (void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
