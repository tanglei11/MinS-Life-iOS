//
//  DatePickerView.m
//  Picker
//
//  Created by Chris on 16/8/25.
//  Copyright © 2016年 Chris. All rights reserved.
//

#import "DatePickerView.h"
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height

@interface DatePickerView ()

@property (nonatomic,weak)UIView *tapView;

@end

@implementation DatePickerView

- (instancetype)initWithFrame:(CGRect)frame andAboveView:(UIView *)bgView
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化背景
        UIView *tapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,Screen_Width, Screen_Height)];
        tapView.backgroundColor = [UIColor blackColor];
        tapView.alpha = 0.6;
        tapView.userInteractionEnabled = YES;
        [bgView addSubview:tapView];
        self.tapView = tapView;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disappear)];
        [self.tapView addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)addDataPickerView
{
    //dataPicker
    UIDatePicker *datePicker = [ [ UIDatePicker alloc] initWithFrame:CGRectMake(0,0,Screen_Width,196)];
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [self addSubview:datePicker];
    self.datePicker = datePicker;
    
    //尾
    UIButton *confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(datePicker.frame), Screen_Width, 44)];
    confirmBtn.backgroundColor = [UIColor whiteColor];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];
    
    UIView *secondLineView = [[UIView alloc]initWithFrame:CGRectMake(24, 0, Screen_Width - 2 * 24, LINE_HEIGHT)];
    secondLineView.backgroundColor = [UIColor colorFromHex:WHITE_GREY];
    [confirmBtn addSubview:secondLineView];
}

- (void)setDataPickerViewBlock:(DataPickerViewConfirmBlock)block
{
    self.dataPickerViewConfirmBlock = block;
}

- (void)confirmClick
{
    [self disappear];
    self.dataPickerViewConfirmBlock();
}

- (void)disappear
{
    [self.tapView removeFromSuperview];
    self.tapView = nil;
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = CGRectMake(0, Screen_Height, Screen_Width, DataPickerViewHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
