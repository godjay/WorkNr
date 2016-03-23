//
//  specialDetailViewController.m
//  问答
//
//  Created by lirenjie on 16/2/21.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "specialDetailViewController.h"
#import "DWTagList.h"
@interface specialDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *idenview;
@property (strong,nonatomic)DWTagList *tagList;
@property (weak, nonatomic) IBOutlet UITextView *introTextView;

@end

@implementation specialDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建导航栏左边按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"箭头.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    _idenview.backgroundColor = [UIColor clearColor];
    _tagList = [[DWTagList alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, _idenview.bounds.size.height)];
    
    NSRange range = [self.fan.label rangeOfString:@","];
    if (range.length != 0){
        NSArray *tagss = [self.fan.label componentsSeparatedByString:@","];
        [_tagList setTags:[NSMutableArray arrayWithObjects:tagss[0],tagss[1], nil]];
        if (tagss.count >= 10){
            [_tagList setTags:[NSMutableArray arrayWithObjects:tagss[0],tagss[1],tagss[2],tagss[3],tagss[4],tagss[5],tagss[6],tagss[7],tagss[8],tagss[9], nil]];
        }else if (tagss.count >= 9){
            [_tagList setTags:[NSMutableArray arrayWithObjects:tagss[0],tagss[1],tagss[2],tagss[3],tagss[4],tagss[5],tagss[6],tagss[7],tagss[8], nil]];
        }else if (tagss.count >= 8){
            [_tagList setTags:[NSMutableArray arrayWithObjects:tagss[0],tagss[1],tagss[2],tagss[3],tagss[4],tagss[5],tagss[6],tagss[7], nil]];
        }else if (tagss.count >= 7){
            [_tagList setTags:[NSMutableArray arrayWithObjects:tagss[0],tagss[1],tagss[2],tagss[3],tagss[4],tagss[5],tagss[6], nil]];
        }else
            if (tagss.count >= 6){
            [_tagList setTags:[NSMutableArray arrayWithObjects:tagss[0],tagss[1],tagss[2],tagss[3],tagss[4],tagss[5], nil]];
        }else if (tagss.count >= 5){
            [_tagList setTags:[NSMutableArray arrayWithObjects:tagss[0],tagss[1],tagss[2],tagss[3],tagss[4], nil]];
        }else if (tagss.count >= 4){
            [_tagList setTags:[NSMutableArray arrayWithObjects:tagss[0],tagss[1],tagss[2],tagss[3], nil]];
        }else if (tagss.count >= 3) {
            [_tagList setTags:[NSMutableArray arrayWithObjects:tagss[0],tagss[1],tagss[2], nil]];
        }
    }else if(self.fan.label.length == 0){
        [_tagList setTags:[NSMutableArray arrayWithObjects:@"对方暂无标签", nil]];
    }else if(self.fan.label.length > 0 && range.length == 0){
        NSString *str = self.fan.label;
        [_tagList setTags:[NSMutableArray arrayWithObjects:str, nil]];
    }
    [self.idenview addSubview:_tagList];
    
    _introTextView.layer.borderWidth = 1.0;
    _introTextView.layer.borderColor = [UIColor grayColor].CGColor;
    _introTextView.text = self.fan.introduce;
    
}

//返回
- (void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
