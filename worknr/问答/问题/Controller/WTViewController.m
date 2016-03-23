//
//  WTViewController.m
//  问答
//
//  Created by xwbb on 16/2/19.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "WTViewController.h"
#import "QDetailViewController.h"

@interface WTViewController ()

@end

@implementation WTViewController

#pragma mark - View Life
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"我的问题";
    _segmentLevelTwo1.selectedSegmentIndex = 0;

//    UILocalNotification
    _segmentLevelOne.tintColor = [UIColor colorWithRed:26.0/255.0 green:193.0/255.0 blue:105.0/255.0 alpha:1];
    NSDictionary *textAttr1 = @{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]};
    NSDictionary *textAttr2 = @{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor grayColor]};
    [_segmentLevelOne setTitleTextAttributes:textAttr1 forState:UIControlStateSelected];
    [_segmentLevelOne setTitleTextAttributes:textAttr2 forState:UIControlStateNormal];
    
    
    _segmentLevelTwo1.tintColor = [UIColor colorWithRed:26.0/255.0 green:193.0/255.0 blue:105.0/255.0 alpha:1];
    NSDictionary *textAttr3 = @{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor whiteColor]};
    NSDictionary *textAttr4 = @{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor grayColor]};
    [_segmentLevelTwo1 setTitleTextAttributes:textAttr3 forState:UIControlStateSelected];
    [_segmentLevelTwo1 setTitleTextAttributes:textAttr4 forState:UIControlStateNormal];
    
    
    _segmentLevelTwo2.tintColor = [UIColor colorWithRed:26.0/255.0 green:193.0/255.0 blue:105.0/255.0 alpha:1];
    NSDictionary *textAttr5 = @{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor whiteColor]};
    NSDictionary *textAttr6 = @{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor grayColor]};
    [_segmentLevelTwo2 setTitleTextAttributes:textAttr5 forState:UIControlStateSelected];
    [_segmentLevelTwo2 setTitleTextAttributes:textAttr6 forState:UIControlStateNormal];
}

#pragma mark - SegmentC Action
- (IBAction)segLevelOneAction:(UISegmentedControl *)sender {
    
    NSInteger index = sender.selectedSegmentIndex;
    switch (index) {
        case 0:
            _segmentLevelTwo1.hidden = NO;
            _segmentLevelTwo2.hidden = YES;
            
            _segmentLevelTwo1.selectedSegmentIndex = 0;
            _adoptTableView.hidden = NO;
            _commentTableView.hidden = YES;
            _complainTableView.hidden = YES;
            _myQuestionTableView.hidden = YES;
            _myAnswerTableView.hidden = YES;
            break;
        case 1:
            _segmentLevelTwo1.hidden = YES;
            _segmentLevelTwo2.hidden = NO;
            
            _segmentLevelTwo2.selectedSegmentIndex = 0;
            _adoptTableView.hidden = YES;
            _commentTableView.hidden = YES;
            _complainTableView.hidden = YES;
            _myQuestionTableView.hidden = NO;
            _myAnswerTableView.hidden = YES;
            break;
        default:
            break;
    }
}

- (IBAction)segLevelTwo1Action:(UISegmentedControl *)sender {
    
    NSInteger index = sender.selectedSegmentIndex;
    switch (index) {
        case 0:
            
            _adoptTableView.hidden = NO;
            _commentTableView.hidden = YES;
            _complainTableView.hidden = YES;
            _myQuestionTableView.hidden = YES;
            _myAnswerTableView.hidden = YES;
            break;
        case 1:
            
            _adoptTableView.hidden = YES;
            _commentTableView.hidden = NO;
            _complainTableView.hidden = YES;
            _myQuestionTableView.hidden = YES;
            _myAnswerTableView.hidden = YES;
            break;
        case 2:
            
            _adoptTableView.hidden = YES;
            _commentTableView.hidden = YES;
            _complainTableView.hidden = NO;
            _myQuestionTableView.hidden = YES;
            _myAnswerTableView.hidden = YES;
            break;
        default:
            break;
    }
}
- (IBAction)segLevelTwo2Action:(UISegmentedControl *)sender {
    
    NSInteger index = sender.selectedSegmentIndex;
    switch (index) {
        case 0:
            
            _adoptTableView.hidden = YES;
            _commentTableView.hidden = YES;
            _complainTableView.hidden = YES;
            _myQuestionTableView.hidden = NO;
            _myAnswerTableView.hidden = YES;
            break;
        case 1:
            
            _adoptTableView.hidden = YES;
            _commentTableView.hidden = YES;
            _complainTableView.hidden = YES;
            _myQuestionTableView.hidden = YES;
            _myAnswerTableView.hidden = NO;
            break;
        default:
            break;
    }
}

@end
