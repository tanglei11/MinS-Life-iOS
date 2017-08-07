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

typedef void (^AlertviewSendFriendBlock)();
typedef void (^AlertviewSendFriendQuanBlock)();
typedef void (^AlertviewSavePictureBlock)();
@interface AlertView : UIView
@property (nonatomic,strong)AlertviewSendFriendBlock  alertviewSendFriendBlock;
@property (nonatomic,strong)AlertviewSendFriendQuanBlock  alertviewSendFriendQuanBlock;
@property (nonatomic,strong)AlertviewSavePictureBlock  alertviewSavePictureBlock;
@property (nonatomic,weak) UITableView *chooseTableView;

-(id)initWithFrame:(CGRect)frame andAboveView:(UIView *)bgView;
-(void)addAlertView;
-(void)setAlertviewSendFriendBlock:(AlertviewSendFriendBlock)friendBlock;
-(void)setAlertviewSendFriendQuanBlock:(AlertviewSendFriendQuanBlock)friendQuanBlock;
-(void)setAlertviewSavePictureBlock:(AlertviewSavePictureBlock)savePictureBlock;
-(void)disappear;

@end
