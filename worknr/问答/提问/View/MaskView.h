//
//  MaskView.h
//  问答
//
//  Created by xwbb on 16/2/17.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PopPickerView;
@interface MaskView : UIView

@property (nonatomic , strong) PopPickerView *popPickerV;

@property (nonatomic , strong) NSArray *array1;
@property (nonatomic , strong) NSArray *array2;
@property (nonatomic , strong) NSArray *array3;
@property (nonatomic , strong) NSArray *array4;
@property (nonatomic , strong) NSArray *array5;
@property (nonatomic , strong) NSArray *array;

@property (nonatomic , copy) NSString *choice1;
@property (nonatomic , copy) NSString *choice2;
@property (nonatomic , copy) NSString *choice3;
@property (nonatomic , copy) NSString *choice4;
@property (nonatomic , copy) NSString *choice5;

@end
