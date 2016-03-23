//
//  PopPickerView.m
//  问答
//
//  Created by xwbb on 16/2/25.
//  Copyright © 2016年 Mr.zY. All rights reserved.
//

#import "PopPickerView.h"

@implementation PopPickerView

- (instancetype)initWithFrame:(CGRect)frame withDataSource:(NSArray *)array withTagNum:(NSInteger)number
{
    if (self = [super initWithFrame:frame]) {
        
        self.dataSource = self;
        self.delegate = self;
        _dataArray = array;
        _tagNum = number;
    }
    return self;
}

#pragma mark - UIPickView DataSoucre
//返回列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//返回行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _dataArray.count;
}

#pragma mark - UIPickView Delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%@",_dataArray[row]];
}

///设置row的高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

//选择某个row时,调用此方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSNumber *number = [NSNumber numberWithInteger:[pickerView selectedRowInComponent:component]];
    NSDictionary *dic = @{@"title":number,@"tagNum":[NSNumber numberWithInteger:_tagNum]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Send_Value" object:self userInfo:dic];
    
    [self removeFromSuperview];
}


@end
