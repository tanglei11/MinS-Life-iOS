//
//  ImagePickerChooseView.h
//  MyFamily
//
//  Created by 陆洋 on 15/7/15.
//  Copyright (c) 2015年 maili. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertCell.h"
#import "UIView+NextResponder.h"

#define AlertViewHeight 197

typedef void (^AlertViewSaveBlock)();
@interface AlertView : UIView
@property (nonatomic,strong)AlertViewSaveBlock AlertViewSaveBlock;

-(id)initWithFrame:(CGRect)frame andAboveView:(UIView *)bgView;
-(void)addAlertView;
-(void)setAlertViewBlock:(AlertViewSaveBlock)block;
-(void)disappear;

@end
