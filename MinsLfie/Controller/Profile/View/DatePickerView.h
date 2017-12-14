//
//  DatePickerView.h
//  Picker
//
//  Created by Chris on 16/8/25.
//  Copyright © 2016年 Chris. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DataPickerViewHeight 240

typedef void (^DataPickerViewConfirmBlock)();
@interface DatePickerView : UIView
@property (nonatomic,strong)DataPickerViewConfirmBlock dataPickerViewConfirmBlock;
@property (nonatomic,weak) UIDatePicker *datePicker;

- (instancetype)initWithFrame:(CGRect)frame andAboveView:(UIView *)bgView;
- (void)addDataPickerView;
-(void)setDataPickerViewBlock:(DataPickerViewConfirmBlock)block;
- (void)disappear;

@end
