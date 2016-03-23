//
//  PopPickerView.h
//  问答
//
//  Created by xwbb on 16/2/25.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopPickerView : UIPickerView <UIPickerViewDelegate,UIPickerViewDataSource>

- (instancetype)initWithFrame:(CGRect)frame withDataSource:(NSArray *)array withTagNum:(NSInteger)number;

@property (nonatomic , strong) NSArray *dataArray;
@property (nonatomic , assign) NSInteger tagNum;

@end
